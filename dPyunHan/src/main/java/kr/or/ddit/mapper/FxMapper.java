package kr.or.ddit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.FxVO;

@Mapper
public interface FxMapper {

	//일정 조회
	public List<FxVO> listAjax();

}
