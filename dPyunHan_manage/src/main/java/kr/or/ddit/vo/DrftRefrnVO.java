package kr.or.ddit.vo;

import lombok.Data;

@Data
public class DrftRefrnVO {
	private int drftRefrnId;
	private int elctrnsanctnSn;
	private String empId;
	
	private EmpVO empVO;
}
