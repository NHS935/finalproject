package kr.or.ddit.security;

import java.io.IOException;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CustomLogoutSuccessHandler implements LogoutSuccessHandler {

												// 요청객체						응답객체						인증객체
	@Override
	public void onLogoutSuccess(HttpServletRequest req, HttpServletResponse resp, Authentication auth)
			throws IOException, ServletException {
		// 로그아웃 성공 시 실행함
		if(auth!=null && auth.getDetails()!=null) {// 로그인 되어있다면
			try{
				HttpSession session = req.getSession();
				session.invalidate(); // 세션의 속성을 모두 제거
			}catch(Exception e) {
				// 세션 무효화 중 오류 발생 시 예외 처리
				e.printStackTrace();
			}
		}
		
		//ex) JSON 응답으로 로그아웃 성공 메시지 반환
//		resp.setStatus(HttpServletResponse.SC_OK); //http 상태 코드 : 200
//		resp.setContentType("application/json;charset=UTF-8");
//		resp.getWriter().write("{\"message\":\"로그아웃 성공!\"}");
		
		//ex2) 로그인 URL로 리다이렉트
		resp.sendRedirect("/login?logout");
	}
}
