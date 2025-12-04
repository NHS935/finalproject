package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.VoteManageTrgterVO;
import kr.or.ddit.vo.VoteMtrVO;
@Mapper
public interface VoteManageTrgterMapper {
	//페이징추가
	//투표고르는페이지
	public List<VoteMtrVO> memVoteList(Map<String, Object> map);
	//전체행의수
	public int getTotal(Map<String, Object> map);
	//페이징추가 끝
	
	//투표할라고고르는페이지의 상세보기
	public VoteMtrVO voteMtrList(VoteMtrVO voteMtrVO);
	//update/insert (haveAVote)
	public int updateVote(VoteManageTrgterVO voteManageTrgterVO);
	public int insertVote(VoteManageTrgterVO voteManageTrgterVO);
	
	//empNm가져오기
	public String findEmpNm(String empId);
	
	//투표어디다했닝
	public Integer getMyVoteIemNo(String mberId, int voteMtrSn);

}
