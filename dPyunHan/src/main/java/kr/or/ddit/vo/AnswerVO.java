package kr.or.ddit.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class AnswerVO {
	
	private String mberId;
	private long answerNo;
	private long bbsDetailNo;
	private long bbsGroupSn;
	private String cn;
	private Date writngDt;
	private Long upperAnswerNo;
	
	private List<AnswerVO> replyList;

}
