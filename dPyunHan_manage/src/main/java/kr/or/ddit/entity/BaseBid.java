package kr.or.ddit.entity;

import jakarta.persistence.*; // 스프링부트 3.x (2.x면 javax.persistence)
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDateTime;

@MappedSuperclass // "나는 테이블 아님, 상속해주는 녀석임"
@Getter @Setter
@NoArgsConstructor // ★ 이거 필수!
@AllArgsConstructor // 이것도 있으면 좋음
public abstract class BaseBid {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "BID_PBLANC_SN")
    private Long bidPblancSn;

    private String bidSj;       // 공고명 (컬럼명: bid_sj)
    private String bidCn;       // 내용
    private String aptName;

    private LocalDateTime pblancDt;   // 공고일시
    private LocalDateTime bidClosDt;  // 마감일시

    private int scsbMth;        // 낙찰방법 코드
    private int bidSttus;       // 상태 코드
    private int bidGtnRt;       // 보증금율

    private int sptdcAt;        // 현장설명 여부 (0,1)
    private String sptdcPlace;  // 현장설명 장소

    private LocalDateTime regDate;

}