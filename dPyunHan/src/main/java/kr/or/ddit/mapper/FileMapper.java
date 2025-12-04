package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.FileGroupVO;

@Mapper
public interface FileMapper {

	int insertFileGroup(FileGroupVO fileGroupVO);

	int insertFileDetail(FileDetailVO fileDetailVO);

	List<FileDetailVO> getFileDetailVOList(Long fileGroupSn);

	FileDetailVO getFileDetail(Map<String, Object> map);
}
