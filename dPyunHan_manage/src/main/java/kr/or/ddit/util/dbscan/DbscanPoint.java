package kr.or.ddit.util.dbscan;

// 1. 데이터 포인트를 나타내는 자바빈클래스 (2차원)
public class DbscanPoint {
	private int id;
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}


	private double x;
	private double y;
	private int clusterId;
	private PointState state; // 포인트 상태(unclassified, core, border, noise)
	
	// 상수 정의
	public static final int UNCLASSIFIED = 0;
	public static final int NOISE = -1;
	
	//포인트 상태를 나타내는 Enum
	public enum PointState{ //Enum 쓰는 방법 기억하기 좋으다 // 중첩 클래스는 아닌데 ENUM 이거 개념이 뭐야? 
		//Enum(열거형)**은 상수의 집합을 하나의 새 데이터타입(클래스처럼)으로 정의
		UNCLASSIFIED, CORE, BORDER, NOISE
	}
	
	//생성자
	public DbscanPoint(int id, double x, double y) {
		this.id=id;
		this.x=x;
		this.y=y;
		this.clusterId=UNCLASSIFIED; //0
		this.state = PointState.UNCLASSIFIED;
	}

	public double getX() {
		return x;
	}

	public void setX(double x) {
		this.x = x;
	}

	public double getY() {
		return y;
	}

	public void setY(double y) {
		this.y = y;
	}

	public int getClusterId() {
		return clusterId;
	}

	public void setClusterId(int clusterId) {
		this.clusterId = clusterId;
	}

	public PointState getState() {
		return state;
	}

	public void setState(PointState state) {
		this.state = state;
	}

	/*
	 * KNN, K-means 
	 * 다른 DbscanPoint 객체와의 유클리드 거리를 계산합니다.
	 */
	public double distanceTo(DbscanPoint other) {
		return Math.sqrt(Math.pow(this.x-other.x,  2)+Math.pow(this.y-other.y, 2));
	}
	
	
	@Override
	public String toString() {
		return "DbscanPoint [x=" + x + ", y=" + y + ", clusterId=" + clusterId + ", state=" + state + "]";
	}
	
	
}
