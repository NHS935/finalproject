package kr.or.ddit.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class HshldVO {
    private String hshldId;
    private String adres;
    private int aptcmpl;
    private int ho;
    private int prvuseAr;
    private int suplyAr;
    private int cmmntyUseAt;
    private int residesttus;
    private String mvnDe;
    private String lvhsDe;

    // 단위 테스트용
//    public HshldVO(String s) {
//        hshldId=s;
//    }
}
