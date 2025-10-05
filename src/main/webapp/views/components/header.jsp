<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">

<header class="navbar navbar-expand-lg header-navbar sticky-top">
    <div class="container-fluid px-4 px-lg-5">
        <!-- Left Section: Logo -->
        <a class="navbar-brand header-logo me-4" href="<%= request.getContextPath()%>/">
            <img src="<%= request.getContextPath() %>/assets/img/LogoFinal.png" alt="Luna Music Logo">
        </a>

        <!-- Middle Section: Home Button + Search Bar -->
        <div class="search-container d-none d-lg-flex align-items-center mx-4">
            <!-- Home Button -->
            <a href="<%= request.getContextPath()%>/" class="home-button">
                <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16">
                    <path
                        d="M6.5 14.5v-3.505c0-.245.25-.495.5-.495h2c.25 0 .5.25.5.5v3.5a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5" />
                </svg>
            </a>

            <!-- Search Bar -->
            <div class="search-input-group">
                <span class="input-group-text">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="search-icon" viewBox="0 0 16 16">
                        <path
                            d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0" />
                    </svg>
                </span>
                <input type="text" class="form-control" placeholder="What do you want to play?">
                <div class="playlist-icon">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16">
                        <path
                            d="M2 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2zm10-1H4a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1z" />
                        <path
                            d="M6 5.5a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 0 1h-3a.5.5 0 0 1-.5-.5zm0 2a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 0 1h-3a.5.5 0 0 1-.5-.5zm0 2a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 0 1h-3a.5.5 0 0 1-.5-.5z" />
                    </svg>
                </div>
            </div>
        </div>

        <!-- Right Section: Navigation Links and Buttons -->
        <div class="d-flex align-items-center">
            <!-- Mobile Menu Button -->
            <button class="mobile-menu-button d-lg-none me-2" data-bs-toggle="modal" data-bs-target="#authModal">
                <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16">
                    <path d="M8 8a3 3 0 1 0 0-6 3 3 0 0 0 0 6" />
                    <path d="M14 14s-1-1.5-6-1.5S2 14 2 14s1-4 6-4 6 4 6 4" />
                </svg>
            </button>

            <!-- Desktop Navigation Links -->
            <div class="header-nav-links d-none d-lg-flex align-items-center">
                <a href="#" class="header-nav-link">Premium</a>
                <span class="header-nav-separator">|</span>
                <a href="#" class="header-nav-link">Support</a>
                <span class="header-nav-separator">|</span>
                <a href="#" class="header-nav-link">Download</a>
                <a href="#" class="install-app-link">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16">
                        <path
                            d="M8.5 6a.5.5 0 0 0-1 0v1.586l-.646-.647a.5.5 0 0 0-.708.708l1 1a.5.5 0 0 0 .708 0l1-1a.5.5 0 0 0-.708-.708L8.5 7.586V6z" />
                    </svg>
                    Install App
                </a>
                <a href="<%= request.getContextPath()%>/register" class="signup-link">Sign up</a>
                <a href="<%= request.getContextPath() %>/login" class="login-button">Log in</a>
            </div>
        </div>
    </div>
</header>

<!-- Mobile Authentication Modal -->
<div class="modal fade auth-modal" id="authModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Account</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="d-grid gap-2">
                    <a href="<%= request.getContextPath()%>/register" class="btn btn-outline-light">Sign up</a>
                    <a href="<%= request.getContextPath() %>/login" class="btn btn-light">Login</a>
                </div>
            </div>
        </div>
    </div>
</div>