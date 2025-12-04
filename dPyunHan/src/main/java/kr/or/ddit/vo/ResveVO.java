package kr.or.ddit.vo;

import java.time.LocalDate;
import java.util.Date;

import lombok.Data;

@Data
public class ResveVO {

	private int resveSn;
	private LocalDate resveDt;
	private int beginVwpoint;
	private int resveTime;
	private int resveNmpr;
	private int resveSttus;
	private Date registDt;
	private String mberId;
	private int cmmntySn;
	
	private CmmntyVO cmmntyVO;
}
