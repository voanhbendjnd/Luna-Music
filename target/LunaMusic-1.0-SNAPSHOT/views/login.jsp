<!DOCTYPE html>
<html lang="vi">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page contentType="text/html;charset=UTF-8" %>
        <%@ page import="jakarta.servlet.*" %>

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Đăng ký</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
                    integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
                    crossorigin="anonymous">
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
                    <!-- <svg class="spotify-logo" role="img" height="40" width="40" aria-hidden="true" viewBox="0 0 24 24"
                        data-testid="spotify-logo">
                        <path fill="#1ed760"
                            d="M12 24c6.627 0 12-5.373 12-12S18.627 0 12 0 0 5.373 0 12s5.373 12 12 12zM7.5 7.5a.75.75 0 0 0 0 1.5h1.498a5.161 5.161 0 0 1 5.006 4.904c0 1.637-.621 3.16-1.748 4.363a.75.75 0 0 0 1.054 1.074 6.709 6.709 0 0 0 2.106-5.437 6.661 6.661 0 0 0-6.75-6.65h-1.499z">
                        </path>
                    </svg> -->
                    <img src="${pageContext.request.contextPath}/assets/img/LogoFinal.png" alt="Logo của tôi"
                        class="spotify-logo" style="object-fit: contain;
                        ">

                    <h1>Welcome back</h1>

                    <form>
                        <div class="mb-3 text-start">
                            <label for="emailInput" class="form-label">Email address</label>
                            <input type="email" class="form-control" id="emailInput" placeholder="name@domain.com"
                                required>
                        </div>

                        <div class="mb-4 text-start">
                            <label for="passwordInput" class="form-label">Password</label>
                            <input type="password" class="form-control" id="passwordInput" placeholder="Password"
                                required>
                        </div>

                        <div class="d-grid mb-4" style="display: flex;
                        justify-content: center;">
                            <button type="submit" class="btn btn-success-custom" style="border-radius:30px ; width: 200px;
                                ">
                                Login
                            </button>
                        </div>
                    </form>

                    <div class="or-separator my-4" style="color: #a7a7a7;">
                        <hr class="w-100" style="border-top: 1px solid #2a2a2a; opacity: 1;">
                    </div>

                    <div class="login-text">
                        Don't have an account? <a href="#" class="login-link">Sign up</a>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
                    integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
                    crossorigin="anonymous"></script>
            </body>

</html>