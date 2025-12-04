package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.VoteIemVO;
import kr.or.ddit.vo.VoteMtrVO;

public interface VoteMtrService {

	//읽기
	public List<VoteMtrVO> voteList(VoteMtrVO voteMtrVO);

	
	//상세보기
	public VoteMtrVO voteMtrList(VoteMtrVO voteMtrVO);
	
    public int addVote(VoteMtrVO voteMtrVO);

    public int addVoteIem(VoteIemVO voteIemVO);
	//등록(MTR+IEM)
	public int addVoteWithIems(VoteMtrVO voteMtrVO, List<VoteIemVO> voteIemVOList);


}
