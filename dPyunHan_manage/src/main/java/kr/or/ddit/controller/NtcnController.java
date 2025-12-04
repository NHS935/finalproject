package kr.or.ddit.controller;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.service.NtcnService;
import kr.or.ddit.service.impl.CustomUser;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.NtcnVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class NtcnController {

	@Autowired
	SimpMessagingTemplate simpMessagingTemplate;
	
    @Autowired
    NtcnService ntcnService;

	// 수신자
	@PostMapping("/ntcn/send")
	public void send(@RequestBody NtcnVO ntcnVO) {
		String rcverId = ntcnVO.getRcverId();

		// 단일 토픽 구조
		String destination = "/topic/ntcn/" + rcverId;
		
		// 미확인 리스트 조회 
		List<NtcnVO> unreadList = ntcnService.getUnreadList(rcverId);
		ntcnVO.setUnreadList(unreadList);

		simpMessagingTemplate.convertAndSend(destination, ntcnVO);
		log.info("[SEND] WebSocket 발행 성공 → 토픽: {}", destination);
	}
	
    @PostMapping("/ntcn/read/{ntcnSn}")
    public Map<String, Object> markAsRead(@PathVariable int ntcnSn) {
        int result = ntcnService.updateRedngAt(ntcnSn);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", result > 0);
        
        log.info("✅ 알림 읽음 처리: ntcnSn={}, result={}", ntcnSn, result);
        
        return response;
    }
    
    @GetMapping("/ntcn/unread")
    public Map<String, Object> getUnreadNotifications(
            @AuthenticationPrincipal CustomUser customUser) {
    	
    	Map<String, Object> response = new HashMap<>();
    	
        // 로그인 안 된 경우 빈 리스트 반환
        if (customUser == null) {
            response.put("unreadList", Collections.emptyList());
            return response;
        }
        
        EmpVO empVO = customUser.getEmpVO();
        String empId = empVO.getEmpId();
        String deptCode = empVO.getDeptCode();
        
        // 개인 알림 조회
        List<NtcnVO> personalList = ntcnService.getUnreadList(empId);
        // 부서 알림 조회
        List<NtcnVO> deptList = ntcnService.getUnreadList(deptCode);
        // 전체 입주민 알림 조회
        List<NtcnVO> allMberList = ntcnService.getUnreadList("ALL_EMP");
        
        // 합치기
        personalList.addAll(deptList);
        personalList.addAll(allMberList);
        
        personalList.sort((a, b) -> b.getRegistDt().compareTo(a.getRegistDt()));
        
        response.put("unreadList", personalList);
        
        log.info("전체 미확인 알림 조회: empId={}, count={}", empId, personalList.size());
        
        return response;
    }
}
