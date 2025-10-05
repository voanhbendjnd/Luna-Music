<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bottom-nav.css">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page contentType="text/html;charset=UTF-8" %>

        <head>
            <meta charset="utf-8" />
        </head>

        <div class="bottom-nav-container d-lg-none">
            <div class="bottom-nav-bar">
                <ul class="bottom-nav-list">
                    <!-- Home - Active State -->
                    <li class="bottom-nav-item">
                        <a href="<%= request.getContextPath() %>/" class="bottom-nav-link active">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="bottom-nav-icon"
                                viewBox="0 0 16 16">
                                <path
                                    d="M6.5 14.5v-3.505c0-.245.25-.495.5-.495h2c.25 0 .5.25.5.5v3.5a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5" />
                            </svg>
                            <span class="bottom-nav-text">Trang chủ</span>
                        </a>
                    </li>

                    <!-- Explore -->
                    <li class="bottom-nav-item">
                        <a href="#" class="bottom-nav-link">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="bottom-nav-icon"
                                viewBox="0 0 16 16">
                                <path
                                    d="M1 2a1 1 0 0 1 1-1h3a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1zM9 1h3a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1H9a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1m4 8V6a1 1 0 0 0-1-1H9a1 1 0 0 0-1 1v3a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1M7 10V6a1 1 0 0 0-1-1H2a1 1 0 0 0-1 1v4a1 1 0 0 0 1 1h4a1 1 0 0 0 1-1" />
                            </svg>
                            <span class="bottom-nav-text">Khám phá</span>
                        </a>
                    </li>

                    <!-- Radio -->
                    <li class="bottom-nav-item">
                        <a href="#" class="bottom-nav-link">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="bottom-nav-icon"
                                viewBox="0 0 16 16">
                                <path
                                    d="M3.05 3.05a7 7 0 0 0 0 9.9.5.5 0 0 1-.707.707 8 8 0 0 1 0-11.314.5.5 0 0 1 .707.707zm2.122 2.122a4 4 0 0 0 0 5.656.5.5 0 1 1-.708.708 5 5 0 0 1 0-7.072.5.5 0 0 1 .708.708zm5.656-.708a.5.5 0 0 1 .708 0 5 5 0 0 1 0 7.072.5.5 0 0 1-.708-.708 4 4 0 0 0 0-5.656zm3.182 1.414a.5.5 0 0 1 .708 0 8 8 0 0 1 0 11.314.5.5 0 0 1-.708-.707 7 7 0 0 0 0-9.9z" />
                                <path d="M10 8a2 2 0 1 1-4 0 2 2 0 0 1 4 0" />
                            </svg>
                            <span class="bottom-nav-text">Radio</span>
                        </a>
                    </li>

                    <!-- Library -->
                    <li class="bottom-nav-item">
                        <a href="#" class="bottom-nav-link">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="bottom-nav-icon"
                                viewBox="0 0 16 16">
                                <path
                                    d="M6 13c0 1.105-1.12 2-2.5 2S1 14.105 1 13c0-1.104 1.12-2 2.5-2s2.5.896 2.5 2m9-2c0 1.105-1.12 2-2.5 2s-2.5-.895-2.5-2 1.12-2 2.5-2 2.5.895 2.5 2" />
                                <path fill-rule="evenodd" d="M14 11V2h1v9zM6 3v10H5V3z" />
                                <path d="M5 2.905a1 1 0 0 1 .9-.995l8-.8a1 1 0 0 1 1.1.995V3L5 4V2.905z" />
                            </svg>
                            <span class="bottom-nav-text">Thư viện</span>
                        </a>
                    </li>

                    <!-- Search - Special styling -->
                    <li class="bottom-nav-item bottom-nav-search">
                        <a href="#" class="bottom-nav-link">
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