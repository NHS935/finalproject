package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.CvplVO;
import kr.or.ddit.vo.DeptVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.NoticeVO;

public interface CvplService {

	public List<CvplVO> list(Map<String, Object> map);

	public int getTotal(Map<String, Object> map);

	public CvplVO findById(int cvplSn);

	public int register(CvplVO cvplVO);

	public List<DeptVO> deptVOList();

	public List<FileDetailVO> getFileDetailVOList(long fileGroupSn);

	public int update(CvplVO cvplVO);

	public List<CvplVO> findByMberId(String mberId);


}
