package kr.or.ddit.service;

import jakarta.annotation.PostConstruct;
import kr.or.ddit.mapper.HshldMapper;
import kr.or.ddit.mapper.MtinspMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Profile;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

@Service
@Profile("server") // "server" 프로필일 때만 활성화
@RequiredArgsConstructor
public class MeterSchedulerService {

    private final HshldMapper hshldMapper; // HSHLD 테이블 조회용
    private final MtinspMapper mtinspMapper;         // MTINSP 테이블 삽입용

    private final Random random = new Random();

    // 💡[추가] 시뮬레이션 시작 및 종료 일시 (2025년 10월 1일 00:00 부터 11월 19일 23:59까지)
    private static final LocalDateTime START_DATETIME = LocalDateTime.of(2025, 12, 1, 0, 0);
    private static final LocalDateTime END_DATETIME = LocalDateTime.of(2025, 12, 3, 23, 59);

    // 💡[추가] 현재 시뮬레이션 일시를 저장할 상태 변수
    private LocalDateTime simulatedDateTime;

    // 💡[추가] 매일 데이터 생성 시, 시간을 고정할 기준 (예: 12시 00분)
    //         하루에 한 번만 데이터를 생성하므로, 특정 시점으로 고정합니다.
    private static final LocalTime FIXED_DATA_TIME = LocalTime.of(12, 0);

    // 정상 범위 설정 (항목별)
    private static final int ELEC_MIN = 100; // 전기
    private static final int ELEC_MAX = 150;
    private static final int GAS_MIN = 20;   // 가스
    private static final int GAS_MAX = 40;
    private static final int WATER_MIN = 50; // 수도
    private static final int WATER_MAX = 80;

    // [수정] 비정상 데이터를 생성할 시간 (0~23)
    // private static final int ABNORMAL_HOUR = 2; // <-- 이 줄 삭제

    // [추가] 비정상 데이터 생성 시작 시간 (시)
    private static final int ABNORMAL_START_HOUR = 14; // 예: 오후 2시
    // [추가] 비정상 데이터 생성 시작 시간 (분)
    private static final int ABNORMAL_START_MINUTE = 30; // 30분

    // [추가] 비정상 데이터 생성 종료 시간 (시)
    private static final int ABNORMAL_END_HOUR = 15; // 오후 3시
    // [추가] 비정상 데이터 생성 종료 시간 (분)
    private static final int ABNORMAL_END_MINUTE = 0; // 00분 (14:30 ~ 15:00)

    // [추가] 비정상 데이터를 적용할 특정 세대 ID
    private static final String ABNORMAL_TARGET_HSHLD_ID = "11010101";

    // [추가] 비정상 범위 설정 (항목별)
    private static final int ELEC_ABNORMAL_MIN = 1000;
    private static final int ELEC_ABNORMAL_MAX = 1200;
    private static final int GAS_ABNORMAL_MIN = 500;
    private static final int GAS_ABNORMAL_MAX = 600;
    private static final int WATER_ABNORMAL_MIN = 300;
    private static final int WATER_ABNORMAL_MAX = 400;


    // 💡[추가] 서비스 시작 시점에 시뮬레이션 날짜를 초기화합니다.
    @PostConstruct
    public void init() {
        this.simulatedDateTime = START_DATETIME;
        System.out.println("[스케줄러 초기화] 시뮬레이션 시작 일시: " + this.simulatedDateTime.toLocalDate());
    }
    /**
     * 5분마다 모든 세대의 (전기, 가스, 수도) 데이터를 일괄 생성 및 삽입
     */
    @Scheduled(cron = "* * * 11 * *")
    public void generateAllHouseholdMeters() {
        // 💡[추가] 시뮬레이션 종료 일시를 초과했는지 체크
        if (simulatedDateTime.isAfter(END_DATETIME)) {
            System.out.println(LocalDateTime.now() + " [스케줄러] 시뮬레이션 종료 일시(" + END_DATETIME.toLocalDate() + ")를 초과하여 작업을 종료합니다. (최종 시도 날짜: " + simulatedDateTime.toLocalDate() + ")");
            return;
        }

        // [수정] 현재 시간 및 비정상 시간 범위 설정
//        LocalDateTime now = LocalDateTime.now();
        // 💡[수정] 현재 시뮬레이션 데이터가 삽입될 최종 시간 (시뮬레이션 날짜의 12:00:00)
        final LocalDateTime now = LocalDateTime.of(this.simulatedDateTime.toLocalDate(), FIXED_DATA_TIME);

        System.out.println(LocalDateTime.now() + " [스케줄러] " + now.toLocalDate() + " 일자 (" + now.toLocalTime() + " 시점)의 검침 데이터 생성을 시작합니다.");


        // [수정] 비정상 시간 범위 체크 로직 (dataInsertionTime 기준)
        // 오늘 날짜 기준으로 비정상 시작/종료 시간 객체 생성
        LocalDateTime abnormalStartTime = now.withHour(ABNORMAL_START_HOUR)
                .withMinute(ABNORMAL_START_MINUTE)
                .withSecond(0).withNano(0);
        LocalDateTime abnormalEndTime = now.withHour(ABNORMAL_END_HOUR)
                .withMinute(ABNORMAL_END_MINUTE)
                .withSecond(0).withNano(0);

        // [수정] 현재 시간이 비정상 시간 범위에 포함되는지 체크
        // (abnormalStartTime <= now < abnormalEndTime)
        final boolean isAbnormalTime = (!now.isBefore(abnormalStartTime)) && (now.isBefore(abnormalEndTime));

        if (isAbnormalTime) {
            System.out.println("[스케줄러] 비정상 시간("
                    + String.format("%02d:%02d", ABNORMAL_START_HOUR, ABNORMAL_START_MINUTE) + " ~ "
                    + String.format("%02d:%02d", ABNORMAL_END_HOUR, ABNORMAL_END_MINUTE)
                    + ")이므로, 지정 값을 벗어난 데이터를 생성합니다.");
        }
        // 1. HSHLD 테이블에서 검침 대상 세대 ID 목록을 가져옵니다.
        List<String> householdIds = hshldMapper.getAllHouseholdIds();
        int householdCount = (householdIds != null) ? householdIds.size() : 0;

        if (householdCount == 0) {
            System.out.println("[스케줄러] 검침 대상 세대가 없어 작업을 종료합니다.");
            return;
        }

        // [수정 1] 필요한 PK 개수 계산 (세대 수 * 3)
        int pkCountNeeded = householdCount * 3;

        // [수정 2] DB에서 필요한 PK 목록을 미리 가져옴
        List<Long> preFetchedPKs = mtinspMapper.getNextMtinspPKs(pkCountNeeded);

        // [수정 3] IntStream.range를 사용하여 인덱스(i) 기반으로 batchList 생성
        List<Map<String, Object>> batchList = IntStream.range(0, householdCount) // 0부터 (세대수-1) 까지의 숫자(인덱스)를 생성
                .boxed() // IntStream을 Stream<Integer>로 변환
                .flatMap(i -> { // 인덱스 'i' (0, 1, 2, ...)

                    // i번째 세대 ID
                    String householdId = householdIds.get(i);

                    // i번째 세대에 할당할 3개의 PK 계산
                    // i=0 -> PK 인덱스 0, 1, 2
                    // i=1 -> PK 인덱스 3, 4, 5
                    Long elecPk = preFetchedPKs.get(i * 3);
                    Long gasPk = preFetchedPKs.get(i * 3 + 1);
                    Long waterPk = preFetchedPKs.get(i * 3 + 2);

                    int elecValue;
                    int gasValue;
                    int waterValue;

                    boolean isTargetForAbnormal = isAbnormalTime &&
                            householdId.equals(ABNORMAL_TARGET_HSHLD_ID);

                    // [수정] 비정상 시간 여부에 따라 다른 값 생성
                    if (isTargetForAbnormal) {
                        // 비정상 범위에서 랜덤 값 생성
                        elecValue = random.nextInt(ELEC_ABNORMAL_MAX - ELEC_ABNORMAL_MIN + 1) + ELEC_ABNORMAL_MIN;
                        gasValue = random.nextInt(GAS_ABNORMAL_MAX - GAS_ABNORMAL_MIN + 1) + GAS_ABNORMAL_MIN;
                        waterValue = random.nextInt(WATER_ABNORMAL_MAX - WATER_ABNORMAL_MIN + 1) + WATER_ABNORMAL_MIN;
                    } else {
                        // (기존 로직) 정상 범위에서 랜덤 값 생성
                        elecValue = random.nextInt(ELEC_MAX - ELEC_MIN + 1) + ELEC_MIN;
                        gasValue = random.nextInt(GAS_MAX - GAS_MIN + 1) + GAS_MIN;
                        waterValue = random.nextInt(WATER_MAX - WATER_MIN + 1) + WATER_MIN;
                    }

                    // 3-1. 전기
                    Map<String, Object> elecData = createMeterData(householdId, "전기", elecValue, elecPk, now);

                    // 3-2. 가스
                    Map<String, Object> gasData = createMeterData(householdId, "가스", gasValue, gasPk, now);

                    // 3-3. 수도
                    Map<String, Object> waterData = createMeterData(householdId, "수도", waterValue, waterPk, now);

                    // 3개의 Map을 Stream으로 반환
                    return Stream.of(elecData, gasData, waterData);
                })
                .collect(Collectors.toList()); // 최종 결과를 List로 "한 번에" 수집

        System.out.println("batchList: " + batchList);

        // 4. 데이터가 준비되면 DB에 일괄 삽입
        try {
            mtinspMapper.insertBatchMeterData(batchList);
            System.out.println("[스케줄러] 총 " + batchList.size() + "건 ("
                    + householdIds.size() + "세대 x 3항목) 데이터 삽입 완료.");
        } catch (Exception e) {
            System.err.println("[스케줄러] 일괄 삽입 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        }

        // 💡[추가] 시뮬레이션 날짜를 하루 증가
        this.simulatedDateTime = this.simulatedDateTime.plusDays(1);
        System.out.println("[스케줄러] 작업 완료. 다음 시뮬레이션 날짜: " + this.simulatedDateTime.toLocalDate());
    }

    /**
     * MyBatis 매퍼에 전달할 Map 객체를 생성하는 헬퍼 메서드
     */
    private Map<String, Object> createMeterData(String householdId, String itemName, int usageQty, Long mtinspSn, LocalDateTime mtinspDt) {
        Map<String, Object> data = new HashMap<>();
        data.put("MTINSP_SN", mtinspSn);      // [추가] 미리 할당받은 PK
        data.put("HSHLD_ID", householdId);
        data.put("IEM_NM", itemName);
        data.put("USGQTY", usageQty);
        data.put("MTINSP_DT", mtinspDt);
        return data;
    }
}
