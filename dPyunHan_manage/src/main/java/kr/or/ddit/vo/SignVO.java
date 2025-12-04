package kr.or.ddit.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class SignVO {
	private int signId;
	private String empId;
	private long fileGroupSn;
	
	//kbh
	private FileGroupVO fileGroupVO;
	private FileDetailVO fileDetailVO;
	private MultipartFile[] uploadFiles;
	//kbh
}
