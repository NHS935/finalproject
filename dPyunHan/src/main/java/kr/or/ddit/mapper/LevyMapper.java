package kr.or.ddit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.LevyVO;

@Mapper
public interface LevyMapper {
	
	// 세대 월별 관리비 조회
	List<LevyVO> selectMonthlyRqestByHouse(String hshldId, String yearMonth);

	 void updatePayStatus(String paySn, int rqestSn);

	String selectHouseholdIdByMember(String mberId);
    
}
