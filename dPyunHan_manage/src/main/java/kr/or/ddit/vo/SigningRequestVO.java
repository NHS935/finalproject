package kr.or.ddit.vo;

import java.util.Date;
import lombok.Data;

@Data
public class SigningRequestVO {
    private String signToken;
    private long fileGroupSn;
    private int fileNo;
    private String ccpyCmpnyNm;
    private String status;
    private Date expiryDate;
    private Date regDate;
    private long elctrnSanctnSn;
}