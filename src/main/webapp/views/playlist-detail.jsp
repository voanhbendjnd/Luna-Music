<!DOCTYPE html>
<html lang="en">
<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <head>
                <title>${playlist.name} - Luna Music</title>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta charset="utf-8">
                <meta name="context-path" content="${pageContext.request.contextPath}">

                <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/playlist-detail.css">
            </head>

            <body>
                <div class="playlist-container">
                    <!-- Playlist Header -->
                    <div class="playlist-header">
                        <div class="playlist-cover-section">
                            <div class="playlist-cover-placeholder" id="playlistCover">
                                <i class="fas fa-pencil-alt edit-icon"></i>
                                <span class="choose-photo-text">Choose photo</span>
                            </div>
                        </div>

                        <div class="playlist-info-section">
                            <div class="playlist-type">Public Playlist</div>
                            <h1 class="playlist-title">${playlist.name}</h1>
                            <div class="playlist-creator">${playlist.user.name}</div>
                            <div class="playlist-stats">
                                <span class="song-count">${playlist.songCount} songs</span>
                                <span class="total-duration">${playlist.totalDuration}</span>
                            </div>
                        </div>
                    </div>

                    <!-- Playlist Actions -->
                    <div class="playlist-actions">
                        <div class="action-buttons">
                            <button class="action-btn" id="addCollaboratorBtn">
                                <i class="fas fa-user-plus"></i>
                            </button>
                            <button class="action-btn" id="moreOptionsBtn">
                                <i class="fas fa-ellipsis-h"></i>
                            </button>
                        </div>

                        <div class="view-toggle">
                            <span class="view-label">List</span>
                            <button class="view-btn" id="viewToggleBtn">
                                <i class="fas fa-bars"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Add Songs Section -->
                    <div class="add-songs-section">
                        <h3 class="section-title">Let's find something for your playlist</h3>

                        <div class="search-container">
                            <div class="search-input-wrapper">
                                <i class="fas fa-search search-icon"></i>
                                <input type="text" id="songSearchInput" class="search-input"
                                    placeholder="Search for songs or episodes">
                                <button class="search-clear-btn" id="searchClearBtn" style="display: none;">
                                    <i class="fas fa-times"></i>
                                </button>
                            </div>
                        </div>

                        <!-- Search Results -->
                        <div class="search-results" id="searchResults" style="display: none;">
                            <div class="search-results-header">
                                <h4>Search Results</h4>
                            </div>
                            <div class="search-results-content" id="searchResultsContent">
                                <!-- Search results will be populated here -->
                            </div>
                        </div>
                    </div>

                    <!-- Playlist Songs -->
                    <div class="playlist-songs-section">
                        <c:choose>
                            <c:when test="${not empty playlist.playlistSongs}">
                                <div class="songs-list">
                                    <c:forEach var="playlistSong" items="${playlist.playlistSongs}" varStatus="status">
                                        <div class="song-item" onclick="playSong(${playlistSong.song.id})">
                                            <div class="song-number">${status.index + 1}</div>
                                            <img src="${pageContext.request.contextPath}${playlistSong.song.coverImage}"
                                                alt="${playlistSong.song.title}" class="song-cover"
                                                onerror="this.src='${pageContext.request.contextPath}/assets/img/default-song.png'">
                                            <div class="song-info">
                                                <div class="song-title">${playlistSong.song.title}</div>
                                                <div class="song-artist">
                                                    <c:forEach var="songArtist" items="${playlistSong.song.songArtists}"
                                                        varStatus="artistStatus">
                                                        <c:if test="${!artistStatus.first}">, </c:if>
                                                        ${songArtist.artist.name}
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <div class="song-duration">
                                                <fmt:formatNumber value="${playlistSong.song.duration / 60}"
                                                    pattern="#,##0" />:
                                                <fmt:formatNumber value="${playlistSong.song.duration % 60}"
                                                    pattern="00" />
                                            </div>
                                            <button class="remove-song-btn"
                                                onclick="removeSongFromPlaylist(event, ${playlist.id}, ${playlistSong.song.id})">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-playlist">
                                    <i class="fas fa-music empty-icon"></i>
                                    <h3>Your playlist is empty</h3>
                                    <p>Search for songs above to add them to your playlist</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Scripts -->
                <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/playlist-detail.js"></script>

                <script>
                    // Context path for navigation
                    const currentContextPath = "${pageContext.request.contextPath}";
                    const playlistId = ${ playlist.id };

                    // All songs data for search
                    const allSongs = [
                        <c:forEach var="song" items="${allSongs}" varStatus="status">
                            {
                                id: ${song.id},
                            title: "${song.title}",
                            artistName: "<c:forEach var='songArtist' items='${song.songArtists}' varStatus='artistStatus'><c:if test='${!artistStatus.first}'>, </c:if>${songArtist.artist.name}</c:forEach>",
                            coverImage: "${pageContext.request.contextPath}${song.coverImage}",
                            duration: ${song.duration}
            }<c:if test="${!status.last}">,</c:if>
                        </c:forEach>
                    ];

                    /**
                     * Play song functionality
                     */
                    function playSong(songId) {
                        console.log("Playing song:", songId);
                        window.location.href = currentContextPath + "/song-detail?id=" + songId;
                    }

                    /**
                     * Remove song from playlist
                     */
                    function removeSongFromPlaylist(event, playlistId, songId) {
                        event.stopPropagation(); // Prevent triggering playSong

                        if (confirm("Are you sure you want to remove this song from the playlist?")) {
                            const form = document.createElement('form');
                            form.method = 'POST';
                            form.action = currentContextPath + '/playlist';

                            const actionInput = document.createElement('input');
                            actionInput.type = 'hidden';
                            actionInput.name = 'action';
                            actionInput.value = 'removeSong';

                            const playlistIdInput = document.createElement('input');
                            playlistIdInput.type = 'hidden';
                            playlistIdInput.name = 'playlistId';
                            playlistIdInput.value = playlistId;

                            const songIdInput = document.createElement('input');
                            songIdInput.type = 'hidden';
                            songIdInput.name = 'songId';
                            songIdInput.value = songId;

                            form.appendChild(actionInput);
                            form.appendChild(playlistIdInput);
                            form.appendChild(songIdInput);

                            document.body.appendChild(form);
                            form.submit();
                        }
                    }

                    // Export functions globally
                    window.playSong = playSong;
                    window.removeSongFromPlaylist = removeSongFromPlaylist;
                </script>
            </body>

</html>