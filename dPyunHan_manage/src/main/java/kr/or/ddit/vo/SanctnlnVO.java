package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class SanctnlnVO {
	private int sanctnlnId;
	private int sanctnOrdr;
	private int sanctnSttus;
	private Date sanctnDt;
	private String returnPrvonsh;
	private int elctrnsanctnSn;
	
	public String getSanctnSttusAsSTr() {
		switch (sanctnSttus) {
		case 2:
			return "반려";
		case 1:
			return "승인";
		default:
			return "대기";
		}
	}
	
	private String empId;
	
	private int dcrbmanAt;
	
	//결재자 N:1 관계 empVO
	private EmpVO empVO;
	
	public static final int sttsPnd = 0; // 미결
    public static final int sttsApr = 1; // 결재함
    public static final int sttsRej = 2; // 반려
}
