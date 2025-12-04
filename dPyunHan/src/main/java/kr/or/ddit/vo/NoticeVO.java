package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class NoticeVO {
	
	private int noticeSn;
	private String noticeSj;
	private String noticeCn;
	private Date noticeWritngDt;
	private String empId;
	private long fileGroupSn;
	private int wnmpyNotice;
	
	//페이징 및 정렬용 순서
	private int rnum;
	
	private String nm;//직원이름
}
