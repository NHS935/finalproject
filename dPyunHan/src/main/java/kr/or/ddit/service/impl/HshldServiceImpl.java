package kr.or.ddit.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.HshldMapper;
import kr.or.ddit.service.HshldService;
import kr.or.ddit.vo.HshldVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class HshldServiceImpl implements HshldService {
	
	@Autowired
	HshldMapper hshldMapper; 
	

	@Override
	public int updateHshId(HshldVO hshldVO) {
		  return hshldMapper.updateHshld(hshldVO);
	}
	
}
