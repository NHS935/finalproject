package kr.or.ddit.scheduler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import kr.or.ddit.service.VisitVhicleService;

@Component
public class VisitVhcleScheduler {

    @Autowired
    private VisitVhicleService visitVhicleService;

    // 매월 1일 0시 초기화
    @Scheduled(cron = "0 0 0 1 * ?")
    public void resetMonthlyParkingTime() {
        visitVhicleService.resetMonthlyTime();
        System.out.println("매월 1일 남은 주차시간 120시간으로 초기화 완료!");
    }
}
