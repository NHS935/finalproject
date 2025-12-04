package kr.or.ddit.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.FxService;
import kr.or.ddit.vo.EmpVO;
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
	public String list(Model model,@RequestParam(value="start",required=false) String start, @RequestParam(value="end",required=false) String end) {
		
		log.info("start : {} ",start);
		log.info("end : {} ",end);
			
		List<EmpVO> empList = fxService.getEmpList();
		model.addAttribute("empList",empList);
		
		log.info("empList(11/13일확인) : {} ",empList);
		return "fx/list";
	}
	
	@ResponseBody
	@GetMapping("/listAjax")  //listAjax는 컨트롤러에서만 쓰는 메서드로 impl, mapper에 쓸 필요없음
	public List<FxVO> listAjax(@RequestParam(value="start",required=false) String start, @RequestParam(value="end",required=false) String end) {
		
		log.info("start : {} ",start);
		log.info("end : {} ",end);
		if(start == null ) {
			 start = "1970-10-01";  //땜빵
			 end="2999-10-31";
		}		
		return fxService.list(start,end);			
	}
	
	
	//일정 등록
	@ResponseBody
	@PostMapping("/insert")
	public String insert(@RequestBody FxVO fxVO) {
		
		int result = this.fxService.insert(fxVO);
		
		log.info("fxVO(이름확인) : {}",fxVO);
		
		log.info("insert->result : {}",result);
		
		if(result > 0) {
			return "success";
		}else {
			return "fail";
		}		
	}
	
	
	//일정 수정
	@ResponseBody
	@PostMapping("/modify")
	public String modify(@RequestBody FxVO fxVO) {
		
		int result=this.fxService.modify(fxVO);
		
		log.info("result : {}",result);
		log.info("fxVO : {}",fxVO);
					
		if(result>0) {
			return "success";
		}else {
			return "fail";
		}

	}
	
	
	//시설관리리스트에서 일정 등록 값 등록
	
	@ResponseBody
	@PostMapping("/schdul")
	public Map<String,Object> fcltyschdulregiser(@RequestBody FxVO fxVO){
		
		
		int result = this.fxService.fcltyschdulregiser(fxVO);
		log.info(" : {}",result);
		log.info("fxVO(일정등록 이름값 여부 확인) : {}",fxVO);
		
		
		Map<String,Object> map = new HashMap<>();
			
		if(result>0) {
			map.put("status", "success");
		}else {
			map.put("status", "fail");
		}
		
		log.info("map(fcltyschdulregiser) : {}",map);
		
		return map;
			
	}
	
	
	
	
	
	
	
}
