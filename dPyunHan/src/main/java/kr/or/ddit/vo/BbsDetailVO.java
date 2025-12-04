package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class BbsDetailVO {
	
	private int rnum;
	private long bbsDetailNo;
	private long bbsGroupSn;
	private String sj;
	private String cn;
	private String sttus;
	private Date writngDt;
	private long fileGroupSn;
	private String mberId;

}
