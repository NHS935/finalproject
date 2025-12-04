package kr.or.ddit.vo;

import lombok.Data;

@Data
public class CvplManageVO {
	
	private int cvplRceptId;
	private int cvplSn;
	
	
	//민원접수 상태값, 내용 가져오기
    private CvplRceptVO cvplRceptVO;
    
}
