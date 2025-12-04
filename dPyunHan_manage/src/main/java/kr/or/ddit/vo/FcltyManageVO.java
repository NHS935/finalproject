package kr.or.ddit.vo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class FcltyManageVO {

	private int fcltyManageSn; //시설관리 일련번호
	private String empId;  //직원ID
	private int fcltySn;  //시설 일련번호
	private int cmmntySn;   //커뮤니티 일련번호
	private String fcltymanageCn;  // 시설관리 내용
	private Date fcltymanageRegistDt;   //시설관리 등록 일시
	
	private double fcltymanagePrearngePd;  //시설관리 예정기간
	
	//fcltymanageBeginDt: "2025-11-11T09:19"
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm", timezone = "Asia/Seoul")
	@DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
	private Date fcltymanageBeginDt;  //시설관리 시작 일시	
	
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm", timezone = "Asia/Seoul")
	@DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
	private Date fcltymanageEndDt;  //시설관리 종료 일시	
	private String fcltymanageChcksttus; // 시설관리 점검상태
	
	
	private FcltyVO fcltyVO; //부모 시설 가져오기
	private CmmntyVO cmmntyVO;  //커뮤니티 가져오기
	private EmpVO empVO;  //직원 가져오기
	
	//DB에는 없는 임시 필드
	private String fcltySttus;  //시설 상태
	private String cmmntyChcksttus;  //커뮤니티 상태
	
	private boolean schduleyesno;  //일정등록 여부

	private String aptcmpl;
	private String fcltyLc;
	private String fcltyNm;
	private String cmmntyNm;
}
