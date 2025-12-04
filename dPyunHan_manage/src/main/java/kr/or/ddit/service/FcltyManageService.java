package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.CmmntyVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FcltyManageVO;
import kr.or.ddit.vo.FcltyVO;

public interface FcltyManageService {


	// 직원 아이디 목록 조회
	public List<EmpVO> selectEmpList();
   
	//시설 일련번호 목록 조회
	public List<FcltyVO> selectFcltySn(int fcltySn);

	//커뮤니티 일련번호 목록 조회
	public List<CmmntyVO> selectCmmnty(int cmmntySn);
	
	//시설관리 등록
	public int registerPost(FcltyManageVO fcltyManageVO);

	//전체 행의 수
	public int getTotal(Map<String, Object> map);

	//시설관리 리스트 목록
	public List<FcltyManageVO> fclManageAllist(Map<String, Object> map);

	//시설관리리스트에서 일정등록 여부 확인
	public int getFxcount(int manageSn);


	






  


	

}
