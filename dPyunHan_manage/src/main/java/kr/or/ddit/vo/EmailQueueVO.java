package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class EmailQueueVO {
	private int emailId;
	private String recipient;
	private String subject;
	private String body;
	private String emailType;
	private String status;
	private int retryCount;
	private Date createdAt;
	private Date sentAt;
	private String errorMsg;
}
