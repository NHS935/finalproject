package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class BbsGroupVO {
	
	private long bbsGroupSn;
	private int answerAt;
	private int atchFileAt;
	private String mberId;
	private String bbsNm;
	
	//BBS_GROUP : BBS_DETAIL = 1 : N
	private List<BbsDetailVO> bbsDetailVOList;
	
}
