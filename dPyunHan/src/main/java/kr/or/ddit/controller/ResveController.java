package kr.or.ddit.controller;

import java.text.ParseException;
import java.time.LocalDate;
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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.ResveService;
import kr.or.ddit.service.impl.CustomUser;
import kr.or.ddit.vo.CmmntyVO;
import kr.or.ddit.vo.ResveVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("resve")
@Slf4j
@Controller
public class ResveController {

	@Autowired
	ResveService resveService;
	
	// 커뮤니티시설 리스트(예약)
	@GetMapping("/list")
	public String list(CmmntyVO cmmntyVO, ResveVO resveVO, @AuthenticationPrincipal CustomUser customUser, Model model) {
		resveVO.setMberId(customUser.getMberVO().getMberId());
		
		List<CmmntyVO> cmmntyVOList = this.resveService.list(cmmntyVO);
		model.addAttribute("cmmntyVOList", cmmntyVOList);
		
		return "resve/list";
	}
	
	// 해당 커뮤니티시설 상세 조회
	@ResponseBody
	@GetMapping("/detail")
	public Map<String, Object> resve(@RequestParam("cmmntySn") int cmmntySn, CmmntyVO cmmntyVO) {
		cmmntyVO.setCmmntySn(cmmntySn);
		
		CmmntyVO result = this.resveService.detail(cmmntyVO);
		
		// 해당 커뮤니티시설 시간대 조회
		List<String> timeList = this.resveService.selectTimeSlots(cmmntyVO);
		
		Map<String, Object> map = new HashMap<>();
		map.put("cmmntyVO", result);
		map.put("timeList", timeList);

		return map;
	}

	//2. 해당 날짜, 시설 예약 내역 조회
	@ResponseBody
	@GetMapping("/resveAvailable")
	public List<ResveVO> resveAvailable(@RequestParam("cmmntySn") int cmmntySn, @RequestParam("resveDt") String resveDtStr) throws ParseException {
		//해당 커뮤니티시설 1시간 단위당 남은 잔여 인원 수
		
//		Date resveDt = java.sql.Date.valueOf(resveDtStr);  // ← 문자열 → Date 변환
		LocalDate resveDt = LocalDate.parse(resveDtStr);
		
	    ResveVO resveVO = new ResveVO();
        resveVO.setCmmntySn(cmmntySn);
        resveVO.setResveDt(resveDt);
        
        CmmntyVO cmmntyVO = new CmmntyVO();
        cmmntyVO.setCmmntySn(cmmntySn);
        resveVO.setCmmntyVO(cmmntyVO);
        
		List<ResveVO> result = this.resveService.resveAvailable(resveVO);
		
		return result;
	}
	
	// 예약 실행
	@ResponseBody
	@PostMapping("/resve")
	public int resve(@RequestBody ResveVO resveVO, @AuthenticationPrincipal CustomUser customUser) {
		resveVO.setMberId(customUser.getMberVO().getMberId());
		
		int result = this.resveService.resve(resveVO);
		return result;
	}              
	
	//내 예약현황 리스트
	@ResponseBody
	@GetMapping("/resveMber")
	public Map<String, Object> resveMber(ResveVO resveVO, @AuthenticationPrincipal CustomUser customUser) {
		resveVO.setMberId(customUser.getMberVO().getMberId());
		
		Map<String, Object> map = new HashMap<>();
		List<ResveVO> result = this.resveService.resveMber(resveVO);
		
		map.put("resveVOList", result);
		
		return map;
	}
	
	//탭별 예약 상세
	@GetMapping("/resveMberDetail")
	@ResponseBody
	public ResveVO resveMberDetail(@RequestParam("resveSn") int resveSn) {
		
	    ResveVO resvoVO = this.resveService.resveMberDetail(resveSn);
	    
	    return resvoVO;
	}
	
	// 예약 취소 실행
	@ResponseBody
	@PostMapping("/resveCancel")
	public int resveCancel(@RequestBody ResveVO resveVO, @AuthenticationPrincipal CustomUser customUser) {
		resveVO.setMberId(customUser.getMberVO().getMberId());
		
		int result = this.resveService.resveCancel(resveVO);

		return result;
	}
}
