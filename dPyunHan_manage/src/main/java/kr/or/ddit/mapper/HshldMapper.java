package kr.or.ddit.mapper;

import kr.or.ddit.vo.HshldVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface HshldMapper {

    List<HshldVO> findActiveResidents();

    List<String> getAllHouseholdIds();
}
