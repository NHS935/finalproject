package kr.or.ddit.vo;

import lombok.Data;

import java.util.Date;

@Data
public class ContractVO {
    private Long rnum;
    private Long id;
    private String content; // <-- 이 컬럼에 HTML이 저장됩니다.
    private String title;
    private Date createdAt;
    private Date updatedAt;
}
