package kr.or.ddit.service; // (사용자님의 서비스 패키지 경로)

import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.xhtmlrenderer.pdf.ITextRenderer;
import com.lowagie.text.pdf.BaseFont; // (Flying Saucer가 사용하는 iText 2.x)

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;

/**
 * HTML 문자열을 PDF byte 배열로 변환하는 서비스
 */
@Service
public class PdfGenerationService {

    /**
     * CKEditor가 생성한 HTML 문자열을 PDF byte 배열로 변환합니다.
     * @param htmlContent (CKEditor에서 넘어온 HTML)
     * @return PDF 파일의 byte[]
     * @throws Exception
     */
    public byte[] generatePdfFromHtml(String htmlContent) throws Exception {

        // 1. (★중요★) Jsoup을 사용하여 HTML을 XHTML로 정리
        //    CKEditor의 HTML은 <img> 태그 등이 닫히지 않아 PDF 변환 시 오류가 날 수 있음.
        Document document = Jsoup.parse(htmlContent);
        document.outputSettings().syntax(Document.OutputSettings.Syntax.xml); // XHTML 모드로 설정
        String xhtml = document.html();

        // 2. (★중요★) 한글 폰트를 사용하도록 HTML을 강제로 수정
        //    CSS로 'Malgun Gothic' 폰트를 지정해 줍니다.
        String finalHtml = wrapHtmlWithFont(xhtml);

        // 3. PDF를 메모리(ByteArray)에 생성하기 위한 준비
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

        // 4. ITextRenderer 객체 생성
        ITextRenderer renderer = new ITextRenderer();

        // 5. (★핵심★) 2단계에서 준비한 한글 폰트 파일을 렌더러에 등록
        try {
            // 'src/main/resources/fonts/MalgunGothic.ttf' 파일을 찾음
            // ClassPathResource는 'resources' 폴더를 기준으로 경로를 찾습니다.
            File fontFile = new ClassPathResource("fonts/MalgunGothic.ttf").getFile();

            renderer.getFontResolver().addFont(
                    fontFile.getAbsolutePath(), // 폰트 파일의 실제 경로
                    BaseFont.IDENTITY_H,        // (iText 2.x 문법)
                    BaseFont.EMBEDDED           // PDF에 폰트를 포함시킴
            );
        } catch (IOException e) {
            e.printStackTrace();
            throw new Exception("PDF 생성 오류: 폰트 파일을 찾을 수 없습니다.");
        }

        // 6. 정리된 HTML(finalHtml)을 렌더러에 설정
        //    (주의: 이미지 경로 등이 'http://'로 시작하는 절대 경로여야 제대로 표시됨)
        renderer.setDocumentFromString(finalHtml);
        renderer.layout();

        // 7. PDF 생성
        renderer.createPDF(outputStream);

        // 8. 스트림 정리 및 byte[] 반환
        outputStream.close();
        return outputStream.toByteArray();
    }

    /**
     * (보조 메서드) HTML을 래핑하여 강제로 한글 폰트(Malgun Gothic)를 사용하도록 CSS를 주입합니다.
     * @param html 원본 HTML
     * @return CSS가 주입된 HTML
     */
    private String wrapHtmlWithFont(String html) {
        // (iTextRenderer가 인식할 수 있는 font-family 이름은 폰트 파일명과 다를 수 있으나,
        //  보통 'Malgun Gothic'과 같이 공백이 있는 이름으로 인식됩니다.)
        return "<html>"
                + "<head>"
                + "<style>"
                + "body { font-family: 'Malgun Gothic', sans-serif !important; }"
                + "</style>"
                + "</head>"
                + "<body>"
                + html
                + "</body>"
                + "</html>";
    }
}