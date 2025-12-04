package kr.or.ddit.config;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionSubscribeEvent;

import kr.or.ddit.service.NtcnService;
import kr.or.ddit.vo.NtcnVO;

@Component
public class WebSocketEventListener {

    @Autowired
    private SimpMessagingTemplate simpMessagingTemplate;
    
    @Autowired
    private NtcnService ntcnService;

    // 구독 시 자동으로 미확인 리스트 전송
    // 이 코드가 없으면, 최초 로그인 후 새로운 알림이 오기 전까지 미확인 리스트가 조회 안됨. 
    @EventListener
    public void handleSubscribeEvent(SessionSubscribeEvent event) {
        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
        String destination = headerAccessor.getDestination();
        
        if (destination != null && destination.startsWith("/topic/ntcn/")) {
            String userId = destination.replace("/topic/ntcn/", "");
            
            if (!userId.equals("ALL_MBER") 
                    && !userId.equals("SYSTEM") 
                    && !userId.matches("\\d+")) {
                // 초기 미확인 리스트 전송
                List<NtcnVO> unreadList = ntcnService.getUnreadList(userId);
                
                NtcnVO initialData = new NtcnVO();
                initialData.setUnreadList(unreadList);
                
                simpMessagingTemplate.convertAndSend("/topic/ntcn/" + userId, initialData);
            }
        }
    }
}