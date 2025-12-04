package kr.or.ddit.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class LevyVO {
    private int paySttus;
    private Long rqestSn;
    private Date payTmlmt;
    private String rqestYm;
    private Date rqestDt;
    private int managectTotAmount;
    private String hshldId;
    private String paySn;
}
