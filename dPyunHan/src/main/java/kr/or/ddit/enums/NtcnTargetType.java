package kr.or.ddit.enums;

public enum NtcnTargetType {

	USER("사용자 1명(NtcnTypeUser)"),
	USER_ALL("사용자 전체(NtcnTypeUserAll)"),
	DEPT("부서 전체(NtcnTypeDept)"),
	GROUP("특정 그룹(NtcnTypeGroup)");

	// 필드 (Enum 상수에 딸려있는 추가 정보)
	private final String description;

	// 생성자 (각 상수 정의할 때 전달받은 값을 이 필드에 저장)
	NtcnTargetType(String description) {
		this.description = description;
	}

	// Getter (필드값을 외부에서 읽을 수 있게)
	public String getDescription() {
		return description;
	}
	
}
