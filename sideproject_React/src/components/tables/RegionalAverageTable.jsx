import { Table, TableBody, TableCell, TableHeader, TableRow } from "../ui/table";

export default function RegionalAverageTable({ 
  data, 
  expandedRows, 
  toggleRow, 
  regions 
}) {
  // renderRows 함수
  const renderRows = (items, depth = 0) => {
    const rows = [];

    items.forEach((item) => {
      const hasChildren = item.children && item.children.length > 0;
      const isExpanded = expandedRows.has(item.id);

      rows.push(
        <TableRow 
          key={item.id}
          className="border-b border-gray-100 dark:border-gray-800 hover:bg-gray-50 dark:hover:bg-gray-800/50"
        >
          {/* 항목명 */}
          <TableCell className="px-4 py-3 text-sm text-gray-700 dark:text-gray-300 whitespace-nowrap">
            <div className="flex items-center" style={{ paddingLeft: `${depth * 20}px` }}>
              {hasChildren ? (
                <button
                  onClick={() => toggleRow(item.id)}
                  className="mr-2 w-5 h-5 flex items-center justify-center text-blue-500 hover:text-blue-700 font-bold"
                >
                  {isExpanded ? "−" : "+"}
                </button>
              ) : (
                <span className="mr-2 w-5" />
              )}
              <span className={depth === 0 ? "font-medium" : ""}>
                {item.name}
              </span>
            </div>
          </TableCell>
          
          {/* 지역별 값 */}
          {item.values.map((value, idx) => (
            <TableCell
              key={idx}
              className="px-4 py-3 text-sm text-right text-gray-600 dark:text-gray-400"
            >
              {typeof value === "number" ? value.toLocaleString() : value}
            </TableCell>
          ))}
        </TableRow>
      );

      // 하위 항목 (펼쳐졌을 때만)
      if (hasChildren && isExpanded) {
        rows.push(...renderRows(item.children, depth + 1));
      }
    });

    return rows;
  };

  return (
    <div className="rounded-2xl border border-gray-200 bg-white dark:border-gray-800 dark:bg-white/[0.03]">
      <div className="px-6 py-5 flex justify-between items-center">
        <h3 className="text-base font-medium text-gray-800 dark:text-white/90">
          관리비등 세부항목 지역별 평균표
        </h3>
        <span className="text-sm text-gray-500 dark:text-gray-400">
          (단위:원/㎡, 주거전용면적기준)
        </span>
      </div>
      
      <div className="border-t border-gray-100 dark:border-gray-800 overflow-x-auto">
        <Table>
          <TableHeader>
            <TableRow className="bg-gray-50 dark:bg-gray-800/50">
              <TableCell
                isHeader
                className="px-4 py-3 text-left text-sm font-medium text-gray-700 dark:text-gray-300 whitespace-nowrap w-[250px]"
              >
                분류(클릭시)
              </TableCell>
              {regions.map((region) => (
                <TableCell
                  key={region}
                  isHeader
                  className="px-4 py-3 text-right text-sm font-medium text-gray-700 dark:text-gray-300 whitespace-nowrap"
                >
                  {region}
                </TableCell>
              ))}
            </TableRow>
          </TableHeader>
          
          <TableBody>
            {renderRows(data)}
          </TableBody>
        </Table>
      </div>
    </div>
  );
}