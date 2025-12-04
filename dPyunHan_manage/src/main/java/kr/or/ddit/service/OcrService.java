package kr.or.ddit.service;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import kr.or.ddit.vo.BizcndIndutyVO;
import kr.or.ddit.vo.CcpyManageVO;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class OcrService {
    
    @Value("${naver.ocr.secret-key}")
    private String secretKey;
    
    @Value("${naver.ocr.invoke-url}")
    private String invokeUrl;
    
    @Value("${naver.ocr.domain-name}")
    private String domainName;
    
    public JSONObject processBizLicenseOcr(String imagePath) throws Exception {
        
        if (!new File(imagePath).exists()) {
            throw new IllegalArgumentException("파일이 존재하지 않습니다: " + imagePath);
        }
        
        String boundary = "----" + UUID.randomUUID().toString().replaceAll("-", "");
        URL url = new URL(invokeUrl);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        
        con.setUseCaches(false);
        con.setDoInput(true);
        con.setDoOutput(true);
        con.setReadTimeout(30000);
        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
        con.setRequestProperty("X-OCR-SECRET", secretKey);
        
        // 요청 JSON 생성 및 전송
        JSONObject requestJson = createRequestJson();
        sendMultipartRequest(con, boundary, requestJson.toString(), imagePath);
        
        // 응답 수신
        JSONObject ocrResponse = receiveResponse(con);
        return ocrResponse;
    }
    
    public CcpyManageVO extractCcpyManageVO(JSONObject ocrResult) throws Exception {
        
        CcpyManageVO ccpyManageVO = new CcpyManageVO();
        
        JSONArray images = (JSONArray) ocrResult.get("images");
        if (images == null || images.isEmpty()) {
            log.warn("이미지가 없습니다");
            return ccpyManageVO;
        }
        
        JSONObject imageResult = (JSONObject) images.get(0);
        JSONArray fields = (JSONArray) imageResult.get("fields");
        
        if (fields != null) {
            List<String> bizcndList = new ArrayList<>();
            List<String> indutyList = new ArrayList<>();
            
            for (Object field : fields) {
                JSONObject fieldObj = (JSONObject) field;
                String fieldName = (String) fieldObj.get("name");
                String fieldValue = (String) fieldObj.get("inferText");
                
                if (fieldValue == null || fieldValue.trim().isEmpty()) {
                    continue;
                }
                
                // 간단한 필드 매핑
                if ("ccpyBizrno".equals(fieldName)) {
                    ccpyManageVO.setCcpyBizrno(extractNumber(fieldValue));
                    log.info("check : setCcpyBizrno => {}", ccpyManageVO.getCcpyBizrno());
                    
                } else if ("ccpyCmpnyNm".equals(fieldName)) {
                    ccpyManageVO.setCcpyCmpnyNm(extractAfterColon(fieldValue));
                    log.info("check : setCcpyCmpnyNm => {}", ccpyManageVO.getCcpyCmpnyNm());
                    
                } else if ("ccpyRprsntvNm".equals(fieldName)) {
                    ccpyManageVO.setCcpyRprsntvNm(extractAfterColon(fieldValue).replaceAll("\\s+", ""));
                    log.info("check : setCcpyRprsntvNm => {}", ccpyManageVO.getCcpyRprsntvNm());
                    
                } else if ("ccpyOpbizDe".equals(fieldName)) {
                    try {
                    	LocalDate parsedDate = parseLocalDate(fieldValue);
                    	Date convertedDate = convertLocalDateToDate(parsedDate);
                        ccpyManageVO.setCcpyOpbizDe(convertedDate);
                        log.info("check : setCcpyOpbizDe => {}", ccpyManageVO.getCcpyOpbizDe());
                    } catch (Exception e) {
                        log.warn("check : error/setCcpyOpbizDe => {}", fieldValue);
                    }
                    
                } else if ("ccpyAdres".equals(fieldName)) {
                    ccpyManageVO.setCcpyAdres(extractAfterColon(fieldValue).replaceAll("^\\s+", ""));
                    log.info("check : setCcpyAdres => {}", ccpyManageVO.getCcpyAdres());
                    
                } else if ("bizcndNm".equals(fieldName)) {
                    String[] items = fieldValue.split("\n");
                    for (String item : items) {
                        String trimmed = item.trim();
                        if (!trimmed.isEmpty()) {
                            bizcndList.add(trimmed);
                        }
                    }
                    log.info("check : bizcndList => {}", bizcndList);
                    
                } else if ("indutyNm".equals(fieldName)) {
                    String[] items = fieldValue.split("\n");
                    for (String item : items) {
                        String trimmed = item.trim();
                        if (!trimmed.isEmpty()) {
                            indutyList.add(trimmed);
                        }
                    }
                    log.info("check : indutyList => {}", indutyList);
                }
            }
            
            ccpyManageVO.setBizcndIndutyVOList(
                createBizcndIndutyList(bizcndList, indutyList)
            );
        }
        return ccpyManageVO;
    }
    
    private Date convertLocalDateToDate(LocalDate localDate) {
        if (localDate == null) return null;
        return java.sql.Date.valueOf(localDate);
    }
    
    private List<BizcndIndutyVO> createBizcndIndutyList(
        List<String> bizcndList, 
        List<String> indutyList) {
        
        List<BizcndIndutyVO> bizcndIndutyVOList = new ArrayList<>();
        
        int maxSize = Math.max(bizcndList.size(), indutyList.size());
        
        for (int i = 0; i < maxSize; i++) {
            BizcndIndutyVO bizcndIndutyVO = new BizcndIndutyVO();
            
            if (i < bizcndList.size()) {
                bizcndIndutyVO.setBizcndNm(bizcndList.get(i));
            }
            if (i < indutyList.size()) {
                bizcndIndutyVO.setIndutyNm(indutyList.get(i));
            }
            
            bizcndIndutyVOList.add(bizcndIndutyVO);
            log.info("check : bizcndIndutyVO => {}", bizcndIndutyVO);
        }
        
        return bizcndIndutyVOList;
    }
    
    private JSONObject createRequestJson() {
        JSONObject json = new JSONObject();
        json.put("version", "V2");
        json.put("requestId", UUID.randomUUID().toString());
        json.put("timestamp", System.currentTimeMillis());
        
        JSONObject image = new JSONObject();
        image.put("format", "jpg");
        image.put("name", domainName);
        
        JSONArray images = new JSONArray();
        images.add(image);
        json.put("images", images);
        
        return json;
    }
    
    private void sendMultipartRequest(HttpURLConnection con, String boundary, 
                                     String message, String imagePath) throws Exception {
        try (DataOutputStream wr = new DataOutputStream(con.getOutputStream())) {
            // 메시지 부분
            wr.writeBytes("--" + boundary + "\r\n");
            wr.writeBytes("Content-Disposition: form-data; name=\"message\"\r\n\r\n");
            wr.writeBytes(message + "\r\n");
            
            // 파일 부분
            File file = new File(imagePath);
            wr.writeBytes("--" + boundary + "\r\n");
            wr.writeBytes("Content-Disposition: form-data; name=\"file\"; filename=\"" + 
                          file.getName() + "\"\r\n");
            wr.writeBytes("Content-Type: application/octet-stream\r\n\r\n");
            
            try (FileInputStream fis = new FileInputStream(file)) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = fis.read(buffer)) != -1) {
                    wr.write(buffer, 0, bytesRead);
                }
            }
            
            wr.writeBytes("\r\n--" + boundary + "--\r\n");
            wr.flush();
        }
    }
    
    private JSONObject receiveResponse(HttpURLConnection con) throws Exception {
        int responseCode = con.getResponseCode();
        log.info("check : responseCode => {} ", responseCode);
        
        try (BufferedReader br = new BufferedReader(
            new InputStreamReader(responseCode == 200 ? 
                con.getInputStream() : con.getErrorStream()))) {
            
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            
            JSONParser parser = new JSONParser();
            return (JSONObject) parser.parse(response.toString());
        }
    }
    
  private String extractAfterColon(String text) {
        if (text == null) return "";
        
        int colonIndex = text.indexOf(":");
        if (colonIndex == -1) {
            return text.trim();
        }
        
        return text.substring(colonIndex + 1).trim();
    }
    
    private String extractNumber(String text) {
        return text == null ? "" : text.replaceAll("[^0-9-]", "").trim();
    }
    
    private LocalDate parseLocalDate(String dateStr) throws Exception {
        if (dateStr == null) return LocalDate.now();
        
        String cleanDate = dateStr.replaceAll("[^0-9]", "");
        if (cleanDate.length() < 8) return LocalDate.now();
        
        String formatted = cleanDate.substring(0, 4) + "-" + 
                          cleanDate.substring(4, 6) + "-" + 
                          cleanDate.substring(6, 8);
        
        return LocalDate.parse(formatted, DateTimeFormatter.ISO_LOCAL_DATE);
    }
}
