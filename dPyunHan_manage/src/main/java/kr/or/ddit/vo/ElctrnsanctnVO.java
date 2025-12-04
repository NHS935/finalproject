package kr.or.ddit.vo;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class ElctrnsanctnVO {
	private int rnum;
	private String drftSj;
	private int elctrnsanctnSn;
	
	private String empId;
	private EmpVO empVO;

	@DateTimeFormat(pattern = "yyyy-MM-dd")
	@JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date drftDt;

	@DateTimeFormat(pattern = "yyyy-MM-dd")
	@JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date creatDt;

	@DateTimeFormat(pattern = "yyyy-MM-dd")
	@JsonFormat(pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
	private Date updtDt;

	private String drftCn;
	private long fileGroupSn;

	private int drftTmprstre;

	// 임시저장 여부
	public String getDrftTmprstreStts() {
		if (drftTmprstre > 0) {
			return "임시저장";
		} else {
			return "상신완료";
		}
	}

	// 결재선 리스트 1:N 관계
	private List<SanctnlnVO> sanctnlnVOList;

	public String getTotSanctnStts() {
		if (sanctnlnVOList == null || sanctnlnVOList.isEmpty()) {
			return "대기";
		}
		long approveCnt = sanctnlnVOList.stream().filter(s -> s.getSanctnSttus() == SanctnlnVO.sttsApr).count();
		long rejectCnt = sanctnlnVOList.stream().filter(s -> s.getSanctnSttus() == SanctnlnVO.sttsRej).count();

		if (rejectCnt > 0) {
			return "반려";
		}
		if (approveCnt == sanctnlnVOList.size()) {
			return "결재완료";
		}
		if (approveCnt > 0) {
			return "진행중";
		}
		return "대기";
	}

	public String getRejectEmpId() {
		return sanctnlnVOList.stream().filter(s -> s.getSanctnSttus() == SanctnlnVO.sttsRej).map(s -> s.getEmpId())
				.findFirst().orElse(null);
	}

	public String getNextSanctnEmpId() {
		String rejectEmpId = getRejectEmpId();
		if (rejectEmpId != null) {
			return rejectEmpId;
		}

		int maxApprovedOrdr = sanctnlnVOList.stream().filter(s -> s.getSanctnSttus() == SanctnlnVO.sttsApr)
				.mapToInt(s -> s.getSanctnOrdr()).max().orElse(0);

		return sanctnlnVOList.stream().filter(s -> s.getSanctnOrdr() == maxApprovedOrdr + 1).map(s -> s.getEmpId())
				.findFirst().orElse(null);
	}

	public String getFirstSanctnEmpId() {
		return sanctnlnVOList.stream().filter(s -> s.getSanctnOrdr() == 1).map(s -> s.getEmpId()).findFirst()
				.orElse(null);
	}

	public String getCurrentWaitingSanctnEmpId() {
		String rejectEmpId = getRejectEmpId();
		if (rejectEmpId != null) {
			return rejectEmpId;
		}

		long approveCnt = sanctnlnVOList.stream().filter(s -> s.getSanctnSttus() == SanctnlnVO.sttsApr).count();

		if (approveCnt == 0) {
			return getFirstSanctnEmpId();
		}

		return getNextSanctnEmpId();
	}

	public String getSanctnEmp() {
		if (sanctnlnVOList == null || sanctnlnVOList.isEmpty()) {
			return "";
		}

		long rejectCnt = sanctnlnVOList.stream().filter(s -> s.getSanctnSttus() == SanctnlnVO.sttsRej).count();

		if (rejectCnt > 0) {
			String rejectEmpNm = sanctnlnVOList.stream().filter(s -> s.getSanctnSttus() == SanctnlnVO.sttsRej)
					.map(s -> {
						EmpVO emp = s.getEmpVO();
						return (emp != null) ? emp.getNm() : null;
					}).findFirst().orElse(null);

			return rejectEmpNm;
		}

		long approveCnt = sanctnlnVOList.stream().filter(s -> s.getSanctnSttus() == SanctnlnVO.sttsApr).count();

		if (approveCnt == sanctnlnVOList.size()) { // 결재완료시 마지막 결재권자
			String finalApproverNm = sanctnlnVOList.stream().filter(s -> s.getDcrbmanAt() == 1) // 결재권자
					.map(s -> {
						EmpVO emp = s.getEmpVO();
						return (emp != null) ? emp.getNm() : null;
					}).findFirst().orElse(null);

			return finalApproverNm;
		}

		if (approveCnt > 0) { // 미결인 다음 결재자
			String nextEmpNm = sanctnlnVOList.stream().filter(s -> s.getSanctnSttus() == SanctnlnVO.sttsPnd).map(s -> {
				EmpVO emp = s.getEmpVO();
				return (emp != null) ? emp.getNm() : null;
			}).findFirst().orElse(null);

			return nextEmpNm;
		}
		
		String firstEmpNm = sanctnlnVOList.stream().filter(s -> s.getSanctnOrdr() == 1).map(s -> {
			EmpVO emp = s.getEmpVO();
			return (emp!=null) ? emp.getNm() : null;
		}).findFirst().orElse(null);
		return firstEmpNm;
	}

	public String getFinalSanctnEmpNm() {
		String finalSanctnEmpNm = sanctnlnVOList.stream().filter(s -> s.getDcrbmanAt() == 1).map(s -> {
			EmpVO emp = s.getEmpVO();
			return (emp != null) ? emp.getNm() : "";
		}).findFirst().orElse("");
		return finalSanctnEmpNm;
	}

	// 1:N 관계
	private List<DrftRefrnVO> drftRefrnVOList;

	// 재상신용 전자결재
	private int upperElctrnsanctnId;
	private ElctrnsanctnVO elctrnsanctnVO;

	// 분류 코드
	private int drftDocId;
	private int elctrnsanctnManageId;

	private DrftDocVO drftDocVO;

}
