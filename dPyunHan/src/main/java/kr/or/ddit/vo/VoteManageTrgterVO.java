package kr.or.ddit.vo;

import lombok.Data;

@Data
public class VoteManageTrgterVO {
	private int voteMtrSn;
	private String mberId;
	private int voteIemNo;
	//내가투표한항목 null이 들어가기 좋은 항목이라 Integer타입했습ㄴ디ㅏ
	private Integer myVoteIemNo;
}
