<!DOCTYPE html>
<html lang="en">
<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <head>
                <title>${album.title} - Luna Music</title>
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
                                    <img src="${pageContext.request.contextPath}${album.coverImagePath}"
                                        alt="${album.title}" class="album-cover"
                                        onerror="this.src='${pageContext.request.contextPath}/assets/img/default-song.png'"
                                        style="width: 200px; height: 200px; object-fit: cover;">
                                </div>

                                <!-- Right Side - Album Information -->
                                <div class="song-info-container">
                                    <div class="song-label">Album</div>
                                    <h1 class="song-title">${album.title}</h1>
                                    <div class="song-details">
                                        <img src="${pageContext.request.contextPath}${album.artist.imagePath}"
                                            alt="Artist" class="artist-icon"
                                            onerror="this.src='${pageContext.request.contextPath}/assets/img/default-artist.png'">
                                        <span class="artist-name">
                                            ${album.artist.name}
                                        </span>
                                        <span class="release-year">${album.releaseYear}</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Middle Section - Controls & Artist Info -->
                        <div class="controls-section">
                            <div class="controls-container">
                                <!-- Artist Information -->
                                <div class="artist-info">
                                    <img src="${pageContext.request.contextPath}${album.artist.imagePath}" alt="Artist"
                                        class="artist-image"
                                        onerror="this.src='${pageContext.request.contextPath}/assets/img/default-artist.png'">
                                    <div class="artist-details">
                                        <div class="artist-label">Artist</div>
                                        <div class="artist-name-main">
                                            ${album.artist.name}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Recommended Section -->
                        <div class="recommended-section">
                            <div class="recommended-container">
                                <div class="recommended-header">
                                    <h3>Songs in this album</h3>
                                </div>

                                <div class="recommended-songs">
                                    <c:choose>
                                        <c:when test="${not empty songs}">
                                            <c:forEach var="song" items="${songs}" varStatus="status">
                                                <c:if test="${status.index < 5}">
                                                    <div class="recommended-song" onclick="playRelatedSong(${song.id})">
                                                        <img src="${pageContext.request.contextPath}${song.coverImage}"
                                                            alt="${song.title}" class="recommended-cover"
                                                            onerror="this.src='${pageContext.request.contextPath}/assets/img/default-song.png'">
                                                        <div class="recommended-info">
                                                            <div class="recommended-title">${song.title}</div>
                                                            <div class="recommended-artist">
                                                                <c:forEach var="songArtist" items="${song.songArtists}"
                                                                    varStatus="artistStatus">
                                                                    <c:if test="${!artistStatus.first}">, </c:if>
                                                                    ${songArtist.artist.name}
                                                                </c:forEach>
                                                            </div>
                                                            <div class="recommended-stats">
                                                                <span class="play-count">
                                                                    <fmt:formatNumber value="${song.playCount}"
                                                                        pattern="#,##0" />
                                                                </span>
                                                                <span class="duration">
                                                                    <fmt:formatNumber value="${song.duration / 60}"
                                                                        pattern="#,##0" />:
                                                                    <fmt:formatNumber value="${song.duration % 60}"
                                                                        pattern="00" />
                                                                </span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="recommended-song">
                                                <div>No song available</div>
                                            </div>

                                        </c:otherwise>
                                    </c:choose>
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
                            function playRelatedSong(songId) {
                                // Navigate đến song-detail page
                                window.location.href = currentContextPath + "/song-detail?id=" + songId;
                            }

                            // Export function globally
                            window.playRelatedSong = playRelatedSong;
                        </script>
                </body>

</html>