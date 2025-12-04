package kr.or.ddit.util;

// (VO 클래스들은 실제 경로에 맞게 import)

import kr.or.ddit.vo.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.sql.Date;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Component
public class BillingUtil {

    /**
     * 계산 결과를 담아 반환할 내부 DTO (Data Transfer Object)
     * Service가 이 객체를 받아 Batch Insert에 사용합니다.
     */
    @RequiredArgsConstructor
    public static class BillingResult {
        public final List<LevyVO> billsToInsert;
        public final List<ManagectLevyDetailVO> detailsToInsert;
    }

    /**
     * 모든 원본 데이터를 받아, 계산된 청구/상세 List를 반환합니다.
     * (이 메서드는 Service로부터 호출됩니다)
     */
    public BillingResult calculate(
            List<HshldVO> residentList,
            List<MtinspVO> meterList,
            List<UntpcVO> rateList,
            List<ManagectIemVO> commonFeeList,
            List<Long> billPKs,     // (수정) 1. 청구(부모) PK 리스트
            List<Long> detailPKs,   // (수정) 2. 상세(자식) PK 리스트
            String rqestYm) {

        int residentCount = residentList.size();

        // 1. (가정) billingMonth가 "2509" (YYMM) 형식이라고 가정합니다.
        //    만약 "202509" (YYYYMM) 형식이면 "yyMM" -> "yyyyMM"으로 변경
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMM");
        YearMonth ym = YearMonth.parse(rqestYm, formatter);

        // 2. rqestDt: 다음 달 1일 (e.g., 25년 9월 정산 -> 10월 1일)
        LocalDate firstDayOfNextMonth = ym.atDay(1).plusMonths(1);
        Date rqestDt = Date.valueOf(firstDayOfNextMonth); // (java.sql.Date로 변환)

        // 3. payTmlmt: rqestDt + 15일 (e.g., 10월 1일 + 15일 = 10월 16일)
        LocalDate paymentDueDate = firstDayOfNextMonth.plusDays(15);
        Date payTmlmt = Date.valueOf(paymentDueDate); // (java.sql.Date로 변환)

        // --- 2. 재료 가공: List를 Map으로 변환 (메모리 작업) ---

        // (2-1) 검침 맵: Map<세대ID, Map<항목코드, 검침VO>>
        Map<String, Map<String, MtinspVO>> meterMap = meterList.stream()
                .collect(Collectors.groupingBy(
                        MtinspVO::getHshldId, // 세대ID로 1차 그룹핑
                        Collectors.toMap(
                                MtinspVO::getIemNm, // "E", "W", "G" 등 항목 코드로 2차 그룹핑
                                vo -> vo              // 값은 VO 객체 전체
                        )
                ));

        // (2-2) 요금표 맵: Map<항목코드, 요금(Integer)>
        Map<String, Integer> rateMap = rateList.stream()
                .collect(Collectors.toMap(
                        UntpcVO::getIemNm, // Key: "E", "W", "G"
                        UntpcVO::getRqestUntpc  // Value: 요금 (Integer)
                ));

        // (2-3) 공용 관리비 맵: Map<항목명, 1세대당 금액(Integer)>
        // (!! 여기서 미리 나눗셈 계산 완료 !!)
        // (!! ManagectIemVO의 항목명(IemNm)이 고유(Unique)하다고 가정 !!)
        Map<String, Integer> commonFeeMap = commonFeeList.stream()
                .collect(Collectors.toMap(
                        ManagectIemVO::getIemNm, // Key: "공동전기료", "청소비" (한글 항목명)
                        vo -> vo.getManagectAmount() / residentCount // Value: 1세대당 부담금
                ));


        // --- 4. 메인 루프: List 조립 (메모리 작업) ---

        List<LevyVO> billsToInsert = new ArrayList<>();
        List<ManagectLevyDetailVO> detailsToInsert = new ArrayList<>();

        //  상세 PK 할당을 위한 인덱스 카운터
        int detailPkIndex = 0;

        // (1) 바깥 루프 (N = 200세대)
        for (int i = 0; i < residentCount; i++) {

            HshldVO resident = residentList.get(i);
            String hshldId = resident.getHshldId(); //  세대ID

            // 미리 받아온 청구(부모) PK 순서대로 할당
            Long rqestSn = billPKs.get(i);

            int managectTotAmount = 0; //

            // (2) 개별 사용 요금 계산 (검침 맵, 요금 맵 조회)
            Map<String, MtinspVO> residentMeters = meterMap.get(hshldId);

            if (residentMeters != null) {
                // (rateMap의 모든 항목("E", "W" 등)을 기준으로 반복)
                for (String iemNm : rateMap.keySet()) {

                    if (residentMeters.containsKey(iemNm)) {

                        // 상세(자식) PK 순차 할당
                        Long managectLevyDetailSn = detailPKs.get(detailPkIndex++);

                        int rqestStdr = residentMeters.get(iemNm).getUsgqty();
                        int rqestUntpc = rateMap.get(iemNm);
                        int rqestAmount = rqestStdr * rqestUntpc/30;

                        managectTotAmount += rqestAmount;

                        // (수정) 상세 내역 추가: (상세PK, 청구FK, 항목코드, 사용량, 요율, 비용)
                        // (!! ManagectLevyDetailVO의 생성자 순서가 이와 같다고 가정합니다 !!)
                        detailsToInsert.add(new ManagectLevyDetailVO(managectLevyDetailSn, iemNm, rqestAmount, rqestStdr, rqestUntpc, rqestSn));
                    }
                }
            }

            // (3) 공용 관리비 계산 (공용비 맵 조회) - 안쪽 루프 (M = 10개 항목)
            for (Map.Entry<String, Integer> entry : commonFeeMap.entrySet()) {

                // (수정) 상세(자식) PK 순차 할당
                Long managectLevyDetailSn = detailPKs.get(detailPkIndex++);

                String iemNm = entry.getKey();     // "공동전기료" (한글 항목명)
                int rqestAmount = entry.getValue(); // 5000 (미리 계산된 값)

                managectTotAmount += rqestAmount;
                int rqestStdr=residentCount;
                int rqestUntpc=rqestAmount*residentCount;

                // (수정) 상세 내역 추가: (상세PK, 청구FK, 항목명, 0, 0, 비용)
                // (!! 주의: "E"같은 코드가 아닌 "공동전기료"같은 한글 항목명이 저장됨 !!)
                detailsToInsert.add(new ManagectLevyDetailVO(managectLevyDetailSn, iemNm, rqestAmount, rqestStdr, rqestUntpc, rqestSn));
            }
            int paySttus=0;
            String paySn=null;
            // (4) 최종 청구(부모) List에 추가
            // (수정) LevyVO 생성자가 (Long, String, String, int)라고 가정
            billsToInsert.add(new LevyVO(paySttus, rqestSn, payTmlmt, rqestYm, rqestDt,managectTotAmount,hshldId,paySn));
        }


        // --- 5. 결과 반환 ---
        return new BillingResult(billsToInsert, detailsToInsert);
    }
}