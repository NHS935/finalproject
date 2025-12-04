package kr.or.ddit.controller;
import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.mapper.FileMapper;
import kr.or.ddit.service.HshldService;
import kr.or.ddit.service.LevyService;
import kr.or.ddit.service.MberService;
import kr.or.ddit.service.NoticeService;
import kr.or.ddit.service.ResveService;
import kr.or.ddit.service.VoteManageTrgterService;
import kr.or.ddit.service.impl.CustomUser;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.util.UploadController;
import kr.or.ddit.vo.CmmntyVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.FileGroupVO;
import kr.or.ddit.vo.HshldVO;
import kr.or.ddit.vo.LevyVO;
import kr.or.ddit.vo.MberVO;
import kr.or.ddit.vo.NoticeVO;
import kr.or.ddit.vo.ResveVO;
import kr.or.ddit.vo.VoteMtrVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MberViewController {
	@Autowired
	VoteManageTrgterService voteManageTrgterService;   // 회원 기준 투표목록 조회용
	
	@Autowired	//관리비
	LevyService levyService;
	@Autowired	//커뮤니티시설예약
	ResveService resveService;
	
	@Autowired
	HshldService hshldService; 
	
	@Autowired	//공지사항
	NoticeService noticeService;
	
	@Autowired
	UploadController uploadController;
	
    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    @Autowired
    private MberService mberService;

    @Autowired
    private FileMapper fileMapper;

    private static final String UPLOAD_ROOT = "D:/upload/";

    
    
    @GetMapping("/login")
    public String loginPage(
    		  @RequestParam(value = "errorMsg", required = false) String errorMsg,
    		  Model model,
    		HttpServletRequest request) {
        // 현재 인증된 사용자가 있는지 확인
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (errorMsg != null) {
            model.addAttribute("errorMsg", errorMsg); // JSP에서 참조 가능
        }
        
        // 인증된 사용자가 있고, 익명 사용자가 아니라면 로그아웃 처리
        if (authentication != null && authentication.isAuthenticated()
                && !"anonymousUser".equals(authentication.getPrincipal())) {

            // 세션 무효화
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }

            // Spring Security 인증 정보 클리어
            SecurityContextHolder.clearContext();
        }
        if (errorMsg != null) {
            model.addAttribute("errorMsg", errorMsg);
        }


        
        return "login";
    }

 // 💡 로그인 처리 (POST) - SweetAlert 플래그 설정
    @PostMapping("/login")
    public String processLogin(
            @RequestParam String username, 
            @RequestParam String password, 
            HttpServletRequest request,
            Model model) {

        log.info("로그인 POST 요청: {}", username);

        // 아이디로 DB에서 사용자 정보를 가져오는 로직
        // (MberService에 아이디로 MberVO를 조회하는 메소드가 있다고 가정)
        MberVO mberVO = mberService.findByMberId(username); 

        // 사용자 인증 및 비밀번호 일치 확인
        if (mberVO == null || !bCryptPasswordEncoder.matches(password, mberVO.getPassword())) {
            // 사용자 없음 또는 비밀번호 불일치
            request.setAttribute("errorMsg", "INVALID_CREDENTIALS");
            log.warn("로그인 실패: ID 또는 PW 불일치");
            return "login"; // login.jsp로 포워딩
        }

        // 승인 대기 상태 확인 로직 (MberVO의 enabled 필드 사용)
        if ("0".equals(mberVO.getEnabled())) { 
            request.setAttribute("errorMsg", "APPROVAL_PENDING");
            log.info("로그인 차단: 승인 대기 상태 ({})", username);
            return "login"; 
        }

        // 4. 정상 로그인 처리 (세션 부여)
        HttpSession session = request.getSession();
        session.setAttribute("mberId", mberVO.getMberId());
        session.setAttribute("mberNm", mberVO.getMberNm());

        log.info("로그인 성공: {}", username);
        
        return "redirect:/main"; // 메인 페이지로 리다이렉트
    }
    

    @GetMapping("/signup")
    public String signup() {
        return "signup";
    }

    @PostMapping("/user")
    public String signup(
            MberVO mberVO,
            @RequestParam(value = "profileFile", required = false) MultipartFile[] profileFile,
            @RequestParam(value = "carRegFile", required = false) MultipartFile[] carFile,
            HttpServletRequest request) throws IOException {

    	
        log.info("회원가입 요청: {}", mberVO);
        HshldVO hshldVO = new HshldVO();
        
        mberVO.setResidesttus(mberVO.getMberTy());
        
        // 세대 존재 여부 확인
        boolean householdExists = mberService.checkHousehold(mberVO.getAptcmpl(), mberVO.getHo(), mberVO.getResidesttus());
        if (!householdExists) {
            request.setAttribute("errorMsg", "입력한 동/호수에 해당하는 세대가 존재하지 않습니다.");
            return "signup";
        }

        // 이미 등록된 회원인지 확인
        boolean alreadyRegistered = mberService.checkAlreadyRegistered(mberVO.getAptcmpl(), mberVO.getHo(), mberVO.getResidesttus());
        if (alreadyRegistered) {
            request.setAttribute("errorMsg", "이미 등록된 세대입니다. 관리자에게 문의하세요.");
            return "signup";
        }
       

        // 비밀번호 암호화
        mberVO.setPassword(bCryptPasswordEncoder.encode(mberVO.getPassword()));

        // 승인 대기 상태
        mberVO.setEnabled("0");

        // 프로필 파일 업로드
        if(profileFile != null && profileFile.length > 0) {
        	boolean hasFiles = false;
			for(MultipartFile file : profileFile) {
				if(file != null && !file.isEmpty()) {
					hasFiles = true;
					break;
				}
			}
			if(hasFiles) {
				long fileGroupSn = uploadController.multiImageUpload(profileFile);
				mberVO.setFileGroupSn(fileGroupSn);
			}
			
		}
        
        // 차량 파일 업로드
        if(carFile != null && carFile.length > 0) {
			boolean hasFiles = false;
			for(MultipartFile file : carFile) {
				if(file != null && !file.isEmpty()) {
					hasFiles = true;
					break;
				}
			}
			
			if(hasFiles) {
				long fileGroupSn = uploadController.multiImageUpload(carFile);
				hshldVO.setFileGroupSn(fileGroupSn);
			}
		}
            
        // hshldid = null 해결 필요 mberTy=1, aptcmpl=102, ho=1502, hshldId=null
        
        String hshldId=Integer.toString(mberVO.getMberTy())+mberVO.getAptcmpl()+mberVO.getHo();
        hshldVO.setHshldId(hshldId);
        hshldService.updateHshId(hshldVO);
        
        //update hshdld기준으로 file sn
        
        int result = hshldService.updateHshId(hshldVO);
        
        
        
        // 회원 등록
        mberService.insertMember(mberVO);

        // 권한 부여
        mberService.insertMemberAuthor(mberVO);

        // 세대 연결
        mberService.insertHouseholdMember(mberVO);

        // 차량 등록
        mberService.insertVehicleRegist(mberVO);

        return "login";
    }

    /** 
     * 파일 저장 + DB 등록
     */
    private long saveFileGroup(MultipartFile file, String folder) throws IOException {
    	
    	String uploadPath =UPLOAD_ROOT + folder + "/";
        File dir = new File(uploadPath);
        if (!dir.exists()) dir.mkdirs();

        String originalName = file.getOriginalFilename();
        String ext = getExtension(originalName);
        String saveName = System.currentTimeMillis() + "_" + originalName;

        // 실제 파일 저장
        File dest = new File(dir, saveName);
        file.transferTo(dest);

        // FILE_GROUP insert
        FileGroupVO groupVO = new FileGroupVO();
        fileMapper.insertFileGroup(groupVO);
        long fileGroupSn = groupVO.getFileGroupSn();

        // FILE_DETAIL insert
        FileDetailVO detailVO = new FileDetailVO();
        detailVO.setFileGroupSn(fileGroupSn);
        detailVO.setFileOrginlNm(originalName);
        detailVO.setFileStreNm(saveName);
        detailVO.setFileStrelc(uploadPath);
        detailVO.setFileExtsn(ext);
        detailVO.setFileMg(file.getSize());
        detailVO.setFileMime(file.getContentType());
        detailVO.setFileFancysize((file.getSize() / 1024) + " KB");
        detailVO.setFileDowncount(0);

        fileMapper.insertFileDetail(detailVO);

        log.info("파일 업로드 완료: {} -> {}", originalName, uploadPath);
        return fileGroupSn;
    }

    private String getExtension(String fileName) {
        int idx = fileName.lastIndexOf(".");
        return idx != -1 ? fileName.substring(idx + 1) : "";
    }

//    @GetMapping("/main")
//    public String main() {
//        return "main";
//    }
    @GetMapping("/main2")
    public String main2() {
    	return "main2";
    }
    
    @GetMapping("/index")
    public String index2() {
        return "index";
    }
    
    
	//리스트
	@GetMapping("/main")
	public String list(Model model
			, CmmntyVO cmmntyVO
			, ResveVO resveVO	// 커뮤니티 시설 예약
			, @AuthenticationPrincipal CustomUser customUser
			, @RequestParam(value="keyword", required=false, defaultValue="") String keyword
			, @RequestParam(value="currentPage", required=false, defaultValue="1") int currentPage
			, @RequestParam(value="size", required=false, defaultValue="5") int size	
			  ///// 관리비 추가 /////
			, @RequestParam(name = "ym", required = false) String yearMonth	//levy
			, HttpSession session 	//levy
			, @RequestParam(value="start",required=false) String start /*start  / end 는 캘린더 */
			, @RequestParam(value="end",required=false) String end /*start  / end 는 캘린더 */
			  ///// VOTE추가 /////
	        , @RequestParam(value = "periodFrom",  required = false) String periodFrom
	        , @RequestParam(value = "periodTo",    required = false) String periodTo
	        , @RequestParam(value = "stat",        required = false) String stat
			){

			// 로그인 확인
		    String mberId = (String) session.getAttribute("mberId");
		    if (mberId == null || mberId.equals("")) {	//로그인상태가 아니라면 login페이지로 redirect
		        return "redirect:/login";
		    }
		    /////levy/////
		    // 회원 ID로 세대 ID 조회
		    String hshldId = levyService.selectHouseholdIdByMember(mberId);	
		    if (yearMonth == null || yearMonth.isEmpty()) {
		        java.time.LocalDate now = java.time.LocalDate.now();
		        yearMonth = String.format("%04d-%02d", now.getYear(), now.getMonthValue());
		    }/////levy/////
		    
		    /*kbh추가 지금 년월을yyyy-mm포멧으로 view로 주기위해서 추가 */
		    LocalDate now = LocalDate.now();	
		    DateTimeFormatter ymFmt = DateTimeFormatter.ofPattern("yyyy-MM");
		    /*kbh추가 끝 */
		    
		/* 공지/커뮤/관리비 */
		Map<String, Object> map = new HashMap<>();
		map.put("keyword", keyword);
		map.put("currentPage", currentPage);
		map.put("size", size);
		map.put("wnmpyNotice", 0);

	    List<LevyVO> rqestList = levyService.selectMonthlyRqestByHouse(hshldId, yearMonth); //levy
		List<NoticeVO> noticeList = this.noticeService.list(map);
		List<CmmntyVO> cmmntyVOList = this.resveService.list(cmmntyVO);
		model.addAttribute("cmmntyVOList", cmmntyVOList);
	    model.addAttribute("rqestList", rqestList);	//levy
	    model.addAttribute("yearMonth", yearMonth);	//levy
	    model.addAttribute("nowYm", now.format(ymFmt));	//kbh추가 지금 년월을 yyyy-mm포멧으로 view로 준다

		int total = this.noticeService.getTotal(map);
		
		ArticlePage<NoticeVO> articlePage = new ArticlePage<>(total, currentPage, size, noticeList, keyword);
		
		model.addAttribute("articlePage",articlePage);

		///// VOTE 추가/////
	    // 시작,끝 시간이 뒤집히면 역전시키기 문자열 사전순 비교		//문자열 사전순으로 비교메서드(compareTo)
	    if (periodFrom != null && periodTo != null && periodFrom.compareTo(periodTo) > 0) {
	        String tmp = periodFrom;
	        periodFrom = periodTo;
	        periodTo = tmp;
	    }

	    /* kbh추가(VOTE) */
	    int voteSize = 5; //메인용 투표 목록 사이즈

	    Map<String, Object> voteMap = new HashMap<>();
	    voteMap.put("currentPage", 1);
	    voteMap.put("keyword", keyword);
	    voteMap.put("mberId", mberId);
	    voteMap.put("periodFrom", periodFrom);
	    voteMap.put("periodTo", periodTo);
	    voteMap.put("stat", stat);
	    voteMap.put("size", 5);

	    // 전체 행수 & 목록 조회 (memVoteList 로직 그대로 차용)
	    int voteTotal = this.voteManageTrgterService.getTotal(voteMap);
	    List<VoteMtrVO> voteMtrVOList = this.voteManageTrgterService.memVoteList(voteMap);

	    // 페이지네이션 객체도 분리해서 바인딩 (뷰에서 별도 사용 시)
	    ArticlePage<VoteMtrVO> votePage = new ArticlePage<VoteMtrVO>(voteTotal, 1, voteSize, voteMtrVOList, keyword);

	    model.addAttribute("voteMtrVOList", voteMtrVOList);  // 메인에 뿌릴 투표목록
	    model.addAttribute("votePage", votePage);            // 필요 시 메인에서도 페이지 영역 사용
	    model.addAttribute("periodFrom", periodFrom);
	    model.addAttribute("periodTo", periodTo);
	    model.addAttribute("stat", stat);
		
		return "main";
	}
	
	
	@GetMapping("/dPyunHan/privacyPolicy")
	public String privacyPolicy() {
		return "dPyunHan/privacyPolicy";
	}
	
	@GetMapping("/dPyunHan/termsofService")
    public String termsofService() {
        return "dPyunHan/termsofService";
    }
	
	@GetMapping("/dPyunHan/dPyunHan")
	public String dPyunHan() {
	    return "dPyunHan/dPyunHan";
	}
	
}
