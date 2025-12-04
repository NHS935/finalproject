import { useState } from "react";
import { Navigate, Route, BrowserRouter as Router, Routes } from "react-router-dom";
import { ScrollToTop } from "./components/common/ScrollToTop";
import NaverMapComponent from "./components/ecommerce/NaverMapComponent";
import NoticeDetail from "./components/NoticeDetail";
import NoticeRegist from "./components/NoticeRegist";
import AppLayout from "./layout/AppLayout";
import AptDetail from "./pages/AptManage/AptDetail";
import AptTables from "./pages/AptManage/AptTable";
import SignIn from "./pages/AuthPages/SignIn";
import SignUp from "./pages/AuthPages/SignUp";
import Blank from "./pages/Blank";
import Calendar from "./pages/Calendar";
import BarChart from "./pages/Charts/BarChart";
import LineChart from "./pages/Charts/LineChart";
import Home from "./pages/Dashboard/Home";
import FormElements from "./pages/Forms/FormElements";
import Notice from "./pages/Notice";
import NotFound from "./pages/OtherPage/NotFound";
import ServerUsagePage from "./pages/ServerUsage/ServerUsagePage";
import BasicTables from "./pages/Tables/BasicTables";
import EmpProfiles from "./pages/Tables/EmpProfiles";
import Avatars from "./pages/UiElements/Avatars";
import Badges from "./pages/UiElements/Badges";
import Buttons from "./pages/UiElements/Buttons";
import Images from "./pages/UiElements/Images";
import RegionalAverage from "./pages/UiElements/RegionalAverage";
import Videos from "./pages/UiElements/Videos";
import UserProfiles from "./pages/UserProfiles";
import BidList from "./pages/Bid/BidList";
import BidDetail from "./pages/Bid/BidDetail";

export default function App() {
  // 로그인 상태 관리
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  // 로그인 처리 함수
  const handleLogin = () => {
    setIsLoggedIn(true);
  };

  // 로그아웃 처리 함수 (필요시 사용)
  const handleLogout = () => {
    setIsLoggedIn(false);
  };

  // 보호된 라우트 컴포넌트
  const ProtectedRoute = ({ children }) => {
    if (!isLoggedIn) {
      return <Navigate to="/signin" replace />;
    }
    return children;
  };

  return (
    <>
      <Router>
        <ScrollToTop />
        <Routes>
          {/* Dashboard Layout - 로그인 필요 */}
          <Route
            element={
              <ProtectedRoute>
                <AppLayout />
              </ProtectedRoute>
            }
          >
            <Route index path="/" element={<Home />} />

            {/* Others Page */}
            <Route path="/profile" element={<UserProfiles />} />
            <Route path="/profile/:userId" element={<UserProfiles />} />
            <Route path="/calendar" element={<Calendar />} />
            <Route path="/blank" element={<Blank />} />

            {/* 입찰 Page */}
            <Route path="/bid" element={<BidList />} />
            <Route path="/bid/view/:id" element={<BidDetail />} />

            {/* 2025-11-20 김우현 */}
            <Route path="/AptTables" element={<AptTables />} />
            <Route path="/AptDetail/:id" element={<AptDetail />} />

            {/* 김병호 */}
            <Route path="/map" element={<NaverMapComponent />} />

            {/* 나혜선 추가 시작*/}
            <Route path="/notice" element={<Notice />} />
            <Route path="/notice/:id" element={<NoticeDetail />} />
            <Route path="/notice/reg" element={<NoticeRegist />} />
            {/* 나혜선 추가 끝*/}

            {/* Forms */}
            <Route path="/form-elements" element={<FormElements />} />

            {/* Tables */}
            <Route path="/basic-tables" element={<BasicTables />} />

            {/* 송인선 한줄 추가 전체 관리비 평균 RegionalAverage */}
            <Route path="/regionalAverage" element={<RegionalAverage />} />
            <Route path="/avatars" element={<Avatars />} />
            <Route path="/badge" element={<Badges />} />
            <Route path="/buttons" element={<Buttons />} />
            <Route path="/images" element={<Images />} />
            <Route path="/videos" element={<Videos />} />
            {/* 백지웅 */}  
            <Route path="/emp-profiles" element={<EmpProfiles />} />
            {/* Charts */}
            {/* 서버 사용량 페이지 */}
            <Route path="/server-usage" element={<ServerUsagePage />} />
            <Route path="/line-chart" element={<LineChart />} />
            <Route path="/bar-chart" element={<BarChart />} />
          </Route>

          {/* Auth Layout - 로그인 페이지에 handleLogin 전달 */}
          <Route path="/signin" element={<SignIn onLogin={handleLogin} />} />
          <Route path="/signup" element={<SignUp />} />

          {/* Fallback Route */}
          <Route path="*" element={<NotFound />} />
        </Routes>
      </Router>
    </>
  );
}
