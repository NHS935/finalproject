package kr.or.ddit.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.config.BeanController;
import kr.or.ddit.service.CvplRceptService;
import kr.or.ddit.service.impl.CustomUser;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.vo.CvplRceptVO;
import kr.or.ddit.vo.CvplVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/cvplRcept")
@Controller
public class CvplRceptController {

	@Autowired
	CvplRceptService cvplRceptService;

	@Autowired
	BeanController beanController;

	@Autowired
	UploadController uploadController;

	@GetMapping("/ntcn/go")
	public String ntcnGo(@RequestParam int cvplSn, HttpSession session) {
		// 클릭한 알림이 민원이라면 해당 민원번호를 세션에 저장
		session.setAttribute("cvplSnForDetail", cvplSn);

		// 실제 페이지로 리다이렉트 (URL은 깔끔하게 유지됨)
		return "redirect:/cvplRcept/list";
	}
	
	// 해당 부서의 민원 리스트
	@GetMapping("/list")
	public String list(HttpSession session, Model model) {
		Object cvplSnObj = session.getAttribute("cvplSnForDetail");
		if (cvplSnObj != null) {
			model.addAttribute("cvplSnForDetail", cvplSnObj);
			session.removeAttribute("cvplSnForDetail");
		}
		return "cvplRcept/list"; // JSP 경로
	}
	@ResponseBody
	@GetMapping("/listAjax")
	public Map<String, Object> listAjax(CvplVO cvplVO, @AuthenticationPrincipal CustomUser customUser,
						@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
						@RequestParam(value = "cvplSj", required = false) String cvplSj,
						@RequestParam(value = "mberNm", required = false) String mberNm,
						@RequestParam(value = "size", required = false, defaultValue = "5") int size,
						@RequestParam(value = "rceptSttus", required = false, defaultValue = "-1") int rceptSttus,
						@RequestParam(value = "startDate", required = false, defaultValue = "") String startDate,
						@RequestParam(value = "endDate", required = false, defaultValue = "") String endDate,
				        @RequestParam(value = "sortType", required = false, defaultValue = "latest") String sortType,
				        @RequestParam(value = "remainDaysRange", required = false, defaultValue = "") String remainDaysRange) {
		cvplVO.setEmpId(customUser.getEmpVO().getEmpId());
		
		//페이지네이션
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("currentPage", currentPage);
		map.put("cvplSj", cvplSj);
		map.put("mberNm", mberNm);
		map.put("size", size);
		map.put("empId", cvplVO.getEmpId());
	    map.put("rceptSttus", rceptSttus);
	    map.put("startDate", startDate);
	    map.put("endDate", endDate);
	    map.put("sortType", sortType);
	    if (remainDaysRange != null && remainDaysRange.trim().isEmpty()) {
	        remainDaysRange = null;
	    }
	    map.put("remainDaysRange", remainDaysRange);

		int total = this.cvplRceptService.getTotal(map);
		//AND E.EMP_ID = 샾{empId}
		//WHERE S.RNUM BETWEEN(샾{currentPage} * 5) - (5 - 1) AND (샾{currentPage} * 5)
		List<CvplVO> cvplVOList = this.cvplRceptService.list(map);
		
		ArticlePage<CvplVO> articlePage = new ArticlePage<CvplVO>(total, currentPage, size, cvplVOList); //2025-11-21 KWH 수정
		Map<String, Object> result = new HashMap<>();
		result.put("total", total);
		result.put("articlePage", articlePage);
		result.put("cvplVOList", cvplVOList);
		
		log.info("==== [CvplRceptController] listAjax START ====");
		log.info("empId={}, currentPage={}, size={}", cvplVO.getEmpId(), currentPage, size);
		log.info("cvplVOList.size={}", cvplVOList != null ? cvplVOList.size() : 0);
		log.info("==== [CvplRceptController] listAjax END ====");

		return result;
	}

	// 해당 민원의 상세
	@ResponseBody
	@GetMapping("/cvplDetailAjax")
	public Map<String, Object> cvplDetailAjax(@RequestParam("cvplSn") int cvplSn, CvplVO cvplVO) {
		cvplVO.setCvplSn(cvplSn);
		
		Map<String, Object> result = new HashMap<>();

	    // 민원 상세
	    cvplVO = this.cvplRceptService.detail(cvplVO);

	    // 접수 상세
	    CvplRceptVO cvplRceptVO = this.cvplRceptService.cvplRceptDetail(cvplSn);

	    result.put("cvplVO", cvplVO);
	    result.put("cvplRceptVO", cvplRceptVO);
	    
		return result;
	}

	// 해당 민원 접수 실행
	@ResponseBody
	@PostMapping("/cvplRceptPost")
	public int cvplRceptPost(@ModelAttribute CvplRceptVO cvplRceptVO, @AuthenticationPrincipal CustomUser customUser) {
		cvplRceptVO.setEmpId(customUser.getEmpVO().getEmpId());
		
		int result = this.cvplRceptService.cvplRceptPost(cvplRceptVO);

		return result;
	}

	// 해당 민원 종결 실행
	@ResponseBody
	@PostMapping("/cvplEnPost")
	public int cvplEnPost(@ModelAttribute CvplRceptVO cvplRceptVO, @AuthenticationPrincipal CustomUser customUser) {
		cvplRceptVO.setEmpId(customUser.getEmpVO().getEmpId());
		
		int result = this.cvplRceptService.cvplEnPost(cvplRceptVO);

		return result;
	}
}
