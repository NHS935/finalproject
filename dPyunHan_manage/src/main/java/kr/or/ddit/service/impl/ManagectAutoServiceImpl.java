package kr.or.ddit.service.impl;

import kr.or.ddit.mapper.*;
import kr.or.ddit.service.ManagectAutoService;
import kr.or.ddit.util.BillingUtil;
import kr.or.ddit.vo.HshldVO;
import kr.or.ddit.vo.ManagectIemVO;
import kr.or.ddit.vo.MtinspVO;
import kr.or.ddit.vo.UntpcVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Transactional
@Service
@RequiredArgsConstructor
public class ManagectAutoServiceImpl implements ManagectAutoService {
    private final HshldMapper hshldMapper;
    private final UntpcMapper untpcMapper;
    private final MtinspMapper mtinspMapper;
    private final ManagectIemMapper managectIemMapper;
    private final LevyMapper levyMapper;
    private  final ManagectLevyDetailMapper managectLevyDetailMapper;


    private final BillingUtil billingUtil;           // 계산 담당 Util


    /**
     * 월별 청구 배치 작업을 생성하고 실행합니다.
     * (스케줄러 또는 수동 실행 시 이 메서드를 호출)
     * * @param billingMonth "2509" (yyMM) 또는 "202509" (yyyyMM) - Util과 형식을 맞춰야 함
     */
    @Override
    @Transactional // (이 메서드 전체를 하나의 트랜잭션으로 묶음)
    public void createMonthlyBills(String billingMonth) {

        // --- 1. 재료 준비: DB 조회 ---
        // (1-1) 청구 대상 세대 조회
        List<HshldVO> residentList = hshldMapper.findActiveResidents();

        int residentCount = residentList.size();
        if (residentCount == 0) {
            System.out.println("청구 대상 세대가 없습니다.");
            return; // 처리할 세대 없음
        }

        // (1-2) 해당 월의 개별 검침 내역 (e.g., 580건)
        List<MtinspVO> mtinspList = mtinspMapper.findMetersByMonth(billingMonth);

        // (1-3) 개별 요금 단가표 (e.g., "E", "W", "G")
        List<UntpcVO> untpcList = untpcMapper.getActiveRates();

        // (1-4) 해당 월의 공용 관리비 (e.g., 10건)
        List<ManagectIemVO> managectIemList = managectIemMapper.findFeesByMonth(billingMonth);


        // --- 3. PK 선점 (2종류의 PK를 필요한 개수만큼 미리 확보) ---

        // (3-1) 부모(청구) PK 개수 계산 및 확보 (e.g., 200개)
        int levyPKsNeeded = residentCount;
        // (BillMapper에 LEVY_RQEST_SN_SEQ를 사용하는 쿼리가 구현되어 있어야 함)
        List<Long> levyPKs = levyMapper.getNextLevyPKs(levyPKsNeeded);

        // (3-2) 자식(상세) PK 개수 계산 및 확보
        int managectIemCount = managectIemList.size();       // 16
        int individualMeterCount = 3;     // 3
        // (200세대 * 16항목+ 3항목) = 3800개
        int detailPKsNeeded = (residentCount * (managectIemCount+ individualMeterCount)) ;

        List<Long> managectLevyDetailPKs;
        if (detailPKsNeeded > 0) {
            // (BillMapper에 LEVY_DETAIL_PK_SEQ를 사용하는 쿼리가 구현되어 있어야 함)
            managectLevyDetailPKs = managectLevyDetailMapper.getNextManagectLevyDetailPKs(detailPKsNeeded);
        } else {
            managectLevyDetailPKs = new java.util.ArrayList<>(); // 상세내역 0건
        }


        // --- 4. 계산 위임 (복잡한 로직은 Util이 전담) ---
        BillingUtil.BillingResult result = billingUtil.calculate(
                residentList,
                mtinspList,
                untpcList,
                managectIemList,
                levyPKs,     // 부모 PK List (200개)
                managectLevyDetailPKs,   // 자식 PK List (2580개)
                billingMonth
        );


        // --- 5. Batch Insert (최종 저장) ---

        // (5-1) 부모(청구) 테이블 삽입
        if (result.billsToInsert != null && !result.billsToInsert.isEmpty()) {
            levyMapper.insertBillsBatch(result.billsToInsert);
        }

        // (5-2) 자식(상세) 테이블 삽입
        if (result.detailsToInsert != null && !result.detailsToInsert.isEmpty()) {
            managectLevyDetailMapper.insertDetailsBatch(result.detailsToInsert);
        }

        // (@Transactional이 메서드 종료 시 자동으로 Commit)
    }

}
