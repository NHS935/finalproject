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
	
	public NoticeVO findById(int noticeSn);

	public List<FileDetailVO> getFileDetailVOList(long fileGroupSn);

	public List<NoticeVO> findAll();
}
