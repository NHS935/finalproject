package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.CvplRceptVO;
import kr.or.ddit.vo.CvplVO;

public interface CvplRceptService {

	//해당 부서의 민원 리스트
	List<CvplVO> list(Map<String, Object> map);

	//페이지네이션
	int getTotal(Map<String, Object> map);

	//해당 민원의 상세
	CvplVO detail(CvplVO cvplVO);
	CvplRceptVO cvplRceptDetail(int cvplSn);

	//해당 민원 접수 실행
	int cvplRceptPost(CvplRceptVO cvplRceptVO);

	// 해당 민원 종결 실행
	int cvplEnPost(CvplRceptVO cvplRceptVO);

	// kbh추가 처리할 민원 숫자 
	int getCvplRceptNum();


}
