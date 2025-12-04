package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.EmpVO;
/*import kr.or.ddit.vo.CmmntyVO;*/
import kr.or.ddit.vo.FcltyVO;

public interface FcltyService {

	//시설 점검 결과 등록
	//public int registerPost(FcltyVO fcltyVO);
    
	//시설 점검 결과 목록
	public List<FcltyVO> list(Map<String, Object> map);

	//전체 행의 수
	public int getTotal(Map<String, Object> map);

	//모달 상태 값 db 변경
	public int updatePost(FcltyVO fcltyVO);

	/*
	 * // 커뮤니티 시설 목록 public List<CmmntyVO> cmmntylist(Map<String, Object> map);
	 */

	//상태값 변경 전 db 값 조회
	public FcltyVO detail(int fcltySn);

	//담당자 정보 조회
	public List<EmpVO> empList();

	//10개 이상 행 보이게 조회
	public List<FcltyVO> selectAll();



	


	
}
