package kr.or.ddit.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.service.EmpService;
import kr.or.ddit.vo.EmpVO;
@Transactional
@Service
public class EmpServiceImpl implements EmpService{
@Autowired
EmpMapper empMapper;
	@Override
	public List<EmpVO> getEmpList() {
		return this.empMapper.getEmpList();
	}

}
