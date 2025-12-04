package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MberVO;

public interface MberService {
    // 세대 입주민 목록
    List<MberVO> getHshldList(Map<String, Object> map);
    // 페이징
    int getHshldTotal(Map<String, Object> map);

    // 세대 상세
    List<MberVO> getHshldDetail(String hshldId);
    
	// 회원숫자count
    public int getMemNum();

	List<FileDetailVO> getFileListByGroupSn(Long fileGroupSn);
	MberVO findByMberId(String mberId);
    
}
