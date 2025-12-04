package kr.or.ddit.controller;

import java.security.Principal;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ChatController {

	
	@GetMapping("/chat")
	public String chatPage(Model model, Principal principal, HttpServletResponse response) throws Exception {
		
		log.info("/왔음");
		
		//로그인이 안된 경우
		if(principal == null) {
			log.debug("principal(로그인 전) : ",principal);
			
			response.setContentType("text/html; charset=UTF-8");
			response.getWriter().println("<html><body>");
			response.getWriter().println("<script>");
			response.getWriter().println("alert('로그인 후 이용가능합니다.');");
			response.getWriter().println("window.parent.location.href='/login';");  //ifram 상위 부모 창에서 로그인화면으로 이동
			response.getWriter().println("</script>"); 
			response.getWriter().println("</html></body>");
			response.flushBuffer();  //버퍼 지우기
		    
		    return null;
		}
		
		//르그인이 된 경우(스프링 시큐리티 로그인한 사용자 정보 가져오기)
		
		log.debug("principal(로그인 후) : ",principal);
		
		String userName = principal.getName();
		
		
		
		model.addAttribute("userName",userName);
		return "chat/chat";   //chat.html로 리렌더링, 만약 로그인 안되어있으면 시큐리티에서 설정된 페이지로 이동
	}
}
