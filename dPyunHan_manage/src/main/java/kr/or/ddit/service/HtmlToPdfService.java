package kr.or.ddit.service;

import com.lowagie.text.DocumentException;

import java.io.IOException;

public interface HtmlToPdfService {
    String createPdfFromHtml(String htmlContent) throws IOException, DocumentException;
}
