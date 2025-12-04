package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.VoteIemVO;
import kr.or.ddit.vo.VoteMtrVO;

public interface VoteMtrService {
	//페이징추가
	//읽기
	public List<VoteMtrVO> voteList(Map<String, Object> map);
	//전체행의수
	public int getTotal(Map<String, Object> map);
	//페이징추가 끝

	
	//상세보기
	public VoteMtrVO voteMtrList(VoteMtrVO voteMtrVO);
	
    public int addVote(VoteMtrVO voteMtrVO);

    public int addVoteIem(VoteIemVO voteIemVO);
	//등록(MTR+IEM)
	public int addVoteWithIems(VoteMtrVO voteMtrVO, List<VoteIemVO> voteIemVOList);
	//글쓴이 이름 넣자!
	public String findEmpNm(String empId);


}
