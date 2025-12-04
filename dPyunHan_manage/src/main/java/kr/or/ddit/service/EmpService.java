package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.vo.EmpVO;

public interface EmpService {
	//담당자 목록 불러오기(나혜선)
	public List<EmpVO> getEmpList();

}
