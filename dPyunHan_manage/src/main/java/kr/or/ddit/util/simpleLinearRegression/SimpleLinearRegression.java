package kr.or.ddit.util.simpleLinearRegression;

import java.util.List;

import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class SimpleLinearRegression {

	private double m;
	private double b;

	public void train(List<RegressionDataPoint> dataPoints) {
		if (dataPoints == null || dataPoints.size() < 2) {
			throw new IllegalArgumentException("훈련 데이터 포인트는 최소 2개 이상이어야 합니다.");
		}

		int n = dataPoints.size();
		double sumX = 0;
		double sumY = 0;
		double sumXY = 0;
		double sumX2 = 0;

		for (RegressionDataPoint dp : dataPoints) {
			sumX += dp.getX();
			sumY += dp.getY();
			sumXY += dp.getX() * dp.getY();
			sumX2 += dp.getX() * dp.getX();
		}

		double numeratorM = (double) n * sumXY - sumX * sumY;
		double denominatorM = (double) n * sumX2 - sumX * sumX;

		if (denominatorM == 0) {
			throw new IllegalArgumentException("모든 X 값이 동일하여 선형 회귀 모델을 생성할 수 없습니다. Y 값을 예측하려면 다른 방법을 사용해야 합니다.");
		}
		m = numeratorM / denominatorM;
		b = (sumY - m * sumX) / n;
	}

	public double predict(double x) {
		if (Double.isNaN(m) || Double.isNaN(b)) {
			throw new IllegalStateException("모델이 아직 학습되지 않았습니다. train() 메서드를 먼저 호출하세요.");
		}
		return m * x + b;
	}
}