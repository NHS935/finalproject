package kr.or.ddit.vo;

import java.time.LocalDate;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class FxVO {

	private int schdulSn;  //일정 일련번호
	private String fxSj;   //일정 제목
	private String fxIem;  //일정 항목
	private String fxCn;  //일정 내용
	private String fxPlace;  //일정 장소
	
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm", timezone = "Asia/Seoul")
	@DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
	private Date fxBeginDt;   //일정 시작 일시 
	
	@JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm", timezone = "Asia/Seoul")
	@DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
	private Date fxEndDt;   //일정 종료 일시
	
	private Date fxRegistDt;   //일정 등록 일시
	private String empId;  //직원id
	
	private int fcltyManageSn;  //시설관리 일련번호
	private int fcltySn;       // 시설 일련번호
	private int cmmntySn;      //커뮤니티 일련번호
	
	private String nm;    //emp name 
	
	
}
