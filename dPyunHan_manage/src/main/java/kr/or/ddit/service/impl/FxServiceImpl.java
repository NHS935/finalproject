package kr.or.ddit.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mapper.FxMapper;
import kr.or.ddit.service.FxService;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FxVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FxServiceImpl implements FxService {

	@Autowired
	FxMapper fxMapper;

	
	//일정조회
	@Override
	public List<FxVO> list(String start, String end) {
		
		Map<String,Object> map = new HashMap<>();
		
		map.put("fxBeginDt",start);
		map.put("fxEndDt", end);
		
		log.info("map : {}",map);
		
		return fxMapper.list(map);
	}
	
	/*
	 * //일정 등록 (나혜선 수정)
	 * 
	 * @Transactional(propagation = Propagation.REQUIRES_NEW) //별도 트랜젝션으로 분리
	 * 
	 * @Override public int insert(FxVO fxVO) { int result =
	 * fxMapper.fcltyschdulregiser(fxVO);
	 * 
	 * log.info("result(등록) : {}",result);
	 * 
	 * if(result>0) { //insert 후 다시 db에서 값 조회해오기 FxVO reselect =
	 * fxMapper.reselectFxDate(fxVO.getFcltyManageSn());
	 * log.info("reselect(다시 조회) : {}",reselect);
	 * 
	 * if(reselect != null) { fxVO.setFxBeginDt(reselect.getFxBeginDt());
	 * fxVO.setFxEndDt(reselect.getFxEndDt()); }
	 * 
	 * //날짜가 null이 아니면 동기화 처리 if(fxVO.getFxBeginDt() != null) {
	 * syncCheckDates(fxVO); //사용자 정의 메서드 }else {
	 * log.warn("⚠ FX 날짜가 null입니다. 동기화가 수행되지 않습니다."); } } return result; }
	 */
	
	
	//일정 등록 (나혜선 수정)
	@Transactional(propagation = Propagation.REQUIRES_NEW) //별도 트랜젝션으로 분리
	@Override
	public int insert(FxVO fxVO) {
	  int result = fxMapper.insert(fxVO);	
	  
		log.info("result(일정화면에서 일정 등록) : {}",result);
	   
	  return result;	
	}
	
	
	
	//일정 수정 (나혜선 수정)
	@Transactional(propagation = Propagation.REQUIRES_NEW) //별도 트랜젝션으로 분리
	@Override
	public int modify(FxVO fxVO) {
		
		int result = fxMapper.modify(fxVO);
		
		log.info("result(수정) : {}",result);
		
		 if(result>0) {
			  //modify 후 다시 db에서 값 조회해오기
			  FxVO updateVO = fxMapper.reupdateFxDate(fxVO.getSchdulSn());
			  log.info("updateVO(다시 수정 후 조회) : {}",updateVO);
			  
			  if(updateVO != null) {
				  fxVO.setFxBeginDt(updateVO.getFxBeginDt());
				  fxVO.setFxEndDt(updateVO.getFxEndDt());
				  fxVO.setFxSj(updateVO.getFxSj());
				  fxVO.setFxIem(updateVO.getFxIem());
				  fxVO.setFxCn(updateVO.getFxCn());
				  fxVO.setFxPlace(updateVO.getFxPlace());
				  
				  fxVO.setFcltyManageSn(updateVO.getFcltyManageSn());
				  fxVO.setFcltySn(updateVO.getFcltySn());
				  fxVO.setCmmntySn(updateVO.getCmmntySn());
				  
				  fxVO.setEmpId(updateVO.getEmpId());
			  }
			  
			  //날짜가 null이 아니면 동기화 처리
			  if(fxVO.getFxBeginDt() != null) {			 		  
			   syncCheckDates(fxVO);  //사용자 정의 메서드
		   }else {
			   log.warn("⚠ FX 날짜가 null입니다. 동기화가 수행되지 않습니다.");
		   }
		}
		
		return result;		
	}

	
	//시설/보안 커뮤니티 점검 이력 리스트 일정 등록 (나혜선 수정)
	@Transactional(propagation = Propagation.REQUIRES_NEW) //별도 트랜젝션으로 분리
	@Override
	public int fcltyschdulregiser(FxVO fxVO) {
		
		int result = fxMapper.fcltyschdulregiser(fxVO);
		
		if(result>0) {
			  
			  FxVO reselect = fxMapper.reselectFxDate(fxVO.getFcltyManageSn());
			  log.info("reselect(다시 수정 후 조회) : {}",reselect);
			  
			  if(reselect != null) {
				  fxVO.setFxBeginDt(reselect.getFxBeginDt());
				  fxVO.setFxEndDt(reselect.getFxEndDt());
			  }
			  
			  //날짜가 null이 아니면 동기화 처리
			  if(fxVO.getFxBeginDt() != null) {			 		  
			   syncCheckDates(fxVO);  //사용자 정의 메서드
		   }else {
			   log.warn("⚠ FX 날짜가 null입니다. 동기화가 수행되지 않습니다.");
		   }
		}
		
		return result;
	}


	//일정 등록 시 emp 전체 목록 조회해오기
	@Override
	public List<EmpVO> getEmpList() {
		return this.fxMapper.getEmpList();
	}


	//시설,커뮤니티,시설관리 동기화(점검 일자 동기화)
	private void syncCheckDates(FxVO fxVO) {
				
		log.info("fx(점검일자 동기화 확인) : {} ",fxVO);  //fxBeginDt 확인
		
		//시설관리 점검일자 동기화
		if(fxVO.getFcltyManageSn() > 0) {
			log.info("FcltyManageSn(점김일자 확인) :{}",fxVO.getFcltyManageSn());
			
			fxMapper.updateFcltyManageDate(
			   fxVO.getFcltyManageSn(),
			   fxVO.getFxBeginDt(),
			   fxVO.getFxEndDt()
		   );
		}
		
		//시설 점검 일자 동기화
		if(fxVO.getFcltySn() > 0) {
			
			log.info("FcltySn(점김일자 확인) :{}",fxVO.getFcltySn());
			
			fxMapper.updateFcltyDate(
			   fxVO.getFcltySn(),
			   fxVO.getFxBeginDt()
			);
		}
		
		//커뮤니티 점검 일자 동기화
		if(fxVO.getCmmntySn() >0) {
			
			log.info("CmmntySn(점김일자 확인) :{}",fxVO.getCmmntySn());
			
			fxMapper.updateCmmntyDate(
			   fxVO.getCmmntySn(),
			   fxVO.getFxBeginDt()
			);
		}
		
	}
	
	
}//전체 끝
