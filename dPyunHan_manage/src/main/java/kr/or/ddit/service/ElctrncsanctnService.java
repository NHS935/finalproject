package kr.or.ddit.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.service.impl.CustomUser;
import kr.or.ddit.vo.BkmkSanctnlnDataVO;
import kr.or.ddit.vo.BkmkSanctnlnVO;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.DrftDocVO;
import kr.or.ddit.vo.ElctrnsanctnVO;
import kr.or.ddit.vo.EmpVO;
import kr.or.ddit.vo.SanctnlnVO;

public interface ElctrncsanctnService {
	
	List<DrftDocVO> getDrftDocList();

	DrftDocVO getDrftDoc(DrftDocVO drftDocVO);

	List<DeptVO> getDeptList(EmpVO empVO);

	int postElctrnsanctn(ElctrnsanctnVO elctrnsanctnVO, MultipartFile[] inputFiles);

	int postBkmkSanctnln(BkmkSanctnlnDataVO bkmkSanctnlnDataVO, CustomUser customUser);

	List<BkmkSanctnlnVO> getBkmkSanctnlnList (EmpVO empVO);

	BkmkSanctnlnVO getBkmkSanctnln(BkmkSanctnlnVO bkmkSanctnlnVO);

	int postSanctnlnDrftRefrn(String sanctnlnEmpList, String drftRefrnEmpList, ElctrnsanctnVO elctrnsanctnVO);

	int getTotal(Map<String, Object> map);

	List<ElctrnsanctnVO> getElctrnsanctnList(Map<String, Object> map);
	
	ElctrnsanctnVO getElctrnsanctn(ElctrnsanctnVO elctrnsanctnVO);

	List<ElctrnsanctnVO> getElctrnsanctnRcptList(Map<String, Object> mapRcpt);

	int getTotalRcpt(Map<String, Object> mapRcpt);

	int rejectElctrnsanctn(SanctnlnVO sanctnlnVO, EmpVO empVO);

	int consentElctrnsanctn(SanctnlnVO sanctnlnVO, EmpVO empVO)throws IOException;
	
//	여기서부터 수정
	/*kbh추가 5행출력용*/
	List<ElctrnsanctnVO> getElctrnsanctnVOListSm(Map<String, Object> map);

}
