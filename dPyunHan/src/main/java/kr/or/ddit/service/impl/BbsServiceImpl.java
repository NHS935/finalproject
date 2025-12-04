package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mapper.AnswerMapper;
import kr.or.ddit.mapper.BbsMapper;
import kr.or.ddit.service.BbsService;
import kr.or.ddit.vo.BbsDetailVO;
import kr.or.ddit.vo.BbsGroupVO;
import kr.or.ddit.vo.FileDetailVO;

@Service
public class BbsServiceImpl implements BbsService {
	
	@Autowired
	BbsMapper bbsMapper;
	
	@Autowired
	AnswerMapper answerMapper;

	@Override
	public int postBbsGroup(BbsGroupVO bbsGroupVO) {
		return this.bbsMapper.postBbsGroup(bbsGroupVO);
	}

	@Override
	public List<Map<String, Object>> bbsGroupList() {
		return this.bbsMapper.bbsGroupList();
	}

	@Override
	public int register(BbsDetailVO bbsDetailVO) {
		return this.bbsMapper.register(bbsDetailVO);
	}

	@Override
	public BbsGroupVO bbsGroup(long bbsGroupSn) {
		return this.bbsMapper.bbsGroup(bbsGroupSn);
	}

    @Override
    public List<BbsDetailVO> bbsList(Map<String, Object> map) {
        return this.bbsMapper.bbsList(map);
    }

	@Override
	public BbsDetailVO bbsDetail(long sn) {
		return this.bbsMapper.bbsDetail(sn);
	}

	@Override
	public int updateBbs(BbsDetailVO bbsDetailVO) {
		return this.bbsMapper.updateBbs(bbsDetailVO);
	}

	@Override
	public int deleteBbs(long bbsDetailNo) {
		
		// 게시글 삭제 전에 댓글 먼저 삭제(위결성 제약 해소)
	    this.answerMapper.deleteAnswersByBbsDelte(bbsDetailNo);
	    
		return this.bbsMapper.deleteBbs(bbsDetailNo);
	}

	@Override
	public int getTotal(Map<String, Object> map) {
		return this.bbsMapper.getTotal(map);
	}

	@Override
	public List<FileDetailVO> getFileList(long fileGroupSn) {
		return this.bbsMapper.getFileList(fileGroupSn);
	}

	@Transactional
	@Override
	public int deleteBbsGroup(long bbsGroupSn) {
	    // 1. 해당 게시판의 모든 댓글 먼저 삭제
	    this.answerMapper.deleteAnswersByBbsGroup(bbsGroupSn);
	    
	    // 2. 해당 게시판의 게시글 삭제
	    this.bbsMapper.deleteBbsDetail(bbsGroupSn);

	    // 3. 게시판 삭제
	    return this.bbsMapper.deleteBbsGroup(bbsGroupSn);
	}

}
