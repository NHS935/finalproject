import { useState } from 'react';

const BidFilter = ({ onSearch }) => {
  // 1. 아코디언 상태 관리 (true: 펼쳐짐, false: 접힘)
  const [isExpanded, setIsExpanded] = useState(true);

  const [filters, setFilters] = useState({
    searchType: 'title',
    keyword: '',
    aptName: '',
    dateType: 'reg',
    startDate: '',
    endDate: '',
    bidStatus: '',
    bidMethod: '',
    category1: '',
    category2: '',
  });

  const setDateRange = (months) => {
    const end = new Date();
    const start = new Date();
    start.setMonth(start.getMonth() - months);
    setFilters((prev) => ({
      ...prev,
      startDate: start.toISOString().split('T')[0],
      endDate: end.toISOString().split('T')[0],
    }));
  };

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFilters((prev) => ({ ...prev, [name]: value }));
  };

  const handleSearch = (e) => {
    e.preventDefault();
    onSearch(filters);
  };

  const labelStyle = "w-32 bg-gray-100 flex items-center justify-start px-4 font-bold text-gray-600 border-r border-gray-200 text-sm";
  const inputAreaStyle = "flex-1 flex items-center px-4 py-2 gap-2 flex-wrap";

  return (
    <div className="bg-white border border-gray-300 rounded-lg shadow-sm mb-6 overflow-hidden">
      
      {/* ▼▼▼ 1. 아코디언 헤더 (클릭 영역) ▼▼▼ */}
      <div 
        className="bg-gray-50 p-4 flex justify-between items-center cursor-pointer hover:bg-gray-100 transition-colors border-b border-gray-200"
        onClick={() => setIsExpanded(!isExpanded)}
      >
        <div className="flex items-center gap-2">
          <svg className="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z" />
          </svg>
          <span className="font-bold text-gray-700">상세 검색 조건</span>
          <span className="text-xs text-gray-500 font-normal ml-2">
            (원하는 조건을 선택하여 검색하세요)
          </span>
        </div>

        {/* 화살표 아이콘 (상태에 따라 회전) */}
        <svg 
          className={`w-5 h-5 text-gray-500 transform transition-transform duration-300 ${isExpanded ? 'rotate-180' : ''}`} 
          fill="none" 
          stroke="currentColor" 
          viewBox="0 0 24 24"
        >
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
        </svg>
      </div>

      {/* ▼▼▼ 2. 아코디언 바디 (애니메이션 적용) ▼▼▼ */}
      <div 
        className={`transition-[max-height,opacity] duration-300 ease-in-out overflow-hidden ${
          isExpanded ? 'max-h-[1000px] opacity-100' : 'max-h-0 opacity-0'
        }`}
      >
        <form onSubmit={handleSearch} className="border-t border-gray-100">
          <div className="flex flex-col divide-y divide-gray-200">
            
            {/* Row 1 */}
            <div className="flex flex-col md:flex-row divide-y md:divide-y-0 md:divide-x divide-gray-200">
              <div className="flex-1 flex">
                <div className={labelStyle}>검색조건</div>
                <div className={inputAreaStyle}>
                  <select name="searchType" value={filters.searchType} onChange={handleChange} className="border border-gray-300 rounded px-2 py-1.5 text-sm w-28">
                    <option value="title">공고명</option>
                    <option value="no">공고번호</option>
                  </select>
                  <input type="text" name="keyword" value={filters.keyword} onChange={handleChange} className="flex-1 border border-gray-300 rounded px-3 py-1.5 text-sm" placeholder="검색어 입력" />
                </div>
              </div>
              <div className="flex-1 flex">
                <div className={labelStyle}>단지명</div>
                <div className={inputAreaStyle}>
                  <input type="text" name="aptName" value={filters.aptName} onChange={handleChange} className="w-full border border-gray-300 rounded px-3 py-1.5 text-sm" />
                </div>
              </div>
            </div>

            {/* Row 2 */}
            <div className="flex">
              <div className={labelStyle}>기간 설정</div>
              <div className={inputAreaStyle}>
                <select name="dateType" value={filters.dateType} onChange={handleChange} className="border border-gray-300 rounded px-2 py-1.5 text-sm mr-2">
                  <option value="reg">공고일</option>
                  <option value="close">마감일</option>
                </select>
                <div className="flex items-center gap-2">
                  <input type="date" name="startDate" value={filters.startDate} onChange={handleChange} className="border border-gray-300 rounded px-2 py-1.5 text-sm" />
                  ~
                  <input type="date" name="endDate" value={filters.endDate} onChange={handleChange} className="border border-gray-300 rounded px-2 py-1.5 text-sm" />
                </div>
                <div className="flex gap-1 ml-auto">
                  {[1, 3, 6].map((m) => (
                    <button key={m} type="button" onClick={() => setDateRange(m)} className="px-2 py-1 text-xs border rounded bg-gray-50 hover:bg-blue-50 text-gray-600">{m}개월</button>
                  ))}
                </div>
              </div>
            </div>

            {/* Row 3 */}
            <div className="flex flex-col md:flex-row divide-y md:divide-y-0 md:divide-x divide-gray-200">
              <div className="flex-1 flex">
                <div className={labelStyle}>공고상태</div>
                <div className={inputAreaStyle}>
                  <select name="bidStatus" onChange={handleChange} className="w-full border border-gray-300 rounded px-2 py-1.5 text-sm">
                    <option value="">전체</option>
                    <option value="new">신규공고</option>
                    <option value="end">마감공고</option>
                  </select>
                </div>
              </div>
              <div className="flex-1 flex">
                <div className={labelStyle}>입찰방법</div>
                <div className={inputAreaStyle}>
                  <select name="bidMethod" onChange={handleChange} className="w-full border border-gray-300 rounded px-2 py-1.5 text-sm">
                    <option value="">전체</option>
                    <option value="electronic">전자입찰</option>
                    <option value="direct">직접입찰</option>
                  </select>
                </div>
              </div>
            </div>

            {/* Row 4 */}
            <div className="flex">
              <div className={labelStyle}>입찰분류</div>
              <div className={inputAreaStyle}>
                <select name="category1" onChange={handleChange} className="border border-gray-300 rounded px-2 py-1.5 text-sm w-1/3">
                  <option value="">대분류</option>
                  <option value="01">공사</option>
                  <option value="02">용역</option>
                </select>
                <select name="category2" onChange={handleChange} className="border border-gray-300 rounded px-2 py-1.5 text-sm w-1/3">
                  <option value="">중분류</option>
                  <option value="A">건축</option>
                </select>
                <select name="category3" onChange={handleChange} className="border border-gray-300 rounded px-2 py-1.5 text-sm w-1/3">
                  <option value="">소분류</option>
                </select>
              </div>
            </div>
          </div>

          <div className="bg-gray-50 p-3 flex justify-center border-t border-gray-200">
            <button type="submit" className="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700 transition font-medium text-sm flex items-center gap-2">
              <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" /></svg>
              조건 검색
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default BidFilter;