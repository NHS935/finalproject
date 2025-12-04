package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.CcpyDtaVO;
import kr.or.ddit.vo.CcpyManageVO;

public interface CcpyManageService {

	int postCcpyManageVO(CcpyManageVO ccpyManageVO, CcpyDtaVO ccpyDtaVO);

	List<CcpyManageVO> getCcpyManageGuestList(Map<String, Object> map);

	int getTotal(Map<String, Object> map);

	CcpyManageVO getCcpyManage(CcpyManageVO ccpyManageVO);

	CcpyDtaVO getCcpyDta(CcpyManageVO ccpyManageVO);
	
	int putCcpyAuthor(CcpyManageVO ccpyManageVO);

	int putCcpySttsAsRej(CcpyManageVO ccpyManageVO);

	List<CcpyManageVO> getCcpyManageList(Map<String, Object> map);
}
