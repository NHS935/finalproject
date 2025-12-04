package kr.or.ddit.util.movingAvgStd;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import java.util.stream.Collectors;

import lombok.extern.slf4j.Slf4j;
import org.mybatis.logging.LoggerFactory;
import org.springframework.stereotype.Component;

/**
 * 이동평균 & 표준편차 기반 이상치 탐지 분석 모듈.
 * 
 * <p>
 * [주요 목적]
 * - 과거의 사용량 데이터를 기반으로 요일별 평균 및 표준편차를 계산
 * - 실시간 신규 검침 데이터가 주어졌을 때, 해당 요일의 통계 기준으로 Z-Score를 산출하여
 *   평상시보다 사용량이 비정상적으로 적거나 많은 경우 이상치(Anomaly)로 탐지.
 * 
 * [적용 시나리오]
 * - 각 세대별 검침량(전기, 가스, 수도 등)을 실시간으로 분석하여
 *   사용량 급증/급감 세대를 자동으로 감지하고 알림 기능에 활용.
 * 
 * [기법 요약]
 * - 이동평균(moving average): 최근 N주(week) 간의 데이터를 기준으로 계산
 * - 표준편차(standard deviation): 평균값으로부터 데이터의 흩어진 정도를 나타냄
 * - Z-score = (현재값 - 평균) / 표준편차
 * - Z-score가 임계값(Z_SCORE_THRESHOLD, 기본 2.5)을 초과하면 '이상치'로 판단
 */
@Slf4j
@Component
public class MovingAvgStdAnalysis {

    // Z-score 임계값 (1차 필터: 이보다 크면 이상치로 간주)
    private static final double Z_SCORE_THRESHOLD = 2.5;
    // 4주 평균 대비 변동률 임계값 (2차 필터: 50% 변동 기준)
    private static final double RECENT_ANOMALY_RATIO = 0.5;

    // 통계 계산을 신뢰할 수 있는 최소 데이터 수
    private static final int MIN_DATA_POINTS = 2;

    /**
     * 요일별 통계를 관리하는 내부 클래스.
     */
    private static class TimeSlotStats {
        double mean;
        double stdDev;
        List<Double> values;
        int dataPoints;

        TimeSlotStats() {
            this.values = new ArrayList<>();
            this.dataPoints = 0;
        }

        // 데이터 리스트 기반으로 평균과 표준편차를 갱신
        void recalculate() {
            this.mean = calculateMean(values);
            this.stdDev = calculateStdDev(values, mean);
            this.dataPoints = values.size();
        }

        // 데이터가 충분히 있는지 판단
        boolean isReliable() {
            return dataPoints >= MIN_DATA_POINTS;
        }
    }

    /**
     * 이중 필터를 적용하는 이상치 탐지 메서드.
     * * @param historicalData 과거 N주간의 사용량 데이터 (세대/항목별로 이미 그룹화됨)
     * @param newData 새로 들어온 실시간 데이터 (분석 대상)
     * @param movingAverageWeeks 이동평균 기준 기간(주 단위)
     * @return 분석 결과가 적용된 newData 리스트 반환
     */
    /**
     * 이중 필터를 적용하는 이상치 탐지 메서드 (DOW Z-Score && 4주 평균 이탈)
     */
    public List<MovingAvgStdPoint> detectAnomalyHybridRealTime(
            List<MovingAvgStdPoint> historicalData,
            List<MovingAvgStdPoint> newData,
            int movingAverageWeeks) {

        // 1. 요일별 통계 정보 생성 (1차 필터 기준 준비)
        Map<Integer, TimeSlotStats> dayOfWeekStats = buildDayOfWeekStats(
                historicalData, movingAverageWeeks);

        // 2. 4주간 일 평균 계산 (2차 필터 기준값)
        double fourWeekDailyAvg = calculateMean(
                historicalData.stream()
                        .mapToDouble(MovingAvgStdPoint::getUsgqty)
                        .boxed()
                        .collect(Collectors.toList())
        );

        // 3. 신규 데이터 순회하며 이중 이상치 탐지 수행
        for (MovingAvgStdPoint newPoint : newData) {

            int dayOfWeek = newPoint.getDate().getDayOfWeek().getValue() % 7;
            TimeSlotStats stats = dayOfWeekStats.get(dayOfWeek);

            // A. 요일별 Z-Score 1차 분석
            boolean isZScoreAnomaly = false;
            double zScore = 0.0;

            if (stats != null && stats.isReliable()) {
                zScore = Math.abs((newPoint.getUsgqty() - stats.mean)
                        / (stats.stdDev + 1e-10));

                isZScoreAnomaly = (zScore > Z_SCORE_THRESHOLD);
                newPoint.setAnomalyScore(Math.min(zScore / Z_SCORE_THRESHOLD, 1.0));
                newPoint.setAnalysisStatus(isZScoreAnomaly ? "Z_SCORE_ANOMALY" : "Z_SCORE_NORMAL");
            } else {
                newPoint.setAnalysisStatus("INSUFFICIENT_DATA");
                newPoint.setAnomaly(false);
                continue;
            }

            // B. 4주 평균 대비 2차 필터링
            boolean isRecentPatternAnomaly = false;
            if (fourWeekDailyAvg > 0) {
                double readingValue = newPoint.getUsgqty();
                // 4주 평균의 150%를 초과하거나 50% 미만일 경우
                if (readingValue > fourWeekDailyAvg * (1 + RECENT_ANOMALY_RATIO) ||
                        readingValue < fourWeekDailyAvg * (1 - RECENT_ANOMALY_RATIO)) {
                    isRecentPatternAnomaly = true;
                }
            }

            // C. 최종 판단: 두 기준 모두 만족 (AND 조건)
            if (isZScoreAnomaly && isRecentPatternAnomaly) {
                newPoint.setAnomaly(true);
                newPoint.setAnalysisStatus("FINAL_ANOMALY");
                log.warn("🚨 이중 이상 감지: HshldId={}, IemNm={} (Z={:.2f}, 4WAvg={:.2f})",
                        newPoint.getHshldId(), newPoint.getIemNm(), zScore, fourWeekDailyAvg);
            } else {
                newPoint.setAnomaly(false);
                newPoint.setAnalysisStatus("FILTERED_NORMAL");
            }
        }

        return newData;
    }

    private Map<Integer, TimeSlotStats> buildDayOfWeekStats(
            List<MovingAvgStdPoint> readings, int movingAverageDays) {

        List<MovingAvgStdPoint> sortedReadings = new ArrayList<>(readings);
        sortedReadings.sort((r1, r2) -> r1.getDate().compareTo(r2.getDate()));

        Map<Integer, TimeSlotStats> dayOfWeekStats = new HashMap<>();
        int maxDays = movingAverageDays * 7;

        for (MovingAvgStdPoint point : sortedReadings) {
            int dayOfWeek = point.getDate().getDayOfWeek().getValue() % 7;
            TimeSlotStats stats = dayOfWeekStats.computeIfAbsent(dayOfWeek, k -> new TimeSlotStats());
            stats.values.add(point.getUsgqty());
        }

        for (TimeSlotStats stats : dayOfWeekStats.values()) {
            if (stats.values.size() > maxDays) {
                stats.values = stats.values.subList(
                        stats.values.size() - maxDays,
                        stats.values.size()
                );
            }
            stats.recalculate();
        }

        return dayOfWeekStats;
    }

    private static double calculateMean(List<Double> values) {
        return values.stream()
                .mapToDouble(Double::doubleValue)
                .average()
                .orElse(0.0);
    }

    private static double calculateStdDev(List<Double> values, double mean) {
        double variance = values.stream()
                .mapToDouble(v -> Math.pow(v - mean, 2))
                .average()
                .orElse(0.0);
        return Math.sqrt(variance);
    }
}
