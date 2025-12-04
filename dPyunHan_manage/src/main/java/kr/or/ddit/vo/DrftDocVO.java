package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class DrftDocVO {
	private int rnum;
	private int drftDocId;
	private String drftDocNm;
	private Date validDudt;
	private String drftDocFormat;
	private int elctrnsanctnManageId;
	
	//결재 구분 코드
	private ElctrnsanctnManageVO elctrnsanctnManageVO;
	
}
