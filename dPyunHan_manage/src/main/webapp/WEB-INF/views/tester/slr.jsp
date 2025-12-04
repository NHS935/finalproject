<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="../include/header.jsp"%>
  <!-- uplot CSS -->
  <link rel="stylesheet" href="https://leeoniya.github.io/uPlot/dist/uPlot.min.css">
  
  <!-- uplot JS -->
  <script src="https://leeoniya.github.io/uPlot/dist/uPlot.iife.js"></script>


<section class="content">
  <div class="container-fluid">
    
    <!-- LINE CHART (uplot용) -->
    <div class="card card-info">
      <div class="card-header">
        <h3 class="card-title">30일 예상 사용량 예측</h3>
        <div class="card-tools">
          <button type="button" class="btn btn-tool" data-card-widget="collapse">
            <i class="fas fa-minus"></i>
          </button>
          <button type="button" class="btn btn-tool" data-card-widget="remove">
            <i class="fas fa-times"></i>
          </button>
        </div>
      </div>
      
      <div class="card-body">
        <div class="chart">
          <!-- 예측 결과 -->
          <div id="result" style="font-size: 18px; font-weight: bold; margin-bottom: 15px; padding: 15px; background-color: #f0f0f0; border-radius: 5px;"></div>
          
          <!-- 예측 버튼 -->
          <button id="predict" class="btn btn-primary" style="margin-bottom: 15px;">
            <i class="fas fa-chart-line"></i> 예측하기
          </button>
          
          <!-- uplot 그래프 -->
          <div id="lineChart" style="width: 100%; height: 400px;"></div>
        </div>
      </div>
      <!-- /.card-body -->
    </div>
    <!-- /.card -->
    
  </div>
  <!-- /.container-fluid -->
</section>
<!-- ///// content 끝 ///// -->
<script>
document.addEventListener("DOMContentLoaded", function(){
	  const predict = document.querySelector("#predict");
	  let chart = null;

	  // 이동평균 계산
	  function calculateMovingAverage(values, window = 3) {
	    const result = [];
	    for (let i = 0; i < values.length; i++) {
	      if (i < window - 1) {
	        result.push(values[i]);
	      } else {
	        const sum = values.slice(i - window + 1, i + 1).reduce((a, b) => a + b, 0);
	        result.push(sum / window);
	      }
	    }
	    return result;
	  }

	  // 정확도 계산
	  function calculateAccuracy(actual, predicted) {
	    if (!actual || actual.length === 0) return 0;
	    
	    let totalError = 0;
	    for(let i = 0; i < actual.length; i++) {
	      totalError += Math.abs(actual[i] - predicted[i]);
	    }
	    const avgError = totalError / actual.length;
	    const avgActual = actual.reduce((a, b) => a + b) / actual.length;
	    return Math.max(0, (1 - avgError / avgActual) * 100);
	  }

	  predict.addEventListener("click", function(){
	    fetch("/tester/predict", {
	      method: "post",
	      headers: {
	        "Content-type": "application/json;charset=UTF-8"
	      },
	      body: JSON.stringify({
	        "varX": 30
	      })
	    })
	    .then(resp => resp.json())
	    .then(data => {
	      console.log("서버 데이터 :", data);
	      
	      // 데이터 준비
	      const days = Array.from({length: 30}, (_, i) => i + 1);
	      
	      // 이동평균으로 부드럽게 만들기
	      const smoothedValues = calculateMovingAverage(data.values, 3);
	      
	      const actualValues = [...data.values, ...Array(15).fill(null)];
	      
	      // 부드러운 값으로 회귀선 계산
	      const m = (smoothedValues[smoothedValues.length - 1] - smoothedValues[0]) / 
	                (data.days[data.days.length - 1] - data.days[0]);
	      const b = smoothedValues[0] - m * data.days[0];
	      
	      const predictValues = days.map(day => m * day + b);

	      // 정확도 계산
	      const accuracy = calculateAccuracy(data.values, predictValues.slice(0, data.values.length));
	      
	      console.log("부드러운 값 :", smoothedValues);
	      console.log("30일 예측값 :", data.amt.toFixed(2));
	      console.log("정확도 :", accuracy.toFixed(1) + "%");

	      // 결과 표시
	      const resultDiv = document.querySelector("#result");
	      if (resultDiv) {
	        resultDiv.innerHTML = 
	          `30일 예상 사용량: \${data.amt.toFixed(2)}<br>
	           <span style="font-size: 14px; color: ${accuracy > 70 ? 'green' : 'orange'};">
	           예측 정확도: \${accuracy.toFixed(1)}%
	           </span>`;
	      }

	      // 툴팁 생성 마우스 올렸을때 사용량 뜨게 하는용도
	      function tooltipPlugin() {
	        let tooltipEl = null;
	        
	        function init(u, opts) {
	          tooltipEl = document.createElement("div");
	          tooltipEl.className = "uplot-tooltip";
	          tooltipEl.style.cssText = `
	            position: absolute;
	            display: none;
	            padding: 8px 12px;
	            background: rgba(0, 0, 0, 0.85);
	            color: white;
	            border-radius: 4px;
	            font-size: 13px;
	            pointer-events: none;
	            z-index: 100;
	            white-space: nowrap;
	          `;
	          document.querySelector("#lineChart").appendChild(tooltipEl);
	          
	          u.over.addEventListener("mouseleave", () => {
	            tooltipEl.style.display = "none";
	          });
	        }
	        
	        // 이거는 그래프에 툴팁 위치를 위한 코드
	        function setCursor(u) {
	          const { left, top, idx } = u.cursor;
	          
	          if (idx === null || idx === undefined) {
	            tooltipEl.style.display = "none";
	            return;
	          }
	          
	          const day = u.data[0][idx];
	          let content = "<strong>" + day + "일</strong><br>";
	          
	          // 실제 사용량
	          if (u.data[1][idx] != null) {
	            content += "실제: " + Math.round(u.data[1][idx]) + "개<br>";
	          }
	          
	          // 예측값
	          if (u.data[2][idx] != null) {
	            content += "예측: " + Math.round(u.data[2][idx]) + "개<br>";
	          }
	          
	          // 30일 예측
	          if (u.data[3][idx] != null) {
	            content += '<span style="color: #ffd700;">⭐ 30일 예측: ' + Math.round(u.data[3][idx]) + '개</span>';
	          }
	          
	          tooltipEl.innerHTML = content;
	          tooltipEl.style.display = "block";
	          
	          // 툴팁 위치 조정 이게 핵심위치
	          const chartRect = u.over.getBoundingClientRect();
	          tooltipEl.style.left = (left + 30) + "px";
	          tooltipEl.style.top = (top + 60) + "px";
	        }
	        
	        return {
	          hooks: {
	            init: init,
	            setCursor: setCursor
	          }
	        };
	      }
	      
	      // uplot 옵션
	      const opts = {
	        title: "30일 예상 사용량 예측",
	        id: "lineChart",
	        class: "my-plot",
	        width: document.querySelector("#lineChart").offsetWidth || 800,
	        height: 400,
	        padding: [10, 10, 40, 60],
	        plugins: [
	        	tooltipPlugin()
	        ],
	        cursor: {
	            drag: {
	              x: false,  // X축 드래그 줌 비활성화
	              y: false   // Y축 드래그 줌 비활성화
	            }
	          },
	        series: [
	          {
	            label: "일수",
	          },
	          {
	            label: "실제 사용량",
	            stroke: "rgb(75, 192, 192)",
	            width: 2,
	            points: {
	              show: true,
	              size: 8
	            }
	          },
	          {
	            label: "예측값 (회귀선)",
	            stroke: "rgb(255, 99, 132)",
	            width: 2,
	            dash: [5, 5],
	            points: {
	              show: false
	            }
	          },
	          {
	            label: "30일 예측",
	            stroke: "rgb(255, 215, 0)",
	            width: 0,
	            points: {
	              show: true,
	              size: 12,
	              fill: "rgb(255, 215, 0)",
	              stroke: "rgb(255, 99, 132)",
	              width: 2
	            }
	          }
	        ],
	        axes: [
	          {
	            label: "일수 (Day)",
	            labelSize: 30,
	            size: 60,
	            gap: 5,
	            values: (self, ticks) => ticks.map(v => Math.round(v))
	          },
	          {
	            label: "사용량 (단위)",
	            labelSize: 30,
	            size: 60,
	            gap: 5,
	            values: (self, ticks) => ticks
	          }
	        ],
	        scales: {
	          x: {
	            auto: true
	          },
	          y: {
	            auto: true,
	            range: [
	              0,
	              Math.max(...data.values, data.amt) + 50
	            ]
	          }
	        }
	      };

	      // 30일만 특별 표시
	      const day30Values = new Array(30).fill(null);
	      day30Values[29] = m * 30 + b;

	      // uplot 데이터
	      const uplotData = [
	        days,
	        actualValues,
	        predictValues,
	        day30Values
	      ];

	      // 기존 차트 제거 후 생성
	      if (chart) {
	        chart.destroy();
	      }

	      chart = new uPlot(opts, uplotData, document.querySelector("#lineChart"));
	    })
	    .catch(error => console.log("에러 :", error));
	  });
	});
</script>

<%@ include file="../include/footer.jsp"%>