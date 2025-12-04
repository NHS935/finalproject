package kr.or.ddit.service.impl;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.enums.NtcnType;
import kr.or.ddit.mapper.MtinspMapper;
import kr.or.ddit.service.MtinspService;
import kr.or.ddit.util.NtcnUtil;
import kr.or.ddit.util.movingAvgStd.MovingAvgStdAnalysis;
import kr.or.ddit.util.movingAvgStd.MovingAvgStdPoint;
import kr.or.ddit.vo.MtinspVO;
import kr.or.ddit.vo.PivotedMtinspVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class MtinspServiceImpl implements MtinspService {

	@Autowired
	NtcnUtil ntcnUtil;
	
	private final MtinspMapper mtinspMapper;

	// 2025-11-19
	// KWH 이동평균표춘편차 검침 이상 분석
	private final MovingAvgStdAnalysis movingAvgStdAnalysis;

	// 기본 이동평균 기간 (4주)
	private static final int DEFAULT_MOVING_AVG_DAYS = 4;
	private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy/MM/dd");

	/**
	 * 검침 사용 이력 조회
	 * 
	 * @param searchParams 검색 조건 (세대ID, 기간 등)
	 * @return 피벗된 검침 데이터 리스트
	 */
	@Override
	public List<PivotedMtinspVO> getUsageHistory(Map<String, Object> searchParams) {
		return mtinspMapper.getUsageHistory(searchParams);
	}

	/**
	 * 실시간 검침 데이터 이상치 탐지 (이동평균 기간 지정)
	 * 
	 * 주요 동작: - DB에서 과거 검침 데이터 조회 (통계 기준용)</li> - MtinspVO → MovingAvgStdPoint
	 * 변환</li> - 이동평균 & 표준편차 기반 이상치 분석 수행</li> - 분석 결과 반환 (isAnomaly, anomalyScore,
	 * analysisStatus 포함)</li>
	 * 
	 * @param newReadings       신규 검침 데이터 리스트
	 * @param movingAverageDays 이동평균 기준 기간(주 단위)
	 * @return 이상치 분석 결과가 포함된 검침 데이터 리스트
	 */
	@Override
	public List<MovingAvgStdPoint> detectAnomalies(List<MovingAvgStdPoint> newReadings, int movingAverageDays) {
		log.debug("이상치 탐지 시작 - 신규 데이터: {}건, 이동평균 기간: {}주", newReadings.size(), movingAverageDays);
		try {
			// 1. DB에서 과거 검침 데이터 전체 조회 (통계 계산 기준)
			List<MtinspVO> historicalMtinspList = mtinspMapper.getAllReadings();

			// 2. MtinspVO → MovingAvgStdPoint 변환
			List<MovingAvgStdPoint> historicalData = convertToMovingAvgStdPoints(historicalMtinspList);

			// 3. 이상치 탐지 분석 수행
			List<MovingAvgStdPoint> analysisResult = movingAvgStdAnalysis.detectAnomalyHybridRealTime(historicalData, // 과거
					newReadings, // 신규 데이터 (분석 대상)
					movingAverageDays // 이동평균 기간
			);

			return analysisResult;
		} catch (Exception e) {
			log.error("이상치 탐지 중 오류 발생", e);
			throw new RuntimeException("이상치 탐지 실패", e);
		}
	}

	/**
	 * 실시간 검침 데이터 이상치 탐지 (기본 4주 기준)
	 * 
	 * 기본 이동평균 기간(4주)을 사용하여 이상치를 탐지합니다.
	 * 
	 * @param newReadings 신규 검침 데이터 리스트
	 * @return 이상치 분석 결과가 포함된 검침 데이터 리스트
	 */
	@Override
	public List<MovingAvgStdPoint> detectAnomalies(List<MovingAvgStdPoint> newReadings) {
		return detectAnomalies(newReadings, DEFAULT_MOVING_AVG_DAYS);
	}

	/**
	 * 특정 세대의 이상치만 필터링하여 조회
	 * 
	 * 주요 동작: - 해당 세대의 모든 검침 데이터 조회 - 최근 검침 데이터로 이상치 분석 수행 - 이상치로 판정된 데이터만 필터링하여 반환
	 * 
	 * @param hshldId 세대 ID
	 * @return 해당 세대의 이상치 검침 데이터 리스트
	 */
	@Override
	public List<MovingAvgStdPoint> getAnomaliesByHousehold(MtinspVO mtinspVO) {
		log.debug("세대별 이상치 조회 - 세대ID: {}", mtinspVO.getHshldId());

		try {
			// 1. 해당 세대의 검침 데이터 조회
			List<MtinspVO> householdReadings = mtinspMapper.getReadingsByHousehold(mtinspVO.getHshldId());

			if (householdReadings.isEmpty()) {
				log.warn("세대 {}의 검침 데이터가 없습니다.", mtinspVO.getHshldId());
				return new ArrayList<>();
			}
			// 2. MovingAvgStdPoint로 변환
			List<MovingAvgStdPoint> dataPoints = convertToMovingAvgStdPoints(householdReadings);

			// 3. 이상치 분석 수행
			List<MovingAvgStdPoint> analyzed = detectAnomalies(dataPoints);

			// 4. 이상치 필터링하여 반환
			return analyzed.stream().filter(MovingAvgStdPoint::isAnomaly).collect(Collectors.toList());

		} catch (Exception e) {
			log.error("세대별 이상치 조회 중 오류 - 세대ID: {}", mtinspVO.getHshldId(), e);
			throw new RuntimeException("세대별 이상치 조회 실패", e);
		}

	}

	/**
	 * 특정 검침 종류의 이상치만 필터링하여 조회
	 * 
	 * 주요 동작: - 해당 검침 종류(수도/가스/전기)의 모든 검침 데이터 조회 - 최근 검침 데이터로 이상치 분석 수행 - 이상치로 판정된
	 * 데이터만 필터링하여 반환
	 * 
	 * @param iemNm 검침 종류 (수도/가스/전기)
	 * @return 해당 검침 종류의 이상치 데이터 리스트
	 */
	@Override
	public List<MovingAvgStdPoint> getAnomaliesByType(MtinspVO mtinspVO) {
		log.debug("검침 종류별 이상치 조회 - 종류: {}", mtinspVO.getIemNm());
		try {
			// 1. 해당 검침 종류의 데이터 조회
			List<MtinspVO> typeReadings = mtinspMapper.getReadingsByType(mtinspVO.getIemNm());

			if (typeReadings.isEmpty()) {
				log.warn("검침 종류 {}의 데이터가 없습니다.", mtinspVO.getIemNm());
				return new ArrayList<>();
			}

			// 2. MovingAvgStdPoint로 변환
			List<MovingAvgStdPoint> dataPoints = convertToMovingAvgStdPoints(typeReadings);

			// 3. 이상치 분석 수행
			List<MovingAvgStdPoint> analyzed = detectAnomalies(dataPoints);

			// 4. 이상치 필터링하여 반환
			return analyzed.stream().filter(MovingAvgStdPoint::isAnomaly).collect(Collectors.toList());

		} catch (Exception e) {
			log.error("검침 종류별 이상치 조회 중 오류 - 종류: {}", mtinspVO.getIemNm(), e);
			throw new RuntimeException("검침 종류별 이상치 조회 실패", e);
		}
	}
	
	/**
     * 특정 날짜의 검침 데이터 조회 (스케줄러용)
     */
    @Override
    public List<MovingAvgStdPoint> getReadingsByDate(LocalDate date) {
        log.debug("날짜별 검침 데이터 조회 - 날짜: {}", date);
        
        try {
            List<MtinspVO> readings = mtinspMapper.getReadingsByDate(date);
            return convertToMovingAvgStdPoints(readings);
        } catch (Exception e) {
            log.error("날짜별 검침 데이터 조회 중 오류 - 날짜: {}", date, e);
            throw new RuntimeException("날짜별 검침 데이터 조회 실패", e);
        }
    }
    
    /**
     * 최근 N시간 데이터 조회 (스케줄러용)
     */
    @Override
    public List<MovingAvgStdPoint> getRecentReadings(int hours) {
        log.debug("최근 {}시간 검침 데이터 조회", hours);
        
        try {
            List<MtinspVO> readings = mtinspMapper.getRecentReadings(hours);
            return convertToMovingAvgStdPoints(readings);
        } catch (Exception e) {
            log.error("최근 데이터 조회 중 오류 - 시간: {}", hours, e);
            throw new RuntimeException("최근 데이터 조회 실패", e);
        }
    }
    
    /**
     * 기간별 검침 데이터 조회 (스케줄러용)
     */
    @Override
    public List<MovingAvgStdPoint> getReadingsByDateRange(
            LocalDate startDate, LocalDate endDate) {
        
        log.debug("기간별 검침 데이터 조회 - 시작: {}, 종료: {}", startDate, endDate);
        
        try {
            List<MtinspVO> readings = 
                mtinspMapper.getReadingsByDateRange(startDate, endDate);
            return convertToMovingAvgStdPoints(readings);
        } catch (Exception e) {
            log.error("기간별 검침 데이터 조회 중 오류 - 시작: {}, 종료: {}", 
                startDate, endDate, e);
            throw new RuntimeException("기간별 검침 데이터 조회 실패", e);
        }
    }

	/**
	 * MtinspVO 리스트를 MovingAvgStdPoint 리스트로 변환
	 * 
	 * 검침 데이터의 날짜 형식(String)을 LocalDate로 변환하고, 이상치 분석에 필요한 MovingAvgStdPoint 형태로
	 * 매핑합니다.
	 * 
	 * @param mtinspList 검침 VO 리스트
	 * @return 변환된 MovingAvgStdPoint 리스트
	 */
	private List<MovingAvgStdPoint> convertToMovingAvgStdPoints(List<MtinspVO> mtinspList) {
		List<MovingAvgStdPoint> dataPoints = new ArrayList<>();

		for (MtinspVO mtinsp : mtinspList) {
			MovingAvgStdPoint point = new MovingAvgStdPoint();

			// 날짜 변환 (String → LocalDate)
			if (mtinsp.getMtinspDt() != null && !mtinsp.getMtinspDt().isEmpty()) {
				try {
					point.setDate(LocalDate.parse(mtinsp.getMtinspDt(), DATE_FORMATTER));
				} catch (Exception e) {
					log.warn("날짜 파싱 실패: {}", mtinsp.getMtinspDt());
					continue;
				}
			}

			// 기본 정보 매핑
			point.setHshldId(mtinsp.getHshldId());
			point.setIemNm(mtinsp.getIemNm());
			point.setUsgqty(mtinsp.getUsgqty());

			dataPoints.add(point);
		}

		return dataPoints;
	}

	/**
	 * 일일 검침 데이터 이상치 배치 분석 (세대/유틸리티별 그룹화 및 이중 필터 적용)
	 * * @Override
	 */
	@Override
	public void analyzeDailyAnomaliesBatch() {
		log.info("--- 분석 로직 시작: DB I/O 최적화된 그룹 분석 ---");

		try {
			LocalDate yesterday = LocalDate.now().minusDays(1);

			// 1. 어제 날짜의 모든 검침 데이터 조회 (신규 데이터)
			List<MovingAvgStdPoint> yesterdayDataPoints = getReadingsByDate(yesterday);
			if (yesterdayDataPoints.isEmpty()) {
				log.warn("어제({}) 검침 데이터가 없습니다. 분석 건너뜀.", yesterday);
				return;
			}

			// 2. 모든 세대/항목의 과거 데이터를 1회 쿼리로 일괄 조회 (DB I/O 최적화)
			List<MovingAvgStdPoint> allHistoricalData = getHistoricalReadingsForAll(
					yesterday, DEFAULT_MOVING_AVG_DAYS);

			// 3. 과거 데이터를 메모리에서 세대(hshldId) 및 유틸리티(iemNm)별로 2중 그룹화
			// Map<HshldId, Map<IemNm, List<HistoricalPoints>>>
			Map<String, Map<String, List<MovingAvgStdPoint>>> groupedHistoricalData = allHistoricalData.stream()
					.collect(
							Collectors.groupingBy(MovingAvgStdPoint::getHshldId,
									Collectors.groupingBy(MovingAvgStdPoint::getIemNm)
							)
					);

			// 4. 어제 데이터도 동일하게 그룹화
			Map<String, Map<String, List<MovingAvgStdPoint>>> groupedYesterdayData = yesterdayDataPoints.stream()
					.collect(
							Collectors.groupingBy(MovingAvgStdPoint::getHshldId,
									Collectors.groupingBy(MovingAvgStdPoint::getIemNm)
							)
					);

			List<MovingAvgStdPoint> finalAnomalies = new ArrayList<>();

			// 5. 어제 데이터 그룹을 순회하며 분석 실행
			groupedYesterdayData.forEach((hshldId, iemNmMap) -> {
				iemNmMap.forEach((iemNm, yesterdayList) -> {

					if (yesterdayList.isEmpty()) return;

					// 해당 그룹의 과거 데이터 조회 (DB 조회가 아닌 메모리 맵 조회)
					List<MovingAvgStdPoint> historicalData = groupedHistoricalData
							.getOrDefault(hshldId, Map.of())
							.getOrDefault(iemNm, List.of());

					// 분석 모듈 호출
					List<MovingAvgStdPoint> analyzedData =
							movingAvgStdAnalysis.detectAnomalyHybridRealTime(
									historicalData, yesterdayList, DEFAULT_MOVING_AVG_DAYS);

					// 최종 이상치만 필터링
					analyzedData.stream()
							.filter(MovingAvgStdPoint::isAnomaly)
							.forEach(finalAnomalies::add);
				});
			});

			// 6. 이상치 처리 및 로깅
			log.info("분석 완료: 총 {}건 중 {}건 이상 감지",
					yesterdayDataPoints.size(), finalAnomalies.size());

			processAnomalies(finalAnomalies, yesterday);

		} catch (Exception e) {
			log.error("일일 검침 이상치 배치 분석 중 오류 발생", e);
			throw new RuntimeException("일일 검침 이상치 배치 분석 실패", e);
		}
	}

		/**
		 * 특정 세대/유틸리티/기간의 과거 데이터 조회 (분석 모듈에 필요한 데이터)
		 * @param endDate 조회 종료 날짜 (어제 날짜)
		 * @param weeks 조회 기간 (주 단위)
		 * @return 조회된 MovingAvgStdPoint 리스트
		 * @Override
		 */
	@Override
	public List<MovingAvgStdPoint> getHistoricalReadingsForAll(
			LocalDate endDate, int weeks) {

		log.debug("전체 과거 데이터 일괄 조회 - 종료일:{}, 기간:{}주", endDate, weeks);

		try {
			// 🚨 MtinspMapper에 getHistoricalReadingsForAll(endDate, weeks) 정의 필요
			List<MtinspVO> historicalList =
					mtinspMapper.getHistoricalReadingsForAll(endDate, weeks);
			return convertToMovingAvgStdPoints(historicalList);
		} catch (Exception e) {
			log.error("전체 과거 데이터 조회 중 오류", e);
			throw new RuntimeException("전체 과거 데이터 조회 실패", e);
		}
	}
		/**
		 * 최종 이상치 데이터를 처리합니다. (DB 저장, 알림 등)
		 * * @param anomalies 최종 이상치 리스트
		 * @param analysisDate 분석 날짜
		 * @Override
		 */
	@Override
	public void processAnomalies(List<MovingAvgStdPoint> anomalies, LocalDate analysisDate) {
		if (anomalies.isEmpty()) {
			log.info("{} 분석 결과: 감지된 이상치 없음.", analysisDate);
			return;
		}

		// 🚨 이 부분에서 알림(ntcnUtil)을 호출하거나, 이상치 기록을 DB에 저장합니다.
		log.warn("{} 분석 결과: 총 {}건의 이상치 감지. DB 저장 및 알림 처리 시작.", analysisDate, anomalies.size());

		// 예: mtinspMapper.insertAnomalies(anomalies);
		// 예: ntcnUtil.sendNotification(anomalies);
		try{

			// 2. 첫 번째 이상치 정보 가져오기
			MovingAvgStdPoint firstAnomaly = anomalies.get(0);
			String hshldId = firstAnomaly.getHshldId();
			String searchMonth = firstAnomaly.getDate()
            	.format(DateTimeFormatter.ofPattern("yyyy-MM"));

			ntcnUtil.sendUser("SYSTEM", "ALL_EMP", NtcnType.ANOMALY,
			analysisDate + " 검침 이상치 " + anomalies.size() + " 건 감지됨. <br>확인이 필요합니다." ,
			"/mtinsp/mtinspView?hshldId=" + hshldId + "&searchMonth=" + searchMonth);
		} catch (Exception e){
			log.error("이상치 처리 중 오류 발생", e);
		}
	}


}
