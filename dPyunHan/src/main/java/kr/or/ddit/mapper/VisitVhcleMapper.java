package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.VisitVhcleVO;



@Mapper
public interface VisitVhcleMapper {

    // 남은 주차시간 조회
	Integer getRemainingTime(String hshldId);

    // 예약 등록
    void insertVisit(VisitVhcleVO visitVhcleVO);

    // 남은시간 업데이트
    void updateRemainingTime(String hshldId, int usedMinutes);

    // 이용내역 조회
    List<VisitVhcleVO> selectVisitHistory(String hshldId);

	VisitVhcleVO selectLatestVisit(String hshldId);

	void insertInitialTime(String hshldId);

	void resetMonthlyTime();

	Integer getAccmltTime(String hshldId);

	String selectHshldIdByMberId(String mberId);

	List<VisitVhcleVO> selectVisitHistoryByMonth(String hshldId, String month);

}
