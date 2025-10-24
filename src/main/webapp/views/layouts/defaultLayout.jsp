<!DOCTYPE html>
<html lang="vi">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page contentType="text/html;charset=UTF-8" %>
        <%@ page import="jakarta.servlet.*" %>

            <head>
                <meta charset="UTF-8">
                <title>${pageTitle}</title>
                <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
            </head>

            <body>

                <%@include file="../components/header.jsp" %>
                    <nav class="nav nav-pills nav-fill" style="margin-left: 250px;">
                        <a class="nav-link active" aria-current="page" href="#">Vpop</a>
                        <a class="nav-link" href="#">Kpop</a>
                        <a class="nav-link active" href="#">Jpop</a>
                        <a class="nav-link disabled" aria-disabled="true">Usuk</a>
                    </nav>
                    <div class="main-content">
                        <%@include file="../home.jsp" %>
                    </div>
                    <%@include file="../components/footer.jsp" %>

                        <%@include file="../components/bottom-nav.jsp" %>



                            <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>

            </body>

</html>