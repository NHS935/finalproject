package kr.or.ddit.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mapper.SignMapper;
import kr.or.ddit.service.SignService;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.vo.SignVO;
import lombok.extern.slf4j.Slf4j;
@Service
@Slf4j
public class SignServiceImpl implements SignService {


	
	@Autowired
	SignMapper signMapper;

	@Override
	// selectSign empId를 기준으로 sign사진을 찾기
	public SignVO selectSign(String empId) {
		return this.signMapper.selectSign(empId);
	}

	@Autowired
	UploadController uploadController;
	
	@Transactional
    @Override
    public long upsertSignAndUpload(SignVO signVO) {
        final String empId = signVO.getEmpId();
        if (empId == null || empId.isBlank()) {
            throw new IllegalArgumentException("empId가 없습니다.");
        }

        // 파일 업로드 (있을 때만)
        MultipartFile[] uploadFiles = signVO.getUploadFiles();
        Long fileGroupSn = signVO.getFileGroupSn(); // 
        if ((fileGroupSn == null || fileGroupSn == 0L) &&
            uploadFiles != null && uploadFiles.length > 0) {
            long uploadedGroupSn = uploadController.multiImageUpload(uploadFiles);
            signVO.setFileGroupSn(uploadedGroupSn);
            fileGroupSn = uploadedGroupSn;
        }
        if (fileGroupSn == null) fileGroupSn = 0L; 

        SignVO signVO2 = signMapper.findByEmpIdForUpdate(empId);

        long signId;
        if (signVO2 == null) {
            SignVO toInsert = new SignVO();
            toInsert.setEmpId(empId);
            toInsert.setFileGroupSn(fileGroupSn);
            int inserted = signMapper.insertSignWithSeq(toInsert);
            if (inserted != 1) {
                throw new IllegalStateException("SIGN 생성 실패");
            }
            signId = toInsert.getSignId();

        } else {
            signId = signVO2.getSignId();
            signMapper.updateFileGroupByEmpId(empId, fileGroupSn);
        }

        log.info("upsertSignAndUpload -> empId={}, signId={}, fileGroupSn={}", empId, signId, fileGroupSn);
        return signId;
    }

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

	
	
	
	
	
	
	
	
