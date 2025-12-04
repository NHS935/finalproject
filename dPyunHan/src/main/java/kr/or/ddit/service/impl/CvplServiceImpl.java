package kr.or.ddit.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.enums.NtcnTargetType;
import kr.or.ddit.enums.NtcnType;
import kr.or.ddit.mapper.CvplMapper;
import kr.or.ddit.service.CvplService;
import kr.or.ddit.service.NtcnService;
import kr.or.ddit.util.NtcnUtil;
import kr.or.ddit.vo.CvplVO;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.FileDetailVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CvplServiceImpl implements CvplService {

	@Autowired
	CvplMapper cvplMapper;
	
	@Autowired
	
	NtcnService ntcnService;
	
	@Autowired
	NtcnUtil ntcnUtil;
	
	@Override
	public List<CvplVO> list(Map<String, Object> map) {
	
		return this.cvplMapper.list(map);
	}

	@Override
	public int getTotal(Map<String, Object> map) {
		
		return this.cvplMapper.getTotal(map);
	}

	@Override
	public CvplVO findById(int cvplSn) {
		CvplVO cvplVO = this.cvplMapper.findById(cvplSn);
		 if (cvplVO != null && cvplVO.getCvplRceptVO() != null) {
		        String cn = cvplVO.getCvplRceptVO().getRceptCn();
		        if (cn != null) {
		        	cn = cn.replaceAll("</?p[^>]*>", "");
		        	cvplVO.getCvplRceptVO().setRceptCn(cn);
		        }
		    }
		
		return cvplVO;
	}

	@Transactional
	@Override
	public int register(CvplVO cvplVO) {
		//민원 등록
		int result = this.cvplMapper.register(cvplVO);
		//민원 관리 등록
//		this.cvplMapper.registerManage(cvplVO);
		
								//발신자						//수신자					//알림 타입					//알림 제목
		ntcnUtil.sendAdmin(cvplVO.getMberId(), String.valueOf(cvplVO.getDeptCode()), NtcnType.CVPL, "새 민원이 접수되었습니다. <br>" + cvplVO.getCvplSj()
							,"/cvplRcept/ntcn/go?cvplSn=" + cvplVO.getCvplSn());
											//알림 URL
		return result;
	}

	@Override
	public List<DeptVO> deptVOList() {

		return this.cvplMapper.deptVOList();
	}

	@Override
	public List<FileDetailVO> getFileDetailVOList(long fileGroupSn) {
		return this.cvplMapper.getFileDetailVOList(fileGroupSn);
	}

	@Override
	public int update(CvplVO cvplVO) {
		
		return this.cvplMapper.update(cvplVO);
	}

	@Override
	public List<CvplVO> findByMberId(String mberId) {
		
		return this.cvplMapper.findByMberId(mberId);
	}

}
