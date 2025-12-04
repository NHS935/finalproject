package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class DeptVO {
	private String deptCode;
	private String deptNm;
	private int deptCttpc;
	
	private List<EmpVO> empVOList; 
}
