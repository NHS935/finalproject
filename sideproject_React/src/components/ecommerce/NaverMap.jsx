import { useEffect, useRef } from "react";
import { DAEJEON_APTS } from "../../data/daejeon_aptsDB";
import "./naver-map.css";

function NaverMap({ selectedApt, onAptSelect }) {
  const mapRef = useRef(null);
  const mapInstanceRef = useRef(null);

  // 지도 초기화
  useEffect(() => {
    const { naver } = window;
    if (!naver || !mapRef.current) return;
    if (!DAEJEON_APTS || DAEJEON_APTS.length === 0) return;
    if (mapInstanceRef.current) return;

    const first = DAEJEON_APTS[0];
    const defaultCenter = new naver.maps.LatLng(first.lat, first.lng);

    const map = new naver.maps.Map(mapRef.current, {
      center: defaultCenter,
      zoom: 13,
    });
    mapInstanceRef.current = map;

    const bounds = new naver.maps.LatLngBounds();

    DAEJEON_APTS.forEach((apt) => {
      const position = new naver.maps.LatLng(apt.lat, apt.lng);
      const pricePerText = [
        apt.currentPrice?.toLocaleString?.() ?? apt.currentPrice,
        apt.priceUnit,
      ]
        .filter(Boolean)
        .join(" ");
      const areaText =
        apt.areaPyeong != null
          ? `${apt.areaPyeong.toLocaleString()}평`
          : "";
      const totalText =
        apt.totalPrice != null
          ? `${apt.totalPrice.toLocaleString()} 만원`
          : "";

      const marker = new naver.maps.Marker({
        map,
        position,
        title: apt.name,
        clickable: true,
        icon: {
          content: `
            <div class="naver-flag-marker">
              <span class="naver-flag-name">${apt.name}</span>
              <span class="naver-flag-price">평당가 ${pricePerText}</span>
              <span class="naver-flag-total">${areaText} · 총 ${totalText}</span>
              <span class="naver-flag-pointer"></span>
            </div>
          `,
          size: new naver.maps.Size(160, 56),
          anchor: new naver.maps.Point(80, 56),
        },
      });

      // 마커 클릭 시 해당 위치로 이동 + 콜백 호출
      naver.maps.Event.addListener(marker, "click", () => {
        map.panTo(position);
        map.setZoom(15);

        if (onAptSelect) {
          onAptSelect(apt);
        }
      });

      bounds.extend(position);
    });

    map.fitBounds(bounds);
  }, [onAptSelect]);

  // selectedApt 변경 시 지도 중심 이동
  useEffect(() => {
    const { naver } = window;
    const map = mapInstanceRef.current;
    if (!naver || !map || !selectedApt) return;

    const center = new naver.maps.LatLng(selectedApt.lat, selectedApt.lng);
    map.panTo(center);
    map.setZoom(15);
  }, [selectedApt]);

  return (
    <div
      ref={mapRef}
      style={{
        width: "100%",
        height: "360px",
        borderRadius: "1rem",
        overflow: "hidden",
      }}
    />
  );
}

export default NaverMap;
