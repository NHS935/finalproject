package kr.or.ddit.service;

public interface KakaoService {

  //카카오톡 투표 알림
   public void sendVotenotice(String mtrSj, String string);

  //카카오톡 회원가입 승인 알림
   public void sendmberapprove(String mberId, String loginUrl);

}
