package kr.or.ddit.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.FxService;
import kr.or.ddit.vo.FxVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/fx")
@Slf4j
@Controller
public class FxController {

	@Autowired
	FxService fxService;
	
	
	//일정 조회
	
	@GetMapping("/list")
	public String list(@RequestParam(value="start",required=false) String start, @RequestParam(value="end",required=false) String end) {
		
		log.info("start : {} ",start);
		log.info("end : {} ",end);
				
		return "fx/list";
	}
	
	@ResponseBody
	@GetMapping("/listAjax")
	public List<FxVO> listAjax(@RequestParam(value="start",required=false) String start, @RequestParam(value="end",required=false) String end){
		
		log.info("start : {}",start);
		log.info("end : {}",end);
		
		if(start == null ) {
			 start = "1970-10-01";  //땜빵
			 end="2999-10-31";
		}		
				
	   List<FxVO> fxVoList = fxService.listAjax();
	   
	   log.info("fxVoList : {}",fxVoList);
	   
	   return fxVoList;
	   
	}
	
	
	
}
