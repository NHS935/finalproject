package kr.or.ddit.service;

import kr.or.ddit.vo.FileDetailVO;

import java.io.IOException;

public interface PdfStampingService {
    String stampPdf(String sessionId, String base64ImageData) throws IOException;
    String stampServerSeal(String generatedPdfPath, String sessionId) throws IOException;
    FileDetailVO createStampedPdfCopy(FileDetailVO originalFileVO) throws IOException;
    FileDetailVO addSignatureToPdf(
            FileDetailVO stampedFileVO, // (Step 1에서 만든 직인본 VO)
            String signerName,
            String signatureData
    ) throws IOException;
}
