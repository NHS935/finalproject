package kr.or.ddit.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.CcpyManageMapper;
import kr.or.ddit.mapper.EmpMapper;
import kr.or.ddit.vo.CcpyManageVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.TesterVO;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Service
public class UserDetailServiceImpl implements UserDetailsService {

	@Autowired 
	CcpyManageMapper ccpyManageMapper;
	
    @Autowired
    EmpMapper empMapper;
    
    @Override
    public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException{
        
    	EmpVO empVO = this.empMapper.findByEmpId(userName);     
	    if(empVO != null){
	    	return new CustomUser(empVO);
	    }
	    
        CcpyManageVO ccpyManageVO = this.ccpyManageMapper.findByCcpyEmail(userName);
        if(ccpyManageVO != null) {
        	return new CustomUser(ccpyManageVO);
        }
    	
    	throw new UsernameNotFoundException("사용자 정보 없음: " + userName);
    }

    
    // 회귀분석 테스터용, 테스트 후 삭제 예정
	public List<TesterVO> getTesterList(EmpVO empVO) {
		
		return this.empMapper.getTesterList(empVO);
	}

    
}
