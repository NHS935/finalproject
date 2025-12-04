package kr.or.ddit.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "BID_PBLANC") // 실제 오라클 테이블명
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
public class BidPblanc {

    @Id
    @Column(name = "BID_PBLANC_SN") // PK 컬럼
    private Long bidPblancSn;

    @Column(name = "BID_SJ")
    private String bidSj;

    @Column(name = "SCSB_MTH")
    private int scsbMth; // 낙찰방법 (코드)

    @Column(name = "BID_CN")
    private String bidCn;

    @Column(name = "PBLANC_DT")
    private LocalDateTime pblancDt;

    @Column(name = "BID_CLOS_DT")
    private LocalDateTime bidClosDt;

    @Column(name = "BID_STTUS")
    private int bidSttus; // 상태 (코드)

    @Column(name = "BID_GTN_RT")
    private int bidGtnRt; // 보증금율

    @Column(name = "SPTDC_AT")
    private int sptdcAt; // 현장설명회 여부

    @Column(name = "SPTDC_PLACE")
    private String sptdcPlace;

    // 만약 APT_NAME(단지명) 컬럼이 테이블에 없다면?
    // 1. 조인해서 가져오거나
    // 2. 일단 "우리 아파트"로 고정하거나
    // 여기서는 일단 필드 선언 안 함 (Service에서 처리)
}