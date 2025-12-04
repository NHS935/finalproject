package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.BdderMapper;
import kr.or.ddit.service.BdderService;
import kr.or.ddit.vo.BdderVO;
import kr.or.ddit.vo.FileDetailVO;

@Service
public class BdderSerivceImpl implements BdderService {

	@Autowired
	BdderMapper bdderMapper;

	@Override
	public int postBdder(BdderVO bdderVO) {
		
		return this.bdderMapper.postBdder(bdderVO);
	}

	@Override
	public List<BdderVO> getMyBdderList(Map<String, Object> map) {
		
		return this.bdderMapper.getMyBdderList(map);
	}

	@Override
	public int getTotal(Map<String, Object> map) {
		
		return this.bdderMapper.getTotal(map);
	}

	@Override
	public List<FileDetailVO> getFileDetailVOList(long fileGroupSn) {
		
		return this.bdderMapper.getFileDetailVOList(fileGroupSn);
	}


	@Override
	public BdderVO getExistingBid(int ccpyManageId, int bidPblancSn) {
		BdderVO bdderVO = new BdderVO();
		bdderVO.setBidPblancSn(bidPblancSn);
		bdderVO.setCcpyManageId(ccpyManageId);
		
		return this.bdderMapper.getExistingBid(bdderVO);
	}

	@Override
	public List<BdderVO> getBdderList(Map<String, Object> map) {
		
		return this.bdderMapper.getBdderList(map);
	}

	@Override
	public BdderVO getBdder(BdderVO bdderVO) {
		
		return this.bdderMapper.getBdder(bdderVO);
	}

	@Override
	public int putBdder(BdderVO bdderVO) {
		
		return this.bdderMapper.putBdder(bdderVO);
	}

	
	
}
