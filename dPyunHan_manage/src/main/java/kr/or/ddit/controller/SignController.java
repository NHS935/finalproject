package kr.or.ddit.controller; // (프로젝트의 컨트롤러 패키지 경로)

// --- 필수 Import ---
import kr.or.ddit.handler.SignWebSocketHandler;
import kr.or.ddit.mapper.FileMapper;
import kr.or.ddit.mapper.SigningRequestMapper;
import kr.or.ddit.service.PdfStampingService;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.SigningRequestVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * 전자 서명 프로세스(PC확인 -> 모바일QR -> 모바일서명)를 담당하는 컨트롤러
 *
 * @author Gemini
 * @version 1.0
 * @see SigningRequestMapper
 * @see FileMapper
 */
@Slf4j
@Controller
@RequestMapping("/sign")
@RequiredArgsConstructor // final 필드에 대한 생성자 자동 주입
public class SignController {

    /**
     * 서명 토큰(SIGNING_REQUEST) DB 접근용 매퍼
     */
    private final SigningRequestMapper signingRequestMapper;

    /**
     * 파일(FILE_DETAIL) DB 접근용 매퍼
     */
    private final FileMapper fileMapper;

    /**
     * [!!! TODO: 별도 구현 필요 !!!]
     * 최종 서명 처리를 담당할 서비스입니다.
     * (직인 찍힌 PDF + Base64 서명 이미지를 받아 -> 최종 PDF로 합성/저장/DB INSERT)
     */
    private final PdfStampingService pdfStampingService;

    private final SignWebSocketHandler signWebSocketHandler;


    /**
     * 1. PC에서 서명 문서를 확인하는 페이지 (PDF 뷰어 + "사인하러가기" 버튼)
     * - 엔드포인트: GET /sign/document
     * - 파라미터: ?token=...
     * - 반환: "sign/documentView" (PC용 JSP 뷰)
     */
    @GetMapping("/document")
    public String showSignPage(@RequestParam String token, Model model) {
        log.info("[PC] 서명 페이지 요청 수신. 토큰: {}", token);

        // 1. 토큰 검증 (헬퍼 메서드 사용)
        SigningRequestVO requestVO = signingRequestMapper.findRequestByToken(token);
        String errorMessage = validateToken(requestVO); // (null, 상태, 만료일 검사)

        if (errorMessage != null) {
            log.warn("[PC] 토큰 검증 실패: {}. 토큰: {}", errorMessage, token);
            model.addAttribute("errorMessage", errorMessage);
            return "errorPage"; // (공통 에러 페이지로 포워딩)
        }

        // 2. 토큰이 유효하면, 연결된 파일 정보를 조회
        Map<String, Object> map = new HashMap<>();
        map.put("fileGroupSn", requestVO.getFileGroupSn());
        map.put("fileNo", requestVO.getFileNo());
        FileDetailVO fileToSign = fileMapper.getFileDetail(map);

        if (fileToSign == null) {
            log.error("[PC] 치명적 오류: 토큰(O)은 유효하나 연결된 파일(X)이 없습니다. 토큰: {}", token);
            model.addAttribute("errorMessage", "문서를 불러오는 데 실패했습니다. (파일 누락)");
            return "errorPage";
        }

        // 3. 뷰(JSP)에 PC 화면 구성에 필요한 데이터를 전달
        model.addAttribute("fileVO", fileToSign);       // (PDF 뷰어의 iframe src용)
        model.addAttribute("signToken", token); // (QR코드 생성 및 폴링용)

        log.info("[PC] 서명 페이지로 이동. 파일명: {}", fileToSign.getFileOrginlNm());
        return "sign/documentView"; // (WEB-INF/views/sign/exdocumentView.jsp)
    }

    /**
     * 2. 모바일 기기에서 QR 스캔 시 열리는 서명 "전용" 페이지 (서명 캔버스)
     * - 엔드포인트: GET /sign/mobile
     * - 파라미터: ?token=...
     * - 반환: "sign/mobileSign" (모바일용 JSP 뷰)
     */
    @GetMapping("/mobile")
    public String showMobileSignPage(@RequestParam String token, Model model) {
        log.info("[Mobile] 모바일 서명 페이지 요청 수신. 토큰: {}", token);

        // 1. 모바일에서도 PC와 동일하게 토큰을 엄격히 검증
        SigningRequestVO requestVO = signingRequestMapper.findRequestByToken(token);
        String errorMessage = validateToken(requestVO);

        if (errorMessage != null) {
            log.warn("[Mobile] 토큰 검증 실패: {}. 토큰: {}", errorMessage, token);
            model.addAttribute("errorMessage", errorMessage);
            return "errorPage"; // (모바일용 에러 페이지가 있다면 분기)
        }

        // 2. 모바일은 PDF 뷰어가 필요 없으므로, 파일 "이름"만 조회
        Map<String, Object> map = new HashMap<>();
        map.put("fileGroupSn", requestVO.getFileGroupSn());
        map.put("fileNo", requestVO.getFileNo());
        FileDetailVO fileToSign = fileMapper.getFileDetail(map); // (getFileDetail 최적화 가능)

        if (fileToSign == null) {
            log.error("[Mobile] 치명적 오류: 토큰(O), 파일(X). 토큰: {}", token);
            model.addAttribute("errorMessage", "문서를 불러오는 데 실패했습니다. (파일 누락)");
            return "errorPage";
        }

        // 3. 뷰(JSP)에 모바일 화면 구성에 필요한 데이터를 전달
        model.addAttribute("fileName", fileToSign.getFileOrginlNm()); // (문서명 표시용)
        model.addAttribute("signToken", token); // (서명 제출 폼(form) 전송용)
        model.addAttribute("signerName", requestVO.getCcpyCmpnyNm()); // (서명자 이름 기본값)

        log.info("[Mobile] 모바일 서명 캔버스 페이지로 이동.");
        return "sign/mobileSign"; // (WEB-INF/views/sign/mobileSign.jsp)
    }

    /**
     * 3. [JSON] PC 화면이 서명 상태를 실시간 체크(Polling)하는 엔드포인트
     * - 엔드포인트: GET /sign/status
     * - 파라미터: ?token=...
     * - 반환: (JSON) {"status": "PENDING" | "COMPLETED" | "INVALID"}
     */
    @GetMapping("/status")
    @ResponseBody // ★ 중요: JSP 뷰가 아닌, JSON 데이터(Map)를 직접 반환
    public Map<String, String> getSignStatus(@RequestParam String token) {
        Map<String, String> response = new HashMap<>();
        SigningRequestVO requestVO = signingRequestMapper.findRequestByToken(token);

        if (requestVO == null) {
            response.put("status", "INVALID"); // 토큰 없음
        } else {
            // DB에 저장된 현재 상태 ("PENDING", "COMPLETED", "EXPIRED" 등)
            response.put("status", requestVO.getStatus());
        }

        // (로그 최소화: 이 로그는 2초마다 찍히므로, 디버그 시에만 활성화)
        // log.debug("[Polling] 상태 확인: {}", response.get("status"));
        return response;
    }

    /**
     * 4. 모바일에서 서명 "제출" 시 호출되는 엔드포인트 (최종 처리)
     * - 엔드포인트: POST /sign/submit
     * - 파라미터: (form data) token, signerName, signatureData (Base64)
     * - 반환: "redirect:/sign/complete" (완료 페이지 리다이렉트)
     */
    @PostMapping("/submit")
    public String processSign(@RequestParam String token,
                              @RequestParam String signerName,
                              @RequestParam String signatureData,
                              Model model,
                              RedirectAttributes redirectAttributes) {

        log.info("[Submit] 서명 제출 수신. 토큰: {}", token);

        // ... (1. 토큰 검증 로직 - 동일) ...
        SigningRequestVO requestVO = signingRequestMapper.findRequestByToken(token);
        String errorMessage = validateToken(requestVO);
        if (errorMessage != null) { /* ... (에러 처리 - 동일) ... */ }

        try {
            // ... (2. 원본 파일 조회 로직 - 동일) ...
            Map<String, Object> map = new HashMap<>();
            map.put("fileGroupSn", requestVO.getFileGroupSn());
            map.put("fileNo", requestVO.getFileNo());
            FileDetailVO stampedFileVO = fileMapper.getFileDetail(map);
            if (stampedFileVO == null) { /* ... (에러 처리 - 동일) ... */ }

            // ... (3. 서명 합성 서비스 호출 - 동일) ...
            FileDetailVO finalSignedFileVO = pdfStampingService.addSignatureToPdf(
                    stampedFileVO, signerName, signatureData
            );

            // ... (4. 토큰 상태 'COMPLETED' 변경 - 동일) ...
            signingRequestMapper.updateRequestStatus(token, "COMPLETED");

            // ... (5. 리다이렉트 VO 전달 - 동일) ...
            redirectAttributes.addFlashAttribute("signedFileVO", finalSignedFileVO);


            // [!!!] 6. (신규) 웹소켓 핸들러 호출 [!!!]
            // PC에게 "서명 완료" 메시지와 "최종 PDF 경로"를 푸시합니다.
            String finalPdfUrl = finalSignedFileVO.getFileStrelc();
            String jsonMessage = String.format("{\"type\": \"signatureCompleted\", \"url\": \"%s\"}", finalPdfUrl);

            signWebSocketHandler.sendMessageToToken(token, jsonMessage);


            // ... (7. 완료 페이지 리다이렉트 - 동일) ...
            return "redirect:/sign/complete";

        } catch (Exception e) {
            // ... (오류 처리 - 동일) ...
            log.error("[Submit] 서명 처리 중 심각한 오류 발생. 토큰: {}", token, e);
            model.addAttribute("errorMessage", "서명 처리 중 오류가 발생했습니다: " + e.getMessage());
            return "errorPage";
        }
    }

    /**
     * 5. 서명 완료 후 모바일/PC가 리다이렉트되는 최종 완료 페이지
     * - 엔드포인트: GET /sign/complete
     * - 반환: "sign/completeView" (완료 JSP 뷰)
     */
    @GetMapping("/complete")
    public String signComplete() {
        log.info("[Complete] 서명 완료 페이지 표시.");
        return "sign/completeView"; // (WEB-INF/views/sign/completeView.jsp)
    }


    // --- 헬퍼 메서드 ---
    /**
     * (private 헬퍼 메서드)
     * 토큰의 유효성을 검사(null, 상태, 만료)하고, 실패 시 오류 메시지를 반환합니다.
     *
     * @param requestVO DB에서 조회한 토큰 VO
     * @return null (성공), 또는 String (실패 메시지)
     */
    private String validateToken(SigningRequestVO requestVO) {
        if (requestVO == null) {
            return "유효하지 않은 서명 요청입니다. (토큰 없음)";
        }

        // (선택사항: 로그인 기반일 경우, 수신자 ID 검증)
        // Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        // String currentUserId = auth.getName();
        // if (requestVO.getRecipientId() != null && !currentUserId.equals(requestVO.getRecipientId())) {
        //     return "본인에게 요청된 서명 건이 아닙니다.";
        // }

        if (requestVO.getExpiryDate().before(new Date())) { // (new Date() == 현재 시간)
            log.warn("만료된 토큰 접근 시도: {}", requestVO.getSignToken());
            // (선택사항: 만료 시 상태를 EXPIRED로 자동 변경)
            // if ("PENDING".equals(requestVO.getStatus())) {
            //     signingRequestMapper.updateRequestStatus(requestVO.getSignToken(), "EXPIRED");
            // }
            return "서명 요청 기간이 만료되었습니다.";
        }

        // "COMPLETED" 또는 "EXPIRED" 등 PENDING이 아닌 모든 상태
        if (!"PENDING".equals(requestVO.getStatus())) {
            log.warn("이미 처리된 토큰 접근 시도: {}({})", requestVO.getSignToken(), requestVO.getStatus());
            return "이미 서명이 완료되었거나 유효하지 않은 요청입니다.";
        }

        return null; // 모든 검증 통과 (유효한 PENDING 상태의 토큰)
    }
}
