package kr.or.ddit.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.service.BdderService;
import kr.or.ddit.service.BidPblancService;
import kr.or.ddit.service.CcpyManageService;
import kr.or.ddit.service.EmailService;
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
@Slf4j
@RequestMapping("/bdder")
public class BdderController {
	@Autowired
	DownloadService downloadService;

	@Autowired
	private EmailService emailService;

	@Autowired
	BidPblancService bidPblancService;

	@Autowired
	CcpyManageService ccpyManageService;

	@Autowired
	UploadController uploadController;

	@Autowired
	BdderService bdderService;

	@GetMapping("/postBdder")
	public String postBidder(@RequestParam int bidPblancSn, HttpSession session, Model model,
			Authentication authentication, @AuthenticationPrincipal CustomUser customuser) {

		CcpyManageVO ccpyManageVO = customuser.getCcpyManageVO();
		List<FileDetailVO> ccpyfileDetailVOList = this.uploadController
				.getFileDetailVOList(ccpyManageVO.getFileGroupSn());

		BidPblancVO bidPblancVO = new BidPblancVO();
		bidPblancVO.setBidPblancSn(bidPblancSn);

		bidPblancVO = this.bidPblancService.getBidPblancVO(bidPblancVO);

		List<FileDetailVO> bidPblancFileDetailVOList = this.uploadController
				.getFileDetailVOList(bidPblancVO.getFileGroupSn());

		model.addAttribute("bidPblancVO", bidPblancVO);
		model.addAttribute("bidPblancFileDetailVOList", bidPblancFileDetailVOList);
		model.addAttribute("ccpyFileDetailVOList", ccpyfileDetailVOList);
		model.addAttribute("ccpyManageVO", ccpyManageVO);
		model.addAttribute("now", new Date());
		model.addAttribute("bidPblancVO", bidPblancVO);

		return "bdder/postBdder";
	}

	@PostMapping("/postBdder")
	public String postBdder(BdderVO bdderVO, BidPblancVO bidPblancVO, CcpyManageVO ccpyManageVO,
			@RequestParam(value = "inputFiles", required = false) MultipartFile[] uploadFiles) {
		long fileGroupSn = this.uploadController.multiImageUpload(uploadFiles);
		
		bdderVO.setBidPblancSn(bidPblancVO.getBidPblancSn());
		bdderVO.setCcpyManageId(ccpyManageVO.getCcpyManageId());
		bdderVO.setFileGroupSn(fileGroupSn);
		
		log.info("check : postBdder/bdderVO => {}", bdderVO);
		int result = this.bdderService.postBdder(bdderVO);
		if (result > 0) {
			return "redirect:/bdder/getMyBdderList";
		}
		return "error";
	}

	@GetMapping("/getMyBdderList")
	public String getMyBidderList(Model model, @RequestParam(required = false, defaultValue = "") String keyword,
			@RequestParam(required = false, defaultValue = "1") int currentPage,
			@AuthenticationPrincipal CustomUser customUser) {
		CcpyManageVO ccpyManageVO = customUser.getCcpyManageVO();
		int size = 10;

		Map<String, Object> map = new HashMap<>();
		map.put("currentPage", currentPage);
		map.put("keyword", keyword);
		map.put("ccpyManageId", ccpyManageVO.getCcpyManageId());

		List<BdderVO> myBdderVOList = this.bdderService.getMyBdderList(map);
		int total = this.bdderService.getTotal(map);

		ArticlePage<BdderVO> articlePage = new ArticlePage<BdderVO>(total, currentPage, size, myBdderVOList, keyword);

		model.addAttribute("articlePage", articlePage);
		return "bdder/getMyBdderList";
	}

	@GetMapping("/getBdder")
	public String getBdder(BdderVO bdderVO, Model model) {
		bdderVO = this.bdderService.getBdder(bdderVO);

		List<FileDetailVO> bdderFileDetailVOList = this.uploadController
				.getFileDetailVOList(bdderVO.getFileGroupSn());
		
		CcpyManageVO ccpyManageVO = bdderVO.getCcpyManageVO();

		List<FileDetailVO> ccpyfileDetailVOList = this.uploadController
				.getFileDetailVOList(ccpyManageVO.getFileGroupSn());

		BidPblancVO bidPblancVO = bdderVO.getBidPblancVO();

		List<FileDetailVO> bidPblancFileDetailVOList = this.uploadController
				.getFileDetailVOList(bidPblancVO.getFileGroupSn());
		
		model.addAttribute("bdderFileDetailVOList", bdderFileDetailVOList);
		model.addAttribute("bidPblancFileDetailVOList", bidPblancFileDetailVOList);
		model.addAttribute("ccpyFileDetailVOList", ccpyfileDetailVOList);

		model.addAttribute("bdderVO", bdderVO);
		return "bdder/getBdder";
	}

	@ResponseBody
	@PostMapping("/putBdder")
	public Map<String, Object> putBdder(BdderVO bdderVO, BidPblancVO bidPblancVO, CcpyManageVO ccpyManageVO) {
		Map<String, Object> map = new HashMap<>();
		bidPblancVO = this.bidPblancService.getBidPblancVO(bidPblancVO);
		int res = this.bidPblancService.putBidPblanc(bidPblancVO);
		bdderVO = this.bdderService.getBdder(bdderVO);
		res = this.bdderService.putBdder(bdderVO);
		ccpyManageVO = this.ccpyManageService.getCcpyManage(ccpyManageVO);

		try {
			boolean result = emailService.queueBidSelectionEmail(bdderVO);
			map.put("success", result);
			map.put("message", result ? "발송 이메일에 등록 완료, 수 분 내 발송" : "❌ 이메일 등록 실패");

		} catch (Exception e) {
			map.put("success", false);
			map.put("message", "❌ 에러: " + e.getMessage());
		}
		return map;
	}

	@GetMapping("/previewFile")
	public ResponseEntity<?> previewFile(@RequestParam long fileGroupSn, @RequestParam int fileNo) {
		return downloadService.previewFile(fileGroupSn, fileNo);
	}

}
