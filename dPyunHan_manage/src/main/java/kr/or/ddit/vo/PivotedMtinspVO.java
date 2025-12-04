package kr.or.ddit.vo;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Data
public class PivotedMtinspVO {
    // 날짜/시간 (java.util.Date 또는 Timestamp)
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date mtinspDt;

    // SQL의 AS 별칭과 이름/타입을 똑같이 맞춥니다.
    private double electricUsage;
    private double waterUsage;
    private double gasUsage;
}
