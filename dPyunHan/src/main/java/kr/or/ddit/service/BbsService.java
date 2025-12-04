package kr.or.ddit.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.vo.BbsDetailVO;
import kr.or.ddit.vo.BbsGroupVO;
import kr.or.ddit.vo.FileDetailVO;

public interface BbsService {

	//게시판 그룹 생성
	public int postBbsGroup(BbsGroupVO bbsGroupVO);
	
	//게시판 그룹 삭제
	public int deleteBbsGroup(long bbsGroupSn);

	//게시판 그룹 리스트 조회
	public List<Map<String, Object>> bbsGroupList();

	//게시글 작성
	public int register(BbsDetailVO bbsDetailVO);

	//게시판 그룹 단일 조회
	public BbsGroupVO bbsGroup(long bbsGroupSn);

	//특정 게시판 그룹의 게시글 리스트 조회
	public List<BbsDetailVO> bbsList(Map<String, Object> map);

	//게시글 상세보기
	public BbsDetailVO bbsDetail(long sn);

	//게시글 수정
	public int updateBbs(BbsDetailVO bbsDetailVO);

	//게시글 삭제
	public int deleteBbs(long bbsDetailNo);

	//전체 행의 수
	public int getTotal(Map<String, Object> map);

	//파일 목록 조회
	public List<FileDetailVO> getFileList(long fileGroupSn);



}
