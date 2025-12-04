package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.NoticeVO;

public interface NoticeService {

	public List<NoticeVO> list(Map<String, Object> map);

	public int getTotal(Map<String, Object> map);
	
	public NoticeVO findById(int noticeSn);

	public List<FileDetailVO> getFileDetailVOList(long fileGroupSn);

	public List<NoticeVO> findAll();
}
