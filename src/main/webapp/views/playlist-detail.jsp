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
                <style>
                    /* Back Button Styles */
                    .back-button-container {
                        margin-bottom: 20px;
                    }

                    .back-btn {
                        border-radius: 25px;
                        padding: 8px 16px;
                        font-size: 14px;
                    }

                    /* Cover Image Styles */
                    .playlist-cover-placeholder {
                        cursor: pointer;
                        transition: all 0.3s ease;
                    }

                    .playlist-cover-placeholder:hover {
                        opacity: 0.8;
                    }

                    .cover-preview {
                        position: relative;
                        width: 200px;
                        height: 200px;
                        border-radius: 8px;
                        overflow: hidden;
                    }

                    .cover-preview img {
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                    }

                    .btn-remove-cover {
                        position: absolute;
                        top: 8px;
                        right: 8px;
                        background: rgba(0, 0, 0, 0.7);
                        border: none;
                        color: white;
                        border-radius: 50%;
                        width: 30px;
                        height: 30px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        cursor: pointer;
                    }

                    /* Add Songs Button Styles */
                    .add-songs-btn {
                        background: linear-gradient(135deg, #1db954, #1ed760);
                        border: none;
                        color: white;
                        padding: 10px 20px;
                        border-radius: 25px;
                        font-weight: 600;
                        transition: all 0.3s ease;
                    }

                    .add-songs-btn:hover {
                        background: linear-gradient(135deg, #1ed760, #1db954);
                        transform: translateY(-2px);
                    }

                    /* Modal Styles */
                    .modal-content {
                        background-color: #191414;
                        color: white;
                        border: 1px solid #333;
                    }

                    .modal-header {
                        border-bottom: 1px solid #333;
                    }

                    .modal-footer {
                        border-top: 1px solid #333;
                    }

                    .search-input-group {
                        display: flex;
                        gap: 10px;
                        margin-bottom: 20px;
                    }

                    .search-input-group input {
                        background-color: #191414;
                        border: 1px solid #333;
                        color: white;
                    }

                    .search-input-group input:focus {
                        background-color: #191414;
                        border-color: #1db954;
                        color: white;
                        box-shadow: 0 0 0 0.2rem rgba(29, 185, 84, 0.25);
                    }

                    .song-item {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 15px;
                        border: 1px solid #333;
                        border-radius: 8px;
                        margin-bottom: 10px;
                        transition: all 0.3s ease;
                    }

                    .song-item:hover {
                        background-color: #282828;
                    }

                    .song-item.selected {
                        background-color: #1db954;
                        border-color: #1db954;
                    }

                    .song-info {
                        flex: 1;
                    }

                    .song-title {
                        font-weight: 600;
                        margin-bottom: 5px;
                    }

                    .song-artist {
                        color: #b3b3b3;
                        font-size: 14px;
                    }
                </style>
            </head>

            <body>
                <div class="playlist-container">
                    <!-- Back Button -->
                    <div class="back-button-container">
                        <button class="btn btn-outline-light back-btn" onclick="goBack()">
                            <i class="fas fa-arrow-left"></i> Back to Library
                        </button>
                    </div>

                    <!-- Playlist Header -->
                    <div class="playlist-header">
                        <div class="playlist-cover-section">
                            <div class="playlist-cover-placeholder" id="playlistCover"
                                onclick="document.getElementById('coverImageInput').click()">
                                <i class="fas fa-pencil-alt edit-icon"></i>
                                <span class="choose-photo-text">Choose photo</span>
                            </div>
                            <input type="file" id="coverImageInput" accept="image/*" style="display: none;"
                                onchange="handleCoverImageUpload(event)">
                            <div class="cover-preview" id="coverPreview" style="display: none;">
                                <img id="previewImage" src="" alt="Cover Preview">
                                <button type="button" class="btn-remove-cover" onclick="removeCoverImage()">
                                    <i class="fas fa-times"></i>
                                </button>
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
                            <button class="action-btn add-songs-btn" id="addSongsBtn">
                                <i class="fas fa-plus"></i>
                                <span>Add Songs</span>
                            </button>
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

                <!-- Add Songs Modal -->
                <div class="modal fade" id="addSongsModal" tabindex="-1" aria-labelledby="addSongsModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="addSongsModalLabel">Add Songs to Playlist</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="search-songs-section">
                                    <div class="search-input-group">
                                        <input type="text" class="form-control" id="songSearchInput"
                                            placeholder="Search for songs...">
                                        <button class="btn btn-primary" onclick="searchSongs()">
                                            <i class="fas fa-search"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="songs-list" id="availableSongsList">
                                    <!-- Songs will be loaded here -->
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="button" class="btn btn-primary" onclick="addSelectedSongs()">Add Selected
                                    Songs</button>
                            </div>
                        </div>
                    </div>
                </div>

                <script>
                    // Override any remaining alerts
                    window.alert = function (message) {
                        // Suppress alerts
                        console.log("Alert suppressed:", message);
                    };

                    // Back button functionality
                    function goBack() {
                        window.history.back();
                    }

                    // Cover image upload functionality
                    function handleCoverImageUpload(event) {
                        const file = event.target.files[0];
                        if (file) {
                            const reader = new FileReader();
                            reader.onload = function (e) {
                                const preview = document.getElementById('coverPreview');
                                const previewImage = document.getElementById('previewImage');
                                const placeholder = document.getElementById('playlistCover');

                                previewImage.src = e.target.result;
                                placeholder.style.display = 'none';
                                preview.style.display = 'block';
                            };
                            reader.readAsDataURL(file);
                        }
                    }

                    function removeCoverImage() {
                        const preview = document.getElementById('coverPreview');
                        const placeholder = document.getElementById('playlistCover');
                        const input = document.getElementById('coverImageInput');

                        preview.style.display = 'none';
                        placeholder.style.display = 'block';
                        input.value = '';
                    }

                    // Add songs modal functionality
                    document.getElementById('addSongsBtn').addEventListener('click', function () {
                        const modal = new bootstrap.Modal(document.getElementById('addSongsModal'));
                        modal.show();
                        loadAvailableSongs();
                    });

                    function loadAvailableSongs() {
                        // This would typically fetch from server
                        const songsList = document.getElementById('availableSongsList');
                        songsList.innerHTML = `
                            <div class="song-item" data-song-id="1">
                                <div class="song-info">
                                    <div class="song-title">Sample Song 1</div>
                                    <div class="song-artist">Artist 1</div>
                                </div>
                                <button class="btn btn-sm btn-outline-primary" onclick="toggleSongSelection(this, 1)">
                                    Add
                                </button>
                            </div>
                            <div class="song-item" data-song-id="2">
                                <div class="song-info">
                                    <div class="song-title">Sample Song 2</div>
                                    <div class="song-artist">Artist 2</div>
                                </div>
                                <button class="btn btn-sm btn-outline-primary" onclick="toggleSongSelection(this, 2)">
                                    Add
                                </button>
                            </div>
                        `;
                    }

                    function toggleSongSelection(button, songId) {
                        if (button.classList.contains('btn-primary')) {
                            button.classList.remove('btn-primary');
                            button.classList.add('btn-outline-primary');
                            button.textContent = 'Add';
                            button.closest('.song-item').classList.remove('selected');
                        } else {
                            button.classList.remove('btn-outline-primary');
                            button.classList.add('btn-primary');
                            button.textContent = 'Added';
                            button.closest('.song-item').classList.add('selected');
                        }
                    }

                    function addSelectedSongs() {
                        const selectedSongs = document.querySelectorAll('.song-item.selected');
                        selectedSongs.forEach(songItem => {
                            const songId = songItem.dataset.songId;
                            addSongToPlaylist(songId);
                        });

                        // Close modal
                        const modal = bootstrap.Modal.getInstance(document.getElementById('addSongsModal'));
                        modal.hide();

                        // Reload page to show new songs
                        location.reload();
                    }

                    function addSongToPlaylist(songId) {
                        const form = document.createElement('form');
                        form.method = 'POST';
                        form.action = '${pageContext.request.contextPath}/playlist';

                        const actionInput = document.createElement('input');
                        actionInput.type = 'hidden';
                        actionInput.name = 'action';
                        actionInput.value = 'addSong';

                        const playlistIdInput = document.createElement('input');
                        playlistIdInput.type = 'hidden';
                        playlistIdInput.name = 'playlistId';
                        playlistIdInput.value = '${playlist.id}';

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

                    function searchSongs() {
                        const query = document.getElementById('songSearchInput').value;
                        // Implement search functionality here
                    }
                </script>
            </body>

</html>