package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.MtinspVO;

public interface SLRService {

    // 특정 연월(YYYYMM)의 관리비를 계산하고 tester테이블에 insert
    List<MtinspVO> calculateDailyTotals(String yearMonth);
    
}
