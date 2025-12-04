package kr.or.ddit.service.impl;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;

import kr.or.ddit.enums.NtcnType;
import kr.or.ddit.mapper.FcltyManageMapper;
import kr.or.ddit.mapper.FxMapper;
import kr.or.ddit.mapper.NtcnMapper;
import kr.or.ddit.service.FcltyManageService;
import kr.or.ddit.service.FxService;
import kr.or.ddit.util.NtcnUtil;
import kr.or.ddit.vo.CmmntyVO;
import kr.or.ddit.vo.CvplVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FcltyManageVO;
import kr.or.ddit.vo.FcltyVO;
import kr.or.ddit.vo.FxVO;
import lombok.extern.slf4j.Slf4j;

@Transactional
@Slf4j
@Service
public class FcltyManageServiceImpl implements FcltyManageService {

	@Autowired
	FcltyManageMapper fcltyManagemapper;

	@Autowired
	FxMapper fxMapper;
	
	@Autowired
	NtcnUtil ntcnUtil;
	
	@Autowired
	NtcnMapper ntcnMapper;
	
	@Autowired
	FxService fxService;

	//직원 아이디 조회
	@Override
	public List<EmpVO> selectEmpList() {
		return this.fcltyManagemapper.selectEmpList();
	}
	// 시설 일련번호 조회
	@Override
	public List<FcltyVO> selectFcltySn(int fcltySn) {
		return this.fcltyManagemapper.selectFcltySn(fcltySn);
	}
	
	//커뮤니티 일련번호 조회
	@Override
	public List<CmmntyVO> selectCmmnty(int cmmntySn) {
		return this.fcltyManagemapper.selectCmmnty(cmmntySn);
	}

	//시설관리 등록
	@Transactional
	@Override
	public int registerPost(FcltyManageVO fcltyManageVO) {
		 
		// 점검상태 값 시설관리_점검상태에도 저장
		if(fcltyManageVO.getFcltySn() != 0 ) {
			fcltyManageVO.setFcltymanageChcksttus(fcltyManageVO.getFcltySttus());
		}else if(fcltyManageVO.getCmmntySn() != 0) {
			fcltyManageVO.setFcltymanageChcksttus(fcltyManageVO.getCmmntyChcksttus());
		}
		
		int result = fcltyManagemapper.registerPost(fcltyManageVO);
		
		FxVO fxVO = null;
		
		if(result>0) {
			fxVO = new FxVO();
			fxVO.setFcltyManageSn(fcltyManageVO.getFcltyManageSn());
			fxVO.setFxBeginDt(fcltyManageVO.getFcltymanageBeginDt());
			fxVO.setFxEndDt(fcltyManageVO.getFcltymanageEndDt());
			fxVO.setFcltySn(fcltyManageVO.getFcltySn());
			fxVO.setCmmntySn(fcltyManageVO.getCmmntySn());
			
			log.info("fxVO(동기화 확인2) : {} ",fxVO);
			
			try {
				fxService.insert(fxVO);				
			}catch(Exception e) {
				log.error("일정 점검기간 동기화 실패",e);
			}
			
		}
		
		log.info("result(동기화 확인) : {} ",result);
		
		
		//시설 및 커뮤니티 상태 업데이트
		if(fcltyManageVO.getFcltySn() != 0) {
			 fcltyManagemapper.updateFcltySttus(fcltyManageVO);
			 fcltyManagemapper.updatefcltyChckDt(fcltyManageVO);
			 fcltyManagemapper.updatefclmanageChcksttus(fcltyManageVO);
		}else if(fcltyManageVO.getCmmntySn() != 0){
			fcltyManagemapper.updateCmmntyChcksttus(fcltyManageVO);
			fcltyManagemapper.updatefclmanageChcksttus(fcltyManageVO);
		}
						 
		//시설관리 점검상태 값 업데이트 
		 
		// 알림 처리
		String fcltymanageChcksttus = fcltyManageVO.getFcltymanageChcksttus(); // 점검상태
		LocalDateTime beginDateTime = fcltyManageVO.getFcltymanageBeginDt().toInstant().atZone(ZoneId.of("Asia/Seoul")).toLocalDateTime();
		LocalDateTime endDateTime = fcltyManageVO.getFcltymanageEndDt().toInstant().atZone(ZoneId.of("Asia/Seoul")).toLocalDateTime();
		String beginFormattedDate = beginDateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
		String endFormattedDate = endDateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
		
		//fcltyManageVO 조회(수신자, 알림 제목)
		if(fcltyManageVO.getFcltySn() != 0) {
			List<FcltyVO> fcltyVOList = ntcnMapper.selectAptcmplFcltyClFcltyNm(fcltyManageVO.getFcltyManageSn());
			
			for (FcltyVO fcltyVO1 : fcltyVOList) {
				if("점검예정".equals(fcltymanageChcksttus)) {
					ntcnUtil.sendAdmin(fcltyManageVO.getEmpId() , fcltyVO1.getAptcmpl(), NtcnType.FCLTY
							, "현재 거주 중인 " + fcltyVO1.getFcltyLc() + " " + fcltyVO1.getFcltyNm() +"가<br>" + beginFormattedDate + "부터 " + endFormattedDate + "까지 점검 예정입니다."
							, "/main");
				} else if("점검중".equals(fcltymanageChcksttus)) {
					ntcnUtil.sendAdmin(fcltyManageVO.getEmpId() , fcltyVO1.getAptcmpl(), NtcnType.FCLTY
							, "현재 거주 중인 " + fcltyVO1.getFcltyLc() + " " +fcltyVO1.getFcltyNm() +"가<br>" + "긴급 점검으로 인하여 " + endFormattedDate + "까지 점검 예정입니다."
							, "/main");
				}
			}
		}
		if(fcltyManageVO.getCmmntySn() != 0) {
			fcltyManageVO = this.ntcnMapper.selectCmmntySnCmmntyNm(fcltyManageVO.getFcltyManageSn());
			
			if("점검예정".equals(fcltymanageChcksttus)) {
				ntcnUtil.sendAdmin(fcltyManageVO.getEmpId() , "ALL_MBER", NtcnType.FCLTY
						, fcltyManageVO.getCmmntyNm() + " 커뮤니티시설이<br>" + beginFormattedDate + "부터 " + endFormattedDate + "까지 점검 예정입니다."
						, "/main");
			} else if("점검중".equals(fcltymanageChcksttus)) {
				ntcnUtil.sendAdmin(fcltyManageVO.getEmpId() , "ALL_MBER", NtcnType.FCLTY
						, fcltyManageVO.getCmmntyNm() + " 커뮤니티시설이<br>" + "긴급 점검으로 인하여 " + endFormattedDate + "까지 점검 예정입니다."
						, "/main");
			}
		}		
		
		log.info("fcltyManageVO(확인용) : {}",fcltyManageVO);
		 
		return result;
	}

	
	//전체 행의 수
	@Override
	public int getTotal(Map<String, Object> map) {
		return this.fcltyManagemapper.getTotal(map);
	}
	
	//시설 관리 목록 조회
	@Override
	public List<FcltyManageVO> fclManageAllist(Map<String, Object> map) {
		
		log.info("map(확인) :{}",map);
		
		return this.fcltyManagemapper.fclManageAllist(map);
	}
	
	//시설관리 리스트에서 일정등록 여부 확인
	@Override
	public int getFxcount(int manageSn) {
		return this.fxMapper.getFxcount(manageSn);

	}
	







	

	
	

}
