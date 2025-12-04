package kr.or.ddit.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.enums.NtcnType;
import kr.or.ddit.mapper.AnswerMapper;
import kr.or.ddit.service.AnswerService;
import kr.or.ddit.service.BbsService;
import kr.or.ddit.util.NtcnUtil;
import kr.or.ddit.vo.AnswerVO;
import kr.or.ddit.vo.BbsDetailVO;

@Service
public class AnswerServiceImpl implements AnswerService {
	
	@Autowired
	AnswerMapper answerMapper;
	
	@Autowired
	BbsService bbsService;
	
	@Autowired
	NtcnUtil ntcnUtil;

	@Override
	public List<AnswerVO> getAnswerList(long bbsDetailNo) {
		// 1. 최상위 댓글들을 조회
		List<AnswerVO> answerList = this.answerMapper.getAnswerList(bbsDetailNo);
		
		// 2. 각 댓글의 대댓글들을 조회하여 세팅
		for(AnswerVO answerVO : answerList) {
			List<AnswerVO> replyList = this.answerMapper.getReplyList(answerVO.getAnswerNo());
			answerVO.setReplyList(replyList);
		}
		
		return answerList;
	}

	@Transactional(rollbackFor = Exception.class)
	@Override
	public int insertAnswer(AnswerVO answerVO) {
		// 1. 댓글 등록
		int result = this.answerMapper.insertAnswer(answerVO);
		
		// 2. 원글 작성자(게시글) 정보 조회
		BbsDetailVO originalPostVO = this.bbsService.bbsDetail(answerVO.getBbsDetailNo());

		ntcnUtil.sendUser(answerVO.getMberId(), originalPostVO.getMberId(), NtcnType.BBS, "본인이 작성한 \"" + originalPostVO.getSj() + "\"<br>글에 댓글이 등록되었습니다."
    			,"/bbs/board/" + originalPostVO.getBbsGroupSn() + "?openDetail=" + answerVO.getBbsDetailNo()); 
		
		return result;
	}

	@Override
	public AnswerVO getAnswer(long answerNo) {
		return this.answerMapper.getAnswer(answerNo);
	}

	@Override
	public int updateAnswer(AnswerVO answerVO) {
		return this.answerMapper.updateAnswer(answerVO);
	}

	@Override
	public int deleteAnswer(long answerNo) {
		return this.answerMapper.deleteAnswer(answerNo);
	}

	@Override
	public int getAnswerCount(long bbsDetailNo) {
		return this.answerMapper.getAnswerCount(bbsDetailNo);
	}
}
