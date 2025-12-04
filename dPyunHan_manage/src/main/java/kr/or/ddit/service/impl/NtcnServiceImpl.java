package kr.or.ddit.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.NtcnMapper;
import kr.or.ddit.service.NtcnService;
import kr.or.ddit.vo.NtcnVO;

@Service
public class NtcnServiceImpl implements NtcnService {

	@Autowired
    NtcnMapper ntcnMapper;

    @Override
    public int insertNtcn(NtcnVO ntcnVO) {
        return ntcnMapper.insertNtcn(ntcnVO);
    }

	@Override
	public List<NtcnVO> getUnreadList(String userId) {
		return this.ntcnMapper.getUnreadList(userId);	
	}
	
	@Override
	public int updateRedngAt(int ntcnSn) {
	    return ntcnMapper.updateRedngAt(ntcnSn);
	}
}