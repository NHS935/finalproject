package kr.or.ddit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.HshldVO;
import kr.or.ddit.vo.MberVO;

@Mapper
public interface HshldMapper {

	int updateHshld(HshldVO hshldVO);
}
