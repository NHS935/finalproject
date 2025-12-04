package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.NtcnVO;

public interface NtcnService {

	int insertNtcn(NtcnVO ntcnVO);
	
	List<NtcnVO> getUnreadList(String userId);
	
	int updateRedngAt(int ntcnSn);
}
