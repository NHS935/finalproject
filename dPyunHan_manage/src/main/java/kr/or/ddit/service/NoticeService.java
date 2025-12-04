package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.NoticeVO;

public interface NoticeService {

	public List<NoticeVO> list(Map<String, Object> map);

	public int getTotal(Map<String, Object> map);

	public int register(NoticeVO noticeVO);

	public NoticeVO findById(int noticeSn);

	public void edit(NoticeVO noticeVO);

	public void delete(int noticeSn);

	public List<FileDetailVO> getFileDetailVOList(long fileGroupSn);

	//정문페이지에 글3개 셀렉해오기(나혜선)
	public List<NoticeVO> maingateselect(Map<String, Object> map);

	public List<NoticeVO> wnmpyNoticeList(Map<String, Object> map);

	public List<NoticeVO> findAll();

}
