package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class PayVO {

    private String paySn;        // 납부 ID
    private int rqestSn;       // 청구 ID (FK)
    private long payAmount;    // 납부 금액
    private Date payDt;       // 납부 일시
    private int payMth;       // 납부 방법
	
    
    private String rqestYm;           // 청구 년월 (예: 202510)
    private long chargeAmount;         // 청구 금액

}
