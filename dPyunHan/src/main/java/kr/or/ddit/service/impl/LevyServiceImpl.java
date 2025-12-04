package kr.or.ddit.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mapper.LevyMapper;
import kr.or.ddit.mapper.PayMapper;
import kr.or.ddit.service.LevyService;
import kr.or.ddit.vo.LevyVO;
import kr.or.ddit.vo.PayVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class LevyServiceImpl implements LevyService {

    @Autowired
    private LevyMapper levyMapper;
    
    @Autowired
    private PayMapper payMapper;
    
    //회원 ID로 세대 ID 조회
    @Override
    public String selectHouseholdIdByMember(String mberId) {
    	 return levyMapper.selectHouseholdIdByMember(mberId);
    }

    // 세대 월별 관리비 조회
    @Override
    public List<LevyVO> selectMonthlyRqestByHouse(String hshldId, String yearMonth) {
    	
    	log.info("hshldId : {} ", hshldId);
    	log.info("yearMonth : {} ", yearMonth);
        return levyMapper.selectMonthlyRqestByHouse(hshldId, yearMonth);
    }

    // 결제처리 로직 (트랜잭션 적용)
    @Transactional
    @Override
    public void processPayment(PayVO pay) {
        log.info("processPayment() 실행 {}", pay);

        // 1PAY 테이블에 결제정보 저장
        payMapper.insertPay(pay);
        log.info("PAY 테이블 저장 완료");

        //  결제된 RQEST의 납부상태 변경 (PAY_STTUS=1, PAY_SN 연결)
        levyMapper.updatePayStatus(pay.getPaySn(), pay.getRqestSn());
        log.info("RQEST 납부 상태 변경 완료");
    }

}
