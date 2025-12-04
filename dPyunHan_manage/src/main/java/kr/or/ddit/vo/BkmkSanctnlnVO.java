package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
public class BkmkSanctnlnVO {		
	private int bkmkSanctnlnId;
	private String empId;
	private String bkmkSanctnlnNm;
	
	//즐겨찾기 결재선 상세
	private List<BkmkSanctnlnDetailVO> bkmkSanctnlnDetailVOList;
}
