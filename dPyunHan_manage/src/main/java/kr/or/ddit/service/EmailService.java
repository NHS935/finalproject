package kr.or.ddit.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import jakarta.mail.internet.MimeMessage;
import kr.or.ddit.mapper.EmailQueueMapper;
import kr.or.ddit.vo.BdderVO;
import kr.or.ddit.vo.CcpyManageVO;
import kr.or.ddit.vo.EmailQueueVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class EmailService {

	@Autowired
	private EmailQueueMapper emailQueueMapper;

	@Value("${app.mail.from-address}")
	private String fromAddress;

	@Value("${app.mail.from-name}")
	private String fromName;

	public boolean sendSimpleEmail(String toEmail, String subject, String body) {
		try {
			SimpleMailMessage message = new SimpleMailMessage();
			message.setFrom(fromAddress); // Brevo SMTP 계정
			message.setTo(toEmail); // 수신자 이메일
			message.setSubject(subject); // 제목
			message.setText(body); // 본문

			mailSender.send(message);
			System.out.println("이메일 발송 성공: " + toEmail);
			return true;

		} catch (Exception e) {
			System.out.println("❌ 이메일 발송 실패: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	// 협력업체 가입 승인 이메일 큐 등록
	public boolean queueCcpyApprovalEmail(CcpyManageVO ccpyManageVO) {
		try {
			String subject = "협력업체 가입 승인 완료";
			String htmlBody = buildCcpyApprovalBody(ccpyManageVO);

			EmailQueueVO emailQueue = new EmailQueueVO();
			emailQueue.setRecipient(ccpyManageVO.getCcpyEmail());
			emailQueue.setSubject(subject);
			emailQueue.setBody(htmlBody);
			emailQueue.setEmailType("APPROVAL");

			int result = emailQueueMapper.insertEmailQueue(emailQueue);
			return result > 0;
		} catch (Exception e) {
			log.error("메일 큐 등록 실패", e);
			return false;
		}
	}

	// 협력업체 등록 거절 이메일 큐 등록
	public boolean queueCcpyRejectionEmail(CcpyManageVO ccpyManageVO, String rejectReason) {
		try {
			String subject = "협력업체 가입 승인 거절";
			String htmlBody = buildCcpyRejectionBody(ccpyManageVO, rejectReason);

			EmailQueueVO emailQueue = new EmailQueueVO();
			emailQueue.setRecipient(ccpyManageVO.getCcpyEmail());
			emailQueue.setSubject(subject);
			emailQueue.setBody(htmlBody);
			emailQueue.setEmailType("REJECTION");

			int result = emailQueueMapper.insertEmailQueue(emailQueue);
			return result > 0;
		} catch (Exception e) {
			log.error("메일 큐 등록 실패", e);
			return false;
		}
	}

	// 입찰 낙찰 이메일 큐 등록
	public boolean queueBidSelectionEmail(BdderVO bdderVO) {
		try {
			String subject = "입찰 낙찰 선정 완료 안내";
			String htmlBody = buildBidSelectionBody(bdderVO);

			EmailQueueVO emailQueue = new EmailQueueVO();
			emailQueue.setRecipient(bdderVO.getCcpyManageVO().getCcpyEmail());
			emailQueue.setSubject(subject);
			emailQueue.setBody(htmlBody);
			emailQueue.setEmailType("BID_SELECTION");

			int result = emailQueueMapper.insertEmailQueue(emailQueue);
			return result > 0;
		} catch (Exception e) {
			log.error("메일 큐 등록 실패", e);
			return false;
		}
	}

	// 실제 발송 (스케줄러에서 호출함)
	@Autowired
	private JavaMailSender mailSender;

	public boolean sendEmailFromQueue(EmailQueueVO emailQueue) {
		try {
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
			helper.setFrom(fromAddress, fromName);
			helper.setTo(emailQueue.getRecipient());
			helper.setSubject(emailQueue.getSubject());
			helper.setText(emailQueue.getBody(), true);
			mailSender.send(message);

			emailQueueMapper.updateEmailSent(emailQueue.getEmailId());
			return true;
		} catch (Exception e) {
			EmailQueueVO failedEmail = new EmailQueueVO();
			failedEmail.setEmailId(emailQueue.getEmailId());
			failedEmail.setStatus(emailQueue.getRetryCount() >= 2 ? "FAILED" : "PENDING");
			failedEmail.setErrorMsg(e.getMessage());
			emailQueueMapper.updateEmailFailed(failedEmail);
			log.error("이메일 발송 실패: {}", e.getMessage());
			return false;
		}
	}

	/**
	 * HTML 형식 이메일 발송 (더 예쁜 이메일)
	 */
	public boolean sendHtmlEmail(String toEmail, String subject, String htmlBody) {
		try {
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

			helper.setFrom(fromAddress);
			helper.setTo(toEmail);
			helper.setSubject(subject);
			helper.setText(htmlBody, true); // true = HTML 형식

			mailSender.send(message);
			System.out.println("✅ HTML 이메일 발송 성공: " + toEmail);
			return true;

		} catch (Exception e) {
			System.out.println("❌ HTML 이메일 발송 실패: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	/**
	 * 텍스트 형식 나중에 HTML형식 못생기면 이거로 함 일단 냅두기
	 * 
	 * 협력업체 승인 이메일 발송 public boolean sendApprovalEmail(CcpyManageVO ccpyManageVO) {
	 * String subject = "협력업체 가입 승인 완료"; String body = "안녕하세요 " +
	 * ccpyManageVO.getCcpyRprsntvNm() + "님,\n\n" + "협력업체(" +
	 * ccpyManageVO.getCcpyCmpnyNm() + ") 가입이 관리사무소의 승인으로 완료되었습니다.\n" + "회사명: " +
	 * ccpyManageVO.getCcpyCmpnyNm() + "\n" + "대표자명: " +
	 * ccpyManageVO.getCcpyRprsntvNm() + "\n" + "사업자등록번호: " +
	 * ccpyManageVO.getCcpyBizrno() + "\n\n" + "이제 시스템을 이용하실 수 있습니다.\n\n" +
	 * "감사합니다.";
	 * 
	 * return sendSimpleEmail(ccpyManageVO.getCcpyEmail() , subject, body); }
	 */

	/**
	 * 협력업체 승인 이메일 발송 (HTML 형식 - 더 예쁨)
	 */
	  private String buildCcpyApprovalBody(CcpyManageVO ccpyManageVO) {		
		String htmlBody = "<html>" + "<body style='font-family: Arial, sans-serif; line-height: 1.6;'>"
				+ "<h2 style='color: #333; border-bottom: 2px solid #007bff; padding-bottom: 10px;'>🎉 협력업체 가입 승인 완료</h2>"
				+ "<p>안녕하세요 <strong>" + ccpyManageVO.getCcpyRprsntvNm() + "</strong>님,</p>" + "<p><strong>"
				+ ccpyManageVO.getCcpyCmpnyNm() + "</strong> 협력업체 가입이 관리사무소의 승인으로 완료되었습니다.</p>"
				+ "<hr style='border: none; border-top: 1px solid #ddd; margin: 20px 0;'>"
				+ "<h3 style='color: #333;'>📋 협력업체 정보</h3>" + "<table style='width: 100%; border-collapse: collapse;'>"
				+ "<tr style='background-color: #f5f5f5;'>"
				+ "<td style='padding: 10px; border: 1px solid #ddd; font-weight: bold; width: 30%;'>회사명</td>"
				+ "<td style='padding: 10px; border: 1px solid #ddd;'>" + ccpyManageVO.getCcpyCmpnyNm() + "</td>"
				+ "</tr>" + "<tr>" + "<td style='padding: 10px; border: 1px solid #ddd; font-weight: bold;'>대표자명</td>"
				+ "<td style='padding: 10px; border: 1px solid #ddd;'>" + ccpyManageVO.getCcpyRprsntvNm() + "</td>"
				+ "</tr>" + "<tr style='background-color: #f5f5f5;'>"
				+ "<td style='padding: 10px; border: 1px solid #ddd; font-weight: bold;'>사업자등록번호</td>"
				+ "<td style='padding: 10px; border: 1px solid #ddd;'>" + ccpyManageVO.getCcpyBizrno() + "</td>"
				+ "</tr>" + "<tr>" + "<td style='padding: 10px; border: 1px solid #ddd; font-weight: bold;'>주소</td>"
				+ "<td style='padding: 10px; border: 1px solid #ddd;'>" + ccpyManageVO.getCcpyAdres() + "</td>"
				+ "</tr>" + "<tr style='background-color: #f5f5f5;'>"
				+ "<td style='padding: 10px; border: 1px solid #ddd; font-weight: bold;'>전화번호</td>"
				+ "<td style='padding: 10px; border: 1px solid #ddd;'>" + ccpyManageVO.getCcpyTelno() + "</td>"
				+ "</tr>" + "</table>" + "<hr style='border: none; border-top: 1px solid #ddd; margin: 20px 0;'>"
				+ "<p style='background-color: #e8f5e9; padding: 15px; border-radius: 5px; border-left: 4px solid #4caf50; margin: 20px 0;'>"
				+ "<strong style='color: #2e7d32;'>✅ 이제 시스템을 이용하실 수 있습니다!</strong>" + "</p>" + "<p>감사합니다.</p>"
				+ "<hr style='border: none; border-top: 1px solid #ddd; margin: 20px 0;'>" + "</body>" + "</html>";

		return htmlBody; 
	}

	/**
	 * 협력업체 가입 거절 이메일 발송
	 */
	  private String buildCcpyRejectionBody(CcpyManageVO ccpyManageVO, String rejectReason) {
		String htmlBody = "<html>" + "<body style='font-family: Arial, sans-serif; line-height: 1.6;'>"
				+ "<h2 style='color: #d32f2f;'>❌ 협력업체 가입 승인 거절</h2>" + "<p>안녕하세요 " + ccpyManageVO.getCcpyRprsntvNm()
				+ "님,</p>" + "<p>죄송하지만 협력업체 가입 승인이 거절되었습니다.</p>"
				+ "<hr style='border: none; border-top: 1px solid #ddd; margin: 20px 0;'>"
				+ "<h3 style='color: #d32f2f;'>거절 사유</h3>"
				+ "<p style='background-color: #ffebee; padding: 15px; border-radius: 5px; border-left: 4px solid #d32f2f;'>"
				+ rejectReason + "</p>" + "<hr style='border: none; border-top: 1px solid #ddd; margin: 20px 0;'>"
				+ "<p>추가 문의사항은 관리사무소로 연락 주시기 바랍니다.</p>" + "<p>감사합니다.</p>" + "</body>" + "</html>";

		return htmlBody;
	}

	/**
	 * 협력업체 낙찰(선정) 이메일 발송
	 */
	  private String buildBidSelectionBody(BdderVO bdderVO) {
		String htmlBody = "<html>" + "<head>" + "<meta charset='UTF-8'>" + "</head>"
				+ "<body style='font-family: Arial, sans-serif; line-height: 1.6; color: #333;'>"
				+ "<div style='max-width: 600px; margin: 0 auto; background-color: #f9f9f9; padding: 20px; border-radius: 10px;'>"
				+

				// 헤더
				"<h2 style='color: #007bff; border-bottom: 3px solid #007bff; padding-bottom: 10px; margin-bottom: 20px;'>"
				+ "🎉 입찰 낙찰 선정 완료</h2>" +

				// 인사말
				"<p>안녕하세요 <strong>" + bdderVO.getCcpyManageVO().getCcpyRprsntvNm() + "</strong>님,</p>"
				+ "<p style='font-size: 16px; color: #2e7d32;'>"
				+ "<strong>축하합니다!</strong> 귀사가 입찰한 건이 <strong>낙찰</strong> 선정되었습니다." + "</p>" +

				// 구분선
				"<hr style='border: none; border-top: 2px solid #007bff; margin: 25px 0;'>" +

				// 입찰 정보
				"<h3 style='color: #333; margin-bottom: 15px;'>📋 입찰 정보</h3>"
				+ "<table style='width: 100%; border-collapse: collapse; margin-bottom: 20px;'>"
				+ "<tr style='background-color: #e3f2fd;'>"
				+ "<td style='padding: 12px; border: 1px solid #90caf9; font-weight: bold; width: 35%;'>입찰번호</td>"
				+ "<td style='padding: 12px; border: 1px solid #90caf9;'>"
				+ bdderVO.getBidPblancVO().getBidPblancSnAsStr() + "</td>" + "</tr>" + "<tr>"
				+ "<td style='padding: 12px; border: 1px solid #90caf9; font-weight: bold;'>입찰제목</td>"
				+ "<td style='padding: 12px; border: 1px solid #90caf9;'>" + bdderVO.getBidPblancVO().getBidSj()
				+ "</td>" + "</tr>" + "<tr style='background-color: #e3f2fd;'>"
				+ "<td style='padding: 12px; border: 1px solid #90caf9; font-weight: bold;'>낙찰방법</td>"
				+ "<td style='padding: 12px; border: 1px solid #90caf9;'>" + bdderVO.getBidPblancVO().getScsbMthAsStr()
				+ "</td>" + "</tr>" + "</table>" +

				// 구분선
				"<hr style='border: none; border-top: 2px solid #007bff; margin: 25px 0;'>" +

				// 입찰가 정보
				"<h3 style='color: #333; margin-bottom: 15px;'>💰 입찰가 정보</h3>"
				+ "<table style='width: 100%; border-collapse: collapse; margin-bottom: 20px;'>"
				+ "<tr style='background-color: #fff3e0;'>"
				+ "<td style='padding: 12px; border: 1px solid #ffe0b2; font-weight: bold; width: 35%;'>입찰가격</td>"
				+ "<td style='padding: 12px; border: 1px solid #ffe0b2; font-size: 16px; color: #e65100;'>" + "<strong>"
				+ formatCurrency(bdderVO.getBidAmount()) + "</strong>" + "</td>" + "</tr>" + "<tr>"
				+ "<td style='padding: 12px; border: 1px solid #ffe0b2; font-weight: bold;'>입찰보증금</td>"
				+ "<td style='padding: 12px; border: 1px solid #ffe0b2; font-size: 14px;'>"
				+ formatCurrency(bdderVO.getBidGtn()) + "</td>" + "</tr>" + "<tr style='background-color: #fff3e0;'>"
				+ "<td style='padding: 12px; border: 1px solid #ffe0b2; font-weight: bold;'>입찰일시</td>"
				+ "<td style='padding: 12px; border: 1px solid #ffe0b2;'>" + formatDate(bdderVO.getBidSportDt())
				+ "</td>" + "</tr>" + "</table>" +

				// 구분선
				"<hr style='border: none; border-top: 2px solid #007bff; margin: 25px 0;'>" +

				// 협력업체 정보
				"<h3 style='color: #333; margin-bottom: 15px;'>🏢 협력업체 정보</h3>"
				+ "<table style='width: 100%; border-collapse: collapse; margin-bottom: 20px;'>"
				+ "<tr style='background-color: #f3e5f5;'>"
				+ "<td style='padding: 12px; border: 1px solid #ce93d8; font-weight: bold; width: 35%;'>회사명</td>"
				+ "<td style='padding: 12px; border: 1px solid #ce93d8;'>" + bdderVO.getCcpyManageVO().getCcpyCmpnyNm()
				+ "</td>" + "</tr>" + "<tr>"
				+ "<td style='padding: 12px; border: 1px solid #ce93d8; font-weight: bold;'>대표자명</td>"
				+ "<td style='padding: 12px; border: 1px solid #ce93d8;'>"
				+ bdderVO.getCcpyManageVO().getCcpyRprsntvNm() + "</td>" + "</tr>"
				+ "<tr style='background-color: #f3e5f5;'>"
				+ "<td style='padding: 12px; border: 1px solid #ce93d8; font-weight: bold;'>사업자등록번호</td>"
				+ "<td style='padding: 12px; border: 1px solid #ce93d8;'>" + bdderVO.getCcpyManageVO().getCcpyBizrno()
				+ "</td>" + "</tr>" + "<tr>"
				+ "<td style='padding: 12px; border: 1px solid #ce93d8; font-weight: bold;'>전화번호</td>"
				+ "<td style='padding: 12px; border: 1px solid #ce93d8;'>" + bdderVO.getCcpyManageVO().getCcpyTelno()
				+ "</td>" + "</tr>" + "<tr style='background-color: #f3e5f5;'>"
				+ "<td style='padding: 12px; border: 1px solid #ce93d8; font-weight: bold;'>이메일</td>"
				+ "<td style='padding: 12px; border: 1px solid #ce93d8;'>" + bdderVO.getCcpyManageVO().getCcpyEmail()
				+ "</td>" + "</tr>" + "</table>" +

				// 구분선
				"<hr style='border: none; border-top: 2px solid #007bff; margin: 25px 0;'>" +

				// 중요 안내사항
				"<div style='background-color: #c8e6c9; padding: 15px; border-radius: 5px; border-left: 5px solid #2e7d32; margin: 20px 0;'>"
				+ "<p style='margin: 0; color: #1b5e20;'>" + "<strong>✅ 중요 안내사항</strong><br/>"
				+ "• 낙찰 계약 진행을 위해 관리사무소로 연락주시기 바랍니다.<br/>" + "• 입찰보증금은 계약 체결 후 반환 또는 계약금으로 환산됩니다.<br/>"
				+ "• 계약서 작성 일정은 별도 통보 예정입니다." + "</p>" + "</div>" +

				// 마무리
				"<p style='margin-top: 30px; color: #666; font-size: 14px; border-top: 1px solid #ddd; padding-top: 15px;'>"
				+ "이 이메일은 발신 전용입니다. 추가 문의사항은 D-편한아파트 관리사무소로 연락 주시기 바랍니다.<br/>" + "감사합니다." + "</p>" +

				"</div>" + "</body>" + "</html>";

		return htmlBody;
	}

	/**
	 * 금액 포맷팅 (숫자에 쉼표 추가)
	 */
	private String formatCurrency(long amount) {
		return String.format("%,d원", amount);
	}

	/**
	 * 날짜 포맷팅
	 */
	private String formatDate(java.util.Date date) {
		if (date == null) {
			return "-";
		}
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy년 MM월 dd일 HH:mm:ss");
		return sdf.format(date);
	}

}