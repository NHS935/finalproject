package kr.or.ddit.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.ResveMapper;
import kr.or.ddit.service.ResveService;
import kr.or.ddit.vo.CmmntyVO;
import kr.or.ddit.vo.ResveVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ResveServiceImpl implements ResveService{

	@Autowired
	ResveMapper resveMapper;

	// 커뮤니티시설 리스트(예약)
	@Override
	public List<CmmntyVO> list(CmmntyVO cmmntyVO) {
		return this.resveMapper.list(cmmntyVO);
	}

	// 해당 커뮤니티시설 상세 조회
	@Override
	public CmmntyVO detail(CmmntyVO cmmntyVO) {
		return this.resveMapper.detail(cmmntyVO);
	}

	// 해당 커뮤니티시설 시간대 조회
	@Override
	public List<String> selectTimeSlots(CmmntyVO cmmntyVO) {
		return this.resveMapper.selectTimeSlots(cmmntyVO);
	}

	//2. 해당 날짜, 시설 예약 내역 조회
	@Override
	public List<ResveVO> resveAvailable(ResveVO resveVO) {
		//해당 커뮤니티시설 1시간 단위당 남은 잔여 인원 수
		
		// 1. 시설 기본 정보 조회
	    CmmntyVO cmmntyVO = this.resveMapper.detail(resveVO.getCmmntyVO());
	    if (cmmntyVO == null) {
	        throw new IllegalArgumentException("존재하지 않는 시설 번호: " + resveVO.getCmmntySn());
	    }

	    int open = Integer.parseInt(cmmntyVO.getCmmntyOpnVwpoint().split(":")[0]);
	    int close = Integer.parseInt(cmmntyVO.getCmmntyClosVwpoint().split(":")[0]);
	    if (close == 0) close = 24;
	    int maxNmpr = cmmntyVO.getTotAceptncNmpr();

	    // 2. 해당 날짜 예약내역 조회
	    List<ResveVO> resveList = this.resveMapper.resveAvailable(resveVO);

	    // 3. 시간대별 누적 인원 (겹침 고려)
	    Map<Integer, Integer> usedMap = new HashMap<>();
	    for (ResveVO r : resveList) {
	        int start = r.getBeginVwpoint();  // 시작 시각
	        int duration = r.getResveTime();  // 이용 시간
	        int end = start + duration;       // 종료 시각

	        for (int t = start; t < end; t++) { // 점유 구간 전부 누적
	            usedMap.put(t, usedMap.getOrDefault(t, 0) + r.getResveNmpr());
	        }
	    }

	    // 4️. 전체 운영시간대 기준 잔여 인원 계산
	    List<ResveVO> availableList = new ArrayList<>();
	    for (int t = open; t < close; t++) {
	        ResveVO slot = new ResveVO();
	        slot.setCmmntySn(resveVO.getCmmntySn());
	        slot.setResveDt(resveVO.getResveDt());
	        slot.setResveTime(t);
	        int remain = maxNmpr - usedMap.getOrDefault(t, 0);
	        slot.setResveNmpr(remain < 0 ? 0 : remain);
	        availableList.add(slot);
	    }

	    return availableList;
	}

	// 예약 실행
	@Override
	public int resve(ResveVO resveVO) {
		return this.resveMapper.resve(resveVO);
	}

	//내 예약현황 리스트
	@Override
	public List<ResveVO> resveMber(ResveVO resveVO) {
		return this.resveMapper.resveMber(resveVO);
	}

	//탭별 예약 상세
	@Override
	public ResveVO resveMberDetail(int resveSn) {
		return this.resveMapper.resveMberDetail(resveSn);
	}

	// 예약 취소 실행
	@Override
	public int resveCancel(ResveVO resveVO) {
		return this.resveMapper.resveCancel(resveVO);
	}

	
}