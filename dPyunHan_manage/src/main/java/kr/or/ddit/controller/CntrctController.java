package kr.or.ddit.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.vo.FileDetailVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/cntrct")
@Controller
public class CntrctController {
	
	@GetMapping("/postCntrct")
	public String postCntrct() {
		
		
		
		return "cntrct/postCntrct";
	}

}
