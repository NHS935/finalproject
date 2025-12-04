package kr.or.ddit.vo;

import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class CvplRceptVO {

	private int cvplRceptId;
	private String empId;
	private Date rceptDt;
	private String rceptCn;
	private int rceptSttus;
	private long fileGroupSn;
	 
	//파일이 업로드되는 윈도 경로
	private MultipartFile[] uploadFiles;
	private int rnum;
	private String pictureUrl;
	
	private FileGroupVO fileGroupVO;
	
	private int cvplSn;
	private String empNm;
	private String mberId;
	//kbh 추가 
	private int cvplRceptNum;	// 상태가 완료가 아닌 민원의 수
}
