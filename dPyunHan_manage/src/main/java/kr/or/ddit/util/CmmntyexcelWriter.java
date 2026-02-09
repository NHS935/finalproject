package kr.or.ddit.util;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Component;

import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.vo.CmmntyVO;


@Component
public class CmmntyexcelWriter {

	public void cmmnwriter(List<CmmntyVO> list, HttpServletResponse response) throws Exception{
		
		//엑셀 생성
     	Workbook wb = new XSSFWorkbook();    //workbook: 인터페이스, XSSFWorkbook: .xlsx 파일을 만드는 실제 클래스    	
     	
     	Sheet sheet = wb.createSheet("커뮤니티 목록");  //엑셀 안의 한 장(시트)   	
     	
     	int rowIdx = 0; //엑셀의 첫줄(row)은 0부터 시작
     	
     	
     	//헤더 생성
     	Row header = sheet.createRow(rowIdx++);
    	
    	String[] headers = {"순번", "커뮤니티 이름", "운영시간", "최근 점검 일자", "점검 상태"};
    	
    	for(int i=0; i<headers.length; i++) {
    		header.createCell(i).setCellValue(headers[i]);
    	}
    	    	
    	
    	//데이터 행 생성
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");   //최근점검일자 형식 지정    	
    	int no = 1;  //화면에 보이는 순번용 번호
    	
    	for(CmmntyVO vo : list) {   //db에서 조회한 커뮤니티 목록 한 줄씩 엑셀에 저장, list 안의 요소를 하나씩 꺼내서 vo에 담아 반복 처리
    	  
    		Row row = sheet.createRow(rowIdx++);  
    		
    		row.createCell(0).setCellValue(no++);  //0번 칸 : 순번
    		row.createCell(1).setCellValue(vo.getCmmntyNm() == null ? "" : vo.getCmmntyNm());  //1번 칸 : 커뮤니티 이름
    		
    		String opn = vo.getCmmntyOpnVwpoint() == null ? "" : vo.getCmmntyOpnVwpoint();  //2번 칸 : 운영시간
    		String cls = vo.getCmmntyClosVwpoint() == null ? "" : vo.getCmmntyClosVwpoint(); 
    		row.createCell(2).setCellValue(opn + "~" + cls);
    		
    		row.createCell(3).setCellValue(vo.getCmmntyChckDt() == null? "" : sdf.format(vo.getCmmntyChckDt()));
    		row.createCell(4).setCellValue(vo.getCmmntyChcksttus() == null? "" : vo.getCmmntyChcksttus());    		
    	}
    	    	
    	
    	//보기 좋게 셀 너비 자동조절
    	for(int i =0; i<headers.length; i++) {
    		sheet.autoSizeColumn(i);
    	}
    	
    	
    	//브라우저로 다운로드 응답
    	String filename = "커뮤니티 리스트.xlsx";   //다운르드 파일명
    	String encoded = URLEncoder.encode(filename, StandardCharsets.UTF_8.toString()).replace("+", "%20");  //한글 파일명 깨짐 방지, %20은 진짜 공백을 의미
    	
    	
    	//브라우저에 엑셀파일임을 안내
    	response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");  //표준 코드
    	
    	//브라우저 헤더에 다운로드 창 띄움
    	response.setHeader("Content-Disposition", "attachment; filename*=UTF-8''"+encoded);  //표준 코드, attachment: 첨부파일로 처리
    	
    	wb.write(response.getOutputStream());  //엑셀파일을 응답스트림으로 전송
    	
    	wb.close(); //메모리 정리   	
    }
		
				
	}
	
	
	
	

