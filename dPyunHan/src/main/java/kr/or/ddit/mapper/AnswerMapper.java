package kr.or.ddit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.AnswerVO;

@Mapper
public interface AnswerMapper {

	// 댓글 목록 조회 (특정 게시글의 댓글들)
	public List<AnswerVO> getAnswerList(long bbsDetailNo);
	
	// 댓글 등록
	public int insertAnswer(AnswerVO answerVO);
	
	// 댓글 상세 조회
	public AnswerVO getAnswer(long answerNo);
	
	// 댓글 수정
	public int updateAnswer(AnswerVO answerVO);
	
	// 댓글 삭제
	public int deleteAnswer(long answerNo);
	
	// 대댓글 목록 조회 (특정 댓글의 대댓글들)
	public List<AnswerVO> getReplyList(long upperAnswerNo);
	
	// 댓글 개수 조회
	public int getAnswerCount(long bbsDetailNo);

	// 게시글 삭제를 위한 댓글 선 삭제
	public void deleteAnswersByBbsDelte(long bbsDetailNo);

	// 게시판 삭제를 위한 포함 게시글의 댓글 모두 삭제
	public void deleteAnswersByBbsGroup(long bbsGroupSn);
}
