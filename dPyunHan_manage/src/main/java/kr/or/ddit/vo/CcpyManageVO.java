package kr.or.ddit.vo;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class CcpyManageVO {
	private int rnum;
	private int ccpyManageId;
	private String ccpyCmpnyNm;
	private String ccpyAdres;
	private String ccpyTelno;
	private String ccpyRprsntvNm;
	private String ccpyBizrno;
	private String ccpyEmail;
	private String ccpyPassword;
	private long fileGroupSn;
	
	private Date ccpyRegistdt;
	
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date ccpyOpbizDe;
	
	private int ccpySttus;
	public String getCcpySttusAsStr() {
		switch (ccpySttus) {
		case 2:
			return "반려"; 
		case 1:
			return "승인"; 
		default:
			return "대기";
		}
	}
	
	//업종 업태
	private List<BizcndIndutyVO> bizcndIndutyVOList;	
	
	private List<CcpyAuthorVO> ccpyAuthorVOList;
	
	// 이름 마스킹 (앞 1글자만 표시)
	public String getMaskCcpyRprsntvNm () {
	    if (ccpyRprsntvNm == null || ccpyRprsntvNm.length() == 0) return "";
	    if (ccpyRprsntvNm.length() == 1) return ccpyRprsntvNm;
	    return ccpyRprsntvNm.charAt(0) + "*".repeat(ccpyRprsntvNm.length() - 1);
	}

	// 회사명 마스킹 (앞 1글자, 뒤 2글자만 표시)
	public String getMaskCcpyCmpnyNm () {
	    if (ccpyCmpnyNm == null || ccpyCmpnyNm.length() <= 3) return ccpyCmpnyNm;
	    int maskLength = ccpyCmpnyNm.length() - 3;
	    return ccpyCmpnyNm.charAt(0) + "*".repeat(maskLength) + ccpyCmpnyNm.substring(ccpyCmpnyNm.length() - 2);
	}

	// 이메일 마스킹 (앞 3글자만 표시)
	public String getMaskCcpyEmail() {
	    if (ccpyEmail == null || ccpyEmail.length() <= 3) return ccpyEmail;
	    return ccpyEmail.substring(0, 3) + "*".repeat(ccpyEmail.length() - 3);
	}
}
