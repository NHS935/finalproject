package kr.or.ddit.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class EmpVO {
	private String telno;
	private String email;
	private String adres;
	private String brthdy;
	private int salary;
	private String enabled;
	private String empId;
	private String empPassword;
	private int clsf;
	private String nm;
	
	public String getClsfName() {
	    switch(clsf) {
	        case 3: return "사원";
	        case 2: return "과장";
	        case 1: return "부장";
	        case 0: return "소장";
	        default: return "";
	    }
	}
	
	//서명
	private SignVO signVO; //<resultmap> <association> 
	
	//첨부 직원 이미지
	private long fileGroupSn;
	
	//부서
	private String deptCode;
	private DeptVO deptVO;
	
	//자기참조
	private String suprrId; // 상관Id
	private EmpVO suprrEmpVO;
	
	//EMP_AUTHOR 테이블
	List<EmpAuthorVO> empAuthorVOList;
	
	//kbh
	private MultipartFile[] uploadFiles;
	private FileGroupVO fileGroupVO;
	private FileGroupVO empFileVOs;
	//kbh
}
