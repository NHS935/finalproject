/* 아파트별 서버 사용량 더미 데이터 */

// 1. 아파트 목록 데이터

const apartments = [
  { id: 1, name: "드림타워 1단지", region: "서울", emoji: "🏢" },
  { id: 2, name: "드림타워 2단지", region: "서울", emoji: "🏬" },
  { id: 3, name: "행복마을 아파트", region: "경기", emoji: "🏘️" },
  { id: 4, name: "푸른숲 아파트", region: "인천", emoji: "🌲" },
  { id: 5, name: "햇살아파트", region: "경기", emoji: "☀️" },
  { id: 6, name: "별빛단지", region: "서울", emoji: "⭐" },
];

// 2. 날짜 생성 함수

// months = 몇 개월치 데이터 만들지 
function generateMonths(months = 12) {
  const result = [];
  const today = new Date(); // 오늘 날짜

  // months 개수만큼 반복하면서 과거 월을 생성
  for (let i = months - 1; i >= 0; i--) {
    // 현재 날짜에서 i개월 전으로 이동
    const date = new Date(today.getFullYear(), today.getMonth() - i, 1);

    // YYYY-MM 형식으로 변환
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, "0"); // padStart()는 한 자리 숫자를 두 자리로 만듦 (예: 1 → "01")

    result.push(`${year}-${month}`);
  }

  return result; //["2024-01", "2024-02", ...] 형태의 배열
}

/* 3. 랜덤 사용량 생성 함수 */

 function generateUsage(baseUsage = 1500, variation = 20) {
  // 기본 사용량에서 ±variation% 범위 내에서 랜덤 생성
  const minUsage = baseUsage * (1 - variation / 100);
  const maxUsage = baseUsage * (1 + variation / 100);

  // Math.random()은 0~1 사이 랜덤 숫자 생성
  const usage = minUsage + Math.random() * (maxUsage - minUsage);

  // 소수점 둘째 자리까지 반올림
  return Math.round(usage * 100) / 100;
}

                             // 아파트 정보, 월 배열 ["2024-01", "2024-02", ...] 형태의 배열
function generateApartmentUsage(apartment, months) {
  // 아파트마다 기본 사용량을 다르게 설정 (800GB ~ 2500GB)
  const baseUsage = 800 + Math.random() * 1700;

  // 각 월마다 사용량 생성
  const monthlyUsage = months.map((month) => ({
    month: month,
    usage: generateUsage(baseUsage, 25), // ±25% 변동
    unit: "GB",
  }));

  return {
    aptId: apartment.id,
    aptName: apartment.name,
    region: apartment.region,
    emoji: apartment.emoji,
    monthlyUsage: monthlyUsage,
  };
}

/* 4. 전체 데이터 생성 */

const months = generateMonths(12); // 최근 12개월

// 모든 아파트의 사용량 데이터 생성
const usageData = apartments.map((apt) =>
  generateApartmentUsage(apt, months)
);

/* 5. 통계 데이터 계산 */

// 전체 통계를 계산하는 함수
function calculateStatistics() {
  // 모든 아파트의 최근 월 사용량 합계
  const latestMonthTotal = usageData.reduce((sum, apt) => {
    const latestUsage = apt.monthlyUsage[apt.monthlyUsage.length - 1].usage;
    return sum + latestUsage;
  }, 0);

  // 평균 사용량
  const averageUsage = latestMonthTotal / apartments.length;

  // 최고 사용량 아파트 찾기
  const topApartment = usageData.reduce((max, apt) => {
    const latestUsage = apt.monthlyUsage[apt.monthlyUsage.length - 1].usage;
    const maxUsage = max.monthlyUsage[max.monthlyUsage.length - 1].usage;
    return latestUsage > maxUsage ? apt : max;
  });

  return {
    totalUsage: Math.round(latestMonthTotal * 100) / 100,
    averageUsage: Math.round(averageUsage * 100) / 100,
    topApartment: {
      name: topApartment.aptName,
      usage: topApartment.monthlyUsage[topApartment.monthlyUsage.length - 1].usage,
    },
  };
}

const statistics = calculateStatistics();

/* 6. 데이터 내보내기 */

const serverUsageData = {
  apartments,      // 아파트 목록
  months,          // 월 배열
  usageData,       // 아파트별 사용량 데이터
  statistics,      // 통계 정보
};

export default serverUsageData;