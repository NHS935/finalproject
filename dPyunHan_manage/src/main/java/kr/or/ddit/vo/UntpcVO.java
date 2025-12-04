package kr.or.ddit.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UntpcVO {
    private Date endDe;
    private int untpcId;
    private String iemNm;
    private int rqestUntpc;

    
    // 단위테스트용
//    public UntpcVO(String s, int i) {
//        iemNm=s;
//        rqestUntpc=i;
//    }
}
