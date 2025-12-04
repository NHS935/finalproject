package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.NoticeMapper;
import kr.or.ddit.service.NoticeService;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.NoticeVO;

@Service
public class NoticeServiceImpl implements NoticeService {

	@Autowired
	NoticeMapper noticeMapper;
	
	@Override
	public List<NoticeVO> list(Map<String, Object> map) {
	
		return this.noticeMapper.list(map);
	}

	@Override
	public int getTotal(Map<String, Object> map) {
		
		return this.noticeMapper.getTotal(map);
	}


	@Override
	public NoticeVO findById(int noticeSn) {
		
		return this.noticeMapper.findById(noticeSn);
	}

	@Override
	public List<FileDetailVO> getFileDetailVOList(long fileGroupSn) {
	
		return this.noticeMapper.getFileDetailVOList(fileGroupSn);
	}

	@Override
	public List<NoticeVO> findAll() {
	
		return noticeMapper.findAll();
	}


}
