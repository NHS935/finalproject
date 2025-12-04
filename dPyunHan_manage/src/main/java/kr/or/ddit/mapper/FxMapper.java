package kr.or.ddit.mapper;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FxVO;

@Mapper
public interface FxMapper {

	
	//일정 조회
	public List<FxVO> list(Map<String, Object> map);
	
	//일정 등록
	public int insert(FxVO fxVO);

	//일정 수정
	public int modify(FxVO fxVO);

	//시설관리리스트 일정 등록
	public int fcltyschdulregiser(FxVO fxVO);

	//시설관리리스트에서 일정등록 여부 확인
	public int getFxcount(int manageSn);

	//일정 등록 시 emp 전체 목록 조회해오기
	public List<EmpVO> getEmpList();

	 //나혜선 추가 시작
	
	//시설/보안 커뮤니티 점검 이력 점검일자 동기화
	public void updateFcltyManageDate(int fcltyManageSn, Date fxBeginDt, Date fxEndDt);
 
	//시설 점검일자 동기화
	public void updateFcltyDate(int fcltySn, Date fxBeginDt);

	//커뮤니티 점검일자 동기화
	public void updateCmmntyDate(int cmmntySn, Date fxBeginDt);

	//동기화 후 db에서 다시 조회해오기
	public FxVO reselectFxDate(int fcltyManageSn);

	//동기화 후 수정 후 db에서 다시 조회해오기
	public FxVO reupdateFxDate(int schdulSn);

    //나혜선 추가 끝

}
