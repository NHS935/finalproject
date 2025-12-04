package kr.or.ddit.service.impl;

import java.util.Collection;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import kr.or.ddit.vo.MberVO;

public class CustomUser extends User {

	private MberVO mberVO;
	
	public CustomUser(String username, String password, Collection<? extends GrantedAuthority> authorities) {
		super(username, password, authorities);
	}
	
	public CustomUser(MberVO mberVO) {
		super(mberVO.getMberId(), mberVO.getPassword()
				, mberVO.getAuthorVOList().stream()
				.map(auth->new SimpleGrantedAuthority(auth.getAuthorId()))
				.collect(Collectors.toList())
				);
		this.mberVO=mberVO;
	}

	public MberVO getMberVO() {
		return mberVO;
	}

	public void setMberVO(MberVO mberVO) {
		this.mberVO = mberVO;
	}
}
