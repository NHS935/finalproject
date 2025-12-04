package kr.or.ddit.service;

import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.SignVO;

public interface EmpMyPageService {

	
	//회원정보수정조회
	public EmpVO selectEmpDetailById(String empId);
	
	//editEmpInfo emp테이블 정보 수정
	public int empEdit(EmpVO empVO);


}
