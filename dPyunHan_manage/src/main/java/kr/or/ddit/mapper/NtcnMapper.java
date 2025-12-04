package kr.or.ddit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.FcltyManageVO;
import kr.or.ddit.vo.FcltyVO;
import kr.or.ddit.vo.NtcnVO;

@Mapper
public interface NtcnMapper {

	//알림테이블 insert
	int insertNtcn(NtcnVO ntcnVO);

	List<NtcnVO> getUnreadList(String userId);

	int updateRedngAt(int ntcnSn);

	//fcltyManageVO 조회(수신자, 알림 제목)
	List<FcltyVO> selectAptcmplFcltyClFcltyNm(int fcltyManageSn);

	//fcltyManageVO 조회(수신자, 알림 제목)
	FcltyManageVO selectCmmntySnCmmntyNm(int fcltyManageSn);

	List<FcltyVO> selectAptcmplFcltyClFcltyNm1(int fcltySn);
}
