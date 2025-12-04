package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class VoteMtrVO {
	private int voteMtrSn;
	private String mtrSj;
	private String mtrCn;
	private String voteBeginDt;
	private String voteEndDt;
	private String empId;
	
	//아래는 추가된 vo들
	//alias로 투표숫자
	private int votedNum;
	//세부항목별 id숫자(alias)
	private int Cnt;
	//행숫자(페이징)
	private int rnum;
	// 상태(예정마감)
	private String stat;	
	private String isVoted; // 로그인한 mber투표 참여 , 미참여
	private String mberId;	// 로그인한아이디식별
	//직원 이름
	private String nm;
	//내가투표한항목 null이 들어가기 좋은 항목이라 Integer타입했습ㄴ디ㅏ
	private Integer myVoteIemNo;
	
	//VOTE_IEM 테이블
	List<VoteIemVO> voteIemVOList;
	
}
