import aptMangeData from "../../data/aptManageDB";
import PageBreadcrumb from "../../components/common/PageBreadCrumb";
import PageMeta from "../../components/common/PageMeta";
import { useParams } from "react-router-dom";
import { useEffect, useState } from "react";
import AptInfoDetail from "./AptInfoCard";
import AptSpecialty from "./AptSpecialty";

export default function Blank() {
  const { id } = useParams();  // URL 경로에서 id 값을 읽음
  const [data, setData] = useState(null);

  useEffect(() => {
    // id 값에 해당하는 데이터 찾기 (id 타입 맞춤 Number 필요할 수 있음)
    const matched = aptMangeData.rowData.find(item => item.id === Number(id));
    setData(matched);
  }, [id]);

  if (!data) return <div>데이터를 찾을 수 없습니다.</div>;
  
  const imgId = id % 5;

  return (
    <div>
      <PageMeta
        title="React.js Blank Dashboard | TailAdmin - Next.js Admin Dashboard Template"
        description="This is React.js Blank Dashboard page for TailAdmin - React.js Tailwind CSS Admin Dashboard Template"
      />
      <PageBreadcrumb pageTitle="상세보기" />
      <div className="min-h-screen rounded-2xl border border-gray-200 bg-white px-5 py-7 dark:border-gray-800 dark:bg-white/[0.03] xl:px-10 xl:py-12">
        <div className="mx-auto w-full grid grid-cols-12 gap-4">
          <div className="col-span-4" style={{ border: "1px solid whenTransitionDone;" }}>
            <img src={`/images/images/apt_${imgId}.jpg`} />
          </div>
          <div className="col-span-8 space-y-3">
            <AptInfoDetail />
             <AptSpecialty />
          </div>
          
        </div>
      </div>
    </div>
  );
}