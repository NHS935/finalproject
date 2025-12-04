package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.LevyVO;
import kr.or.ddit.vo.PayVO;

public interface PayService {

	
	// 납부 내역 목록 
	public List<PayVO> list(String hshldId, String keyword);
	/*전체 행의 수
	<select id="getTotal" resultType="int">*/ 
	public List<LevyVO> getTotal(String hshldId);

    // 결제후 처리
	public void completePayment(PayVO payVO);


}
