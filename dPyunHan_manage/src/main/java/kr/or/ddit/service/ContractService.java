package kr.or.ddit.service;

import kr.or.ddit.vo.ContractVO;

import java.util.List;
import java.util.Map;

public interface ContractService {
    ContractVO getContract(Long id);
    void saveContract(Long id,ContractVO contractVO);
    ContractVO postContract(ContractVO contractVO);

    int getTotal(Map<String, Object> map);

    List<ContractVO> getContractList(Map<String, Object> map);

    String sendSigningRequest(long fileGroupSn, int fileNo, String toEmail, String ccpyCmpnyNm);
}
