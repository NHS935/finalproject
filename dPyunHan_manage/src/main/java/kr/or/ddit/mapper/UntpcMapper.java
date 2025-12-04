package kr.or.ddit.mapper;

import kr.or.ddit.vo.UntpcVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface UntpcMapper {
    UntpcVO detail(UntpcVO untpcVO);

    List<UntpcVO> getActiveRates();
}
