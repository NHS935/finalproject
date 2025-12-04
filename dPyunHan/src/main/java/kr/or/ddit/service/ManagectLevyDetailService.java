package kr.or.ddit.service;

import java.util.List;

import org.springframework.stereotype.Service;

import kr.or.ddit.vo.ManagectLevyDetailVO;

@Service
public interface ManagectLevyDetailService {

	// 청구서의 모든 상세항목 조회
	List<ManagectLevyDetailVO> getDetailsByRqestSn(String rqestSn);
	
	// 상세항목 1건 조회
	ManagectLevyDetailVO getDetailBySn(long detailSn);

} 