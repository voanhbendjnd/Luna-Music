<head>
    <style>
        /* Đảm bảo màu chữ hiển thị sáng rõ */
        .form-control {
            color: #fff !important;
        }

        /* Làm Sáng Chữ Placeholder: Đặt một màu xám nhạt */
        .form-control::placeholder {
            color: #b3b3b3 !important;
            /* Màu xám nhạt, nổi bật trên nền tối */
            opacity: 0.9;
        }

        /* ------------------------------------------- */
        /* 1. Loại bỏ Viền Xanh (Focus Outline) */
        /* ------------------------------------------- */

        /* 1a. Cho Input */
        .form-control:focus {
            box-shadow: none !important;
            border-color: #2a2a2a !important;
            background-color: #2a2a2a !important;
        }

        /* 1b. Cho các Nav-link và nút */
        .navbar a:focus,
        .navbar button:focus {
            outline: none !important;
            box-shadow: none !important;
        }
    </style>
</head>

<header class="navbar navbar-expand-lg py-3 sticky-top" style="background-color: #121212;color: #fff;">
    <div class="container-fluid px-4 px-lg-5">

        <a class="navbar-brand me-4" href="<%= request.getContextPath()%>/" style="color: #fff;
         height: 30px;
         display: flex;
         justify-content: center;
         ">
            <img src="<%= request.getContextPath() %>/assets/img/LogoFinal.png" alt="Luna Music Logo"
                style="height: 30px; object-fit: contain;">
        </a>

        <div class="mx-lg-auto d-none d-lg-block" style="max-width: 450px; width: 100%;">

            <div class="input-group">
                <a href="<%= request.getContextPath()%>/" style="color: #fff;">
                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor"
                        class="bi bi-house-door" viewBox="0 0 16 16" style="margin-top: 10px; margin-right: 20px;">
                        <path
                            d="M6.5 14.5v-3.505c0-.245.25-.495.5-.495h2c.25 0 .5.25.5.5v3.5a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5" />

                    </svg>
                </a>

                <span class="input-group-text rounded-start-pill"
                    style="background-color: #2a2a2a; border-color: #2a2a2a;">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                        style="color: #fff;" class="bi bi-search" viewBox="0 0 16 16">
                        <path
                            d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0" />
                    </svg>
                </span>
                <input type="text" class="form-control rounded-end-pill custom-focus-none"
                    placeholder="What do you want to play?"
                    style="background-color: #2a2a2a; border-color: #2a2a2a; color: #fff;">
            </div>
        </div>

        <div class="d-flex align-items-center">

            <!-- Nút mở modal Auth (chỉ hiển thị trên mobile) -->
            <button class="btn btn-outline-light d-lg-none me-2"
                style="border-radius: 50%; width:36px; height:36px; padding:0;" data-bs-toggle="modal"
                data-bs-target="#authModal">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person"
                    viewBox="0 0 16 16">
                    <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6" />
                    <path d="M14 14s-1-1.5-6-1.5S2 14 2 14s1-4 6-4 6 4 6 4" />
                </svg>
            </button>

            <ul class="navbar-nav flex-row align-items-center">
                <li class="nav-item d-none d-xl-block">
                    <a class="nav-link text-white-50 small mx-2 custom-focus-none" href="#">Premium</a>
                </li>
                <li class="nav-item d-none d-xl-block">
                    <a class="nav-link text-white-50 small mx-2 custom-focus-none" href="#">Support</a>
                </li>
                <li class="nav-item d-none d-xl-block">
                    <a class="nav-link text-white-50 small mx-2 custom-focus-none" href="#">Download</a>
                </li>

                <li class="nav-item d-none d-xl-block mx-2">
                    <span style="color: #4a4a4a;">|</span>
                </li>

                <!-- Ẩn login/signup trên mobile -->
                <li class="nav-item me-3 me-lg-4 d-none d-lg-block">
                    <a class="nav-link text-white-50 fw-bold custom-focus-none"
                        href="<%= request.getContextPath()%>/register">Sign up</a>
                </li>
                <li class="nav-item d-none d-lg-block">
                    <a class="btn btn-light rounded-pill px-4 fw-bold custom-focus-none"
                        href="<%= request.getContextPath() %>/login">
                        Login
                    </a>
                </li>
            </ul>
        </div>
    </div>
</header>

<!-- Modal đăng nhập/đăng ký cho mobile -->
<div class="modal fade" id="authModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="background-color:#1f1f1f; color:#fff; border:1px solid #2a2a2a;">
            <div class="modal-header">
                <h5 class="modal-title" style="color: #fff;">Account</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                    aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="d-grid gap-2">
                    <a href="<%= request.getContextPath()%>/register" class="btn btn-outline-light"
                        style="background-color: #1f1c1c; color: #fff;">Sign up</a>
                    <a href="<%= request.getContextPath() %>/login" class="btn btn-light text-dark fw-bold">
                        Login
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>