package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.AnswerVO;

public interface AnswerService {

	// 댓글 목록 조회 (대댓글 포함)
	public List<AnswerVO> getAnswerList(long bbsDetailNo);
	
	// 댓글 등록
	public int insertAnswer(AnswerVO answerVO);
	
	// 댓글 상세 조회
	public AnswerVO getAnswer(long answerNo);
	
	// 댓글 수정
	public int updateAnswer(AnswerVO answerVO);
	
	// 댓글 삭제
	public int deleteAnswer(long answerNo);
	
	// 댓글 개수 조회
	public int getAnswerCount(long bbsDetailNo);
}
