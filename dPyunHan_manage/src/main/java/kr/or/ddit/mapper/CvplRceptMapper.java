package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.CvplManageVO;
import kr.or.ddit.vo.CvplRceptVO;
import kr.or.ddit.vo.CvplVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.FileGroupVO;

@Mapper
public interface CvplRceptMapper {

	//해당 부서의 민원 리스트
	List<CvplVO> list(Map<String, Object> map);

	//페이지네이션
	int getTotal(Map<String, Object> map);
	
	//해당 민원의 상세
	CvplVO detail(CvplVO cvplVO);
	CvplRceptVO cvplRceptDetail(int cvplSn);

	//해당 민원 접수 실행
	int cvplRceptPost(CvplRceptVO cvplRceptVO);
	int insertCvplManage(CvplRceptVO cvplRceptVO);

	// 해당 민원 종결 실행
	int cvplEnPost(CvplRceptVO cvplRceptVO);

	//cvplVO 조회(수신자, 알림 제목)
	CvplVO selectMberIdCvplSj(int cvplSn);

	// kbh추가 처리할 민원 숫자 
	int getCvplRceptNum();
    
}
