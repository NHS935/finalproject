package kr.or.ddit.util.simpleLinearRegression;

//데이터 포인트 클래스 (x, y 값 쌍)
public class RegressionDataPoint {
	private double x;
	private double y;
	
	public RegressionDataPoint(double x, double y) {
	   this.x = x;
	   this.y = y;
	}
	
	public double getX() {
	   return x;
	}
	
	public double getY() {
	   return y;
	}
	
	@Override
	public String toString() {
	   return "(" + x + ", " + y + ")";
	}
}