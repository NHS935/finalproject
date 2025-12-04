package kr.or.ddit.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.service.CcpyManageService;
import kr.or.ddit.service.EmailService;
import kr.or.ddit.service.OcrService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.util.DownloadService;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.vo.CcpyDtaVO;
import kr.or.ddit.vo.CcpyManageVO;
import kr.or.ddit.vo.FileDetailVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/ccpyManage")
public class CcpyManageController {
	@Autowired
	DownloadService downloadService;
	
	@Autowired
	private EmailService emailService;

	@Autowired
	private BCryptPasswordEncoder bCryptPasswordEncoder;

	@Autowired
	CcpyManageService ccpyManageService;

	@Autowired
	UploadController uploadController;

	@Autowired
	private OcrService ocrService;

	@GetMapping("/postCcpyManage")
	public String putCcpyManage() {
		return "ccpyManage/postCcpyManage";
	}

	@GetMapping("/loginCcpyManage")
	public String loginCcpyManage () {
		return "ccpyManage/loginCcpyManage";
	}
	
	@GetMapping("/wait")
	public String waitCcypy(
			CcpyManageVO ccpyManageVO,
			Model model
			) {
		ccpyManageVO = this.ccpyManageService.getCcpyManage(ccpyManageVO);
		model.addAttribute("ccpyManageVO", ccpyManageVO);
		return "ccpyManage/wait";
	}

	@ResponseBody
	@PostMapping("/postBizLicense")
	public Map<String, Object> postBizLicense(@RequestParam("uploadFile") MultipartFile uploadFile) {
		CcpyManageVO ccpyManageVO = null;
		String savedFilePath = null;
		Map<String, Object> map = new HashMap<>();
		try {
			savedFilePath = this.uploadController.uploadFile(uploadFile);
			JSONObject ocrResult = ocrService.processBizLicenseOcr(savedFilePath);
			ccpyManageVO = ocrService.extractCcpyManageVO(ocrResult);
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		map.put("ccpyManageVO", ccpyManageVO);
		return map;
	}

	@PostMapping("/postCcpyManage")
	public String postCcpyManage(CcpyManageVO ccpyManageVO,
			@RequestParam(value = "uploadFile", required = false) MultipartFile[] uploadFile,
			@RequestParam(value = "ccpyDtaList", required = false) MultipartFile[] uploadFiles) {		
		//사업자등록증
		long fileGroupSn = this.uploadController.multiImageUpload(uploadFile);
		ccpyManageVO.setFileGroupSn(fileGroupSn);
		
		//지원서류
		long ccpyDtaFileGroupSn = this.uploadController.multiImageUpload(uploadFiles);
		CcpyDtaVO ccpyDtaVO = new CcpyDtaVO();
		ccpyDtaVO.setFileGroupSn(ccpyDtaFileGroupSn);
		String encodedPassword = bCryptPasswordEncoder.encode(ccpyManageVO.getCcpyPassword());
		ccpyManageVO.setCcpyPassword(encodedPassword);
		int result = this.ccpyManageService.postCcpyManageVO(ccpyManageVO, ccpyDtaVO);
		return "redirect:/ccpyManage/wait?ccpyManageId="+ccpyManageVO.getCcpyManageId();
	}

	@GetMapping("/getCcpyManageGuestList")
	public String getCcpyManageList(
			Model model, 
			@RequestParam(required = false, defaultValue = "") String keyword,
			@RequestParam(required = false, defaultValue = "1") int currentPage
			) {
		Map<String, Object> map = new HashMap<>();
		map.put("keyword", keyword);
		map.put("currentPage", currentPage);

		List<CcpyManageVO> ccpyManageVOList = this.ccpyManageService.getCcpyManageGuestList(map);

		int size = 10;
		int total = this.ccpyManageService.getTotal(map);

		ArticlePage<CcpyManageVO> articlePage = new ArticlePage<CcpyManageVO>(total, currentPage, size,
				ccpyManageVOList, keyword);

		model.addAttribute("articlePage", articlePage);

		return "ccpyManage/getCcpyManageGuestList";
	}

	@GetMapping("/getCcpyManage")
	public String getCcpyManage(
			CcpyManageVO ccpyManageVO, 
			Model model) {
		ccpyManageVO = this.ccpyManageService.getCcpyManage(ccpyManageVO);
		
		//사업자등록증
		if(ccpyManageVO.getFileGroupSn()!=0L) {
			List<FileDetailVO> fileDetailVOList = this.uploadController.getFileDetailVOList(ccpyManageVO.getFileGroupSn());
			model.addAttribute("fileDetailVOList", fileDetailVOList);
		}
		
		//지원서류
		CcpyDtaVO ccpyDtaVO = this.ccpyManageService.getCcpyDta(ccpyManageVO);
		if(ccpyDtaVO !=null) {
			List<FileDetailVO> ccpyDtaFileDetailVOList = this.uploadController.getFileDetailVOList(ccpyDtaVO.getFileGroupSn());
			model.addAttribute("ccpyDtaFileDetailVOList",ccpyDtaFileDetailVOList);
		}
		
		model.addAttribute("ccpyManageVO", ccpyManageVO);
		return "ccpyManage/getCcpyManage";
	}	
	
	@GetMapping("/download")
	public ResponseEntity<Resource> downloadFile(@RequestParam("fileGroupSn") long fileGroupSn,
			@RequestParam("fileNo") int fileNo) throws IOException {
		return downloadService.downloadFile(fileGroupSn, fileNo);
	}

	@PostMapping("/downloadSelected")
	public ResponseEntity<Resource> downloadSelected(@RequestParam("fileGroupSn") List<Long> fileGroupSnList,
			@RequestParam("fileNo") List<Integer> fileNoList) throws IOException {
		return downloadService.downloadSelected(fileGroupSnList, fileNoList);
	}

	@GetMapping("/downloadAll")
	public ResponseEntity<Resource> downloadAll(@RequestParam("fileGroupSn") long fileGroupSn) throws IOException {
		return downloadService.downloadAll(fileGroupSn);
	}
		
	@ResponseBody
	@PostMapping("/sendCcpyApprovalEmail")
	public Map<String, Object> sendCcpyApprovalEmail(
			@RequestBody CcpyManageVO ccpyManageVO
			) {
		Map<String, Object> map = new HashMap<>();
		
		int res = this.ccpyManageService.putCcpyAuthor(ccpyManageVO);		
		ccpyManageVO = this.ccpyManageService.getCcpyManage(ccpyManageVO);
		try {
			boolean result = emailService.queueCcpyApprovalEmail(ccpyManageVO);
			map.put("success", result);	
			map.put("message", result ? "발송 이메일에 등록 완료, 수 분 내 발송" : "❌ 이메일 등록 실패");
		} catch(Exception e){
			map.put("success", false);
			map.put("message", "❌ 에러: " + e.getMessage());
		}
		return map;
	}
	
	@ResponseBody
	@PostMapping("/sendCcpyRejectionEmail")
	public Map<String, Object> sendCcpyRejectionEmail(
			@RequestBody CcpyManageVO ccpyManageVO
			){
		Map<String, Object> map = new HashMap<>();
		int res = this.ccpyManageService.putCcpySttsAsRej(ccpyManageVO);	
		ccpyManageVO = this.ccpyManageService.getCcpyManage(ccpyManageVO);
		try {
			boolean result = emailService.queueCcpyRejectionEmail(ccpyManageVO, "부적격");
			map.put("success", result);
			map.put("message", result ? "발송 이메일에 등록 완료, 수 분 내 발송" : "❌ 이메일 등록 실패");
		}catch(Exception e){
			map.put("success", false);
			map.put("message", "❌ 에러: " + e.getMessage());			
		}
		return map;
	}
	/**
	 * 협력업체 목록을 조회하여 JSON 리스트로 반환합니다.
	 * (계약서 서명 요청 모달에 데이터를 로드하기 위함)
	 * @return List<CcpyManageVO> (JSON으로 직렬화되어 반환됨)
	 */
	@ResponseBody
	@GetMapping("/getPartnerCompanies") // JavaScript에서 사용한 URL
	public List<CcpyManageVO> getPartnerCompanies() {

		// 1. 필요한 경우 필터링을 위한 Map 생성 (페이징 정보는 제외)
		Map<String, Object> map = new HashMap<>();
		 map.put("keyword", ""); // 필요하다면 검색 키워드를 여기에 설정할 수 있습니다.

		// 2. 모든 협력사 목록 조회
		// ⚠️ getCcpyManageGuestList 메서드가 Map을 인자로 받으며 List를 반환한다고 가정합니다.
		List<CcpyManageVO> ccpyManageVOList = this.ccpyManageService.getCcpyManageList(map);

		// 3. List 객체를 반환하면 Spring이 자동으로 JSON으로 변환하여 클라이언트로 전송합니다.
		return ccpyManageVOList;
	}


}
