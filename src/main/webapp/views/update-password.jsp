<%-- Document : register Created on : Oct 3, 2025, 2:24:42 AM Author : Vo Anh Ben - CE190709 --%>

    <!DOCTYPE html>
    <html lang="en">
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <%@ page contentType="text/html;charset=UTF-8" language="java" %>
            <%@ page contentType="text/html;charset=UTF-8" %>
                <%@ page import="jakarta.servlet.*" %>

                    <head>
                        <meta charset="UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Change password</title>
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
                            .form-select {
                                border: none;
                                border: 1px solid #535353;
                                background-color: #1a1a1a;
                            }
                            .form-select:focus {
                                color: #000000;
                                box-shadow: none;
                            }

                            .form-select:hover {
                                color: #1ed760;

                            }
                        </style>
                    </head>

                    <body>

                        <div class="signup-container">
                            <a href="<%= request.getContextPath()%>/">
                                <img src="<%= request.getContextPath() %>/assets/img/LogoFinal.png" alt="Logo của tôi"
                                    class="spotify-logo" style="object-fit: contain;">

                            </a>

                            <h1>Update password</h1>
                            <form id="registrationForm"
                                action="<%= request.getContextPath() %>/account?action=update-password" method="post"
                                onsubmit="return validateForm()">


                                <div class="mb-4 text-start">
                                    <label for="passwordInput" class="form-label">Old password</label>
                                    <input type="password" class="form-control" placeholder="Password"
                                        name="oldPassword" required>
                                </div>

                                <div class="mb-4 text-start">
                                    <label for="passwordInput" class="form-label">Create new password</label>
                                    <input type="password" class="form-control" id="passwordInput"
                                        placeholder="Password" name="password" required
                                        onkeyup="validatePasswordMatch()">
                                    <div id="passwordError" class="error-message" style="display: none;"></div>
                                </div>

                                <div class="mb-4 text-start">
                                    <label for="confirmPasswordInput" class="form-label">Confirm password</label>
                                    <input type="password" class="form-control" id="confirmPasswordInput"
                                        placeholder="Confirm password" name="confirmPassword" required
                                        onkeyup="validatePasswordMatch()">
                                </div>

                                <p style="color: #05f74e; display: flex;">
                                    ${successMsg != null ? successMsg : null}
                                </p>
                                <p style="color: #ff3333; display: flex;">
                                    ${errorMsg != null ? errorMsg : null}
                                </p>
                                <div class="d-grid mb-4" style="display: flex; justify-content: center;">
                                    <button type="submit" class="btn btn-success-custom"
                                        style="border-radius:30px; width: 200px;">
                                        Update
                                    </button>
                                </div>
                            </form>

                            <div class="or-separator my-4" style="color: #a7a7a7;">
                                <hr class="w-100" style="border-top: 1px solid #2a2a2a; opacity: 1;">
                            </div>

                            <div class="login-text">
                                Back to <a href="<%= request.getContextPath() %>/home" class="login-link">home page</a>
                            </div>
                        </div>

                        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>

                        <script>
                            let isPasswordMatch = false;
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

                            function validateForm() {
                                validatePasswordMatch();
                                if (!isPasswordMatch) {
                                    return false;
                                }

                                return true;
                            }

                            document.addEventListener('DOMContentLoaded', () => {
                                // Thực hiện kiểm tra khi người dùng bắt đầu nhập (onkeyup)
                                document.getElementById('passwordInput').addEventListener('keyup', validatePasswordMatch);
                                document.getElementById('confirmPasswordInput').addEventListener('keyup', validatePasswordMatch);
                            });

                        </script>
                    </body>

    </html>