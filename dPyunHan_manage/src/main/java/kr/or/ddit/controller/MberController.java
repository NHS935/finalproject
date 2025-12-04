package kr.or.ddit.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.service.MberService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.vo.MberVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/mber")
@Slf4j
public class MberController {
	
	@Autowired
	MberService mberService;
	@GetMapping("/hshldList")
	// 세대 + 입주민 목록
	public String getHshldList(Model model,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
			@RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
			@RequestParam(value="size", required=false, defaultValue="20") int size //한페이지에 보여줄 글 수 20개했습니다
			) {
		
	    Map<String, Object> map = new HashMap<>();
	    map.put("currentPage", currentPage);
	    map.put("size", size);      //페이징
	    map.put("keyword", keyword); // 검색에 사용

	    // 목록 조회
	    List<MberVO> hshldListVO = mberService.getHshldList(map);

	    // 전체 건수 페이지네이션
	    int total = mberService.getHshldTotal(map);
	   
	    ArticlePage<MberVO> articlePage = new ArticlePage<>(total, currentPage, size, hshldListVO, keyword);

	    model.addAttribute("articlePage", articlePage);
	    model.addAttribute("hshldListVO", hshldListVO); // 필요하면 그대로도 넘겨줌
	    model.addAttribute("keyword", keyword);         // 검색어 유지용
		
		return "mber/hshldList";
	}
	
	@GetMapping("/hshldDetail")
	// 세대 상세
	public String getHshldDetail(Model model,@RequestParam String hshldId) {
		List<MberVO> hshldDetailVO = mberService.getHshldDetail(hshldId);
		
		model.addAttribute("hshldDetailVO", hshldDetailVO);
		return "mber/hshldDetail";
	
	}
	
}
