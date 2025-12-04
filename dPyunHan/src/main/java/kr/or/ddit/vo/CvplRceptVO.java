package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class CvplRceptVO {

	private int cvplRceptId;
	private String empId;
	private Date rceptDt;
	private String rceptCn;
	private int rceptSttus;
	
}
