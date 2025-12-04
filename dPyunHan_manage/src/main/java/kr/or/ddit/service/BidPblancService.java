package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.BidPblancVO;
import kr.or.ddit.vo.FileDetailVO;

public interface BidPblancService {

	int postBidPblanc(BidPblancVO bidPblancVO);

	List<BidPblancVO> getBidPblancList(Map<String, Object> map);

	int getTotal(Map<String, Object> map);

	BidPblancVO getBidPblancVO(BidPblancVO bidPblancVO);

	List<FileDetailVO> getFileDetailVOList(Long fileGroupSn);

	FileDetailVO getFileDetail(long fileGroupSn, int fileNo);

	//정문페이지에 글3개 가져오기(나혜선)
	List<BidPblancVO> maingateget(Map<String, Object> map);

	List<BidPblancVO> getBidPblancListAsEmp(Map<String, Object> map);

	int putBidPblanc(BidPblancVO bidPblancVO);

}
