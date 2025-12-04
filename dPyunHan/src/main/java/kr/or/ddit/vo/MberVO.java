package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class MberVO {
	private String mberId;
	private String password;
	private String mberNm;
	private String telno;
	private String email;
	private int mberTy;
	private String brthdy;
	private String enabled;
	
	private long fileGroupSn;
	
	//AUTHOR 테이블
	List<AuthorVO> authorVOList;

	// 동호수 확인  
	private int aptcmpl; 	// 동 (APTCMPL)
	private int ho;      	 // 호 (HO)
	private int residesttus; // 거주방식 
	private String hshldId;
	
	private String vhcleNo; // 차량번호 추가
	
	private List<HshldMberManageVO> hshldManageList;

}
