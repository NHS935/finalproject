document.addEventListener("DOMContentLoaded", function() {
	let predictChart = null;
	let modalInstance = null; // ✅ 전역 변수
	let seriesVisibility = [true, true, true, true];
	let lottieAnimation = null; // ✅ Lottie 애니메이션 변수

	const predictBtn = document.querySelector("#predictBtn");
	if (!predictBtn) return;

	const modalEl = document.getElementById('predictModal');

	modalEl.addEventListener('shown.bs.modal', function() {
		const currentYm = document.querySelector("#searchYm").value.replace("-", "");
		if (currentYm) {
			fetchPredictData(currentYm);
		}
	});

	modalEl.addEventListener('hide.bs.modal', function() {
		// 포커스된 요소 해제
		if (document.activeElement && modalEl.contains(document.activeElement)) {
			document.activeElement.blur();
		}
	});

	modalEl.addEventListener('hidden.bs.modal', function() {
		if (predictChart) {
			predictChart.destroy();
			predictChart = null;	
		}
		document.querySelector("#predictChart").innerHTML = '';
		document.querySelector("#predictResult").style.display = "none";
		document.querySelector("#predictSpinner").style.display = "none";

		// ✅ Lottie 정리
		if (lottieAnimation) {
			lottieAnimation.destroy();
			lottieAnimation = null;
		}
	});

	predictBtn.addEventListener("click", function() {
		const ym = document.querySelector("#searchYm").value.replace("-", "");
		if (!ym) {
			alert("조회 연월을 선택하세요.");
			return;
		}

		if (!modalInstance) {
			modalInstance = new bootstrap.Modal(modalEl);
		}
		modalInstance.show();
	});

	// 나머지 함수들은 그대로...
	function fetchPredictData(yearMonth) {
		if (predictChart) {
		    predictChart.destroy();
		    predictChart = null;
		  }

		// ✅ 스피너 표시, 결과/차트 숨기기
		document.querySelector("#predictSpinner").style.display = "block";
		document.querySelector("#predictResult").style.display = "none";
		document.querySelector("#predictChart").innerHTML = '';

		// ✅ Lottie 애니메이션 시작
		if (lottieAnimation) {
			lottieAnimation.destroy();
			lottieAnimation = null;
		}

		lottieAnimation = lottie.loadAnimation({
			container: document.getElementById('lottie-container'),
			renderer: 'svg',
			loop: true,
			autoplay: true,
			path: '/animations/LoadingGraph.json' // ✅ 경로 수정
		});

		fetch("/levy/predict", {
			method: "post",
			headers: { "Content-Type": "application/json;charset=UTF-8" },
			body: JSON.stringify({ yearMonth })
		})
			.then(r => r.json())
			.then(data => {

				setTimeout(() => {
					const days = data.days;
					const actualValues = data.values;
					const predictedValues = data.predicted;
					const totalMonth = data.amt;

					const futurePredict = new Array(days.length).fill(null);

					// 마지막 미래 예측값의 인덱스 찾기
					let lastFutureIndex = -1;
					for (let i = days.length - 1; i >= 0; i--) {
						if (actualValues[i] == null && predictedValues[i] != null) {
							lastFutureIndex = i;
							break; // 가장 마지막 미래 예측값 찾으면 중단
						}
					}

					// ✅ 마지막 인덱스에만 값 설정
					if (lastFutureIndex !== -1) {
						futurePredict[lastFutureIndex] = predictedValues[lastFutureIndex];
					}

					const resultDiv = document.querySelector("#predictResult");
					const resultText = document.querySelector("#predictResultText");
					resultDiv.style.display = "block";
					resultText.innerHTML =
						"<strong>" + yearMonth.substr(0, 4) + "년 " + yearMonth.substr(4, 2) + "월</strong>" +
						" 예상 관리비: <strong style='font-size:20px; color:white;'>" + totalMonth.toLocaleString() + "원</strong>";

					drawPredictChart(yearMonth, days, actualValues, predictedValues, futurePredict);
					createCustomLegend();

					document.querySelector("#predictSpinner").style.display = "none";
					if (lottieAnimation) {
						lottieAnimation.destroy();
						lottieAnimation = null;
					}
				}, 2500); //2.5초
			})
			.catch(err => {
				console.error("예측 데이터 로드 실패:", err);
				document.querySelector("#predictSpinner").style.display = "none";
				if (lottieAnimation) {
					lottieAnimation.destroy();
					lottieAnimation = null;
				}
				alert("예측 데이터를 불러오는데 실패했습니다.");
			});
	}

	function createCustomLegend() {
		const legendContainer = document.querySelector("#customLegend");

		const legendItems = [
			{ label: "실제 사용량", color: "#3b82f6", seriesIdx: 1 },
			{ label: "예측 기준선", color: "#f59e0b", seriesIdx: 2 },
			{ label: "미래 예측", color: "#ef4444", seriesIdx: 3 }
		];

		legendContainer.innerHTML = '';

		legendItems.forEach(item => {
			const legendItem = document.createElement('div');
			legendItem.className = 'legend-item';
			legendItem.setAttribute('data-series-idx', item.seriesIdx);
			legendItem.setAttribute('data-color', item.color); 
			legendItem.style.cssText = `
        display: flex; 
        align-items: center; 
        gap: 7px; 
        padding: 7px 16px; 
        background:${item.color}; 
        border-radius: 6px; 
        font-size: 13px; 
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s ease;
        user-select: none;
      `;

			const marker = document.createElement('div');
			marker.style.cssText = `
        width: 12px; 
        height: 12px; 
        background: ${item.color};
		border: 2px solid white; 
        border-radius: 50%; 
        flex-shrink: 0;
      `;

			const label = document.createElement('span');
			label.textContent = item.label;

			legendItem.appendChild(marker);
			legendItem.appendChild(label);
			legendContainer.appendChild(legendItem);

			legendItem.addEventListener('mouseenter', function() {
				if (seriesVisibility[item.seriesIdx]) {
					 this.style.opacity = '0.8';
				}
			});

			legendItem.addEventListener('mouseleave', function() {
				if (seriesVisibility[item.seriesIdx]) {
					this.style.opacity = '1';
					this.style.background = originalColor;
				}
			});

			legendItem.addEventListener('click', function() {
				const seriesIdx = parseInt(this.getAttribute('data-series-idx'));
				toggleSeries(seriesIdx, this);
			});
		});
	}

	function toggleSeries(seriesIdx, legendEl) {
		if (!predictChart) return;

		seriesVisibility[seriesIdx] = !seriesVisibility[seriesIdx];
		const isVisible = seriesVisibility[seriesIdx];
		const originalColor = legendEl.getAttribute('data-color');

		predictChart.setSeries(seriesIdx, { show: isVisible });

		if (isVisible) {
		   // ✅ 보이는 상태: 원래 색
		   legendEl.style.opacity = '1';
		   legendEl.style.background = originalColor;
		 } else {
		   // ✅ 숨김 상태: 흐리게
		   legendEl.style.opacity = '0.3';
		   legendEl.style.background = '#888';
		 }
	}

	function drawPredictChart(yearMonth, days, actualValues, predictedValues, futurePredict) {
		seriesVisibility = [true, true, true, true];

		const chartContainer = document.querySelector("#predictChart");
		const containerWidth = chartContainer.offsetWidth || 800;

		const opts = {
			width: containerWidth,
			height: 550,
			scales: {
				x: { time: false },
				y: {
					auto: true,
					range: (u, min, max) => {
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
					values: (u, vals) => vals.map(v => v + '일'),
					splits: (u) => {
						let splits = [1];
						for (let i = 5; i <= days.length; i += 5) {
							splits.push(i);
						}
						if (splits[splits.length - 1] !== days.length) {
							splits.push(days.length);
						}
						return splits;
					}
				},
				{
					stroke: "#475569",
					grid: {
						stroke: (u, ticks, axisIdx, tickIdx, value) => value === 0 ? "#374151" : "#e5e7eb",
						width: (u, ticks, axisIdx, tickIdx, value) => value === 0 ? 2 : 1
					},
					ticks: { stroke: "#cbd5e1", width: 1 },
					font: "14px 'Segoe UI', sans-serif",
					values: (u, vals) => vals.map(v => v.toLocaleString() + '원'),
					size: 80
				}
			],
			plugins: [tooltipPlugin()],
			legend: { show: false },
			cursor: {
				show: true,
				drag: { x: false, y: false },
				points: {
					show: true,
					size: 8,
					width: 2,
					stroke: (u, seriesIdx) => u.series[seriesIdx].stroke,
					fill: "#ffffff"
				}
			},
			series: [
				{ label: "일자" },
				{
					label: "실제 사용량",
					stroke: "#3b82f6",
					width: 4,
					points: { show: true, size: 7, fill: "#3b82f6" }
				},
				{
					label: "예측 기준선",
					stroke: "#f59e0b",
					width: 3,
					dash: [8, 3],
					points: { show: false },
                    drawStyle: 1
				},
				{
					label: "미래 예측",
					stroke: "#ef4444",
					width: 4.5,
					points: { show: true, size: 10, fill: "#ef4444" }
				}
			]
		};

		const plotData = [days, actualValues, predictedValues, futurePredict];

		if (predictChart) predictChart.destroy();
		chartContainer.innerHTML = '';
		predictChart = new uPlot(opts, plotData, chartContainer);
	}

	function tooltipPlugin() {
		let el;
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
					document.querySelector("#predictChart").appendChild(el);
				},
				setCursor: function(u) {
					const idx = u.cursor.idx;
					const left = u.cursor.left;
					const top = u.cursor.top;

					if (idx == null) {
						el.style.display = "none";
						return;
					}

					const actual = u.data[1][idx];
					const predict = u.data[2][idx];
					const future = u.data[3][idx];

					let html = "<div style='font-weight:600;margin-bottom:8px;color:#475569;'>" +
						u.data[0][idx] + "일</div>";

					if (actual != null && seriesVisibility[1]) {
						html += "<div style='color:#3b82f6;margin:4px 0;font-weight:600;'>실제: " + actual.toLocaleString() + "원</div>";
					}

					if (future != null && seriesVisibility[3]) {
						html += "<div style='color:#ef4444;margin:4px 0;font-weight:600;'>예측: " + future.toLocaleString() + "원</div>";
					} else if (predict != null && actual == null && seriesVisibility[2]) {
						html += "<div style='color:#f59e0b;margin:4px 0;'>예측선: " + predict.toLocaleString() + "원</div>";
					}

					el.innerHTML = html;

					const tooltipWidth = 180;
					const tooltipHeight = 90;
					let tooltipLeft = left -50;
					let tooltipTop = top - tooltipHeight + 150;

					if (tooltipLeft < 0) tooltipLeft = 5;
					if (tooltipLeft + tooltipWidth > u.bbox.width) tooltipLeft = u.bbox.width - tooltipWidth - 5;
					if (tooltipTop < 0) tooltipTop = top + 25;

					el.style.left = tooltipLeft + "px";
					el.style.top = tooltipTop + "px";
					el.style.display = "block";
				}
			}
		};
	}

	window.addEventListener('resize', () => {
		if (predictChart && document.getElementById('predictModal').classList.contains('show')) {
			const newWidth = document.querySelector("#predictChart").offsetWidth;
			if (newWidth > 0) {
				predictChart.setSize({
					width: newWidth,
					height: 550
				});
			}
		}
	});
});