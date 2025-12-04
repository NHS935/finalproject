package kr.or.ddit.vo;

import lombok.Data;

@Data
public class VoteIemVO {
	private int voteMtrSn;
	private int voteIemNo;
	private String iemNm;
	private String iemCn;
	//세부항목별 id숫자(alias)
	private int cnt;
	}
