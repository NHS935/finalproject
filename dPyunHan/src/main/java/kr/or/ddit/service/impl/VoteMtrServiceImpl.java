package kr.or.ddit.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mapper.VoteMtrMapper;
import kr.or.ddit.service.VoteMtrService;
import kr.or.ddit.vo.VoteIemVO;
import kr.or.ddit.vo.VoteMtrVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class VoteMtrServiceImpl implements VoteMtrService {


	@Autowired
	VoteMtrMapper voteMtrMapper;



	// 조회
	@Override
	public List<VoteMtrVO> voteList(VoteMtrVO voteMtrVO) {
		// TODO Auto-generated method stub
		return this.voteMtrMapper.voteList(voteMtrVO);
	}

    //상세보기
	@Override
	public VoteMtrVO voteMtrList(VoteMtrVO voteMtrVO) {
		return this.voteMtrMapper.voteMtrList(voteMtrVO);
	}

	@Override
	public int addVote(VoteMtrVO voteMtrVO) {
		return this.voteMtrMapper.addVote(voteMtrVO);
	}

	@Override
	public int addVoteIem(VoteIemVO voteIemVO) {
		return this.voteMtrMapper.addVoteIem(voteIemVO);
	}
	
	//등록
	@Transactional
	@Override
	public int addVoteWithIems(VoteMtrVO voteMtrVO, List<VoteIemVO> voteIemVOList) { // 부모먼저INSERT
		//부모실행
		int result1 = voteMtrMapper.addVote(voteMtrVO);
			
		for (VoteIemVO item : voteIemVOList) {
			item.setVoteMtrSn(voteMtrVO.getVoteMtrSn());
			// 자식fk
			voteMtrMapper.addVoteIem(item); 
		}
		return result1;
	}






}
