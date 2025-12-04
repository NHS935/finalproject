package kr.or.ddit.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import kr.or.ddit.enums.NtcnType;
import kr.or.ddit.service.NtcnService;
import kr.or.ddit.vo.NtcnVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class NtcnUtil {

	@Value("${server.url.admin:http://localhost:8020}")
	private String adminServerUrl;

	@Value("${server.url.mber:http://localhost:8272}")
	private String mberServerUrl;

	private final RestTemplate restTemplate = new RestTemplate();
	
	@Autowired
	private NtcnService ntcnService;

	// 발신자
	// 입주민단에 알림 보내기
	// 알림 + DB 저장 한 번에 처리
	public void sendAdmin(String dsptchmanId, String rcverId, NtcnType ntcnType, String ntcnCn, String ntcnUrl) {
		try {
			NtcnVO ntcnVO = new NtcnVO();
			ntcnVO.setDsptchmanId(dsptchmanId);
			ntcnVO.setRcverId(rcverId);
			ntcnVO.setNtcnTy(ntcnType);
			ntcnVO.setNtcnCn(ntcnCn);
			ntcnVO.setNtcnUrl(ntcnUrl);

			// DB 저장
			ntcnService.insertNtcn(ntcnVO);

			// WebSocket 발송
			restTemplate.postForObject(mberServerUrl + "/ntcn/send", ntcnVO, Void.class);

			log.info("[알림 전송 완료] → 대상: {}, 내용: {}", rcverId, ntcnCn);
		} catch (Exception e) {
			log.error("[알림 전송 실패]: " + e);
		}
	}
	
	// 발신자
	// 관리자단에 알림 보내기
	// 알림 + DB 저장 한 번에 처리
	public void sendUser(String dsptchmanId, String rcverId, NtcnType ntcnType, String ntcnCn, String ntcnUrl) {
		try {
			NtcnVO ntcnVO = new NtcnVO();
			ntcnVO.setDsptchmanId(dsptchmanId);
			ntcnVO.setRcverId(rcverId);
			ntcnVO.setNtcnTy(ntcnType);
			ntcnVO.setNtcnCn(ntcnCn);
			ntcnVO.setNtcnUrl(ntcnUrl);

			// DB 저장
			ntcnService.insertNtcn(ntcnVO);

			// WebSocket 발송
			restTemplate.postForObject(adminServerUrl + "/ntcn/send", ntcnVO, Void.class);

			log.info("[알림 전송 완료] → 대상: {}, 내용: {}", rcverId, ntcnCn);
		} catch (Exception e) {
			log.error("[알림 전송 실패]: " + e);
		}
	}
	
	// 관리비 알림 발송
	@Scheduled(cron = "0 35 11 4 12 ?")
    public void sendMonthlyManagect() {
    	
        // 발신자는 SYSTEM
    	// 알림 + DB 저장 한 번에 처리
        sendAdmin("SYSTEM", "ALL_MBER", NtcnType.MANAGECT, "이번 달 관리비가 고지되었습니다. 자세한 내용은 관리비 탭에서 확인하세요.", "/main");
    }

}
