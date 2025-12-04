package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.EmpVO;
/*import kr.or.ddit.vo.cmmntyVO;*/
import kr.or.ddit.vo.FcltyVO;

@Mapper
public interface FcltyMapper {

	//시설점검 결과 등록
	//public int registerPost(FcltyVO fcltyVO);

	//시설점검 결과 목록
	public List<FcltyVO> list(Map<String, Object> map);

	//전체 행의 수
	public int getTotal(Map<String, Object> map);

	//검색 결과 목록 조회
	public int listPostAjax(List<FcltyVO> nhs);

	//모달 변경 상태값 db 변경
	public int updatePost(FcltyVO fcltyVO);

	/*
	 * // 커뮤니티 리스트 목록 조회 public List<cmmntyVO> cmmntylist(Map<String, Object> map);
	 */

	//상태값 변경 전 db 값 조회
	public FcltyVO detail(int fcltySn);

	//시설관리 리스트 상태값 업데이트(행 2개 이상 시 이전 행 점검완료 처리)
	public int updateManage(FcltyVO fcltyVO);

	//시설관리 리스트 상태값 업데이트(행 2개 이상 시 최근 행 시설상태 동일 처리)
	public int updateManageRecent(FcltyVO fcltyVO);
	
	//시설관리 행의 갯수 조회
	public int selectManageCount(int fcltySn);

	//시설관리 행의 갯수가 2개 미만일때
	public int updateManage2(FcltyVO fcltyVO);

	//담당자 정보 조회
	public List<EmpVO> empList();

	//행 10개 이상 보이게 조회
	public List<FcltyVO> selectAll();



   
}
