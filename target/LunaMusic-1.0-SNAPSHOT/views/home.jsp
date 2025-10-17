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
                    /* Force green color for active nav pills */
                    .nav-pills .nav-link.active {
                        background-color: #28a745 !important;
                        color: white !important;
                        border: none !important;
                    }

                    .nav-pills .nav-link {
                        color: #b3b3b3;
                        background-color: transparent;
                        border: none;
                    }

                    .nav-pills .nav-link:hover {
                        color: white;
                        background-color: rgba(255, 255, 255, 0.1);
                    }

                    /* Remove blue border from search input */
                    .form-control:focus {
                        border-color: #6c757d !important;
                        box-shadow: none !important;
                        outline: none !important;
                    }

                    .form-control {
                        border-color: #6c757d !important;
                        box-shadow: none !important;
                    }

                    .input-group:focus-within .form-control {
                        border-color: #6c757d !important;
                        box-shadow: none !important;
                    }

                    /* Force dark background */
                    body,
                    html {
                        background-color: #030303 !important;
                        color: white !important;
                    }

                    .container-fluid,
                    .row {
                        background-color: #030303 !important;
                    }

                    .bg-dark {
                        background-color: #030303 !important;
                    }

                    /* Override Bootstrap defaults */
                    .container-fluid {
                        background-color: #030303 !important;
                    }

                    .row {
                        background-color: #030303 !important;
                    }

                    .col-md-3,
                    .col-lg-2 {
                        background-color: #000000 !important;
                    }

                    .col-md-9,
                    .col-lg-10 {
                        background-color: #030303 !important;
                    }
                </style>
            </head>

            <body class="bg-dark text-white">
                <div class="container-fluid p-0">
                    <div class="row g-0 min-vh-100">
                        <!-- Left Sidebar - Your Library -->
                        <div class="col-md-3 col-lg-2 bg-dark border-end border-secondary">
                            <div class="p-3">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h2 class="h4 mb-0 text-white fw-bold">Your Library</h2>
                                    <button class="btn btn-outline-light btn-sm rounded-circle" id="addToLibraryBtn">
                                        <i class="fas fa-plus"></i>
                                    </button>
                                </div>

                                <!-- Library Navigation -->
                                <div class="mb-4">
                                    <ul class="nav nav-pills nav-fill mb-3">
                                        <li class="nav-item">
                                            <button
                                                class="nav-link active d-flex align-items-center justify-content-center gap-2"
                                                data-tab="playlists"
                                                style="background-color: #28a745 !important; color: white !important; border: none !important;">
                                                <i class="fas fa-music"></i>
                                                <span>Playlists</span>
                                            </button>
                                        </li>
                                        <li class="nav-item">
                                            <button
                                                class="nav-link d-flex align-items-center justify-content-center gap-2"
                                                data-tab="recents"
                                                style="color: #b3b3b3; background-color: transparent; border: none;">
                                                <i class="fas fa-clock"></i>
                                                <span>Recents</span>
                                            </button>
                                        </li>
                                    </ul>

                                    <div class="d-flex gap-2">
                                        <div class="input-group input-group-sm">
                                            <span class="input-group-text bg-secondary border-secondary">
                                                <i class="fas fa-search text-muted"></i>
                                            </span>
                                            <input type="text"
                                                class="form-control bg-secondary border-secondary text-white"
                                                placeholder="Search in Your Library">
                                        </div>
                                        <button class="btn btn-outline-secondary btn-sm" id="sortBtn">
                                            <i class="fas fa-sort"></i>
                                        </button>
                                    </div>
                                </div>

                                <div class="library-content">
                                    <!-- Playlists Tab Content -->
                                    <div class="tab-content active" id="playlistsTab">
                                        <div class="playlists-list" id="playlistsList">
                                            <!-- Playlists will be loaded here -->
                                        </div>
                                    </div>

                                    <!-- Recents Tab Content -->
                                    <div class="tab-content" id="recentsTab">
                                        <div class="recents-list" id="recentsList">
                                            <div class="text-center text-muted py-4">
                                                <i class="fas fa-clock fa-2x mb-2"></i>
                                                <p class="mb-0">No recent activity</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Main Content -->
                        <div class="col-md-9 col-lg-10 bg-dark">
                            <div class="p-4">
                                <!-- Artists Section -->
                                <div class="mb-5">
                                    <h2 class="h3 mb-4 text-white fw-bold">Artists</h2>
                                    <div class="d-flex gap-3 overflow-auto pb-2">
                                        <c:choose>
                                            <c:when test="${not empty requestScope.artists}">
                                                <c:forEach var="artist" items="${requestScope.artists}">
                                                    <div class="text-center" style="min-width: 150px;"
                                                        onclick="viewArtist(${artist.id})">
                                                        <div class="position-relative mb-2">
                                                            <img src="${pageContext.request.contextPath}${artist.imagePath}"
                                                                alt="${artist.name}"
                                                                class="rounded-circle object-fit-cover"
                                                                style="width: 120px; height: 120px;"
                                                                onerror="this.src='${pageContext.request.contextPath}/assets/img/default-artist.png'">
                                                        </div>
                                                        <h6 class="text-white mb-1 fw-semibold">${artist.name}</h6>
                                                        <small class="album-type">Artist</small>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Demo artists for development -->
                                                <div class="text-center" style="min-width: 150px;">
                                                    <div class="position-relative mb-2">
                                                        <img src="https://via.placeholder.com/150/FF6B6B/FFFFFF?text=IVE"
                                                            alt="IVE" class="rounded-circle object-fit-cover"
                                                            style="width: 120px; height: 120px;">
                                                    </div>
                                                    <h6 class="text-white mb-1 fw-semibold">IVE</h6>
                                                    <small class="text-muted">Artist</small>
                                                </div>
                                                <div class="text-center" style="min-width: 150px;">
                                                    <div class="position-relative mb-2">
                                                        <img src="https://via.placeholder.com/150/4ECDC4/FFFFFF?text=BABYMONSTER"
                                                            alt="BABYMONSTER" class="rounded-circle object-fit-cover"
                                                            style="width: 120px; height: 120px;">
                                                    </div>
                                                    <h6 class="text-white mb-1 fw-semibold">BABYMONSTER</h6>
                                                    <small class="text-muted">Artist</small>
                                                </div>
                                                <div class="text-center" style="min-width: 150px;">
                                                    <div class="position-relative mb-2">
                                                        <img src="https://via.placeholder.com/150/45B7D1/FFFFFF?text=JENNIE"
                                                            alt="JENNIE" class="rounded-circle object-fit-cover"
                                                            style="width: 120px; height: 120px;">
                                                    </div>
                                                    <h6 class="text-white mb-1 fw-semibold">JENNIE</h6>
                                                    <small class="text-muted">Artist</small>
                                                </div>
                                                <div class="text-center" style="min-width: 150px;">
                                                    <div class="position-relative mb-2">
                                                        <img src="https://via.placeholder.com/150/F9CA24/FFFFFF?text=KATSEYE"
                                                            alt="KATSEYE" class="rounded-circle object-fit-cover"
                                                            style="width: 120px; height: 120px;">
                                                    </div>
                                                    <h6 class="text-white mb-1 fw-semibold">KATSEYE</h6>
                                                    <small class="text-muted">Artist</small>
                                                </div>
                                                <div class="text-center" style="min-width: 150px;">
                                                    <div class="position-relative mb-2">
                                                        <img src="https://via.placeholder.com/150/6C5CE7/FFFFFF?text=LE+SSERAFIM"
                                                            alt="LE SSERAFIM" class="rounded-circle object-fit-cover"
                                                            style="width: 120px; height: 120px;">
                                                    </div>
                                                    <h6 class="text-white mb-1 fw-semibold">LE SSERAFIM</h6>
                                                    <small class="text-muted">Artist</small>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>


                                <!-- Albums Section -->
                                <div class="mb-5">
                                    <h2 class="h3 mb-4 text-white fw-bold">Albums</h2>
                                    <div class="d-flex gap-3 overflow-auto pb-2">
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
                        </div>
                    </div>
                </div>

                <meta name="context-path" content="${pageContext.request.contextPath}">

                <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/home.js"></script>
            </body>

</html>