import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";
import svgr from "vite-plugin-svgr";

// https://vite.dev/config/
export default defineConfig({
  plugins: [react(), tailwindcss(), svgr()],
  server: {
    proxy: {
      // '/api'로 시작하는 요청을 백엔드(8080)로 전달
      '/api': {
        target: 'http://localhost:8020', // 스프링 부트 서버 주소
        changeOrigin: true, // 호스트 헤더 변경 (CORS 우회에 도움)
        // secure: false, // https를 쓴다면 false로 설정 필요할 수 있음
      }
    }
  }
});
