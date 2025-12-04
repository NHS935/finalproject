package kr.or.ddit.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class MtinspVO {
    private int mtinspSn;
    private String hshldId;
    private String iemNm;
    private int usgqty;
    private String mtinspDt;
    
    // 단위 테스트
//    public MtinspVO(String s1, String s2, int i) {
//        hshldId=s1;
//        iemNm=s2;
//        usgqty=i;
//    }
}
