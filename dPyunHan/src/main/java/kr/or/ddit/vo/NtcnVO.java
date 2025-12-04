package kr.or.ddit.vo;

import java.time.LocalDateTime;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonFormat;

import kr.or.ddit.enums.NtcnTargetType;
import kr.or.ddit.enums.NtcnType;
import lombok.Data;

@Data
public class NtcnVO {

	private int ntcnSn;
	private String dsptchmanId;
	private String rcverId;
	@JsonFormat(shape = JsonFormat.Shape.STRING)
	private NtcnType ntcnTy;
	private String ntcnCn;
	private String ntcnUrl;
	private String redngAt;
	private LocalDateTime  registDt;
	
	// DB 저장 X, 전송 경로 구분용
	private transient NtcnTargetType ntcnTargetType;
	
	// 미확인 알림 리스트
	private List<NtcnVO> unreadList;
	
}
