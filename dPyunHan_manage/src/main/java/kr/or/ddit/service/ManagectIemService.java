package kr.or.ddit.service;

import kr.or.ddit.vo.ManagectIemVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface ManagectIemService {
    List<ManagectIemVO> findFeesByMonth(String billingMonth);

    int upload(MultipartFile file) throws Exception;
}
