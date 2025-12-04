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
import kr.or.ddit.service.impl.CustomUser;
import kr.or.ddit.vo.CcpyManageVO;
import kr.or.ddit.vo.EmpVO;
import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j 
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

	//HttpSessionRequestCache : 로그인 하기 전에 사용자가 요청했던 URL(/product/addProduct)을 세션에 저장해주는 객체
	   private final HttpSessionRequestCache requestCache 
	      = new HttpSessionRequestCache(); 
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication auth) throws IOException, ServletException {
		
		CustomUser customUser = (CustomUser)auth.getPrincipal();
		String userType = customUser.getUserType();
		String targetUrl = null;
		
		if ("EMP".equals(userType)) {
			EmpVO empVO = customUser.getEmpVO();
			log.info("직원 로그인 성공: {}", empVO);
			targetUrl = "/main";  
		} else if ("CCPY".equals(userType)) {
			CcpyManageVO ccpyManageVO = customUser.getCcpyManageVO();
			log.info("협력업체 로그인 성공: {}", ccpyManageVO);
			targetUrl = "/bidPblanc/getBidPblancList"; 
		}

		
		//특정 페이지로 리다이렉트
//		response.sendRedirect("/notice/list");
		
		// reqeustCache : 세션에 저장되어 있는 로그인 전 요청 객체
		//                               요청을 get(요청객체, 응답객체)
	    // savedRequest : 사용자가 인증 없이 접근했던 URL(/product/addProduct)이 여기에 저장되어 있음
		SavedRequest savedRequest = requestCache.getRequest(request, response);
		log.info("savedRequest: {}", savedRequest);  // ✅ 디버깅
		
		// 1. SavedRequest 우선
	    if(savedRequest != null) {
	        String redirectUrl = savedRequest.getRedirectUrl();
	        log.info("SavedRequest로 리다이렉트: {}", redirectUrl);
	        response.sendRedirect(redirectUrl);
	        return;
	    }

	    // 2. Referer 헤더 확인 (이전 페이지)
	    String referer = request.getHeader("Referer");
	    log.info("Referer: {}", referer);
	    
	    if (referer != null && 
	        (referer.contains("/bdder/") || referer.contains("/bidPblanc/"))) {
	        log.info("Referer로 리다이렉트: {}", referer);
	        response.sendRedirect(referer);
	        return;
	    }

	    // 3. 세션의 originalUrl 확인
	    String originalUrl = (String) request.getSession().getAttribute("originalUrl");
	    if (originalUrl != null && !originalUrl.isEmpty()) {
	        log.info("세션 originalUrl로 리다이렉트: {}", originalUrl);
	        request.getSession().removeAttribute("originalUrl");
	        response.sendRedirect(originalUrl);
	        return;
	    }

	    // 4. 기본값
	    log.info("기본값 targetUrl로 리다이렉트: {}", targetUrl);
	    response.sendRedirect(targetUrl != null ? targetUrl : "/login");
	}

}
