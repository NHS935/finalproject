package kr.or.ddit.vo;

import java.util.Date;

import lombok.Data;

@Data
public class FileDetailVO {
	
	private long fileGroupSn; // 파일 그룹 일련번호 FK, PK
	private int fileNo; // 파일 번호 PK
	private String fileOrginlNm; // 원본 파일명
	private String fileStreNm; // 저장명
	private String fileStrelc; // 저장 주소
	 private String filePath; // 
	private long fileMg; // 파일 크기
	private String fileExtsn; // 확장자
	private String fileMime; // MIME
	private String fileFancysize; 
	private Date fileSaveDate; // 저장 일시
	private int fileDowncount;
	
	//다운로드시 필요한 저장 절대경로
	private String fileAbsltStrelc;
}
