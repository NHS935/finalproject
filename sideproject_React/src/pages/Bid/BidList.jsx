import axios from 'axios';
import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import BidFilter from '../../components/common/BidFilter'; // ★ 경로 확인 필수!

const BidList = () => {

    const navigate = useNavigate();
  // 1. 상태 관리
  const [bids, setBids] = useState([]);
  const [loading, setLoading] = useState(false);
  const [totalElements, setTotalElements] = useState(0);
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(0);
  
  // 정렬 상태
  const [sortField, setSortField] = useState('pblancDate'); // 기본 정렬: 공고일
  const [sortDirection, setSortDirection] = useState('desc'); // 기본 방향: 내림차순

  // 현재 적용된 필터 상태 저장 (페이지 이동 시 유지용)
  const [currentFilters, setCurrentFilters] = useState({});

  // 3. 행 클릭 핸들러 추가
    const handleRowClick = (item) => {
    // URL: /bid/view/10?serverName=서울본사_Server
    navigate(`/bid/view/${item.bidPblancSn}?serverName=${item.serverName}`);
  };

  // 2. 데이터 가져오기 (API 호출)
  const fetchBids = async (page, filters = {}) => {
    setLoading(true);
    try {
      // filters 객체와 정렬 정보를 합쳐서 서버로 전송
      const response = await axios.get('/api/bidPblanc/list', {
        params: {
          currentPage: page,
          pageSize: 10,
          sortField: sortField, 
          sortDirection: sortDirection,
          ...filters 
        }
      });

      const { content, totalPages, totalElements } = response.data;
      setBids(content);
      setTotalPages(totalPages);
      setTotalElements(totalElements);
      setCurrentPage(page);
    } catch (error) {
      console.error("데이터 로딩 실패:", error);
      alert("데이터를 불러오는 중 오류가 발생했습니다.");
    } finally {
      setLoading(false);
    }
  };

  // 3. 정렬 핸들러 (헤더 클릭 시 실행)
  const handleSort = (field) => {
    // 이미 이 필드로 정렬 중이면? -> 방향만 반대로 토글 (desc <-> asc)
    if (field === sortField) {
      setSortDirection(prev => prev === 'desc' ? 'asc' : 'desc');
    } else {
      // 다른 필드를 눌렀으면? -> 그 필드로 변경하고 내림차순(desc) 시작
      setSortField(field);
      setSortDirection('desc');
    }
  };

  // 정렬 상태가 바뀌면 자동으로 데이터 다시 가져오기
  useEffect(() => {
    fetchBids(1, currentFilters); // 필터 조건 유지한 채 1페이지부터 다시 조회
  }, [sortField, sortDirection]);

  // 4. 검색(필터) 버튼 눌렀을 때 실행 (BidFilter에서 호출됨)
  const handleSearch = (filterData) => {
    setCurrentFilters(filterData); // 현재 필터 저장
    fetchBids(1, filterData); // 1페이지부터 다시 조회
  };

  // 5. 페이지 이동 시 실행
  const handlePageChange = (newPage) => {
    if (newPage >= 1 && newPage <= totalPages) {
      fetchBids(newPage, currentFilters); // 저장된 필터 유지하며 페이지 이동
    }
  };

  // 초기 로딩
  useEffect(() => {
    fetchBids(1);
  }, []);

  // [헬퍼] 정렬 가능한 헤더 렌더링 함수
  const renderSortableHeader = (field, label, widthClass = "") => (
    <th 
      className={`px-4 py-3 text-center text-xs font-bold text-gray-600 uppercase tracking-wider cursor-pointer hover:bg-gray-200 transition select-none ${widthClass}`}
      onClick={() => handleSort(field)}
    >
      <div className="flex items-center justify-center gap-1">
        {label}
        {sortField === field ? (
          <span className="text-blue-600">{sortDirection === 'asc' ? '▲' : '▼'}</span>
        ) : (
          <span className="text-gray-300 opacity-0">▲</span> // 자리 차지용
        )}
      </div>
    </th>
  );

  return (
    <div className="max-w-7xl mx-auto p-6 bg-white shadow-lg rounded-lg mt-10">
      
      {/* 헤더 섹션 */}
      <div className="flex justify-between items-center mb-6 border-b pb-4">
        <h1 className="text-2xl font-bold text-gray-800">
          통합 입찰 공고 게시판
        </h1>
        <div className="text-sm text-gray-500">
          총 <span className="font-bold text-blue-600">{totalElements}</span>건
        </div>
      </div>

      {/* ★ [복구 완료] 필터 컴포넌트 장착 ★ */}
      <BidFilter onSearch={handleSearch} />

      {/* 테이블 섹션 */}
      <div className="overflow-x-auto min-h-[500px]">
        <table className="min-w-full divide-y divide-gray-200 border-t border-gray-200">
          <thead className="bg-gray-100 sticky top-0 z-10">
            <tr>
              <th className="px-4 py-3 text-center text-xs font-bold text-gray-600 uppercase tracking-wider w-16">번호</th>
              
              {/* 정렬 가능한 헤더들 */}
              {renderSortableHeader('bidNo', '공고번호', 'w-32')}
              {renderSortableHeader('aptName', '단지명', 'w-40')} 
              {renderSortableHeader('bidTitle', '공고명', '')}
              {renderSortableHeader('bidMethod', '낙찰방법', 'w-24')}
              {renderSortableHeader('pblancDate', '공고일', 'w-24')}
              {renderSortableHeader('bidCloseDate', '마감일', 'w-32')}
              {renderSortableHeader('bidStatus', '상태', 'w-32')} {/* 너비 넓힘 */}
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {loading ? (
              <tr>
                <td colSpan="8" className="px-6 py-20 text-center text-gray-500">
                  <div className="flex justify-center items-center gap-2">
                    <div className="w-3 h-3 bg-blue-500 rounded-full animate-bounce"></div>
                    <div className="w-3 h-3 bg-blue-500 rounded-full animate-bounce delay-75"></div>
                    <div className="w-3 h-3 bg-blue-500 rounded-full animate-bounce delay-150"></div>
                  </div>
                </td>
              </tr>
            ) : bids.length === 0 ? (
              <tr><td colSpan="8" className="text-center py-20 text-gray-500">조회된 데이터가 없습니다.</td></tr>
            ) : (
              bids.map((item, index) => (
                <tr key={`${item.bidNo}-${index}`} className="hover:bg-blue-50 transition duration-150 group cursor-pointer" // cursor-pointer 추가
          onClick={() => handleRowClick(item)}>
                  {/* 1. 번호 */}
                  <td className="px-4 py-3 text-center text-sm text-gray-500">
                    {(currentPage - 1) * 10 + index + 1}
                  </td>
                  
                  {/* 2. 공고번호 */}
                  <td className="px-4 py-3 text-sm font-mono text-gray-600 whitespace-nowrap">
                    {item.bidNo}
                  </td>
                  
                  {/* 3. 단지명 (말줄임 처리) */}
                  <td className="px-4 py-3 text-sm text-gray-700 font-semibold whitespace-nowrap truncate max-w-[150px]" title={item.aptName}>
                    {item.aptName}
                  </td>
                  
                  {/* 4. 공고명 (클릭 가능) */}
                  <td className="px-4 py-3 text-sm font-medium text-gray-900 cursor-pointer truncate max-w-[300px] hover:text-blue-600 hover:underline" title={item.bidTitle}>
                    {item.bidTitle}
                  </td>
                  
                  {/* 5. 낙찰방법 */}
                  <td className="px-4 py-3 text-center text-sm text-gray-500 whitespace-nowrap">
                    {item.bidMethod}
                  </td>

                  {/* 6. 공고일 */}
                  <td className="px-4 py-3 text-center text-sm text-gray-500 whitespace-nowrap">
                    {item.pblancDate}
                  </td>
                  
                  {/* 7. 마감일 (강조) */}
                  <td className="px-4 py-3 text-center text-sm text-red-600 font-medium whitespace-nowrap">
                    {item.bidCloseDate}
                  </td>

                  {/* 8. 상태 (넓어진 너비에 뱃지 표시) */}
                  <td className="px-4 py-3 text-center whitespace-nowrap">
                    <span className={`px-3 py-1 inline-flex text-xs leading-5 font-semibold rounded-full border ${
                        item.bidStatus === '신규공고' ? 'bg-green-100 text-green-800 border-green-200' : 
                        item.bidStatus === '마감임박' ? 'bg-red-100 text-red-800 border-red-200' : 
                        item.bidStatus === '마감'     ? 'bg-gray-200 text-gray-500 border-gray-300' : 
                        'bg-blue-50 text-blue-800 border-blue-200'
                    }`}>
                      {item.bidStatus}
                    </span>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* 페이징 섹션 */}
      <div className="flex justify-center items-center mt-6 gap-2">
        <button 
          onClick={() => handlePageChange(currentPage - 1)}
          disabled={currentPage === 1}
          className="px-4 py-2 border rounded-md text-sm bg-white hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed text-gray-600"
        >
          &lt; 이전
        </button>
        
        <span className="text-sm text-gray-600 px-4 font-medium">
          <span className="text-blue-600 font-bold">{currentPage}</span> / {totalPages === 0 ? 1 : totalPages} 페이지
        </span>

        <button 
          onClick={() => handlePageChange(currentPage + 1)}
          disabled={currentPage === totalPages || totalPages === 0}
          className="px-4 py-2 border rounded-md text-sm bg-white hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed text-gray-600"
        >
          다음 &gt;
        </button>
      </div>
    </div>
  );
};

export default BidList;