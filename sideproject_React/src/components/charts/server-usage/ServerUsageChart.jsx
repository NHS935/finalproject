import { useMemo } from "react";
import Chart from "react-apexcharts";
import { useTheme } from "../../../context/ThemeContext";

/* 서버 사용량 추이 차트 컴포넌트 */

/* 
@param {array} props.usageData - 아파트별 사용량 데이터 배열
@param {array} props.months - 월 배열 (X축에 표시될 값)
@param {array} props.selectedApartments - 선택된 아파트 ID 배열 (필터링용)
 */

export default function ServerUsageChart({ usageData, months, selectedApartments = [] }) {

  /* 1. 다크모드 설정 가져오기 */
  const { theme } = useTheme();
  const isDark = theme === "dark";

  /* 2. 데이터 필터링 및 변환 */
  const chartSeries = useMemo(() => {
    // 선택된 아파트만 필터링
    const filteredData = usageData.filter((apt) => selectedApartments.includes(apt.aptId));

    // ApexCharts가 원하는 형태로 데이터 변환
    return filteredData.map((apt) => ({
      name: `${apt.emoji} ${apt.aptName}`,  // 범례에 표시될 이름
      data: apt.monthlyUsage.map((item) => Number(item.usage.toFixed(2))),  // 사용량 배열 (숫자)
    }));
  }, [usageData, selectedApartments]);

  /* 3. 차트 색상 팔레트 */
  const chartColors = [
    "#3B82F6", // 파란색 - 드림타워 1단지
    "#10B981", // 초록색 - 드림타워 2단지
    "#F59E0B", // 주황색 - 행복마을
    "#EF4444", // 빨간색 - 푸른숲
    "#8B5CF6", // 보라색 - 햇살아파트
    "#EC4899", // 핑크색 - 별빛단지
  ];

  /* 4. 차트 옵션 설정 */
  const options = {
    chart: {
      type: "area",
      height: 350,
      toolbar: {
        show: true,
      },
    },
    colors: chartColors,
    stroke: {
      curve: "smooth",
      width: 2,
    },
    fill: {
      type: "gradient",
      gradient: {
        opacityFrom: 0.6,
        opacityTo: 0.1,
      },
    },
    xaxis: {
      categories: months,
      labels: {
        style: {
          colors: isDark ? "#9CA3AF" : "#6B7280",
        },
      },
    },
    yaxis: {
      labels: {
        style: {
          colors: isDark ? "#9CA3AF" : "#6B7280",
        },
        formatter: (value) => `${value.toFixed(0)} GB`,
      },
    },
    legend: {
      position: "top",
      horizontalAlign: "left",
      labels: {
        colors: isDark ? "#E5E7EB" : "#374151",
      },
    },
    tooltip: {
      theme: isDark ? "dark" : "light",
      y: {
        formatter: (value) => `${value.toLocaleString()} GB`,
      },
    },
    grid: {
      borderColor: isDark ? "#374151" : "#E5E7EB",
    },
  };




  /* 5. 데이터가 없을 때 처리 */

  if (!usageData || usageData.length === 0) {
    return (
      <div className="flex items-center justify-center h-[350px] bg-gray-50 dark:bg-gray-800 rounded-lg">
        <p className="text-gray-500 dark:text-gray-400">
          📊 표시할 데이터가 없습니다.
        </p>
      </div>
    );
  }





  /* 6. 차트 렌더링 */

  return (
    <div className="w-full">
      {/* 차트 제목 */}
      <div className="mb-4">
        <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
          📈 월별 서버 사용량 추이
        </h3>
        <p className="text-sm text-gray-500 dark:text-gray-400 mt-1">
          최근 {months.length}개월간의 아파트별 서버 사용량을 확인하세요
        </p>
      </div>

      {/* 차트 컴포넌트 */}
      <div className="bg-white dark:bg-gray-800 rounded-lg p-6 shadow-sm border border-gray-200 dark:border-gray-700">
        <div className="min-h-[350px]">
          {chartSeries && chartSeries.length > 0 ? (
            <Chart
              options={options}
              series={chartSeries}
              type="area"
              height={350}
            />
          ) : (
            <div className="flex items-center justify-center h-[350px]">
              <div className="text-center">
                <p className="text-gray-500 dark:text-gray-400 mb-2">
                  ⚠️ 차트 데이터가 비어있습니다
                </p>
                <p className="text-sm text-gray-400">
                  chartSeries 길이: {chartSeries?.length || 0}
                </p>
              </div>
            </div>
          )}
        </div>
      </div>

      {/* 차트 설명 */}
      <div className="mt-4 p-4 bg-blue-50 dark:bg-blue-900/20 rounded-lg">
        <p className="text-sm text-blue-700 dark:text-blue-300">
          💡 <strong>사용 팁:</strong> 범례의 아파트 이름을 클릭하면 해당 라인을 숨기거나 표시할 수 있습니다.
        </p>
      </div>
    </div>
  );
}