package kr.or.ddit.security;

import java.io.IOException;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CustomAccessDeniedHandler implements AccessDeniedHandler {

	@Override
	public void handle(HttpServletRequest request, HttpServletResponse response,
			AccessDeniedException accessDeniedException) throws IOException, ServletException {
		// 권한 부족시 로직을 구현함
		// ex) JSON형식의 403 forbidden 오류 반환
		// 인증(로그인)은 되었지만, 해당 리소스(/notice/regist)에 접근할 권한이 없는 사용자가 접근을 시도할 때
		// 	접근 거부 처리(AccessDeniedHandler)를 함. 보통 403 forbidden 오류 반환
//		response.setStatus(HttpServletResponse.SC_FORBIDDEN);
//		response.setContentType("application/json;charset=UTF-8");
//		response.getWriter().write("{\"error\":\"접근 권한이 없습니다.\"}");
		
		//ex2) redirect->요청URI->jsp forwarding
		response.sendRedirect("/accessError");
	}

}
