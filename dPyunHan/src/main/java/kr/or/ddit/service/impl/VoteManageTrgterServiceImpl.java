package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mapper.VoteManageTrgterMapper;
import kr.or.ddit.service.VoteManageTrgterService;
import kr.or.ddit.vo.VoteManageTrgterVO;
import kr.or.ddit.vo.VoteMtrVO;
@Service
public class VoteManageTrgterServiceImpl implements VoteManageTrgterService{
	
	@Autowired
	VoteManageTrgterMapper voteManageTrgterMapper;
	
	
	
	//페이징추가
	//조회(페이징추가)
	@Transactional
	@Override
	public List<VoteMtrVO> memVoteList(Map<String, Object> map) {
		return this.voteManageTrgterMapper.memVoteList(map);
	}
	//전체행의수
	@Transactional
	@Override
	public int getTotal(Map<String, Object> map) {
		return this.voteManageTrgterMapper.getTotal(map);
	}
	//페이징추가 끝
	
    //투표할라고고르는페이지의 상세보기
	@Transactional
	@Override
	public VoteMtrVO voteMtrList(VoteMtrVO voteMtrVO) {
		return this.voteManageTrgterMapper.voteMtrList(voteMtrVO);
	}
	//update 시도 후 실패하면 insert 
	@Transactional
	@Override
	public int haveAVote(VoteManageTrgterVO voteManageTrgterVO) {
	    int updated = voteManageTrgterMapper.updateVote(voteManageTrgterVO);
	    if (updated == 0) {
	        return voteManageTrgterMapper.insertVote(voteManageTrgterVO);
	    }
	    return updated;
	}
	// empNm을 찾아오자
	@Override
	public String findEmpNm(String empId) {
		return this.voteManageTrgterMapper.findEmpNm(empId);
	}
	
	//투표어디다했닝
	public Integer getMyVoteIemNo(String mberId, int voteMtrSn) {
		return this.voteManageTrgterMapper.getMyVoteIemNo(mberId, voteMtrSn);
	}
}
