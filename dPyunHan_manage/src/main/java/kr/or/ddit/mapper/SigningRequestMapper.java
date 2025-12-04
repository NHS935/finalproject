package kr.or.ddit.mapper;

import kr.or.ddit.vo.SigningRequestVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface SigningRequestMapper {

    /**
     * 서명 요청 정보를 DB에 저장합니다.
     */
    int insertSigningRequest(SigningRequestVO requestVO);

    /**
     * 토큰 값으로 서명 요청 정보를 조회합니다.
     */
    SigningRequestVO findRequestByToken(String signToken);

    /**
     * 토큰의 상태를 변경합니다. (e.g., PENDING -> COMPLETED)
     */
    int updateRequestStatus(@Param("signToken") String signToken, @Param("status") String status);
}