package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.NoticeVO;

@Mapper
public interface NoticeMapper {

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
