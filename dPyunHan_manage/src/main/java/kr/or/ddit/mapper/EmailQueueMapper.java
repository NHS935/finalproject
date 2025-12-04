package kr.or.ddit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.EmailQueueVO;

@Mapper
public interface EmailQueueMapper {

	int insertEmailQueue(EmailQueueVO emailQueue);

	void updateEmailSent(int emailId);

	void updateEmailFailed(EmailQueueVO failedEmail);

	List<EmailQueueVO> selectPendingEmails();

	int countPendingEmails();
	
}
