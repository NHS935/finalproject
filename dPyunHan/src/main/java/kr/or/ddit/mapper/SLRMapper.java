package kr.or.ddit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.MtinspVO;

@Mapper
public interface SLRMapper {

    // 특정 연월(YYYYMM)의 관리비를 계산하고 tester테이블에 insert
    List<MtinspVO> selectDailyUsage(@Param("yyyymm") String yearMonth, @Param("hshldId") String hshldId);

}
