package kr.or.ddit.vo;

import java.util.Date;
import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class FcltyVO {
 
	private int fcltySn;  //시설 일련번호
	
	private String fcltyCl;  //시설분류

	private String fcltyNm;  //시설이름
	
	private String fcltyLc;    //시설위치
	
	private String fcltySttus;   //시설상태
		
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date fcltyChckDt;   //시설점검일시

	private String empId;

	private String aptcmpl;

	
}
