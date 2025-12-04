package kr.or.ddit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.ManagectLevyDetailVO;

	@Mapper
	public interface ManagectLevyDetailMapper {

		// 청구서의 모든 상세항목 조회
		List<ManagectLevyDetailVO> selectDetailByRqestSn(String rqestSn);

		// 상세항목 1건 조회
		ManagectLevyDetailVO selectDetailBySn(long detailSn);


}
