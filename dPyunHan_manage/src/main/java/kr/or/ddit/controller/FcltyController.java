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

import kr.or.ddit.service.FcltyService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.vo.CmmntyVO;
import kr.or.ddit.vo.FcltyVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/fclty")
@Slf4j
@Controller
public class FcltyController {

	@Autowired
	FcltyService fcltyService;

	/*
	 * //시설점검 결과 등록
	 * 
	 * @GetMapping("/register") public String register() { return "fclty/register";
	 * }
	 * 
	 * @PostMapping("/registerPost") public String registerPost(FcltyVO fcltyVO,
	 * Model model) { int result = this.fcltyService.registerPost(fcltyVO);
	 * log.info("registerPost->result {} : ",result);
	 * 
	 * model.addAttribute("fcltyVO",fcltyVO);
	 * 
	 * return "redirect:/fclty/list"; }
	 */
	
	
	//시설점검결과 목록 조회
    @GetMapping("/list")
	public String list(Model model, @RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage,
			          @RequestParam(value="keyword",required=false, defaultValue="")String keyword) {
    	
    	//한 화면에 보여줄 행의 수
    	int size=10;
    	
    	Map<String,Object> map = new HashMap<>();
    	map.put("currentPage", currentPage);
    	map.put("keyword", keyword);
    	
    	//전체 행의 수
    	int total = this.fcltyService.getTotal(map);
    	log.info("list->total {}: ", total);
    	
    	List<FcltyVO> fcltyVOList = this.fcltyService.list(map);
    	List<FcltyVO> fcltyAllList = this.fcltyService.selectAll();  //나혜선 추가
    	
    	log.info("list->fcltyVOList {}: ",fcltyVOList);
    	log.debug("list->fcltyVOList(디버그) {}:",fcltyVOList);
    	
    	//페이지네이션
		ArticlePage<FcltyVO> articlePage = 
			new ArticlePage<FcltyVO>(total, currentPage, size, fcltyVOList, keyword);
		log.info("list->articlePage : " + articlePage);
		
		model.addAttribute("fcltyVOList",fcltyVOList);
		model.addAttribute("fcltyAllList",fcltyAllList);
		model.addAttribute("empList",fcltyService.empList());
		model.addAttribute("articlePage", articlePage);
		
		return "fclty/list";
    	
    }
    
    

   // 모달 상태값 변경 시 db 전달
    
   @ResponseBody
   @PostMapping("/updatePost")
   public int updatePost(@RequestBody FcltyVO fcltyVO) {
	   
	   /*
	    FcltyVO(fcltySn=0, fcltyCl=0, fcltyClStr=null, fcltyNm=null, 
	    fcltyLc=0, fcltyLcStr=null, fcltySttus=4, fcltySttusStr=null, 
	    fcltyChckDt=Tue Sep 16 09:00:00 KST 2025)
	    */
	   
	   log.info("updatePost->fcltyVO : "+fcltyVO);
	   
	   //이전 db 데이터값 조회
	   FcltyVO oldData = this.fcltyService.detail(fcltyVO.getFcltySn());
	   
	   if(fcltyVO.getFcltyChckDt()==null) {
		   fcltyVO.setFcltyChckDt(oldData.getFcltyChckDt());
	   }
	   
       int result = this.fcltyService.updatePost(fcltyVO);
	   
   
	   log.info("updatePost->result : "+result);
	   
	   return result;
   }
    
    
   
   
   

}
