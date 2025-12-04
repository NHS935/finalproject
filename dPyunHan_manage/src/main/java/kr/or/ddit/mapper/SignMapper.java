package kr.or.ddit.mapper;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.SignVO;
@Mapper
public interface SignMapper {

	
	//selectSign empId를 기준으로 sign사진을 찾기
	public SignVO selectSign(String empId);
	
	  //  EMP_ID로 조회
    SignVO findByEmpIdForUpdate(String empId);

    // SIGN 생성 
    int insertSignWithSeq(SignVO vo);

    // EMP_ID 기준으로 FILE_GROUP_SN 업데이트
    int updateFileGroupByEmpId(String empId, long fileGroupSn);

    // 조회용
    Long findSignIdByEmpId(String empId);
	
}
