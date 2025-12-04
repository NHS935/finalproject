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

import kr.or.ddit.service.FcltyManageService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.vo.CmmntyVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FcltyManageVO;
import kr.or.ddit.vo.FcltyVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/fcltyManage")
@Slf4j
@Controller
public class FcltyManageController {

	@Autowired
	FcltyManageService fcltyManageService;
	
	
	//시설관리 일정 등록 화면
	
	@GetMapping("/register")
	public String register(FcltyManageVO fcltyManageVO, Model model, @RequestParam(value="fcltySn", required=false, defaultValue = "0") int fcltySn,  //null 일 수 있으므로 Integer 사용
                           @RequestParam(value="cmmntySn", required=false, defaultValue="0") int cmmntySn) {  //단순히 jsp에서 데이터만 받는거이므로(단순 조회)
	  	
		//담당자 조회
		 List<EmpVO> empList = this.fcltyManageService.selectEmpList();  //단순 조회이므로 서비스나 매퍼에서 받을 인자 필요 없음
		
		//시설 일련번호 조회
		 List<FcltyVO> fcltyVO = this.fcltyManageService.selectFcltySn(fcltySn);  
		 
		 //커뮤니티 일련번호 조히
		 List<CmmntyVO> cmmntyVO = this.fcltyManageService.selectCmmnty(cmmntySn);	
		 
		model.addAttribute("empList",empList);
		model.addAttribute("fcltyVOList",fcltyVO);
		model.addAttribute("cmmntyVOList",cmmntyVO); //"cmmntyVOList" : JSP로 전달될 때는 “속성 이름(key)”으로 사용되는 것
		
		return "fcltyManage/register";
	}
	
		
	//시설관리 일정 등록(insert)
	
	@ResponseBody
	@PostMapping("/registerPost")
	public Map<String,Object> registerPost(@RequestBody FcltyManageVO fcltyManageVO) {  //@RequestParam은 개별 파라미터를 받지만, @ModelAttribute는 여러 파라미터를 한 객체로 묶어서 받는다.
		
		log.info("registerPost->fcltyManageVO : {} ",fcltyManageVO);
		
		int result = this.fcltyManageService.registerPost(fcltyManageVO);
		
		log.info("registerPost->result : {} ",result);
		
	    Map<String,Object> map = new HashMap<>();
	    
	    map.put("result", result);
	    
	    return map;   //get매핑일땐 뷰 경로를, post 매핑일때는 return 이 뷰 경로가 아닌걸로
		
	}
	
	
   //시설관리 일정 목록 조회(select) + 페이징처리
	
	@GetMapping("/list")
	public String list(Model model, @RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage,
	                   @RequestParam(value="keyword",required=false, defaultValue="")String keyword) {  //vo는 클라이언트에서 데이터 받을 때, model은 jsp에 데이터를 던질때 사용, 리턴값이 뷰 경로를 가리키는 문자열 이므로 String
		
		//한 화면에 보여줄 행의 수
		int size=10;
		
		Map<String,Object> map = new HashMap<>();
		
		map.put("currentPage", currentPage);
		map.put("keyword", keyword);
		
		//전체 행의 수
		int total = this.fcltyManageService.getTotal(map);
	
		
		// 시설관리 리스트 목록 조회
		List<FcltyManageVO> FcltyManageVOList = this.fcltyManageService.fclManageAllist(map); //model 은 컨트롤러와 jsp에서만 사용
				
		
		//일정등록 버튼을 누른 후 일정등록 버튼 사라지게 하기 
			
		for(int i=0; i<FcltyManageVOList.size(); i++) {
			
			//리스트에서 한개씩 확인
			FcltyManageVO fcltyManageVO = FcltyManageVOList.get(i);
			
			//시설관리 일련번호 확인
			int manageSn = fcltyManageVO.getFcltyManageSn();
			
			//fx db에 해당 시설관리 일련번호 있는지 여부 확인
			int count = this.fcltyManageService.getFxcount(manageSn);
			
			if(count>0) {
				fcltyManageVO.setSchduleyesno(true); //일정등록 완료
			}else {
				fcltyManageVO.setSchduleyesno(false);
			}				
			
			log.info("count(시설관리리스트 등록여부) : {}",count);
		}//for문
		
		
		model.addAttribute("fcllist",FcltyManageVOList); 
				
		log.info("FcltyManageVOList(확인용) : {}",FcltyManageVOList);
		
		//페이지네이션
		ArticlePage<FcltyManageVO> articlePage =
				new ArticlePage<>(total, currentPage, size, FcltyManageVOList, keyword);
		
		model.addAttribute("articlePage",articlePage);
		
		return "fcltyManage/list";
	   
	}
	

	
	
	
}
