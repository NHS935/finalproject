package kr.or.ddit.service;

import kr.or.ddit.util.movingAvgStd.MovingAvgStdPoint;
import kr.or.ddit.vo.MtinspVO;
import kr.or.ddit.vo.PivotedMtinspVO;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

public interface MtinspService {
	
	// 2025-11-19 KWH 
	// 이동평균표춘편차 검침 이상 분석
	/**
     * 검침 사용 이력 조회
     * @param searchParams 검색 조건
     * @return 피벗된 검침 데이터
     */
    List<PivotedMtinspVO> getUsageHistory(Map<String, Object> searchParams);
    
    /**
     * 실시간 검침 데이터 이상치 탐지
     * 
     * @param newReadings 신규 검침 데이터 리스트
     * @param movingAverageDays 이동평균 기준 기간(주 단위, 기본값: 4주)
     * @return 이상치 분석 결과가 포함된 검침 데이터 리스트
     */
    List<MovingAvgStdPoint> detectAnomalies(List<MovingAvgStdPoint> newReadings, int movingAverageDays);
    
    /**
     * 실시간 검침 데이터 이상치 탐지 (기본 4주 기준)
     * 
     * @param newReadings 신규 검침 데이터 리스트
     * @return 이상치 분석 결과가 포함된 검침 데이터 리스트
     */
    List<MovingAvgStdPoint> detectAnomalies(List<MovingAvgStdPoint> newReadings);
    
    /**
     * 특정 세대의 이상치만 필터링하여 조회
     * 
     * @param hshldId 세대 ID
     * @return 해당 세대의 이상치 검침 데이터 리스트
     */
    List<MovingAvgStdPoint> getAnomaliesByHousehold(MtinspVO mtinspVO);
    
    /**
     * 특정 검침 종류의 이상치만 필터링하여 조회
     * 
     * @param iemNm 검침 종류 (수도/가스/전기)
     * @return 해당 검침 종류의 이상치 데이터 리스트
     */
    List<MovingAvgStdPoint> getAnomaliesByType(MtinspVO mtinspVO);
    
    /**
     * 특정 날짜의 검침 데이터 조회 (스케줄러용)
     */
    List<MovingAvgStdPoint> getReadingsByDate(LocalDate date);
    
    /**
     * 최근 N시간 데이터 조회 (스케줄러용)
     */
    List<MovingAvgStdPoint> getRecentReadings(int hours);
    
    /**
     * 기간별 검침 데이터 조회 (스케줄러용)
     */
    List<MovingAvgStdPoint> getReadingsByDateRange(LocalDate startDate, LocalDate endDate);

    /**
     * 일일 검침 데이터 이상치 배치 분석 (세대/유틸리티별 그룹화 및 이중 필터 적용)
     * */
    void analyzeDailyAnomaliesBatch();

/**
 * 특정 세대/유틸리티/기간의 과거 데이터 조회 (분석 모듈에 필요한 데이터)
 * */
List<MovingAvgStdPoint> getHistoricalReadingsForAll(LocalDate endDate, int weeks);

/**
 * 최종 이상치 데이터를 처리합니다. (DB 저장, 알림 등)
 * */
    void processAnomalies(List<MovingAvgStdPoint> anomalies, LocalDate analysisDate);
}
