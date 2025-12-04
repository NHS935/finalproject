package kr.or.ddit.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.service.VoteMtrService;
import kr.or.ddit.vo.VoteIemVO;
import kr.or.ddit.vo.VoteMtrVO;
import lombok.extern.slf4j.Slf4j;
@Slf4j
@Controller
@RequestMapping("/vote")

public class VoteMtrController {
	
	@Autowired
	VoteMtrService voteMtrService;
	
	@GetMapping("/voteMtr")
	public String voteList(Model model, VoteMtrVO voteMtrVO) {
		log.info("VoteMtrController -> voteMtrVO : {}" , model);
		
		List<VoteMtrVO> voteMtrVOList = this.voteMtrService.voteList(voteMtrVO);
		model.addAttribute("voteMtrVOList",voteMtrVOList);
		
		log.info("VoteMtrController -> voteMtrVOList : {}" , voteMtrVOList);
		
		return "vote/voteMtr";
	}
	
	
	@GetMapping("/voteDetail")
	public String voteDetail(VoteMtrVO voteMtrVO, Model model) {
		
		VoteMtrVO resultVO = this.voteMtrService.voteMtrList(voteMtrVO);

        model.addAttribute("voteMtrVO", resultVO);

	    log.info("voteMtrList-> voteMtrVO :" , voteMtrVO);
		return "vote/voteDetail";
	}
	
	
	
	@PreAuthorize("hasRole('ROLE_EMP')")
	@GetMapping("/addVotePage")
	public String addVotePage( ) {
		
		return "vote/addVotePage";
	}
	
	
	@PreAuthorize("hasRole('ROLE_EMP')")
	@PostMapping("/addVote")
	public String addVoteWithIems(@ModelAttribute VoteMtrVO voteMtrVO ,Principal principal)  {
		
		voteMtrVO.setEmpId(principal.getName());//empId불러오기
		log.info("addVote-> principal : {} ", principal);
		List<VoteIemVO> voteIemVOList = voteMtrVO.getVoteIemVOList();
		
		int result = this.voteMtrService.addVoteWithIems(voteMtrVO, voteMtrVO.getVoteIemVOList());
		
		log.info("addVote -> voteMtrVO : {} ", voteMtrVO);
		log.info("addVote -> voteIemVOList : {} ", voteIemVOList);
		log.info("addVote -> result : {} ", result);
		
		return "redirect:/vote/voteMtr";
	}
}