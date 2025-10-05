<%-- Document : register Created on : Oct 3, 2025, 2:24:42 AM Author : Vo Anh Ben - CE190709 --%>

    <!DOCTYPE html>
    <html lang="en">
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
        <%@ page contentType="text/html;charset=UTF-8" %>
            <%@ page import="jakarta.servlet.*" %>

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Sign Up</title>
                    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
                    <style>
                        /* CSS... (giữ nguyên để tiết kiệm không gian) */
                        body {
                            background-color: #121212;
                            color: #ffffff;
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            min-height: 100vh;
                            margin: 0;
                            font-family: Arial, sans-serif;
                        }

                        .signup-container {
                            width: 100%;
                            max-width: 450px;
                            padding: 20px;
                            text-align: center;
                        }

                        .signup-container h1 {
                            font-weight: 900;
                            font-size: 2.5rem;
                            margin-bottom: 3rem;
                        }

                        .form-control {
                            background-color: #1a1a1a;
                            border: 1px solid #535353;
                            color: #ffffff;
                            padding: 0.8rem 0.75rem;
                        }

                        .form-control:focus {
                            background-color: #1a1a1a;
                            color: #ffffff;
                            border-color: #ffffff;
                            box-shadow: 0 0 0 0.25rem rgba(255, 255, 255, 0.25);
                        }

                        .btn-success-custom {
                            background-color: #1ed760;
                            border-color: #1ed760;
                            color: #000000;
                            font-weight: bold;
                            font-size: 1rem;
                            padding: 0.8rem 0;
                            transition: background-color 0.15s ease-in-out;
                        }

                        .btn-success-custom:hover,
                        .btn-success-custom:focus {
                            background-color: #1fdf64;
                            border-color: #1fdf64;
                            color: #000000;
                            box-shadow: none;
                        }

                        .login-text {
                            margin-top: 3rem;
                            color: #a7a7a7;
                        }

                        .login-link {
                            color: #ffffff;
                            font-weight: bold;
                            text-decoration: none;
                        }

                        .login-link:hover {
                            color: #1ed760;
                        }

                        .spotify-logo {
                            margin-bottom: 2rem;
                            height: 40px;
                            width: 40px;
                        }

                        .form-check-label {
                            color: #ffffff;
                        }

                        /* Custom error message style */
                        .error-message {
                            color: #ff3333;
                            /* Bright red for errors */
                            font-size: 0.875rem;
                            margin-top: 0.25rem;
                            text-align: left;
                        }
                    </style>
                </head>

                <body>

                    <div class="signup-container">
                        <a href="<%= request.getContextPath()%>/">
                            <img src="<%= request.getContextPath() %>/assets/img/LogoFinal.png" alt="Logo của tôi"
                                class="spotify-logo" style="object-fit: contain;">

                        </a>

                        <h1>Sign up to start listening</h1>

                        <form id="registrationForm" action="<%= request.getContextPath() %>/register" method="post"
                            onsubmit="return validateForm()">

                            <div class="mb-3 text-start">
                                <label for="nameInput" class="form-label">What's your name?</label>
                                <input type="text" class="form-control" id="nameInput" placeholder="John Doe"
                                    name="name" required onkeyup="validateName()">
                                <div id="nameError" class="error-message" style="display: none;"></div>
                            </div>

                            <div class="mb-3 text-start">
                                <label class="form-label">What's your gender?</label>
                                <div class="d-flex justify-content-between">
                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="gender" id="genderMale"
                                            value="MALE" required>
                                        <label class="form-check-label" for="genderMale">Male</label>
                                    </div>

                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="gender" id="genderFemale"
                                            value="FEMALE">
                                        <label class="form-check-label" for="genderFemale">Female</label>
                                    </div>

                                    <div class="form-check form-check-inline">
                                        <input class="form-check-input" type="radio" name="gender" id="genderOther"
                                            value="OTHER">
                                        <label class="form-check-label" for="genderOther">Other</label>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3 text-start">
                                <label for="emailInput" class="form-label">What's your email?</label>
                                <input type="email" class="form-control" id="emailInput" placeholder="name@domain.com"
                                    name="email" required onkeyup="validateEmail()">
                                <div id="emailError" class="error-message" style="display: none;"></div>
                            </div>

                            <div class="mb-4 text-start">
                                <label for="passwordInput" class="form-label">Create a password</label>
                                <input type="password" class="form-control" id="passwordInput" placeholder="Password"
                                    name="password" required onkeyup="validatePasswordMatch()">
                                <div id="passwordError" class="error-message" style="display: none;"></div>
                            </div>

                            <div class="mb-4 text-start">
                                <label for="confirmPasswordInput" class="form-label">Confirm password</label>
                                <input type="password" class="form-control" id="confirmPasswordInput"
                                    placeholder="Confirm password" name="confirmPassword" required
                                    onkeyup="validatePasswordMatch()">
                            </div>

                            <div class="d-grid mb-4" style="display: flex; justify-content: center;">
                                <button type="submit" class="btn btn-success-custom"
                                    style="border-radius:30px; width: 200px;">
                                    Sign Up
                                </button>
                            </div>
                        </form>

                        <div class="or-separator my-4" style="color: #a7a7a7;">
                            <hr class="w-100" style="border-top: 1px solid #2a2a2a; opacity: 1;">
                        </div>

                        <div class="login-text">
                            Already have an account? <a href="<%= request.getContextPath() %>/login"
                                class="login-link">Log in</a>
                        </div>
                    </div>

                    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>

                    <script>
                        // Regex cơ bản để kiểm tra định dạng email
                        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

                        // Cờ kiểm tra tổng thể
                        let isNameValid = false;
                        let isEmailValid = false;
                        let isPasswordMatch = false;


                        // --- 1. Real-time validation cho Name ---
                        function validateName() {
                            const nameInput = document.getElementById('nameInput');
                            const nameError = document.getElementById('nameError');
                            const nameValue = nameInput.value.trim();

                            if (nameValue.length < 2) {
                                nameError.textContent = 'Name must be at least 2 characters long.';
                                nameError.style.display = 'block';
                                isNameValid = false;
                            } else {
                                nameError.style.display = 'none';
                                isNameValid = true;
                            }
                        }

                        // --- 2. Real-time validation cho Email ---
                        function validateEmail() {
                            const emailInput = document.getElementById('emailInput');
                            const emailError = document.getElementById('emailError');
                            const emailValue = emailInput.value.trim();

                            if (emailValue === '') {
                                // Để HTML5 required xử lý việc bỏ trống
                                emailError.style.display = 'none';
                                isEmailValid = false;
                            } else if (!emailRegex.test(emailValue)) {
                                emailError.textContent = 'Please enter a valid email address (e.g., user@example.com).';
                                emailError.style.display = 'block';
                                isEmailValid = false;
                            } else {
                                emailError.style.display = 'none';
                                isEmailValid = true;
                            }
                        }

                        // --- 3. Real-time validation cho Password Match ---
                        function validatePasswordMatch() {
                            const password = document.getElementById('passwordInput').value;
                            const confirmPassword = document.getElementById('confirmPasswordInput').value;
                            const errorElement = document.getElementById('passwordError');

                            if (password !== '' && confirmPassword !== '' && password !== confirmPassword) {
                                errorElement.textContent = 'Error: Passwords do not match.';
                                errorElement.style.display = 'block';
                                isPasswordMatch = false;
                            } else if (password === '' && confirmPassword === '') {
                                errorElement.style.display = 'none'; // Để HTML5 required xử lý
                                isPasswordMatch = false; // Vẫn tính là chưa hợp lệ nếu trống
                            } else {
                                errorElement.style.display = 'none';
                                isPasswordMatch = true;
                            }
                        }


                        // --- 4. Tổng hợp validation khi Submit ---
                        function validateForm() {
                            // Chạy lại tất cả các hàm kiểm tra trước khi submit lần cuối
                            validateName();
                            validateEmail();
                            validatePasswordMatch();

                            // Kiểm tra các trường required khác mà JS không kiểm tra real-time (ví dụ: Gender)
                            const genderChecked = document.querySelector('input[name="gender"]:checked');

                            // Nếu một trong các cờ là false, hoặc Gender chưa được chọn, ngăn form submit.
                            // Chú ý: Các kiểm tra HTML5 required vẫn hoạt động.
                            if (!isNameValid || !isEmailValid || !isPasswordMatch || !genderChecked) {
                                return false;
                            }

                            return true;
                        }

                        // Tự động chạy validation khi trang tải để thiết lập trạng thái ban đầu
                        document.addEventListener('DOMContentLoaded', () => {
                            // Thực hiện kiểm tra khi người dùng bắt đầu nhập (onkeyup)
                            document.getElementById('nameInput').addEventListener('keyup', validateName);
                            document.getElementById('emailInput').addEventListener('keyup', validateEmail);
                            document.getElementById('passwordInput').addEventListener('keyup', validatePasswordMatch);
                            document.getElementById('confirmPasswordInput').addEventListener('keyup', validatePasswordMatch);
                        });

                    </script>
                </body>

    </html>