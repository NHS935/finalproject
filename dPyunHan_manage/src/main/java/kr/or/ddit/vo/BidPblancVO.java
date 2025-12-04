package kr.or.ddit.vo;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class BidPblancVO {
	
	private int rnum;
	
	private int bidPblancSn;


    //상세보기용 입찰번호
		public String getBidPblancSnAsStr() {
			java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
			String pblancDtStr = sdf.format(pblancDt);
			long diffMillis = bidClosDt.atZone(ZoneId.systemDefault()).toInstant().toEpochMilli() - pblancDt.getTime();
			long diffDays = diffMillis / (1000 * 60 * 60 * 24);
			String diffDaysStr = String.format("%02d", diffDays);
			
			
			return pblancDtStr + diffDaysStr + bidPblancSn;
		}
	
	private String bidSj;
	
	// 낙찰 방법
	private int scsbMth;
		public String getScsbMthAsStr() { 
			/*
			 * 	<option value="0">적격 심사</option>
				<option value="1">최저 낙찰</option>
				<option value="2">최고 낙찰</option>
			 */
			switch (scsbMth) {
			case 2:
				return "최고낙찰";
			case 1:
				return "최저낙찰";
			default:
				return "적격심사";
			}
		}
	
	private String bidCn;
	
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date pblancDt;
	
	// 입찰 마감일
	@DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
	private LocalDateTime bidClosDt; 
		public Date getBidClosDtAsDate() { 
	        if (bidClosDt == null) return null;
	        return Date.from(bidClosDt.atZone(ZoneId.systemDefault()).toInstant());
	    }
	
	// 입찰 상태
	private int bidSttus;
		public String getBidSttusAsStr() { 
			switch (bidSttus) {
			case 2: {				
				return "선정 완료";
			}
			case 1: {
				return "재공고";
			}
			default:
				return "신규공고";
			}
			
		}
	
	private int elctrnsanctnSn;
	
	// 신용평가 제출 여부
	private int cdltPresentnAt;
		public String getCdltPresentnAtAsStr() {
			switch (cdltPresentnAt) {
			case 1:
				return "제출";
			default:
				return "해당없음";
			}
		}
	
	// 실적증명 제출 여부
	private int acmsltproofPresentnAt;
		public String getAcmsltproofPresentnAtAsStr() {
			switch (acmsltproofPresentnAt) {
			case 1:
				return "제출";
			default:
				return "해당없음";
			}
		}
		
		//리스트에 필수 제출 서류 보이게하기
		public String getAllRequirementsAsStr() {
			List<String> requirements = new ArrayList<>();
		    
		    if (cdltPresentnAt == 1) {
		        requirements.add("신용평가등급확인서");
		    }
		    if (acmsltproofPresentnAt == 1) {
		        requirements.add("관리실적증명서");
		    }		    
		    return requirements.isEmpty() ? "해당 없음" : String.join(", ", requirements);		
		}
		//제출서류 관리 테이블 필요
	private long fileGroupSn;
	
	// 현장 설명 여부
	private int sptdcAt;
		public String getSptdcAtAsStr() {
			switch (sptdcAt) {
			case 1:
				return "필수";
			default:
				return "없음";
			}
		}
	
	@DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
	private LocalDateTime  sptdcDt; // 현장설명_일시
		public Date getSptdcDtAsDate() { 
	        if (sptdcDt == null) return null;
	        return Date.from(sptdcDt.atZone(ZoneId.systemDefault()).toInstant());
	    }
		
	private String sptdcPlace;
	
	// 입찰 보증금 율
	private int bidGtnRt;
	
	private boolean hasAlreadyBid;
	
	//1:N bdder
	private List<BdderVO> bdderVOList;
	
	public int getCntBdderVO() {
		int cnt=0;
		for(BdderVO bdderVO: bdderVOList) {
			if(bdderVO.getCcpyManageId()!=0) {
				cnt++;
			}
		}
		return cnt;
	}
	
}
