package kr.or.ddit.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.FileGroupVO;

//계정, 로그인 관련 쿼리 실행
@Mapper
public interface EmpMyPageMapper {

	//emp+file+filedetail+auth 개인정보,개인정보수정 접근
	public EmpVO selectEmpDetailById(String empId);
	
	
	//[부모]	editEmpInfo emp테이블 정보 수정
	public int empEdit(EmpVO empVO);
	
}
