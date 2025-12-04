let stompClient = null;
let gContextPath = "";

let user = null;
let group = null;
let userAll = "ALL_MBER";
let system = "SYSTEM";

document.addEventListener("DOMContentLoaded", () => {
    user = document.body.dataset.user;
    group = document.body.dataset.group;
    
    const el = document.querySelector("[data-context-path]");
    gContextPath = el ? el.dataset.contextPath : "";
    
    // WebSocket 연결
    connectWebSocket();
    
    // 로그인 후 1번만 새알림 모달이 뜨기 위한 함수
    (function() {
        const lastUser = sessionStorage.getItem('lastLoggedInUser');
    
        if (lastUser !== user) {
            sessionStorage.clear();
            sessionStorage.setItem('lastLoggedInUser', user);
        }
    })();
});

function connectWebSocket() {
    const socket = new SockJS(gContextPath + "/ws-ntcn");
    stompClient = Stomp.over(socket);

    const rcverIds = [user, group, userAll, system];

    stompClient.connect({}, function(frame) {
        console.log("WebSocket 연결: " + frame);

        // 토픽 모두 구독
        rcverIds.forEach(id => {
            stompClient.subscribe("/topic/ntcn/" + id, function(message) {
                const ntcn = JSON.parse(message.body);

                // 1. 새 알림이 있으면 팝업 + 배지 증가 + 드롭다운 영역 업데이트
                if (ntcn.ntcnCn) {
                    showNtcnSwal(ntcn);

                    const badge = document.querySelector('#ntcnBadge');
                    const header = document.querySelector('#ntcnHeader');
                    const dropdownList = document.querySelector('#ntcnDropdownList');

                    // 배지 증가
                    const currentCount = parseInt(badge.textContent) || 0;
                    const newCount = currentCount + 1;
                    badge.textContent = newCount + '+';
                    badge.style.display = 'inline-block';

                    badge.classList.remove('bg-danger');
                    badge.classList.add('badge-blinking');

                    // 전체 알림 조회
                    fetch('/ntcn/unread')
                        .then(r => r.json())
                        .then(data => {
                            header.textContent = data.unreadList.length + '개의 새 알림';

                            let html = '';
                            const recentList = data.unreadList.slice(0, 3);

                            recentList.forEach(function(n) {
                                const date = new Date(n.registDt);

                                const iconMap = {
                                    'CVPL': { icon: 'bi-chat-left-text', color: 'bg-info' },
                                    'RESVE': { icon: 'bi-calendar-check', color: 'bg-success' },
                                    'ELCTRNSANCTN': { icon: 'bi-file-earmark-text', color: 'bg-primary' },
                                    'NOTICE': { icon: 'bi-megaphone', color: 'bg-warning' },
                                    'FCLTY': { icon: 'bi-building', color: 'bg-secondary' },
                                    'BBS': { icon: 'bi-clipboard', color: 'bg-info' },
                                    'VOTE': { icon: 'bi-hand-thumbs-up', color: 'bg-primary' },
                                    'MANAGECT': { icon: 'bi-cash-coin', color: 'bg-warning' },
                                    'SYSTEM': { icon: 'bi-gear', color: 'bg-danger' },
                                    'SIGN': { icon: 'bi-gear', color: 'bg-danger' }
                                };
                                const ntcnType = n.ntcnTy || 'SYSTEM';
                                const iconInfo = iconMap[ntcnType] || { icon: 'bi-bell', color: 'bg-secondary' };

                                html += `
                                    <a href="${n.ntcnUrl}" class="dropdown-item d-flex align-items-center" 
                                       onclick="markNotificationAsRead(${n.ntcnSn})">
                                        <div class="me-3">
                                            <div class="rounded-circle d-flex align-items-center justify-content-center ${iconInfo.color} text-white" 
                                                 style="width: 40px; height: 40px;">
                                                <i class="bi ${iconInfo.icon}"></i>
                                            </div>
                                        </div>
                                        <div style="flex: 1;">
                                            <div class="small text-muted">${getTimeAgo(date)}</div>
                                            <div class="notification-text">${n.ntcnCn}</div>
                                        </div>
                                    </a>
                                `;
                            });

                            dropdownList.innerHTML = html;
                        });
                }

                // 2. 초기 로딩 (ntcnCn 없을 때만) - REST API로 전체 알림 조회
                if (ntcn.unreadList && !ntcn.ntcnCn && id === user) {

                    //개인 + 단지 알림 통합 조회
                    fetch('/ntcn/unread')
                        .then(r => r.json())
                        .then(data => {
                            // UI 업데이트 (배지 + 드롭다운)
                            updateNotificationUI(data.unreadList);

                            // 첫 로그인 시 모달
                            if (!sessionStorage.getItem('initialNtcnShown') && data.unreadList.length > 0) {
                                // 모달은 UI 업데이트 후에!
                                setTimeout(() => {
                                    showUnreadModal(data.unreadList);
                                }, 500);
                                sessionStorage.setItem('initialNtcnShown', 'true');
                            }
                        })
                        .catch(error => {
                            console.error('알림 조회 실패:', error);
                        });
                }
            });

            console.log("구독: /topic/ntcn/" + id);
        });
    });
}

// 미확인 알림 UI 업데이트 함수
function updateNotificationUI(unreadList) {
    const badge = document.querySelector('#ntcnBadge');
    const header = document.querySelector('#ntcnHeader');
    const dropdownList = document.querySelector('#ntcnDropdownList');

    const count = unreadList.length;

    if (count > 0) {
        badge.textContent = count;
        badge.style.display = 'inline-block';
        header.textContent = count + '개의 새 알림';

        let html = '';
        const recentList = unreadList.slice(0, 3);

        recentList.forEach(function(n) {
            const date = new Date(n.registDt);

            // 알림 타입별 아이콘 & 색상 결정
            const iconMap = {
                'CVPL': { icon: 'bi-chat-left-text', color: 'bg-info' },
                'RESVE': { icon: 'bi-calendar-check', color: 'bg-success' },
                'ELCTRNSANCTN': { icon: 'bi-file-earmark-text', color: 'bg-primary' },
                'NOTICE': { icon: 'bi-megaphone', color: 'bg-warning' },
                'FCLTY': { icon: 'bi-building', color: 'bg-secondary' },
                'BBS': { icon: 'bi-clipboard', color: 'bg-info' },
                'VOTE': { icon: 'bi-hand-thumbs-up', color: 'bg-primary' },
                'MANAGECT': { icon: 'bi-cash-coin', color: 'bg-warning' },
                'SYSTEM': { icon: 'bi-gear', color: 'bg-danger' },
                'SIGN': { icon: 'bi-gear', color: 'bg-danger' }
            };

            const ntcnType = n.ntcnTy || 'SYSTEM';
            const iconInfo = iconMap[ntcnType] || { icon: 'bi-bell', color: 'bg-secondary' };

            html += `
                <a href="${n.ntcnUrl}" class="dropdown-item d-flex align-items-center" 
                onclick="markNotificationAsRead(${n.ntcnSn})">
                    <div class="me-3">
                        <div class="rounded-circle d-flex align-items-center justify-content-center ${iconInfo.color} text-white" 
                            style="width: 40px; height: 40px;">
                            <i class="bi ${iconInfo.icon}"></i>
                        </div>
                    </div>
                    <div style="flex: 1;">
                        <div class="small text-muted">${getTimeAgo(date)}</div>
                        <div class="notification-text">${n.ntcnCn}</div>
                    </div>
                </a>
            `;
        });

        dropdownList.innerHTML = html;
    } else {
        badge.textContent = '0';
        badge.style.display = 'none';
        header.textContent = '알림 없음';
        dropdownList.innerHTML = '<div class="dropdown-item text-center text-muted">새 알림이 없습니다</div>';
    }
}

// 첫 로딩 시 미확인 알림 모달
function showUnreadModal(unreadList) {
    const count = unreadList.length;
    const firstNtcn = unreadList[0];

    Swal.fire({
        icon: "info",
        title: "읽지 않은 알림",
        html: firstNtcn.ntcnCn + "<br><br>읽지 않은 " + count + "개의 알림이 있습니다.",
        showConfirmButton: true,
        confirmButtonText: "확인"
    });
}

// 새 알림 팝업
function showNtcnSwal(ntcn) {
    const icons = {
        CVPL: "info",
        RESVE: "success",
        ELCTRNSANCTN: "info",
        NOTICE: "info",
        FCLTY: "info",
        BBS: "info",
        VOTE: "info",
        MANAGECT: "warning",
        SYSTEM: "error",
		SIGN: "info"
		
    };

    const titles = {
        CVPL: "민원 알림",
        RESVE: "예약 알림",
        ELCTRNSANCTN: "결재 알림",
        NOTICE: "공지 알림",
        FCLTY: "시설 알림",
        BBS: "게시판 알림",
        VOTE: "투표 알림",
        MANAGECT: "관리비 알림",
        SYSTEM: "시스템 알림",
		SIGN: "회원가입 요청 알림"
    };

    const icon = icons[ntcn.ntcnTy] || "info";
    const title = titles[ntcn.ntcnTy] || "알림";
    const message = ntcn.ntcnCn || "새로운 알림이 도착했습니다.";

    Swal.fire({
            toast: true,                        // 토스트 모드
            position: "top-start",              // 오른쪽 상단
            icon: icon,
            title: title,
            html: message,
            showConfirmButton: false,           // 확인 버튼 제거
            timer: 10000,                       // 10초 유지
            timerProgressBar: true,             // 시간 바
            background: "#ffffff",
            customClass: {
                popup: 'swal2-toast-custom',
                timerProgressBar: 'swal2-progress-custom'
            },
            didOpen: (toast) => {
                
                // 알림 아이콘 찾기
                const bell = document.querySelector('#ntcnDropdown');
                if (bell) {
                    const rect = bell.getBoundingClientRect();

                    // 강제 위치 재배치
                    toast.style.position = "fixed";
                    toast.style.top = (rect.bottom + 10) + "px";   // 아이콘 아래 10px
                    toast.style.left = (rect.right - 260) + "px";  // 토스트 width 맞춰서 오른쪽 정렬
                }
                            
                // 클릭하면 읽음 처리 and URL 이동
                toast.addEventListener('click', () => {
                    // 읽음 처리
                    if (ntcn.ntcnSn) {
                        markNotificationAsRead(ntcn.ntcnSn);
                        
                        // UI 즉시 새로고침
                        fetch('/ntcn/unread')
                            .then(r => r.json())
                            .then(data => updateNotificationUI(data.unreadList));
                    }

                    // URL 이동
                    if (ntcn.ntcnUrl) {
                        window.location.href = ntcn.ntcnUrl;
                    }
                });
            }
        });
}

// 알림창의 시간 표시 함수
function getTimeAgo(date) {
    const now = new Date();
    const diff = Math.floor((now - date) / 1000);

    if (diff < 60) return '방금 전';
    if (diff < 3600) return Math.floor(diff / 60) + '분 전';
    if (diff < 86400) return Math.floor(diff / 3600) + '시간 전';
    return Math.floor(diff / 86400) + '일 전';
}

// 알림 읽음 처리
function markNotificationAsRead(ntcnSn) {
    fetch('/ntcn/read/' + ntcnSn, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                console.log('알림 읽음 처리 완료:', ntcnSn);

                // 배지 숫자 감소
                const badge = document.querySelector('#ntcnBadge');
                const currentCount = parseInt(badge.textContent) || 0;
                if (currentCount > 0) {
                    const newCount = currentCount - 1;
                    badge.textContent = newCount;
                    if (newCount === 0) {
                        badge.style.display = 'none';
                    }
                }
            }
        })
        .catch(error => {
            console.error('알림 읽음 처리 실패:', error);
        });
}

//모든 알림 보기
function showAllNotifications() {
    fetch('/ntcn/unread')
        .then(r => r.json())
        .then(data => {
            const dropdownList = document.querySelector('#ntcnDropdownList');
            dropdownList.innerHTML = '';

            // 알림 타입별 아이콘 & 색상 결정
            const iconMap = {
                'CVPL': { icon: 'bi-chat-left-text', color: 'bg-info' },
                'RESVE': { icon: 'bi-calendar-check', color: 'bg-success' },
                'ELCTRNSANCTN': { icon: 'bi-file-earmark-text', color: 'bg-primary' },
                'NOTICE': { icon: 'bi-megaphone', color: 'bg-warning' },
                'FCLTY': { icon: 'bi-building', color: 'bg-secondary' },
                'BBS': { icon: 'bi-clipboard', color: 'bg-info' },
                'VOTE': { icon: 'bi-hand-thumbs-up', color: 'bg-primary' },
                'MANAGECT': { icon: 'bi-cash-coin', color: 'bg-warning' },
                'SYSTEM': { icon: 'bi-gear', color: 'bg-danger' },
                'SIGN': { icon: 'bi-gear', color: 'bg-danger' }
            };

            data.unreadList.forEach(n => {
                const date = new Date(n.registDt);
                const ntcnType = n.ntcnTy || 'SYSTEM';
                const iconInfo = iconMap[ntcnType] || { icon: 'bi-bell', color: 'bg-secondary' };

                dropdownList.innerHTML += `
                    <a href="${n.ntcnUrl}" class="dropdown-item d-flex align-items-center" 
                       onclick="markNotificationAsRead(${n.ntcnSn})">
                        <div class="me-3">
                            <div class="rounded-circle d-flex align-items-center justify-content-center ${iconInfo.color} text-white" 
                                 style="width: 40px; height: 40px;">
                                <i class="bi ${iconInfo.icon}"></i>
                            </div>
                        </div>
                        <div style="flex: 1;">
                            <div class="small text-muted">${getTimeAgo(date)}</div>
                            <div class="notification-text">${n.ntcnCn}</div>
                        </div>
                    </a>
                `;
            });

            // 모든 알림 보기 버튼 숨기기
            const showAllBtn = document.querySelector('.dropdown-item.text-center.text-primary.fw-bold');
            if (showAllBtn) {
                showAllBtn.style.display = 'none';
            }
        });
}

// 페이지 로드 시 실행
document.addEventListener("DOMContentLoaded", function() {

    // 알림 드롭다운 클릭 시 깜빡임 멈춤
    document.querySelector('#ntcnDropdown').addEventListener('click', function() {
        resetNotificationDropdown();
        
        // 배지 깜빡임 멈춤
        const badge = document.querySelector('#ntcnBadge');
        badge.classList.remove('badge-blinking');
        badge.classList.add('bg-danger');
    });
});

// 모든 알림 보기 클릭 후 닫았을 때 모든 알림 보기 재활성화하기
function resetNotificationDropdown() {
    const header = document.querySelector('#ntcnHeader');
    const dropdownList = document.querySelector('#ntcnDropdownList');
    const showAllBtn = document.querySelector('.ntcn-dropdown-footer');

    // 버튼 복구
    if (showAllBtn) showAllBtn.style.display = 'block';
    
    fetch('/ntcn/unread')
        .then(r => r.json())
        .then(data => {
            // 기존의 3개 미리보기 UI 로직 재사용
            updateNotificationUI(data.unreadList);
        })
        .catch(err => console.error('알림 초기화 실패:', err));
            
    // 기본 헤더
    header.textContent = '알림 없음';

    // 기본 내용
    dropdownList.innerHTML = `
        <div class="dropdown-item text-center text-muted">
            새 알림이 없습니다
        </div>`;
}
