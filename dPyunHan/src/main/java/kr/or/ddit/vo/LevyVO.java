package kr.or.ddit.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class LevyVO {

    private String rqestSn;         // 청구 일련번호
    private Date payTmlmt;       	// 청구 기한
    private String rqestYm;        	// 청구 연월
    private Date rqestDt;          	// 청구 일시
    private int managectTotAmount;	// 관리비 총 금액
    private int paySttus;     		// 납부 상태  0 = 미납, 1 = 납부완료
    private String hshldId;         // 세대번호
    private String paySn;           // 납부 ID 
    
    //  청구 상세 항목 리스트
    private List<ManagectLevyDetailVO> detailList;
}
