package kr.or.ddit.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;

import kr.or.ddit.mapper.ResveMapper;
import kr.or.ddit.vo.CmmntyVO;
import kr.or.ddit.vo.ResveVO;

public interface ResveService {

	// 커뮤니티시설 리스트(예약)
	List<CmmntyVO> list(CmmntyVO cmmntyVO);

	// 해당 커뮤니티시설 상세 조회
	CmmntyVO detail(CmmntyVO cmmntyVO);

	// 해당 커뮤니티시설 시간대 조회
	List<String> selectTimeSlots(CmmntyVO cmmntyVO);

	//2. 해당 날짜, 시설 예약 내역 조회
	List<ResveVO> resveAvailable(ResveVO resveVO);

	// 예약 실행
	int resve(ResveVO resveVO);

	//내 예약현황 리스트
	List<ResveVO> resveMber(ResveVO resveVO);

	//탭별 예약 상세
	ResveVO resveMberDetail(int resveSn);

	// 예약 취소 실행
	int resveCancel(ResveVO resveVO);

}
