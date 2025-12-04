package kr.or.ddit.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.MberVO;

@Mapper
public interface MberMapper {

    /** 회원 정보 조회 */
    MberVO selectMemberById(String mberId);

    /** 회원 가입 시 회원 정보 insert */
    void insertMember(MberVO mberVO);

    /** 회원 가입 시 기본 권한 insert (ROLE_GUEST) */
    void insertMemberAuthor(MberVO mberVO);

    /** HSHLD_MBER_MANAGE 테이블에 세대 연결 */
    void insertHouseholdMember(MberVO mberVO);

    /** 세대 존재 여부 체크 */
    Integer countHousehold(int aptcmpl, int ho, int residesttus);

    /** 이미 등록된 회원인지 체크 */
    Integer countRegistered(int aptcmpl, int ho, int residesttus);

    /** 세대 ID 조회 (세션 저장용) */
    String selectHouseholdIdByMember(String mberId);

	MberVO findByMberId(String mberId);
	
	void insertVehicleRegist(MberVO mberVO);

	/** 마이페이지 정보 수정*/
	void updateMember(MberVO mberVO);

    List<MberVO> getMberList(MberVO mberVO);
}
