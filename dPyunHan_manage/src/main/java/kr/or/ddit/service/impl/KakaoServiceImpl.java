package kr.or.ddit.service.impl;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import kr.or.ddit.mapper.VoteMtrMapper;
import kr.or.ddit.service.KakaoService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class KakaoServiceImpl implements KakaoService {
	
	
	@Value("${kakao.access.token}")
	private String kakaoAccessToken;
	
		
	//카카오톡 투표 알림 => 지금 방식은 나의 계정으로 나에게 보내기만 가능함 만약, 입주민 전체에게 보내려면 검수 요청 필수
	@Override
	public void sendVotenotice(String mtrSj, String string) {  //제목, 일련번호
		
		//메세지 생성
		try {
			/*  기본템플릿
			 * String message = "{" + "\"object_type\":\"text\"," +
			 * "\"text\":\" 📢 새로운 투표가 등록되었습니다 : " + mtrSj + "\"," + "\"link\":{" +
			 * "\"web_url\":\"" + string + "\"," + "\"mobile_web_url\":\"" + string + "\"" +
			 * "}," + "\"button_title\":\"투표 하기\"" + "}";
			 */
			 
			String message = "{"
                    + "\"template_id\": 125539,"
                    + "\"template_args\": {"
                    + "\"vote_title\": \"" + mtrSj + "\","
                    + "\"vote_url\": \"" + string + "\""
                    + "}"
                    + "}";
							 
		 //카카오톡 api호출
		  //String url = "https://kapi.kakao.com/v2/api/talk/memo/default/send";   //나에게 보내기(친구한테 보내려면 v1)
		  //String url = "https://kapi.kakao.com/v1/api/talk/friends/message/default/send";   //친구에게 보내기(기본템플릿)
		  String url = "https://kapi.kakao.com/v1/api/talk/friends/message/send";   //친구에게 보내기(사용자 정의 템플릿)
		  
		  RestTemplate restTemplate = new RestTemplate(); //spring에서 제공하는, 위의 객체로 실제 http 요청 전송
		  
		  HttpHeaders headers = new HttpHeaders();  //요청 헤더를 담을 객체 생성
		   
		  //            누가 요청했는가      토큰 소유자
		  headers.add("Authorization", "Bearer " + kakaoAccessToken);  //내가 발급받은 api 엑세스 토큰 입력(토큰 유효시간 6시간)
		   
		  headers.add("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");   //카카오톡이 지정한 형식
		  
		  //친구 목록에서 받아온 uuid 작성 
		 // String recieveuuid = "[\"blxvWW9ea1lpRXRAcUl7QnRCcV1sX2xeb1xtHg\"]";   //내 아이디로 로그인해서 카카오소셜-카카오톡 친구 목록 조회 - 전송에서 결과값에서 확인 (기본 템플릿)
		  String recieveuuid = "[\"blxvWW9ea1lpRXRAcUl7QnRCcV1sX2xeb1xtHg\"]";  
		  
		  
		  MultiValueMap<String, String> params = new LinkedMultiValueMap<>();  //http 요청의 폼 데이터(body부분) 담기 위한 객체 생성
		  
			/* 친구에게 기본템플릿으로 보낼 경우
			 * params.add("receiver_uuids", recieveuuid); // 카카오에서 설정한 형식(친구 목록)
			 * params.add("template_object", message); //위에서 설정한 메세지 템플릿 문자열 넣기,
			 * template_object은 카카오톡 api에서 요구하는 파라미터 이름
			 */		  
		  
		  params.add("receiver_uuids", recieveuuid);    
		  params.add("template_id", "125539");  
		  params.add("template_args", 
				  //"{\"title\":\"" + mtrSj + "\",\"url\":\"" + string + "\"}" 
		    String.format("{\"vote_title\":\"%s\", \"vote_url\":\"%s\"}", mtrSj, string) );
		  
		  log.info("템플릿 파라미터 확인: {}", String.format("{\"vote_title\":\"%s\", \"vote_url\":\"%s\"}", mtrSj, string));
		 
		 		  
		  HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(params,headers);  //params(본문)+headers(헤더) 묶어서 RestTemplate이 최종적으로 post 요청 보내기
		   
		  ResponseEntity<String> response =  restTemplate.postForEntity(url, entity, String.class); //위의 요청 결과(응답)을 받음(요청을 보낼 주소, 본문과 헤더를 담은 객체, 어떤 타입으로 받을지(문자열로 받겠다)
		
		  log.info("카카오 응답 : {} ",response.getBody());
		  
		}catch(Exception e) {
			log.info("카카오톡 알림 전송 실패", e);
		}
	}

  //카카오톡 회원가입 승인 알림
	@Override
	public void sendmberapprove(String mberId, String loginUrl) {
		
		//메세지 생성
		try {
			
			//카카오톡 api 호출
			String url = "https://kapi.kakao.com/v1/api/talk/friends/message/send";   //친구에게 보내기(사용자 정의 템플릿)	
			
			RestTemplate restTemplate = new RestTemplate(); //spring에서 제공하는, 위의 객체로 실제 http 요청 전송
			
			HttpHeaders headers = new HttpHeaders();  //요청 헤더를 담을 객체 생성	
			
//      누가 요청했는가      토큰 소유자
			headers.add("Authorization", "Bearer " + kakaoAccessToken);  //내가 발급받은 api 엑세스 토큰 입력(토큰 유효시간 6시간)
			
			headers.add("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");   //카카오톡이 지정한 형식	
			
			
	//친구 목록에서 받아온 uuid 작성 		
	  String recieveuuid = "[\"blxvWW9ea1lpRXRAcUl7QnRCcV1sX2xeb1xtHg\"]";  		
	 
	  MultiValueMap<String, String> params = new LinkedMultiValueMap<>();  //http 요청의 폼 데이터(body부분) 담기 위한 객체 생성
		
	  params.add("receiver_uuids", recieveuuid);    
	  params.add("template_id", "126052");  
	  params.add("template_args", 
			 
	  String.format("{\"user_id\":\"%s\", \"login_url\":\"%s\"}", mberId, loginUrl));
	  
	  log.info("템플릿 파라미터 확인: {}", 
			    String.format("{\"user_id\":\"%s\", \"login_url\":\"%s\"}", mberId, loginUrl));
	  
	  HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(params,headers);  //params(본문)+headers(헤더) 묶어서 RestTemplate이 최종적으로 post 요청 보내기
	   
	  ResponseEntity<String> response =  restTemplate.postForEntity(url, entity, String.class); //위의 요청 결과(응답)을 받음(요청을 보낼 주소, 본문과 헤더를 담은 객체, 어떤 타입으로 받을지(문자열로 받겠다)
	
	  log.info("카카오 응답 : {} ",response.getBody()); 
    
    }catch(Exception e) {
    	log.info("카카오톡 회원가입 알림 실패",e);
    }
	
  }
}