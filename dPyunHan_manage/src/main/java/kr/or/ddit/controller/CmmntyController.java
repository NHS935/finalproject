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

import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.service.CmmntyService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.util.CmmntyexcelWriter;
import kr.or.ddit.vo.CmmntyVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/cmmnty")
@Slf4j
@Controller
public class CmmntyController {

	@Autowired
	CmmntyService cmmntyService;
	
	@Autowired
	CmmntyexcelWriter cmmntyexcelWriter;

	 //커뮤니티 리스트 목록 조회
    @GetMapping("/cmmntylist")
    public String cmmntylist(Model model, 
    		                 @RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage,
	                         @RequestParam(value="keyword",required=false, defaultValue="")String keyword,
	                         @RequestParam(value="sortOrder",required=false,defaultValue="")String sortOrder,
	                         @RequestParam(value="status", required=false, defaultValue="")String status,
	                         @RequestParam(value="startDate",required=false,defaultValue="")String startDate,
	                         @RequestParam(value="endDate",required=false,defaultValue="")String endDate) {
    	
    	
    	int size=10; //한 화면에 보여줄 행의 수
    	int offset = (currentPage -1)*size;  //db에서 몇개를 어디서부터 가져올지 설정
    	
    	String kw = (keyword == null) ? "": keyword.trim();
    	
    	Map<String,Object> map = new HashMap<>();
    	map.put("currentPage", currentPage);
    	map.put("size", size);
    	map.put("offset", offset);
    	map.put("keyword", kw);
    	map.put("sortOrder", (sortOrder == null || sortOrder.isBlank()) ? "desc" : sortOrder );
    	map.put("status", status == null ? "" : status);
    	map.put("startDate", startDate == null ? "" : startDate);
    	map.put("endDate", endDate == null ? "" : endDate);
    	
    	//전체 행의 수
    	int total = this.cmmntyService.getTotal2(map);
    	log.info("list->total {}: ", total);
    	
    	List<CmmntyVO> cmmntyVOList = this.cmmntyService.cmmntylist(map);
    	log.info("cmmntyVOList(테스트) : {}",cmmntyVOList);
    	   	
    	//페이지네이션
		ArticlePage<CmmntyVO> articlePage = 
			new ArticlePage<CmmntyVO>(total, currentPage, size, cmmntyVOList, kw);
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
    
    
    //커뮤니티 목록 excel 다운로드
    @GetMapping("/excel")
    public void cmmntyexcel(@RequestParam(value="keyword", required=false, defaultValue="")String keyword,   //jsp에서 return하지 않으므로 String 안씀
    		@RequestParam(value="sortOrder",required=false,defaultValue="desc")String sortOrder,
            @RequestParam(value="status", required=false, defaultValue="")String status,
            @RequestParam(value="startDate",required=false,defaultValue="")String startDate,
            @RequestParam(value="endDate",required=false,defaultValue="")String endDate,
            HttpServletResponse response) throws Exception{
    	
      List<CmmntyVO> list = cmmntyService.cmmntyexcel(keyword,sortOrder,status,startDate,endDate);                     //검색 조건 + 전체조회(페이징 미처리)
      
      cmmntyexcelWriter.cmmnwriter(list,response);                                                                     //엑셀파일 생성+다운로드 응답
     
    }
}
