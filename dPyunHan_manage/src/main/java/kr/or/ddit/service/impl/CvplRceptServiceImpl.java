package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.enums.NtcnType;
import kr.or.ddit.mapper.CvplRceptMapper;
import kr.or.ddit.service.CvplRceptService;
import kr.or.ddit.util.NtcnUtil;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.vo.CvplRceptVO;
import kr.or.ddit.vo.CvplVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CvplRceptServiceImpl implements CvplRceptService{
	
	@Autowired
	CvplRceptMapper cvplRceptMapper;
	
	@Autowired
	UploadController uploadController;
	
	@Autowired
	NtcnUtil ntcnUtil;
	 
	//해당 부서의 민원 리스트
	@Override
	public List<CvplVO> list(Map<String, Object> map) {
		return this.cvplRceptMapper.list(map);
	}
	
	//페이지네이션
	@Override
	public int getTotal(Map<String, Object> map) {
		return  this.cvplRceptMapper.getTotal(map);
	}
		

	//해당 민원의 상세
	@Override
	public CvplVO detail(CvplVO cvplVO) {
		return this.cvplRceptMapper.detail(cvplVO);
	}
	@Override
	public CvplRceptVO cvplRceptDetail(int cvplSn) {
		return this.cvplRceptMapper.cvplRceptDetail(cvplSn);
	}

	//해당 민원 접수 실행
	@Transactional
	@Override
	public int cvplRceptPost(CvplRceptVO cvplRceptVO) {
		
		MultipartFile[] uploadFiles = cvplRceptVO.getUploadFiles();
		if(uploadFiles != null) {
			if(uploadFiles[0].getOriginalFilename().length() > 0) {
				long fileGroupSn = this.uploadController.multiImageUpload(cvplRceptVO.getUploadFiles());
				
				cvplRceptVO.setFileGroupSn(fileGroupSn);
			}
		}
		
        int result = this.cvplRceptMapper.cvplRceptPost(cvplRceptVO);
        
        if (result > 0) {
        	cvplRceptMapper.insertCvplManage(cvplRceptVO);
			
			//cvplVO 조회(수신자, 알림 제목)
			CvplVO cvplVO = this.cvplRceptMapper.selectMberIdCvplSj(cvplRceptVO.getCvplSn());
			
									//발신자					//수신자			//알림 타입					//알림 제목
			ntcnUtil.sendAdmin(cvplRceptVO.getEmpId() , cvplVO.getMberId(), NtcnType.CVPL, "신청하신 \"" + cvplVO.getCvplSj() + "\" <br>민원이 접수되었습니다."
								, "/cvpl/ntcn/go?cvplSn=" + cvplRceptVO.getCvplSn());
												//알림 URL
        }
        
		return result;
	}
	
	// 해당 민원 종결 실행
	@Transactional
	@Override
	public int cvplEnPost(CvplRceptVO cvplRceptVO) {
		
		int result = this.cvplRceptMapper.cvplEnPost(cvplRceptVO);
		
		if (result > 0) {
			//cvplVO 조회(수신자, 알림 제목)
	        CvplVO cvplVO = this.cvplRceptMapper.selectMberIdCvplSj(cvplRceptVO.getCvplSn());
	        
	        							//발신자					//수신자			//알림 타입					//알림 제목
	        ntcnUtil.sendAdmin(cvplRceptVO.getEmpId() , cvplVO.getMberId(), NtcnType.CVPL, "신청하신 \"" + cvplVO.getCvplSj() + "\" <br>민원이 종결되었습니다."
	        					, "/cvpl/ntcn/go?cvplSn=" + cvplRceptVO.getCvplSn());
	        									//알림 URL
		}
		
		return result;
	}
	// kbh추가 처리할 민원 숫자 
	@Override
	public int getCvplRceptNum() {
		return this.cvplRceptMapper.getCvplRceptNum();
	}

	
	
}
