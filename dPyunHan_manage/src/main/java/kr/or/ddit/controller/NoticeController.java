package kr.or.ddit.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.service.NoticeService;
import kr.or.ddit.service.impl.CustomUser;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.util.DownloadService;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.NoticeVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/notice")
public class NoticeController {

	@Autowired
	NoticeService noticeService;

	@Autowired
	UploadController uploadController;

	@Autowired
	DownloadService downloadService;
	
	// 리스트,
	@GetMapping("/list")
	public String list(NoticeVO noticeVO, Model model,
			@RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
			@RequestParam(value = "size", required = false, defaultValue = "10") int size) {

		Map<String, Object> map = new HashMap<>();
		map.put("keyword", keyword);
		map.put("currentPage", currentPage);
		map.put("size", size);

		List<NoticeVO> noticeList = this.noticeService.list(map);

		int total = this.noticeService.getTotal(map);

		ArticlePage<NoticeVO> articlePage = new ArticlePage<>(total, currentPage, size, noticeList, keyword);

		model.addAttribute("articlePage", articlePage);

		return "notice/list";
	}

	// 상세보기
	@GetMapping("/detail/{noticeSn}")
	public String detail(@PathVariable int noticeSn, Model model) {
		log.info("detail->noticeSn : {}", noticeSn);

		NoticeVO noticeVO = this.noticeService.findById(noticeSn);

		List<FileDetailVO> fileDetailVOList = this.noticeService.getFileDetailVOList(noticeVO.getFileGroupSn());

		model.addAttribute("noticeVO", noticeVO);
		model.addAttribute("fileDetailVOList", fileDetailVOList);
		return "notice/detail";
	}

	// 등록폼
	@PreAuthorize("hasRole('ADMIN')")
	@GetMapping("/register")
	public String registerForm(Model model) {

		return "notice/register";
	}

	// 등록
	@PostMapping("/register")
	public String register(@AuthenticationPrincipal CustomUser customUser, NoticeVO noticeVO, Model model,
			@RequestParam MultipartFile[] multipartFiles) {

		noticeVO.setEmpId(customUser.getEmpVO().getEmpId());

		log.info("register -> wnmpyNotice: {}", noticeVO.getWnmpyNotice());
		log.info("register -> noticeSj: {}", noticeVO.getNoticeSj());
		log.info("register -> noticeVO: {}", noticeVO);

		// 파일 null 검증 추가
		List<MultipartFile> validFiles = new ArrayList<>();
		if (multipartFiles != null) {
			for (MultipartFile file : multipartFiles) {
				if (!file.isEmpty() && file.getOriginalFilename() != null
						&& !file.getOriginalFilename().trim().isEmpty()) {
					validFiles.add(file);
				}
			}
		}

		long fileGroupSn = 0;
		if (!validFiles.isEmpty()) {
			fileGroupSn = uploadController.multiImageUpload(validFiles.toArray(new MultipartFile[0]));
		}

		noticeVO.setFileGroupSn(fileGroupSn);

		int register = this.noticeService.register(noticeVO);
		log.info("noticeVO->register : {}", register);

		model.addAttribute("successMessage", "공지사항이 등록되었습니다.");

		return "notice/register";
	}

	// 수정 Form
	@GetMapping("/edit/{noticeSn}")
	public String editForm(@PathVariable int noticeSn, Model model,
			@RequestParam(value = "edit", required = false, defaultValue = "false") boolean edit) {

		NoticeVO noticeVO = this.noticeService.findById(noticeSn);

		model.addAttribute("noticeVO", noticeVO);
		model.addAttribute("editMode", edit);

		return "notice/detail";
	}

	@PostMapping("/edit")
	public String edit(NoticeVO noticeVO) {

		this.noticeService.edit(noticeVO);

		return "redirect:/notice/list";
	}

	@PostMapping("/delete")
	public String delete(@RequestParam("noticeSn") int noticeSn) {

		this.noticeService.delete(noticeSn);

		return "redirect:/notice/list";
	}

	// 사내공지
	@PreAuthorize("hasAnyRole('EMP', 'ADMIN')")
	@GetMapping("/wnmpy_notice")
	public String wnmpyNoticeList(NoticeVO noticeVO, Model model,
			@RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
			@RequestParam(value = "size", required = false, defaultValue = "10") int size) {

		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		System.out.println("현재 사용자: " + auth.getName());
		System.out.println("권한: " + auth.getAuthorities());
		log.info("list -> noticeVO : {}", noticeVO);

		log.info("wnmpyNoticeList -> {}", noticeVO);

		Map<String, Object> map = new HashMap<>();
		map.put("keyword", keyword);
		map.put("currentPage", currentPage);
		map.put("size", size);
		map.put("wnmpyNotice", 1);

		List<NoticeVO> noticeList = this.noticeService.wnmpyNoticeList(map);
		int total = this.noticeService.getTotal(map);

		ArticlePage<NoticeVO> articlePage = new ArticlePage<>(total, currentPage, size, noticeList, keyword);
		model.addAttribute("articlePage", articlePage);

		return "notice/wnmpy_notice";
	}

	// 상세보기 (AJAX용)
	@PostMapping("/detail")
	@ResponseBody
	public Map<String, Object> detail(@RequestBody NoticeVO noticeVO) {
		log.info("detail->noticeVO : {}", noticeVO);

		int noticeSn = noticeVO.getNoticeSn();
		log.info("noticeSn : {}", noticeSn);

		noticeVO = this.noticeService.findById(noticeSn);

		List<FileDetailVO> fileDetailVOList = this.noticeService.getFileDetailVOList(noticeVO.getFileGroupSn());
		if (fileDetailVOList == null) {
			fileDetailVOList = new ArrayList<>();
		}

		Map<String, Object> map = new HashMap<>();
		map.put("noticeVO", noticeVO);
		map.put("fileDetailVOList", fileDetailVOList);

		return map;
	}

	// 이전글 / 다음글 기능
	@GetMapping("/listJson")
	@ResponseBody
	public Map<String, Object> listJson() {
		Map<String, Object> map = new HashMap<>();
		// 정렬: 최신순 (기본값)
		List<NoticeVO> noticeList = this.noticeService.findAll();

		map.put("noticeList", noticeList);
		return map;
	}

	
	@GetMapping("/download")
	public ResponseEntity<Resource> downloadFile(@RequestParam("fileGroupSn") long fileGroupSn,
			@RequestParam("fileNo") int fileNo) throws IOException {
		return downloadService.downloadFile(fileGroupSn, fileNo);
	}


	@GetMapping("/downloadAll")
	public ResponseEntity<Resource> downloadAll(@RequestParam("fileGroupSn") long fileGroupSn) throws IOException {
		return downloadService.downloadAll(fileGroupSn);
	}

}
