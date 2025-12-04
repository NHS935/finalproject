package kr.or.ddit.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.enums.NtcnType;
import kr.or.ddit.mapper.FileMapper;
import kr.or.ddit.mapper.MberMapper;
import kr.or.ddit.service.MberService;
import kr.or.ddit.util.NtcnUtil;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.FileGroupVO;
import kr.or.ddit.vo.MberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Transactional
@Service
public class MberServiceImpl implements MberService {

	@Autowired
	private MberMapper mberMapper;

	@Autowired
	private FileMapper fileMapper;

	@Autowired
	NtcnUtil ntcnUtil;

	@Override
	public String selectHouseholdIdByMember(String mberId) {
		return mberMapper.selectHouseholdIdByMember(mberId);
	}

	@Override
	public MberVO findByMberId(String mberId) {
		return mberMapper.findByMberId(mberId);
	}

	@Transactional(rollbackFor = Exception.class)
	@Override
	public void insertMember(MberVO mberVO) {
		// 1. 회원 등록
		mberMapper.insertMember(mberVO);
		
		// 2. 웹소켓 전송
		ntcnUtil.sendAdmin(mberVO.getMberId(), "ALL_EMP", NtcnType.SIGN, 
				mberVO.getMberNm() + "님이 " + mberVO.getAptcmpl() + "동 " + mberVO.getHo() + "호 의 세대로 <br>회원가입을 신청하였습니다." ,
				"/mber/detail?mberId=" + mberVO.getMberId());
		
		
		
	}

	@Override
	public void insertMemberAuthor(MberVO mberVO) {
		mberMapper.insertMemberAuthor(mberVO);
	}

	@Override
	public boolean checkHousehold(int aptcmpl, int ho, int residesttus) {
		Integer count = mberMapper.countHousehold(aptcmpl, ho, residesttus);
		return count != null && count > 0;
	}

	@Override
	public boolean checkAlreadyRegistered(int aptcmpl, int ho, int residesttus) {
		Integer count = mberMapper.countRegistered(aptcmpl, ho, residesttus);
		return count != null && count > 0;
	}

	@Override
	public void insertHouseholdMember(MberVO mberVO) {
		mberMapper.insertHouseholdMember(mberVO);
	}

	/** FILE_GROUP 등록 */
	@Override
	public long insertFileGroup(FileGroupVO fileGroupVO) {
		fileMapper.insertFileGroup(fileGroupVO);
		return fileGroupVO.getFileGroupSn();
	}

	/** FILE_DETAIL 등록 */
	@Override
	public void insertFileDetail(FileDetailVO fileDetailVO) {
		fileMapper.insertFileDetail(fileDetailVO);
	}

	@Override
	public void insertVehicleRegist(MberVO mberVO) {
		if (mberVO.getVhcleNo() != null && !mberVO.getVhcleNo().isEmpty()) {
			mberMapper.insertVehicleRegist(mberVO);
		}
	}


	@Override
	public void updateMember(MberVO mberVO) {
	    mberMapper.updateMember(mberVO);
		
	}
}
