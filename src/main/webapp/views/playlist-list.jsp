<!DOCTYPE html>
<html lang="en">
<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <head>
                <title>Your Library - Luna Music</title>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta charset="utf-8">
                <meta name="context-path" content="${pageContext.request.contextPath}">

                <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
            </head>

            <body>
                <div class="home-layout">
                    <!-- Left Sidebar - Your Library -->
                    <div class="left-sidebar">
                        <div class="library-header">
                            <h2>Your Library</h2>
                            <button class="add-btn" id="addToLibraryBtn">
                                <i class="fas fa-plus"></i>
                            </button>
                        </div>

                        <!-- Library Navigation -->
                        <div class="library-navigation">
                            <div class="nav-tabs">
                                <button class="nav-tab active" data-tab="playlists">
                                    <i class="fas fa-music"></i>
                                    <span>Playlists</span>
                                </button>
                                <button class="nav-tab" data-tab="recents">
                                    <i class="fas fa-clock"></i>
                                    <span>Recents</span>
                                </button>
                            </div>

                            <div class="library-search-sort">
                                <div class="search-container">
                                    <i class="fas fa-search search-icon"></i>
                                    <input type="text" class="library-search-input"
                                        placeholder="Search in Your Library">
                                </div>
                                <button class="sort-btn" id="sortBtn">
                                    <i class="fas fa-sort"></i>
                                </button>
                            </div>
                        </div>

                        <div class="library-content">
                            <!-- Playlists Tab Content -->
                            <div class="tab-content active" id="playlistsTab">
                                <div class="playlists-list" id="playlistsList">
                                    <c:choose>
                                        <c:when test="${not empty playlists}">
                                            <c:forEach var="playlist" items="${playlists}">
                                                <div class="playlist-item" onclick="viewPlaylist(${playlist.id})">
                                                    <div class="playlist-cover">
                                                        <i class="fas fa-music"></i>
                                                    </div>
                                                    <div class="playlist-info">
                                                        <div class="playlist-name">${playlist.name}</div>
                                                        <div class="playlist-details">Playlist • ${playlist.user.name}
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="playlists-empty">
                                                <i class="fas fa-music"></i>
                                                <p>No playlists yet</p>
                                                <button class="create-first-playlist-btn" onclick="createPlaylist()">
                                                    Create your first playlist
                                                </button>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Recents Tab Content -->
                            <div class="tab-content" id="recentsTab">
                                <div class="recents-list" id="recentsList">
                                    <div class="recents-empty">
                                        <i class="fas fa-clock"></i>
                                        <p>No recent activity</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Main Content -->
                    <div class="main-content">
                        <div class="main-container">
                            <!-- Content tabs -->
                            <div class="content-tabs">
                                <button class="content-tab active" data-content="all">All</button>
                                <button class="content-tab" data-content="music">Music</button>
                                <button class="content-tab" data-content="podcasts">Podcasts</button>
                            </div>

                            <!-- To get you started section -->
                            <div class="get-started-section">
                                <h2>To get you started</h2>
                                <div class="mix-cards">
                                    <div class="mix-card">
                                        <div class="mix-cover">
                                            <i class="fas fa-music"></i>
                                        </div>
                                        <div class="mix-info">
                                            <div class="mix-title">Liked Songs</div>
                                            <div class="mix-artists">Songs you've liked</div>
                                        </div>
                                    </div>
                                    <div class="mix-card">
                                        <div class="mix-cover">
                                            <i class="fas fa-heart"></i>
                                        </div>
                                        <div class="mix-info">
                                            <div class="mix-title">Favorites</div>
                                            <div class="mix-artists">Your favorite tracks</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Recommended section -->
                            <div class="recommended-section">
                                <div class="section-header">
                                    <div class="section-subtitle">Inspired by your recent activity</div>
                                    <h2>Recommended for today</h2>
                                </div>
                                <div class="recommended-cards">
                                    <div class="recommended-card">
                                        <div class="recommended-cover">
                                            <i class="fas fa-star"></i>
                                        </div>
                                        <div class="recommended-title">Top Hits</div>
                                    </div>
                                    <div class="recommended-card">
                                        <div class="recommended-cover">
                                            <i class="fas fa-fire"></i>
                                        </div>
                                        <div class="recommended-title">Trending</div>
                                    </div>
                                    <div class="recommended-card">
                                        <div class="recommended-cover">
                                            <i class="fas fa-music"></i>
                                        </div>
                                        <div class="recommended-title">New Releases</div>
                                    </div>
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