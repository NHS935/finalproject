package kr.or.ddit.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ManagectLevyDetailVO {
    private Long managectLevyDetailSn;
    private String iemNm;
    private int rqestAmount;
    private int rqestStdr;
    private int rqestUntpc;
    private Long rqestSn;

}
