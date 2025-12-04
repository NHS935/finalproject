package kr.or.ddit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@RequestMapping("/sign")
@Controller
public class SignPageController {
    // 1. PC가 접속할 페이지 (QR 띄우는 곳)
    @GetMapping("/sign-page")
    public String signPage() {
        return "sign/sign-page"; // (WEB-INF/jsp/sign-page.jsp)
    }

    // 2. 모바일이 QR 스캔 후 접속할 페이지
    @GetMapping("/mobile-sign-page")
    public String mobileSignPage(@RequestParam String session, Model model) {
        // URL의 ?session=... 값을 받아서 모델에 담아줌
        model.addAttribute("sessionId", session);
        return "sign/mobile-sign-page"; // (WEB-INF/jsp/mobile-sign-page.jsp)
    }
    @GetMapping("/sign-pdf")
    public String signPdf() {
        return "sign/pdf-view"; // (WEB-INF/jsp/sign-page.jsp)
    }

}
