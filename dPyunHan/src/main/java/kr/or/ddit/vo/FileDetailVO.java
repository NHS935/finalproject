package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class FileDetailVO {
//	private int fileSn;			// PK
//	private long fileGroupNo;	// PK, FK
//	private String fileOriginalName;
//	private String fileSaveName;
//	private String fileSaveLocate;
//	private long fileSize;
//	private String fileExt;
//	private String fileMime;
//	private String fileFancysize;
//	private Date fileSaveDate;
//	private int fileDowncount;
	
	private long fileGroupSn;
	private int fileNo;
	private String fileOrginlNm;
	private String fileStreNm;
	private String fileStrelc;
	private long fileMg;
	private String fileExtsn;
	private String fileMime;
	private String fileFancysize;
	private Date fileSaveDate;
	private int fileDowncount;
	
	//다운로드시 필요한 저장 절대경로
	private String fileAbsltStrelc;
}
