package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.enums.NtcnType;
import kr.or.ddit.mapper.FcltyManageMapper;
import kr.or.ddit.mapper.FcltyMapper;
import kr.or.ddit.mapper.NtcnMapper;
import kr.or.ddit.service.FcltyService;
import kr.or.ddit.util.NtcnUtil;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.FcltyManageVO;
/*import kr.or.ddit.vo.cmmntyVO;*/
import kr.or.ddit.vo.FcltyVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FcltyServiceImpl implements FcltyService {
	
	@Autowired
	FcltyMapper fcltymapper;
	
	@Autowired
	NtcnUtil ntcnUtil;
	
	@Autowired
	NtcnMapper ntcnMapper;

	//시설점검 결과 등록	
	/*
	 * @Override public int registerPost(FcltyVO fcltyVO) { return
	 * this.fcltymapper.registerPost(fcltyVO); }
	 */

	//시설 점검 결과 목록
	@Override
	public List<FcltyVO> list(Map<String, Object> map) {
		return this.fcltymapper.list(map);
	}

    //전체 행의 수
	@Override
	public int getTotal(Map<String, Object> map) {
		return this.fcltymapper.getTotal(map);
	}

	//모달 변경 상태값 db 변경
	@Transactional
	@Override
	public int updatePost(FcltyVO fcltyVO) {
		//1.시설 상태변경
		int result = this.fcltymapper.updatePost(fcltyVO);
		
		List<FcltyVO> fcltyVOList = ntcnMapper.selectAptcmplFcltyClFcltyNm1(fcltyVO.getFcltySn());
		
		if(result > 0) {
			if("점검완료".equals(fcltyVO.getFcltySttus()) || "정상".equals(fcltyVO.getFcltySttus())) {
				for (FcltyVO fcltyVO1 : fcltyVOList) {
					ntcnUtil.sendAdmin(fcltyVO1.getEmpId() , fcltyVO1.getAptcmpl(), NtcnType.FCLTY
							, "현재 거주 중인 " + fcltyVO1.getFcltyLc() + " " +fcltyVO1.getFcltyNm() +"가<br>" + "점검 완료되었습니다."
									, "/main");
				}
			}			
		}
		
		log.info("result :"+result);
		
		// FCLTY_MANAGE의 FCLTY_MANAGE_SN 행의 갯수에 따라
		
		int manageCount = fcltymapper.selectManageCount(fcltyVO.getFcltySn());
		
		if(manageCount >= 2) {		
          result += this.fcltymapper.updateManage(fcltyVO);  //시설매니지가 2개 이상일때 이전 행 점검완료 처리                                                          //해당 시설이 1개일때
		  result += this.fcltymapper.updateManageRecent(fcltyVO);   //2개 이상일 때 최신 행 시설 상태 동일 처리
		}else {
		  result += fcltymapper.updateManage2(fcltyVO);   //1개 이하일때
		};
		
		log.info("fcltySn(아하) : {}", fcltyVO.getFcltySn());
		log.info("manageCount : {}", manageCount);
		
		return result;
	}

	/*
	 * // 커뮤니티 리스트 목록 조회
	 * 
	 * @Override public List<CmmntyVO> cmmntylist(Map<String, Object> map) { return
	 * this.fcltymapper.cmmntylist(map); }
	 */

	//상태값 변경 전 db 값 조회
	@Override
	public FcltyVO detail(int fcltySn) {
		return this.fcltymapper.detail(fcltySn);
	}

	//담당자 정보 조회
	@Override
	public List<EmpVO> empList() {
		return this.fcltymapper.empList();
	}

	//10개 이상 행 보이게 조회
	@Override
	public List<FcltyVO> selectAll() {
		return this.fcltymapper.selectAll();
	}



}
