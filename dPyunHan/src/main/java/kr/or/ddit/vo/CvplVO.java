package kr.or.ddit.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class CvplVO {
	private int cvplSn;       // 민원 일련번호
	private String mberId;    // 회원 ID
	private String cvplSj;    // 민원 제목
	private String cvplCn;    // 민원 내용
	private Date reqstDt;     // 신청 일시
	private int deptCode;     // 부서 코드
  	private long fileGroupSn; //첨부 파일
	
	//페이징 및 정렬용 순서
	private int rnum;
	
	//MberId, deptCode 값을 가져오기 위한 추가
	private MberVO mber; 
    private DeptVO deptVO;
	
    private String mberNm;
    
    //민원 관리
    private CvplManageVO cvplManageVO;
    
    private CvplRceptVO cvplRceptVO;


}

