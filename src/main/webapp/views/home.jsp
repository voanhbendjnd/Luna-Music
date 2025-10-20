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
                <style>

                </style>
            </head>

            <body class="bg-dark text-white">
                <div class="container-fluid p-0">
                    <div class="row g-0 min-vh-100">
                        <!-- Left Sidebar - Your Library -->
                        <div class="col-md-3 col-lg-2 border-end border-secondary" style="background-color: #1db954;">
                            <div class="p-3">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h2 class="h4 mb-0 text-white fw-bold">Your Library</h2>
                                    <button class="btn btn-outline-light btn-sm rounded-circle player-btn-play"
                                        id="addToLibraryBtn">
                                        <i class="fas fa-plus"></i>
                                    </button>
                                </div>

                                <!-- Library Navigation -->
                                <div class="mb-4">
                                    <div class="d-flex gap-2">
                                        <div class="input-group input-group-sm">
                                            <span class="input-group-text bg-secondary border-secondary"
                                                style="background-color: #030303 !important; border-color: #6c757d !important; box-shadow: none !important; outline: none !important;">
                                                <i class="fas fa-search text-muted"></i>
                                            </span>
                                            <input type="text"
                                                class="form-control bg-secondary border-secondary text-white library-search-input"
                                                style="background-color: #030303 !important; border-color: #6c757d !important; box-shadow: none !important; outline: none !important;"
                                                placeholder="Search in Your Library">
                                        </div>
                                        <button class="btn btn-outline-secondary btn-sm player-btn-play" id="sortBtn">
                                            <i class="fas fa-sort"></i>
                                        </button>
                                    </div>
                                </div>

                                <div class="library-content">
                                    <div class="playlists-list" id="playlistsList">
                                        <!-- Playlists will be loaded here -->
                                        <c:if test="${not empty userPlaylists}">
                                            <c:forEach var="playlist" items="${userPlaylists}">
                                                <div class="playlist-item" onclick="viewPlaylist(${playlist.id})">
                                                    <div class="playlist-cover">
                                                        <c:choose>
                                                            <c:when test="${not empty playlist.coverImage}">
                                                                <img src="${pageContext.request.contextPath}${playlist.coverImage}"
                                                                    alt="${playlist.name}"
                                                                    onerror="this.src='${pageContext.request.contextPath}/assets/img/default-playlist.png'"
                                                                    style="width: 100%; height: 100%; object-fit: cover;">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="fas fa-music"></i>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="playlist-info">
                                                        <div class="playlist-name">${playlist.name}</div>
                                                    </div>
                                                    <button style="background-color:#030303; border: none;"
                                                        onclick="deletePlaylist(event, ${playlist.id})">
                                                        <i class="fas fa-times" style="color:#fff"></i>
                                                    </button>
                                                </div>

                                            </c:forEach>
                                        </c:if>
                                        <c:if test="${empty userPlaylists}">
                                            <div class="empty-state">
                                                <i class="fas fa-music"></i>
                                                <p>No playlists available at the moment.</p>
                                                <button class="btn btn-outline-light btn-sm show-all-btn"
                                                    onclick="createPlaylist()">
                                                    Create your first playlist
                                                </button>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Main Content -->
                        <div class="col-md-9 col-lg-10 bg-dark">
                            <div class="p-4">
                                <div class="section">
                                    <c:if test="${not empty search}">
                                        <p style="font-style: italic;">Results for "${search}"</p>
                                    </c:if>
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h2 class="section-title mb-0">
                                            <c:if test="${not empty search}">
                                                Song
                                            </c:if>
                                            <c:if test="${empty requestScope.search}">
                                                New Songs
                                            </c:if>
                                        </h2>
                                        <button class="btn btn-outline-light btn-sm show-all-btn"
                                            onclick="showAllSongs()">
                                            Show All
                                        </button>
                                    </div>
                                    <c:choose>
                                        <c:when test="${not empty requestScope.songs}">
                                            <div class="horizontal-scroll" id="new-songs-container">
                                                <c:forEach var="song" items="${requestScope.songs}" varStatus="status">
                                                    <div class="album-card" onclick="playSong(${song.id})"
                                                        data-song-id="${song.id}" <c:if test="${status.index >= 10}">
                                                        style="display: none;"</c:if>>
                                                        <img src="${pageContext.request.contextPath}${song.coverImage}"
                                                            alt="${song.title}" class="album-cover"
                                                            onerror="this.src='${pageContext.request.contextPath}/assets/img/default-song.png'">
                                                        <div class="album-title">${song.title}</div>
                                                    </div>
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
                                <!-- Artists Section -->
                                <div class="section">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h2 class="section-title mb-0">Artists</h2>
                                        <button class="btn btn-outline-light btn-sm show-all-btn"
                                            onclick="showAllArtists()">
                                            Show All
                                        </button>
                                    </div>
                                    <c:choose>
                                        <c:when test="${not empty requestScope.artists}">
                                            <div class="horizontal-scroll" id="artists-container">
                                                <c:forEach var="artist" items="${requestScope.artists}"
                                                    varStatus="status">
                                                    <div class="artist-card" onclick="viewArtist(${artist.id})"
                                                        data-artist-id="${artist.id}" <c:if
                                                        test="${status.index >= 10}">style="display: none;"</c:if>>
                                                        <div class="position-relative mb-2">
                                                            <img src="${pageContext.request.contextPath}${artist.imagePath}"
                                                                alt="${artist.name}"
                                                                class="rounded-circle object-fit-cover"
                                                                style="width: 120px; height: 120px;">
                                                        </div>
                                                        <div class="artist-name">${artist.name}</div>
                                                        <div class="artist-label">Artist</div>
                                                    </div>
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
                                <!-- Songs Section -->
                                <div class="section">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h2 class="section-title mb-0">Albums</h2>
                                        <button class="btn btn-outline-light btn-sm show-all-btn"
                                            onclick="showAllAlbums()">
                                            Show All
                                        </button>
                                    </div>
                                    <c:choose>
                                        <c:when test="${not empty requestScope.albums}">
                                            <div class="horizontal-scroll" id="popular-songs-container">
                                                <c:forEach var="album" items="${requestScope.albums}"
                                                    varStatus="status">
                                                    <div class="album-card" onclick="viewAlbum(${album.id})"
                                                        data-song-id="${album.id}" <c:if test="${status.index >= 10}">
                                                        style="display: none;"
                                                        </c:if>>
                                                        <img src="${pageContext.request.contextPath}${album.coverImagePath}"
                                                            alt="${album.title}" class="album-cover">
                                                        <div class="album-title">${album.title}</div>
                                                        <div class="album-type">Album</div>

                                                    </div>
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

                                <c:if test="${empty search}">
                                    <!-- Songs Section -->
                                    <div class="section">
                                        <div class="d-flex justify-content-between align-items-center mb-3">
                                            <h2 class="section-title mb-0">Popular Songs</h2>
                                            <button class="btn btn-outline-light btn-sm show-all-btn"
                                                onclick="showAllPopularSongs()">
                                                Show All
                                            </button>
                                        </div>
                                        <c:choose>
                                            <c:when test="${not empty requestScope.popularSong}">
                                                <div class="horizontal-scroll" id="popular-songs-container">
                                                    <c:forEach var="song" items="${requestScope.popularSong}"
                                                        varStatus="status">
                                                        <div class="album-card" onclick="playSong(${song.id})"
                                                            data-song-id="${song.id}" <c:if
                                                            test="${status.index >= 10}">
                                                            style="display: none;"
                                </c:if>>
                                <img src="${pageContext.request.contextPath}${song.coverImage}" alt="${song.title}"
                                    class="album-cover">
                                <div class="album-title">${song.title}</div>
                            </div>
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
                    </c:if>

                </div>
                </div>
                </div>
                </div>

                <meta name="context-path" content="${pageContext.request.contextPath}">

                <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/home.js"></script>

                <!-- Library search functionality -->
                <script>
                    // Wait for DOM to be ready check hd chưa
                    if (document.readyState === 'loading') {
                        // đang load thì chờ 
                        document.addEventListener('DOMContentLoaded', initLibrarySearch);
                    } else {
                        // đã load xong thì gọi hàm dưới
                        initLibrarySearch();
                    }

                    function initLibrarySearch() {
                        const searchInput = document.querySelector(".library-search-input");

                        if (searchInput) {
                            searchInput.addEventListener("input", function (e) {
                                // Lấy giá trị user gõ
                                const query = e.target.value.toLowerCase().trim();
                                // dữ liệu có sẳn ở html render
                                const items = document.querySelectorAll(".playlist-item");
                                // lọc
                                items.forEach(item => {
                                    const nameEl = item.querySelector(".playlist-name");
                                    if (nameEl) {
                                        const name = nameEl.textContent.toLowerCase();
                                        // so sánh
                                        if (query === "" || name.includes(query)) {
                                            // hiển thị
                                            item.style.display = "flex";
                                        } else {
                                            // ẩn
                                            item.style.display = "none";
                                        }
                                    }
                                });
                            });
                        }
                    }

                </script>
            </body>

</html>