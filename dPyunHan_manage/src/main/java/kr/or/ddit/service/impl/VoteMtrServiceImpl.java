package kr.or.ddit.service.impl;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.enums.NtcnType;
import kr.or.ddit.mapper.VoteMtrMapper;
import kr.or.ddit.service.VoteMtrService;
import kr.or.ddit.util.NtcnUtil;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.vo.VoteIemVO;
import kr.or.ddit.vo.VoteMtrVO;
import lombok.extern.slf4j.Slf4j;
@Transactional
@Slf4j
@Service
public class VoteMtrServiceImpl implements VoteMtrService {

	@Autowired
	UploadController uploadController;
	

	@Autowired
	VoteMtrMapper voteMtrMapper;
	
	@Autowired
	NtcnUtil ntcnUtil;
    
	//페이징추가
	//조회(페이징추가)
	@Override
	public List<VoteMtrVO> voteList(Map<String, Object> map) {
		return this.voteMtrMapper.voteList(map);
	}
	//전체행의수
	@Override
	public int getTotal(Map<String, Object> map) {
		return this.voteMtrMapper.getTotal(map);
	}
	//페이징추가 끝
	

  //상세보기
	@Override
	public VoteMtrVO voteMtrList(VoteMtrVO voteMtrVO) {
		return this.voteMtrMapper.voteMtrList(voteMtrVO);
	}

    //투표 기본정보 db저장
	@Override
	public int addVote(VoteMtrVO voteMtrVO) {
		return this.voteMtrMapper.addVote(voteMtrVO);
	}

	//투표 항목(선택지) 저장
	@Override
	public int addVoteIem(VoteIemVO voteIemVO) {
		return this.voteMtrMapper.addVoteIem(voteIemVO);
	}
	
	//등록
	@Transactional
	@Override
	public int addVoteWithIems(VoteMtrVO voteMtrVO, List<VoteIemVO> voteIemVOList) { // 부모먼저INSERT
		//부모(투표 기본정보) insert
		int result1 = voteMtrMapper.addVote(voteMtrVO);
			
		for (VoteIemVO item : voteIemVOList) {
			item.setVoteMtrSn(voteMtrVO.getVoteMtrSn());
			//자식(투표 항목) insert
			voteMtrMapper.addVoteIem(item); 
		}
		
		//voteManageTrgterVO 조회(수신자)
		voteMtrVO = this.voteMtrMapper.voteMtrList(voteMtrVO);
		
		LocalDateTime dateTime = LocalDateTime.parse(voteMtrVO.getVoteEndDt());
		String formattedDate = dateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
		
		ntcnUtil.sendAdmin(voteMtrVO.getEmpId() , "ALL_MBER", NtcnType.VOTE, "새로운 \"" + voteMtrVO.getMtrSj() + "\" <br>투표가 등록되었습니다. <br>투표 기한은 " + formattedDate + "까지입니다."
							, "/vote/memVoteList");
		
		return result1;
	}
	//글쓴이 이름을 넣자
	@Override
	public String findEmpNm(String empId) {
		return this.voteMtrMapper.findEmpNm(empId);
	}






}
