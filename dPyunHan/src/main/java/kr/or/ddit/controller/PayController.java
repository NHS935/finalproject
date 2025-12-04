package kr.or.ddit.controller;

import java.net.http.HttpClient;
import java.security.Principal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import kr.or.ddit.service.PayService;
import kr.or.ddit.vo.LevyVO;
import kr.or.ddit.vo.PayVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class PayController {
    
	@Autowired	//관리비
	LevyService levyService;
	
    @Autowired
    private PayService payService;
    
    
    
    @GetMapping("/rqest/list")
    public String list(Model model, HttpSession httpSession,
            @RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage,
            @RequestParam(value="keyword", required=false, defaultValue="") String keyword) {
        
        
        String memId=(String)httpSession.getAttribute("mberId");
        // 회원 ID로 세대 ID 조회
        String hshldId = levyService.selectHouseholdIdByMember(memId);	

        log.info("ffffff : {}",hshldId);
        
        Map<String,Object> map = new HashMap<>();
        map.put("currentPage", currentPage);
        map.put("keyword", keyword); // 검색어가 Map에 담겨 있지만, 아래 서비스 메서드에는 전달되지 않음

        List<LevyVO> total = this.payService.getTotal(hshldId);
        
        // 💡 수정 필요 지점: PayService의 list 메서드에 keyword를 추가하여 호출
        List<PayVO> payList = this.payService.list(hshldId, keyword); 
        
        log.info("list -> total : {}", total);
        log.info("list -> payList.size() : {}", payList.size());
        
        model.addAttribute("payList", payList);
        model.addAttribute("total", total);
        model.addAttribute("hshldId", hshldId);
        
        log.info("model -> {} ", model);
        return "rqest/list";
    }
    
    // PortOne 결제 완료 후 서버 처리
    @PostMapping("/paymentSuccessPortOne")
    @ResponseBody
    public ResponseEntity<?> paymentSuccessPortOne(@RequestBody PayVO payVO) {
        try {
            log.info("결제 완료 데이터: {}", payVO);

            // 결제 완료 시간 기록
            payVO.setPayDt(new Date());
            payVO.setPayMth(1);       // 1: 카드 결제 예시
            payVO.setPayAmount(payVO.getPayAmount());  // 결제 금액
            payVO.setPaySn(payVO.getPaySn());          // 결제 고유 ID
            payVO.setRqestSn(payVO.getRqestSn());      // 청구번호 ???

            // PAY 테이블 insert + RQEST 상태 update (트랜잭션 처리)
            payService.completePayment(payVO);

            return ResponseEntity.ok().body("결제 완료 및 DB 저장 성공");
        } catch(Exception e) {
            log.error("결제 후 DB 처리 실패", e);
            return ResponseEntity.status(500).body("서버 오류: 결제 저장 실패");
        }
    }
}
