package kr.or.ddit.controller;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
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

import kr.or.ddit.service.ElctrncsanctnService;
import kr.or.ddit.service.impl.ContractServiceImpl;
import kr.or.ddit.service.impl.CustomUser;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.vo.BkmkSanctnlnDataVO;
import kr.or.ddit.vo.BkmkSanctnlnVO;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.DrftDocVO;
import kr.or.ddit.vo.ElctrnsanctnVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.SanctnlnVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequestMapping("/elctrnsanctn")
@Controller
public class ElctrncsanctnController {

	@Autowired
	UploadController uploadService;

	@Autowired
	ElctrncsanctnService elctrnsanctnService;

	@Autowired
	ContractServiceImpl  contractService;

	@GetMapping("/getElctrnsanctnList")
	public String getElctrnsanctnList(Model model, @AuthenticationPrincipal CustomUser customUser,
			@RequestParam(required = false, defaultValue = "") String keyword,
			@RequestParam(required = false, defaultValue = "1") int currentPage) {
		// 공용
		int size = 5;
		EmpVO empVO = customUser.getEmpVO();
		model.addAttribute("empVO", empVO);

		// 보낸 기안
		Map<String, Object> mapSent = new HashMap<>();
		mapSent.put("keyword", keyword);
		mapSent.put("currentPage", currentPage);
		mapSent.put("empId", empVO.getEmpId());

		List<ElctrnsanctnVO> elctrnsanctnVOListSent = this.elctrnsanctnService.getElctrnsanctnList(mapSent);
		int totalSent = this.elctrnsanctnService.getTotal(mapSent);

		ArticlePage<ElctrnsanctnVO> articlePageSent = new ArticlePage<ElctrnsanctnVO>(totalSent, currentPage, size,
				elctrnsanctnVOListSent, keyword);
		model.addAttribute("articlePageSent", articlePageSent);

		// 받은 기안
		Map<String, Object> mapRcpt = new HashMap<>();
		mapRcpt.put("empId", empVO.getEmpId());
		mapRcpt.put("currentPage", currentPage);
		mapRcpt.put("empId", empVO.getEmpId());
		List<ElctrnsanctnVO> elctrnsanctnVOListRcpt = this.elctrnsanctnService.getElctrnsanctnRcptList(mapRcpt);
		int totalRcpt = this.elctrnsanctnService.getTotalRcpt(mapRcpt);

		ArticlePage<ElctrnsanctnVO> articlePageRcpt = new ArticlePage<ElctrnsanctnVO>(totalRcpt, currentPage, size,
				elctrnsanctnVOListRcpt, keyword);
		model.addAttribute("articlePageRcpt", articlePageRcpt);
		return "elctrnsanctn/getElctrnsanctnList";
	}

	//2025-11-22 KWH 수정
	@GetMapping("/getElctrnsanctnSentList")
	public String getElctrnsanctnSentList(Model model, @AuthenticationPrincipal CustomUser customUser,
			@RequestParam(required = false, defaultValue = "") String keyword,
			@RequestParam(required = false, defaultValue = "1") int currentPage) {
		
		// 자료: 클라이언트 -> 컨틀
		int size = 15;
		EmpVO empVO = customUser.getEmpVO();
		Map<String, Object> map = new HashMap<>();
		
		// 서비스
		map.put("keyword", keyword);
		map.put("currentPage", currentPage);
		map.put("empId", empVO.getEmpId());
		map.put("size", size);
		List<ElctrnsanctnVO> elctrnsanctnVOList = this.elctrnsanctnService.getElctrnsanctnList(map);

		
		int total = this.elctrnsanctnService.getTotal(map);
		
		// 반환
		ArticlePage<ElctrnsanctnVO> articlePage = new ArticlePage<ElctrnsanctnVO>(total, currentPage, size,
				elctrnsanctnVOList, keyword);

		model.addAttribute("empVO", empVO);
		model.addAttribute("articlePage", articlePage);
		return "elctrnsanctn/getElctrnsanctnSentList";
	}
	
	
	// 2025-11-22 KWH 수정		
	@GetMapping("/getElctrnsanctnRcpttList")
	public String getElctrnsanctnRcptList(Model model, @AuthenticationPrincipal CustomUser customUser,
			@RequestParam(required = false, defaultValue = "") String keyword,
			@RequestParam(required = false, defaultValue = "1") int currentPage) {
		int size = 15;
		EmpVO empVO = customUser.getEmpVO();
		model.addAttribute("empVO", empVO);

		// 받은 기안
		Map<String, Object> map = new HashMap<>();
		map.put("empId", empVO.getEmpId());
		map.put("currentPage", currentPage);
		map.put("empId", empVO.getEmpId());
		map.put("size", size);
		
		List<ElctrnsanctnVO> elctrnsanctnVOList = this.elctrnsanctnService.getElctrnsanctnRcptList(map);
		int total = this.elctrnsanctnService.getTotalRcpt(map);

		ArticlePage<ElctrnsanctnVO> articalPage = new ArticlePage<ElctrnsanctnVO>(total, currentPage, size,
				elctrnsanctnVOList, keyword);
		model.addAttribute("articlePage", articalPage);
		return "elctrnsanctn/getElctrnsanctnRcpttList";
	}
	
	@GetMapping("/getElctrnsanctn")
	public String getElctrnsanctn(ElctrnsanctnVO elctrnsanctnVO, Model model,
			@AuthenticationPrincipal CustomUser customUser) {
		EmpVO empVO = customUser.getEmpVO();
		elctrnsanctnVO = this.elctrnsanctnService.getElctrnsanctn(elctrnsanctnVO);

		if (!empVO.getEmpId().equals(elctrnsanctnVO.getEmpId())) {
			return "elctrnsanctn/getElctrnsanctnList";
		}

		List<FileDetailVO> fileDetailVOList = this.uploadService
				.getFileDetailVOList(elctrnsanctnVO.getFileGroupSn());

		model.addAttribute("fileDetailVOList", fileDetailVOList);
		model.addAttribute("elctrnsanctnVO", elctrnsanctnVO);

		return "elctrnsanctn/getElctrnsanctn";
	}

	@GetMapping("/getElctrnsanctnRcpt")
	public String getElctrnsanctnRcpt(ElctrnsanctnVO elctrnsanctnVO, Model model,
			@AuthenticationPrincipal CustomUser customUser) {
		EmpVO empVO = customUser.getEmpVO();
		Map<String, Object> map = new HashMap<>();
		elctrnsanctnVO = this.elctrnsanctnService.getElctrnsanctn(elctrnsanctnVO);

		if (empVO.getEmpId().equals(elctrnsanctnVO.getEmpId())) {
			return "redirect:elctrnsanctn/getElctrnsanctnList";
		}

		List<FileDetailVO> fileDetailVOList = this.uploadService
				.getFileDetailVOList(elctrnsanctnVO.getFileGroupSn());

		model.addAttribute("empVO", empVO);
		model.addAttribute("fileDetailVOList", fileDetailVOList);
		model.addAttribute("elctrnsanctnVO", elctrnsanctnVO);

		return "elctrnsanctn/getElctrnsanctnRcpt";
	}

	@ResponseBody
	@PostMapping("/rejectElctrnsanctn")
	public Map<String, Object> rejectElctrnsanctn(@RequestBody SanctnlnVO sanctnlnVO,
			@AuthenticationPrincipal CustomUser customUser) {
		Map<String, Object> map = new HashMap<>();
		EmpVO empVO = customUser.getEmpVO();
		log.info("elctrnsanctnSn: => {}", sanctnlnVO.getElctrnsanctnSn());
		log.info("returnPrvonsh: => {}", sanctnlnVO.getReturnPrvonsh());

		int result = this.elctrnsanctnService.rejectElctrnsanctn(sanctnlnVO, empVO);
		map.put("result", result);
		return map;
	}

	@ResponseBody
	@PostMapping("/consentElctrnsanctn")
	public Map<String, Object> consentElctrnsanctn(@RequestBody SanctnlnVO sanctnlnVO,
			@AuthenticationPrincipal CustomUser customUser) throws IOException {
		System.out.println(sanctnlnVO);
		Map<String, Object> map = new HashMap<>();
		EmpVO empVO = customUser.getEmpVO();
		int result = this.elctrnsanctnService.consentElctrnsanctn(sanctnlnVO, empVO);
		map.put("result", result);
		return map;
	}

	@GetMapping("/postElctrnsanctn")
	public String insertElctrnsanctn(Model model, @AuthenticationPrincipal CustomUser customUser) {

		List<DrftDocVO> drftDocVOList = this.elctrnsanctnService.getDrftDocList();

		EmpVO empVO = customUser.getEmpVO();
		List<DeptVO> deptVOList = this.elctrnsanctnService.getDeptList(empVO);
		List<BkmkSanctnlnVO> bkmkSanctnlnVOList = this.elctrnsanctnService.getBkmkSanctnlnList(empVO);

		Date now = new Date();
		model.addAttribute("bkmkSanctnlnVOList", bkmkSanctnlnVOList);
		model.addAttribute("now", now);
		model.addAttribute("empVO", empVO);
		model.addAttribute("deptVOList", deptVOList);
		model.addAttribute("drftDocVOList", drftDocVOList);


		return "elctrnsanctn/postElctrnsanctn";
	}
	
	//재상신
	@GetMapping("/postReElctrnsanctn")
	public String postReElctrnsanctn(Model model, ElctrnsanctnVO elctrnsanctnVO,
			@AuthenticationPrincipal CustomUser customUser) {
		EmpVO empVO = customUser.getEmpVO();
		elctrnsanctnVO = this.elctrnsanctnService.getElctrnsanctn(elctrnsanctnVO);

		if (!empVO.getEmpId().equals(elctrnsanctnVO.getEmpId())) {
			return "elctrnsanctn/getElctrnsanctnList";
		}

		List<FileDetailVO> fileDetailVOList = this.uploadService
				.getFileDetailVOList(elctrnsanctnVO.getFileGroupSn());
		
		List<DrftDocVO> drftDocVOList = this.elctrnsanctnService.getDrftDocList();
		List<DeptVO> deptVOList = this.elctrnsanctnService.getDeptList(empVO);
		List<BkmkSanctnlnVO> bkmkSanctnlnVOList = this.elctrnsanctnService.getBkmkSanctnlnList(empVO);
		Date now = new Date();
		
		model.addAttribute("bkmkSanctnlnVOList", bkmkSanctnlnVOList);
		model.addAttribute("deptVOList", deptVOList);
		model.addAttribute("now", now);
		model.addAttribute("drftDocVOList", drftDocVOList);
		model.addAttribute("empVO", empVO);
		model.addAttribute("fileDetailVOList", fileDetailVOList);
		model.addAttribute("elctrnsanctnVO", elctrnsanctnVO);

		return "elctrnsanctn/postReElctrnsanctn";
	}

	/**
	 * 전자결재 작성 폼을 로드하는 메서드. (redirected from /sendToSanctn)
	 * Flash Attribute로 전달된 파일 정보를 Model에 추가하여 View로 전달합니다.
	 * * @param model Flash Attribute 수신 및 View로 데이터 전달을 위한 객체
	 * @param customUser 현재 사용자 정보
	 * @return 전자결재 작성 폼 View
	 */
	@GetMapping("/postNewElctrnsanctn")// Flash Attribute 수신 용도로 고정
	public String postElctrnsanctn(Model model, @AuthenticationPrincipal CustomUser customUser) {

		EmpVO empVO = customUser.getEmpVO();
		long fileGroupSn = 0L; // 초기값 설정

		// 1. Flash Attribute로 전달된 파일 ID 수신
		// Flash Attribute는 Model에 자동으로 추가됩니다.
		if (model.containsAttribute("fileGroupSn")) {
			fileGroupSn = (long) model.getAttribute("fileGroupSn");
			long fileNo = (int) model.getAttribute("fileNo");
			String originalName = (String) model.getAttribute("fileOriginalName");

			log.info("Flash Data 수신 성공 - FileGroupSn: {}, FileNo: {}", fileGroupSn, fileNo);

			// 2. 수신된 fileGroupSn으로 DB에서 파일 목록을 다시 조회
			// (새로 생성된 PDF와 혹시 모를 다른 첨부 파일이 있다면 함께 가져옴)
			List<FileDetailVO> fileDetailVOList = this.uploadService
					.getFileDetailVOList(fileGroupSn);

			model.addAttribute("fileGroupSn", fileGroupSn); // 다음 POST 요청 시 재사용할 GroupSn을 명시적으로 전달
			model.addAttribute("fileDetailVOList", fileDetailVOList); // View에 첨부 파일 목록 표시
		}

		// 3. 폼 작성을 위한 보조 데이터 로드 (기존 로직과 유사)
		List<DrftDocVO> drftDocVOList = this.elctrnsanctnService.getDrftDocList();
		List<DeptVO> deptVOList = this.elctrnsanctnService.getDeptList(empVO);
		List<BkmkSanctnlnVO> bkmkSanctnlnVOList = this.elctrnsanctnService.getBkmkSanctnlnList(empVO);
		Date now = new Date();

		// 4. 모델에 담기
		model.addAttribute("bkmkSanctnlnVOList", bkmkSanctnlnVOList);
		model.addAttribute("deptVOList", deptVOList);
		model.addAttribute("now", now);
		model.addAttribute("drftDocVOList", drftDocVOList);
		model.addAttribute("empVO", empVO);

		// 5. View 반환
		return "elctrnsanctn/postElctrnsanctn"; // 전자결재 작성 폼 JSP
	}

	@ResponseBody
	@GetMapping("/getDrftDocFormat")
	public Map<String, Object> getDrftDocFormat(DrftDocVO drftDocVO, @AuthenticationPrincipal CustomUser customUser) {
		Map<String, Object> map = new HashMap<>();
		drftDocVO = this.elctrnsanctnService.getDrftDoc(drftDocVO);
		EmpVO empVO = customUser.getEmpVO();
		map.put("drftDocVO", drftDocVO);
		map.put("empVO", empVO);
		return map;
	}

	// 상신
	@ResponseBody
	@PostMapping("/postElctrnsanctn")
	public Map<String, Object> postElctrnsanctn(ElctrnsanctnVO elctrnsanctnVO,
			@RequestParam(value = "inputFiles", required = false) MultipartFile[] inputFiles,
			@RequestParam String sanctnlnEmpList, @RequestParam String drftRefrnEmpList) {
		Map<String, Object> map = new HashMap<>();
		elctrnsanctnVO.setDrftTmprstre(0);
		int result = this.elctrnsanctnService.postElctrnsanctn(elctrnsanctnVO, inputFiles);
		result += this.elctrnsanctnService.postSanctnlnDrftRefrn(sanctnlnEmpList, drftRefrnEmpList, elctrnsanctnVO);
		map.put("result", result);
		return map;
	}
	
	//재상신
	@ResponseBody
	@PostMapping("/postReElctrnsanctn")
	public Map<String, Object> postReElctrnsanctn(
			ElctrnsanctnVO elctrnsanctnVO,
			@RequestParam(value = "inputFiles", required = false) MultipartFile[] inputFiles,
			@RequestParam String sanctnlnEmpList, @RequestParam String drftRefrnEmpList) {		
		
		Map<String, Object> map = new HashMap<>();
		elctrnsanctnVO.setDrftTmprstre(0);
		int result = this.elctrnsanctnService.postElctrnsanctn(elctrnsanctnVO, inputFiles);
		result += this.elctrnsanctnService.postSanctnlnDrftRefrn(sanctnlnEmpList, drftRefrnEmpList, elctrnsanctnVO);
		map.put("result", result);
		return map;
	}


	

	// 임시저장
	@ResponseBody
	@PostMapping("/postTempElctrnsanctn")
	public Map<String, Object> postTempElctrnsanctn(ElctrnsanctnVO elctrnsanctnVO,
			@RequestParam(value = "inputFiles", required = false) MultipartFile[] inputFiles,
			@RequestParam String sanctnlnEmpList, @RequestParam String drftRefrnEmpList) {
		Map<String, Object> map = new HashMap<>();
		
		elctrnsanctnVO.setDrftTmprstre(1);
		int result = this.elctrnsanctnService.postElctrnsanctn(elctrnsanctnVO, inputFiles);
		result += this.elctrnsanctnService.postSanctnlnDrftRefrn(sanctnlnEmpList, drftRefrnEmpList, elctrnsanctnVO);
		map.put("result", result);
		return map;
	}

	@ResponseBody
	@PostMapping("/postBkmkSanctnln")
	public Map<String, Object> postBkmkSanctnln(@RequestBody BkmkSanctnlnDataVO bkmkSanctnlnDataVO,
			@AuthenticationPrincipal CustomUser customUser) {
		Map<String, Object> map = new HashMap<>();
		
		int result = this.elctrnsanctnService.postBkmkSanctnln(bkmkSanctnlnDataVO, customUser);
		map.put("result", result);
		return map;
	}

	@ResponseBody
	@GetMapping("/getBkmkSanctnln")
	public Map<String, Object> getBkmkSanctnln(BkmkSanctnlnVO bkmkSanctnlnVO) {
		Map<String, Object> map = new HashMap<>();
		bkmkSanctnlnVO = this.elctrnsanctnService.getBkmkSanctnln(bkmkSanctnlnVO);
		map.put("bkmkSanctnlnVO", bkmkSanctnlnVO);
		return map;
	}

	/**
	 * 최종 직인본을 DB에 등록하고 서명 요청 URL을 생성합니다.
	 * (이 메서드는 직인 완료 후 파일 ID를 받아 실행됩니다.)
	 * * @param fileGroupSn 직인된 PDF의 파일 그룹 SN
	 * @return HTML 형태의 테스트 URL
	 */
	@ResponseBody
	@PostMapping("/sendContractForSigning")
	public String sendContractForSigning(
			@RequestParam("fileGroupSn") long fileGroupSn,
			@RequestParam("fileNo") int fileNo,
			@RequestParam("toEmail") String toEmail,
			@RequestParam("ccpyCmpnyNm") String ccpyCmpnyNm) {
		// 서비스 호출: 모든 비즈니스 로직을 위임
		String signingUrl = contractService.sendSigningRequest(fileGroupSn, fileNo, toEmail, ccpyCmpnyNm);

		// 결과 반환 (URL만 받아서 메시지 구성)
		return "<h1>서명 요청 처리 완료</h1>";
	}



}
