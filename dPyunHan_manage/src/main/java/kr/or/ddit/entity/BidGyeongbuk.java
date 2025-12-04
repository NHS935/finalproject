package kr.or.ddit.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "bid_gyeongbuk")
@Getter @Setter
public class BidGyeongbuk extends BaseBid {
}