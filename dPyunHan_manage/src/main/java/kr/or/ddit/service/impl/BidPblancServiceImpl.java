package kr.or.ddit.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.BidPblancMapper;
import kr.or.ddit.service.BidPblancService;
import kr.or.ddit.vo.BdderVO;
import kr.or.ddit.vo.BidPblancVO;
import kr.or.ddit.vo.FileDetailVO;

@Service
public class BidPblancServiceImpl implements BidPblancService {
	
	@Autowired
	BidPblancMapper bidPblancMapper;

 	
	@Override
	public int postBidPblanc(BidPblancVO bidPblancVO) {
		
		return this.bidPblancMapper.postBidPblanc(bidPblancVO);
	}

	@Override
	public List<BidPblancVO> getBidPblancList(Map<String, Object> map) {
		
		return this.bidPblancMapper.getBidPblancList(map);
	}

	@Override
	public int getTotal(Map<String, Object> map) {
		
		return this.bidPblancMapper.getTotal(map);
	}

	@Override
	public BidPblancVO getBidPblancVO(BidPblancVO bidPblancVO) {
		
		return this.bidPblancMapper.getBidPblancVO(bidPblancVO);
	}

	@Override
	public List<FileDetailVO> getFileDetailVOList(Long fileGroupSn) {
		
		return this.bidPblancMapper.getFileDetailVOList(fileGroupSn);
	}

	@Override
	public FileDetailVO getFileDetail(long fileGroupSn, int fileNo) {
		
		Map<String, Object> map = new HashMap<>();
		map.put("fileGroupSn", fileGroupSn);
		map.put("fileNo", fileNo);
		
		return this.bidPblancMapper.getFileDetail(map);
	}

	//정문페이지에 글3개 가져오기(나혜선)
	@Override
	public List<BidPblancVO> maingateget(Map<String, Object> map) {
		return this.bidPblancMapper.maingateget(map);
	}

	@Override
	public List<BidPblancVO> getBidPblancListAsEmp(Map<String, Object> map) {
		List<BidPblancVO> bidPblancVOList = this.bidPblancMapper.getBidPblancListAsEmp(map);  
		
		for(BidPblancVO bidPblancVO : bidPblancVOList) {
			List<BdderVO> bdderVOs = this.bidPblancMapper.getBdderList(bidPblancVO);
			bidPblancVO.setBdderVOList(bdderVOs);
		}
		
		return bidPblancVOList;
	}

	@Override
	public int putBidPblanc(BidPblancVO bidPblancVO) {		
		return this.bidPblancMapper.putBidPblanc(bidPblancVO);
	}
	
}
