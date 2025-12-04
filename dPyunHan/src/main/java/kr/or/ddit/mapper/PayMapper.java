package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.LevyVO;
import kr.or.ddit.vo.PayVO;

@Mapper
public interface PayMapper {

	// 관리비 납부 내역 조회
	//매퍼인터페이스의 목적은 쿼리실행임. 매퍼XML 호출 시 파라미터를 던짐
	public List<PayVO> list(@Param("hshldId") String hshldId,
							@Param("keyword") String keyword);

	/*전체 행의 수*/
	public List<LevyVO> getTotal(String hshldId);

	// 1. PAY 테이블에 결제 기록 추가
	public void insertPay(PayVO payVO);

	// 2. RQEST 테이블 납부 상태 + PAY_SN 업데이트
	public void updateRqestAfterPay(Map<String, Object> map);


}
