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
	
	//첨부 프사
	private Long fileGroupSn;
	private String filePath;
	private String fileNm;
	
	//AUTHOR 테이블
	List<AuthorVO> authorVOList;
	
    // 세대 관련 정보
    private String hshldId;
    private String adres;
    private int aptcmpl;
    private int ho;
    private int cmmntyUseAt;
    private int residesttus;
    private String mvnDe;
    private String lvhsDe;
    private int memNum;	//kbh 회원수count
    private String prvuseAr;	//평수
    private String suplyAr;	//평수
    private String carNo;	
    private String carRegDate;	
    
}
