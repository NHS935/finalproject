package kr.or.ddit.service.impl;

import kr.or.ddit.mapper.ContractMapper;
import kr.or.ddit.mapper.SigningRequestMapper;
import kr.or.ddit.service.ContractService;
import kr.or.ddit.service.EmailService;
import kr.or.ddit.vo.ContractVO;
import kr.or.ddit.vo.SigningRequestVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
@Slf4j
@RequiredArgsConstructor
public class ContractServiceImpl implements ContractService {

    private final ContractMapper contractMapper;
    private final SigningRequestMapper signingRequestMapper;
    private final EmailService emailService;
    /**
     * DB에서 계약서 내용을 가져옵니다.
     */
    @Override
    public ContractVO getContract(Long id) {
        // 3. Mapper를 호출해 DTO를 받습니다.
        ContractVO contractVO = contractMapper.getContractById(id);

        if (contractVO.getContent() == null) {
            contractVO.setContent(""); // DTO에서 HTML 내용 반환
        }
        return contractVO; // 조회된 게 없으면 빈 문자열
    }

    /**
     * CKEditor에서 받은 HTML 내용을 DB에 저장(수정)합니다.
     */
    @Override
    public void saveContract(Long id,ContractVO contractVO) {
        // 4. DTO에 내용을 담아 Mapper로 전달합니다.
        contractVO.setId(id);

        // (ID가 이미 있으면 update, 없으면 insert 하는 로직이 보통 들어갑니다)
        // 여기서는 예시로 update만 호출
        contractMapper.updateContract(contractVO);
    }
    @Override
    public ContractVO postContract(ContractVO contractVO) {
        contractMapper.postContract(contractVO);

        return contractVO;
    }

    @Override
    public int getTotal(Map<String, Object> map) {
        return this.contractMapper.getTotal(map);
    }

    @Override
    public List<ContractVO> getContractList(Map<String, Object> map) {
        return this.contractMapper.getContractList(map);
    }

    /**
     * 최종 직인본에 대한 서명 요청 토큰을 생성하고 DB에 저장 후, 서명 링크를 이메일로 발송합니다.
     * @param fileGroupSn 직인된 PDF의 파일 그룹 SN
     * @param fileNo 직인된 PDF의 파일 번호
     * @return 생성된 보안 서명 URL (Controller 반환용)
     */
    @Transactional // DB 트랜잭션 관리
    @Override
    public String sendSigningRequest(long fileGroupSn, int fileNo, String toEmail, String ccpyCmpnyNm) {
// 1. 보안 토큰 생성
        String secureToken = UUID.randomUUID().toString();

        // 2. 토큰 만료 시간 설정 (1시간 뒤)
        Instant expiry = Instant.now().plus(1, ChronoUnit.HOURS);
        
        // 3. SIGNING_REQUEST 테이블에 저장할 VO 생성 및 필드 설정
        SigningRequestVO requestVO = new SigningRequestVO();
        requestVO.setSignToken(secureToken);
        requestVO.setFileGroupSn(fileGroupSn);
        requestVO.setFileNo(fileNo);
        requestVO.setCcpyCmpnyNm(ccpyCmpnyNm);
        requestVO.setStatus("PENDING");
        requestVO.setExpiryDate(Date.from(expiry));

        // 4. DB 저장
        signingRequestMapper.insertSigningRequest(requestVO);
        log.info("-> 2. 서명 토큰 및 DB 저장 완료: {}", secureToken);

        // 5. "보안 서명 URL" 생성
        String serverDomain = "http://192.168.141.46:8020"; // ⚠️ 실제 서버 도메인으로 변경해야 합니다.
        String signingUrl = String.format("%s/sign/document?token=%s", serverDomain, secureToken);

        // ----------------------------------------------------
        // 6. 이메일 발송 (EmailService 호출)

        String subject = "[전자 서명 요청] " + ccpyCmpnyNm + "님께 계약서 서명을 요청합니다.";
        String emailBody = "<html>" +
                "<body style='font-family: Arial, sans-serif; line-height: 1.6; padding: 20px;'>" +
                "<h2 style='color: #007bff;'>✍️ 전자 서명 요청 문서 도착</h2>" +
                "<p>안녕하세요, <strong>" + ccpyCmpnyNm + "</strong>님.</p>" +
                "<p>귀하께 전자 서명을 요청하는 계약서 문서가 도착했습니다. 아래 링크를 클릭하여 서명을 진행해 주십시오.</p>" +
                "<div style='margin: 20px 0; text-align: center;'>" +
                "<a href='" + signingUrl + "' target='_blank' style='background-color: #28a745; color: white; padding: 12px 25px; text-decoration: none; border-radius: 5px; font-weight: bold;'>" +
                "서명 문서 열기 (유효 기간: 1시간)</a>" +
                "</div>" +
                "<p>보안상의 이유로 이 링크는 <strong>1시간 후 만료</strong>됩니다. 기간 내에 서명을 완료해 주시기 바랍니다.</p>" +
                "<p style='font-size: 12px; color: #6c757d; border-top: 1px solid #eee; margin-top: 20px; padding-top: 10px;'>서명 링크: " + signingUrl + "</p>" +
                "</body></html>";

        boolean emailSuccess = emailService.sendHtmlEmail(toEmail, subject, emailBody);

        if (!emailSuccess) {
            log.error("서명 링크 이메일 발송 실패: 수신자 {}", toEmail);
            // 이메일 발송 실패 시 추가적인 예외 처리나 알림 로직을 여기에 추가할 수 있습니다.
        }

        // 7. URL 반환
        return signingUrl;
    }
}