package kr.or.ddit.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.service.CvplService;
import kr.or.ddit.service.impl.CustomUser;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.vo.CvplVO;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.NoticeVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/cvpl")
public class CvplController {
	
	@Autowired
	CvplService cvplService;
	
	@Autowired
	UploadController uploadController;
	
	@GetMapping("/ntcn/go")
	public String ntcnGo(@RequestParam int cvplSn, HttpSession session) {
	    // 클릭한 알림이 민원이라면 해당 민원번호를 세션에 저장
	    session.setAttribute("cvplSnForDetail", cvplSn);

	    // 실제 페이지로 리다이렉트 (URL은 깔끔하게 유지됨)
	    return "redirect:/cvpl/list";
	}
	
	//페이징 및 리스트
	@GetMapping("/list")
	public String list(Model model
			, @RequestParam(value="keyword", required = false, defaultValue="") String keyword
			, @RequestParam(value="currentPage", required = false, defaultValue="1") int currentPage
			, @RequestParam(value="size", required=false, defaultValue="10") int size
			, @AuthenticationPrincipal CustomUser customUser
			, HttpSession session) {
		
		Object cvplSnObj = session.getAttribute("cvplSnForDetail");
		if (cvplSnObj != null) {
			model.addAttribute("cvplSnForDetail", cvplSnObj);
			session.removeAttribute("cvplSnForDetail");
		}
		
		Map<String, Object> map = new HashMap<>();
		map.put("keyword", keyword);
		map.put("currentPage", currentPage);
		map.put("size", size);
		map.put("mberId", customUser.getMberVO().getMberId());
		
		List<CvplVO> cvplList = this.cvplService.list(map);
		
		int total = this.cvplService.getTotal(map);
		
		ArticlePage<CvplVO> articlePage = new ArticlePage<>(total, currentPage, size, cvplList, keyword);
		
		model.addAttribute("articlePage",articlePage);
		
		
		return "cvpl/list";
	}
	
	//리로드용 리스트
	@PostMapping("/listAjax")
	@ResponseBody
	public Map<String, Object> listAjax(
			  @RequestParam(value="keyword", required = false, defaultValue="") String keyword
			, @RequestParam(value="currentPage", required = false, defaultValue="1") int currentPage
			, @RequestParam(value="size", required=false, defaultValue="10") int size
			, @AuthenticationPrincipal CustomUser customUser){
		log.info("listAjax -> keyword : {}", keyword);
		log.info("listAjax -> currentPage : {}", currentPage);
		
		Map<String, Object> map = new HashMap<>();
		map.put("keyword", keyword);
		map.put("currentPage", currentPage);
		map.put("size",size);
		map.put("mberId", customUser.getMberVO().getMberId());
		
		List<CvplVO> cvplList = this.cvplService.list(map);
		int total = this.cvplService.getTotal(map);
		
		ArticlePage<CvplVO> articlePage = new ArticlePage<>(total, currentPage, size, cvplList, keyword);
		map.put("articlePage", articlePage);
		
		return map;
	}
	
	
	//상세보기 모달
	@PostMapping("/cvplDetailModal")
	@ResponseBody
	public Map<String, Object> detail(
			 @RequestBody CvplVO cvplVO
			,@AuthenticationPrincipal CustomUser customUser) {
		log.info("cvplDetailModal->cvplVO : {}", cvplVO);
		
		int cvplSn = cvplVO.getCvplSn();
		
		cvplVO = this.cvplService.findById(cvplSn);
		log.info("(after) cvplDetailModal->cvplSn : {}", cvplVO);
		
		List<FileDetailVO> fileDetailVOList = this.cvplService.getFileDetailVOList(cvplVO.getFileGroupSn());
		log.info("fileDetailVOList=> {}",fileDetailVOList);
		
		// 이전글/다음글
		String mberId = customUser.getMberVO().getMberId();
		List<CvplVO> cvplList = this.cvplService.findByMberId(mberId);
		log.info("cvplList size => : {}", cvplList.size());
		
		
		Map<String, Object> map = new HashMap<>();
		map.put("cvplVO", cvplVO);
		map.put("fileDetailVOList", fileDetailVOList);
		map.put("cvplList", cvplList);
		
		return map;
	}
	
	//등록 모달
	@GetMapping("/cvplRegisterModal")
	@ResponseBody
	public Map<String, Object> registerForm() {
		
		List<DeptVO> deptVOList = this.cvplService.deptVOList();
		log.info("deptVOList", deptVOList);
		Map<String, Object> map = new HashMap<>();
		map.put("deptVOList", deptVOList);
		
		return map;
	}
	
	//등록
	@PostMapping("/cvplRegister")
	@ResponseBody
	public Map<String, Object> register(
			@AuthenticationPrincipal CustomUser customUser
		  , @RequestParam String cvplSj
		  , @RequestParam String cvplCn
		  , @RequestParam int deptCode
		  , @RequestParam MultipartFile[] multipartFiles) {
		
		CvplVO cvplVO = new CvplVO();
		cvplVO.setCvplSj(cvplSj);
		cvplVO.setCvplCn(cvplCn);
		cvplVO.setDeptCode(deptCode);
		cvplVO.setMberId(customUser.getMberVO().getMberId()); //회원아이디 가져오기
		
		//파일 등록null가능 검증
		List<MultipartFile> validFiles = new ArrayList<>();
	    if(multipartFiles != null) {
	        for(MultipartFile file : multipartFiles) {
	            if(!file.isEmpty() && file.getOriginalFilename() != null 
	               && !file.getOriginalFilename().trim().isEmpty()) {
	                validFiles.add(file);
	            }
	        }
	    }
	    
	    long fileGroupSn = 0;
	    if(!validFiles.isEmpty()) {  // ★ 이 한 줄이 핵심!
	        fileGroupSn = uploadController.multiImageUpload(validFiles.toArray(new MultipartFile[0]));
	    }
		
		cvplVO.setFileGroupSn(fileGroupSn);
		log.info("cvplVO : =>{}", cvplVO);
		
		int register = this.cvplService.register(cvplVO);
		
		Map<String, Object> map = new HashMap<>();
		map.put("register", register);
		map.put("fileGroupSn", fileGroupSn);
		
		log.info("cvplVO->register : {}",register);
		log.info("cvplVO->fileGroupSn : {}",fileGroupSn);
		return map;
		
	}
	
	//수정
	@PostMapping("/update")
	@ResponseBody
	public Map<String, Object> update(
	    @AuthenticationPrincipal CustomUser customUser,
	    @RequestBody CvplVO cvplVO) {
	  
	  cvplVO.setMberId(customUser.getMberVO().getMberId());
	  
	  int update = this.cvplService.update(cvplVO);
	  
	  Map<String, Object> map = new HashMap<>();
	  map.put("update", update);
	  
	  return map;
	}
	
}
