import { useNavigate } from "react-router-dom";
import { AllCommunityModule, ModuleRegistry, themeAlpine, themeBalham, themeMaterial, themeQuartz } from "ag-grid-community";
import { AgGridReact } from "ag-grid-react";
import aptMangeData from "../../../data/aptManageDB";
import { useState } from "react";
ModuleRegistry.registerModules([AllCommunityModule]);
 

function AptTable() {
  const navigate = useNavigate();

    const[rowData, setRowData] = useState(aptMangeData.rowData);
    const[colDefs, setColDefs] = useState(aptMangeData.colDefs);

    const rowClick = (e) =>{
      console.log("check => ", e.data);
      const aptDetail = e.data;
      navigate(`/AptDetail/${aptDetail.id}`);
    }

  return (
    <div style={{ height: 500 }}>
         <AgGridReact 
          /* 페이지 나누기 적용 시작 */
        pagination={true}
        paginationAutoPageSize={true}
        /* 페이지 나누기 적용 끝 */
         rowData={rowData}
         columnDefs={colDefs}
         onRowClicked={rowClick}
         theme={themeQuartz}
         />
    </div>
  );
}

export default AptTable