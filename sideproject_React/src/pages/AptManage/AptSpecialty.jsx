import Checkbox from "../../components/form/input/Checkbox";
import Button from "../../components/ui/button/Button";
import { Modal } from "../../components/ui/modal";
import { useModal } from "../../hooks/useModal";
import { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import aptMangeData from "../../data/aptManageDB";

// 모든 시설 목록 (20개)
const ALL_FACILITIES = [
  "헬스장", "수영장", "스쿼시장", "테니스장", "요가/필라테스 스튜디오",
  "골프 연습장", "영화관", "도서관/독서실", "북카페", "스터디룸/회의실",
  "예술관/갤러리", "어린이집", "키즈카페/놀이터", "물놀이장(워터파크)",
  "사우나/찜질방", "카페테리아/식당", "게스트하우스", "편의점",
  "경로당", "주민회의실/커뮤니티센터"
];

export default function AptSpecialty() {
  const [facilityStates, setFacilityStates] = useState({});
  const { isOpen, openModal, closeModal } = useModal();
  const { id } = useParams();
  const [data, setData] = useState(null);

  useEffect(() => {
    const matched = aptMangeData.rowData.find(item => item.id === Number(id));
    setData(matched);
    
    // 초기화: 아파트에 있는 시설만 true
    const initialState = {};
    ALL_FACILITIES.forEach((facility) => {
      initialState[facility] = matched?.facilities?.includes(facility) ? true : false;
    });
    setFacilityStates(initialState);
  }, [id]);

  const handleSave = () => {
    const checkedFacilities = Object.entries(facilityStates)
      .filter(([_, isChecked]) => isChecked)
      .map(([facility, _]) => facility);
    console.log("Saving facilities:", checkedFacilities);
    closeModal();
  };

  const handleCheckboxChange = (facility, checked) => {
    const isAvailable = data.facilities?.includes(facility) || false;
    
    // 없는 시설은 절대 체크 불가능
    if (!isAvailable) {
      return;
    }
    
    setFacilityStates(prev => ({
      ...prev,
      [facility]: checked,
    }));
  };

  if (!data) return <div>데이터를 찾을 수 없습니다.</div>;

  const checkedCount = Object.values(facilityStates).filter(v => v).length;

  return (
    <>
      <div className="p-5 border border-gray-200 rounded-2xl dark:border-gray-800 lg:p-6 bg-white/50 dark:bg-white/[0.02] backdrop-blur-sm">
        <div className="flex flex-col gap-6">
          {/* 헤더 */}
          <div className="flex items-center justify-between">
            <div>
              <h4 className="text-lg font-semibold text-gray-800 dark:text-white/90">
                시설 정보
              </h4>
              <p className="text-xs text-gray-500 dark:text-gray-400 mt-1">
                {checkedCount} / {ALL_FACILITIES.length}개 보유
              </p>
            </div>
            <button
              onClick={openModal}
              className="flex items-center justify-center gap-2 rounded-full border border-gray-300 bg-white px-4 py-2.5 text-sm font-medium text-gray-700 shadow-theme-xs hover:bg-gray-50 hover:text-gray-800 dark:border-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:hover:bg-white/[0.03] dark:hover:text-gray-200 transition-all duration-200 whitespace-nowrap"
            >
              <svg
                className="fill-current"
                width="16"
                height="16"
                viewBox="0 0 18 18"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  fillRule="evenodd"
                  clipRule="evenodd"
                  d="M15.0911 2.78206C14.2125 1.90338 12.7878 1.90338 11.9092 2.78206L4.57524 10.116C4.26682 10.4244 4.0547 10.8158 3.96468 11.2426L3.31231 14.3352C3.25997 14.5833 3.33653 14.841 3.51583 15.0203C3.69512 15.1996 3.95286 15.2761 4.20096 15.2238L7.29355 14.5714C7.72031 14.4814 8.11172 14.2693 8.42013 13.9609L15.7541 6.62695C16.6327 5.74827 16.6327 4.32365 15.7541 3.44497L15.0911 2.78206ZM12.9698 3.84272C13.2627 3.54982 13.7376 3.54982 14.0305 3.84272L14.6934 4.50563C14.9863 4.79852 14.9863 5.2734 14.6934 5.56629L14.044 6.21573L12.3204 4.49215L12.9698 3.84272ZM11.2597 5.55281L5.6359 11.1766C5.53309 11.2794 5.46238 11.4099 5.43238 11.5522L5.01758 13.5185L6.98394 13.1037C7.1262 13.0737 7.25666 13.003 7.35947 12.9002L12.9833 7.27639L11.2597 5.55281Z"
                  fill="currentColor"
                />
              </svg>
              수정하기
            </button>
          </div>

          {/* 시설 그리드 - 20개 모두 표시 */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
            {ALL_FACILITIES.map((facility, index) => {
              const isAvailable = data.facilities?.includes(facility) || false;
              const isChecked = facilityStates[facility] || false;
              
              return (
                <div
                  key={index}
                  onClick={() => {
                    if (isAvailable) {
                      handleCheckboxChange(facility, !isChecked);
                    }
                  }}
                  className={`flex items-center gap-3 p-3 rounded-lg border transition-all duration-200 ${
                    isAvailable
                      ? "border-gray-100 dark:border-gray-800 bg-gray-50/50 dark:bg-gray-800/30 hover:bg-gray-100 dark:hover:bg-gray-800/50 cursor-pointer group"
                      : "border-gray-100 dark:border-gray-800/50 bg-gray-50/30 dark:bg-gray-900/10 opacity-40 cursor-not-allowed"
                  }`}
                >
                  <div onClick={(e) => e.stopPropagation()}>
                    <Checkbox
                      checked={isAvailable ? isChecked : false}
                      onChange={(checked) => handleCheckboxChange(facility, checked)}
                    />
                  </div>
                  <label className={`text-sm font-medium flex-1 transition-colors ${
                    isAvailable
                      ? "text-gray-700 dark:text-gray-300 group-hover:text-gray-900 dark:group-hover:text-white cursor-pointer"
                      : "text-gray-400 dark:text-gray-500 cursor-not-allowed"
                  }`}>
                    {facility}
                  </label>
                  {!isAvailable && (
                    <span className="text-xs text-gray-400 dark:text-gray-500">없음</span>
                  )}
                </div>
              );
            })}
          </div>
        </div>
      </div>

      {/* 수정 모달 */}
      <Modal isOpen={isOpen} onClose={closeModal} className="max-w-[700px] m-4">
        <div className="relative w-full p-4 overflow-y-auto bg-white no-scrollbar rounded-3xl dark:bg-gray-900 lg:p-11">
          <div className="px-2 pr-14 mb-6">
            <h4 className="mb-2 text-2xl font-semibold text-gray-800 dark:text-white/90">
              시설 정보 수정
            </h4>
            <p className="text-sm text-gray-500 dark:text-gray-400">
              아파트의 보유 시설 정보를 업데이트해주세요.
            </p>
          </div>

          <form className="flex flex-col">
            <div className="px-2 overflow-y-auto custom-scrollbar max-h-96">
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                {ALL_FACILITIES.map((facility, index) => {
                  const isAvailable = data.facilities?.includes(facility) || false;
                  const isChecked = facilityStates[facility] || false;
                  
                  return (
                    <div
                      key={index}
                      onClick={() => {
                        if (isAvailable) {
                          handleCheckboxChange(facility, !isChecked);
                        }
                      }}
                      className={`flex items-center gap-3 p-3 rounded-lg border transition-colors ${
                        isAvailable
                          ? "border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-800/50 hover:bg-gray-100 dark:hover:bg-gray-800 cursor-pointer"
                          : "border-gray-100 dark:border-gray-800/50 bg-gray-50/30 dark:bg-gray-900/10 opacity-40 cursor-not-allowed"
                      }`}
                    >
                      <div onClick={(e) => e.stopPropagation()}>
                        <Checkbox
                          checked={isAvailable ? isChecked : false}
                          onChange={(checked) => handleCheckboxChange(facility, checked)}
                        />
                      </div>
                      <label className={`text-sm font-medium flex-1 ${
                        isAvailable
                          ? "text-gray-700 dark:text-gray-300 cursor-pointer"
                          : "text-gray-400 dark:text-gray-500 cursor-not-allowed"
                      }`}>
                        {facility}
                      </label>
                      {!isAvailable && (
                        <span className="text-xs text-gray-400 dark:text-gray-500">없음</span>
                      )}
                    </div>
                  );
                })}
              </div>
            </div>

            <div className="flex items-center gap-3 px-2 mt-6 lg:justify-end">
              <Button size="sm" variant="outline" onClick={closeModal}>
                닫기
              </Button>
              <Button size="sm" onClick={handleSave}>
                저장하기
              </Button>
            </div>
          </form>
        </div>
      </Modal>
    </>
  );
}