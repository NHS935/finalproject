import NaverMapLayout from "./NaverMapLayout";

function NaverMapComponent() {
  return (
    <div className="min-h-screen bg-gray-50 p-4">
      <div className="max-w-6xl mx-auto">
        <h1 className="mb-4 text-xl font-bold">대전 아파트 시세 지도</h1>

        <NaverMapLayout />
      </div>
    </div>
  );
}

export default NaverMapComponent;
