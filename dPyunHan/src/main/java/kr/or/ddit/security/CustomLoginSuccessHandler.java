package kr.or.ddit.security;

import java.io.IOException;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Component;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.service.impl.CustomUser;
import kr.or.ddit.vo.MberVO;
import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

    private final HttpSessionRequestCache requestCache = new HttpSessionRequestCache();

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication auth) throws IOException, ServletException {

        CustomUser customUser = (CustomUser) auth.getPrincipal();
        MberVO mberVO = customUser.getMberVO();

        log.info("onAuthenticationSuccess -> mberVO : {}", mberVO);

        // 승인 여부 체크
        if (!"1".equals(mberVO.getEnabled())) {
            // 기존 세션 초기화
            request.getSession().invalidate();

            // 새 세션 생성 후 에러 메시지 저장
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("errorMsg", "APPROVAL_PENDING");

            response.sendRedirect("/login");
            return;
        }


        // 세션에 회원 정보 저장
        request.getSession().setAttribute("mberId", mberVO.getMberId());

        // 저장된 요청 가져오기
        SavedRequest savedRequest = requestCache.getRequest(request, response);

        if (savedRequest != null) {
            String targetUrl = savedRequest.getRedirectUrl();
            response.sendRedirect(targetUrl);
        } else {
            response.sendRedirect("/main");
        }
    }
}
