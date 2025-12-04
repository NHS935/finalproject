package kr.or.ddit.config;

import kr.or.ddit.handler.ChatWebSocketHandler;
import kr.or.ddit.handler.SignWebSocketHandler;
import lombok.RequiredArgsConstructor; // 롬복 임포트
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.web.socket.config.annotation.*;

@Configuration
@EnableWebSocketMessageBroker
@EnableScheduling
@EnableWebSocket
@RequiredArgsConstructor // (수정) 생성자 주입을 롬복이 대신함
public class WebSocketConfig implements WebSocketConfigurer, WebSocketMessageBrokerConfigurer {

    // (수정) final 키워드 추가
    private final SignWebSocketHandler signWebSocketHandler;
    private final ChatWebSocketHandler chatWebSocketHandler;   //나혜선 추가

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        // 브로커: 구독 경로
        registry.enableSimpleBroker("/topic");
        // 발신 경로 prefix
        registry.setApplicationDestinationPrefixes("/app");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // 웹소켓 연결 엔드포인트 (CORS 허용)
        registry.addEndpoint("/ws-ntcn")
                .setAllowedOriginPatterns("*")
                .withSockJS();
    }
    
    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        // 주입받은 핸들러 등록
        registry.addHandler(signWebSocketHandler, "/ws/sign/**")
                .setAllowedOrigins("*");
        
        //채팅용 websocket 추가(나혜선)
        registry.addHandler(chatWebSocketHandler, "/ws/chat")
                .setAllowedOrigins("*");
    }
    
   
    
}
