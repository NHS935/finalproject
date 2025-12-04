package kr.or.ddit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.VoteIemVO;
import kr.or.ddit.vo.VoteMtrVO;
@Mapper
public interface VoteMtrMapper {
	
//	//투표생성
//	public int createVote(VoteMtrVO voteMtrVO);

	//읽기
	public List<VoteMtrVO> voteList(VoteMtrVO voteMtrVO);
	
	//투표안건+항목보기
//	public List<VoteIemVO> voteDetail();
	
	//상세보기
	public VoteMtrVO voteMtrList(VoteMtrVO voteMtrVO);
	
    public int addVote(VoteMtrVO voteMtrVO);

    public int addVoteIem(VoteIemVO voteIemVO);
	
	//등록(MTR+IEM)
	public int addVoteWithIems(VoteMtrVO voteMtrVO, List<VoteIemVO> voteIemVOList);


}
