package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.ui.Model;

import kr.or.ddit.vo.CmmntyVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FcltyManageVO;
import kr.or.ddit.vo.FcltyVO;

@Mapper
public interface FcltyManageMapper {


	//직원 아이디 조회
	public List<EmpVO> selectEmpList();
	
	//시설 일련번호 조회
	public List<FcltyVO> selectFcltySn(int fcltySn);
	
	//커뮤니티 일련번호 조회
	public List<CmmntyVO> selectCmmnty(int cmmntySn);
	
	//시설관리 등록
	public int registerPost(FcltyManageVO fcltyManageVO);

	//전체 행의 수
	public int getTotal(Map<String, Object> map);

	//시설 관리 목록 조회
	public List<FcltyManageVO> fclManageAllist(Map<String, Object> map);

	//시설 점검상태 업데이트
	public void updateFcltySttus(FcltyManageVO fcltyManageVO);

	//커뮤니티 점검상태 업데이트 
	public void updateCmmntyChcksttus(FcltyManageVO fcltyManageVO);

	//시설점검 일시 업데이트 반영
	public void updatefcltyChckDt(FcltyManageVO fcltyManageVO);

	//시설관리 점검 상태 업데이트 
	public void updatefclmanageChcksttus(FcltyManageVO fcltyManageVO);


	
}
