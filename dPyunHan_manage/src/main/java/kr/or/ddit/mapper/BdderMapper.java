package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.BdderVO;
import kr.or.ddit.vo.FileDetailVO;

@Mapper
public interface BdderMapper {

	int postBdder(BdderVO bdderVO);
	
	List<BdderVO> getMyBdderList(Map<String, Object> map);

	int getTotal(Map<String, Object> map);

	List<FileDetailVO> getFileDetailVOList(long fileGroupSn);

	BdderVO getExistingBid(BdderVO bdderVO);

	List<BdderVO> getBdderList(Map<String, Object> map);

	BdderVO getBdder(BdderVO bdderVO);

	int putBdder(BdderVO bdderVO);

}
