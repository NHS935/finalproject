package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.VoteIemVO;
import kr.or.ddit.vo.VoteManageTrgterVO;
import kr.or.ddit.vo.VoteMtrVO;
@Mapper
public interface VoteMtrMapper {
	
//	//투표생성
//	public int createVote(VoteMtrVO voteMtrVO);

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
	
	//voteManageTrgterVO 조회(수신자)
	public VoteManageTrgterVO selectMberId(int voteMtrSn);

	//글쓴이 이름 넣자!
	public String findEmpNm(String empId);
}
