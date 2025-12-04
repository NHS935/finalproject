package kr.or.ddit.controller;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
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

import kr.or.ddit.service.BdderService;
import kr.or.ddit.service.BidPblancService;
import kr.or.ddit.service.impl.CustomUser;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.util.DownloadService;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.vo.BdderVO;
import kr.or.ddit.vo.BidPblancVO;
import kr.or.ddit.vo.CcpyManageVO;
import kr.or.ddit.vo.FileDetailVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/bidPblanc")
@Slf4j
public class BidPblancController {

	@Autowired
	DownloadService downloadService;

	@Autowired
	BdderService bdderService;

	@Autowired
	UploadController uploadService;

	@Autowired
	BidPblancService bidPblancService;

	@GetMapping("/getBidPblancListAsEmp")
	public String getBidPblancListAsEmp(Model model, @RequestParam(required = false, defaultValue = "") String keyword,
			@RequestParam(required = false, defaultValue = "1") int currentPage) {
		int size = 10;
		Map<String, Object> map = new HashMap<>();
		map.put("currentPage", currentPage);
		map.put("keyword", keyword);

		int total = this.bidPblancService.getTotal(map);

		List<BidPblancVO> bidPblancVOList = this.bidPblancService.getBidPblancListAsEmp(map);

		ArticlePage<BidPblancVO> articlePage = new ArticlePage<BidPblancVO>(total, currentPage, size, bidPblancVOList,
				keyword);

		model.addAttribute("articlePage", articlePage);

		return "bidPblanc/getBidPblancListAsEmp";
	}

	@GetMapping("/getBidPblancList")
	public String getBidPblancList(Model model, @RequestParam(required = false, defaultValue = "") String keyword,
			@RequestParam(required = false, defaultValue = "1") int currentPage,
			@RequestParam(required = false, defaultValue = "") String bidSttus,
			@RequestParam(required = false, defaultValue = "") String scsbMth,
			@RequestParam(required = false, defaultValue = "") String cdltPresentnAt,
			@RequestParam(required = false, defaultValue = "") String acmsltproofPresentnAt,
			@RequestParam(required = false, defaultValue = "pblancDt") String dateType,
			@RequestParam(required = false, defaultValue = "") String startDate,
			@RequestParam(required = false, defaultValue = "") String endDate,
			@RequestParam(required = false, defaultValue = "") String sortField,
		    @RequestParam(required = false, defaultValue = "desc") String sortDirection,
			@AuthenticationPrincipal CustomUser customUser
			) {
		int size = 10;

		Map<String, Object> map = new HashMap<>();
		map.put("currentPage", currentPage);
		map.put("keyword", keyword);
		map.put("bidSttus", bidSttus);
		map.put("scsbMth", scsbMth);
		map.put("cdltPresentnAt", cdltPresentnAt);
		map.put("acmsltproofPresentnAt", acmsltproofPresentnAt);
		map.put("dateType", dateType);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("sortField", sortField);
	    map.put("sortDirection", sortDirection);

		int total = this.bidPblancService.getTotal(map);

		List<BidPblancVO> bidPblancVOList = this.bidPblancService.getBidPblancList(map);

		ArticlePage<BidPblancVO> articlePage = new ArticlePage<BidPblancVO>(total, currentPage, size, bidPblancVOList,
				map);

		if (customUser != null) {
			if (customUser.getCcpyManageVO() != null) { // 직원이 로그인한 경우 문제 발생! 통합시 제거 예정
				CcpyManageVO ccpyManageVO = customUser.getCcpyManageVO();
				for (BidPblancVO bidPblancVO : articlePage.getContent()) {
					BdderVO existingBid = this.bdderService.getExistingBid(ccpyManageVO.getCcpyManageId(),
							bidPblancVO.getBidPblancSn());
					if (existingBid != null) {
						bidPblancVO.setHasAlreadyBid(true);
					}
				}
			}
		}
		model.addAttribute("articlePage", articlePage);

		return "bidPblanc/getBidPblancList";
	}

	@GetMapping("/getBidPblancAsEmp")
	public String getBidPblancAsEmp(Model model, BidPblancVO bidPblancVO,
			@RequestParam(required = false, defaultValue = "") String keyword,
			@RequestParam(required = false, defaultValue = "1") int currentPage) {
		bidPblancVO = this.bidPblancService.getBidPblancVO(bidPblancVO);
		Long fileGroupSn = bidPblancVO.getFileGroupSn();
		log.info("check : getBidPblancAsEmp/fileGroupSn => {}", fileGroupSn);

		List<FileDetailVO> fileDetailVOList = this.uploadService.getFileDetailVOList(fileGroupSn);
		model.addAttribute("bidPblancVO", bidPblancVO);
		model.addAttribute("fileDetailVOList", fileDetailVOList);

		int size = 5;
		Map<String, Object> map = new HashMap<>();
		map.put("bidPblancSn", bidPblancVO.getBidPblancSn());
		map.put("currentPage", currentPage);
		map.put("keyword", keyword);
		int total = this.bdderService.getTotal(map);

		List<BdderVO> bdderVOList = this.bdderService.getBdderList(map);

		ArticlePage<BdderVO> articlePage = new ArticlePage<BdderVO>(total, currentPage, size, bdderVOList, keyword);

		model.addAttribute("articlePage", articlePage);
		return "bidPblanc/getBidPblancAsEmp";
	}

	@GetMapping("/getBidPblanc")
	public String getBidPblanc(Model model, BidPblancVO bidPblancVO, @AuthenticationPrincipal CustomUser customUser) {
		bidPblancVO = this.bidPblancService.getBidPblancVO(bidPblancVO);

		if (customUser != null) {
			CcpyManageVO ccpyManageVO = customUser.getCcpyManageVO();

			Boolean hasAlreadyBid = false;
			BdderVO existingBid = this.bdderService.getExistingBid(ccpyManageVO.getCcpyManageId(),
					bidPblancVO.getBidPblancSn());
			if (existingBid != null) {
				hasAlreadyBid = true;
			}
			model.addAttribute("hasAlreadyBid", hasAlreadyBid); // 입찰 여부
			model.addAttribute("existingBid", existingBid); // 입찰 정보
		}

		Long fileGroupSn = bidPblancVO.getFileGroupSn();

		List<FileDetailVO> fileDetailVOList = this.uploadService.getFileDetailVOList(fileGroupSn);

		model.addAttribute("bidPblancVO", bidPblancVO);
		model.addAttribute("fileDetailVOList", fileDetailVOList);
		return "bidPblanc/getBidPblanc";
	}

	@GetMapping("/postBidPblanc")
	public String postBidPblanc(Model model) {
		Date now = new Date();
		model.addAttribute("now", now);
		return ("bidPblanc/postBidPblanc");
	}

	@ResponseBody
	@PostMapping("/postBidPblanc")
	public Map<String, Object> postBidPblanc(BidPblancVO bidPblancVO,
			  @RequestParam(value = "uploadFiles", required = false) MultipartFile[] uploadFiles) {

		long fileGroupSn = this.uploadService.multiImageUpload(uploadFiles);
		
		bidPblancVO.setFileGroupSn(fileGroupSn);

		int result = this.bidPblancService.postBidPblanc(bidPblancVO);

		Map<String, Object> map = new HashMap<>();
		return map;
	}

	@ResponseBody
	@PostMapping("/getFileDetailVOList")
	public Map<String, Object> getFileDetailVOList(@RequestBody BidPblancVO bidPblancVO) {
		bidPblancVO = this.bidPblancService.getBidPblancVO(bidPblancVO);
		Long fileGroupSn = bidPblancVO.getFileGroupSn();
		List<FileDetailVO> fileDetailVOList = this.uploadService.getFileDetailVOList(fileGroupSn);

		Map<String, Object> map = new HashMap<>();

		map.put("result", 1);
		map.put("fileDetailVOList", fileDetailVOList);
		return map;
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

}
