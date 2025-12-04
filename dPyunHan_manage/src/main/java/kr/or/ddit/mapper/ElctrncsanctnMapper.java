package kr.or.ddit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.BkmkSanctnlnDetailVO;
import kr.or.ddit.vo.BkmkSanctnlnVO;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.DrftDocVO;
import kr.or.ddit.vo.DrftRefrnVO;
import kr.or.ddit.vo.ElctrnsanctnVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.SanctnlnVO;
import kr.or.ddit.vo.SignVO;

@Mapper
public interface ElctrncsanctnMapper {
	
	List<DrftDocVO> getDrftDocList();
	DrftDocVO getDrftDoc(DrftDocVO drftDocVO);
	List<DeptVO> getDeptList(EmpVO empVO);

	int postElctrnsanctn(ElctrnsanctnVO elctrnsanctnVO);
	
	int postBkmkSanctnln(BkmkSanctnlnVO bkmkSanctnlnVO);	
	void postBkmkSanctnlnDetail(BkmkSanctnlnDetailVO bkmkSanctnlnDetailVO);
	
	List<BkmkSanctnlnVO> getBkmkSanctnlnList(EmpVO empVO);
	BkmkSanctnlnVO getBkmkSanctnln(BkmkSanctnlnVO bkmkSanctnlnVO);
	
	int postSanctnln(SanctnlnVO sanctnlnVO);
	int postDrftRefrn(DrftRefrnVO drftRefrnVO);

	List<ElctrnsanctnVO> getElctrnsanctnList(Map<String, Object> map);
	int getTotal(Map<String, Object> map);
	
	ElctrnsanctnVO getElctrnsanctn(ElctrnsanctnVO elctrnsanctnVO);
	DeptVO getDept(EmpVO empVO);
	SignVO getSign(EmpVO empVO);
	
	List<ElctrnsanctnVO> getElctrnsanctnRcptList(Map<String, Object> mapRcpt);
	
	int getTotalRcpt(Map<String, Object> mapRcpt);
	EmpVO getEmp(String empId);
	
	int rejectElctrnsanctn(Map<String, Object> map);
	int consentElctrnsanctn(Map<String, Object> map);	

	/*kbh추가 5행출력용*/
	List<ElctrnsanctnVO> getElctrnsanctnVOListSm(Map<String, Object> map);


}
