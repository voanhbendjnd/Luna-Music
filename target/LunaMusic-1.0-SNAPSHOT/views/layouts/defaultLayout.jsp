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

                    <div class="main-content">
                        <%@include file="../home.jsp" %>
                    </div>
                    <%@include file="../components/footer.jsp" %>

                        <%@include file="../components/bottom-nav.jsp" %>



                            <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>

            </body>

</html>