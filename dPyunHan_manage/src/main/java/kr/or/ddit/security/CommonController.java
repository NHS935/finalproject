package kr.or.ddit.security;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.extern.slf4j.Slf4j;


@Controller
@Slf4j
public class CommonController {

	// 인가(권환)가 안됨. 즉, 로그인은 되어있는 상태임. 로그인(Authentication) 정보를 받아올 수 있음
	@GetMapping("/accessError")
	public String accessError(Authentication auth, Model model) {
		//auth : 로그인 정보가 들어있음
		log.info("accessError : "+auth);
		
		model.addAttribute("msg","권한이 없습니다."); //모델 -> 동기방식
		// 비동기는 ajax, fetch, axios
		
		// /views/accessError.jsp를 forwarding
		return "accessError";
	}
	
}
