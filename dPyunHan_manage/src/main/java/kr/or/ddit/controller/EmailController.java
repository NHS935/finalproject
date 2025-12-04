package kr.or.ddit.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import kr.or.ddit.service.EmailService;
import kr.or.ddit.vo.CcpyManageVO;
import java.util.HashMap;
import java.util.Map;
import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/email")
@Slf4j
public class EmailController {

	@Autowired
	private EmailService emailService;

	/**
	 * 협력업체 승인 이메일 발송 POST /api/email/ccpy/approval
	 */
	@PostMapping("/ccpy/approval")
	public Map<String, Object> sendCcpyApprovalEmail(@RequestBody CcpyManageVO ccpyManageVO) {
		Map<String, Object> resultMap = new HashMap<>();
		boolean result = emailService.queueCcpyApprovalEmail(ccpyManageVO);
		resultMap.put("success", result);
		resultMap.put("message", result ? "발송 이메일에 등록 완료, 수 분 내 발송" : "❌ 이메일 등록 실패");
		return resultMap;
	}

	/**
	 * 협력업체 거절 이메일 발송 POST /api/email/ccpy/rejection
	 */
	@PostMapping("/ccpy/rejection")
	public Map<String, Object> sendCcpyRejectionEmail(@RequestBody CcpyManageVO ccpyManageVO,
			@RequestParam String rejectReason) {

		Map<String, Object> resultMap = new HashMap<>();
        boolean result = emailService.queueCcpyRejectionEmail(ccpyManageVO, rejectReason);
        resultMap.put("success", result);
        resultMap.put("message", result ? "발송 이메일에 등록 완료, 수 분 내 발송" : "❌ 이메일 등록 실패");
        return resultMap;
	}

	/**
	 * 테스트: 간단한 이메일 발송 POST /api/email/test/simple
	 */
	@PostMapping("/test/simple")
	public Map<String, Object> sendSimpleEmail(@RequestParam String email, @RequestParam String subject,
			@RequestParam String body) {

		Map<String, Object> resultMap = new HashMap<>();

		try {
			boolean result = emailService.sendSimpleEmail(email, subject, body);

			resultMap.put("success", result);
			resultMap.put("message", result ? "✅ 이메일 발송 완료" : "❌ 발송 실패");
			resultMap.put("email", email);

		} catch (Exception e) {
			resultMap.put("success", false);
			resultMap.put("message", "❌ 에러: " + e.getMessage());
		}

		return resultMap;
	}
}