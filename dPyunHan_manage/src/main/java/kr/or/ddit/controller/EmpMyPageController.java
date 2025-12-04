package kr.or.ddit.controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.config.BeanController;
import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.service.EmpMyPageService;
import kr.or.ddit.service.SignService;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.SignVO;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/emp")
@Slf4j
@Controller
public class EmpMyPageController {
	@Autowired
	EmpMyPageService empMyPageService;

	@Autowired
	BeanController beanController;

	@Autowired
	UploadController uploadController;

	@Autowired
	EmpMapper empMapper;

	@Autowired
	SignService signService;

	@GetMapping("empMyPage/{empId}")
	public String selectEmpDetailById(@PathVariable("empId") String empId, Model model) {
		log.info("editEmpMyPage -> principal : {}", empId);
		EmpVO emp2VO = this.empMyPageService.selectEmpDetailById(empId);
		SignVO signVO = this.signService.selectSign(empId);
		
		log.info("editEmpMyPage -> emp2VO : {}", emp2VO);
		log.info("selectSign -> signVO : {}", signVO);
		model.addAttribute("emp2VO", emp2VO);
		model.addAttribute("signVO", signVO);
		log.info("editEmpMyPage -> emp2VO : {}", emp2VO);
		log.info("editEmpMyPage -> signVO : {}", signVO);

		return "emp/empMyPage";
	}
	@GetMapping("/editEmpMyPage/{empId}")
	public String editEmpMyPage(@PathVariable("empId") String empId, Model model) {
		log.info("editEmpMyPage -> principal : {}", empId);
		EmpVO emp2VO = this.empMyPageService.selectEmpDetailById(empId);
		SignVO signVO = this.signService.selectSign(empId);
		
		log.info("editEmpMyPage -> emp2VO : {}", emp2VO);
		log.info("selectSign -> signVO : {}", signVO);
		model.addAttribute("emp2VO", emp2VO);
		model.addAttribute("signVO", signVO);
		log.info("editEmpMyPage -> emp2VO : {}", emp2VO);
		log.info("editEmpMyPage -> signVO : {}", signVO);
		
		return "emp/editEmpMyPage";
	}
    // 사인업데이트
    @PostMapping("/insertSign")	
    public String upsertSignAndUpload(SignVO signVO,
    		@RequestParam(value="fileGroupSn2", required=false) Long empFileGroupSn) {

        long signId = signService.upsertSignAndUpload(signVO);
        return "redirect:/emp/editEmpMyPage/" + signVO.getEmpId();
    }
	
	@PostMapping("/empEdit")
	public String empEdit(@ModelAttribute EmpVO empVO, Principal principal) {
		//로그인 안되면 로그인페이지로 보내요
		if(principal==null || principal.getName().equals("")) {
			return "redirect:/login";
		}
		log.info("empEditPost => empVO : {}", empVO);
		empVO.setEmpId(principal.getName());
		int result = this.empMyPageService.empEdit(empVO);
		log.info("empEditPost => result : {}", result);
		// 경로
		return "redirect:/emp/editEmpMyPage/"+empVO.getEmpId();
	}
}
