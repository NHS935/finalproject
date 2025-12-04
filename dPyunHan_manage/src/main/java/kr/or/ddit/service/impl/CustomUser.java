package kr.or.ddit.service.impl;

import java.util.Collection;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import kr.or.ddit.vo.CcpyManageVO;
import kr.or.ddit.vo.EmpVO;

public class CustomUser extends User {

	private EmpVO empVO;	
	private CcpyManageVO ccpyManageVO ;
	private String userType;
	
	public CustomUser(String username, String password, Collection<? extends GrantedAuthority> authorities) {
		super(username, password, authorities);
	}
	
	public CustomUser(EmpVO empVO) {
		super(empVO.getEmpId(), empVO.getEmpPassword()
				, empVO.getEmpAuthorVOList().stream()
				.map(auth->new SimpleGrantedAuthority(auth.getAuthorId()))
				.collect(Collectors.toList())
				);
		this.empVO=empVO;
		this.userType="EMP";
	}
	
	public CustomUser(CcpyManageVO ccpyManageVO) {
		super(ccpyManageVO.getCcpyEmail(), ccpyManageVO.getCcpyPassword()
				, ccpyManageVO.getCcpyAuthorVOList().stream()
				.map(auth->new SimpleGrantedAuthority(auth.getAuthorId()))
				.collect(Collectors.toList())
				);
		this.ccpyManageVO=ccpyManageVO;
		this.userType="CCPY";
	}
	
		
	public CcpyManageVO getCcpyManageVO() {
		return ccpyManageVO;
	}

	public void setCcpyManageVO(CcpyManageVO ccpyManageVO) {
		this.ccpyManageVO = ccpyManageVO;
	}

	public EmpVO getEmpVO() {
		return empVO;
	}

	public void setEmpVO(EmpVO empVO) {
		this.empVO = empVO;
	}

	public String getUserType() {
		
		return userType;
	}
}
