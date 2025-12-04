package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class BdderVO {
	
	private int rnum;	
	
	private int bidGtn; //보증금
	private int bidAmount; //입찰액
	private int bdderSn; //입찰일련번호
	private Date bidSportDt; //입찰 일시
	
	private int bidAt; //입찰 여부
		public String getBidAtAsStr() {
			switch (bidAt) {
			case 2:
				return "미선정";
			case 1:
				return "선정";
			default:
				return "진행 중";
			}
		}

	//입찰 공고 1:1 
	private int bidPblancSn; //입찰 공고 일련번호
	private BidPblancVO bidPblancVO;
	
	// 협력업체 1:1
	private int ccpyManageId;
	private CcpyManageVO ccpyManageVO;
	
	private long fileGroupSn;
}
