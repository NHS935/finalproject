package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.VisitVhcleVO;

public interface VisitVhicleService {
	
	// 
	String getHshldIdByMberId(String mberId);
	
    // 남은 주차시간 조회
    int getRemainingTime(String hshldId);

    // 예약 처리
    int reserveVhicle(VisitVhcleVO visitVhcleVO);

    // 이용내역 조회
    List<VisitVhcleVO> getVisitHistory(String hshldId);

    // 최신 방문 내역조회
	VisitVhcleVO getLatestVisit(String hshldId);
   
    // 신규 입주민 초기화
    void initNewResident(String hshldId);

    // 매월 1일 전체 초기화
    void resetMonthlyTime();

    // 이번달 누적 사용시간 조회
	int getAccmltTime(String hshldId);

	List<VisitVhcleVO> getVisitHistoryByMonth(String hshldId, String month);
	
}
