package kr.or.ddit.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.NoticeService;
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
	
	//리스트,
	@GetMapping("/list")
	public String list(Model model
			, @RequestParam(value="searchField", required=false) String[] searchField
			, @RequestParam(value="status", required=false, defaultValue="") String status
			, @RequestParam(value="startDate", required=false, defaultValue="") String startDate
			, @RequestParam(value="endDate", required=false, defaultValue="") String endDate
			, @RequestParam(value="keyword", required=false, defaultValue="") String keyword
			, @RequestParam(value = "sortOrder", required = false, defaultValue = "desc") String sortOrder
			, @RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage
			, @RequestParam(value="size", required=false, defaultValue="10") int size){
		
		Map<String, Object> map = new HashMap<>();
		map.put("keyword", keyword);
		map.put("currentPage", currentPage);
		map.put("size", size);
		map.put("wnmpyNotice", 0);
		map.put("searchField", searchField); // 검색용 친구들
		map.put("status", status);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("sortOrder", sortOrder);
		
		List<NoticeVO> noticeList = this.noticeService.list(map);
		
		int total = this.noticeService.getTotal(map);
		
		log.info("wnmpyNotice =>: {}", map);
		ArticlePage<NoticeVO> articlePage = new ArticlePage<>(total, currentPage, size, noticeList, keyword);
		
		model.addAttribute("articlePage",articlePage);
		model.addAttribute("searchField", searchField);
		model.addAttribute("keyword", keyword);
		model.addAttribute("status", status);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		model.addAttribute("sortOrder", sortOrder);
		
		return "notice/list";
	}
	
	//상세보기
		@PostMapping("/detail")
		@ResponseBody
		public Map<String, Object> detail(
				@RequestBody NoticeVO noticeVO) {
			log.info("detail->noticeVO : {}", noticeVO);
			
			int noticeSn = noticeVO.getNoticeSn();
			log.info("noticeSn : {}", noticeSn);
			
			noticeVO = this.noticeService.findById(noticeSn);
			
			List<FileDetailVO> fileDetailVOList = this.noticeService.getFileDetailVOList(noticeVO.getFileGroupSn());
			
			Map<String,Object> map = new HashMap<>();
			map.put("noticeVO", noticeVO);
			map.put("fileDetailVOList", fileDetailVOList);
			
			return map;
		}
		
		//이전글 / 다음글 기능
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