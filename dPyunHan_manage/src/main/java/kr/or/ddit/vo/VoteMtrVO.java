package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;
	
@Data
public class VoteMtrVO {  
	private int voteMtrSn;  //투표 안건 일련번호
	private String mtrSj;  //안건 제목
	private String mtrCn;   //안건 내용
	private String voteBeginDt;  //투표 시작일
	private String voteEndDt;   //투표 종료일
	private String empId;    //직원id
	private int rnum;          // 페이지 번호용 (ROWNUM)
	private String stat;	// 상태(예정마감)
	//세부항목별 id숫자(alias)
	private int Cnt;
	
	private String nm;
	
	//VOTE_IEM 테이블
	List<VoteIemVO> voteIemVOList;
	
//	//VOTE_MANAGE_TRIGER 테이블
//	List<VoteManageTrgterVO> VoteManageTrgterVOList;
}
