package kr.or.ddit.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import kr.or.ddit.mapper.MberMapper;
import kr.or.ddit.vo.MberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class UserDetailServiceImpl implements UserDetailsService {

    @Autowired
    MberMapper mberMapper;

    @Override
    public UserDetails loadUserByUsername(String mberId) throws UsernameNotFoundException {
        log.info("loadUserByUsername -> empId : " + mberId);

        MberVO mberVO = this.mberMapper.findByMberId(mberId);
        log.info("check : loadUserByUsername-> empVO" + mberVO);

        if (mberVO == null) {
            throw new UsernameNotFoundException("사용자 정보 없음: " + mberId);
        }
        return mberVO == null ? null : new CustomUser(mberVO);
    }

    // 회귀분석 테스터용, 테스트 후 삭제 예정
    public List<MberVO> getTesterList(MberVO mberVO) {

        return this.mberMapper.getMberList(mberVO);
    }
}
