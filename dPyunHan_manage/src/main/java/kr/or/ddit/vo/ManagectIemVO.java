package kr.or.ddit.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ManagectIemVO {
    private int managectIemId;
    private String iemNm;
    private int managectAmount;
    private String managectIemStdrCode;
    private String managectUseDe;

//    public ManagectIemVO(String s, int i) {
//        iemNm=s;
//        managectAmount=i;
//    }
}
