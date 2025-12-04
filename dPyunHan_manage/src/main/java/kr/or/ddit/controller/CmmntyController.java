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

import kr.or.ddit.service.CmmntyService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.vo.CmmntyVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/cmmnty")
@Slf4j
@Controller
public class CmmntyController {

	@Autowired
	CmmntyService cmmntyService;
		
	 //커뮤니티 리스트 목록 조회
    @GetMapping("/cmmntylist")
    public String cmmntylist(Model model, @RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage,
	                         @RequestParam(value="keyword",required=false, defaultValue="")String keyword) {
    	
    	//한 화면에 보여줄 행의 수
    	int size=10;
    	
    	Map<String,Object> map = new HashMap<>();
    	map.put("currentPage", currentPage);
    	map.put("keyword", keyword);
    	
    	//전체 행의 수
    	int total = this.cmmntyService.getTotal2(map);
    	log.info("list->total {}: ", total);
    	
    	List<CmmntyVO> cmmntyVOList = this.cmmntyService.cmmntylist(map);
    	log.info("cmmntyVOList(테스트) : {}",cmmntyVOList);
    	   	
    	//페이지네이션
		ArticlePage<CmmntyVO> articlePage = 
			new ArticlePage<CmmntyVO>(total, currentPage, size, cmmntyVOList, keyword);
		log.info("list->articlePage : " + articlePage);
		
		model.addAttribute("cmmntyVOList",cmmntyVOList);
		model.addAttribute("empList",cmmntyService.empList());
		model.addAttribute("articlePage", articlePage);
    	
		return "cmmnty/cmmntylist";
    }
    
    // 커뮤니티 모달 상태값 변경 시 db 전달
    @ResponseBody
    @PostMapping("/cmmntyupdatePost")
    public int cmmntyupdatePost(@RequestBody CmmntyVO cmmntyVO) {
    	
    	log.info("cmmntyupdatePost->cmmntyVO " + cmmntyVO);
    	
		/*
		 * //기존 db 데이터 값 조회 cmmntyVO dbData =
		 * cmmntyService.detail(cmmntyVO.getCmmntySn());
		 * 
		 * if(cmmntyVO.getCmmntyChckDt() == null) {
		 * cmmntyVO.setCmmntyChckDt(dbData.getCmmntyChckDt()); }
		 */
    	
    	int result = this.cmmntyService.cmmntyupdatePost(cmmntyVO);
    	log.info("cmmntyupdatePost->cmmntyVO(후) " + cmmntyVO);
    	log.info("cmmntyupdatePost->result " + result);
    	
    	return result;
    }
	
}
