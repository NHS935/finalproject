package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.CmmntyVO;
import kr.or.ddit.vo.EmpVO;

@Mapper
public interface CmmntyMapper {

	//커뮤니티 리스트 목록 조회
	public List<CmmntyVO> cmmntylist(Map<String, Object> map);

	//전체 행의 수
	public int getTotal2(Map<String, Object> map);

	//모달 상태값 변경 db전달
	public int cmmntyupdatePost(CmmntyVO cmmntyVO);

	//상태값 변경 전 db값 조회
	public CmmntyVO detail(int cmmntySn);

	//커뮤니티 리스트 행의 갯수 조회
	public int selectManageCount(int cmmntySn);

	//행의 갯수 2개 이상 이전 값 점검완료 처리
	public int updateManage(CmmntyVO cmmntyVO);

	//행의 갯수 2개 이상 마지막 행 커뮤니티 상태 동기화
	public int updateManageRecent(CmmntyVO cmmntyVO);

	//행의 갯수 2개 미만 시 
	public int updateManage2(CmmntyVO cmmntyVO);

	//담당자 정보 조회
	public List<EmpVO> empList();

}
