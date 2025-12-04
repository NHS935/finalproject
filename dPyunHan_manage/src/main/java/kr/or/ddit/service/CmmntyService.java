package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.CmmntyVO;
import kr.or.ddit.vo.EmpVO;

public interface CmmntyService {

	//커뮤니티 리스트 목록 조회
	public List<CmmntyVO> cmmntylist(Map<String, Object> map);

	//전체 행의 수 
	public int getTotal2(Map<String, Object> map);

	//상태 값 변경 db 전달
	public int cmmntyupdatePost(CmmntyVO cmmntyVO);

	//상태 값 변경 전 db값 조회
	public CmmntyVO detail(int cmmntySn);

	//담당자 정보 조회
	public List<EmpVO> empList();

	


}
