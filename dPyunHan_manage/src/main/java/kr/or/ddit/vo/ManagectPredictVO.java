package kr.or.ddit.vo;

import java.sql.Date;

import lombok.Data;

@Data
public class ManagectPredictVO {

	 private int managectPredictId;  //관리비예측 id
	 private String hshldId; //세대id
	 private Date mtinspDt; //검침 일자
	 private String iemNm;  //유틸리티 이름
	 private int usgqty;  //검침 사용량
	 private Date predictDate; //조회 일자
	
}
