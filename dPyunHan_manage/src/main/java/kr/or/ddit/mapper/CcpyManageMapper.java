package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.BizcndIndutyVO;
import kr.or.ddit.vo.CcpyAuthorVO;
import kr.or.ddit.vo.CcpyDtaVO;
import kr.or.ddit.vo.CcpyManageVO;

@Mapper
public interface CcpyManageMapper {

	int postCcpyManageVO(CcpyManageVO ccpyManageVO);

	int postbizcndIndutyVO(BizcndIndutyVO bizcndIndutyVO);

	int postCcpyAuthor(CcpyAuthorVO ccpyAuthorVO);	

	List<CcpyManageVO> getCcpyManageGuestList(Map<String, Object> map);

	int getTotal(Map<String, Object> map);

	CcpyManageVO getCcpyManage(CcpyManageVO ccpyManageVO);

	int postCcpyDta(CcpyDtaVO ccpyDtaVO);

	CcpyDtaVO getCcpyDta(CcpyManageVO ccpyManageVO);
	
	int putCcpyAuthor(CcpyManageVO ccpyManageVO);

	CcpyManageVO findByCcpyEmail(String ccpyEmail);

	int putCcpySttsAsRej(CcpyManageVO ccpyManageVO);

	void putCcpySttsAsAcpt(CcpyManageVO ccpyManageVO);

	List<CcpyManageVO> getCcpyManageList(Map<String, Object> map);
}


