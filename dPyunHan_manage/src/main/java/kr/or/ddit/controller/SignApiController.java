package kr.or.ddit.controller;

import kr.or.ddit.handler.SignWebSocketHandler;
import kr.or.ddit.service.PdfStampingService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor // (수정) 생성자 주입
public class SignApiController {

    // (수정) final 키워드 추가, @Autowired 삭제
    private final PdfStampingService pdfService;
    private final SignWebSocketHandler webSocketHandler;

    @PostMapping("/complete-signature")
    public ResponseEntity<String> completeSignature(@RequestBody Map<String, String> payload) {
        String sessionId = payload.get("sessionId");
        String imageData = payload.get("imageData"); // Base64 이미지 수신

        if (sessionId == null || imageData == null) {
            return ResponseEntity.badRequest().body("세션 ID 또는 이미지 데이터가 없습니다.");
        }

        try {
            // 1. PDF에 도장 찍고 새 파일 URL 받아오기
            String stampedPdfUrl = pdfService.stampPdf(sessionId, imageData);

            // 2. PC에 "완료" 신호 쏘기
            String message = String.format("{\"type\":\"signatureCompleted\", \"url\":\"%s\"}", stampedPdfUrl);
//            webSocketHandler.sendMessageToSession(sessionId, message);

            return ResponseEntity.ok("서명 완료. 이 창을 닫아주세요.");

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("서명 처리 중 오류 발생");
        }
    }
}