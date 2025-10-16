<!DOCTYPE html>
<html lang="en">
<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <head>
                <title>Luna Music - Home</title>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta charset="utf-8">
                <meta name="context-path" content="${pageContext.request.contextPath}">

                <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
            </head>

            <body>
                <div class="main-container">
                    <!-- Artists Section -->
                    <div class="section">
                        <h2 class="section-title">Artists</h2>
                        <div class="horizontal-scroll">
                            <c:choose>
                                <c:when test="${not empty requestScope.artists}">
                                    <c:forEach var="artist" items="${requestScope.artists}">
                                        <div class="artist-card" onclick="viewArtist(${artist.id})">
                                            <img src="${pageContext.request.contextPath}${artist.imagePath}"
                                                alt="${artist.name}" class="artist-image"
                                                onerror="this.src='${pageContext.request.contextPath}/assets/img/default-artist.png'">
                                            <div class="artist-name">${artist.name}</div>
                                            <div class="artist-label">Artist</div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <!-- Demo artists for development -->
                                    <div class="artist-card">
                                        <img src="https://via.placeholder.com/150/FF6B6B/FFFFFF?text=IVE" alt="IVE"
                                            class="artist-image">
                                        <div class="artist-name">IVE</div>
                                        <div class="artist-label">Artist</div>
                                    </div>
                                    <div class="artist-card">
                                        <img src="https://via.placeholder.com/150/4ECDC4/FFFFFF?text=BABYMONSTER"
                                            alt="BABYMONSTER" class="artist-image">
                                        <div class="artist-name">BABYMONSTER</div>
                                        <div class="artist-label">Artist</div>
                                    </div>
                                    <div class="artist-card">
                                        <img src="https://via.placeholder.com/150/45B7D1/FFFFFF?text=JENNIE"
                                            alt="JENNIE" class="artist-image">
                                        <div class="artist-name">JENNIE</div>
                                        <div class="artist-label">Artist</div>
                                    </div>
                                    <div class="artist-card">
                                        <img src="https://via.placeholder.com/150/F9CA24/FFFFFF?text=KATSEYE"
                                            alt="KATSEYE" class="artist-image">
                                        <div class="artist-name">KATSEYE</div>
                                        <div class="artist-label">Artist</div>
                                    </div>
                                    <div class="artist-card">
                                        <img src="https://via.placeholder.com/150/6C5CE7/FFFFFF?text=LE+SSERAFIM"
                                            alt="LE SSERAFIM" class="artist-image">
                                        <div class="artist-name">LE SSERAFIM</div>
                                        <div class="artist-label">Artist</div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Albums Section -->
                    <div class="section">
                        <h2 class="section-title">Albums</h2>
                        <div class="horizontal-scroll">
                            <c:choose>
                                <c:when test="${not empty requestScope.albums}">
                                    <c:forEach var="album" items="${requestScope.albums}">
                                        <div class="album-card" onclick="viewAlbum(${album.id})">
                                            <img src="${pageContext.request.contextPath}${album.coverImagePath}"
                                                alt="${album.title}" class="album-cover"
                                                onerror="this.src='${pageContext.request.contextPath}/assets/img/default-album.png'">
                                            <div class="album-title">${album.title}</div>
                                            <div class="album-type">Album</div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <!-- Demo albums for development -->
                                    <div class="album-card">
                                        <img src="https://via.placeholder.com/180/87CEEB/FFFFFF?text=IVE+SECRET"
                                            alt="IVE SECRET" class="album-cover">
                                        <div class="album-title">IVE SECRET</div>
                                        <div class="album-type">IVE The 1st EP</div>
                                    </div>
                                    <div class="album-card">
                                        <img src="https://via.placeholder.com/180/FFFFFF/000000?text=I'VE+IVE"
                                            alt="I'VE IVE" class="album-cover">
                                        <div class="album-title">I'VE IVE</div>
                                        <div class="album-type">EP</div>
                                    </div>
                                    <div class="album-card">
                                        <img src="https://via.placeholder.com/180/98FB98/000000?text=After+LIKE"
                                            alt="After LIKE" class="album-cover">
                                        <div class="album-title">After LIKE</div>
                                        <div class="album-type">IVE 3RD SINGLE ALBUM</div>
                                    </div>
                                    <div class="album-card">
                                        <img src="https://via.placeholder.com/180/F0E68C/000000?text=I'VE+Empathy"
                                            alt="I'VE Empathy" class="album-cover">
                                        <div class="album-title">I'VE Empathy</div>
                                        <div class="album-type">EP</div>
                                    </div>
                                    <div class="album-card">
                                        <img src="https://via.placeholder.com/180/FFB6C1/FFFFFF?text=I'VE+MINE"
                                            alt="I'VE MINE" class="album-cover">
                                        <div class="album-title">I'VE MINE</div>
                                        <div class="album-type">IVE THE 1st EP</div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Songs Section -->
                    <div class="section">
                        <h2 class="section-title">Popular Songs</h2>
                        <c:choose>
                            <c:when test="${not empty requestScope.songs}">
                                <div class="horizontal-scroll">
                                    <c:forEach var="song" items="${requestScope.songs}" varStatus="status">
                                        <c:if test="${status.index < 10}">
                                            <div class="album-card" onclick="playSong(${song.id})"
                                                data-song-id="${song.id}">
                                                <img src="${pageContext.request.contextPath}${song.coverImage}"
                                                    alt="${song.title}" class="album-cover"
                                                    onerror="this.src='${pageContext.request.contextPath}/assets/img/default-song.png'">
                                                <div class="album-title">${song.title}</div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="fas fa-music"></i>
                                    <p>No songs available at the moment.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <meta name="context-path" content="${pageContext.request.contextPath}">

                <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>

                <script>
                    // Get context path for navigation
                    const currentContextPath = "${pageContext.request.contextPath}";

                    console.log('Home.js inline loaded. Context path:', currentContextPath);

                    /**
                     * Play song functionality
                     * @param {number} songId - The song ID
                     */
                    function playSong(songId) {
                        console.log("Playing song:", songId);
                        console.log("Current context path:", currentContextPath);
                        console.log("Full URL will be:", currentContextPath + "/song-detail?id=" + songId);

                        // Navigate to song detail page
                        window.location.href = currentContextPath + "/song-detail?id=" + songId;
                    }

                    /**
                     * Navigate to artist page
                     * @param {number} artistId - The artist ID
                     */
                    function viewArtist(artistId) {
                        console.log("Viewing artist:", artistId);
                        window.location.href = currentContextPath + "/artist?id=" + artistId;
                    }

                    /**
                     * Navigate to album page
                     * @param {number} albumId - The album ID
                     */
                    function viewAlbum(albumId) {
                        console.log("Viewing album:", albumId);
                        window.location.href = currentContextPath + "/album?id=" + albumId;
                    }

                    // Export functions for global use
                    window.playSong = playSong;
                    window.viewArtist = viewArtist;
                    window.viewAlbum = viewAlbum;

                    // Debug: Log that functions are available
                    console.log("Functions available:", {
                        viewArtist: typeof window.viewArtist,
                        viewAlbum: typeof window.viewAlbum,
                        playSong: typeof window.playSong
                    });

                    // Initialize when DOM is loaded
                    document.addEventListener("DOMContentLoaded", function () {
                        console.log('DOM loaded. Functions ready to use.');

                        // Test click events on song cards
                        document.querySelectorAll('.album-card[data-song-id]').forEach(function (card, index) {
                            console.log('Found song card', index, 'with data-song-id:', card.getAttribute('data-song-id'));

                            // Add click event listener as backup
                            card.addEventListener('click', function (e) {
                                console.log('Song card clicked via event listener');
                                const songId = card.getAttribute('data-song-id');
                                if (songId) {
                                    console.log('Playing song via event listener:', songId);
                                    playSong(parseInt(songId));
                                }
                            });
                        });
                    });
                </script>
            </body>

</html>