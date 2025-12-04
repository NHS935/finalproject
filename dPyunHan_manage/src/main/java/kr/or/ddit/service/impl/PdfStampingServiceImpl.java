package kr.or.ddit.service.impl;

import kr.or.ddit.config.BeanController;
import kr.or.ddit.mapper.FileMapper;
import kr.or.ddit.service.PdfStampingService;
import kr.or.ddit.vo.FileDetailVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Base64;
import java.util.Date;
import java.util.UUID;

@Service
@Slf4j
@RequiredArgsConstructor // (수정) 생성자 주입
public class PdfStampingServiceImpl implements PdfStampingService {

    // (수정) final 키워드 추가
    private final ResourceLoader resourceLoader;
    private final BeanController beanController; // [!!!] 이 줄을 추가! [!!!]
    private final FileMapper fileMapper; // (이전 답변에서 추가한 것)

    @Override
    public String stampPdf(String sessionId, String base64ImageData) throws IOException {
        String originalPdfPath = "classpath:static/original.pdf";
        File originalFile = resourceLoader.getResource(originalPdfPath).getFile();
        try (PDDocument document = PDDocument.load(originalFile)) {
            String pureBase64 = base64ImageData.substring(base64ImageData.indexOf(",") + 1);
            byte[] imageBytes = Base64.getDecoder().decode(pureBase64);
            PDImageXObject stampImage = PDImageXObject.createFromByteArray(document, imageBytes, "signature.png");
            PDPage lastPage = document.getPage(document.getNumberOfPages() - 1);
            try (PDPageContentStream contentStream = new PDPageContentStream(document, lastPage,
                    PDPageContentStream.AppendMode.APPEND, true, true)) {
                float x = lastPage.getMediaBox().getWidth() - 300;
                float y = 310;
                contentStream.drawImage(stampImage, x, y, 140, 70);
            }
            Resource staticResource = resourceLoader.getResource("classpath:static/");
            String staticFolderPath = staticResource.getFile().getAbsolutePath();
            File outputDir = new File(staticFolderPath + File.separator + "output");
            if (!outputDir.exists()) {
                outputDir.mkdirs();
            }
            String newPdfFilename = "stamped_" + sessionId + ".pdf";
            String savePath = outputDir.getAbsolutePath() + File.separator + newPdfFilename;
            document.save(savePath);
            return "/output/" + newPdfFilename;
        }
    }

    @Override
    public String stampServerSeal(String generatedPdfPath, String sessionId) throws IOException {
        File originalFile = new File(generatedPdfPath);
        String sealImagePath = "classpath:seals/company_seal.png";
        Resource sealResource = resourceLoader.getResource(sealImagePath);
        try (PDDocument document = PDDocument.load(originalFile);
             InputStream sealInputStream = sealResource.getInputStream()) {
            byte[] sealBytes = sealInputStream.readAllBytes();
            PDImageXObject stampImage = PDImageXObject.createFromByteArray(document, sealBytes, "company_seal.png");
            PDPage lastPage = document.getPage(document.getNumberOfPages() - 1);
            try (PDPageContentStream contentStream = new PDPageContentStream(document, lastPage,
                    PDPageContentStream.AppendMode.APPEND, true, true)) {
                float x = lastPage.getMediaBox().getWidth() - 490;
                float y = 310;
                float width = 70;
                float height = 70;
                contentStream.drawImage(stampImage, x, y, width, height);
            }
            Resource staticResource = resourceLoader.getResource("classpath:static/");
            File outputDir = new File(staticResource.getFile().getAbsolutePath() + File.separator + "output");
            if (!outputDir.exists()) {
                outputDir.mkdirs();
            }
            String newPdfFilename = "final_contract_" + sessionId + ".pdf";
            String savePath = outputDir.getAbsolutePath() + File.separator + newPdfFilename;
            document.save(savePath);
            return "/output/" + newPdfFilename;
        }
    }

    @Override
    public FileDetailVO createStampedPdfCopy(FileDetailVO originalFileVO) throws IOException {

        // --- 1. 원본 파일 절대 경로 재구성 ---
        String webPath = originalFileVO.getFileStrelc();
        if (webPath == null || webPath.isEmpty()) {
            throw new IOException("원본 파일의 웹 경로(fileStrelc)를 찾을 수 없습니다.");
        }
        String uploadRootPath = beanController.getUploadFolder();
        File originalFile = new File(uploadRootPath, webPath);
        if (!originalFile.exists()) {
            throw new IOException("원본 파일을 찾을 수 없습니다: " + originalFile.getAbsolutePath());
        }
        log.info("원본 파일(직인용) 절대 경로 재구성 성공: {}", originalFile.getAbsolutePath());

        // --- 2. 직인 이미지 로드 ---
        String sealImagePath = "classpath:seals/company_seal.png";
        Resource sealResource = resourceLoader.getResource(sealImagePath);
        if (!sealResource.exists()) {
            throw new IOException("직인 이미지를 찾을 수 없습니다: " + sealImagePath);
        }

        // --- 3. [새 파일] 저장 경로 생성 ---
        File newUploadPath = new File(beanController.getUploadFolder(), beanController.getFolder());
        if (!newUploadPath.exists()) {
            newUploadPath.mkdirs();
        }
        String newOriginalFileName = addStampedSuffix(originalFileVO.getFileOrginlNm());
        String newStorageFileName = UUID.randomUUID().toString() + "_" + newOriginalFileName;
        File newStampedFile = new File(newUploadPath, newStorageFileName);

        // --- 4. PDF 스탬핑 작업 (직인) ---
        try (PDDocument document = PDDocument.load(originalFile);
             InputStream sealInputStream = sealResource.getInputStream()) {

            byte[] sealBytes = sealInputStream.readAllBytes();
            PDImageXObject stampImage = PDImageXObject.createFromByteArray(document, sealBytes, "company_seal.png");
            PDPage lastPage = document.getPage(document.getNumberOfPages() - 1);

            try (PDPageContentStream contentStream = new PDPageContentStream(document, lastPage,
                    PDPageContentStream.AppendMode.APPEND, true, true)) {
                // (직인 좌표)
                float x = lastPage.getMediaBox().getWidth() - 490;
                float y = 310-170;
                float width = 70;
                float height = 70;
                contentStream.drawImage(stampImage, x, y, width, height);
            }
            document.save(newStampedFile.getAbsolutePath());
        }
        log.info("직인 파일 생성 완료. 새 파일 경로: {}", newStampedFile.getAbsolutePath());

        // --- 5. [새 파일] VO 생성 및 DB INSERT ---
        FileDetailVO stampedFileVO = createFileDetailVO(
                originalFileVO.getFileGroupSn(), // (그룹SN은 원본과 동일)
                newOriginalFileName,
                newStorageFileName,
                newWebPath(newStorageFileName),
                newStampedFile
        );
        this.fileMapper.insertFileDetail(stampedFileVO);

        log.info("새 직인 파일 정보 DB 저장 완료. 새 fileNo: {}", stampedFileVO.getFileNo());
        return stampedFileVO;
    }

    /**
     * [Step 2. 서명 합성]
     * (모바일 서명 제출 시) '직인본'에 'Base64 서명'을 합성해 "최종본" 생성 (DB INSERT)
     */
    @Override
    public FileDetailVO addSignatureToPdf(
            FileDetailVO stampedFileVO, // (Step 1에서 만든 직인본 VO)
            String signerName,
            String signatureData
    ) throws IOException {

        // --- 1. 원본 (직인본) 파일 절대 경로 재구성 ---
        String webPath = stampedFileVO.getFileStrelc();
        if (webPath == null || webPath.isEmpty()) {
            throw new IOException("서명할 원본(직인본)의 웹 경로(fileStrelc)를 찾을 수 없습니다.");
        }


        String uploadRootPath = beanController.getUploadFolder();
        File originalFile = new File(uploadRootPath, webPath); // (직인본 파일)
        if (!originalFile.exists()) {
            throw new IOException("서명할 원본(직인본) 파일을 찾을 수 없습니다: " + originalFile.getAbsolutePath());
        }
        log.info("원본 파일(서명용) 절대 경로 재구성 성공: {}", originalFile.getAbsolutePath());

        // --- 2. Base64 서명 이미지 -> byte[] 변환 ---
        byte[] signatureBytes;
        try {
            String pureBase64 = signatureData.substring(signatureData.indexOf(",") + 1);
            signatureBytes = Base64.getDecoder().decode(pureBase64);
        } catch (Exception e) {
            log.error("Base64 서명 이미지 디코딩 실패", e);
            throw new IOException("잘못된 서명 이미지 형식입니다.", e);
        }

        // --- 3. [최종 파일] 저장 경로 생성 ---
        File newUploadPath = new File(beanController.getUploadFolder(), beanController.getFolder());
        if (!newUploadPath.exists()) {
            newUploadPath.mkdirs();
        }
        String newOriginalFileName = addSignedSuffix(stampedFileVO.getFileOrginlNm()); // (e.g., ..._stamped_signed.pdf)
        String newStorageFileName = UUID.randomUUID().toString() + "_" + newOriginalFileName;
        File finalSignedFile = new File(newUploadPath, newStorageFileName); // (최종본 파일)

        // --- 4. PDF 스탬핑 작업 (서명) ---
        try (PDDocument document = PDDocument.load(originalFile)) { // (직인본 로드)

            PDImageXObject signatureImage = PDImageXObject.createFromByteArray(document, signatureBytes, "signature.png");
            PDPage lastPage = document.getPage(document.getNumberOfPages() - 1);

            try (PDPageContentStream contentStream = new PDPageContentStream(document, lastPage,
                    PDPageContentStream.AppendMode.APPEND, true, true)) {

                // (서명 좌표)
                float x = lastPage.getMediaBox().getWidth() - 300;
                float y = 310-170;
                float width = 140;
                float height = 70;
                contentStream.drawImage(signatureImage, x, y, width, height);
            }

            document.save(finalSignedFile.getAbsolutePath());
        }
        log.info("최종 서명 파일 생성 완료. 새 파일 경로: {}", finalSignedFile.getAbsolutePath());

        // --- 5. [최종 파일] VO 생성 및 DB INSERT ---
        FileDetailVO finalFileVO = createFileDetailVO(
                stampedFileVO.getFileGroupSn(), // (그룹SN은 계속 동일)
                newOriginalFileName,
                newStorageFileName,
                newWebPath(newStorageFileName),
                finalSignedFile
        );
        this.fileMapper.insertFileDetail(finalFileVO);

        log.info("최종 서명 파일 정보 DB 저장 완료. 새 fileNo: {}", finalFileVO.getFileNo());
        return finalFileVO;
    }

    private FileDetailVO createFileDetailVO(long fileGroupSn, String originalName, String storageName, String webPath, File file) {
        FileDetailVO vo = new FileDetailVO();
        vo.setFileGroupSn(fileGroupSn);
        vo.setFileOrginlNm(originalName);
        vo.setFileStreNm(storageName);
        vo.setFileStrelc(webPath); // 웹 경로
        vo.setFileAbsltStrelc(file.getAbsolutePath()); // 절대 경로
        vo.setFileMg(file.length());
        vo.setFileExtsn(originalName.substring(originalName.lastIndexOf(".") + 1));
        vo.setFileMime("application/pdf"); // (MIME 타입 고정)
        vo.setFileSaveDate(new Date());
        vo.setFileDowncount(0);
        return vo;
    }

    /**
     * 새 웹 경로를 생성합니다. (e.g., /2025/11/13/uuid_name.pdf)
     */
    private String newWebPath(String storageFileName) {
        return "/" + beanController.getFolder().replace("\\", "/") + "/" + storageFileName;
    }

    /*
     * 파일명에 "_signed" 접미사를 붙입니다.
     */
    private String addSignedSuffix(String fileName) {
        if (fileName == null) return "_signed.pdf";

        // (수정) "_stamped"를 "_signed"로 교체
        if (fileName.contains("_stamped")) {
            fileName = fileName.replace("_stamped", "_signed");
        } else {
            // (기존 로직)
            int dotIndex = fileName.lastIndexOf('.');
            if (dotIndex > 0) {
                fileName = fileName.substring(0, dotIndex) + "_signed" + fileName.substring(dotIndex);
            } else {
                fileName = fileName + "_signed";
            }
        }

        return fileName;
    }
    /**
     * 파일명(String)에 "_stamped" 접미사를 붙여 반환합니다.
     * (e.g., "file.pdf" -> "file_stamped.pdf")
     *
     * @param fileName 원본 파일명
     * @return "_stamped"가 추가된 파일명
     */
    private String addStampedSuffix(String fileName) {
        String newFileName;
        int dotIndex = fileName.lastIndexOf('.');

        if (dotIndex > 0) {
            // 확장자가 있는 경우
            String nameWithoutExt = fileName.substring(0, dotIndex);
            String extension = fileName.substring(dotIndex); // ".pdf"
            newFileName = nameWithoutExt + "_stamped" + extension;
        } else {
            // 확장자가 없는 경우
            newFileName = fileName + "_stamped";
        }
        return newFileName;
    }

}