package kr.or.ddit.service;

import org.springframework.web.multipart.MultipartFile;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.FileGroupVO;
import kr.or.ddit.vo.MberVO;

public interface MberService {

    /** 회원 정보 조회 */
    MberVO findByMberId(String mberId);

    /** 회원 가입 시 회원 정보 insert */
    void insertMember(MberVO mberVO);

    /** 회원 가입 시 기본 권한 insert (ROLE_GUEST) */
    void insertMemberAuthor(MberVO mberVO);
    
    /** HSHLD_MBER_MANAGE 테이블에 세대 연결 */
    void insertHouseholdMember(MberVO mberVO);

    /** 세대 존재 여부 체크 */
    boolean checkHousehold(int aptcmpl, int ho, int residesttus);

    /** 이미 등록된 회원인지 체크 */
    boolean checkAlreadyRegistered(int aptcmpl, int ho, int residesttus);

    /** 세대 ID 조회 (세션 저장용) */
    String selectHouseholdIdByMember(String mberId);

    /** 파일 그룹 등록 */
    long insertFileGroup(FileGroupVO fileGroupVO);

    /** 파일 상세 등록 */
    void insertFileDetail(FileDetailVO fileDetailVO);
    
    /** 차량등록*/
    void insertVehicleRegist(MberVO mberVO);
    
    /** 마이페이지 정보 수정*/
    void updateMember(MberVO mberVO);


    
}
