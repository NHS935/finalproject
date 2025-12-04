import { useState } from "react";
import AptPriceChart from "./AptPriceChart";
import NaverMap from "./NaverMap";
import NaverMapTable from "./NaverMapTable";

function AptDetailCard({ apt }) {
  if (!apt) {
    return (
      <div className="mt-3 rounded-xl border border-dashed border-gray-300 p-3 text-xs text-gray-400">
        아파트를 클릭하면 상세정보가 보여집니다.
      </div>
    );
  }

  return (
    <div className="mt-3 rounded-xl border border-gray-200 bg-gray-50 p-3 text-xs">
      <div className="flex justify-between items-center mb-1">
        <h3 className="text-sm font-semibold text-gray-800">{apt.name}</h3>
        <span className="text-[10px] rounded-full bg-emerald-100 px-2 py-0.5 text-emerald-700">
          {apt.district}
        </span>
      </div>
      <p className="text-gray-500 mb-2">{apt.address}</p>

      <div className="grid grid-cols-2 gap-2">
        <div>
          <div className="text-[11px] text-gray-500">현재 평단가</div>
          <div className="text-sm font-semibold">
            {apt.currentPrice.toLocaleString()} {apt.priceUnit}
          </div>
        </div>
        <div>
          <div className="text-[11px] text-gray-500">총가격</div>
          <div className="text-sm font-semibold">
            {apt.totalPrice?.toLocaleString()} 만원
          </div>
        </div>
        <div>
          <div className="text-[11px] text-gray-500">전용면적</div>
          <div className="text-sm">
            {apt.areaPyeong?.toLocaleString()}평
          </div>
        </div>
        <div>
          <div className="text-[11px] text-gray-500">준공연도</div>
          <div className="text-sm">{apt.completionYear}년</div>
        </div>
        <div>
          <div className="text-[11px] text-gray-500">세대수</div>
          <div className="text-sm">
            {apt.householdCount.toLocaleString()} 세대
          </div>
        </div>
        <div>
          <div className="text-[11px] text-gray-500">인근 평균 평단가</div>
          <div className="text-sm">
            {apt.nearbyAvgPrice.toLocaleString()} {apt.priceUnit}
          </div>
        </div>
      </div>

      {/* 차트 */}
      <AptPriceChart apt={apt} />
    </div>
  );
}

function NaverMapLayout() {
  const [selectedApt, setSelectedApt] = useState(null);

  const handleSelectApt = (apt) => {
    setSelectedApt(apt);
  };

  return (
    <div className="flex gap-4 w-full">
      {/* 좌측: 테이블 */}
      <div className="w-[520px] rounded-2xl border border-gray-200 bg-white p-2 dark:border-gray-800 dark:bg-white/[0.03]">
        <NaverMapTable onRowClick={handleSelectApt} selectedApt={selectedApt} />
      </div>

      {/* 우측: 지도 + 카드 */}
      <div className="flex-1 flex flex-col rounded-2xl border border-gray-200 bg-white p-3 dark:border-gray-800 dark:bg-white/[0.03]">
        <NaverMap selectedApt={selectedApt} onAptSelect={handleSelectApt} />
        {/* 클릭한 아파트 상세 정보 */}
        <AptDetailCard apt={selectedApt} />
      </div>
    </div>
  );
}

export default NaverMapLayout;
