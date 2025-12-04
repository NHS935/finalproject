package kr.or.ddit.vo;

import lombok.Data;

@Data
public class BkmkSanctnlnDetailVO {
	private int bkmkSanctnlnId;
	private String empId;
	private int sanctnOrdr;
	private int drftRefrnAt;
	
	private EmpVO empVO;
}
