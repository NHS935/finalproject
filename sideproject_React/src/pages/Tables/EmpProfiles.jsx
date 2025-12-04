import { useMemo, useState } from "react";
import ComponentCard from "../../components/common/ComponentCard";
import PageBreadcrumb from "../../components/common/PageBreadCrumb";
import PageMeta from "../../components/common/PageMeta";
import Badge from "../../components/ui/badge/Badge";
import {
  Table,
  TableBody,
  TableCell,
  TableHeader,
  TableRow,
} from "../../components/ui/table";
import aptMangeData from "../../data/aptManageDB";
const apartments = aptMangeData.rowData;
import employees from "../../data/emp";

const statusColor = (status) => {
  if (status === "재직") return "success";
  if (status === "휴직") return "warning";
  return "error";
};

// 인사관리 테이블 페이지
export default function EmpProfiles() {
  const [allEmployees, setAllEmployees] = useState(employees);
  const [selectedAptId, setSelectedAptId] = useState("");
  const statusTabs = ["재직", "휴직", "퇴사"];
  const [statusTab, setStatusTab] = useState(statusTabs[0]);
  const [roleFilter, setRoleFilter] = useState("");
  const [deptFilter, setDeptFilter] = useState("");
  const [nameSort, setNameSort] = useState("asc");
  const [draftEmployee, setDraftEmployee] = useState({
    name: "",
    department: "",
    role: "",
    apartmentId: "",
    contact: "",
    joinDate: "",
    status: statusTabs[0],
  });

  const roleOptions = useMemo(
    () => Array.from(new Set(allEmployees.map((emp) => emp.role))),
    [allEmployees]
  );

  const departmentOptions = useMemo(
    () => Array.from(new Set(allEmployees.map((emp) => emp.department))),
    [allEmployees]
  );

  const aptOptions = useMemo(
    () => apartments.map((apt) => ({ id: apt.id, name: apt.name })),
    []
  );

  const aptNameMap = useMemo(
    () => Object.fromEntries(apartments.map((apt) => [apt.id, apt.name])),
    []
  );

  const handleDraftChange = (field, value) => {
    setDraftEmployee((prev) => ({ ...prev, [field]: value }));
  };

  const handleCreateEmployee = (e) => {
    e.preventDefault();
    if (!draftEmployee.name || !draftEmployee.apartmentId) {
      return;
    }
    const nextId = Math.max(...allEmployees.map((emp) => emp.id)) + 1;
    const newEmployee = {
      id: nextId,
      name: draftEmployee.name,
      apartmentId: Number(draftEmployee.apartmentId),
      department: draftEmployee.department || "행정",
      role: draftEmployee.role || "행정 주무관",
      joinDate: draftEmployee.joinDate || new Date().toISOString().slice(0, 10),
      status: draftEmployee.status || statusTabs[0],
      contact: draftEmployee.contact || "010-0000-0000",
    };
    setAllEmployees((prev) => [...prev, newEmployee]);
    setDraftEmployee({
      name: "",
      department: "",
      role: "",
      apartmentId: "",
      contact: "",
      joinDate: "",
      status: statusTabs[0],
    });
  };

  const filteredEmployees = useMemo(() => {
    let list = allEmployees;

    if (selectedAptId) {
      const aptIdNum = Number(selectedAptId);
      list = list.filter((emp) => emp.apartmentId === aptIdNum);
    }

    list = list.filter((emp) => emp.status === statusTab);

    if (roleFilter) {
      list = list.filter((emp) => emp.role === roleFilter);
    }

    if (deptFilter) {
      list = list.filter((emp) => emp.department === deptFilter);
    }

    list = [...list].sort((a, b) =>
      nameSort === "asc"
        ? a.name.localeCompare(b.name, "ko-KR")
        : b.name.localeCompare(a.name, "ko-KR")
    );

    return list;
  }, [allEmployees, selectedAptId, statusTab, roleFilter, deptFilter, nameSort]);

  return (
    <>
      <PageMeta
        title="Employee Profiles | TailAdmin"
        description="사원 프로필/인사관리 테이블 페이지"
      />
      <PageBreadcrumb pageTitle="직원 관리" />
      <div className="grid grid-cols-1 gap-6 xl:grid-cols-2">
        <ComponentCard title="직원 목록">
          <div className="flex flex-wrap items-center gap-2 px-6 pt-2">
            {statusTabs.map((tab) => {
              const active = statusTab === tab;
              return (
                <button
                  key={tab}
                  type="button"
                  onClick={() => setStatusTab(tab)}
                  className={`rounded-full px-4 py-2 text-sm font-medium transition-colors ${
                    active
                      ? "bg-blue-600 text-white"
                      : "bg-gray-100 text-gray-700 hover:bg-gray-200 dark:bg-white/[0.06] dark:text-gray-200"
                  }`}
                >
                  {tab}
                </button>
              );
            })}
          </div>

          <div className="flex flex-wrap gap-3 px-6 pb-2 pt-3">
            <select
              value={selectedAptId}
              onChange={(e) => setSelectedAptId(e.target.value)}
              className="rounded-lg border border-gray-200 bg-white px-3 py-2 text-sm text-gray-700 dark:border-white/[0.08] dark:bg-white/[0.04] dark:text-gray-200"
            >
              <option value="">아파트 전체</option>
              {aptOptions.map((apt) => (
                <option key={apt.id} value={apt.id}>
                  {apt.name}
                </option>
              ))}
            </select>

            <select
              value={roleFilter}
              onChange={(e) => setRoleFilter(e.target.value)}
              className="rounded-lg border border-gray-200 bg-white px-3 py-2 text-sm text-gray-700 dark:border-white/[0.08] dark:bg-white/[0.04] dark:text-gray-200"
            >
              <option value="">직책 전체</option>
              {roleOptions.map((role) => (
                <option key={role} value={role}>
                  {role}
                </option>
              ))}
            </select>

            <select
              value={deptFilter}
              onChange={(e) => setDeptFilter(e.target.value)}
              className="rounded-lg border border-gray-200 bg-white px-3 py-2 text-sm text-gray-700 dark:border-white/[0.08] dark:bg-white/[0.04] dark:text-gray-200"
            >
              <option value="">부서 전체</option>
              {departmentOptions.map((dept) => (
                <option key={dept} value={dept}>
                  {dept}
                </option>
              ))}
            </select>

            <select
              value={nameSort}
              onChange={(e) => setNameSort(e.target.value)}
              className="rounded-lg border border-gray-200 bg-white px-3 py-2 text-sm text-gray-700 dark:border-white/[0.08] dark:bg-white/[0.04] dark:text-gray-200"
            >
              <option value="asc">이름순 오름차순</option>
              <option value="desc">이름순 내림차순</option>
            </select>
          </div>

          <div className="overflow-hidden rounded-xl border border-gray-200 bg-white dark:border-white/[0.05] dark:bg-white/[0.03]">
            <div className="max-w-full overflow-x-auto">
              <Table>
                <TableHeader className="border-b border-gray-100 dark:border-white/[0.05]">
                  <TableRow>
                    <TableCell
                      isHeader
                      className="px-4 py-3 font-medium text-gray-500 text-start text-theme-xs dark:text-gray-400"
                    >
                      순번
                    </TableCell>
                    <TableCell
                      isHeader
                      className="px-5 py-3 font-medium text-gray-500 text-start text-theme-xs dark:text-gray-400"
                    >
                      이름
                    </TableCell>
                    <TableCell
                      isHeader
                      className="px-5 py-3 font-medium text-gray-500 text-start text-theme-xs dark:text-gray-400"
                    >
                      아파트
                    </TableCell>
                    <TableCell
                      isHeader
                      className="px-5 py-3 font-medium text-gray-500 text-start text-theme-xs dark:text-gray-400"
                    >
                      부서
                    </TableCell>
                    <TableCell
                      isHeader
                      className="px-5 py-3 font-medium text-gray-500 text-start text-theme-xs dark:text-gray-400"
                    >
                      직책
                    </TableCell>
                    <TableCell
                      isHeader
                      className="px-5 py-3 font-medium text-gray-500 text-start text-theme-xs dark:text-gray-400"
                    >
                      입사일
                    </TableCell>
                    <TableCell
                      isHeader
                      className="px-5 py-3 font-medium text-gray-500 text-start text-theme-xs dark:text-gray-400"
                    >
                      상태
                    </TableCell>
                    <TableCell
                      isHeader
                      className="px-5 py-3 font-medium text-gray-500 text-start text-theme-xs dark:text-gray-400"
                    >
                      연락처
                    </TableCell>
                  </TableRow>
                </TableHeader>

                <TableBody className="divide-y divide-gray-100 dark:divide-white/[0.05]">
                  {filteredEmployees.map((emp, idx) => (
                    <TableRow
                      key={emp.id}
                      className="hover:bg-gray-50 dark:hover:bg-white/[0.02] transition-colors"
                    >
                      <TableCell className="px-4 py-3 sm:px-6 text-start text-theme-sm text-gray-800 dark:text-white/90">
                        {idx + 1}
                      </TableCell>
                      <TableCell className="px-5 py-4 sm:px-6 text-start text-theme-sm text-gray-800 dark:text-white/90">
                        {emp.name}
                      </TableCell>
                      <TableCell className="px-4 py-3 text-gray-500 text-start text-theme-sm dark:text-gray-400">
                        {aptNameMap[emp.apartmentId] || `APT-${emp.apartmentId}`}
                      </TableCell>
                      <TableCell className="px-4 py-3 text-gray-500 text-start text-theme-sm dark:text-gray-400">
                        {emp.department}
                      </TableCell>
                      <TableCell className="px-4 py-3 text-gray-500 text-start text-theme-sm dark:text-gray-400">
                        {emp.role}
                      </TableCell>
                      <TableCell className="px-4 py-3 text-gray-500 text-start text-theme-sm dark:text-gray-400">
                        {emp.joinDate}
                      </TableCell>
                      <TableCell className="px-4 py-3 text-gray-500 text-start text-theme-sm dark:text-gray-400">
                        <Badge size="sm" color={statusColor(emp.status)}>
                          {emp.status}
                        </Badge>
                      </TableCell>
                      <TableCell className="px-4 py-3 text-gray-500 text-start text-theme-sm dark:text-gray-400">
                        {emp.contact}
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
          </div>
        </ComponentCard>
        <ComponentCard title="직원 생성">
          <form className="space-y-4 px-6 py-4" onSubmit={handleCreateEmployee}>
            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
              <label className="space-y-1 text-sm text-gray-700 dark:text-gray-200">
                <span className="block">이름</span>
                <input
                  type="text"
                  value={draftEmployee.name}
                  onChange={(e) => handleDraftChange("name", e.target.value)}
                  className="w-full rounded-lg border border-gray-200 px-3 py-2 text-gray-800 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-400 dark:border-white/[0.08] dark:bg-white/[0.04] dark:text-white"
                  placeholder="홍길동"
                  required
                />
              </label>
              <label className="space-y-1 text-sm text-gray-700 dark:text-gray-200">
                <span className="block">아파트</span>
                <select
                  value={draftEmployee.apartmentId}
                  onChange={(e) => handleDraftChange("apartmentId", e.target.value)}
                  className="w-full rounded-lg border border-gray-200 px-3 py-2 text-gray-800 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-400 dark:border-white/[0.08] dark:bg-white/[0.04] dark:text-white"
                  required
                >
                  <option value="">선택하세요</option>
                  {aptOptions.map((apt) => (
                    <option key={apt.id} value={apt.id}>
                      {apt.name}
                    </option>
                  ))}
                </select>
              </label>
            </div>

            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
              <label className="space-y-1 text-sm text-gray-700 dark:text-gray-200">
                <span className="block">부서</span>
                <input
                  type="text"
                  value={draftEmployee.department}
                  onChange={(e) => handleDraftChange("department", e.target.value)}
                  className="w-full rounded-lg border border-gray-200 px-3 py-2 text-gray-800 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-400 dark:border-white/[0.08] dark:bg-white/[0.04] dark:text-white"
                  placeholder="행정"
                />
              </label>
              <label className="space-y-1 text-sm text-gray-700 dark:text-gray-200">
                <span className="block">직책</span>
                <input
                  type="text"
                  value={draftEmployee.role}
                  onChange={(e) => handleDraftChange("role", e.target.value)}
                  className="w-full rounded-lg border border-gray-200 px-3 py-2 text-gray-800 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-400 dark:border-white/[0.08] dark:bg-white/[0.04] dark:text-white"
                  placeholder="행정 주무관"
                />
              </label>
            </div>

            <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
              <label className="space-y-1 text-sm text-gray-700 dark:text-gray-200">
                <span className="block">입사일</span>
                <input
                  type="date"
                  value={draftEmployee.joinDate}
                  onChange={(e) => handleDraftChange("joinDate", e.target.value)}
                  className="w-full rounded-lg border border-gray-200 px-3 py-2 text-gray-800 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-400 dark:border-white/[0.08] dark:bg-white/[0.04] dark:text-white"
                />
              </label>
              <label className="space-y-1 text-sm text-gray-700 dark:text-gray-200">
                <span className="block">상태</span>
                <select
                  value={draftEmployee.status}
                  onChange={(e) => handleDraftChange("status", e.target.value)}
                  className="w-full rounded-lg border border-gray-200 px-3 py-2 text-gray-800 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-400 dark:border-white/[0.08] dark:bg-white/[0.04] dark:text-white"
                >
                  {statusTabs.map((st) => (
                    <option key={st} value={st}>
                      {st}
                    </option>
                  ))}
                </select>
              </label>
            </div>

            <label className="space-y-1 text-sm text-gray-700 dark:text-gray-200">
              <span className="block">연락처</span>
              <input
                type="text"
                value={draftEmployee.contact}
                onChange={(e) => handleDraftChange("contact", e.target.value)}
                className="w-full rounded-lg border border-gray-200 px-3 py-2 text-gray-800 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-1 focus:ring-blue-400 dark:border-white/[0.08] dark:bg-white/[0.04] dark:text-white"
                placeholder="010-0000-0000"
              />
            </label>

            <div className="flex justify-end pt-2">
              <button
                type="submit"
                className="rounded-xl bg-blue-600 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-offset-2 dark:bg-blue-500 dark:hover:bg-blue-600"
              >
                생성
              </button>
            </div>
          </form>
        </ComponentCard>
      </div>
    </>
  );
}
