package kr.or.ddit.handler;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.fasterxml.jackson.databind.ObjectMapper;

@Component
public class ChatWebSocketHandler extends TextWebSocketHandler{  

    private final Set<WebSocketSession> sessions = ConcurrentHashMap.newKeySet();
    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception{
        sessions.add(session);
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception{

        Map<String,Object> msg = mapper.readValue(message.getPayload(),Map.class);
        String type = (String) msg.get("type");

        // 클라이언트 입장
        if("join".equals(type)) {
            String name = (String) msg.get("name");
            session.getAttributes().put("name", name);

            Map<String,Object> payload = Map.of(
                "type", "notice",
                "text", "📢 " + name + "님이 입장했습니다."
            );

            broadcast(payload);
            return;
        }

        // 일반 채팅
        if("chat".equals(type)) {
            String name = (String) session.getAttributes().get("name");
            String text = (String) msg.get("text");

            Map<String,Object> payload = new HashMap<>();
            payload.put("type", "chat");
            payload.put("name", name);
            payload.put("text", text);

            broadcast(payload);
            return;
        }

        // 타이핑 중
        if("typing".equals(type)) {
            String name = (String) session.getAttributes().get("name");

            Map<String,Object> payload = new HashMap<>();
            payload.put("type", "typing");
            payload.put("name", name);

            String json = mapper.writeValueAsString(payload);

            for(WebSocketSession s : sessions) {
                if(s.isOpen() && !s.equals(session)) {
                    synchronized (s) {
                        s.sendMessage(new TextMessage(json));
                    }
                }
            }
            return;
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception{
        sessions.remove(session);
        String name = (String) session.getAttributes().get("name");

        if(name != null) {
            Map<String,Object> payload = Map.of(
                "type", "notice",
                "text", "📢 " + name + "님이 퇴장했습니다."
            );
            broadcast(payload);
        }
    }

    // 수정된 broadcast (핵심 해결)
    private void broadcast(Map<String,Object> payload) throws Exception{

        String json = mapper.writeValueAsString(payload);

        for(WebSocketSession s : sessions) {
            if(s.isOpen()) {
                synchronized (s) {   // ★ 문제 완전 해결
                    s.sendMessage(new TextMessage(json));
                }
            }
        }
    }
}
