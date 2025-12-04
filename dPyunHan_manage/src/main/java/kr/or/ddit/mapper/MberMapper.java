package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.MberVO;

@Mapper
public interface MberMapper {

    // 승인 대기 회원 조회
    List<MberVO> selectPendingMembers();

    // 승인 처리
    void approveMember(String mberId);

    // 기존 ROLE_GUEST 삭제
    void deleteGuestRole(String mberId);

    // ROLE_MBER 추가
    void insertMberRole(String mberId);

    // 회원상세조회
	MberVO selectMemberDetail(String mberId);

	// 회원숫자count
	public int getMemNum();
	
    // 세대 입주민 목록
	List<MberVO> getHshldList(Map<String, Object> map);
	// 페이징
	int getHshldTotal(Map<String, Object> map);

    // 세대 상세
	public List<MberVO> getHshldDetail(String hshldId);

	MberVO findByMberId(String mberId);


}
