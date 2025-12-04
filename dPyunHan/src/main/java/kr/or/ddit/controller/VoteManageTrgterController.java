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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.service.VoteManageTrgterService;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.vo.VoteManageTrgterVO;
import kr.or.ddit.vo.VoteMtrVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/vote")
public class VoteManageTrgterController {

	@Autowired
	VoteManageTrgterService voteManageTrgterService;
	@PreAuthorize("hasRole('ROLE_MBER')")
	@GetMapping("/memVoteList")
	public String memVoteList(Model model, Principal principal,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
			@RequestParam(value = "keyword",     required = false, defaultValue = "") String keyword,
			@RequestParam(value = "periodFrom",  required = false) String periodFrom,
	        @RequestParam(value = "periodTo",    required = false) String periodTo,
	        @RequestParam(value = "stat",        required = false) String stat) {
			if(principal==null || principal.getName().equals("")) { //로그인안되면 로그인으로 돌려보내기
				return "redirect:/login";
			}
			log.info("VoteMtrController -> voteMtrVO : {}", model);
			String mberId = principal.getName();
			
			// 한 화면에 보여질 행의 수
			int size = 10;		
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
			map.put("mberId", mberId);
			map.put("periodFrom", periodFrom);
		    map.put("periodTo", periodTo);
		    map.put("stat", stat);
		    map.put("size", size);     

			// 전체 행의 수*
			int total = this.voteManageTrgterService.getTotal(map);
			log.info("voteList->total : " + total);
			//목록조회 (여기에 다담겨옴)
			List<VoteMtrVO> voteMtrVOList = this.voteManageTrgterService.memVoteList(map);
			log.info("voteList->voteMtrVOList : " + voteMtrVOList);		
			
			//직원이름 하나하나 담기 2025-11-13kbh추가
			for (VoteMtrVO voteMtrVO : voteMtrVOList) {
			    String empId = voteMtrVO.getEmpId();
			    log.info("memVoteList -> row empId : {}", empId);

			    if (empId != null && !empId.isEmpty()) {
			        String nm = this.voteManageTrgterService.findEmpNm(empId);
			        log.info("memVoteList -> row nm : {}", nm);
			        voteMtrVO.setNm(nm);   // VO 안의 nm 필드에 이름 넣기
			    }
			}
			//직원이름 하나하나 담기 2025-11-13kbh추가끝
			
			// 페이지네이션
			ArticlePage<VoteMtrVO> articlePage = new ArticlePage<VoteMtrVO>(total, currentPage, size, voteMtrVOList, keyword);

			model.addAttribute("voteMtrVOList", voteMtrVOList);
			model.addAttribute("articlePage", articlePage);
			model.addAttribute("keyword", keyword);
		    model.addAttribute("periodFrom", periodFrom);
		    model.addAttribute("periodTo", periodTo);
		    model.addAttribute("stat", stat);
			log.info("list->voteMtrVOList : " + voteMtrVOList); 
			log.info("list->articlePage : " + articlePage);

			
			return "vote/memVoteList"; 
	}	
	// 모달누를때 나오는 정보
	@ResponseBody
	@PostMapping("memVoteList")
	public Map<String, Object> voteMtrList(@RequestBody VoteMtrVO voteMtrVO,VoteManageTrgterVO voteManageTrgterVO ,HttpSession session) {
		// memberId 넣기
		String mberId = (String) session.getAttribute("mberId");
	    voteManageTrgterVO.setMberId(mberId);
		
		log.info("goVote -> voteMtrVO전 : {}  ", voteMtrVO);
		VoteMtrVO resultVO = voteManageTrgterService.voteMtrList(voteMtrVO);
		/* kbh 2025-11-17 empId기준으로 nm찾아오기 */
		//empId가져오고, empId기준으로 nm가져오기				votemtrVO에있거나			resultVO에 있거나
		String empId = voteMtrVO.getEmpId() != null ? voteMtrVO.getEmpId() : resultVO.getEmpId();
		if (empId != null) { //empId가있으면 ID에 해당하는 NM넣기
		    resultVO.setNm(voteManageTrgterService.findEmpNm(empId));
		}
		
		/* kbh 2025-11-17 empId기준으로 nm찾아오기 끝 */
		Integer voteIemNo = voteManageTrgterService.getMyVoteIemNo(mberId, voteMtrVO.getVoteMtrSn());		
		resultVO.setMyVoteIemNo(voteIemNo);
		
	    log.info("goVote -> resultVO후 : {}", resultVO);
	    Map<String, Object> result = new HashMap<>();
	    result.put("voteMtrVO", resultVO);
	    result.put("mberId", mberId);
		return result;
	}
	
	//투표 하기
	@PreAuthorize("hasRole('ROLE_MBER')")
	@PostMapping("/haveAVote")
	public String haveAVote(VoteManageTrgterVO voteManageTrgterVO, Principal principal) {
		//로그인한아이디 호출
		voteManageTrgterVO.setMberId(principal.getName());
		log.info("haveAVote -> principal : {} ", principal); // mberId담고 체킁
		log.info("haveAVote -> voteManageTrgterVO : {} ", voteManageTrgterVO); // mberId담고 체킁
		//투표하기 메서드 호출( impl에서 업데이트와 인서트로 진행됨 )
		int result = this.voteManageTrgterService.haveAVote(voteManageTrgterVO);
		log.info("haveAVote -> voteManageTrgterVO : {} ", voteManageTrgterVO); // mberId담고 체킁

		return "redirect:/vote/memVoteList";
	}
	//문자로 보내줄 투표 링크! => 혜선씨 이거 쓰세요 , 투표하기 버튼은 haveAVote를 공유합니다
	@GetMapping("/goVote")
	public String voteMtrList(VoteMtrVO voteMtrVO, Model model) {
		log.info("goVote -> voteMtrVO : {}  ", voteMtrVO);
		VoteMtrVO resultVO = this.voteManageTrgterService.voteMtrList(voteMtrVO);
		log.info("goVote-> resultVO : {}", resultVO);
		model.addAttribute("voteMtrVO", resultVO);
		
		return "vote/goVote";
	}
}
