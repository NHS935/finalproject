// 차트 컴포넌트
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Tooltip,
  Legend,
} from "chart.js";
import { Line } from "react-chartjs-2";

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Tooltip,
  Legend
);

function AptPriceChart({ apt }) {
  if (!apt || !apt.priceHistoryIndex || apt.priceHistoryIndex.length === 0) {
    return null;
  }

  const startYear = apt.historyStartYear ?? 2015;
  const indices = apt.priceHistoryIndex;
  const lastIndex = indices[indices.length - 1];
  const area = apt.areaPyeong ?? 0;

  // x축: 연도
  const labels = indices.map((_, i) => startYear + i);

  // y축: 평당가, 총가격(만원)
  const pricesPerPyeong = indices.map((idx) =>
    Math.round((apt.currentPrice * idx) / lastIndex)
  );
  const totalPrices = pricesPerPyeong.map((p) => Math.round(p * area));

  const data = {
    labels,
    datasets: [
      {
        label: "평당가 (만원/3.3㎡)",
        data: pricesPerPyeong,
        borderColor: "rgba(37, 99, 235, 0.8)",
        backgroundColor: "rgba(37, 99, 235, 0.15)",
        tension: 0.3,
        pointRadius: 2.5,
      },
      {
        label: "총가격 (만원)",
        data: totalPrices,
        borderColor: "rgba(16, 185, 129, 0.85)",
        backgroundColor: "rgba(16, 185, 129, 0.12)",
        tension: 0.3,
        pointRadius: 2.5,
      },
    ],
  };

  const options = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        display: true,
        labels: {
          font: { size: 10 },
        },
      },
      tooltip: {
        callbacks: {
          label: (ctx) =>
            `${ctx.dataset.label}: ${ctx.parsed.y.toLocaleString()} 만원`,
        },
      },
    },
    scales: {
      x: {
        ticks: {
          font: { size: 10 },
        },
      },
      y: {
        ticks: {
          callback: (value) => value.toLocaleString(),
          font: { size: 10 },
        },
      },
    },
  };

  return (
    <div className="mt-3 h-40 rounded-lg bg-white">
      <Line data={data} options={options} />
    </div>
  );
}

export default AptPriceChart;

