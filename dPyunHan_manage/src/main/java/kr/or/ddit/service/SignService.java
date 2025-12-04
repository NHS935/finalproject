package kr.or.ddit.service;

import kr.or.ddit.vo.SignVO;

public interface SignService {
	
	//selectSign empId를 기준으로 sign사진을 찾기
	public SignVO selectSign(String empId);
	public long upsertSignAndUpload(SignVO signVO);
}
