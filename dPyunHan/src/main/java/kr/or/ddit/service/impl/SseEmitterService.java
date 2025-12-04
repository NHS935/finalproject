package kr.or.ddit.service.impl;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@Service
public class SseEmitterService {

	private final Map<String, SseEmitter> emitterMap = new ConcurrentHashMap<>();

	public SseEmitter subscribe(String receiverId) {
		SseEmitter emitter = new SseEmitter(Long.MAX_VALUE);
		emitterMap.put(receiverId, emitter);

		emitter.onCompletion(() -> emitterMap.remove(receiverId));
		emitter.onTimeout(() -> emitterMap.remove(receiverId));

		return emitter;
	}

	public void sendToClient(String receiverId, String message) {
		SseEmitter emitter = emitterMap.get(receiverId);
		if (emitter != null) {
			try {
				emitter.send(SseEmitter.event().name("notification").data(message));
			} catch (IOException e) {
				emitterMap.remove(receiverId);
			}
		}
	}
}
