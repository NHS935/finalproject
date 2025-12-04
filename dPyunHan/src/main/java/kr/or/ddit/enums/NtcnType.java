package kr.or.ddit.enums;

public enum NtcnType {

	CVPL("민원"),
	RESVE("예약"),
	ELCTRNSANCTN("결재"),
	NOTICE("공지"),
	FCLTY("시설"),
	BBS("게시판"),
	VOTE("투표"),
	MANAGECT("관리비"),
	SIGN("회원가입"),
	ANOMALY("검침 이상치");
	
	//Mtinsp("검침");
	
	// 필드 (Enum 상수에 딸려있는 추가 정보)
	private final String description;

	// 생성자 (각 상수 정의할 때 전달받은 값을 이 필드에 저장)
	NtcnType(String description) {
		this.description = description;
	}

	// Getter (필드값을 외부에서 읽을 수 있게)
	public String getDescription() {
		return description;
	}
}
