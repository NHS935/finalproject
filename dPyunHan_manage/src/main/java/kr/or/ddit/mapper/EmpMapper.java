package kr.or.ddit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.TesterVO;

//계정, 로그인 관련 쿼리 실행
@Mapper
public interface EmpMapper {
	
	// 사용자 정보를 가져옴(로그인) -> select
	public EmpVO findByEmpId(String empId);

	//회귀분석 테스터용
	public List<TesterVO> getTesterList(EmpVO empVO);

	//담당자 목록 불러오기(나혜선)
	public List<EmpVO> getEmpList();

}
