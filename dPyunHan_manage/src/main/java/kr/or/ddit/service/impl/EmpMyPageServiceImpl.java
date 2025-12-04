package kr.or.ddit.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.mapper.EmpMyPageMapper;
import kr.or.ddit.mapper.SignMapper;
import kr.or.ddit.service.EmpMyPageService;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.SignVO;
import lombok.extern.slf4j.Slf4j;
@Slf4j
@Service
public class EmpMyPageServiceImpl implements EmpMyPageService {
	@Autowired
	EmpMyPageMapper empMyPageMapper;
	@Autowired
	SignMapper signMapper; 
	

	//emp+file+filedetail+auth
	@Override
	public EmpVO selectEmpDetailById(String empId) {
		return this.empMyPageMapper.selectEmpDetailById(empId);
	}
	
	
	@Autowired
	UploadController uploadController;
	
	   @Override
	   public int empEdit(EmpVO empVO ) {
	      
	      MultipartFile[] uploadFiles = empVO.getUploadFiles();
	        if (uploadFiles != null && uploadFiles[0].getOriginalFilename().length() > 0) {
	            long fileGroupSn = uploadController.multiImageUpload(uploadFiles);
	            empVO.setFileGroupSn(fileGroupSn);
	        }
	        int result = this.empMyPageMapper.empEdit(empVO);
	        log.info("empEdit -> result :{}" , result);
	        
	      return result;
	   }
	   

}
