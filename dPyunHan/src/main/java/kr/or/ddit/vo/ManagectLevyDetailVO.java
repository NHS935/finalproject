package kr.or.ddit.vo;

import lombok.Data;

@Data
public class ManagectLevyDetailVO {
	
	// 청구상세
    private long managectLevyDetailSn;    // 관리비부과상세일련번호
    private String iemNm;                 // 항목명
    private int rqestAmount;              // 청구금액
    private String rqestStdr;             // 청구기준
    private String rqestUntpc;   		  // 관리비청구단가
    private String rqestSn;               // 청구일련번호
}
