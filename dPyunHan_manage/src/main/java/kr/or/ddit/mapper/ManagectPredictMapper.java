package kr.or.ddit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.ManagectPredictVO;

@Mapper
public interface ManagectPredictMapper {

	//세대id 관리비 예측 조회
	public List<ManagectPredictVO> selectPredict(String hshldId);
}
