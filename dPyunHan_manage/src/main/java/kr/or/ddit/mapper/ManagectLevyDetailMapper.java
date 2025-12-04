package kr.or.ddit.mapper;

import kr.or.ddit.vo.ManagectLevyDetailVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ManagectLevyDetailMapper {
    List<Long> getNextManagectLevyDetailPKs(int detailPKsNeeded);

    void insertDetailsBatch(List<ManagectLevyDetailVO> detailsToInsert);

    List<ManagectLevyDetailVO> findByBillingMonth(String billingMonth);
}
