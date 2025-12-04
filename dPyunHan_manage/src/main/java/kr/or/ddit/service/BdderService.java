package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.BdderVO;
import kr.or.ddit.vo.BidPblancVO;
import kr.or.ddit.vo.FileDetailVO;

public interface BdderService {

	int postBdder(BdderVO bdderVO);

	List<BdderVO> getMyBdderList(Map<String, Object> map);

	int getTotal(Map<String, Object> map);

	List<FileDetailVO> getFileDetailVOList(long fileGroupSn);

	BdderVO getExistingBid(int ccpyManageId, int bidPblancSn);

	List<BdderVO> getBdderList(Map<String, Object> map);

	BdderVO getBdder(BdderVO bdderVO);

	int putBdder(BdderVO bdderVO);

}
