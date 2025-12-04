package kr.or.ddit.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.PayMapper;
import kr.or.ddit.service.PayService;
import kr.or.ddit.vo.LevyVO;
import kr.or.ddit.vo.PayVO;

@Service
public class PayServiceImpl implements PayService {

	@Autowired
	PayMapper payMapper;

	// 납부 내역 목록 
	@Override
	public List<PayVO> list(String hshldId, String keyword) {
	    return this.payMapper.list(hshldId, keyword);
	}
	
	/*전체 행의 수
	<select id="getTotal" resultType="int">*/ 
	@Override
	public List<LevyVO> getTotal(String hshldId) {
		return this.payMapper.getTotal(hshldId);
	}

	@Override
	public void completePayment(PayVO payVO) {
		  // 1. PAY 테이블에 결제 기록 추가
        payMapper.insertPay(payVO);

        // 2. RQEST 테이블 납부 상태 + PAY_SN 업데이트
        Map<String,Object> map = new HashMap<>();
        map.put("rqestSn", payVO.getRqestSn());
        map.put("paySn", payVO.getPaySn());
        payMapper.updateRqestAfterPay(map);
    }
		
	}

