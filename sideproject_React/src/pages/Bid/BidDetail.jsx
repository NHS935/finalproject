import axios from 'axios';
import { useEffect, useState } from 'react';
import { useNavigate, useParams, useSearchParams } from 'react-router-dom'; // 라우터 훅 사용

const BidDetail = () => {
  const { id } = useParams(); // URL의 :id 파라미터
  const [searchParams] = useSearchParams();
  const serverName = searchParams.get('serverName'); // 쿼리스트링의 ?serverName=...
  const navigate = useNavigate();

  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchDetail = async () => {
      try {
        const response = await axios.get(`/api/bidPblanc/view/${id}`, {
          params: { serverName: serverName }
        });
        setData(response.data);
      } catch (error) {
        console.error("상세 조회 실패:", error);
        alert("데이터를 불러오지 못했습니다.");
        navigate(-1); // 에러 시 뒤로가기
      } finally {
        setLoading(false);
      }
    };
    fetchDetail();
  }, [id, serverName, navigate]);

  if (loading) return <div className="text-center py-20 text-gray-500">데이터 로딩중...</div>;
  if (!data) return <div className="text-center py-20">데이터가 없습니다.</div>;

  return (
    <div className="max-w-5xl mx-auto p-6 bg-white shadow-lg rounded-lg mt-10">
      
      {/* 타이틀 영역 */}
      <div className="border-b-2 border-gray-800 pb-4 mb-6">
        <h1 className="text-2xl font-bold text-gray-800">
          [{data.bidStatus}] {data.bidTitle}
        </h1>
        <div className="text-sm text-gray-500 mt-2 flex justify-between">
            <span>공고번호 : {data.bidNo}</span>
            <span>작성일 : {data.pblancDate}</span>
        </div>
      </div>

      {/* 상세 정보 테이블 */}
      <div className="border-t border-gray-300">
        <table className="w-full text-sm border-b border-gray-300">
          <tbody>
            <tr className="border-b border-gray-200">
              <th className="bg-gray-100 p-3 text-left w-32 font-bold border-r border-gray-200">단지명</th>
              <td className="p-3 w-1/3">{data.aptName}</td>
              <th className="bg-gray-100 p-3 text-left w-32 font-bold border-r border-gray-200">낙찰방법</th>
              <td className="p-3">{data.bidMethod}</td>
            </tr>
            <tr className="border-b border-gray-200">
              <th className="bg-gray-100 p-3 text-left font-bold border-r border-gray-200">공고일자</th>
              <td className="p-3">{data.pblancDate}</td>
              <th className="bg-gray-100 p-3 text-left font-bold border-r border-gray-200">마감일자</th>
              <td className="p-3 text-red-600 font-bold">{data.bidCloseDate}</td>
            </tr>
            <tr className="border-b border-gray-200">
              <th className="bg-gray-100 p-3 text-left font-bold border-r border-gray-200">현장설명회</th>
              <td className="p-3">
                {data.spotYn} ({data.spotPlace || '-'})
              </td>
              <th className="bg-gray-100 p-3 text-left font-bold border-r border-gray-200">입찰보증금</th>
              <td className="p-3">{data.bidDepositRate}%</td>
            </tr>
            <tr className="border-b border-gray-200">
              <th className="bg-gray-100 p-3 text-left font-bold border-r border-gray-200">필수서류</th>
              <td className="p-3" colSpan="3">{data.requiredDocs}</td>
            </tr>
          </tbody>
        </table>
      </div>

      {/* 본문 내용 (공고 상세 내용) */}
      <div className="mt-6 min-h-[200px] p-6 bg-gray-50 border border-gray-200 rounded whitespace-pre-line leading-relaxed text-gray-700">
        {data.bidContent}
      </div>

      {/* 하단 버튼 */}
      <div className="mt-8 flex justify-center gap-2">
        <button 
          onClick={() => navigate(-1)}
          className="px-6 py-2.5 bg-gray-600 text-white rounded hover:bg-gray-700 transition"
        >
          목록으로
        </button>
        {/* 마감되지 않았을 때만 입찰 버튼 보이기 */}
        {data.bidStatus !== '마감' && (
          <button className="px-6 py-2.5 bg-blue-600 text-white rounded hover:bg-blue-700 transition">
            입찰 참여하기
          </button>
        )}
      </div>

    </div>
  );
};

export default BidDetail;