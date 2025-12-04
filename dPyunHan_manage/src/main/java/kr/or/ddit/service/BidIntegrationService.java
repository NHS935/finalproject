package kr.or.ddit.service;

import kr.or.ddit.dto.BidPblancResponseDto;
import kr.or.ddit.entity.*;
import kr.or.ddit.repository.BidPblancRepository;
import kr.or.ddit.repository.BidSeoulRepository;
import kr.or.ddit.repository.BidGyeonggiRepository;
import kr.or.ddit.repository.BidGyeongbukRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class BidIntegrationService {

    // 3개 지역 Repository 주입
    private final BidSeoulRepository seoulRepo;
    private final BidGyeonggiRepository gyeonggiRepo;
    private final BidGyeongbukRepository gyeongbukRepo;

    private final BidPblancRepository realRepo;
    /**
     * 서울, 경기, 경북 서버의 데이터를 모두 조회하여 통합 리스트 반환
     */
    public List<BidPblancResponseDto> getAllBids() {
        List<BidPblancResponseDto> integratedList = new ArrayList<>();


        // 1. [진짜] BID_PBLANC 데이터 조회 (메인 서버)
        List<BidPblanc> realList = realRepo.findAll();
        for (BidPblanc entity : realList) {
            // 진짜 데이터 변환 메서드 호출
            integratedList.add(convertRealToDto(entity));
        }

        // 1. 서울 서버 조회 (ServerName: 서울본사)
        List<BidSeoul> seoulList = seoulRepo.findAll();
        for (BidSeoul entity : seoulList) {
            integratedList.add(convertToDto(entity, "서울본사_Server"));
        }

        // 2. 경기 서버 조회 (ServerName: 경기지사)
        List<BidGyeonggi> gyeonggiList = gyeonggiRepo.findAll();
        for (BidGyeonggi entity : gyeonggiList) {
            integratedList.add(convertToDto(entity, "경기지사_Server"));
        }

        // 3. 경북 서버 조회 (ServerName: 경북지사)
        List<BidGyeongbuk> gyeongbukList = gyeongbukRepo.findAll();
        for (BidGyeongbuk entity : gyeongbukList) {
            integratedList.add(convertToDto(entity, "경북지사_Server"));
        }

        // 4. 최신순 정렬 (공고일자 기준 내림차순)
        integratedList.sort(Comparator.comparing(BidPblancResponseDto::getPblancDate).reversed());

        log.info("통합 조회 완료 - 서울:{}건, 경기:{}건, 경북:{}건 / 총 {}건",
                seoulList.size(), gyeonggiList.size(), gyeongbukList.size(), integratedList.size());

        return integratedList;
    }

    private BidPblancResponseDto convertRealToDto(BidPblanc entity) {
        BidPblancResponseDto dto = new BidPblancResponseDto();

        dto.setBidPblancSn(Math.toIntExact(entity.getBidPblancSn()));
        dto.setBidTitle(entity.getBidSj());
        dto.setBidContent(entity.getBidCn());
        dto.setBidDepositRate(entity.getBidGtnRt());

        // ★ 중요: 진짜 데이터는 서버명을 다르게 주거나 강조
        dto.setServerName("Dream_System");

        // ★ 단지명: 테이블에 없으면 고정값 사용 (또는 조인 필요)
        dto.setAptName("디편한 아파트");

        // 날짜 변환
        DateTimeFormatter ymd = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        if (entity.getPblancDt() != null) {
            dto.setPblancDate(ymd.format(entity.getPblancDt()));
            String dateStr = entity.getPblancDt().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
            dto.setBidNo(dateStr + "-" + entity.getBidPblancSn());
        }
        if (entity.getBidClosDt() != null) {
            dto.setBidCloseDate(ymd.format(entity.getBidClosDt()));
        }

        // 상태/방법 코드 변환 (메서드 재사용)
        dto.setBidMethod(getBidMethodName(entity.getScsbMth()));

        // 마감 체크 로직
        LocalDateTime now = LocalDateTime.now();
        if (entity.getBidClosDt() != null && entity.getBidClosDt().isBefore(now)) {
            dto.setBidStatus("마감");
        } else {
            dto.setBidStatus(getBidStatusName(entity.getBidSttus()));
        }

        // 기타 기본값
        dto.setRequiredDocs("관련 서류 일체");
        dto.setSpotYn(entity.getSptdcAt() == 1 ? "필수" : "없음");
        dto.setSpotPlace(entity.getSptdcPlace());

        return dto;
    }
    // Entity -> DTO 변환 메서드
    private BidPblancResponseDto convertToDto(BaseBid entity, String serverName) {
        BidPblancResponseDto dto = new BidPblancResponseDto();

        dto.setBidPblancSn(Math.toIntExact(entity.getBidPblancSn()));
        dto.setBidTitle(entity.getBidSj());
        dto.setAptName(entity.getAptName());
        dto.setBidContent(entity.getBidCn());
        dto.setBidDepositRate(entity.getBidGtnRt());
        dto.setServerName(serverName); // ★ 서버 위치 표시

        // 날짜 변환
        DateTimeFormatter ymd = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        // DateTimeFormatter ymdhm = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"); // 시간도 표현

        if (entity.getPblancDt() != null) {
            dto.setPblancDate(ymd.format(entity.getPblancDt()));
            // 공고번호 생성 (날짜 + ID)
            String dateStr = entity.getPblancDt().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
            dto.setBidNo(dateStr + "-" + entity.getBidPblancSn());
        }
        if (entity.getBidClosDt() != null) {
            dto.setBidCloseDate(entity.getBidClosDt().format(ymd));
        }

        // 낙찰방법 변환
        dto.setBidMethod(getBidMethodName(entity.getScsbMth()));

        // ▼▼▼ [수정 2] 상태 결정 로직 (마감일 체크 우선) ▼▼▼
        // 현재 시간 가져오기
        LocalDateTime now = LocalDateTime.now();

        // 1순위: 마감일이 지났으면 무조건 '마감' 처리
        if (entity.getBidClosDt() != null && entity.getBidClosDt().isBefore(now)) {
            dto.setBidStatus("마감");
        }
        // 2순위: 마감일이 안 지났으면 원래 상태값(DB값) 따라감
        else {
            dto.setBidStatus(getBidStatusName(entity.getBidSttus()));
        }
        // 기타 값
        dto.setRequiredDocs("신용평가등급확인서");
        dto.setCreditYn("제출");
        dto.setSpotYn(entity.getSptdcAt() == 1 ? "필수" : "없음");
        dto.setSpotPlace(entity.getSptdcPlace());

        return dto;
    }

    private String getBidMethodName(int code) {
        switch (code) {
            case 2: return "최고낙찰";
            case 1: return "최저낙찰";
            default: return "적격심사";
        }
    }

    private String getBidStatusName(int code) {
        switch (code) {
            case 2: return "선정 완료";
            case 1: return "재공고";
            default: return "신규공고";
        }
    }
    public BidPblancResponseDto getBidDetail(int id, String serverName) {
        Long longId = (long) id;

        // [1] 진짜 서버(Dream_System)인 경우 -> realRepo에서 조회
        if ("Dream_System".equals(serverName)) {
            BidPblanc realEntity = realRepo.findById(longId).orElse(null);

            if (realEntity == null) {
                throw new RuntimeException("해당 공고를 찾을 수 없습니다. (Real DB)");
            }
            // 진짜 엔티티를 DTO로 변환해서 리턴
            return convertRealToDto(realEntity);
        }

        BaseBid entity = null;

        // 서버 이름에 따라 다른 레포지토리에서 조회
        if (serverName.contains("서울")) {
            entity = seoulRepo.findById(longId).orElse(null);
        } else if (serverName.contains("경기")) {
            entity = gyeonggiRepo.findById(longId).orElse(null);
        } else if (serverName.contains("경북")) {
            entity = gyeongbukRepo.findById(longId).orElse(null);
        }

        if (entity == null) {
            throw new RuntimeException("해당 공고를 찾을 수 없습니다.");
        }

        return convertToDto(entity, serverName);
    }
}