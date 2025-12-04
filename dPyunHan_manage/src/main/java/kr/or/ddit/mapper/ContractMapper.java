package kr.or.ddit.mapper;

import kr.or.ddit.vo.ContractVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface ContractMapper {
    ContractVO getContractById(Long id);
    void updateContract(ContractVO contractVO);

    int postContract(ContractVO form);

    int getTotal(Map<String, Object> map);

    List<ContractVO> getContractList(Map<String, Object> map);
}
