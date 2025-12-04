import { useMemo, useState } from "react";
import PageBreadcrumb from "../../components/common/PageBreadCrumb";
import PageMeta from "../../components/common/PageMeta";
import RegionalAverageTable from "../../components/tables/RegionalAverageTable";
import { monthlyData, regions, yearlyData } from "../../data/managementFeeData";


// 시드 기반 난수 생성 (같은 시드면 같은 결과)
const seededRandom = (seed) => {
  const x = Math.sin(seed) * 10000;
  return x - Math.floor(x);
};


// 데이터 값 변형 함수 (년도/월에 따라 일관된 변형)
const transformData = (items, year, month, isYearly) => {
  const seed = parseInt(year) * 100 + (isYearly ? 0 : parseInt(month));


  return items.map((item, idx) => {
    const itemSeed = seed + idx * 17;
    const factor = 0.85 + seededRandom(itemSeed) * 0.3; // 0.85 ~ 1.15 범위


    const newValues = item.values.map((val, vIdx) => {
      if (typeof val !== "number") return val;
      const valSeed = itemSeed + vIdx * 7;
      const valFactor = 0.9 + seededRandom(valSeed) * 0.2; // 0.9 ~ 1.1 범위
      return Math.round(val * factor * valFactor);
    });


    return {
      ...item,
      values: newValues,
      children: item.children ? transformData(item.children, year, month, isYearly) : undefined,
    };
  });
};


export default function RegionalAverage() {
  const [activeTab, setActiveTab] = useState("monthly"); // monthly | yearly
  const [selectedYear, setSelectedYear] = useState("2025");
  const [selectedMonth, setSelectedMonth] = useState("08");
  const [expandedRows, setExpandedRows] = useState(new Set());


  // 선택된 년도/월에 따라 데이터 변형
  const data = useMemo(() => {
    const baseData = activeTab === "monthly" ? monthlyData : yearlyData;
    const isYearly = activeTab === "yearly";


    // 2025년 8월은 원본 데이터 그대로
    if (selectedYear === "2025" && (isYearly || selectedMonth === "08")) {
      return baseData;
    }


    return transformData(baseData, selectedYear, selectedMonth, isYearly);
  }, [activeTab, selectedYear, selectedMonth]);


  // 행 펼침/접힘 토글
  const toggleRow = (id) => {
    const newExpanded = new Set(expandedRows);
    if (newExpanded.has(id)) {
      newExpanded.delete(id);
    } else {
      newExpanded.add(id);
    }
    setExpandedRows(newExpanded);
  };


  return (
    <>
      <PageMeta
        title="관리비 세부항목 지역별 평균 | CYTEMP"
        description="관리비 세부항목 지역별 평균 조회"
      />
      <PageBreadcrumb pageTitle="관리비 세부항목 지역별 평균" />


      <div className="space-y-6">
        {/* 컨트롤 영역 */}
        <div className="rounded-2xl border border-gray-200 bg-white dark:border-gray-800 dark:bg-white/[0.03]">
          <div className="p-4 sm:p-6">
            <div className="flex flex-wrap items-center justify-between gap-4">
              {/* 탭 (왼쪽) */}
              <div className="flex">
                <button
                  onClick={() => setActiveTab("monthly")}
                  className={`px-6 py-2 text-sm font-medium border ${
                    activeTab === "monthly"
                      ? "bg-gray-800 text-white border-gray-800 dark:bg-white dark:text-gray-800"
                      : "bg-white text-gray-700 border-gray-300 dark:bg-gray-800 dark:text-gray-300 dark:border-gray-600"
                  } rounded-l-lg`}
                >
                  월별
                </button>
                <button
                  onClick={() => setActiveTab("yearly")}
                  className={`px-6 py-2 text-sm font-medium border-t border-b border-r ${
                    activeTab === "yearly"
                      ? "bg-gray-800 text-white border-gray-800 dark:bg-white dark:text-gray-800"
                      : "bg-white text-gray-700 border-gray-300 dark:bg-gray-800 dark:text-gray-300 dark:border-gray-600"
                  } rounded-r-lg`}
                >
                  연도별
                </button>
              </div>


              {/* 날짜 선택 */}
              <div className="flex items-center gap-2">
                <select
                  value={selectedYear}
                  onChange={(e) => setSelectedYear(e.target.value)}
                  className="px-3 py-2 text-sm border border-gray-300 rounded-lg bg-white dark:bg-gray-800 dark:border-gray-600 dark:text-gray-300"
                >
                  <option value="2025">2025</option>
                  <option value="2024">2024</option>
                  <option value="2023">2023</option>
                </select>
                {activeTab === "monthly" && (
                  <select
                    value={selectedMonth}
                    onChange={(e) => setSelectedMonth(e.target.value)}
                    className="px-3 py-2 text-sm border border-gray-300 rounded-lg bg-white dark:bg-gray-800 dark:border-gray-600 dark:text-gray-300"
                  >
                    {Array.from({ length: 12 }, (_, i) => {
                      const month = String(i + 1).padStart(2, "0");
                      return (
                        <option key={month} value={month}>
                          {month}
                        </option>
                      );
                    })}
                  </select>
                )}
              </div>


              {/* 오른쪽 빈 공간 (균형 맞추기) */}
              <div className="w-[180px]"></div>
            </div>
          </div>
        </div>


        {/* 테이블 */}
        <RegionalAverageTable 
          data={data}
          expandedRows={expandedRows}
          toggleRow={toggleRow}
          regions={regions}
        />


        {/* 안내 문구 */}
        <div className="p-4 bg-orange-50 dark:bg-orange-900/20 rounded-lg border border-orange-200 dark:border-orange-800">
          <div className="flex items-start gap-3">
            <span className="text-orange-500 text-xl">⚠</span>
            <div className="text-sm text-orange-700 dark:text-orange-400">
              <p className="font-medium text-orange-600 dark:text-orange-300 mb-1">
                관리비를 공개한 단지 전체를 기준으로 집계한 자료임에 유의
              </p>
              <ul className="list-disc list-inside space-y-1">
                <li>
                  특히, 개별사용료 중 난방비 및 급탕비 값의 경우 중앙난방, 지역난방 외에 개별난방(난방비, 급탕비 "0"원)인 단지의 값도 포함되어 있는 점 유의
                </li>
                <li>
                  난방방식 등 특정 기준에 따른 관리비 확인은 '지역별 맞춤형 통계 추출' 메뉴 활용
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}