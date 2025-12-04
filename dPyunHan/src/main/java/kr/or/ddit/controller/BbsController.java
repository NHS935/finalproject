package kr.or.ddit.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.config.BeanController;
import kr.or.ddit.service.AnswerService;
import kr.or.ddit.service.BbsService;
import kr.or.ddit.service.impl.CustomUser;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.vo.AnswerVO;
import kr.or.ddit.vo.BbsDetailVO;
import kr.or.ddit.vo.BbsGroupVO;
import kr.or.ddit.vo.FileDetailVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/bbs")
public class BbsController {
	
	@Autowired
	BeanController beanController;
	
	@Autowired
	UploadController uploadController;
	
	@Autowired
	BbsService bbsService;
	
	@Autowired
	AnswerService answerService;
	
	// 게시판(그룹) 목록 페이지
	@GetMapping("/bbsGroupList")
	public String bbsGroupList(Model model) {
		List<Map<String, Object>> bbsGroupVOList = bbsService.bbsGroupList();
		model.addAttribute("bbsGroupList", bbsGroupVOList);

		return "bbs/list";
	}
	
	// 게시판 불러오기
	@GetMapping("/bbsGroupList/data")
	@ResponseBody
	public List<Map<String, Object>> bbsGroupListData() {
		List<Map<String, Object>> bbsGroupVOList = bbsService.bbsGroupList();
		log.info("bbsGroupListData : {}", bbsGroupVOList);
		return bbsGroupVOList;
	}
	
	// 게시판(그룹) 추가
	@PostMapping("/postBbsGroup")
	@ResponseBody
	public Map<String, Object> postBbsGroup(
			@RequestBody BbsGroupVO bbsGroupVO,
			@AuthenticationPrincipal CustomUser customUser
			){
		log.info("createGroupVO -> bbsGroupVO : {}", bbsGroupVO);
		
		//작성자
		bbsGroupVO.setMberId(customUser.getMberVO().getMberId());
		
		//insert 수행
		int result = this.bbsService.postBbsGroup(bbsGroupVO);
		log.info("createGroupVO -> result : {}", bbsGroupVO);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", result);
		map.put("bbsGroupVO", bbsGroupVO);
		log.info("createGroupVO -> map : {}", map);
		
		return map;
	}
	
	// 게시판(그룹) 삭제
	@PostMapping("/deleteBbsGroup/{bbsGroupSn}")
	@ResponseBody
	public Map<String, Object> deleteBbsGroup(
	        @PathVariable long bbsGroupSn,
	        @AuthenticationPrincipal CustomUser customUser) {
	    
	    log.info("deleteBbsGroup -> bbsGroupSn : {}", bbsGroupSn);
	    
	    Map<String, Object> map = new HashMap<String, Object>();
	    
	    // 로그인 체크
	    if(customUser == null || customUser.getMberVO() == null) {
	        map.put("success", false);
	        map.put("message", "로그인이 필요합니다.");
	        return map;
	    }
	    
	    // 게시판 정보 조회
	    BbsGroupVO bbsGroup = this.bbsService.bbsGroup(bbsGroupSn);
	    
	    if(bbsGroup == null) {
	        map.put("success", false);
	        map.put("message", "존재하지 않는 게시판입니다.");
	        return map;
	    }
	    
	    // 작성자 확인 (본인이 만든 게시판만 삭제 가능)
	    if(!bbsGroup.getMberId().equals(customUser.getMberVO().getMberId())) {
	        map.put("success", false);
	        map.put("message", "삭제 권한이 없습니다.");
	        return map;
	    }
	    
	    // 삭제 실행
	    int result = this.bbsService.deleteBbsGroup(bbsGroupSn);
	    log.info("deleteBbsGroup -> result : {}", result);
	    
	    if(result > 0) {
	        map.put("success", true);
	        map.put("message", "게시판이 삭제되었습니다.");
	    } else {
	        map.put("success", false);
	        map.put("message", "게시판 삭제에 실패했습니다.");
	    }
	    
	    return map;
	}
	
	// 게시글 등록
	@PostMapping("/register")
	@ResponseBody
	public Map<String, Object> registerPost(
			@RequestParam("bbsGroupSn") long bbsGroupSn,
			@RequestParam("sj") String sj,
			@RequestParam("cn") String cn,
			@AuthenticationPrincipal CustomUser customUser,
			@RequestParam(value="multipartFiles", required=false) MultipartFile[] multipartFiles){
		
		log.info("register->uploadFile : " + multipartFiles);

		Map<String, Object> map = new HashMap<String, Object>();

		// 로그인 체크
		if(customUser == null || customUser.getMberVO() == null) {
			map.put("result", 0);
			map.put("message", "로그인이 필요합니다.");
			return map;
		}
		
		BbsDetailVO bbsDetailVO = new BbsDetailVO();
		bbsDetailVO.setBbsGroupSn(bbsGroupSn);
		bbsDetailVO.setSj(sj);
		bbsDetailVO.setCn(cn);
		bbsDetailVO.setMberId(customUser.getMberVO().getMberId());
		
		// 파일 업로드
		if(multipartFiles != null && multipartFiles.length > 0) {
			boolean hasFiles = false;
			for(MultipartFile file : multipartFiles) {
				if(file != null && !file.isEmpty()) {
					hasFiles = true;
					break;
				}
			}
			
			if(hasFiles) {
				long fileGroupSn = uploadController.multiImageUpload(multipartFiles);
				bbsDetailVO.setFileGroupSn(fileGroupSn);
			}
		}
		
		int result = this.bbsService.register(bbsDetailVO);
		log.info("bbsDetailVO->register : {}", result);
		
		map.put("result", result);
		map.put("bbsDetailNo", bbsDetailVO.getBbsDetailNo());
		map.put("bbsGroupSn", bbsDetailVO.getBbsGroupSn());
		
		return map;
		
	}

	// 특정 게시판의 게시글 목록 페이지(JSP)
	@GetMapping("/board/{bbsGroupSn}")
	public String bbsBoard(@PathVariable long bbsGroupSn) {
		return "bbs/board";
	}
	
	// 특정 게시판의 게시글 목록 데이터(JSON)
	@GetMapping("/board/{bbsGroupSn}/data")
	@ResponseBody
	public Map<String, Object> bbsBoardData(
			@PathVariable long bbsGroupSn,
			@RequestParam(value="currentPage",required=false,defaultValue="1") int currentPage,
			@RequestParam(value="keyword",required=false,defaultValue="") String keyword) {
		
		int size = 10;
		
		// 파라미터 맵 생성
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("bbsGroupSn", bbsGroupSn);  // ⭐ 추가!
		paramMap.put("currentPage", currentPage);
		paramMap.put("keyword", keyword);
		
		//전체 행의 수
		int total = this.bbsService.getTotal(paramMap);
		log.info("bbsBoardData->total : " + total);
		
		// 게시판 정보
		BbsGroupVO bbsGroup = bbsService.bbsGroup(bbsGroupSn);
		
		// 게시글 목록 (paramMap 전달!) ⭐
		List<BbsDetailVO> bbsList = bbsService.bbsList(paramMap);
		log.info("bbsBoardData->bbsList size : " + bbsList.size());
		
		//페이지네이션
		ArticlePage<BbsDetailVO> articlePage = 
				new ArticlePage<BbsDetailVO>(total, currentPage, size, bbsList, keyword);
		log.info("bbsBoardData->articlePage : " + articlePage);
		
		// 응답 맵
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("bbsGroup", bbsGroup);
		resultMap.put("bbsList", bbsList);
		resultMap.put("articlePage", articlePage);
		
		return resultMap;
	}
	
	// 게시글 상세보기 데이터 (JSON)
	@GetMapping("/detail/{bbsDetailNo}/data")
	@ResponseBody
	public Map<String, Object> bbsDetailData(
	        @PathVariable long bbsDetailNo,
	        @AuthenticationPrincipal CustomUser customUser) {
	    
	    log.info("bbsDetailData -> bbsDetailNo : {}", bbsDetailNo);
	    
	    // 게시글 상세 조회
	    BbsDetailVO bbs = bbsService.bbsDetail(bbsDetailNo);
	    
	    // 게시판 그룹 정보 조회 (댓글 가능 여부 확인용)
	    BbsGroupVO bbsGroup = bbsService.bbsGroup(bbs.getBbsGroupSn());
	    
	    // 댓글 목록 조회
	    List<AnswerVO> answerList = answerService.getAnswerList(bbsDetailNo);
	    
	    // 댓글 개수 조회
	    int answerCount = answerService.getAnswerCount(bbsDetailNo);
	    
	    // 첨부파일 목록 조회
	    List<FileDetailVO> fileList = null;
	    if(bbs.getFileGroupSn() > 0) {
	        fileList = bbsService.getFileList(bbs.getFileGroupSn());
	        log.info("bbsDetailData -> fileList size : {}", fileList.size());
	    }
	    
	    // 현재 로그인한 사용자 ID
	    String currentMberId = null;
	    if(customUser != null && customUser.getMberVO() != null) {
	        currentMberId = customUser.getMberVO().getMberId();
	    }
	    
	    // 응답 맵 생성
	    Map<String, Object> resultMap = new HashMap<String, Object>();
	    resultMap.put("bbs", bbs);
	    resultMap.put("bbsGroup", bbsGroup);
	    resultMap.put("answerList", answerList);
	    resultMap.put("answerCount", answerCount);
	    resultMap.put("fileList", fileList);
	    resultMap.put("currentMberId", currentMberId);
	    
	    return resultMap;
	}
	


	// 게시글 수정 처리
	@ResponseBody
	@PostMapping("/update")
	public Map<String, Object> updateBbs(
	        @RequestParam("bbsDetailNo") long bbsDetailNo,
	        @RequestParam("sj") String sj,
	        @RequestParam("cn") String cn,
	        @AuthenticationPrincipal CustomUser customUser,
	        @RequestParam(value="multipartFiles", required=false) MultipartFile[] multipartFiles){

	    Map<String, Object> map = new HashMap<String, Object>();

	    // 작성자와 로그인 아이디 비교
	    BbsDetailVO cpbbsDetailVO = this.bbsService.bbsDetail(bbsDetailNo);
	    if(!cpbbsDetailVO.getMberId().equals(customUser.getMberVO().getMberId())){
	        map.put("result", 0);
	        map.put("message", "수정 권한이 없습니다.");
	        return map;
	    }
	    
	    // VO 생성
	    BbsDetailVO bbsDetailVO = new BbsDetailVO();
	    bbsDetailVO.setBbsDetailNo(bbsDetailNo);
	    bbsDetailVO.setSj(sj);
	    bbsDetailVO.setCn(cn);
	    
	    // 파일 업로드 (새 파일이 있는 경우)
	    if(multipartFiles != null && multipartFiles.length > 0) {
	        boolean hasFiles = false;
	        for(MultipartFile file : multipartFiles) {
	            if(file != null && !file.isEmpty()) {
	                hasFiles = true;
	                break;
	            }
	        }
	        
	        if(hasFiles) {
	            long fileGroupSn = uploadController.multiImageUpload(multipartFiles);
	            bbsDetailVO.setFileGroupSn(fileGroupSn);
	        }
	    }

	    // 수정 실행
	    int result = this.bbsService.updateBbs(bbsDetailVO);
	    
	    map.put("result", result);
	    map.put("bbsDetailNo", bbsDetailVO.getBbsDetailNo());
	    
	    return map;
	}
	
	//게시글 삭제 처리
	@PostMapping("/delete/{bbsDetailNo}")
	@ResponseBody
	public Map<String, Object> delteBbs(
			@PathVariable long bbsDetailNo,
			@AuthenticationPrincipal CustomUser customUser){
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		// 작성자와 로그인 아이디 비교
		BbsDetailVO cpbbsDetailVO = this.bbsService.bbsDetail(bbsDetailNo);
		if(!cpbbsDetailVO.getMberId().equals(customUser.getMberVO().getMberId())) {
			map.put("success", false);
			map.put("message", "삭제 권한이 없습니다.");
			
			return map;
		}
		
		//삭제 실행
		int result = this.bbsService.deleteBbs(bbsDetailNo);
		
		map.put("success", true);
		map.put("bbsGroupSn", cpbbsDetailVO.getBbsGroupSn());
		
		return map;
	}
	
	// ======================== 댓글 기능 슛 ========================
	
	//댓글 등록
	@ResponseBody
	@PostMapping("/answer/insert")
	public Map<String, Object> insertAnswer(
			@RequestBody AnswerVO answerVO,
			@AuthenticationPrincipal CustomUser customUser
			){
		
		log.info("insertAnswer -> answerVO : {}", answerVO);
		
		// 작성자 설정
		answerVO.setMberId(customUser.getMberVO().getMberId());
		
		// 댓글 등록
		int result = this.answerService.insertAnswer(answerVO);
		log.info("insertAnswer -> result : {}", result);
		
		// 댓글 목록 재조회 (등록 후 전체 댓글 리스트 반환)
		List<AnswerVO> answerList = this.answerService.getAnswerList(answerVO.getBbsDetailNo());
		
		// 댓글 개수 조회
		int answerCount = this.answerService.getAnswerCount(answerVO.getBbsDetailNo());
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("result", result);
		map.put("answerList", answerList);
		map.put("answerCount", answerCount);
		map.put("mberId", customUser.getMberVO().getMberId());
		
		return map;
		
	}
	
	//댓글 수정
	@ResponseBody
	@PostMapping("/answer/update")
	public Map<String, Object> updateAnswer(
			@RequestBody AnswerVO answerVO,
			@AuthenticationPrincipal CustomUser customUser) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		// 작성자 확인
		AnswerVO originalAnswer = this.answerService.getAnswer(answerVO.getAnswerNo());
		if(!originalAnswer.getMberId().equals(customUser.getMberVO().getMberId())) {
			map.put("result", 0);
			map.put("message", "수정 권한이 없습니다.");
			return map;
		}
		
		// 댓글 수정
		int result = this.answerService.updateAnswer(answerVO);
		log.info("updateAnswer -> result : {}", result);
		
		map.put("result", result);
		map.put("answerVO", answerVO);
		
		return map;
	}
	
	// 댓글 삭제
	@ResponseBody
	@PostMapping("/answer/delete/{answerNo}")
	public Map<String, Object> deleteAnswer(
	        @PathVariable long answerNo,
	        @AuthenticationPrincipal CustomUser customUser) {
	    
	    Map<String, Object> map = new HashMap<String, Object>();
	    
	    // 댓글 조회
	    AnswerVO originalAnswer = this.answerService.getAnswer(answerNo);
	    
	    // 댓글이 존재하지 않는 경우
	    if(originalAnswer == null) {
	        map.put("result", 0);
	        map.put("message", "존재하지 않는 댓글입니다.");
	        return map;
	    }
	    
	    // 작성자 확인
	    if(!originalAnswer.getMberId().equals(customUser.getMberVO().getMberId())) {
	        map.put("result", 0);
	        map.put("message", "삭제 권한이 없습니다.");
	        return map;
	    }
	    
	    // 댓글 삭제
	    int result = this.answerService.deleteAnswer(answerNo);
	    
	    map.put("result", result);
	    map.put("answerNo", answerNo);
	    
	    return map;
	}

	// 댓글 상세 조회
	@ResponseBody
	@PostMapping("/answer/detail")
	public Map<String, Object> getAnswer(@RequestBody AnswerVO answerVO) {
	    
	    answerVO = this.answerService.getAnswer(answerVO.getAnswerNo());
	    
	    int result = 0;
	    if(answerVO != null) {
	        result = 1;
	    }
	    
	    Map<String, Object> map = new HashMap<String, Object>();
	    map.put("result", result);
	    map.put("answerVO", answerVO);
	    
	    return map;
	}
	
	/* 모달로 대체
	// 게시글 상세보기
	@GetMapping("/detail/{bbsDetailNo}")
	public String bbsDetail(@PathVariable long bbsDetailNo, Model model) {
		
		log.info("bbsDetail -> bbsDetailNo : {}", bbsDetailNo);
		
	    BbsDetailVO bbs = bbsService.bbsDetail(bbsDetailNo);
	    
	    // 게시판 그룹 정보 조회 (댓글 가능 여부 확인용)
	    BbsGroupVO bbsGroup = bbsService.bbsGroup(bbs.getBbsGroupSn());
	    
	    // 댓글 목록 조회
	    List<AnswerVO> answerList = answerService.getAnswerList(bbsDetailNo);
	    
	    // 댓글 개수 조회
	    int answerCount = answerService.getAnswerCount(bbsDetailNo);
	    
	    model.addAttribute("bbs", bbs);
	    model.addAttribute("bbsGroup", bbsGroup);
	    model.addAttribute("answerList", answerList);
	    model.addAttribute("answerCount", answerCount);
	    
	    if(bbs.getFileGroupSn() > 0) {
	    	List<FileDetailVO> fileList = bbsService.getFileList(bbs.getFileGroupSn());
	    	log.info("bbsDetail -> fileList size : {}", fileList.size());
	    	model.addAttribute("fileList", fileList);
	    }
	    
	    return "bbs/detail";
	}
	*/
	
	/* 모달로 대체
	// 게시글 수정 폼
	@GetMapping("/edit/{bbsDetailNo}")
	public String edit(@PathVariable long bbsDetailNo,
			Model model,
			@AuthenticationPrincipal CustomUser customUser) {
		
		BbsDetailVO bbs = bbsService.bbsDetail(bbsDetailNo);

		List<BbsGroupVO> bbsGroupVOList = bbsService.bbsGroupList();
		
		model.addAttribute("bbs",bbs);
		model.addAttribute("bbsGroupList", bbsGroupVOList);
		
		return "bbs/edit";
	}
	*/
	
	/* 모달로 대체
	// 게시글 작성폼
	@GetMapping("/register")
	public String register(Model model,
		@RequestParam("bbsGroupSn") long bbsGroupSn) {

		List<BbsGroupVO> bbsGroupVOList = bbsService.bbsGroupList();
		BbsGroupVO bbsGroup = bbsService.bbsGroup(bbsGroupSn);
		
		model.addAttribute("bbsGroupList", bbsGroupVOList);
		model.addAttribute("bbsGroupSn", bbsGroupSn);
		model.addAttribute("bbsGroup", bbsGroup);
		
		return "bbs/register";
	}
	*/
	
}





















