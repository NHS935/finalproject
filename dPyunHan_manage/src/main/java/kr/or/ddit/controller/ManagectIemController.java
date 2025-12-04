package kr.or.ddit.controller;

import kr.or.ddit.service.ManagectIemService;
import kr.or.ddit.vo.ManagectIemVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/managect")
public class ManagectIemController {

    private final ManagectIemService managectIemService;

    @GetMapping("/upload")
    public  String upload(){
        return "managect/upload";
    }

    @PostMapping("/upload")
    public String uploadExcel(@RequestParam("file") MultipartFile file, Model model) {
        try {

            int count = managectIemService.upload(file);
            model.addAttribute("message", count+"건이 등록되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("message", "업로드 실패: " + e.getMessage());
        }
        return "managect/upload";
    }
//    @GetMapping("/managectView")
//    public String managectViewPage(Model model) {
//        // 1. "이번 달" 날짜 계산
//        LocalDate now = LocalDate.now(); // 예: 2025-11-04
//
//        // 2. DB 쿼리용 "yyyyMM" 형식 (예: "202511")
//        String managectUseDe = now.format(DateTimeFormatter.ofPattern("yyyyMM"));
//
//        // 3. <input type="month">에 표시할 "yyyy-MM" 형식 (예: "2025-11")
//        String searchMonth = now.format(DateTimeFormatter.ofPattern("yyyy-MM"));
//
//        // 4. 서비스 호출 (DB에서 '이번 달' 데이터 조회)
//        List<ManagectIemVO> feeList = managectIemService.findFeesByMonth(managectUseDe);
//
//        // 5. Model에 '이번 달' 데이터와 날짜를 미리 담아서...
//        model.addAttribute("searchMonth", searchMonth); // 뷰의 <input>에 '2025-11' 표시
//        model.addAttribute("feeList", feeList);       // 뷰의 <table>에 '이번 달' 내역 표시
//
//        // 6. ...뷰로 보낸다.
//        return "managect/managectView";
//    }

    /**
     * 특정 월의 관리비 내역을 조회
     */
    @GetMapping("/managectView")
    public String searchByMonth(@RequestParam(value="searchMonth", required = false) String month, Model model) {
        String managectUseDe; // 1. DB 조회용 (YYYYMM)
        String displayMonth;  // 2. View 표시용 (YYYY-MM)

        if(month == null || month.equals("")){
            // 파라미터가 없는 경우 (최초 로드)
            LocalDate now = LocalDate.now();
            managectUseDe = now.format(DateTimeFormatter.ofPattern("yyyyMM"));
            displayMonth = now.format(DateTimeFormatter.ofPattern("yyyy-MM")); // "YYYY-MM" 형식 생성
        } else {
            // 파라미터가 있는 경우 (날짜 선택 조회)
            managectUseDe = month.replace("-", ""); // DB 조회용
            displayMonth = month;                   // View 표시용 (원본 "YYYY-MM" 값)
        }

        List<ManagectIemVO> feeList = managectIemService.findFeesByMonth(managectUseDe);

        // "searchMonth"에는 반드시 "YYYY-MM" 형식인 displayMonth를 넘겨줍니다.
        model.addAttribute("searchMonth", displayMonth);
        model.addAttribute("feeList", feeList);

        return "managect/managectView";
    }
}
