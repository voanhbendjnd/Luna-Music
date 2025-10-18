<!DOCTYPE html>
<html lang="en">
<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <head>
                <title>${artist.name} - Luna Music</title>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta charset="utf-8">
                <meta name="context-path" content="${pageContext.request.contextPath}">

                <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/song-detail.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/if-footer-song-detail.css">

                <style>
                    /* Dynamic background styles */
                    .song-detail-section {
                        transition: background 1.5s ease-in-out;
                        position: relative;
                        overflow: hidden;
                    }

                    .song-detail-section>* {
                        position: relative;
                        z-index: 2;
                    }

                    .animated-background-overlay {
                        position: absolute;
                        top: 0;
                        left: 0;
                        right: 0;
                        bottom: 0;
                        pointer-events: none;
                        z-index: 1;
                    }

                    @keyframes backgroundPulse {

                        0%,
                        100% {
                            opacity: 0.3;
                            transform: scale(1);
                        }

                        50% {
                            opacity: 0.6;
                            transform: scale(1.05);
                        }
                    }
                </style>
            </head>
            <%@include file="/views/components/header.jsp" %>

                <body style="background-color: #121212;
                ">
                    <div class="spotify-player" style="background-color: #121212;">
                        <!-- Top Section - Song Details with Red Gradient -->
                        <div class="song-detail-section">
                            <div class="song-detail-content">
                                <!-- Left Side - Album Cover -->
                                <div class="album-cover-container">
                                    <img src="${pageContext.request.contextPath}${artist.imagePath}"
                                        alt="${artist.name}" class="album-cover"
                                        onerror="this.src='${pageContext.request.contextPath}/assets/img/default-song.png'"
                                        style="width: 200px; height: 200px; object-fit: cover;">
                                </div>
                                <!-- Right Side - Album Information -->
                                <div class="song-info-container">
                                    <div class="song-label">Artist</div>
                                    <h1 class="song-title">${artist.name}</h1>
                                    <div class="song-details">
                                        <span class="bio">${artist.bio}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Recommended Section -->
                        <div class="recommended-section" style="margin-top: 20px;">
                            <div class="recommended-container">
                                <div class="recommended-header">
                                    <h3>Albums by this artist</h3>
                                    <p>Based on this artist</p>
                                    <div class="recommended-songs">
                                        <c:choose>
                                            <c:when test="${not empty albums}">
                                                <c:forEach var="album" items="${albums}" varStatus="status">
                                                    <c:if test="${status.index < 5}">
                                                        <div class="recommended-song"
                                                            onclick="playRelatedAlbum(${album.id})">
                                                            <img src="${pageContext.request.contextPath}${album.coverImagePath}"
                                                                alt="${album.title}" class="recommended-cover"
                                                                onerror="this.src='${pageContext.request.contextPath}/assets/img/default-song.png'">
                                                            <div class="recommended-info">
                                                                <div class="recommended-title">${album.title}</div>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="recommended-song">
                                                    <div>No album available</div>
                                                </div>

                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>


                            </div>
                        </div>
                    </div>
                    <%@include file="/views/components/footer.jsp" %>
                        <!-- Scripts -->
                        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
                        <script src="${pageContext.request.contextPath}/assets/js/color-extractor.js"></script>
                        <script src="${pageContext.request.contextPath}/assets/js/dynamic-background.js"></script>
                        <script src="${pageContext.request.contextPath}/assets/js/song-detail.js"></script>

                        <script>
                            // Context path for navigation
                            const currentContextPath = "${pageContext.request.contextPath}";

                            /**
                             * Play related song
                             */
                            function playRelatedAlbum(albumId) {
                                // Navigate đến song-detail page
                                window.location.href = currentContextPath + "/album-detail?id=" + albumId;
                            }

                            // Export function globally
                            window.playRelatedSong = playRelatedSong;
                        </script>
                </body>

</html>