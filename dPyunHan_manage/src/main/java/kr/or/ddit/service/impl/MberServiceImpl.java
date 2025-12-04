package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mapper.FileMapper;
import kr.or.ddit.mapper.MberMapper;
import kr.or.ddit.service.MberService;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MberVO;
import lombok.extern.slf4j.Slf4j;
@Transactional
@Slf4j
@Service
public class MberServiceImpl implements MberService{
	@Autowired
	MberMapper mberMapper;
	@Autowired
	FileMapper fileMapper;
	
	//회원목록
	@Override
    public List<MberVO> getHshldList(Map<String, Object> map) {
        return this.mberMapper.getHshldList(map);
    }
	//회원목록 페이징
	@Override
	public int getHshldTotal(Map<String, Object> map) {
		return this.mberMapper.getHshldTotal(map);
	}
	//회원상세
    @Override
    public List<MberVO> getHshldDetail(String hshldId) {
        return mberMapper.getHshldDetail(hshldId);
    }
	@Override
	public int getMemNum() {
		return this.mberMapper.getMemNum();
	}
	@Override
	public List<FileDetailVO> getFileListByGroupSn(Long fileGroupSn) {
	    return fileMapper.selectFileList(fileGroupSn);
	}
	@Override
	public MberVO findByMberId(String mberId) {
		 return mberMapper.findByMberId(mberId);
	}
}
