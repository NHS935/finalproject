package kr.or.ddit.controller;

import com.google.gson.Gson;
import kr.or.ddit.service.MtinspService;
import kr.or.ddit.vo.PivotedMtinspVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/mtinsp")
@RequiredArgsConstructor
public class MtinspController {
    private final MtinspService mtinspService;

    @GetMapping("/mtinspView")
    public String mtinspview(@RequestParam(value="hshldId", required=false) String hshldId,
                             @RequestParam(value="searchMonth", required=false) String searchMonth,
                             Model model) {

        // 2. 검색용 Map 준비
        Map<String, Object> searchParams = new HashMap<>();

        String yyyymm = "";

        // 2. 파라미터가 비어있는지(최초 접속) 확인
        if (searchMonth == null || searchMonth.isEmpty()) {
            // 3. (최초 접속) "이번 달" 날짜로 기본 세팅
            LocalDate now = LocalDate.now();
            yyyymm = now.format(DateTimeFormatter.ofPattern("yyyyMM"));      // 쿼리용 (예: "202511")
            searchMonth = now.format(DateTimeFormatter.ofPattern("yyyy-MM")); // 뷰 <input>용 (예: "2025-11")
        } else {
            // 4. (검색 시) 넘어온 "yyyy-MM" 값을 "yyyyMM"으로 변환
            yyyymm = searchMonth.replace("-", "");
        }

        // 4. Model에 검색 조건 자체를 통째로 넘김 (JSP 폼 채우기 용도)
        searchParams.put("yyyymm", yyyymm); // 퀴리용
        searchParams.put("hshldId", hshldId);             // 뷰 <input>용 (예: "101-101")

        // 5. '이번 달'이든 '검색한 달'이든, 해당 yyyymm으로 서비스 호출
        // (서비스는 매퍼의 findDataByMonth를 호출)
        List<PivotedMtinspVO> dataList = mtinspService.getUsageHistory(searchParams);
        System.out.println("dataList : "+dataList);

        // 2. 그래프용 데이터로 가공 (X축, Y축)
        List<Date> labels = dataList.stream().map(PivotedMtinspVO::getMtinspDt).collect(Collectors.toList());
        List<Double> electricData = dataList.stream().map(PivotedMtinspVO::getElectricUsage).collect(Collectors.toList());
        // 4. (Y축 2 - 추가) 수도 데이터
        List<Double> waterData = dataList.stream()
                .map(PivotedMtinspVO::getWaterUsage)
                .collect(Collectors.toList());

// 5. (Y축 3 - 추가) 가스 데이터
        List<Double> gasData = dataList.stream()
                .map(PivotedMtinspVO::getGasUsage)
                .collect(Collectors.toList());

        // 3. 💥 List를 JSON 문자열로 변환 (Gson 라이브러리 예시)
        Gson gson = new Gson();
        String jsonLabels = gson.toJson(labels);
        String jsonElectric = gson.toJson(electricData);
        String jsonWater = gson.toJson(waterData);
        String jsonGas = gson.toJson(gasData);

        // 6. Model에 '검색한 날짜'와 '결과 리스트'를 담기
        model.addAttribute("searchMonth", searchMonth);
        model.addAttribute("dataList", dataList);
        model.addAttribute("chartLabels", jsonLabels);
        model.addAttribute("chartElectric", jsonElectric);
        model.addAttribute("chartWater", jsonWater);
        model.addAttribute("chartGas", jsonGas);
        model.addAttribute("hshldId", hshldId);

        return "mtinsp/mtinspView"; // JSP 페이지로 이동
    }


}
