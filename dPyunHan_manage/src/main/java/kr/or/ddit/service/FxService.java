package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FxVO;

public interface FxService {

	//일정 조회
	public List<FxVO> list(String start, String end);

	//일정 등록
	public int insert(FxVO fxVO);

	//일정 수정
	public int modify(FxVO fxVO);

	//시설관리리스트 일정 등록
	public int fcltyschdulregiser(FxVO fxVO);

	//일정등록 시 emp 전체 목록 조회
	public List<EmpVO> getEmpList();


}
