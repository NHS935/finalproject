package kr.or.ddit.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import kr.or.ddit.service.MberService;
import kr.or.ddit.service.impl.CustomUser;
import kr.or.ddit.vo.MberVO;

@Controller
public class MypageController {

    @Autowired
    private MberService mberService;

    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    // 마이페이지 조회
    @GetMapping("/mypage")
    public String mypage(@AuthenticationPrincipal CustomUser customUser, Model model) {
        MberVO mberVO = customUser.getMberVO();
        model.addAttribute("mberVO", mberVO);
        return "mypage"; // JSP 이름
    }

    // 마이페이지 정보 수정 처리
    @PostMapping("/mypage/update")
    public String updateMypage(@AuthenticationPrincipal CustomUser customUser, MberVO formVO) {
        // DB에서 회원 정보 가져오기
        MberVO target = mberService.findByMberId(customUser.getMberVO().getMberId());

        // 기본 정보 수정
        target.setMberNm(formVO.getMberNm());
        target.setTelno(formVO.getTelno());
        target.setEmail(formVO.getEmail()); // 이메일도 수정 가능

        // 비밀번호 변경 시 처리
        if (formVO.getPassword() != null && !formVO.getPassword().isEmpty()) {
            target.setPassword(bCryptPasswordEncoder.encode(formVO.getPassword()));
        }

        // DB에 반영
        mberService.updateMember(target);

        // 🔹 세션 CustomUser 객체 갱신
        customUser.setMberVO(target);

        // 수정 성공 표시를 위해 쿼리 파라미터 전달
        return "redirect:/mypage?updateSuccess=true";
    }
}
