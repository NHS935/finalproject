package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class VisitVhcleVO {
	private int visitVhcleSn;      // 방문차량일련번호
    private String hshldId;         // 세대번호
    private String vhcleNo;         // 차량번호
    private Date visitReqstDt;      // 방문신청일시
    private Date parkngBeginDt;     // 주차시작일시
    private Date parkngEndDt;       // 주차종료일시
    private int rmndrTime;          // 남은시간
    private int accmltTime;         // 사용한시간
    private Date lastDt;  			// 마지막업데이트시간
}
