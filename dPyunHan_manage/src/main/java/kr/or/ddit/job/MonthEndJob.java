package kr.or.ddit.job;


import kr.or.ddit.service.ManagectAutoService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.scheduling.annotation.Scheduled;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

@Configuration
@Profile("server") // "server" 프로필일 때만 활성화
@RequiredArgsConstructor
public class MonthEndJob {
    private final ManagectAutoService managectAutoService;

    // cron =        "초 분 시 일 월 요일"
    @Scheduled(cron = "0 0 1  1 * ?", zone = "Asia/Seoul")
    public void runMonthEndSettlement() {

        // 1. 오늘 날짜 (e.g., 11월 1일)
        LocalDate today = LocalDate.now(ZoneId.of("Asia/Seoul"));

        // 2. 청구 대상월 (e.g., 10월)
        LocalDate lastMonth = today.minusMonths(1);

        // 3. (수정) Service에 전달할 "yyMM" 형식의 String 생성 (e.g., "2509")
        // (Service/Util이 "yyyyMM"을 쓰면 포맷 변경)
        String billingMonth = lastMonth.format(DateTimeFormatter.ofPattern("yyyyMM"));

        // 4. (수정) Service 호출
        try {
            managectAutoService.createMonthlyBills(billingMonth);
            System.out.println("[MonthEndJob] 작업 성공: " + billingMonth + "월분 청구 생성 완료");
        } catch (Exception e) {
            // (에러 로그 기록)
            System.err.println("[MonthEndJob] 작업 실패: " + billingMonth + "월분 청구 생성 중 오류 발생");
            e.printStackTrace();
        }
    }
}
