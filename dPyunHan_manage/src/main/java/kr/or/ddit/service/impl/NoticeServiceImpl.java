package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.enums.NtcnType;
import kr.or.ddit.mapper.NoticeMapper;
import kr.or.ddit.service.NoticeService;
import kr.or.ddit.util.NtcnUtil;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.NoticeVO;

@Service
public class NoticeServiceImpl implements NoticeService {

    @Autowired
    NoticeMapper noticeMapper;
    
    @Autowired
    NtcnUtil ntcnUtil;
    
    @Override
    public List<NoticeVO> list(Map<String, Object> map) {
    
        return this.noticeMapper.list(map);
    }

    @Override
    public int getTotal(Map<String, Object> map) {
        
        return this.noticeMapper.getTotal(map);
    }

    @Transactional
    @Override
    public int register(NoticeVO noticeVO) {
    
        noticeVO.setNoticeCn(noticeVO.getNoticeCn().replaceAll("</?p[^>]*>", ""));
        int result = this.noticeMapper.register(noticeVO);
        
        if(noticeVO.getWnmpyNotice() == 0) {
            ntcnUtil.sendAdmin(noticeVO.getEmpId() , "ALL_MBER", NtcnType.NOTICE
                    , "공지사항이 등록되었습니다.<br>자세한 내용은 공지사항 탭에서 확인하세요."
                    , "/main");
        }else {
            ntcnUtil.sendUser(noticeVO.getEmpId() , "ALL_EMP", NtcnType.NOTICE
                    , "공지사항이 등록되었습니다.<br>자세한 내용은 공지사항 탭에서 확인하세요."
                    , "/main");
        }
        
        return result;
    }

    @Override
    public NoticeVO findById(int noticeSn) {
        
        return this.noticeMapper.findById(noticeSn);
    }

    @Override
    public void edit(NoticeVO noticeVO) {
        
        this.noticeMapper.edit(noticeVO);
    }

    @Override
    public void delete(int noticeSn) {
        
        this.noticeMapper.delete(noticeSn);
        
    }

    @Override
    public List<FileDetailVO> getFileDetailVOList(long fileGroupSn) {
        
        return this.noticeMapper.getFileDetailVOList(fileGroupSn);
    }

    //정문페이지에 글3개 셀렉해오기(나혜선)
    @Override
    public List<NoticeVO> maingateselect(Map<String, Object> map) {
        return this.noticeMapper.maingateselect(map);
    }

    @Override
    public List<NoticeVO> wnmpyNoticeList(Map<String, Object> map) {
        
        return this.noticeMapper.wnmpyNoticeList(map);
    }

    @Override
    public List<NoticeVO> findAll() {
        
        return this.noticeMapper.findAll();
    }

    
}
