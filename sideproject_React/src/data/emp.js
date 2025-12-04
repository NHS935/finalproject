import aptMangeData from "./aptManageDB";
const apartments = aptMangeData.rowData;  // ← rowData 배열 추출
// deterministic generator to keep 데이터 고정
let seed = 20250301;
const rng = () => {
  seed = (seed * 1664525 + 1013904223) >>> 0;
  return seed / 2 ** 32;
};

const familyNames = [
  "김",
  "이",
  "박",
  "최",
  "정",
  "조",
  "윤",
  "임",
  "한",
  "서",
  "권",
  "양",
  "문",
  "오",
  "남",
  "신",
  "유",
  "장",
  "노",
  "하",
  "백",
  "고",
  "강",
  "도",
  "변",
  "설",
  "전",
  "허",
  "육",
];

const givenNames = [
  "지훈",
  "서연",
  "도윤",
  "수민",
  "하늘",
  "세라",
  "다인",
  "도형",
  "예림",
  "현우",
  "채린",
  "지안",
  "유리",
  "지민",
  "민서",
  "현준",
  "세영",
  "시온",
  "해진",
  "보민",
  "하진",
  "민규",
  "나연",
  "서준",
  "유진",
  "예린",
  "수혁",
  "채윤",
  "다현",
  "시아",
  "채원",
  "민호",
  "가온",
  "다온",
  "리안",
  "해온",
  "하온",
  "예준",
  "서후",
  "다겸",
  "이안",
  "연우",
  "세빈",
  "채하",
  "소이",
  "태윤",
  "주하",
  "리현",
  "윤하",
  "예나",
  "하율",
  "현이",
  "주희",
];

const departments = {
  행정: ["행정 주무관", "행정 대리", "총무 주임", "민원 담당", "회계 주무관"],
  시설관리: ["시설 기사", "전기 감독", "설비 주임", "보안 반장", "기계 관리"],
  소방안전: ["소방 점검원", "안전 관리자", "비상대응 담당", "소방 교육담당"],
  환경: ["환경 미화원", "조경 기사", "재활용 담당", "에너지 관리", "실내공기 담당"],
};

const statuses = ["재직", "휴직", "퇴사"];

const pad = (num, len = 2) => String(num).padStart(len, "0");
const pick = (list) => list[Math.floor(rng() * list.length)];
const randomName = () => `${pick(familyNames)}${pick(givenNames)}`;
const randomPhone = () =>
  `010-${pad(Math.floor(rng() * 9000) + 1000, 4)}-${pad(
    Math.floor(rng() * 9000) + 1000,
    4
  )}`;
const randomJoinDate = () => {
  const year = 2013 + Math.floor(rng() * 12); // 2013~2024
  const month = pad(1 + Math.floor(rng() * 12));
  const day = pad(1 + Math.floor(rng() * 28));
  return `${year}-${month}-${day}`;
};

// 1~5번은 수동 입력용 기본 틀
const employees = [
  {
    id: 1,
    name: "대덕이",
    role: "관리소장",
    department: "행정",
    joinDate: "2018-04-25",
    status: "재직",
    contact: "010-5732-9835",
    apartmentId: 1,
  },
  {
    id: 2,
    name: "유관순",
    role: "시설 기사",
    department: "시설관리",
    joinDate: "2019-01-15",
    status: "재직",
    contact: "010-2848-5984",
    apartmentId: 1,
  },
  {
    id: 3,
    name: "이순신",
    role: "설비 주임",
    department: "시설관리",
    joinDate: "2012-03-15",
    status: "재직",
    contact: "010-4871-1567",
    apartmentId: 1,
  },
  {
    id: 4,
    name: "홀길동",
    role: "보안 반장",
    department: "시설관리",
    joinDate: "2022-11-10",
    status: "재직",
    contact: "010-6815-8431",
    apartmentId: 1,
  },
];

let seq = employees.length + 1;

apartments.forEach((apt, aptIdx) => {
  // skip 첫번째 단지는 위에서 수동 추가했으니 자동 생성은 2번부터
  if (apt.id === 1) return;

  const baseCount = 6 + (aptIdx % 3); // 6~8 기본
  const extra = Math.floor(rng() * 3); // +0~2
  const total = Math.min(12, baseCount + extra); // 6~10명/단지

  for (let i = 0; i < total; i += 1) {
    const department = pick(Object.keys(departments));
    const role = pick(departments[department]);
    const status = pick(statuses);

    employees.push({
      id: seq,
      name: randomName(),
      role,
      department,
      joinDate: randomJoinDate(),
      status,
      contact: randomPhone(),
      apartmentId: apt.id,
    });
    seq += 1;
  }
});

export default employees;
