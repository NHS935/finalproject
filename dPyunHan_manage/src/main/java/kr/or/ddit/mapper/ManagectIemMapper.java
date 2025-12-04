package kr.or.ddit.mapper;

import kr.or.ddit.vo.ManagectIemVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ManagectIemMapper {
    List<ManagectIemVO> findFeesByMonth(String billingMonth);

    int upload(List<ManagectIemVO> list);

    int getMaxId();

}
