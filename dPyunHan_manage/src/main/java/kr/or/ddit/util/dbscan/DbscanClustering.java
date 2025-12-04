package kr.or.ddit.util.dbscan;

import java.util.ArrayList;
import java.util.List;
import java.util.Stack;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class DbscanClustering {
	
	private double epsilon;// 이웃을 탐색할 반경
	private int minPts; // 군집을 형성하기 위한 최소 포인트 수
	private List<DbscanPoint> dataPoints; // 군집화할 데이터 포인트 리스트
	private int nextClusterId;
	
	/*
	 * Dbscan 알고리즘 인스턴스를 생성합니다.
	 * @param epsilon 이웃을 탐색할 반경
	 * @param minPts 코어 포인트가 되기 위한 최소 이웃 수
	 */
	
	public DbscanClustering(
			 @Value("${DbscanClustering.epsilon}") double epsilon,
			 @Value("${DbscanClustering.minPts}") int minPts
			) {
		if(epsilon <=0) {
			throw new IllegalArgumentException("Epsilon은 양수여야 합니다."); //생성자에 직접 제어구문을 넣어서 활용하는 방법
		}
		if(minPts <=0) {
			throw new IllegalArgumentException("minPts는 양수여야 합니다.");
		}
		this.epsilon = epsilon;
		this.minPts = minPts;
		this.nextClusterId = 1; //군집 ID는 1부터 시작
	}
	
	/*
	 * Dbscan 군집화를 수행합니다.
	 * @param dataPoints 군집화할 데이터 포인트 리스트
	 * @return 군집화된 데이터 포인트 리스트 (clusterId와 state가 할당된 상태)
	 */
	
	public List<DbscanPoint> cluster(List<DbscanPoint> dataPoints){
		if(dataPoints == null || dataPoints.isEmpty()) {
			throw new IllegalArgumentException("데이터 포인트가 비어있습니다.");
		}
		
		this.dataPoints = dataPoints;
		this.nextClusterId=1;
		
		System.out.println("DBSCAN 군집화 시작(Epsilon: "+ epsilon + ", MinPts: " + minPts+ ")...");
		
		//모든 데이터 포인트를 순회하며 군집 탐색
		for(DbscanPoint p : dataPoints) {
			//아직 방문하지 않은 포인트인 경우에만 처리
			if(p.getClusterId() == DbscanPoint.UNCLASSIFIED) {
				//현재 포인트의 이웃들을 찾습니다.
				List<DbscanPoint> neighbors = getNeighbors(p); // <-- getNeighbors() 함수 호출
				
				// 이웃 수가 minPts보다 적으면 노이즈로 잠정 분류합니다.
				if(neighbors.size() <minPts) {
					p.setClusterId(DbscanPoint.NOISE);
					p.setState(DbscanPoint.PointState.NOISE); // 클래스의 PointState라는 중첩클래스? 아닌데 
					//Enum(열거형)**은 상수의 집합을 하나의 새 데이터타입(클래스처럼)으로 정의
					//자바에서는 새로운 클래스를 만드는 것과 비슷하게 동작
				} else {
					//이웃 수가 MinPts 이상이면 새로운 군집을 시작합니다.
					p.setState(DbscanPoint.PointState.CORE); // 현재 포인트는 코어
					
					expandCluster(p, neighbors, nextClusterId); // 군집 확장; <-- expandCluster() 함수 호출
					nextClusterId++; // 다은 군집은 위해 ID 증가
				}
			}
		}
		System.out.println("Dbscan 군집화 완료");
		return this.dataPoints;
	}
	
	/*
	 * 특정 포인트의 epsilon 반경 내에 있는 모든 이웃 포인트를 찾습니다.
	 * @param p 기준 포인트
	 * @return 이웃 포인트 리스트
	 */
	private List<DbscanPoint> getNeighbors(DbscanPoint p){ // private 메소드
		List<DbscanPoint> neighbors = new ArrayList<>();
		
		for(DbscanPoint other : dataPoints) {
			if(p!=other && p.distanceTo(other) <=epsilon) {//자기 자신 제외, epsilon 이내
				neighbors.add(other);
			}
		}
		return neighbors;
	}
	
	/*
	 * 코어 포인트로부터 군집을 확장한다
	 * @param corePoint 현재 코어 포인트
	 * @param neighbors 코어 포인트의 이웃 리스트
	 * @param clusterId 현재 군집 ID
	 */
	
								//             p                       p의 neighbor         1
	private void expandCluster(DbscanPoint corePoint, List<DbscanPoint> neighbors, int clusterId){// private 메소드
		corePoint.setClusterId(clusterId); //코어 포인트를 현재 군집에 할당
		
		// 스택을 사용하여 재귀대신 반복문으로 군집확장
		// 재귀 호출이 깊어질 경우 StackOverflowError 방지
		Stack<DbscanPoint> stack = new Stack<>();
		stack.addAll(neighbors); // 코어포인트의 모든 이웃을 스택에 추가ㅓ
		
		// p의 neighbor를 담은 stack이 빌때까지
		while(!stack.isEmpty()) {
			// p의 neighbor의 DbscanPoint        
			DbscanPoint current = stack.pop();
			
			// 만약 현재 포인트가 노이즈로 분류 되어있었다면 (나중에 코어 포인트에 의해 연결된 경우),
			// 이제는 이 군집의 경계 포인트가 됩니다.
			if(current.getClusterId()==DbscanPoint.NOISE) {
				current.setClusterId(clusterId);
				current.setState(DbscanPoint.PointState.BORDER); //노이즈에서 경계로 변경
			}
			
			
			// 아직 분류되지 않은 포인트인 경우에만 처리
            if (current.getClusterId() == DbscanPoint.UNCLASSIFIED) {
                current.setClusterId(clusterId); // 현재 포인트를 군집에 할당
                List<DbscanPoint> currentNeighbors = getNeighbors(current);
							
				// 현재 포인트가 코어 포인트라면, 그 이웃들도 군집에 추가
				if(currentNeighbors.size() >=minPts) {
					current.setState(DbscanPoint.PointState.CORE); // 이 포인트도 코어 포인트? <-- 왜 코어 포인트가 되지?
					
					for(DbscanPoint neighbor : currentNeighbors) {
						// 아직 방문하지 않았거나 노이즈로 분류된 이웃만 스택에 추가
						if(neighbor.getClusterId()==DbscanPoint.UNCLASSIFIED || 
								neighbor.getClusterId()==DbscanPoint.NOISE) {
							stack.push(neighbor);
						}
					}
				}else {
					current.setState(DbscanPoint.PointState.BORDER); //이 포인트는 경계 포인트
				}
			}
		}
	}
	
}
