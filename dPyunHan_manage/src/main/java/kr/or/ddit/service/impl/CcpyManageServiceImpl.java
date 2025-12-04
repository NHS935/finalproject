package kr.or.ddit.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mapper.CcpyManageMapper;
import kr.or.ddit.service.CcpyManageService;
import kr.or.ddit.vo.BizcndIndutyVO;
import kr.or.ddit.vo.CcpyAuthorVO;
import kr.or.ddit.vo.CcpyDtaVO;
import kr.or.ddit.vo.CcpyManageVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CcpyManageServiceImpl implements CcpyManageService {

	@Autowired
	CcpyManageMapper ccpyManageMapper;

	@Override
	public int postCcpyManageVO(CcpyManageVO ccpyManageVO, CcpyDtaVO ccpyDtaVO) {		
		int result = this.ccpyManageMapper.postCcpyManageVO(ccpyManageVO);				
		log.info("check : result => {}", result);		
		//권한
		CcpyAuthorVO ccpyAuthorVO = new CcpyAuthorVO();
		ccpyAuthorVO.setCcpyManageId(ccpyManageVO.getCcpyManageId());
		
		result += this.ccpyManageMapper.postCcpyAuthor(ccpyAuthorVO);
		
		log.info("check : result => {}", result);		
		//업종, 업태
		for(BizcndIndutyVO bizcndIndutyVO: ccpyManageVO.getBizcndIndutyVOList()) {
			bizcndIndutyVO.setCcpyManageId(ccpyManageVO.getCcpyManageId());
			result+=this.ccpyManageMapper.postbizcndIndutyVO(bizcndIndutyVO);
		}
		log.info("check : result => {}", result);		
		//지원서류
		ccpyDtaVO.setCcpyManageId(ccpyManageVO.getCcpyManageId());
		result += this.ccpyManageMapper.postCcpyDta(ccpyDtaVO);
		return result;
	}

	@Override
	public List<CcpyManageVO> getCcpyManageGuestList(Map<String, Object> map) {
		List<CcpyManageVO> ccpyManageVOList =  this.ccpyManageMapper.getCcpyManageGuestList(map);		
		return ccpyManageVOList;
	}

	@Override
	public int getTotal(Map<String, Object> map) {
		return this.ccpyManageMapper.getTotal(map);
	}

	@Override
	public CcpyManageVO getCcpyManage(CcpyManageVO ccpyManageVO) {
		return this.ccpyManageMapper.getCcpyManage(ccpyManageVO);
	}

	@Override
	public CcpyDtaVO getCcpyDta(CcpyManageVO ccpyManageVO) {
		return this.ccpyManageMapper.getCcpyDta(ccpyManageVO);
	}

	@Transactional
	@Override
	public int putCcpyAuthor(CcpyManageVO ccpyManageVO) {
		this.ccpyManageMapper.putCcpySttsAsAcpt(ccpyManageVO);
		return this.ccpyManageMapper.putCcpyAuthor(ccpyManageVO);
	}

	@Override
	public int putCcpySttsAsRej(CcpyManageVO ccpyManageVO) {		
		return this.ccpyManageMapper.putCcpySttsAsRej(ccpyManageVO);
	}

	@Override
	public List<CcpyManageVO> getCcpyManageList(Map<String, Object> map) {
		List<CcpyManageVO> ccpyManageVOList =  this.ccpyManageMapper.getCcpyManageList(map);
		return ccpyManageVOList;
	}


}
