<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>접근 제한</title>

    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
        h1 { color: #d9534f; /* 밝은 글자색 */
   			 text-shadow:
   			 -2px -2px 2px white,
  			  2px -2px 2px white,
   			 -2px 2px 2px white,
   			  2px 2px 2px white;
   			 
   			 }
        p { color: #red;
   			-webkit-text-stroke: 1px white;
    		text-stroke: 1px white; 
    		}
    </style>
</head>
<body style="margin: 0; min-height: 100vh; background: white; position: relative;">

  <!-- 이미지와 반투명 오버레이 및 텍스트를 같이 감쌈 -->
  <div style="position: relative; max-height: 80vh; width: 100%; max-width: 100vw; overflow: hidden; border-radius: 12px;">
    <img src="/images/error.jpg"
      style="width: 100%; height: auto; max-height: 80vh; object-fit: contain; display: block; border-radius: 12px;"
    />
    <div style="position: absolute; top: 0; left: 20%; right: 20%; bottom: 0;
                background: rgba(0, 0, 0, 0.3); border-radius: 12px;
                display: flex; flex-direction: column; align-items: center; justify-content: center; color: white; padding: 20px; box-sizing: border-box; text-align: center;">
      <h1 style="font-size: 10rem; margin-bottom: 16px;">접근 제한</h1>
      <p style="font-size: 1.5rem; margin-bottom: 32px;">죄송합니다. 이 페이지에 접근 권한이 없습니다.</p>
      <a href="/login"
         style="background: #3366ff; color: white; padding: 12px 24px; border-radius: 6px; text-decoration: none; font-size: 1rem;">
        로그인으로 돌아가기
      </a>
    </div>
  </div>

</body>
</html>