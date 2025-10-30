<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bottom-nav.css">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page contentType="text/html;charset=UTF-8" %>

        <head>
            <meta charset="utf-8" />
        </head>
        <style>
            /* bottom-nav.css */
            /* Định nghĩa màu xanh (hoặc màu nổi bật) cho trạng thái đang hoạt động */
            .bottom-nav-link.active .bottom-nav-icon,
            .bottom-nav-link.active .bottom-nav-text {
                color: #1db954;
                /* Ví dụ: Màu xanh dương */
                /* Hoặc bạn có thể dùng một màu khác tùy ý */
            }

            /* Đảm bảo icon và text có màu mặc định khi không active */
            .bottom-nav-link .bottom-nav-icon,
            .bottom-nav-link .bottom-nav-text {
                color: #909090;
                /* Ví dụ: Màu xám */
            }
        </style>
        <div class="bottom-nav-container d-lg-none">
            <div class="bottom-nav-bar">
                <ul class="bottom-nav-list">
                    <!-- Home - Active State -->
                    <li class="bottom-nav-item">
                        <a href="<%= request.getContextPath() %>/" class="bottom-nav-link">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="bottom-nav-icon"
                                viewBox="0 0 16 16">
                                <path
                                    d="M6.5 14.5v-3.505c0-.245.25-.495.5-.495h2c.25 0 .5.25.5.5v3.5a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5" />
                            </svg>
                            <span class="bottom-nav-text">Home</span>
                        </a>
                    </li>

                    <!-- Explore -->
                    <li class="bottom-nav-item">
                        <a href="${pageContext.request.contextPath}/search?genre=happy" class="bottom-nav-link">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="bottom-nav-icon"
                                viewBox="0 0 16 16">
                                <path
                                    d="M8 0a8 8 0 1 1 0 16A8 8 0 0 1 8 0M7 6.5C7 5.672 6.552 5 6 5s-1 .672-1 1.5S5.448 8 6 8s1-.672 1-1.5M4.285 9.567a.5.5 0 0 0-.183.683A4.5 4.5 0 0 0 8 12.5a4.5 4.5 0 0 0 3.898-2.25.5.5 0 1 0-.866-.5A3.5 3.5 0 0 1 8 11.5a3.5 3.5 0 0 1-3.032-1.75.5.5 0 0 0-.683-.183m5.152-3.31a.5.5 0 0 0-.874.486c.33.595.958 1.007 1.687 1.007s1.356-.412 1.687-1.007a.5.5 0 0 0-.874-.486.93.93 0 0 1-.813.493.93.93 0 0 1-.813-.493" />
                            </svg>
                            <span class="bottom-nav-text">Happy</span>
                        </a>
                    </li>

                    <!-- Radio -->
                    <li class="bottom-nav-item">
                        <a href="${pageContext.request.contextPath}/search?genre=remix" class="bottom-nav-link">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="bottom-nav-icon"
                                viewBox="0 0 16 16">
                                <path fill-rule="evenodd"
                                    d="M8.5 2a.5.5 0 0 1 .5.5v11a.5.5 0 0 1-1 0v-11a.5.5 0 0 1 .5-.5m-2 2a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5m4 0a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5m-6 1.5A.5.5 0 0 1 5 6v4a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m8 0a.5.5 0 0 1 .5.5v4a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5m-10 1A.5.5 0 0 1 3 7v2a.5.5 0 0 1-1 0V7a.5.5 0 0 1 .5-.5m12 0a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0V7a.5.5 0 0 1 .5-.5" />

                            </svg>
                            <span class="bottom-nav-text">Remix</span>
                        </a>
                    </li>

                    <!-- Library -->
                    <li class="bottom-nav-item">
                        <a href="${pageContext.request.contextPath}/search?q=piano" class="bottom-nav-link">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                                class="bi bi-music-player" viewBox="0 0 16 16">
                                <path
                                    d="M4 3a1 1 0 0 1 1-1h6a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1zm1 0v3h6V3zm3 9a1 1 0 1 0 0-2 1 1 0 0 0 0 2" />
                                <path d="M11 11a3 3 0 1 1-6 0 3 3 0 0 1 6 0m-3 2a2 2 0 1 0 0-4 2 2 0 0 0 0 4" />
                                <path
                                    d="M2 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2zm2-1a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1z" />
                            </svg>
                            <span class="bottom-nav-text">Piano</span>
                        </a>
                    </li>

                    <!-- Search - Special styling -->
                    <li class="bottom-nav-item bottom-nav-search">
                        <a href="#" class="bottom-nav-link mobile-menu-button d-lg-none me-2" data-bs-toggle="modal"
                            data-bs-target="#searchModal">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="bottom-nav-icon"
                                viewBox="0 0 16 16">
                                <path
                                    d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0" />
                            </svg>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <div class="modal fade auth-modal" id="searchModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Search your song...</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                                class="bi bi-x-lg" viewBox="0 0 16 16">
                                <path
                                    d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z" />
                            </svg>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div style="position: relative;">
                            <form action="${pageContext.request.contextPath}/search" method="GET" id="searchForm">
                                <input type="text" id="globalSearchInput" name="q" class="form-control"
                                    style="background-color: #121212; color:#fff; padding-right: 40px;"
                                    placeholder="What do you want to play?" autocomplete="off">
                            </form>
                            <button type="submit" form="searchForm" class="btn btn-link p-0 border-0" style="color: #fff; 
                                       position: absolute;
                                       top: 50%; 
                                       right: 10px; 
                                       transform: translateY(-50%); 
                                       z-index: 10;">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="search-icon"
                                    style="width: 20px; height: 20px;" viewBox="0 0 16 16">
                                    <path
                                        d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0" />
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Lấy đường dẫn URL hiện tại (chỉ lấy phần path, không lấy domain)
                // Ví dụ: /myapp/search?genre=happy
                const currentPath = window.location.pathname + window.location.search;

                // Lấy tất cả các liên kết trong thanh điều hướng
                const navLinks = document.querySelectorAll('.bottom-nav-list .bottom-nav-link');

                navLinks.forEach(link => {
                    // Lấy URL đích của liên kết, bỏ qua phần getContextPath/
                    // Ví dụ: /search?genre=happy
                    const linkHref = link.getAttribute('href').replace('<%= request.getContextPath() %>', '');

                    // ⭐ Xử lý đặc biệt cho Trang chủ (root path)
                    if (linkHref === '/') {
                        // Trang chủ chỉ active khi đường dẫn chính xác là / hoặc /index.jsp
                        if (currentPath === '<%= request.getContextPath() %>/' || currentPath === '/') {
                            link.classList.add('active');
                        } else {
                            link.classList.remove('active');
                        }
                    }
                    // ⭐ Xử lý cho các liên kết còn lại (Happy, Remix, Piano)
                    else if (currentPath.startsWith(linkHref)) {
                        // Áp dụng class 'active' nếu URL hiện tại BẮT ĐẦU bằng URL đích của liên kết
                        link.classList.add('active');
                    } else {
                        link.classList.remove('active');
                    }

                    // ⭐ (Tùy chọn) Thêm hiệu ứng nhấn vào: Remove 'active' cho tất cả
                    // và thêm lại 'active' cho liên kết vừa click (thao tác này chỉ mang tính thị giác nhanh)
                    link.addEventListener('click', function () {
                        navLinks.forEach(item => item.classList.remove('active'));
                        this.classList.add('active');
                        // Lưu ý: Sau khi chuyển trang, logic DOMContentLoaded sẽ chạy lại để xác định trang active chính xác.
                    });
                });
            });
        </script>