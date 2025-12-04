const cuteBaseNames = [
  "드림타워",
  "드림캐슬",
  "행복마을",
  "푸른숲",
  "햇살마을",
  "햇살아파트",
  "별빛단지",
  "호수마을",
  "노을리버",
  "해솔마을",
  "가온마을",
  "바람숲",
  "라온에코",
  "별무리",
  "솔바람채",
  "초록마을",
  "은하수마을",
  "푸른강변",
  "하늘마을",
  "달빛채",
  "무지개타운",
  "봄내음마을",
];

const realisticBaseNames = [
  "래미안",
  "자이",
  "푸르지오",
  "힐스테이트",
  "아이파크",
  "더샵",
  "e편한세상",
  "롯데캐슬",
  "센트레빌",
  "포레나",
  "호반써밋",
  "중흥S클래스",
  "우미린",
  "코오롱하늘채",
  "벽산블루밍",
  "경남아너스빌",
  "아이파크씨티",
  "리버시티",
  "클래식시티",
];

const regionDistricts = {
  서울: ["강남구", "송파구", "마포구", "성동구", "용산구", "광진구", "은평구", "노원구", "동작구"],
  경기: [
    "성남시 분당구",
    "수원시 영통구",
    "용인시 기흥구",
    "고양시 덕양구",
    "부천시 원미구",
    "남양주시 다산동",
    "안양시 동안구",
    "김포시 구래동",
    "의정부시 민락동",
  ],
  인천: ["연수구", "남동구", "미추홀구", "부평구", "계양구", "서구"],
  부산: ["해운대구", "수영구", "동래구", "남구", "북구", "연제구"],
  대구: ["수성구", "동구", "북구", "달서구", "중구"],
  광주: ["서구", "남구", "북구", "동구"],
  대전: ["유성구", "서구", "중구", "동구"],
  울산: ["남구", "북구", "중구", "동구"],
  강원: ["춘천시", "원주시", "강릉시"],
  충북: ["청주시 청원구", "청주시 흥덕구", "충주시"],
  충남: ["천안시 서북구", "아산시", "공주시"],
  전북: ["전주시 덕진구", "익산시", "군산시"],
  전남: ["여수시", "순천시", "목포시"],
  경북: ["포항시 북구", "경주시", "구미시"],
  경남: ["창원시 성산구", "김해시", "진주시"],
  제주: ["제주시 애월읍", "제주시 연동", "서귀포시 대정읍"],
  세종: ["세종시 한솔동", "세종시 보람동", "세종시 새롬동"],
};

const surnames = [
  "김", "이", "박", "최", "정", "조", "윤", "임", "한", "서",
  "권", "양", "문", "오", "남", "신", "유", "장", "노", "하",
  "백", "고", "강", "도", "변", "설", "전", "허", "육",
];

const givenNames = [
  "지훈", "서연", "도윤", "수민", "하늘", "세라", "다인", "도형", "예림", "현우",
  "채린", "지안", "유리", "지민", "민서", "현준", "세영", "시온", "해진", "보민",
  "하진", "민규", "나연", "서준", "유진", "예린", "수혁", "채윤", "다현", "시아",
  "채원", "민호", "가온", "다온", "리안", "해온", "하온", "예준", "서후", "다겸",
  "이안", "연우", "세빈", "채하", "소이", "태윤", "주하", "리현", "윤하", "예나",
  "하율", "현이", "주희",
];

// 시설 정보
const ALL_FACILITIES = [
  "헬스장", "수영장", "스쿼시장", "테니스장", "요가/필라테스 스튜디오",
  "골프 연습장", "영화관", "도서관/독서실", "북카페", "스터디룸/회의실",
  "예술관/갤러리", "어린이집", "키즈카페/놀이터", "물놀이장(워터파크)",
  "사우나/찜질방", "카페테리아/식당", "게스트하우스", "편의점",
  "경로당", "주민회의실/커뮤니티센터"
];

const pad2 = (num) => num.toString().padStart(2, "0");
const pickOne = (list) => list[Math.floor(Math.random() * list.length)];
const usedManagers = new Set();

const randomManager = () => {
  let candidate = "";
  let attempts = 0;
  while (!candidate || usedManagers.has(candidate)) {
    const first = pickOne(surnames);
    const given = pickOne(givenNames);
    candidate = `${first}${given}`;
    attempts += 1;
    if (attempts > 200) break;
  }
  usedManagers.add(candidate);
  return candidate;
};

const randomBuiltDate = () => {
  const year = 2000 + Math.floor(Math.random() * 25);
  const month = pad2(Math.ceil(Math.random() * 12));
  const day = pad2(Math.max(2, Math.ceil(Math.random() * 27)));
  return `${year}-${month}-${day}`;
};

const randomUnits = () => Math.floor(Math.random() * 2101) + 400;

const randomContact = (region) => {
  const prefixMap = {
    서울: "02",
    경기: "031",
    인천: "032",
    부산: "051",
    대구: "053",
    광주: "062",
    대전: "042",
    울산: "052",
    강원: "033",
    충북: "043",
    충남: "041",
    전북: "063",
    전남: "061",
    경북: "054",
    경남: "055",
    제주: "064",
    세종: "044",
  };
  const prefix = prefixMap[region] || "070";
  const mid = (Math.floor(Math.random() * 800) + 200).toString().padStart(4, "0");
  const tail = (Math.floor(Math.random() * 9000) + 1000).toString().padStart(4, "0");
  return `${prefix}-${mid}-${tail}`;
};

// 랜덤 시설 선택 함수
const randomFacilities = () => {
  const count = Math.floor(Math.random() * 11) + 5; // 5~15개
  const shuffled = [...ALL_FACILITIES].sort(() => Math.random() - 0.5);
  return shuffled.slice(0, count);
};

const usedApartmentNames = new Set();

const rowData = [
  {
    id: 1,
    name: "D-편한세상아파트",
    address: "대전시 중구 오류동",
    mngOfficeNum: "042-123-4567",
    mngOfficerNm: "김대표",
    unit: 600,
    constDt: "2025-05-01",
    facilities: randomFacilities(),
  },
];

const addApartment = (name) => {
  if (usedApartmentNames.has(name) || rowData.length >= 100) return false;
  const region = pickOne(Object.keys(regionDistricts));
  const district = pickOne(regionDistricts[region]);
  rowData.push({
    id: rowData.length + 1,
    name: name,
    address: `${region} ${district}`,
    mngOfficeNum: randomContact(region),
    mngOfficerNm: randomManager(),
    unit: randomUnits(),
    constDt: randomBuiltDate(),
    facilities: randomFacilities(),
  });
  usedApartmentNames.add(name);
  return true;
};

const requiredNames = [
  "별빛단지",
  "푸른숲 아파트",
  "햇살아파트",
  "행복마을 아파트",
  "드림타워",
];

const shuffle = (list) =>
  [...list].map((v) => [Math.random(), v]).sort((a, b) => a[0] - b[0]).map(([, v]) => v);

const pickBaseName = () => {
  return Math.random() < 0.7 ? pickOne(cuteBaseNames) : pickOne(realisticBaseNames);
};

requiredNames.forEach((name) => addApartment(name));

const TARGET_MAIN = 93;
const basePool = shuffle([...cuteBaseNames, ...realisticBaseNames]).filter(
  (name) => !usedApartmentNames.has(name)
);

for (let idx = 0; idx < basePool.length && rowData.length < TARGET_MAIN; idx += 1) {
  const baseName = basePool[idx];
  const isComplex = Math.random() < 0.65;
  const remainingSlots = TARGET_MAIN - rowData.length;
  const clusterSize = Math.min(Math.floor(Math.random() * 5) + 1, remainingSlots);

  if (isComplex && clusterSize > 1) {
    for (let i = 1; i <= clusterSize && rowData.length < 100; i += 1) {
      addApartment(`${baseName} ${i}단지`);
    }
  } else {
    addApartment(baseName);
  }
}

while (rowData.length < TARGET_MAIN) {
  const baseName = pickBaseName();
  const suffix = `${Math.floor(Math.random() * 900) + 101}동`;
  const name = usedApartmentNames.has(baseName) ? `${baseName} ${suffix}` : baseName;
  addApartment(name);
}

const tailNames = [
  "라온타운",
  "푸른솔마을",
  "해송에코",
  "달보드레",
  "초록숲채",
  "별무리타운",
  "드림힐",
];

tailNames.forEach((name) => {
  if (rowData.length >= 100) return;
  let candidate = name;
  let n = 2;
  while (usedApartmentNames.has(candidate)) {
    candidate = `${name} ${n}동`;
    n += 1;
  }
  addApartment(candidate);
});

while (rowData.length < 100) {
  const baseName = pickBaseName();
  let candidate = baseName;
  let n = 2;
  while (usedApartmentNames.has(candidate)) {
    candidate = `${baseName} ${n}동`;
    n += 1;
  }
  addApartment(candidate);
}

const colDefs = [
  {
    headerName: '#',
    valueGetter: params => params.node.rowIndex + 1,
    sortable: false,
    filter: false,
    flex: 1,
  },
  {
    field: "name",
    headerName: "이름",
    flex: 2,
  },
  {
    field: "address",
    headerName: "주소",
    flex: 2,
  },
  {
    field: "mngOfficeNum",
    headerName: "관리사무소 전화번호",
    flex: 2,
  },
  {
    field: "mngOfficerNm",
    headerName: "관리소장",
    flex: 1,
  },
  {
    field: "unit",
    headerName: "세대 수",
    flex: 1,
  },
  {
    field: "constDt",
    headerName: "준공일자",
    flex: 1,
  },
];

const aptMangeData = { rowData, colDefs };

export default aptMangeData;