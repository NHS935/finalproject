package kr.or.ddit.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.or.ddit.mapper.MberMapper;
import kr.or.ddit.service.KakaoService;
import kr.or.ddit.service.MberService;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MberVO;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/mber")
@Slf4j
public class ApproveMemberController {

    @Autowired
    private MberMapper mberMapper;
    
    @Autowired
	MberService mberService;
    
    @Autowired
    KakaoService kakaoService;

    // 승인 대기 리스트 표시 (GET)
    @GetMapping("/list")
    public String pendingList(Model model) {
        List<MberVO> pendingList = mberMapper.selectPendingMembers();
        model.addAttribute("pendingList", pendingList);
        return "mber/list"; // JSP 경로
    }

    // 회원 승인 처리 (POST)
    @PostMapping("/approve")
    public String approveMember(@RequestParam("mberId") String mberId) {
        log.info("회원 승인 요청: {}", mberId);

        mberMapper.approveMember(mberId);	 // ENABLED = '1'
        mberMapper.deleteGuestRole(mberId);	 // 기존 ROLE_GUEST 삭제
        mberMapper.insertMberRole(mberId); 	 // ROLE_MBER 추가

        log.info("회원 승인 완료: {} → ROLE_MBER", mberId);
        
        
        //나혜선 추가 시작
        //승인된 회원에게 승인알림 카카오 발송
        
        try {
          kakaoService.sendmberapprove(mberId,"login");
          log.info("카카오톡 회원가입 승인 알림 : {} ",mberId);
        }catch(Exception e){
        	log.error("카카오톡 승인 알림 실패",e);
        }
        //나혜선 추가 끝
        
        
        // 승인 후 상세페이지로 이동
        return "redirect:/mber/detail?mberId=" + mberId;
    }
    
 // 회원 상세보기 (GET)
    @GetMapping("/detail")
    public String memberDetail(@RequestParam("mberId") String mberId, Model model) {
        log.info("회원 상세보기 요청: {}", mberId);

        MberVO member = mberMapper.selectMemberDetail(mberId);  // 상세 조회 쿼리 추가 필요
	    
	    model.addAttribute("member", member);

        return "mber/detail"; // JSP 파일명
    }
}

