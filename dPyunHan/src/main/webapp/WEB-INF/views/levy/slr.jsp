<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="../include/headerContents.jsp"%>

<link rel="stylesheet" href="https://leeoniya.github.io/uPlot/dist/uPlot.min.css">
<script src="https://leeoniya.github.io/uPlot/dist/uPlot.iife.js"></script>

<style>
/* 카드 스타일 개선 */
.card-info {
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  border: none;
  border-radius: 12px;
  overflow: hidden;
}

.card-info .card-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  padding: 20px;
}

.card-info .card-header .card-title {
  color: white;
  font-size: 20px;
  font-weight: 700;
  text-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

/* 결과 영역 스타일 개선 */
#result {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
  color: white !important;
  border-radius: 12px !important;
  padding: 20px !important;
  margin-bottom: 20px !important;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4) !important;
  font-size: 18px !important;
  font-weight: bold !important;
}

#result span {
  font-size: 22px !important;
  color: #fef3c7 !important;
  text-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

/* 월 선택 입력 스타일 */
#yearMonth {
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  padding: 8px 12px;
  font-size: 15px;
  transition: all 0.3s ease;
  height: 40px;
}

#yearMonth:focus {
  border-color: #667eea;
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.15);
  outline: none;
}

/* 라벨 스타일 */
label {
  font-weight: 600 !important;
  color: #374151;
  font-size: 14px;
  margin-bottom: 8px;
}

/* 버튼 스타일 */
#predict {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
  border: none !important;
  padding: 8px 24px !important;
  font-size: 15px !important;
  font-weight: 600 !important;
  border-radius: 8px !important;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4) !important;
  transition: all 0.3s ease !important;
  color: white !important;
  height: 40px !important;
}

#predict:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 16px rgba(102, 126, 234, 0.6) !important;
}

#predict:active {
  transform: translateY(0);
}

#predict i {
  margin-right: 6px;
}

/* 그래프 컨테이너 스타일 */
#lineChart {
  background: white;
  border-radius: 12px;
  padding: 20px 15px !important;  /* 25px → 20px 15px (상하 20, 좌우 15) */
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
  border: 1px solid #e5e7eb;
}

/* 범례 한 줄 정렬 */
.u-legend {
  display: flex !important;
  flex-direction: row !important;
  align-items: center !important;
  justify-content: center !important;
  gap: 20px !important;
  background: white !important;
  padding: 12px 16px !important;
  border-radius: 8px !important;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1) !important;
  border: 1px solid #e5e7eb !important;
}

.u-legend .u-series {
  display: flex !important;
  align-items: center !important;
  gap: 6px !important;
  padding: 4px 8px !important;
  font-weight: 500 !important;
  white-space: nowrap !important;
  cursor: pointer !important;  /* ✅ 클릭 가능 표시 */
  transition: all 0.2s ease !important;  /* ✅ 부드러운 전환 */
  border-radius: 6px !important;  /* ✅ 둥근 모서리 */
}

/* ✅ hover 효과 */
.u-legend .u-series:hover {
  background: rgba(102, 126, 234, 0.1) !important;
}

/* ✅ 숨겨진 시리즈 스타일 */
.u-legend .u-series.u-off {
  opacity: 0.35 !important;
}

.u-legend .u-marker {
  width: 12px !important;
  height: 12px !important;
  border-radius: 50% !important;
  flex-shrink: 0 !important;
}

.u-legend .u-label {
  font-size: 13px !important;
  color: #475569 !important;
}

/* 그래프 제목 스타일 */
.u-title {
  font-size: 17px !important;
  font-weight: 700 !important;
  color: #1e293b !important;
  padding: 8px 0 !important;
}

/* 카드 바디 여백 */
.card-body {
  padding: 25px !important;
}

/* 결과 영역 스타일 */
#result {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%) !important;
  color: white !important;
  border-radius: 10px !important;
  padding: 12px 16px !important;
  margin: 0 !important;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4) !important;
  font-size: 14px !important;
  font-weight: 600 !important;
  line-height: 1.6 !important;
}

#result span {
  font-size: 16px !important;
  color: #fef3c7 !important;
  text-shadow: 0 2px 4px rgba(0,0,0,0.2);
  font-weight: 700 !important;
}

@media (max-width: 768px) {
  .card-body > div:first-child {
    grid-template-columns: 1fr !important;
    gap: 12px !important;
  }
  
  #yearMonth {
    width: 100% !important;
    max-width: 100% !important;
  }
}
</style>
<section class="content">
  <div class="container-fluid">

    <div class="card card-info">
      <div class="card-header">
        <h3 class="card-title">📊 30일 예상 사용량 예측</h3>
        <div class="card-tools">
          <button type="button" class="btn btn-tool" data-card-widget="collapse" style="color: white;">
            <i class="fas fa-minus"></i>
          </button>
        </div>
      </div>

    <div class="card-body">
  <!-- 2x2 그리드 레이아웃 -->
  <div style="display: grid; grid-template-columns: auto 1fr; gap: 15px 20px; margin-bottom: 25px; align-items: center;">
    
    <!-- 1행 1열: 라벨 -->
    <div>
      <label style="margin: 0; font-weight: 600; color: #374151; font-size: 14px;">
        📅 조회할 년/월 선택
      </label>
    </div>
    
    <!-- 1행 2열: 날짜 입력박스 -->
    <div>
      <input type="month" id="yearMonth" class="form-control" value="${yearMonth}" style="width: 200px;">
    </div>
    
    <!-- 2행 1열: 예측 버튼 -->
    <div>
      <button id="predict" class="btn btn-primary">
        <i class="fas fa-chart-line"></i> 예측하기
      </button>
    </div>
    
    <!-- 2행 2열: 결과 영역 -->
    <div>
      <div id="result" style="display:none;"></div>
    </div>
    
  </div>

  <!-- 그래프 영역 -->
  <div id="lineChart" style="width:100%;height:550px;"></div>
</div>

    </div>
  </div>
</section>

<script>
document.addEventListener("DOMContentLoaded", function () {

	 let chart = null;

	  function fetchData(yearMonth) {
	    return fetch("/levy/predict", {
	      method: "post",
	      headers: { "Content-Type": "application/json;charset=UTF-8" },
	      body: JSON.stringify({ yearMonth })
	    }).then(r => r.json());
	  }

	  document.querySelector("#predict").addEventListener("click", () => {
	    const ym = document.querySelector("#yearMonth").value.replace("-", "");
	    if (!ym) return alert("년월을 선택하세요.");
	    runPredict(ym);
	  });

	  function runPredict(yearMonth) {

	    fetchData(yearMonth).then(data => {

	      const days = data.days;
	      const actualValues = data.values;
	      const predictedValues = data.predicted;
	      const totalMonth = data.amt;

	      // 미래 예측 (실제값이 null인 구간만)
	      var futurePredict = new Array(days.length).fill(null);

	      for (var i = 0; i < days.length; i++) {
	        if (actualValues[i] == null) {
	          futurePredict[i] = predictedValues[i];
	        }
	      }

	      // 결과 영역 표시
	      const resultDiv = document.querySelector("#result");
	      resultDiv.style.display = "block";
	      resultDiv.innerHTML =
	        "📅 선택한 월: " + yearMonth.substr(0,4) + "년 " + yearMonth.substr(4,2) + "월<br>" +
	        "<span>💰 " + yearMonth.substr(4,2) + "월 예상 관리비: " + totalMonth.toLocaleString() + "원</span>";

	        const opts = {
	        		  title: yearMonth.substr(0,4) + "년 " + yearMonth.substr(4,2) + "월 관리비 예측",
	        		  width: document.querySelector("#lineChart").offsetWidth,  // 빼기 없이 100%
	        		  height: 530,  // 
	        		  padding: [30, 50, 50, 0],  // 내부 여백만 조정
	        		  scales: {
	        			  x: { time: false },
	        			  y: {
	        			    auto: true,  // ✅ auto는 true로 유지
	        			    range: (u, min, max) => {
	        			      // 최소값이 0보다 크면 0으로, 아니면 그대로
	        			      const rangeMin = Math.min(0, min);
	        			      const padding = (max - rangeMin) * 0.1;
	        			      return [rangeMin, max + padding];
	        			    }
	        			  }
	        			},
	        		  axes: [
	        		    {
	        		      stroke: "#475569",
	        		      grid: { stroke: "#e5e7eb", width: 1 },
	        		      ticks: { stroke: "#cbd5e1", width: 1 },
	        		      font: "14px 'Segoe UI', sans-serif",
	        		      size: 65,
	        		      // ✅ 5일 간격으로 표시 (1, 5, 10, 15, 20, 25, 30)
	        		      values: (u, vals) => vals.map(v => v + '일'),
	        		      splits: (u) => {
	        		        let splits = [1];  // 1일은 항상 표시
	        		        for (let i = 5; i <= days.length; i += 5) {
	        		          splits.push(i);
	        		        }
	        		        // 마지막 날이 5의 배수가 아니면 추가
	        		        if (splits[splits.length - 1] !== days.length) {
	        		          splits.push(days.length);
	        		        }
	        		        return splits;
	        		      }
	        		    },
	        		    {
	        		      stroke: "#475569",
	        		      grid: { stroke: "#e5e7eb", width: 1 },
	        		      ticks: { stroke: "#cbd5e1", width: 1 },
	        		      font: "14px 'Segoe UI', sans-serif",
	        		      values: (u, vals) => vals.map(v => v.toLocaleString() + '원'),
	        		      size: 110
	        		    }
	        		  ],
	        		  plugins: [ tooltipPlugin() ],
	        		  legend: {
	        			  show: true,
	        			  live: true,      
	        			  isolate: true
	        		  },
	        		  series: [
	        			  { label: "일자" },
	        			  { 
	        			    label: "실제 사용량",   // 1번 (파랑)
	        			    stroke: "#3b82f6",
	        			    width: 4,
	        			    points: { show: true, size: 7, fill: "#3b82f6" }
	        			  },
	        			  { 
	        				  label: "예측 기준선",
	        				  stroke: "#f59e0b",
	        				  width: 3,  // 2.5 → 3 (더 굵게)
	        				  dash: [8, 3],  // [6, 4] → [8, 3] (점선 더 진하게)
	        				  points: { show: false },
	        				  drawStyle: 1  // 직선 강제
	        			  },
	        			  { 
	        			    label: "미래 예측",     // 3번 (빨강)
	        			    stroke: "#ef4444",
	        			    width: 4.5,
	        			    points: { show: true, size: 10, fill: "#ef4444" }
	        			  }
	        			]
	        		};
	      const plotData = [
	        days,
	        actualValues,
	        predictedValues,
	        futurePredict
	      ];

	      if (chart) chart.destroy();
	      chart = new uPlot(opts, plotData, document.querySelector("#lineChart"));
	    });
	  }

	  function tooltipPlugin() {
	    var el;
	    return {
	      hooks: {
	        init: function(u) {
	          el = document.createElement("div");
	          el.style.cssText = `
	            position: absolute;
	            background: rgba(255, 255, 255, 0.98);
	            color: #1e293b;
	            padding: 12px 16px;
	            border-radius: 8px;
	            font-size: 14px;
	            pointer-events: none;
	            display: none;
	            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
	            border: 1px solid #e2e8f0;
	            z-index: 1000;
	            font-family: 'Segoe UI', sans-serif;
	          `;
	          document.querySelector("#lineChart").appendChild(el);
	        },
	        setCursor: function(u) {
	          var idx = u.cursor.idx;
	          var left = u.cursor.left;
	          var top = u.cursor.top;

	          if (idx == null) {
	            el.style.display = "none";
	            return;
	          }

	          var actual = u.data[1][idx];
	          var predict = u.data[2][idx];
	          var future = u.data[3][idx];

	          let html = "<div style='font-weight:600;margin-bottom:8px;color:#475569;'>" + 
	                     u.data[0][idx] + "일</div>";

	          if (actual != null) {
	            html += "<div style='color:#3b82f6;margin:4px 0;font-weight:600;'>실제: " + actual.toLocaleString() + "원</div>";
	          }
	          
	          if (future != null) {
	            html += "<div style='color:#ef4444;margin:4px 0;font-weight:600;'>예측: " + future.toLocaleString() + "원</div>";
	          } else if (predict != null && actual == null) {
	            html += "<div style='color:#94a3b8;margin:4px 0;'>예측선: " + predict.toLocaleString() + "원</div>";
	          }

	          el.innerHTML = html;

	          // ✅ 툴팁 위치 자동 조정
	          const chartRect = document.querySelector("#lineChart").getBoundingClientRect();
	       // ✅ 툴팁 위치 자동 조정 (마우스 바로 위)
	          const tooltipWidth = 0;
	          const tooltipHeight = -250;

	          // 기본 위치: 마우스 바로 위 (거의 붙여서)
	          let tooltipLeft = left + 10;              // 중앙 정렬 말고 살짝 오른쪽
	          let tooltipTop = top - tooltipHeight + 20; // 훨씬 더 가까이

	          // 왼쪽 벽 넘으면 조정
	          if (tooltipLeft < 0) {
	            tooltipLeft = 5;
	          }

	          // 오른쪽 벽 넘으면 조정
	          if (tooltipLeft + tooltipWidth > u.bbox.width) {
	            tooltipLeft = u.bbox.width - tooltipWidth - 5;
	          }

	          // 위쪽 넘으면 아래로
	          if (tooltipTop < 0) {
	            tooltipTop = top + 25;  // 마우스 바로 아래
	          }

	          el.style.left = tooltipLeft + "px";
	          el.style.top = tooltipTop + "px";
	          el.style.display = "block";
	        }
	      }
	    };
	  }

	});
</script>

<%@ include file="../include/footerContents.jsp"%>