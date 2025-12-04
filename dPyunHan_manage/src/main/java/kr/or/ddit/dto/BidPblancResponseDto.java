package kr.or.ddit.dto;

import kr.or.ddit.vo.BidPblancVO;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
public class BidPblancResponseDto {

    // 1. 기본 식별자 (React Key용)
    private int bidPblancSn;
    private int rnum;

    // 2. 화면 표시용 데이터 (Display Fields)
    private String bidNo;        // 공고번호 (계산된 문자열)
    private String bidTitle;     // 공고명 (bidSj)
    private String bidMethod;    // 낙찰방법 (scsbMth -> 텍스트)
    private String bidContent;   // 공고내용
    private String bidStatus;    // 입찰상태 (bidSttus -> 텍스트)
    private String aptName;

    // 3. 날짜 관련 (String으로 변환해서 React가 바로 찍게 함)
    private String pblancDate;   // 공고일 (yyyy-MM-dd)
    private String bidCloseDate; // 마감일 (yyyy-MM-dd HH:mm)
    private String spotDate;     // 현장설명일시

    // 4. 여부 체크 및 서류 (0/1 -> 텍스트)
    private String creditYn;       // 신용평가제출여부
    private String proofYn;        // 실적증명제출여부
    private String requiredDocs;   // 필수제출서류 모음
    private String spotYn;         // 현장설명회 여부
    private String spotPlace;      // 현장설명회 장소

    private int bidDepositRate;    // 보증금율
    private int bidderCount;       // 참여자 수

    // (이전 대화 맥락) 어느 서버(테이블)에서 왔는지 표시
    private String serverName;

    // ★ 핵심: VO를 받아서 DTO로 변환하는 정적 메서드 (Factory Method)
    public static BidPblancResponseDto from(BidPblancVO vo) {
        return from(vo, "Main_Server"); // 기본값
    }

    public static BidPblancResponseDto from(BidPblancVO vo, String serverName) {
        BidPblancResponseDto dto = new BidPblancResponseDto();

        dto.setBidPblancSn(vo.getBidPblancSn());
        dto.setRnum(vo.getRnum());
        dto.setBidTitle(vo.getBidSj());
        dto.setBidContent(vo.getBidCn());
        dto.setBidDepositRate(vo.getBidGtnRt());
        dto.setSpotPlace(vo.getSptdcPlace());
        dto.setServerName(serverName);

        // [로직 1] 공고번호 계산 (VO의 getBidPblancSnAsStr 로직 이식)
        if (vo.getPblancDt() != null && vo.getBidClosDt() != null) {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
            String pblancDtStr = sdf.format(vo.getPblancDt());
            long diffMillis = vo.getBidClosDt().atZone(ZoneId.systemDefault()).toInstant().toEpochMilli() - vo.getPblancDt().getTime();
            long diffDays = diffMillis / (1000 * 60 * 60 * 24);
            dto.setBidNo(pblancDtStr + String.format("%02d", diffDays) + vo.getBidPblancSn());
        }

        // [로직 2] 낙찰방법 변환 (Switch -> String)
        switch (vo.getScsbMth()) {
            case 2: dto.setBidMethod("최고낙찰"); break;
            case 1: dto.setBidMethod("최저낙찰"); break;
            default: dto.setBidMethod("적격심사"); break;
        }

        // [로직 3] 상태 변환
        switch (vo.getBidSttus()) {
            case 2: dto.setBidStatus("선정 완료"); break;
            case 1: dto.setBidStatus("재공고"); break;
            default: dto.setBidStatus("신규공고"); break;
        }

        // [로직 4] 날짜 포맷팅 (React가 편하도록 String으로)
        DateTimeFormatter ymd = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        DateTimeFormatter ymdhm = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

        if (vo.getPblancDt() != null) {
            dto.setPblancDate(new java.text.SimpleDateFormat("yyyy-MM-dd").format(vo.getPblancDt()));
        }
        if (vo.getBidClosDt() != null) {
            dto.setBidCloseDate(vo.getBidClosDt().format(ymdhm));
        }
        if (vo.getSptdcDt() != null) {
            dto.setSpotDate(vo.getSptdcDt().format(ymdhm));
        }

        // [로직 5] 필수서류 목록
        List<String> reqs = new ArrayList<>();
        if (vo.getCdltPresentnAt() == 1) reqs.add("신용평가등급확인서");
        if (vo.getAcmsltproofPresentnAt() == 1) reqs.add("관리실적증명서");
        dto.setRequiredDocs(reqs.isEmpty() ? "해당 없음" : String.join(", ", reqs));

        // [로직 6] 기타 여부 텍스트
        dto.setCreditYn(vo.getCdltPresentnAt() == 1 ? "제출" : "해당없음");
        dto.setProofYn(vo.getAcmsltproofPresentnAt() == 1 ? "제출" : "해당없음");
        dto.setSpotYn(vo.getSptdcAt() == 1 ? "필수" : "없음");

        // [로직 7] 참여자 수
        dto.setBidderCount(vo.getCntBdderVO());

        return dto;
    }
}
