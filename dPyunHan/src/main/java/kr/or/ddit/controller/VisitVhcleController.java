package kr.or.ddit.controller;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.VisitVhicleService;
import kr.or.ddit.vo.VisitVhcleVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/visit")
public class VisitVhcleController {

    @Autowired
    private VisitVhicleService visitVhicleService;

    // 1. 예약 폼 페이지
    @GetMapping("/reserve")
    public String reserveForm(HttpSession session, Model model) {
        String hshldId = getLoginHshldId(session);

        int accmltTime = visitVhicleService.getAccmltTime(hshldId);
        int rmnTime = 120 - accmltTime;
        List<VisitVhcleVO> history = visitVhicleService.getVisitHistory(hshldId);
        
        model.addAttribute("rmnTime", rmnTime);
        model.addAttribute("accmltTime", accmltTime);
        model.addAttribute("history", history);
        
        log.info("reserveForm - 세대ID: {}, 남은시간: {}, 누적시간: {}, history.size: {}",
        		hshldId, rmnTime, accmltTime, history.size());

        return "visit/reserveForm";
    }

 // 2. 예약 처리 (AJAX)
    @PostMapping("/reserve")
    @ResponseBody
    public Map<String, Object> reserveAjax(
            HttpSession session,
            @RequestParam String vhcleNo,
            @RequestParam("VISIT_REQST_DT") String visitReqstDt,    // 날짜 부분 (예: "2025-11-25")
            @RequestParam("PARKNG_BEGIN_DT") String parkngBeginDt,  // 시작 시간 부분 (예: "10:00")
            @RequestParam("PARKNG_END_DT") String parkngEndDt) {   // 종료 시간 부분 (예: "12:00" or "24:00")

        Map<String, Object> result = new HashMap<>();
        try {
            String hshldId = getLoginHshldId(session);

            // 💡 날짜와 시간을 합쳐 LocalDateTime 객체 생성 및 24:00 처리
            java.time.format.DateTimeFormatter yyyyMMddFormatter = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd");
            java.time.format.DateTimeFormatter finalFormatter = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

            // 1. 시작 시간: 날짜 + 시작 시간
            String finalStartDtStr = visitReqstDt + " " + parkngBeginDt;
            LocalDateTime finalStartDt = LocalDateTime.parse(finalStartDtStr, finalFormatter);

            // 2. 종료 시간: 날짜 + 종료 시간 + 24:00 처리
            String finalEndDtStr;
            LocalDateTime finalEndDt;

            if (parkngEndDt.equals("24:00")) {
                 // 24:00 선택 시 다음 날짜의 00:00으로 처리
                 java.time.LocalDate nextDay = java.time.LocalDate.parse(visitReqstDt, yyyyMMddFormatter).plusDays(1);
                 
                 // 다음 날 00:00으로 포맷
                 finalEndDtStr = nextDay.format(yyyyMMddFormatter) + " 00:00"; 
                 finalEndDt = LocalDateTime.parse(finalEndDtStr, finalFormatter);
            } else {
                 // 일반적인 종료 시간 처리
                 finalEndDtStr = visitReqstDt + " " + parkngEndDt;
                 finalEndDt = LocalDateTime.parse(finalEndDtStr, finalFormatter);
            }

            // 3. VO에 데이터 설정 및 Timestamp 변환
            VisitVhcleVO visitVhcleVO = new VisitVhcleVO();
            visitVhcleVO.setHshldId(hshldId);
            visitVhcleVO.setVhcleNo(vhcleNo);
            visitVhcleVO.setParkngBeginDt(java.sql.Timestamp.valueOf(finalStartDt));
            visitVhcleVO.setParkngEndDt(java.sql.Timestamp.valueOf(finalEndDt));

            int insertResult = visitVhicleService.reserveVhicle(visitVhcleVO);

            if (insertResult > 0) {
                result.put("success", true);
                int rmnTime = visitVhicleService.getRemainingTime(hshldId);
                VisitVhcleVO latest = visitVhicleService.getLatestVisit(hshldId);

                result.put("remainingTime", rmnTime);
                result.put("accmltTime", latest != null ? latest.getAccmltTime() : 0);
                result.put("now", LocalDateTime.now().toString());
            } else {
                result.put("success", false);
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "예약 처리 중 오류가 발생했습니다: " + e.getMessage());
        }
        return result;
    }

    // 3. 이용내역 조회
    @GetMapping("/history")  
    public String visitHistory(
            HttpSession session, 
            @RequestParam(value = "month", required = false) String month, 
            Model model) {

        String hshldId = getLoginHshldId(session);

        List<VisitVhcleVO> history;

        if (month != null && !month.isEmpty()) {
            // 월별 예약 내역 조회 (month 형식: "2025-11")
            history = visitVhicleService.getVisitHistoryByMonth(hshldId, month);
        } else {
            // 전체 예약 내역
            history = visitVhicleService.getVisitHistory(hshldId);
        }

        int accmltTime = visitVhicleService.getAccmltTime(hshldId);
        int rmnTime = 120 - accmltTime;

        log.info("예약 내역 조회 - 세대ID : {}, 월 : {}, 내역 개수 : {}", hshldId, month, history.size());

        model.addAttribute("history", history);
        model.addAttribute("rmnTime", rmnTime);
        model.addAttribute("accmltTime", accmltTime);
        model.addAttribute("selectedMonth", month); // JSP에서 선택값 유지용

        return "visit/history";
    }


    // 로그인한 세대번호 가져오기
    private String getLoginHshldId(HttpSession session) {
        String mberId = (String) session.getAttribute("mberId");
        if (mberId == null) {
            throw new RuntimeException("로그인이 필요합니다.");
        }
        return visitVhicleService.getHshldIdByMberId(mberId);
    }
    @GetMapping("/reserveData")
    @ResponseBody
    public Map<String, Object> reserveData(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            String hshldId = getLoginHshldId(session);
            int accmltTime = visitVhicleService.getAccmltTime(hshldId);
            int rmnTime = 120 - accmltTime;

            result.put("accmltTime", accmltTime);
            result.put("remainingTime", rmnTime);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

}
