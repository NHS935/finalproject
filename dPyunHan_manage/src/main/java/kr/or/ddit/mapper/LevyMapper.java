package kr.or.ddit.mapper;

import kr.or.ddit.vo.LevyVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface LevyMapper {
    List<Long> getNextLevyPKs(int billPKsNeeded);

    void insertBillsBatch(List<LevyVO> billsToInsert);

    List<LevyVO> findByBillingMonth(String billingMonth);

    LevyVO findByHshldId(@Param("billingMonth")String billingMonth, @Param("hshldId")String number);
}
