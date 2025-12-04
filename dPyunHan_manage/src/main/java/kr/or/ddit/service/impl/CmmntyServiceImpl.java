package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import kr.or.ddit.enums.NtcnType;
import kr.or.ddit.mapper.CmmntyMapper;
import kr.or.ddit.service.CmmntyService;
import kr.or.ddit.util.NtcnUtil;
import kr.or.ddit.vo.CmmntyVO;
import kr.or.ddit.vo.EmpVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CmmntyServiceImpl implements CmmntyService {

	@Autowired
	CmmntyMapper cmmntymapper;
	
	@Autowired
	NtcnUtil ntcnUtil;
	
	//커뮤니티 리스트 목록 조회
	@Override
	public List<CmmntyVO> cmmntylist(Map<String, Object> map) {		
		return this.cmmntymapper.cmmntylist(map);		
	}

   //전체 행의 수 
	@Override
	public int getTotal2(Map<String, Object> map) {
		return this.cmmntymapper.getTotal2(map);
	}

	//모달 상태값 변경 db전달
	@Override
	public int cmmntyupdatePost(CmmntyVO cmmntyVO) {
		
		int result = this.cmmntymapper.cmmntyupdatePost(cmmntyVO);
		log.info("============테스트==========");
		log.info("result(커뮤니티) : {}",result);
		log.info("cmmntyVO(업데이트 확인) : {}",cmmntyVO);
		
		int manageCount = cmmntymapper.selectManageCount(cmmntyVO.getCmmntySn());
		
		if(manageCount>=2) {
			log.info("제발!!!");
			result += this.cmmntymapper.updateManage(cmmntyVO);
			log.info("제발!!!+");
			result += this.cmmntymapper.updateManageRecent(cmmntyVO);
		}else {
			result += cmmntymapper.updateManage2(cmmntyVO); //행 1개 이하 일때
		};
		
		log.info("manageCount(갯수확인) : {}",manageCount);
		
		if(result > 0) {
			if("점검완료".equals(cmmntyVO.getCmmntyChcksttus()) || "정상".equals(cmmntyVO.getCmmntyChcksttus())) {
				String empId = SecurityContextHolder.getContext().getAuthentication().getName();
				cmmntyVO.setEmpId(empId);
				
				ntcnUtil.sendAdmin(cmmntyVO.getEmpId() , "ALL_MBER", NtcnType.FCLTY
						, "현재 " + cmmntyVO.getCmmntyNm() +"가<br>" + "점검 완료되었습니다."
						, "/main");
			}
		}
		
		return result;
	}

	//상태 값 변경 전 db값 조회
	@Override
	public CmmntyVO detail(int cmmntySn) {
		return this.cmmntymapper.detail(cmmntySn);
	}

	//담당자 정보 조회
	@Override
	public List<EmpVO> empList() {
		return this.cmmntymapper.empList();
	}

}
