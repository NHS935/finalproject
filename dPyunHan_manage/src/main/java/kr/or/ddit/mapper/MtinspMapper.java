package kr.or.ddit.mapper;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.MtinspVO;
import kr.or.ddit.vo.PivotedMtinspVO;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MtinspMapper {

    List<MtinspVO> findMetersByMonth(String billingMonth);
    
    // 2025-11-19 KWH
    // 이동평균표춘편차 검침 이상 분석
    /**
     * 검침 사용 이력 조회 (피벗)
     */
    List<PivotedMtinspVO> getUsageHistory(Map<String, Object> searchParams);
    
    /**
     * 전체 검침 데이터 조회 (이상치 분석용)
     */
    List<MtinspVO> getAllReadings();
    
    /**
     * 특정 세대의 검침 데이터 조회
     */
    List<MtinspVO> getReadingsByHousehold(String hshldId);
    
    /**
     * 특정 검침 종류의 데이터 조회
     */
    List<MtinspVO> getReadingsByType(String iemNm);

    /**
     * 특정 날짜의 검침 데이터 조회 (스케줄러용)
     * 
     * @param date 조회 날짜
     */
    List<MtinspVO> getReadingsByDate(@Param("date") LocalDate date);
    
    /**
     * 최근 N시간 이내의 검침 데이터 조회 (스케줄러용)
     * 
     * @param hours 조회 시간 (시간 단위)
     */
    List<MtinspVO> getRecentReadings(@Param("hours") int hours);
    
    /**
     * 기간별 검침 데이터 조회 (스케줄러용)
     * 
     * @param startDate 시작 날짜
     * @param endDate 종료 날짜
     */
    List<MtinspVO> getReadingsByDateRange(
        @Param("startDate") LocalDate startDate,
        @Param("endDate") LocalDate endDate
    );



    void insertBatchMeterData(List<Map<String, Object>> batchList);

    List<Long> getNextMtinspPKs(@Param("count") int count);

    List<MtinspVO> getHistoricalReadingsForAll(LocalDate endDate, int weeks);

}
