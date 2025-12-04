import { useMemo, useRef, useEffect } from "react";
import { AgGridReact } from "ag-grid-react";
import { DAEJEON_APTS } from "../../data/daejeon_aptsDB";

function NaverMapTable({ onRowClick, selectedApt }) {
  const gridApiRef = useRef(null);

  // Grid columns
  const columnDefs = useMemo(
    () => [
      {
        headerName: "아파트명",
        field: "name",
        flex: 2,
        minWidth: 120,
        sortable: true,
        filter: "agTextColumnFilter",
        tooltipField: "name",
      },
      {
        headerName: "구",
        field: "district",
        flex: 1,
        minWidth: 80,
        sortable: true,
        filter: "agTextColumnFilter",
        filterParams: {
          suppressSelectAll: false,
          searchDebounceMs: 100,
        },
      },
      {
        headerName: "평단가",
        field: "currentPrice",
        flex: 0.95,
        minWidth: 100,
        sortable: true,
        filter: "agNumberColumnFilter",
        filterParams: {
          filterOptions: ["greaterThan", "lessThan", "inRange", "equals"],
          defaultOption: "greaterThan",
          debounceMs: 200,
        },
        valueFormatter: (params) =>
          params.value != null ? params.value.toLocaleString() : "",
        cellClass: "ag-right-aligned-cell",
      },
      {
        headerName: "평수",
        field: "areaPyeong",
        flex: 0.65,
        minWidth: 70,
        sortable: true,
        filter: "agNumberColumnFilter",
        valueFormatter: (params) =>
          params.value != null ? params.value.toLocaleString() : "",
        cellClass: "ag-right-aligned-cell",
      },
      {
        headerName: "총가격",
        field: "totalPrice",
        flex: 1,
        minWidth: 110,
        sortable: true,
        filter: "agNumberColumnFilter",
        valueFormatter: (params) =>
          params.value != null ? params.value.toLocaleString() : "",
        cellClass: "ag-right-aligned-cell",
      },
    ],
    []
  );

  // Data
  const rowData = useMemo(
    () =>
      DAEJEON_APTS.map((apt, idx) => ({
        id: apt.id ?? idx,
        ...apt,
      })),
    []
  );

  const onGridReady = (params) => {
    gridApiRef.current = params.api;
    params.api.sizeColumnsToFit();
  };

  const handleRowClicked = (event) => {
    if (onRowClick) {
      onRowClick(event.data);
    }
  };

  // 선택된 아파트 행 하이라이트
  useEffect(() => {
    const api = gridApiRef.current;
    if (!api) return;

    if (!selectedApt) {
      api.deselectAll();
      return;
    }

    api.forEachNode((node) => {
      const isSelected = node.data.id === selectedApt.id;
      node.setSelected(isSelected);
    });
  }, [selectedApt]);

  return (
    <div className="flex flex-col h-full">
      <div
        className="flex-1 ag-theme-alpine rounded-xl text-[10px]"
        style={{ width: "100%", height: "100%" }}
      >
        <AgGridReact
          rowData={rowData}
          columnDefs={columnDefs}
          rowSelection="single"
          onGridReady={onGridReady}
          onRowClicked={handleRowClicked}
          headerHeight={30}
          rowHeight={30}
          enableBrowserTooltips={true}
          animateRows={true}
        />
      </div>
    </div>
  );
}
export default NaverMapTable;
