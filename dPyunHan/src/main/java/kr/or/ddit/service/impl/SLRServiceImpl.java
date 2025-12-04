package kr.or.ddit.service.impl;

import java.time.YearMonth;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.SLRMapper;
import kr.or.ddit.service.SLRService;
import kr.or.ddit.util.simpleLinearRegression.RegressionDataPoint;
import kr.or.ddit.util.simpleLinearRegression.SimpleLinearRegression;
import kr.or.ddit.vo.MberVO;
import kr.or.ddit.vo.MtinspVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SLRServiceImpl implements SLRService {

    @Autowired
    SLRMapper simpleLinearRegressionMapper;

    @Autowired
    SimpleLinearRegression regressor;   // 예측용 회귀 모델

    @Override
    public List<MtinspVO> calculateDailyTotals(String yearMonth) {

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUser customUser = (CustomUser) authentication.getPrincipal();
        MberVO mberVO = customUser.getMberVO();
        String hshldId = mberVO.getHshldId();
        
        int year = Integer.parseInt(yearMonth.substring(0, 4));
        int month = Integer.parseInt(yearMonth.substring(4, 6));
        int lastDay = YearMonth.of(year, month).lengthOfMonth();

        // DB pivot 조회
        List<MtinspVO> dailyList = simpleLinearRegressionMapper.selectDailyUsage(yearMonth, hshldId);

        List<MtinspVO> resultList = new ArrayList<>();

        // -------------------------
        // 1. 실제 daily total 계산
        // -------------------------
        for (int day = 1; day <= lastDay; day++) {
            final int currentDay = day;

            MtinspVO found = dailyList.stream()
                    .filter(vo -> extractDay(vo.getMtinspDt()) == currentDay)
                    .findFirst()
                    .orElse(null);

            MtinspVO mtinspVO = new MtinspVO();
            mtinspVO.setDay(day);

            if (found != null) {
                mtinspVO.setGasQty(found.getGasQty());
                mtinspVO.setWaterQty(found.getWaterQty());
                mtinspVO.setElecQty(found.getElecQty());

                double gas = mtinspVO.getGasQty() * 0.05 * 900;
                double water = mtinspVO.getWaterQty() * 0.0045 * 700;
                double elec = mtinspVO.getElecQty() * 0.07 * 150;

                double total = gas + water + elec;

                total = Math.round(total * 100) / 100.0;   // 소수 둘째 자리 반올림

                mtinspVO.setTotal(total);

            } else {
                mtinspVO.setTotal(null);
            }

            resultList.add(mtinspVO);
        }

        // -------------------------
        // 2. 회귀 데이터 생성 & 예측 금액 계산
        // -------------------------
        // 누적값 먼저 계산
        double cumActualForRegression = 0;
        List<RegressionDataPoint> trainingData = new ArrayList<>();

        for (MtinspVO vo : resultList) {

            // total = “일일 금액” (절대 수정 금지)

            if (vo.getTotal() != null && vo.getTotal() > 0) {
                cumActualForRegression += vo.getTotal();   // 일일 → 누적
                trainingData.add(new RegressionDataPoint(vo.getDay(), cumActualForRegression));
            }
        }

        // 누적합 계산용
        double cumActual = 0;
        double cumPredict = 0;

        // 최종 월 누적 예측치
        double monthTotal = 0;

        // -------------------------
        // 3. 회귀 학습 + 미래 예측
        // -------------------------
        if (trainingData.size() >= 2) {

            SimpleLinearRegression freshRegressor = new SimpleLinearRegression();
            freshRegressor.train(trainingData);

            for (MtinspVO vo : resultList) {

                // 1) 누적 예측값 pred
                double pred = freshRegressor.predict(vo.getDay());
                pred = Math.round(pred * 100) / 100.0;
                vo.setPredictedTotal(pred);   // 누적 예측 그대로 사용 (누적하지 않음!)

                // 2) 실제 누적값 (일일 total을 누적)
                if (vo.getTotal() != null) {
                    cumActual += vo.getTotal();     // total = 일일값
                    vo.setTotal(cumActual);         // total을 누적으로 변경
                } else {
                    vo.setTotal(null);
                }

                // 3) 월 누적 예측
                monthTotal = (vo.getTotal() != null ? vo.getTotal() : pred);
            }

        } else {
            // 학습 데이터가 부족한 경우: 단일 total 기반 단순 누적
            for (MtinspVO vo : resultList) {

                if (vo.getTotal() != null) {
                    cumActual += vo.getTotal();
                    vo.setTotal(cumActual);
                } else {
                    vo.setTotal(null);
                }

                vo.setPredictedTotal(cumActual); // 예측치 = 실제 누적값
                monthTotal = cumActual;
            }
        }
            
        // -------------------------
        // 4. 마지막 VO에 monthPredictSum 저장
        // -------------------------
        // 소수점 첫째 자리 반올림 (원 단위)
        if (!resultList.isEmpty()) {
            
            // 마지막 누적 예측값 (가장 정확한 한달 예상 총액)
            double finalPredictedSum = resultList.get(resultList.size() - 1).getPredictedTotal();

            // 원 단위 반올림
            finalPredictedSum = Math.round(finalPredictedSum);

            // 저장
            resultList.get(resultList.size() - 1).setMonthPredict(finalPredictedSum);
        }

        return resultList;
    }

    private int extractDay(String dateStr) {
        if (dateStr == null || dateStr.length() < 10) {
            return -1;
        }
        return Integer.parseInt(dateStr.substring(8, 10));
    }
}
