package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.BdderVO;
import kr.or.ddit.vo.BidPblancVO;
import kr.or.ddit.vo.FileDetailVO;

@Mapper
public interface BidPblancMapper {

	int postBidPblanc(BidPblancVO bidPblancVO);

	int getTotal(Map<String, Object> map);

	List<BidPblancVO> getBidPblancList(Map<String, Object> map);

	BidPblancVO getBidPblancVO(BidPblancVO bidPblancVO);

	List<FileDetailVO> getFileDetailVOList(Long fileGroupSn);

	FileDetailVO getFileDetail(Map<String, Object> map);

	//정문페이지에 글3개 가져오기(나혜선)
	List<BidPblancVO> maingateget(Map<String, Object> map);

	List<BidPblancVO> getBidPblancListAsEmp(Map<String, Object> map);
	
	int putBidPblanc(BidPblancVO bidPblancVO);

	List<BdderVO> getBdderList(BidPblancVO bidPblancVO);

}
