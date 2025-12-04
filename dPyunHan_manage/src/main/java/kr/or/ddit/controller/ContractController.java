package kr.or.ddit.controller;

import com.lowagie.text.DocumentException;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.service.PdfGenerationService;
import kr.or.ddit.service.impl.ContractServiceImpl;
import kr.or.ddit.service.impl.HtmlToPdfServiceImpl;
import kr.or.ddit.service.impl.PdfStampingServiceImpl;
import kr.or.ddit.util.ArticlePage;
import kr.or.ddit.vo.ContractVO;
import kr.or.ddit.vo.FileDetailVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.beans.factory.annotation.Value;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Controller
@RequestMapping("/contract")
@RequiredArgsConstructor
@Slf4j
public class ContractController {

    private final ContractServiceImpl contractServiceImpl;

    private final HtmlToPdfServiceImpl htmlToPdfServiceImpl;

    private final PdfGenerationService pdfGenerationService;

    // (필수) application.properties에 임시 폴더 경로 설정
//    @Value("${file.temp.path}") // 예: C:/upload/temp
    
//    private String tempUploadPath;

    /**
     * 1. 수정 페이지 (View)를 보여주는 메서드
     * - DB(서비스)에서 계약서 내용을 가져와서,
     */
//    @GetMapping("/edit")
//    public String editContract(Model model) {
//
//        String currentContent = contractService.getContract();
//
//        // "contractContent"라는 이름으로 jsp파일에 데이터를 전달
//        model.addAttribute("contractContent", currentContent);
//
//        return "contract/edit"; // "/WEB-INF/views/edit.jsp"를 찾아감
//    }
    @GetMapping("/contractlist")
    public String contractlist(Model model, @RequestParam(required = false, defaultValue = "") String keyword,
                               @RequestParam(required = false, defaultValue = "1") int currentPage) {
        int size = 10;

        Map<String, Object> map = new HashMap<>();
        map.put("currentPage", currentPage);
        map.put("keyword", keyword);

        int total = this.contractServiceImpl.getTotal(map);

        List<ContractVO> contractVOList = this.contractServiceImpl.getContractList(map);

        ArticlePage<ContractVO> articlePage = new ArticlePage<ContractVO>(total, currentPage, size, contractVOList,
                keyword);

        model.addAttribute("articlePage", articlePage);

        return "contract/contractlist";
    }


    @GetMapping("/postContract")
    public String insertContract(){
        return "contract/contwrite";
    }

    @PostMapping("/postContract")
    @ResponseBody // 1. 이 메서드는 뷰(HTML)가 아닌 데이터(JSON)를 반환합니다.
    public ResponseEntity<Map<String, Object>> postContract(ContractVO form) {
        Map<String, Object> map = new HashMap<>();

        try {
            ContractVO contractVO = contractServiceImpl.postContract(form);
            Long id = contractVO.getId();

            // 2. 성공 시: JS가 원하는 JSON 형식으로 반환
            map.put("result", 1); // JS의 'result.result > 0' 조건
            map.put("id", id);      // JS가 리다이렉트할 수 있도록 ID 전달

            return ResponseEntity.ok(map); // 200 OK + {"result": 1, "id": 123}

        } catch (Exception e) {
            // 3. 실패 시: JS가 오류를 알 수 있도록 JSON 반환
            e.printStackTrace(); // 서버 콘솔에 에러 로그 출력
            map.put("result", 0);
            map.put("message", "저장에 실패했습니다: " + e.getMessage());

            // 500 서버 내부 오류 + {"result": 0, "message": "..."}
            return ResponseEntity.status(500).body(map);
        }
    }
//    @PostMapping("/postContract")
//    public String postContract(ContractVO form,RedirectAttributes rttr){
//
//
//        ContractVO contractVO = contractServiceImpl.postContract(form);
//
//        Long id = contractVO.getId();
//
//        rttr.addAttribute("id",id);
//
//        return "redirect:/contract/edit/{id}";
//    }

    @GetMapping("/edit/{id}")
    public String editContract(@PathVariable("id") Long id,Model model) {

        // 3. 서비스 호출 변경:
        //    이제 고정된 ID가 아니라 URL로 받은 'id'를 넘겨줍니다.
        ContractVO contractVO = contractServiceImpl.getContract(id);

        model.addAttribute("contractContent", contractVO.getContent());
        model.addAttribute("title", contractVO.getTitle());

        // (참고) 수정 중인 문서의 ID도 JSP로 넘겨주면 나중에 저장할 때 유용합니다.
        model.addAttribute("id", id);

        return "contract/edit";
    }
//
//    @GetMapping("/cont")
//    public String Contract(Model model) {

//        String currentContent = contractService.getContract();

        // "contractContent"라는 이름으로 jsp파일에 데이터를 전달
//        model.addAttribute("contractContent", currentContent);
//
         // "/WEB-INF/views/edit.jsp"를 찾아감
//        return "contract/contwrite";
//    }

    /**
     * 2. CKEditor에서 '저장' 버튼을 눌렀을 때 실행되는 메서드
     * - "content"라는 이름의 파라미터(HTML 데이터)를 받아서,
     * - 서비스에 넘겨 저장시킵니다.
     * - 저장이 끝나면 다시 수정 페이지로 리다이렉트합니다.
     */
    @PostMapping("/save/{id}")
    public String saveContract(@PathVariable("id") Long id,ContractVO form) {

        // CKEditor에서 넘어온 거대한 HTML 문자열을 서비스로 전달
        contractServiceImpl.saveContract(id,form);

        System.out.println(form);

        // 저장 후, 다시 /contract/edit 페이지로 이동시킴 (Post-Redirect-Get 패턴)
        return "redirect:/contract/edit/{id}";
    }

    @PostMapping("/generate-pdf")
    @ResponseBody // (페이지 이동 대신, 생성된 파일의 URL을 JSON/텍스트로 반환)
    public String generateContractPdf(
            @RequestParam("content") String htmlContent, // CKEditor의 name="content"
            HttpSession session) {

        String PdfUrl = null;
        try {
            // 1단계: HTML -> PDF 파일 생성 (직인 X)
            PdfUrl = htmlToPdfServiceImpl.createPdfFromHtml(htmlContent);

            // 2단계: 생성된 PDF -> 직인 날인 (직인 O)
            // (이전에 만드신 PDFBox 서비스 호출)
//            String finalPdfUrl = pdfStampingServiceImpl.stampServerSeal(
//                    PdfUrl,
//                    session.getId() // (세션 ID로 파일명 구분)
//            );

            // 3. (선택) 임시 1단계 파일(tempPdfPath)은 삭제
            // ... (new File(tempPdfPath).delete();) ...

            // 4. 클라이언트에게 최종 PDF 파일의 URL 반환
            // (예: "/output/final_contract_...pdf")
            return PdfUrl;

        } catch (Exception e) {
            e.printStackTrace();
            // (에러 처리)
            // (만약 tempPdfPath가 생성됐다면 삭제하는 로직 필요)
            return "ERROR: " + e.getMessage();
        }
    }

    @PostMapping("/sendToSanctn")
    public String sendToSanctn(
            @RequestParam("content") String htmlContent,
            @RequestParam("title") String title,
            RedirectAttributes redirectAttributes) {

        // 1. 원본 파일명 결정
        String originalFilename = (title == null || title.isEmpty() ? "계약서" : title) + ".pdf";

        // 2. 새로운 파일 그룹 생성을 위한 초기 값 (DB 설정에 따라 0L 또는 null 사용)
        final Long INITIAL_GROUP_SN = 0L;

        try {
            // 3. (★핵심★) PDF 생성, 임시 저장, 영구 저장/DB 등록을 통합 서비스로 처리
            // 반환된 FileDetailVO에는 최종 fileGroupSn과 fileNo가 채워져 있습니다.
            FileDetailVO savedFileVO = htmlToPdfServiceImpl.generateAndSavePdf(
                    htmlContent,
                    INITIAL_GROUP_SN,
                    originalFilename
            );

            // 4. 리다이렉트될 페이지로 최종 ID 전달 (Flash Attribute)
            // 다음 업로드 시 재사용할 GroupSn과 첨부된 PDF의 FileNo를 전달합니다.
            redirectAttributes.addFlashAttribute("fileGroupSn", savedFileVO.getFileGroupSn());
            redirectAttributes.addFlashAttribute("fileNo", savedFileVO.getFileNo());
            redirectAttributes.addFlashAttribute("fileOriginalName", originalFilename);

            log.info("PDF 생성 및 DB 등록 성공. 전달할 FileGroupSn: {}, FileNo: {}",
                    savedFileVO.getFileGroupSn(), savedFileVO.getFileNo());


            // 5. "전자결재 작성 폼" 페이지로 이동
            return "redirect:/elctrnsanctn/postNewElctrnsanctn";

        } catch (IOException e) {
            log.error("PDF 파일 처리 중 입출력 오류 발생", e);
            redirectAttributes.addFlashAttribute("error", "파일 저장 중 오류가 발생했습니다.");
            return "redirect:/contract/contractlist";

        } catch (DocumentException e) {
            log.error("PDF 렌더링 오류 (폰트, CSS, XHTML 문제)", e);
            redirectAttributes.addFlashAttribute("error", "PDF 문서 생성 중 오류가 발생했습니다.");
            return "redirect:/contract/contractlist";

        } catch (Exception e) {
            log.error("예상치 못한 오류 발생", e);
            redirectAttributes.addFlashAttribute("error", "처리 중 예상치 못한 오류가 발생했습니다.");
            return "redirect:/contract/contractlist";
        }
    }

}