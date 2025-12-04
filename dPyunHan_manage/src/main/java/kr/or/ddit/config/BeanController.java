package kr.or.ddit.config;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.stereotype.Component;

// 스프링 프레임워크에서 자바빈 객체로 미리 등록해줌
@Component
public class BeanController { // 저장규칙
	//파일이 업로드 되는 윈도우 경로
	private String uploadFolder = "D:\\upload";
	
	//연월일
	private String folder = "";

	// private인 uploadFolder 값을 가져갈수 있는 getter메서드 만들기
	public String getUploadFolder() {
		return uploadFolder;
	}
	
	// 연월일 폴더를 생성해주는 메서드
	public String getFolder() {
		//2025-02-21 형식(format) 지정
		//간단 날짜 형식
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		//날짜 객체 생성(java.util 패키지)
		Date date = new Date();
		String str = sdf.format(date);
		//str : 2025-02-21 -> 2025\\02\\21
//		return str.replace("-", "\\"); // 아래와 같다 File.separator == "\\"
		return str.replace("-", File.separator);
	}
	
}
