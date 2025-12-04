package kr.or.ddit.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.or.ddit.service.ManagectLevyDetailService;
import kr.or.ddit.vo.ManagectLevyDetailVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController  // @Controller + @ResponseBody
@RequiredArgsConstructor
public class ManagectLevyDetailController {

    private final ManagectLevyDetailService managectLevyDetailService;

    @GetMapping("/rqest/detail")
    public List<ManagectLevyDetailVO> getDetailList(@RequestParam("rqestSn") String rqestSn) {
        List<ManagectLevyDetailVO> detailList = managectLevyDetailService.getDetailsByRqestSn(rqestSn);
        log.info("detailList for rqestSn {} : {}", rqestSn, detailList);
        return detailList; // JSON으로 반환
    }
}
