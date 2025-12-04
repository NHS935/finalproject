package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.BbsDetailVO;
import kr.or.ddit.vo.BbsGroupVO;
import kr.or.ddit.vo.FileDetailVO;

@Mapper
public interface BbsMapper {

	public int postBbsGroup(BbsGroupVO bbsGroupVO);

	public List<Map<String, Object>> bbsGroupList();

	public int register(BbsDetailVO bbsDetailVO);

	public BbsGroupVO bbsGroup(long bbsGroupSn);

	public List<BbsDetailVO> bbsList(Map<String, Object> map);

	public BbsDetailVO bbsDetail(long sn);

	public int updateBbs(BbsDetailVO bbsDetailVO);

	public int deleteBbs(long bbsDetailNo);

	public int getTotal(Map<String, Object> map);

	public List<FileDetailVO> getFileList(long fileGroupSn);

	public void deleteBbsDetail(long bbsGroupSn);
	
	public int deleteBbsGroup(long bbsGroupSn);



}
