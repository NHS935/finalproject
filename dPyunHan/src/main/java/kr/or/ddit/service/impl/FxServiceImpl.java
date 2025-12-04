package kr.or.ddit.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.FxMapper;
import kr.or.ddit.service.FxService;
import kr.or.ddit.vo.FxVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FxServiceImpl implements FxService {

	@Autowired
	FxMapper fxMapper;
	
	//일정 조회
	@Override
	public List<FxVO> listAjax() {

		return this.fxMapper.listAjax();
	}

}
