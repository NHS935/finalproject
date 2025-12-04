package kr.or.ddit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.NtcnVO;

@Mapper
public interface NtcnMapper {

	int insertNtcn(NtcnVO ntcnVO);

	List<NtcnVO> getUnreadList(String userId);

	int updateRedngAt(int ntcnSn);
	
}
