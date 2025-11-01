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
                        <title>My Account</title>
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

                            <h1>My Account</h1>
                            <form id="registrationForm"
                                action="<%= request.getContextPath() %>/account?action=update-user" method="post"
                                onsubmit="return validateForm()">
                                <div class="mb-3 text-start">
                                    <label for="emailInput" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="emailInput" value="${user.email}"
                                        name="email" readonly>
                                </div>

                                <div class="mb-3 text-start">
                                    <label for="nameInput" class="form-label">Name</label>
                                    <input type="text" class="form-control" id="nameInput" value="${user.name}"
                                        name="name" required onkeyup="validateName()">
                                    <div id="nameError" class="error-message" style="display: none;"></div>
                                </div>

                                <div class="mb-3 text-start">
                                    <label class="form-label">Gender</label>
                                    <div class="d-flex justify-content-between">
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="gender" id="genderMale"
                                                value="MALE" required <c:if test="${user.gender =='MALE'}">
                                            checked
                                            </c:if>
                                            >
                                            <label class="form-check-label" for="genderMale">Male</label>
                                        </div>

                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="gender" id="genderFemale"
                                                value="FEMALE" <c:if test="${user.gender == 'FEMALE'}">
                                            checked
                                            </c:if>
                                            >
                                            <label class="form-check-label" for="genderFemale">Female</label>
                                        </div>

                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="radio" name="gender" id="genderOther"
                                                value="OTHER" <c:if test="${user.gender == 'OTHER'}">
                                            checked
                                            </c:if>
                                            >
                                            <label class="form-check-label" for="genderOther">Other</label>
                                        </div>
                                    </div>
                                </div>


                                <div class="mb-4 text-start">
                                    <label class="form-label">Your city</label>
                                    <select class="form-control" name="city" required>
                                        <option value="CAN%20THO" <c:if test=" ${user.city == 'CAN%20THO'}">
                                            selected
                                            </c:if>
                                            >CẦN THƠ</option>
                                        <option value="HO%20CHI%20MINH" <c:if test="${user.city == 'HO%20CHI%20MINH'}">
                                            selected
                                            </c:if>
                                            >HỒ CHÍNH MINH</option>
                                        <option value="HA%20NOI" <c:if test="${user.city == 'HA%20NOI'}">
                                            selected
                                            </c:if>
                                            >HÀ NỘI</option>
                                    </select>
                                </div>
                                <div style="display: flex; justify-content: start;"><a class="login-link"
                                        href="<%= request.getContextPath() %>/account?action=update-password">Update
                                        password?</a></div>

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
                            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                            let isNameValid = false;
                            let isPasswordMatch = false;
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
                            function validateForm() {
                                validateName();
                                const genderChecked = document.querySelector('input[name="gender"]:checked');
                                if (!isNameValid || !genderChecked) {
                                    return false;
                                }

                                return true;
                            }
                            document.addEventListener('DOMContentLoaded', () => {
                                document.getElementById('nameInput').addEventListener('keyup', validateName);
                            });

                        </script>
                    </body>

    </html>