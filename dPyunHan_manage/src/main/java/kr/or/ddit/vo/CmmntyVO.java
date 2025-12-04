package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class CmmntyVO {

	private String cmmntyOpnVwpoint;  //커뮤니티 개방 시간
	private String cmmntyClosVwpoint;   //커뮤니티 마감 시간
	private int cmmntySn;   //커뮤니티 일련번호
	private String cmmntyNm;  //커뮤니티 이름
	private int totUsePosblSpce; //총 사용 가능 공간
	
	private String cmmntyChcksttus;  //커뮤니티 상태
	private Date cmmntyChckDt; //커뮤니티 점검 일시
	
	private String empId;
}
