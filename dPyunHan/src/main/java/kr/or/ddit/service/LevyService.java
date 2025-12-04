package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.PayVO;
import kr.or.ddit.vo.LevyVO;

public interface LevyService {
	 // 회원 ID로 세대 ID 조회
	public String selectHouseholdIdByMember(String mberId);

	// 세대 월별 관리비 조회
  public List<LevyVO> selectMonthlyRqestByHouse(String hshldId, String yearMonth);
  
  // 결제 성공 시 PAY 기록 + RQEST 상태 업데이트
  public void processPayment(PayVO pay);

  
}
