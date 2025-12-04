package kr.or.ddit.vo;

import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class CvplVO {

	private int cvplSn;
	private String mberId;
	private String cvplSj;
	private String cvplCn;
	private Date reqstDt;
	private String deptCode;
	
	private String empId;
	private int rceptSttus;
	private int cvplRceptId;
	private String mberNm;
	private Integer remainDays;
	private Date rceptDt;
	
	private long fileGroupSn;
	
	//파일이 업로드되는 윈도 경로
	private MultipartFile[] uploadFiles;
	private int rnum;
	private String pictureUrl;
	
	private FileGroupVO fileGroupVO;
}
