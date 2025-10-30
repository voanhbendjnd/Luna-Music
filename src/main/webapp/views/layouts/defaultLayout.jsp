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
                    <nav class="nav nav-pills nav-fill d-flex flex-nowrap w-100 justify-content-center"
                        style="margin: 0 auto; max-width: 600px;" ">
                        <a class=" nav-link" href="${pageContext.request.contextPath}/home?action=filter&type=Vpop">
                        Vpop</a>
                        <a class="nav-link"
                            href="${pageContext.request.contextPath}/home?action=filter&type=Kpop">Kpop</a>
                        <a class="nav-link"
                            href="${pageContext.request.contextPath}/home?action=filter&type=Jpop">Jpop</a>
                        <a class="nav-link"
                            href="${pageContext.request.contextPath}/home?action=filter&type=Us-uk">Usuk</a>

                    </nav>
                    <div class="main-content">
                        <%@include file="../home.jsp" %>
                    </div>
                    <%@include file="../components/footer.jsp" %>

                        <%@include file="../components/bottom-nav.jsp" %>

            </body>


</html>