package kr.or.ddit.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.service.BidPblancService;
import kr.or.ddit.service.CcpyManageService;
import kr.or.ddit.service.CvplRceptService;
import kr.or.ddit.service.ElctrncsanctnService;
import kr.or.ddit.service.EmpService;
import kr.or.ddit.service.FxService;
import kr.or.ddit.service.MberService;
import kr.or.ddit.service.NoticeService;
import kr.or.ddit.service.VoteMtrService;
import kr.or.ddit.service.impl.CustomUser;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.vo.BidPblancVO;
import kr.or.ddit.vo.CcpyManageVO;
import kr.or.ddit.vo.ElctrnsanctnVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.NoticeVO;
import kr.or.ddit.vo.VoteMtrVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class EmpViewController {
	@Autowired
	MberService mberService;
	@Autowired
	CcpyManageService ccpyManageService;
	@Autowired
	BCryptPasswordEncoder bCryptPasswordEncoder;
	@Autowired
	EmpService empService;
	@Autowired
	NoticeService noticeService;
	@Autowired
	BidPblancService bidPblancService;
	/* 11-13kbh 메인페이지 볼 기능들 추가 */
	@Autowired // 결재
	ElctrncsanctnService elctrnsanctnService;
	@Autowired // 민원
	CvplRceptService cvplRceptService;
	@Autowired // 투표
	VoteMtrService voteMtrService;
	@Autowired // 일정관리
	FxService fxService;
	/* kbh 추가 끝 */

	// 1. /login 요청 URI를 요청하면 login() 메서드로 매핑됨
	// 뷰리졸버에 의해 /WEB-INF/views/ + login + .jsp로 조립되어 forwarding
	@GetMapping("/login")
	public String login(Model model, HttpServletRequest request) {
		
	    // 1. 자동 로그아웃 로직 (새로 추가)
	    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    if (authentication != null && authentication.isAuthenticated()
	            && !"anonymousUser".equals(authentication.getPrincipal())) {
	        HttpSession session = request.getSession(false);
	        if (session != null) {
	            session.invalidate();
	        }
	        SecurityContextHolder.clearContext();
	    }
		
		log.info("java->" + bCryptPasswordEncoder.encode("qwer"));

		// 나혜선 시작 (11.6 수정함)
		Map<String, Object> map = new HashMap<>();

		map.put("limit", 5); // 5개씩의 글만 가져올거임

		List<NoticeVO> noticeVOList = noticeService.maingateselect(map);

		List<BidPblancVO> bidPblancVOList = bidPblancService.maingateget(map);

		log.info("noticeVOList : {}", noticeVOList);
		log.info("bidPblancVOList : {}", bidPblancVOList);

		model.addAttribute("noticeVOList", noticeVOList); // jsp에서 사용하기 위해 model에 담기
		model.addAttribute("bidPblancVOList", bidPblancVOList);
		// 나혜선 끝

		return "login"; // jsp
	}

	// 2. /signup 요청 URI를 요청하면 signup() 메서드로 매핑됨
	// 뷰리졸버에 의해 /WEB-INF/views/ + signup + .jsp로 조립되어 forwarding
	@GetMapping("/signup")
	public String signup() {

		return "signup"; // jsp
	}

	/*
	 * 요청URI : /user 요청파라미터 : request{email=test@test.com,password=asdf} 요청방식 : post
	 */

	@PostMapping("/user")
	public String signup(EmpVO empVO) {
		log.info("check: signup/empVO => {}", empVO);

		// 비밀번호 암호화
		String encodedPassword = bCryptPasswordEncoder.encode(empVO.getEmpPassword());
		empVO.setEmpPassword(encodedPassword);
		log.info("check: encodedPassword=>{}", encodedPassword);

		return "main";

	}

	@GetMapping("/main")
	public String main(
			/* kbh추가 메인화면에서 보여줄 항목 가져오기 articlePage1은 민원 2는 결재 */
			Model model, @RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
			@RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
			@RequestParam(value = "periodFrom", required = false) String periodFrom,
			@RequestParam(value = "periodTo", required = false) String periodTo,
			@RequestParam(value = "stat", required = false) String stat,
			@RequestParam(value = "start", required = false) String start /* start, end는 캘린더 */
			, @RequestParam(value = "end", required = false) String end,
			@RequestParam(value = "size", required = false, defaultValue = "5") int size // 한페이지에 보여줄 글 수
			, @AuthenticationPrincipal CustomUser customUser) {
		// 한 화면에 보여질 행의 수
		// 전체 행의 수*
		// 시작,끝 시간이 뒤집히면 역전시키기 //문자열 사전순으로 비교메서드(compareTo)
		if (periodFrom != null && periodTo != null && periodFrom.compareTo(periodTo) > 0) {
			String tmp = periodFrom;
			periodFrom = periodTo;
			periodTo = tmp;
		}
		// 투표리스트 목록
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("currentPage", currentPage);
		map.put("keyword", keyword);
		map.put("periodFrom", periodFrom);
		map.put("periodTo", periodTo);
		map.put("stat", stat);
		map.put("size", size);
		// total에 넣자
		int total = this.voteMtrService.getTotal(map);

		// detail에서 voteMtrList를 써서 voteMtr2VO로 했음 //목록조회 (여기에 다담겨옴)
		List<VoteMtrVO> voteMtrVOList2 = this.voteMtrService.voteList(map);

		// 결재 목록 (보낸거 5줄 받은거 5줄)
		// 2025-11-18 KWH
		EmpVO empVO = customUser.getEmpVO();
		// 보낸 기안함
		Map<String, Object> elctrnsanctnSentMap = new HashMap<>();
		elctrnsanctnSentMap.put("empId", empVO.getEmpId());
		elctrnsanctnSentMap.put("currentPage", currentPage);
		elctrnsanctnSentMap.put("keyword", keyword);
		elctrnsanctnSentMap.put("size", size);
		List<ElctrnsanctnVO> elctrnsanctnVOListSent = this.elctrnsanctnService.getElctrnsanctnList(elctrnsanctnSentMap);
		int totalSent = this.elctrnsanctnService.getTotal(elctrnsanctnSentMap);

		ArticlePage<ElctrnsanctnVO> articlePageElctrnsanctnSent = new ArticlePage<ElctrnsanctnVO>(totalSent,
				currentPage, size, elctrnsanctnVOListSent, keyword);
		model.addAttribute("articlePageElctrnsanctnSent", articlePageElctrnsanctnSent);
		// 보낸 기안함

		// 받은 기안함
		Map<String, Object> elctrnsanctnRcptMap = new HashMap<>();
		elctrnsanctnRcptMap.put("empId", empVO.getEmpId());
		elctrnsanctnRcptMap.put("currentPage", currentPage);
		elctrnsanctnRcptMap.put("empId", empVO.getEmpId());
		elctrnsanctnRcptMap.put("size", size);
		List<ElctrnsanctnVO> elctrnsanctnVOListRcpt = this.elctrnsanctnService
				.getElctrnsanctnRcptList(elctrnsanctnRcptMap);
		int totalRcpt = this.elctrnsanctnService.getTotalRcpt(elctrnsanctnRcptMap);

		ArticlePage<ElctrnsanctnVO> articlePageElctrnsanctnRcpt = new ArticlePage<ElctrnsanctnVO>(totalRcpt,
				currentPage, size, elctrnsanctnVOListRcpt, keyword);
		model.addAttribute("articlePageElctrnsanctnRcpt", articlePageElctrnsanctnRcpt);
		// 받은 기안함
		// 결재 목록

		// 입찰공고관리
		Map<String, Object> bidPblancMap = new HashMap<>();
		bidPblancMap.put("currentPage", currentPage);
		bidPblancMap.put("keyword", keyword);
		bidPblancMap.put("size", size);

		int bidPblancTotal = this.bidPblancService.getTotal(bidPblancMap);

		List<BidPblancVO> bidPblancVOList = this.bidPblancService.getBidPblancListAsEmp(bidPblancMap);

		ArticlePage<BidPblancVO> articlePageBidPblanc = new ArticlePage<BidPblancVO>(bidPblancTotal, currentPage, size,
				bidPblancVOList, keyword);

		model.addAttribute("articlePageBidPblanc", articlePageBidPblanc);
		// 입찰공고관리

		// 협력업체관리
		Map<String, Object> ccpyManageMap = new HashMap<>();
		ccpyManageMap.put("keyword", keyword);
		ccpyManageMap.put("currentPage", currentPage);
		ccpyManageMap.put("size", size);
		List<CcpyManageVO> ccpyManageVOList = this.ccpyManageService.getCcpyManageGuestList(ccpyManageMap);

		int ccpyManageTotal = this.ccpyManageService.getTotal(ccpyManageMap);

		ArticlePage<CcpyManageVO> articlePageCcpyManage = new ArticlePage<CcpyManageVO>(ccpyManageTotal, currentPage,
				size, ccpyManageVOList, keyword);

		model.addAttribute("articlePageCcpyManage", articlePageCcpyManage);
		// 협력업체관리

		// kbh 2025-11-18 사내공지 추가 5개
		Map<String, Object> wnmpyMap = new HashMap<>();
		wnmpyMap.put("keyword", "");
		wnmpyMap.put("currentPage", 1);
		wnmpyMap.put("size", 5);
		wnmpyMap.put("wnmpyNotice", 1);
		// 서비스 호출
		List<NoticeVO> wnmpyNoticeList = this.noticeService.wnmpyNoticeList(wnmpyMap);
		// 모델에 담기
		model.addAttribute("wnmpyNoticeList", wnmpyNoticeList);
		// 사내공지 추가 끝.
		// kbh 11-18 멤버숫자id값으로 count
		int memNum = this.mberService.getMemNum();
		model.addAttribute("memNum", memNum);
		// 멤버숫자id값으로 count끝
		// 입주민관리 처리상태가 완료(2)가 아닌 민원건수 count
		int cvplRceptNum = this.cvplRceptService.getCvplRceptNum();
		model.addAttribute("cvplRceptNum",cvplRceptNum);
		// 입주민관리 처리상태가 완료(2)가 아닌 민원건수 count 끝
		// 투표
		// 페이지네이션
		ArticlePage<VoteMtrVO> articlePage1 = new ArticlePage<VoteMtrVO>(total, currentPage, size, voteMtrVOList2,
				keyword);
		
		//나혜선 추가
		//캘린더 담당자 목록 불러오기
		List<EmpVO> empList = empService.getEmpList();

		model.addAttribute("voteMtrVOList2", voteMtrVOList2);
		model.addAttribute("articlePage1", articlePage1);
		model.addAttribute("keyword", keyword);
		model.addAttribute("periodFrom", periodFrom);
		model.addAttribute("periodTo", periodTo);
		model.addAttribute("stat", stat);
		model.addAttribute("empList",empList);
		
		// 투표
		/* 투표 정보,캘린더 불러오기 끝 */

		return "main"; // /WEB-INF/views/main.jsp 가 존재해야 합니다.
	}
	
}
