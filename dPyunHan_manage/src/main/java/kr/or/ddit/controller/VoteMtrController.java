package kr.or.ddit.controller;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import kr.or.ddit.RestFulCrudApplication;
import kr.or.ddit.service.KakaoService;
import kr.or.ddit.service.VoteMtrService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.vo.VoteIemVO;
import kr.or.ddit.vo.VoteMtrVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/vote")

public class VoteMtrController {

    private final RestFulCrudApplication restFulCrudApplication;
	@Autowired
	VoteMtrService voteMtrService;
	
	@Autowired
	KakaoService kakaoService;

    VoteMtrController(RestFulCrudApplication restFulCrudApplication) {
        this.restFulCrudApplication = restFulCrudApplication;
    }
	//관리자가 보는 List페이지 
	@GetMapping("/voteMtr")
	public String voteList(Model model,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
			@RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
			@RequestParam(value = "periodFrom",  required = false) String periodFrom,
	        @RequestParam(value = "periodTo",    required = false) String periodTo,
	        @RequestParam(value = "stat",        required = false) String stat,
	        @RequestParam(value="size", required=false, defaultValue="15") int size //한페이지에 보여줄 글 수
	        ) {
		// 한 화면에 보여질 행의 수
		// 전체 행의 수*
		// 시작,끝 시간이 뒤집히면 역전시키기					//문자열 사전순으로 비교메서드(compareTo)
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
	    log.info("voteList->total : " + total);
		
		//detail에서 voteMtrList를 써서 voteMtr2VO로 했음 //목록조회 (여기에 다담겨옴)
		List<VoteMtrVO> voteMtrVOList2 = this.voteMtrService.voteList(map);
		log.info("voteList->voteMtrVOList2 : " + voteMtrVOList2);
		
		//직원이름 하나하나 담기 2025-11-13kbh추가
		for (VoteMtrVO voteMtrVO : voteMtrVOList2) {
		    String empId = voteMtrVO.getEmpId();
		    log.info("voteList -> row empId : {}", empId);

		    if (empId != null && !empId.isEmpty()) {
		        String nm = this.voteMtrService.findEmpNm(empId);
		        log.info("voteList -> row nm : {}", nm);
		        voteMtrVO.setNm(nm);   // VO 안의 nm 필드에 이름 넣기
		    }
		}
		//직원이름 하나하나 담기 2025-11-13kbh추가끝

		
		
		// 페이지네이션
		ArticlePage<VoteMtrVO> articlePage = new ArticlePage<VoteMtrVO>(total, currentPage, size, voteMtrVOList2, keyword);

		model.addAttribute("voteMtrVOList2", voteMtrVOList2);
		model.addAttribute("articlePage", articlePage);
		model.addAttribute("keyword", keyword);
	    model.addAttribute("periodFrom", periodFrom);
	    model.addAttribute("periodTo", periodTo);
	    model.addAttribute("stat", stat);
		log.info("list->voteMtrVOList2 : " + voteMtrVOList2);
		log.info("list->articlePage : " + articlePage);

		return "vote/voteMtr";
	}
	//등록되어있는 투표글 보는페이지
	@GetMapping("/voteDetail")
	public String voteDetail(VoteMtrVO voteMtrVO, Model model) {
		log.info("voteDetail -> voteMtrVO : {}  ",voteMtrVO);
		
		//호출
		VoteMtrVO resultVO = this.voteMtrService.voteMtrList(voteMtrVO);
		log.info("voteDetail -> resultVO : {}", resultVO);
	    // empId를 VO에서 가져오기 2025-11-13kbh추가
	    String empId = resultVO.getEmpId();  
	    log.info("voteDetail -> empId : {}", empId);
	    // 글쓴이 이름 찾아오기
	    String nm = this.voteMtrService.findEmpNm(empId);
	    log.info("voteDetail -> nm : {}", nm);
		
		
		
        model.addAttribute("voteMtrVO", resultVO);
        model.addAttribute("nm", nm);	//이름 넣자
	    log.info("voteDetail-> voteMtrVO :" , voteMtrVO);
		return "vote/voteDetail";
	}
	//투표 등록페이지
	@PreAuthorize("hasRole('ROLE_EMP')")
	@GetMapping("/addVotePage")
	public String addVotePage( ) {
		
		return "vote/addVotePage";
	}
	   //실제 투표 데이터 db에 넣음
	   @PreAuthorize("hasRole('ROLE_EMP')")
	   @PostMapping("/addVote")
	   public String addVoteWithIems(@ModelAttribute VoteMtrVO voteMtrVO ,Principal principal)  {
	      
	      voteMtrVO.setEmpId(principal.getName());//empId불러오기
	      log.info("addVote-> principal : {} ", principal);
	      List<VoteIemVO> voteIemVOList = voteMtrVO.getVoteIemVOList();
	      
	      int result = this.voteMtrService.addVoteWithIems(voteMtrVO, voteMtrVO.getVoteIemVOList());
	      
	    //나혜선 추가 시작(11.6일 수정함)
			
			//카카오톡 알림
			if(result>0) {
				kakaoService.sendVotenotice(voteMtrVO.getMtrSj(), //카카오톡 본문 표시: 투표 제목
				 //"http://localhost:8272/vote/goVote?voteMtrSn=" + voteMtrVO.getVoteMtrSn());  //http://localhost:8020/vote/voteDetail?voteMtrSn=2 처럼 입주민이 링크 클릭해서 들어갈 목록
						"vote/goVote?voteMtrSn=" + voteMtrVO.getVoteMtrSn());
			}		
			//나혜선 추가 끝
	      
	      log.info("addVote -> voteMtrVO : {} ", voteMtrVO);
	      log.info("addVote -> voteIemVOList : {} ", voteIemVOList);
	      log.info("addVote -> result : {} ", result);
	      
	      return "redirect:/vote/voteMtr";
	   }
	}