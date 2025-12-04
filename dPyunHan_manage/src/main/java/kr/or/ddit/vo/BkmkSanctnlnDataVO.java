package kr.or.ddit.vo;

import java.util.List;

import lombok.Data;

@Data
//즐겨찾기 결재선 입력용 VO
public class BkmkSanctnlnDataVO {
	
	private String bkmkSanctnlnNm;
	private List<BkmkSanctnlnDetailVO> sanctnlnList;
	private List<BkmkSanctnlnDetailVO> drftRefrnList;
}
