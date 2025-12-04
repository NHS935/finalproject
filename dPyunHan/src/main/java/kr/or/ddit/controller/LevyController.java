package kr.or.ddit.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.service.LevyService;
import kr.or.ddit.vo.PayVO;
import kr.or.ddit.vo.LevyVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class LevyController {

   @Autowired
   LevyService levyService;
   
   
   //  월별 관리비 청구내역 조회
   @GetMapping("/rqest/rqest")
   public String manageFeeView(
           @RequestParam(name = "ym", required = false) String yearMonth,
           HttpSession session,  // 로그인 정보 접근용
           Model model) {

      
         // 로그인 확인
       String mberId = (String) session.getAttribute("mberId");
       if (mberId == null) {
           return "redirect:/login";
       }
      
       // 회원 ID로 세대 ID 조회
       String hshldId = levyService.selectHouseholdIdByMember(mberId);
       
      
//        페이지 첫 진입: yearMonth 없으면 현재 년월 사용
       if (yearMonth == null || yearMonth.isEmpty()) {
           java.time.LocalDate now = java.time.LocalDate.now();
           yearMonth = String.format("%04d-%02d", now.getYear(), now.getMonthValue());
       }
       log.info("yearMonth : {}", yearMonth);

      
       List<LevyVO> rqestList = levyService.selectMonthlyRqestByHouse(hshldId, yearMonth);

       model.addAttribute("rqestList", rqestList);
       model.addAttribute("yearMonth", yearMonth);

       log.info("rqestList : {}", rqestList);
       return "rqest/rqest"; // rqest.jsp
   }
    
    // 결제 성공 시 (PortOne → 서버)
    @PostMapping("/rqest/paymentSuccessPortOne")
    public ResponseEntity<String> paymentSuccess(@RequestBody PayVO pay) {
        log.info("PortOne 결제 성공 요청 수신: {}", pay);

        try {
           levyService.processPayment(pay);
            return ResponseEntity.ok("success");
        } catch (Exception e) {
            log.error("결제 처리 중 오류", e);
            return ResponseEntity.internalServerError().body("fail");
        }
    }
    
    
    
    // 
    @ResponseBody
    @GetMapping("/rqest/listAjax")
    public List<LevyVO> getRqestList(
            @RequestParam(name = "ym", required = false) String yearMonth,
            HttpSession session) {

        String mberId = (String) session.getAttribute("mberId");

        String hshldId = levyService.selectHouseholdIdByMember(mberId);

        if (yearMonth == null || yearMonth.isEmpty()) {
           java.time.LocalDate now = java.time.LocalDate.now();
            yearMonth = String.format("%04d-%02d", now.getYear(), now.getMonthValue());
        }
        return levyService.selectMonthlyRqestByHouse(hshldId, yearMonth);
    }
    
    

}
