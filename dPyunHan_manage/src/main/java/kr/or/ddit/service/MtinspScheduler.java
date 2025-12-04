package kr.or.ddit.service;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.context.annotation.Profile;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.util.NtcnUtil;
import kr.or.ddit.util.movingAvgStd.MovingAvgStdPoint;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * 검침 데이터 이상치 자동 탐지 스케줄러
 *
 * <p>매일 정해진 시간에 자동으로 검침 데이터의 이상치를 분석하고
 * 결과를 처리합니다.</p>
 */
@Slf4j
@Service
@Profile("server") // "server" 프로필일 때만 활성화
@RequiredArgsConstructor
public class MtinspScheduler {

    private final NtcnUtil ntcnUtil;
    private final MtinspService mtinspService;  // ← Service만 사용

    /**
     * 매일 자정에 전일 검침 데이터 이상치 분석 실행
     *                 초 분 시 일 월 요일
     * <p>Cron 표현식: "0 0 0 * * *"</p>
     */
    @Scheduled(cron = "0 35 11 4 12 *")
    @Transactional
    public void analyzeDailyAnomalies() {
        log.info("========== 일일 검침 이상치 분석 시작 (그룹화 기반) ==========");

        try {
            // 기존의 데이터 조회, 그룹화, 분석, 필터링, 처리 로직 전체를
            // MtinspService의 analyzeDailyAnomaliesBatch() 메서드로 위임합니다.
            mtinspService.analyzeDailyAnomaliesBatch();

            log.info("========== 일일 검침 이상치 분석 완료 ==========");

        } catch (Exception e) {
            log.error("일일 검침 이상치 분석 중 오류 발생", e);
        }
    }

}
