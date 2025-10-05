<%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <title>Admin Dashboard</title>

        <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
            crossorigin="anonymous" referrerpolicy="no-referrer" />

        <style>
            #layoutSidenav {
                display: flex;
            }

            #layoutSidenav_nav {
                flex-shrink: 0;
                transition: width 0.3s ease-in-out;
                z-index: 1030;
            }

            #sidenavAccordion {
                background-color: #212529;
                height: 100vh;
                position: fixed;
                width: 225px;
                overflow-y: auto;
                transition: transform 0.3s ease-in-out, width 0.3s ease-in-out;
                transform: translateX(0);
            }

            #sidenavAccordion.collapsed {
                transform: translateX(-100%);
                width: 0;
            }

            #layoutSidenav_content {
                flex-grow: 1;
                margin-left: 225px;
                padding: 20px;
                transition: margin-left 0.3s ease-in-out;
            }

            #layoutSidenav_content.expanded {
                margin-left: 0;
            }

            .sb-sidenav-menu .nav-link {
                color: rgba(255, 255, 255, 0.5);
                padding: 0.75rem 1rem;
            }

            .sb-sidenav-menu .nav-link:hover {
                color: rgba(255, 255, 255, 0.8);
            }

            .sb-sidenav-menu .nav-link.active {
                color: #ffffff;
                background-color: rgba(255, 255, 255, 0.1);
            }

            .sb-sidenav-menu .nav-link .sb-nav-link-icon {
                margin-right: 0.5rem;
            }

            .sb-sidenav-menu-heading {
                padding: 0.75rem 1rem;
                font-size: 0.8rem;
                color: rgba(255, 255, 255, 0.4);
            }
        </style>
    </head>

    <body>

        <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
            <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle"><i
                    class="fas fa-bars"></i></button>
            <a class="navbar-brand ps-3"
                href="${pageContext.request.contextPath}/admin?action=list&type=dashboard">Admin Panel</a>

        </nav>

        <div id="layoutSidenav">
            <%-- 1. LEFT NAVBAR (SIDEBAR) --%>
                <div id="layoutSidenav_nav">
                    <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion" style="width: 170px;">
                        <div class="sb-sidenav-menu">
                            <div class="nav">
                                <% String type=request.getParameter("type"); if (type==null||type.isBlank())
                                    type="dashboard" ; %>
                                    <a class="nav-link <%= " dashboard".equalsIgnoreCase(type) ? "active" : "" %>"
                                        href="${pageContext.request.contextPath}/admin?action=list&type=dashboard">
                                        <div class="sb-nav-link-icon"><i class="fas fa-tachometer-alt"></i>
                                        </div>
                                        Dashboard
                                    </a>

                                    <a class="nav-link <%= " users".equalsIgnoreCase(type) ? "active" : "" %>"
                                        href="${pageContext.request.contextPath}/admin?action=list&type=users">
                                        <div class="sb-nav-link-icon"><i class="fas fa-users"></i></div>
                                        User Management
                                    </a>

                                    <a class="nav-link" href="#">
                                        <div class="sb-nav-link-icon"><i class="fas fa-music"></i></div>
                                        Song Management
                                    </a>

                                    <%-- Thêm các mục quản lý khác tại đây (ví dụ: Categories, Albums) --%>
                                        <a class="nav-link" href="#">
                                            <div class="sb-nav-link-icon"><i class="fas fa-cog"></i></div>
                                            System Settings
                                        </a>
                            </div>
                        </div>
                        <div class="sb-sidenav-footer">
                            <div class="small">Logged in as:</div>
                            Admin
                        </div>
                    </nav>
                </div>

                <%-- 2. MAIN CONTENT --%>
                    <div id="layoutSidenav_content">
                        <main>
                            <div class="container-fluid">
                                <h1 class="mt-4">
                                    <%= "users" .equalsIgnoreCase(type) ? "Users Management" :
                                        ("dashboard".equalsIgnoreCase(type) ? "Dashboard" : "Management" ) %>
                                </h1>
                                <ol class="breadcrumb mb-4">
                                    <li class="breadcrumb-item"><a
                                            href="${pageContext.request.contextPath}/admin?action=list&type=dashboard">Dashboard</a>
                                    </li>
                                    <li class="breadcrumb-item active">
                                        <%= "users" .equalsIgnoreCase(type) ? "Users" :
                                            ("dashboard".equalsIgnoreCase(type) ? "Home" : type) %>
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
                // Sidebar toggle with smooth animation
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
                            } else {
                                sidenav.classList.remove('collapsed');
                                content.classList.remove('expanded');
                            }
                        };

                        toggle.addEventListener('click', toggleSidebar);

                        // Initialize sidebar state
                        sidenav.classList.remove('collapsed');
                        content.classList.remove('expanded');
                    }
                });
            </script>
    </body>

    </html>