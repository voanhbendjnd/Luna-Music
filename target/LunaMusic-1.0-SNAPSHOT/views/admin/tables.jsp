<%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <title>Admin Dashboard</title>

        <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet" />
        <link href="${pageContext.request.contextPath}/assets/css/admin-layout.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
            crossorigin="anonymous" referrerpolicy="no-referrer" />
    </head>

    <body>

        <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
            <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle">
                <i class="fas fa-bars"></i>
            </button>
            <a class="navbar-brand ps-3" href="${pageContext.request.contextPath}/admin?action=list&type=dashboard">
                Luna Music Admin
            </a>

            <!-- User Info -->
            <div class="ms-auto d-flex align-items-center">
                <span class="text-light me-3">
                    <i class="fas fa-user-circle me-2"></i>
                    Welcome, Admin
                </span>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm">
                    <i class="fas fa-sign-out-alt me-2"></i>
                    Logout
                </a>
            </div>
        </nav>

        <div id="layoutSidenav">
            <%-- 1. LEFT NAVBAR (SIDEBAR) --%>
                <div id="layoutSidenav_nav">
                    <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
                        <div class="sb-sidenav-menu">
                            <div class="nav">
                                <% String type=request.getParameter("type"); if (type==null || type.isBlank())
                                    type="dashboard" ;%>

                                    <div class="sb-sidenav-menu-heading">Dashboard</div>
                                    <a class="nav-link <%= " dashboard".equalsIgnoreCase(type) ? "active" : "" %>"
                                        href="${pageContext.request.contextPath}/admin?action=list&type=dashboard">
                                        <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i></div>
                                        Dashboard
                                    </a>

                                    <div class="sb-sidenav-menu-heading">Content Management</div>
                                    <a class="nav-link <%= " songs".equalsIgnoreCase(type) ? "active" : "" %>"
                                        href="${pageContext.request.contextPath}/admin?action=list&type=songs">
                                        <div class="sb-nav-link-icon"><i class="fas fa-music"></i></div>
                                        Songs
                                    </a>
                                    <a class="nav-link <%= " albums".equalsIgnoreCase(type) ? "active" : "" %>"
                                        href="${pageContext.request.contextPath}/admin?action=list&type=albums">
                                        <div class="sb-nav-link-icon"><i class="fas fa-compact-disc"></i></div>
                                        Albums
                                    </a>
                                    <a class="nav-link <%= " artists".equalsIgnoreCase(type) ? "active" : "" %>"
                                        href="${pageContext.request.contextPath}/admin?action=list&type=artists">
                                        <div class="sb-nav-link-icon"><i class="fas fa-microphone"></i></div>
                                        Artists
                                    </a>
                                    <a class="nav-link <%= " genres".equalsIgnoreCase(type) ? "active" : "" %>"
                                        href="${pageContext.request.contextPath}/admin?action=list&type=genres">
                                        <div class="sb-nav-link-icon"><i class="fas fa-tags"></i></div>
                                        Genres
                                    </a>

                                    <div class="sb-sidenav-menu-heading">User Management</div>
                                    <a class="nav-link <%= " users".equalsIgnoreCase(type) ? "active" : "" %>"
                                        href="${pageContext.request.contextPath}/admin?action=list&type=users">
                                        <div class="sb-nav-link-icon"><i class="fas fa-users"></i></div>
                                        Users
                                    </a>

                                    <div class="sb-sidenav-menu-heading">System</div>
                                    <a class="nav-link" href="#">
                                        <div class="sb-nav-link-icon"><i class="fas fa-cog"></i></div>
                                        Settings
                                    </a>
                                    <a class="nav-link" href="${pageContext.request.contextPath}/">
                                        <div class="sb-nav-link-icon"><i class="fas fa-home"></i></div>
                                        Back to Site
                                    </a>
                            </div>
                        </div>
                        <div class="sb-sidenav-footer">
                            <div class="small">Logged in as:</div>
                            <div class="d-flex align-items-center">
                                <i class="fas fa-user-circle me-2"></i>
                                Admin User
                            </div>
                        </div>
                    </nav>
                </div>

                <%-- 2. MAIN CONTENT --%>
                    <div id="layoutSidenav_content">
                        <div class="content-container">
                            <div class="page-header">
                                <h1 class="page-title">
                                    <%= "users" .equalsIgnoreCase(type) ? "Users Management" :
                                        ("songs".equalsIgnoreCase(type) ? "Song Management" :
                                        ("artists".equalsIgnoreCase(type) ? "Artist Management" :
                                        ("albums".equalsIgnoreCase(type) ? "Album Management" :
                                        ("genres".equalsIgnoreCase(type) ? "Genre Management" :
                                        ("dashboard".equalsIgnoreCase(type) ? "Dashboard" : "Management" )))))%>
                                </h1>
                                <p class="page-subtitle">
                                    <%= "users" .equalsIgnoreCase(type) ? "Manage user accounts and permissions" :
                                        ("songs".equalsIgnoreCase(type) ? "Manage music tracks and metadata" :
                                        ("artists".equalsIgnoreCase(type) ? "Manage artist profiles and information" :
                                        ("albums".equalsIgnoreCase(type) ? "Manage album collections and details" :
                                        ("genres".equalsIgnoreCase(type) ? "Manage music genres and categories" :
                                        ("dashboard".equalsIgnoreCase(type) ? "Overview of your music platform"
                                        : "System management" )))))%>
                                </p>
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb">
                                        <li class="breadcrumb-item">
                                            <a
                                                href="${pageContext.request.contextPath}/admin?action=list&type=dashboard">
                                                <i class="fas fa-home me-1"></i>Dashboard
                                            </a>
                                        </li>
                                        <li class="breadcrumb-item active">
                                            <%= "users" .equalsIgnoreCase(type) ? "Users" :
                                                ("songs".equalsIgnoreCase(type) ? "Songs" :
                                                ("artists".equalsIgnoreCase(type) ? "Artists" :
                                                ("albums".equalsIgnoreCase(type) ? "Albums" :
                                                ("genres".equalsIgnoreCase(type) ? "Genres" :
                                                ("dashboard".equalsIgnoreCase(type) ? "Home" : type)))))%>
                                        </li>
                                    </ol>

                                    <!-- <c:if test="${not empty requestScope.message}">
                                    <div class="alert alert-success mt-3">${requestScope.message}</div>
                                </c:if>
                                <c:if test="${not empty requestScope.error}">
                                    <div class="alert alert-danger mt-3">${requestScope.error}</div>
                                </c:if> -->

                                    <jsp:include page="${requestScope.viewPath}" />
                            </div>
                            </main>

                            <%-- Footer --%>
                                <!-- <footer class="py-4 bg-light mt-auto">
                    <div class="container-fluid px-4">
                        <div class="d-flex align-items-center justify-content-between small">
                            <div class="text-muted">Copyright &copy; Your Website 2025</div>
                        </div>
                    </div>
                </footer> -->
                        </div>
                    </div>



                    <%-- 3. JAVASCRIPT --%>
                        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
                        <script>
                            // Enhanced Sidebar toggle with smooth animation
                            document.addEventListener('DOMContentLoaded', function () {
                                const toggle = document.getElementById('sidebarToggle');
                                const sidenav = document.getElementById('sidenavAccordion');
                                const content = document.getElementById('layoutSidenav_content');

                                if (toggle && sidenav && content) {
                                    let collapsed = false;

                                    const toggleSidebar = () => {
                                        collapsed = !collapsed;

                                        if (collapsed) {
                                            sidenav.classList.add('collapsed');
                                            content.classList.add('expanded');
                                            // Update toggle button icon
                                            toggle.innerHTML = '<i class="fas fa-bars"></i>';
                                        } else {
                                            sidenav.classList.remove('collapsed');
                                            content.classList.remove('expanded');
                                            // Update toggle button icon
                                            toggle.innerHTML = '<i class="fas fa-bars"></i>';
                                        }

                                        // Save state to localStorage
                                        localStorage.setItem('sidebarCollapsed', collapsed);
                                    };

                                    // Load saved state
                                    const savedState = localStorage.getItem('sidebarCollapsed');
                                    if (savedState === 'true') {
                                        collapsed = true;
                                        sidenav.classList.add('collapsed');
                                        content.classList.add('expanded');
                                    }

                                    toggle.addEventListener('click', toggleSidebar);

                                    // Initialize sidebar state
                                    if (!collapsed) {
                                        sidenav.classList.remove('collapsed');
                                        content.classList.remove('expanded');
                                    }

                                    // Add smooth transitions to nav links
                                    const navLinks = document.querySelectorAll('.sb-sidenav-menu .nav-link');
                                    navLinks.forEach((link, index) => {
                                        link.style.animationDelay = `${index * 0.1}s`;
                                    });

                                    // Add click animation to buttons
                                    const buttons = document.querySelectorAll('.btn');
                                    buttons.forEach(button => {
                                        button.addEventListener('click', function (e) {
                                            const ripple = document.createElement('span');
                                            const rect = this.getBoundingClientRect();
                                            const size = Math.max(rect.width, rect.height);
                                            const x = e.clientX - rect.left - size / 2;
                                            const y = e.clientY - rect.top - size / 2;

                                            ripple.style.cssText = `
                                    position: absolute;
                                    width: ${size}px;
                                    height: ${size}px;
                                    left: ${x}px;
                                    top: ${y}px;
                                    background: rgba(255, 255, 255, 0.3);
                                    border-radius: 50%;
                                    transform: scale(0);
                                    animation: ripple 0.6s linear;
                                    pointer-events: none;
                                `;

                                            this.style.position = 'relative';
                                            this.style.overflow = 'hidden';
                                            this.appendChild(ripple);

                                            setTimeout(() => {
                                                ripple.remove();
                                            }, 600);
                                        });
                                    });

                                    // Add ripple animation CSS
                                    const style = document.createElement('style');
                                    style.textContent = `
                            @keyframes ripple {
                                to {
                                    transform: scale(4);
                                    opacity: 0;
                                }
                            }
                        `;
                                    document.head.appendChild(style);
                                }
                            });
                        </script>
    </body>

    </html>