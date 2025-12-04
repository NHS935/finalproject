import { useState, useMemo } from "react";
import PageMeta from "../../components/common/PageMeta";
import ServerUsageChart from "../../components/charts/server-usage/ServerUsageChart";
import serverUsageData from "../../data/serverUsageData";

/* 아파트별 서버 사용량 페이지 */

export default function ServerUsagePage() {

  /***** 1. 상태 관리 *****/


  // 기간 필터: 몇 개월치 데이터를 보여줄지
  const [periodFilter, setPeriodFilter] = useState(12); // 기본값: 12개월

  // 아파트 필터: 어떤 아파트들을 보여줄지
  const [selectedApartments, setSelectedApartments] = useState([1]); // 기본값: 첫 번째 아파트만 선택




  
  /***** 2. 데이터 필터링 (기간별) *****/


  // useMemo: 기간이 변경될 때만 데이터를 다시 계산
  const filteredData = useMemo(() => {
    // 최근 N개월 데이터만 추출
    const filteredMonths = serverUsageData.months.slice(-periodFilter); // -를 붙이면 끝부터 가져옴.

    // 각 아파트의 N개월 간 같은 데이터만 추출.
    const filteredUsage = serverUsageData.usageData.map((apt) => ({
      ...apt, // 전체 apt 정보 가져와서 새 객체 만들기 (자주 사용한다.)
      monthlyUsage: apt.monthlyUsage.slice(-periodFilter),
      
    }));

    return {
      months: filteredMonths,
      usageData: filteredUsage,
    };
  }, [periodFilter]); // periodFilter가 바뀔때만 안의 내용 다시 계산 <- useMemo

  



  /***** 3. 통계 계산 (선택된 아파트 기준) *****/


  const statistics = useMemo(() => {
    // 선택된 아파트만 필터링
    const targetApartments = filteredData.usageData.filter((apt) =>
      selectedApartments.includes(apt.aptId)
    );

    // 선택된 아파트가 없으면 기본값 반환
    if (targetApartments.length === 0) {
      return {
        total: "0",
        average: "0",
        top: {
          name: "-",
          emoji: "",
          usage: "0",
        },
      };
    }

    // 최근 월의 총 사용량 계산
    const latestMonthTotal = targetApartments.reduce((sum, apt) => {
      const latestUsage = apt.monthlyUsage[apt.monthlyUsage.length - 1].usage;
      return sum + latestUsage;
    }, 0);

    // 평균 계산
    const average = latestMonthTotal / targetApartments.length;

    // 최고 사용량 아파트 찾기
    const topApartment = targetApartments.reduce((max, apt) => {
      const latestUsage = apt.monthlyUsage[apt.monthlyUsage.length - 1].usage;
      const maxUsage = max.monthlyUsage[max.monthlyUsage.length - 1].usage;
      return latestUsage > maxUsage ? apt : max;
    });

    return {
      total: latestMonthTotal.toFixed(2),
      average: average.toFixed(2),
      top: {
        name: topApartment.aptName,
        emoji: topApartment.emoji,
        usage: topApartment.monthlyUsage[topApartment.monthlyUsage.length - 1].usage.toFixed(2), // 소수점 둘째 자리까지
      },
    };
  }, [filteredData, selectedApartments]);





  /***** 4. 이벤트 핸들러 *****/


  // 기간 필터 변경
  const handlePeriodChange = (e) => {
    setPeriodFilter(Number(e.target.value));
  };

  // 아파트 체크박스 토글
  const handleApartmentToggle = (aptId) => {
    setSelectedApartments((prev) => {
      // 이미 선택되어 있으면 제거, 없으면 추가
      if (prev.includes(aptId)) {
        return prev.filter((id) => id !== aptId);
      } else {
        return [...prev, aptId];
      }
    });
  };

  // 전체 선택/해제
  const handleSelectAll = () => {
    if (selectedApartments.length === serverUsageData.apartments.length) {
      // 전체 선택 상태면 전체 해제
      setSelectedApartments([]);
    } else {
      // 일부만 선택 상태면 전체 선택
      setSelectedApartments(serverUsageData.apartments.map((apt) => apt.id));
    }
  };

  


  /***** 5. 렌더링 *****/

  return (
    <>
      {/* SEO 메타 태그 */}
      <PageMeta
        title="아파트별 서버 사용량 추이 | 관리 시스템"
        description="각 아파트의 월별 서버 사용량 추이를 차트로 확인하고 통계를 분석하세요"
      />

      <div className="space-y-6">
        {/* ============== 헤더 영역 ============== */}
        <div>
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
            📊 아파트별 서버 사용량 추이
          </h1>
          <p className="mt-2 text-sm text-gray-600 dark:text-gray-400">
            입주민과 관리사무소의 서버 사용량을 아파트별로 확인하세요
          </p>
        </div>

        {/* ============== 필터 영역 ============== */}
        <div className="bg-white dark:bg-gray-800 rounded-lg p-6 shadow-sm border border-gray-200 dark:border-gray-700">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">

            {/* 📅 기간 필터 */}
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                📅 조회 기간
              </label>
              <select
                id="period-filter"
                value={periodFilter}
                onChange={handlePeriodChange}
                className="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg
                         bg-white dark:bg-gray-700 text-gray-900 dark:text-white
                         focus:ring-2 focus:ring-blue-500 focus:border-transparent
                         transition-colors"
              >
                <option value={3}>최근 3개월</option>
                <option value={6}>최근 6개월</option>
                <option value={12}>최근 12개월</option>
              </select>
            </div>

            {/* 🏢 아파트 필터 */}
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                🏢 아파트 선택
              </label>
              <div className="space-y-2">
                {/* 전체 선택/해제 버튼 */}
                <button
                  onClick={handleSelectAll}
                  className="text-sm text-blue-600 dark:text-blue-400 hover:underline"
                >
                  {selectedApartments.length === serverUsageData.apartments.length
                    ? "전체 해제"
                    : "전체 선택"}
                </button>

                {/* 아파트 체크박스 목록 */}
                <div className="grid grid-cols-2 gap-2">
                  {serverUsageData.apartments.map((apt) => (
                    <label
                      key={apt.id}
                      className="flex items-center space-x-2 cursor-pointer
                               p-2 rounded hover:bg-gray-50 dark:hover:bg-gray-700
                               transition-colors"
                    >
                      <input
                        type="checkbox"
                        checked={selectedApartments.includes(apt.id)}
                        onChange={() => handleApartmentToggle(apt.id)}
                        className="w-4 h-4 text-blue-600 border-gray-300 rounded
                                 focus:ring-blue-500 dark:border-gray-600
                                 dark:bg-gray-700"
                      />
                      <span className="text-sm text-gray-700 dark:text-gray-300">
                        {apt.emoji} {apt.name}
                      </span>
                    </label>
                  ))}
                </div>
              </div>
            </div>
          </div>

          {/* 필터 적용 안내 */}
          <div className="mt-4 p-3 bg-blue-50 dark:bg-blue-900/20 rounded-lg">
            <p className="text-sm text-blue-700 dark:text-blue-300">
              💡 <strong>필터 적용 중:</strong> {periodFilter}개월 / {" "}
              {selectedApartments.length === 0
                ? "선택 없음"
                : `${selectedApartments.length}개 아파트`}
            </p>
          </div>
        </div>

        {/* ============== 통계 카드 영역 ============== */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">

          {/* 총 사용량 카드 */}
          <div className="bg-gradient-to-br from-blue-500 to-blue-600 rounded-lg p-6 text-white shadow-lg">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm opacity-90">총 사용량</p>
                <p className="text-3xl font-bold mt-2">{statistics.total}</p>
                <p className="text-sm mt-1">GB</p>
              </div>
              <div className="text-5xl opacity-20">💾</div>
            </div>
          </div>

          {/* 평균 사용량 카드 */}
          <div className="bg-gradient-to-br from-green-500 to-green-600 rounded-lg p-6 text-white shadow-lg">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm opacity-90">평균 사용량</p>
                <p className="text-3xl font-bold mt-2">{statistics.average}</p>
                <p className="text-sm mt-1">GB</p>
              </div>
              <div className="text-5xl opacity-20">📊</div>
            </div>
          </div>

          {/* 최고 사용 단지 카드 */}
          <div className="bg-gradient-to-br from-orange-500 to-orange-600 rounded-lg p-6 text-white shadow-lg">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm opacity-90">최고 사용 단지</p>
                <p className="text-xl font-bold mt-2">
                  {statistics.top.emoji} {statistics.top.name}
                </p>
                <p className="text-lg mt-1">{statistics.top.usage} GB</p>
              </div>
              <div className="text-5xl opacity-20">🏆</div>
            </div>
          </div>
        </div>

        {/* ============== 차트 영역 ============== */}
        <ServerUsageChart
          usageData={filteredData.usageData}
          months={filteredData.months}
          selectedApartments={selectedApartments}
        />

        {/* ============== 안내 메시지 ============== */}
        <div className="bg-gray-50 dark:bg-gray-800 rounded-lg p-6 border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-3">
            📖 사용 가이드
          </h3>
          <ul className="space-y-2 text-sm text-gray-600 dark:text-gray-400">
            <li className="flex items-start">
              <span className="mr-2">•</span>
              <span><strong>기간 선택:</strong> 최근 3개월, 6개월, 12개월 중 선택하여 조회 기간을 변경할 수 있습니다.</span>
            </li>
            <li className="flex items-start">
              <span className="mr-2">•</span>
              <span><strong>아파트 필터:</strong> 특정 아파트만 선택하여 비교할 수 있습니다.</span>
            </li>
            <li className="flex items-start">
              <span className="mr-2">•</span>
              <span><strong>차트 인터랙션:</strong> 범례를 클릭하여 특정 아파트 라인을 숨기거나 표시할 수 있습니다.</span>
            </li>
            <li className="flex items-start">
              <span className="mr-2">•</span>
              <span><strong>마우스 호버:</strong> 차트에 마우스를 올리면 정확한 수치를 확인할 수 있습니다.</span>
            </li>
          </ul>
        </div>
      </div>
    </>
  );
}
