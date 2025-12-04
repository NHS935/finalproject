package kr.or.ddit.controller;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.service.SLRService;
import kr.or.ddit.service.impl.CustomUser;
import kr.or.ddit.util.simpleLinearRegression.RegressionDataPoint;
import kr.or.ddit.util.simpleLinearRegression.SimpleLinearRegression;
import kr.or.ddit.vo.MberVO;
import kr.or.ddit.vo.MtinspVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/levy")
public class SLRController {

    @Autowired
    SLRService simpleLinearRegressionService;

    @GetMapping("/slr")
    public String slr(@AuthenticationPrincipal CustomUser customUser, Model model) {
        // 로그인 사용자
        MberVO mberVO = customUser.getMberVO();

        // 기본 월 (현재 월 or 원하는 월)
        String yearMonth = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMM"));

        // 일별 사용량 + total 리스트
        List<MtinspVO> list = simpleLinearRegressionService.calculateDailyTotals(yearMonth);

        model.addAttribute("dailyList", list);
        model.addAttribute("yearMonth", yearMonth);

        return "levy/slr";
    }

    @ResponseBody
    @PostMapping("/predict")
    public Map<String, Object> predict(@RequestBody Map<String, Object> map, @AuthenticationPrincipal CustomUser customUser) {

        String yearMonth = (String) map.get("yearMonth");

        // 서비스에서 실제값 + 미래 예측값 + monthPredict 모두 계산 완료됨
        List<MtinspVO> list = simpleLinearRegressionService.calculateDailyTotals(yearMonth);

        // 월 예측 총액 = resultList 마지막 요소의 monthPredict
        Double monthPredict = list.get(list.size() - 1).getMonthPredict();

        // 프론트에서 그래프 그릴 데이터 구성
        Map<String, Object> result = new HashMap<>();

        // 한달 총 예상금액
        result.put("amt", monthPredict);
        // 날짜
        result.put("days", list.stream().map(MtinspVO::getDay).toList());
        // 실제값
        result.put("values", list.stream().map(MtinspVO::getTotal).toList());

        // 진짜 예측선 
        result.put("predicted", list.stream()
                .map(MtinspVO::getPredictedTotal)   // <- 이걸 써야 함
                .toList()
        );
        
        Map<Integer, Double> predictMap = new HashMap<>();
        for (MtinspVO mtinspVO : list) {
            predictMap.put(mtinspVO.getDay(), mtinspVO.getPredictedTotal());
        }
        result.put("predictMap", predictMap);

        return result;
    }
}
