package kr.or.ddit.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.ManagectLevyDetailMapper;
import kr.or.ddit.service.ManagectLevyDetailService;
import kr.or.ddit.vo.ManagectLevyDetailVO;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ManagectLevyDetailServiceImpl implements ManagectLevyDetailService {

	private final ManagectLevyDetailMapper managectLevyDetailMapper;
	
	@Override
	public List<ManagectLevyDetailVO> getDetailsByRqestSn(String rqestSn) {
		 return managectLevyDetailMapper.selectDetailByRqestSn(rqestSn);	
	}

	@Override
	public ManagectLevyDetailVO getDetailBySn(long detailSn) {
        return managectLevyDetailMapper.selectDetailBySn(detailSn);
	}

	
}
