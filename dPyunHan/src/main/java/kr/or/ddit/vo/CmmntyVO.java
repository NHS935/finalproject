package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class CmmntyVO {

	private int cmmntySn;
	private String cmmntyNm;
	private int totAceptncNmpr;
	private String cmmntyOpnVwpoint;
	private String cmmntyClosVwpoint;
	private int resveMxmmNmpr;
	private int resveMxmmTime;
	
	private int remainNmpr;
	private String timeRange;
	private List<ResveVO> resveVOList;
}
