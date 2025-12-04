package kr.or.ddit.util.scheduler;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Profile;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import kr.or.ddit.mapper.EmailQueueMapper;
import kr.or.ddit.service.EmailService;
import kr.or.ddit.vo.EmailQueueVO;
import lombok.extern.slf4j.Slf4j;

@Profile("server") 
@Component
@Slf4j
public class EmailScheduler {

    @Autowired
    private EmailQueueMapper emailQueueMapper;
    @Autowired
    private EmailService emailService;

    @Scheduled(cron = "*/3 * * * * *")
    public void sendPendingEmails() {
        try {
            int pendingCount = emailQueueMapper.countPendingEmails();
            log.info("[이메일 스케줄러 시작] 대기 중인 이메일: {} 개", pendingCount);
            
            if (pendingCount == 0) {
                log.info("[스케줄러] 발송할 이메일이 없습니다.");
                return;
            }
            
            List<EmailQueueVO> pendingEmails = emailQueueMapper.selectPendingEmails();
            log.info("[조회 결과] 처리할 이메일: {} 개", pendingEmails.size());
            
            int successCount = 0;
            int failCount = 0;
            
            for (EmailQueueVO emailQueue : pendingEmails) {
                log.info("[발송 중] EMAIL_ID: {}, RECIPIENT: {}, EMAIL_TYPE: {}", 
                		emailQueue.getEmailId(), 
                	    emailQueue.getRecipient(),
                	    emailQueue.getEmailType());
                
                boolean result = emailService.sendEmailFromQueue(emailQueue);
                
                if (result) {
                    successCount++;
                } else {
                    failCount++;
                }
                
                Thread.sleep(500);  // 간격 조정: 100ms → 500ms
            }
            
            log.info("[스케줄러 완료] 성공: {} 개, 실패: {} 개", successCount, failCount);
        } catch (Exception e) {
            log.error("❌ [스케줄러 오류]...", e);
        }
    }
}
