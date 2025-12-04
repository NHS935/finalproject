package kr.or.ddit.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "bid_seoul") // DB 테이블명
@Getter @Setter
public class BidSeoul extends BaseBid {
    // 내용은 비워둬도 부모(BaseBid)꺼 다 물려받음
}