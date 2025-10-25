<!DOCTYPE html>
<html lang="vi">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ page contentType="text/html;charset=UTF-8" %>
            <%@ page import="jakarta.servlet.*" %>

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>About page</title>
                    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
                    <style>
                        /* Thiết lập nền đen cho toàn bộ trang và chữ trắng */
                        body {
                            background-color: #121212;
                            /* Nền đen của Spotify */
                            color: #ffffff;
                            /* Chữ trắng */
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            min-height: 100vh;
                            /* Chiều cao tối thiểu là 100% viewport height */
                            margin: 0;
                            font-family: Arial, sans-serif;
                        }

                        /* Container chứa form */
                        .signup-container {
                            width: 100%;
                            max-width: 450px;
                            /* Chiều rộng tối đa tương tự giao diện Spotify */
                            padding: 20px;
                            text-align: center;
                        }

                        /* Tiêu đề */
                        .signup-container h1 {
                            font-weight: 900;
                            font-size: 2.5rem;
                            /* Kích thước chữ lớn */
                            margin-bottom: 3rem;
                        }

                        /* Nền Input */
                        .form-control {
                            background-color: #1a1a1a;
                            /* Nền input tối hơn */
                            border: 1px solid #535353;
                            color: #ffffff;
                            /* Chữ trong input màu trắng */
                            padding: 0.8rem 0.75rem;
                            /* Tăng padding cho ô input */
                        }

                        /* Hiệu ứng focus cho input */
                        .form-control:focus {
                            background-color: #1a1a1a;
                            color: #ffffff;
                            border-color: #ffffff;
                            /* Viền trắng khi focus */
                            box-shadow: 0 0 0 0.25rem rgba(255, 255, 255, 0.25);
                            /* Box shadow nhẹ */
                        }

                        /* Button Next (Đăng ký) */
                        .btn-success-custom {
                            background-color: #1ed760;
                            /* Màu xanh lá của Spotify */
                            border-color: #1ed760;
                            color: #000000;
                            /* Chữ đen */
                            font-weight: bold;
                            font-size: 1rem;
                            padding: 0.8rem 0;
                            transition: background-color 0.15s ease-in-out;
                        }

                        .btn-success-custom:hover,
                        .btn-success-custom:focus {
                            background-color: #1fdf64;
                            /* Sáng hơn khi hover/focus */
                            border-color: #1fdf64;
                            color: #000000;
                            box-shadow: none;
                        }

                        /* Text "Đã có tài khoản?" */
                        .login-text {
                            margin-top: 3rem;
                            color: #a7a7a7;
                            /* Màu xám nhạt */
                        }

                        /* Link Đăng nhập */
                        .login-link {
                            color: #ffffff;
                            /* Màu trắng */
                            font-weight: bold;
                            text-decoration: none;
                            /* Bỏ gạch chân */
                        }

                        .login-link:hover {
                            color: #1ed760;
                            /* Màu xanh lá khi hover */
                        }

                        /* Biểu tượng (Icon) Spotify, nếu cần thêm */
                        .spotify-logo {
                            margin-bottom: 2rem;
                            height: 40px;
                            /* Kích thước icon */
                            width: 40px;
                        }
                    </style>
                </head>

                <body>

                    <div class="signup-container">
                        <a href="<%= request.getContextPath()%>/">
                            <img src="<%= request.getContextPath() %>/assets/img/LogoFinal.png" alt="Logo của tôi"
                                class="spotify-logo" style="object-fit: contain;">

                        </a>

                        <h1>About us</h1>
                        <h3>Web: Luna Music</h3>
                        <div>
                            <span>Thành viên nhóm: </span>
                            <p>Võ Anh Ben - CE190709</p>
                            <p>Trương Hoàng Khang - CE190729</p>
                            <p>Trần Lương Thiện Hoàng - CE190272</p>
                            <p>Dương Thiện Nhân - CE190741</p>
                            <p>Trần Hiển Vinh - CE190881</p>
                        </div>


                        <div class="or-separator my-4" style="color: #a7a7a7;">
                            <hr class="w-100" style="border-top: 1px solid #2a2a2a; opacity: 1;">
                        </div>
                        <p>
                            Mô tả:
                            Dự án nhóm môn PRJ301, là một web nghe nhạc tương tự như spotify phục vụ cho những người yêu
                            âm nhạc.
                        </p>
                        <p>
                            Theo dõi quá trình xây dựng dự án tại <a
                                href="https://github.com/voanhbendjnd/Luna-Music.git" class="login-link">
                                Github
                            </a>
                        </p>

                        <div class="login-text">
                            Trở về trang chủ? <a href="<%= request.getContextPath() %>/" class="login-link">Home
                            </a>
                        </div>
                    </div>

                    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>

                </body>



</html>