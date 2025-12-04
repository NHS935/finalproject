package kr.or.ddit.handler;

import lombok.extern.slf4j.Slf4j; // [!!!] 1. (추가) Slf4j 로거 추가
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j // [!!!] 1. (추가) 로깅
@Component
public class SignWebSocketHandler extends TextWebSocketHandler {

    // [!!!] 3. (수정) 저장소의 Key는 "세션 ID"가 아닌 "보안 토큰(signToken)"입니다.
    private final Map<String, WebSocketSession> sessions = new ConcurrentHashMap<>();

    /**
     * [!!!] 4. (핵심 수정)
     * PC가 ws://.../ws/sign/{token} 으로 접속했을 때
     */
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {

        // 4-1. (신규) 세션의 URI에서 토큰을 추출합니다.
        String token = extractTokenFromSession(session);

        if (token != null) {
            // 4-2. (수정) UUID 대신 "추출한 토큰"을 Key로 세션을 저장합니다.
            sessions.put(token, session);
            log.info("[WS] PC 연결됨. 토큰: {}, 현재 접속자: {}명", token, sessions.size());

            // 4-3. (삭제) PC는 이미 토큰을 알고 있으므로,
            //      "sessionCreated" 메시지를 보낼 필요가 없습니다.
            // String message = String.format("{\"type\":\"sessionCreated\", ...
            // session.sendMessage(new TextMessage(message));

        } else {
            log.warn("[WS] 비정상적 연결 시도. (토큰 없음)");
            session.close(CloseStatus.BAD_DATA);
        }
    }

    /**
     * [!!!] 5. (수정) 비효율적인 탐색 대신, 토큰을 바로 추출하여 삭제합니다.
     */
    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        // 5-1. (신규) 닫힌 세션의 URI에서도 토큰을 추출합니다.
        String token = extractTokenFromSession(session);

        if (token != null) {
            // 5-2. (수정) 토큰 Key로 세션을 바로 제거합니다.
            sessions.remove(token);
            log.info("[WS] PC 연결 종료. 토큰: {}, 현재 접속자: {}명", token, sessions.size());
        }
    }

    /**
     * [!!!] 6. (수정) SignController와 이름/파라미터를 맞춥니다.
     * (API 컨트롤러가 호출할) 메시지 발송 함수
     *
     * @param token   메시지를 받을 대상(PC)의 토큰 (sessionId가 아님)
     * @param message 전송할 JSON 메시지 (e.g., {"type":"signatureCompleted", ...})
     */
    public void sendMessageToToken(String token, String message) throws IOException {
        WebSocketSession session = sessions.get(token);

        if (session != null && session.isOpen()) {
            session.sendMessage(new TextMessage(message));
            log.info("[WS] 메시지 발송 성공. 토큰: {}", token);
        } else {
            log.warn("[WS] 메시지 발송 실패: 세션이 닫혀있거나 없음. 토큰: {}", token);
        }
    }

    // [!!!] 7. (추가) URI에서 토큰을 추출하는 헬퍼 메서드
    /**
     * 세션 URI에서 토큰을 추출 (e.g., /ws/sign/a1b2c3d4... -> a1b2c3d4...)
     */
    private String extractTokenFromSession(WebSocketSession session) {
        try {
            // URI: /ws/sign/a1b2c3d4-xxxx-xxxx
            String uriPath = session.getUri().getPath();
            // 마지막 "/"의 인덱스를 찾아서 그 다음 문자열(토큰)을 반환
            return uriPath.substring(uriPath.lastIndexOf('/') + 1);
        } catch (Exception e) {
            log.error("[WS] 세션 URI에서 토큰 추출 실패", e);
            return null;
        }
    }

    // (참고: handleTextMessage, handleTransportError는 TextWebSocketHandler 기본 구현을 사용)
}