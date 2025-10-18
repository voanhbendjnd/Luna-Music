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
                    .playlist-cover-container {
                        position: relative;
                        width: 200px;
                        height: 200px;
                        border-radius: 8px;
                        overflow: hidden;
                        cursor: pointer;
                        background: linear-gradient(135deg, #1e1e1e, #2a2a2a);
                        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.5);
                    }

                    .playlist-cover-image {
                        width: 100%;
                        height: 100%;
                        object-fit: cover;
                    }

                    .playlist-cover-placeholder {
                        width: 100%;
                        height: 100%;
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        justify-content: center;
                        background: linear-gradient(135deg, #1e1e1e, #2a2a2a);
                    }

                    .playlist-cover-overlay {
                        position: absolute;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(0, 0, 0, 0.7);
                        display: flex;
                        flex-direction: column;
                        align-items: center;
                        justify-content: center;
                        opacity: 0;
                        transition: opacity 0.3s ease;
                    }

                    .playlist-cover-container:hover .playlist-cover-overlay {
                        opacity: 1;
                    }

                    .change-photo-btn {
                        background: rgba(29, 185, 84, 0.9);
                        border: none;
                        color: white;
                        padding: 10px 20px;
                        border-radius: 25px;
                        font-weight: 600;
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        transition: all 0.3s ease;
                    }

                    .change-photo-btn:hover {
                        background: rgba(29, 185, 84, 1);
                        transform: scale(1.05);
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

                    .btn-save-cover {
                        position: absolute;
                        bottom: 8px;
                        right: 8px;
                        background: rgba(29, 185, 84, 0.9);
                        border: none;
                        color: white;
                        border-radius: 50%;
                        width: 30px;
                        height: 30px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        cursor: pointer;
                        transition: all 0.3s ease;
                    }

                    .btn-save-cover:hover {
                        background: rgba(29, 185, 84, 1);
                        transform: scale(1.1);
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

                    /* Modal songs list specific styles */
                    #availableSongsList .song-item {
                        display: flex;
                        align-items: center;
                        padding: 12px;
                        border: 1px solid #333;
                        border-radius: 8px;
                        margin-bottom: 10px;
                        transition: all 0.3s ease;
                        background-color: #191414;
                    }

                    #availableSongsList .song-item:hover {
                        background-color: #282828;
                        transform: translateX(4px);
                    }

                    #availableSongsList .song-item.selected {
                        background-color: rgba(29, 185, 84, 0.2);
                        border-color: #1db954;
                    }

                    #availableSongsList .song-info {
                        flex: 1;
                        margin-left: 0;
                    }

                    .search-input-group .btn-primary {
                        background-color: #1db954;
                        border-color: #1db954;
                    }

                    .search-input-group .btn-primary:hover {
                        background-color: #1ed760;
                        border-color: #1ed760;
                    }

                    .modal-footer .btn-primary {
                        background-color: #1db954;
                        border-color: #1db954;
                    }

                    .modal-footer .btn-primary:hover {
                        background-color: #1ed760;
                        border-color: #1ed760;
                    }

                    /* Audio Player Styles */
                    .audio-player-bar {
                        position: fixed;
                        bottom: 0;
                        left: 0;
                        right: 0;
                        height: 90px;
                        background: linear-gradient(to top, #181818, #282828);
                        border-top: 1px solid #282828;
                        display: none;
                        /* Hidden by default */
                        z-index: 1000;
                        box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.3);
                    }

                    .audio-player-bar.active {
                        display: flex;
                        align-items: center;
                        padding: 0 16px;
                        gap: 16px;
                    }

                    .player-song-info {
                        display: flex;
                        align-items: center;
                        gap: 12px;
                        flex: 0 0 300px;
                    }

                    .player-song-cover {
                        width: 56px;
                        height: 56px;
                        border-radius: 4px;
                        object-fit: cover;
                    }

                    .player-song-details {
                        flex: 1;
                        min-width: 0;
                    }

                    .player-song-title {
                        font-size: 14px;
                        font-weight: 600;
                        color: white;
                        margin-bottom: 4px;
                        white-space: nowrap;
                        overflow: hidden;
                        text-overflow: ellipsis;
                    }

                    .player-song-artist {
                        font-size: 12px;
                        color: #b3b3b3;
                        white-space: nowrap;
                        overflow: hidden;
                        text-overflow: ellipsis;
                    }

                    .player-controls-center {
                        flex: 1;
                        display: flex;
                        flex-direction: column;
                        gap: 8px;
                        max-width: 600px;
                        margin-left: 180px;
                    }

                    .player-buttons {
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        gap: 16px;
                    }

                    .player-btn {
                        background: none;
                        border: none;
                        color: #b3b3b3;
                        cursor: pointer;
                        transition: all 0.2s;
                        font-size: 18px;
                        padding: 8px;
                    }

                    .player-btn:hover {
                        color: white;
                        transform: scale(1.1);
                    }

                    .player-btn-play {
                        background: white;
                        color: black;
                        border-radius: 50%;
                        width: 40px;
                        height: 40px;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-size: 16px;
                    }

                    .player-btn-play:hover {
                        transform: scale(1.06);
                        background: #1db954;
                        color: white;
                    }

                    .player-progress-container {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        width: 100%;
                    }

                    .player-time {
                        font-size: 11px;
                        color: #b3b3b3;
                        min-width: 40px;
                    }

                    .player-progress-bar {
                        flex: 1;
                        height: 4px;
                        background: #4d4d4d;
                        border-radius: 2px;
                        cursor: pointer;
                        position: relative;
                    }

                    .player-progress-fill {
                        height: 100%;
                        background: #1db954;
                        border-radius: 2px;
                        transition: width 0.1s linear;
                        position: relative;
                    }

                    .player-progress-fill::after {
                        content: '';
                        position: absolute;
                        right: 0;
                        top: 50%;
                        transform: translateY(-50%);
                        width: 12px;
                        height: 12px;
                        background: white;
                        border-radius: 50%;
                        opacity: 0;
                        transition: opacity 0.2s;
                    }

                    .player-progress-bar:hover .player-progress-fill::after {
                        opacity: 1;
                    }

                    .player-progress-bar:hover .player-progress-fill {
                        background: #1ed760;
                    }


                    /* Add padding to container when player is active */
                    body.player-active .playlist-container {
                        padding-bottom: 100px;
                    }
                </style>
            </head>

            <body>
                <div class="playlist-container">
                    <div class="back-button-container">
                        <a class="btn btn-outline-light back-btn" href="${pageContext.request.contextPath}/home">
                            <i class="fas fa-home"></i>
                        </a>
                        <button class="btn btn-outline-light back-btn" onclick="goBack()">
                            <i class="fas fa-arrow-left"></i> Back to Library
                        </button>
                    </div>

                    <!-- Playlist Header -->
                    <div class="playlist-header">
                        <div class="playlist-cover-section">
                            <!-- Main Cover Display -->
                            <div class="playlist-cover-container" id="mainCoverContainer"
                                onclick="document.getElementById('coverImageInput').click()"
                                style="display: ${not empty playlist.coverImage ? 'block' : 'none'};">
                                <img src="${pageContext.request.contextPath}${playlist.coverImage}"
                                    alt="${playlist.name}" class="playlist-cover-image" id="currentCoverImage"
                                    onerror="this.src='${pageContext.request.contextPath}/assets/img/default-playlist.png'">
                                <div class="playlist-cover-overlay">
                                    <button type="button" class="change-photo-btn">
                                        <i class="fas fa-camera"></i>
                                        <span>Change Photo</span>
                                    </button>
                                </div>
                            </div>

                            <!-- Placeholder (when no image) -->
                            <div class="playlist-cover-container" id="placeholderContainer"
                                onclick="document.getElementById('coverImageInput').click()"
                                style="display: ${empty playlist.coverImage ? 'block' : 'none'};">
                                <div class="playlist-cover-placeholder">
                                    <i class="fas fa-image"
                                        style="font-size: 48px; margin-bottom: 12px; color: #b3b3b3;"></i>
                                    <span class="choose-photo-text" style="color: #b3b3b3; font-size: 14px;">Choose
                                        photo</span>
                                </div>
                            </div>

                            <!-- Form để submit file ảnh -->
                            <form id="coverImageForm" method="post" action="${pageContext.request.contextPath}/playlist"
                                enctype="multipart/form-data" style="display: none;">
                                <input type="hidden" name="action" value="updateCover">
                                <input type="hidden" name="playlistId" value="${playlist.id}">
                                <input type="file" id="coverImageInput" name="coverImage" accept="image/*"
                                    onchange="handleCoverImageUpload(event)">
                            </form>

                            <!-- Preview when selecting new image -->
                            <div class="cover-preview" id="coverPreview" style="display: none;">
                                <img id="previewImage" src="" alt="Cover Preview">
                                <button type="button" class="btn-remove-cover" onclick="removeCoverImage()">
                                    <i class="fas fa-times"></i>
                                </button>
                                <button type="button" class="btn-save-cover" onclick="saveCoverImage()">
                                    <i class="fas fa-save"></i>
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
                    <div class="playlist-description">
                        <h3>Description</h3>
                        <p>${playlist.description}</p>
                    </div>
                    <!-- Playlist Actions -->
                    <div class="playlist-actions">
                        <div class="action-buttons">
                            <button id="addSongsBtn"
                                style="background-color: #121212; border: none; color: white; padding: 8px; border-radius: 100px; transition: all 0.2s ease; font-size: 16px;">
                                <i class="fas fa-plus"></i>
                                <span>Add Songs</span>
                            </button>
                        </div>
                    </div>

                    <!-- Add Songs Section -->
                    <div class="add-songs-section">
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


                    // ========== AUDIO PLAYER FUNCTIONALITY ==========

                    // Playlist songs data from JSP
                    const playlistSongs = [
                        <c:forEach var="playlistSong" items="${playlist.playlistSongs}" varStatus="status">
                            {
                                id: ${playlistSong.song.id},
                            title: `${playlistSong.song.title}`,
                            artist: `<c:forEach var="songArtist" items="${playlistSong.song.songArtists}" varStatus="artistStatus"><c:if test="${!artistStatus.first}">, </c:if>${songArtist.artist.name}</c:forEach>`,
                            coverImage: `${pageContext.request.contextPath}${playlistSong.song.coverImage}`,
                            filePath: `${pageContext.request.contextPath}${playlistSong.song.filePath}`,
                            duration: ${playlistSong.song.duration}
            }<c:if test="${!status.last}">,</c:if>
                        </c:forEach>
                    ];

                    // Audio player elements
                    let audioElement = null;
                    let playerBar = null;
                    let playerPlayBtn = null;
                    let playerPlayIcon = null;
                    let playerProgressBar = null;
                    let playerProgressFill = null;
                    let playerCurrentTime = null;
                    let playerDuration = null;
                    let playerCover = null;
                    let playerTitle = null;
                    let playerArtist = null;
                    let playerNextBtn = null;
                    let playerPrevBtn = null;

                    // Player state
                    let currentSongIndex = -1;
                    let isPlaying = false;

                    // Initialize audio player
                    document.addEventListener('DOMContentLoaded', function () {
                        initializeAudioPlayer();
                    });

                    function initializeAudioPlayer() {
                        // Get elements
                        audioElement = document.getElementById('audioElement');
                        playerBar = document.getElementById('audioPlayerBar');
                        playerPlayBtn = document.getElementById('playerPlayBtn');
                        playerPlayIcon = document.getElementById('playerPlayIcon');
                        playerProgressBar = document.getElementById('playerProgressBar');
                        playerProgressFill = document.getElementById('playerProgressFill');
                        playerCurrentTime = document.getElementById('playerCurrentTime');
                        playerDuration = document.getElementById('playerDuration');
                        playerCover = document.getElementById('playerCover');
                        playerTitle = document.getElementById('playerTitle');
                        playerArtist = document.getElementById('playerArtist');
                        playerNextBtn = document.getElementById('playerNextBtn');
                        playerPrevBtn = document.getElementById('playerPrevBtn');

                        // Add event listeners
                        if (playerPlayBtn) {
                            playerPlayBtn.addEventListener('click', togglePlay);
                        }

                        if (playerNextBtn) {
                            playerNextBtn.addEventListener('click', playNextSong);
                        }

                        if (playerPrevBtn) {
                            playerPrevBtn.addEventListener('click', playPreviousSong);
                        }

                        if (playerProgressBar) {
                            playerProgressBar.addEventListener('click', seek);
                        }


                        if (audioElement) {
                            audioElement.addEventListener('timeupdate', updateProgress);
                            audioElement.addEventListener('loadedmetadata', updateDuration);
                            audioElement.addEventListener('ended', onSongEnded);
                            audioElement.addEventListener('play', function () {
                                isPlaying = true;
                                updatePlayButton();
                            });
                            audioElement.addEventListener('pause', function () {
                                isPlaying = false;
                                updatePlayButton();
                            });
                        }
                    }

                    /**
                     * Play song functionality - Updated to use audio player
                     */
                    function playSong(songId) {
                        const index = playlistSongs.findIndex(song => song.id === songId);
                        if (index === -1) return;

                        loadAndPlaySong(index);
                    }

                    function loadAndPlaySong(index) {
                        if (index < 0 || index >= playlistSongs.length) return;

                        currentSongIndex = index;
                        const song = playlistSongs[index];

                        // Update UI
                        playerCover.src = song.coverImage;
                        playerTitle.textContent = song.title;
                        playerArtist.textContent = song.artist;

                        // Load and play audio
                        audioElement.src = song.filePath;
                        audioElement.load();
                        audioElement.play().then(() => {
                            // Show player bar
                            playerBar.classList.add('active');
                            document.body.classList.add('player-active');
                        }).catch(error => {
                            console.error('Error playing audio:', error);
                        });
                    }

                    function togglePlay() {
                        if (!audioElement.src) {
                            // No song loaded, play first song
                            if (playlistSongs.length > 0) {
                                loadAndPlaySong(0);
                            }
                            return;
                        }

                        if (isPlaying) {
                            audioElement.pause();
                        } else {
                            audioElement.play();
                        }
                    }

                    function updatePlayButton() {
                        if (isPlaying) {
                            playerPlayIcon.className = 'fas fa-pause';
                        } else {
                            playerPlayIcon.className = 'fas fa-play';
                        }
                    }

                    function playNextSong() {
                        if (playlistSongs.length === 0) return;

                        // Random next song (excluding current)
                        let nextIndex;
                        if (playlistSongs.length === 1) {
                            nextIndex = 0; // Only one song, replay it
                        } else {
                            do {
                                nextIndex = Math.floor(Math.random() * playlistSongs.length);
                            } while (nextIndex === currentSongIndex);
                        }

                        loadAndPlaySong(nextIndex);
                    }

                    function playPreviousSong() {
                        if (currentSongIndex > 0) {
                            loadAndPlaySong(currentSongIndex - 1);
                        } else {
                            loadAndPlaySong(playlistSongs.length - 1);
                        }
                    }

                    function onSongEnded() {
                        // Auto-play next random song
                        playNextSong();
                    }

                    function updateProgress() {
                        if (!audioElement.duration) return;

                        const percent = (audioElement.currentTime / audioElement.duration) * 100;
                        playerProgressFill.style.width = percent + '%';

                        // Update current time display
                        const minutes = Math.floor(audioElement.currentTime / 60);
                        const seconds = Math.floor(audioElement.currentTime % 60);
                        playerCurrentTime.textContent = minutes + ':' + (seconds < 10 ? '0' : '') + seconds;
                    }

                    function updateDuration() {
                        if (!audioElement.duration) return;

                        const minutes = Math.floor(audioElement.duration / 60);
                        const seconds = Math.floor(audioElement.duration % 60);
                        playerDuration.textContent = minutes + ':' + (seconds < 10 ? '0' : '') + seconds;
                    }

                    function seek(e) {
                        if (!audioElement.duration) return;

                        const rect = playerProgressBar.getBoundingClientRect();
                        const percent = (e.clientX - rect.left) / rect.width;
                        audioElement.currentTime = percent * audioElement.duration;
                    }


                    function formatTime(seconds) {
                        const mins = Math.floor(seconds / 60);
                        const secs = Math.floor(seconds % 60);
                        return mins + ':' + (secs < 10 ? '0' : '') + secs;
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
                                        <input type="text" class="form-control" id="modalSongSearchInput"
                                            placeholder="Search for songs..." onkeyup="filterSongsInModal()">
                                        <button class="btn btn-primary" onclick="filterSongsInModal()">
                                            <i class="fas fa-search"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="songs-list" id="availableSongsList">
                                    <!-- Render songs using JSTL forEach -->
                                    <c:forEach var="song" items="${allSongs}">
                                        <c:set var="isInPlaylist" value="false" />
                                        <c:forEach var="playlistSong" items="${playlist.playlistSongs}">
                                            <c:if test="${playlistSong.song.id == song.id}">
                                                <c:set var="isInPlaylist" value="true" />
                                            </c:if>
                                        </c:forEach>

                                        <c:if test="${!isInPlaylist}">
                                            <div class="song-item modal-song-item" data-song-id="${song.id}"
                                                data-song-title="${song.title}"
                                                data-artist-name="<c:forEach var='songArtist' items='${song.songArtists}' varStatus='artistStatus'><c:if test='${!artistStatus.first}'>, </c:if>${songArtist.artist.name}</c:forEach>">
                                                <img src="${pageContext.request.contextPath}${song.coverImage}"
                                                    alt="${song.title}"
                                                    style="width: 50px; height: 50px; border-radius: 4px; margin-right: 12px; object-fit: cover;"
                                                    onerror="this.src='${pageContext.request.contextPath}/assets/img/default-song.png'">
                                                <div class="song-info">
                                                    <div class="song-title">${song.title}</div>
                                                    <div class="song-artist">
                                                        <c:forEach var="songArtist" items="${song.songArtists}"
                                                            varStatus="artistStatus">
                                                            <c:if test="${!artistStatus.first}">, </c:if>
                                                            ${songArtist.artist.name}
                                                        </c:forEach>
                                                    </div>
                                                </div>
                                                <div style="margin-right: 12px; color: #b3b3b3;">
                                                    <fmt:formatNumber value="${song.duration / 60}" pattern="#,##0" />:
                                                    <fmt:formatNumber value="${song.duration % 60}" pattern="00" />
                                                </div>
                                                <button class="btn btn-sm btn-outline-success"
                                                    onclick="toggleSongSelection(this, ${song.id})">
                                                    Add
                                                </button>
                                            </div>
                                        </c:if>
                                    </c:forEach>
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

                <!-- Audio Player Bar -->
                <div class="audio-player-bar" id="audioPlayerBar">
                    <!-- Song Info -->
                    <div class="player-song-info">
                        <img src="" alt="Song Cover" class="player-song-cover" id="playerCover">
                        <div class="player-song-details">
                            <div class="player-song-title" id="playerTitle">No song playing</div>
                            <div class="player-song-artist" id="playerArtist">-</div>
                        </div>
                    </div>

                    <!-- Player Controls -->
                    <div class="player-controls-center">
                        <div class="player-buttons">
                            <button class="player-btn" id="playerPrevBtn" title="Previous">
                                <i class="fas fa-step-backward"></i>
                            </button>
                            <button class="player-btn player-btn-play" id="playerPlayBtn" title="Play/Pause">
                                <i class="fas fa-play" id="playerPlayIcon"></i>
                            </button>
                            <button class="player-btn" id="playerNextBtn" title="Next">
                                <i class="fas fa-step-forward"></i>
                            </button>
                        </div>
                        <div class="player-progress-container">
                            <span class="player-time" id="playerCurrentTime">0:00</span>
                            <div class="player-progress-bar" id="playerProgressBar">
                                <div class="player-progress-fill" id="playerProgressFill"></div>
                            </div>
                            <span class="player-time" id="playerDuration">0:00</span>
                        </div>
                    </div>


                    <!-- Hidden Audio Element -->
                    <audio id="audioElement" preload="metadata"></audio>
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
                            // Validation
                            const maxSize = 5 * 1024 * 1024; // 5MB
                            const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];

                            if (file.size > maxSize) {
                                alert('Image size must be less than 5MB');
                                event.target.value = '';
                                return;
                            }

                            if (!allowedTypes.includes(file.type) && !file.name.match(/\.(jpg|jpeg|png|gif)$/i)) {
                                alert('Please select a valid image file (JPG, PNG, GIF)');
                                event.target.value = '';
                                return;
                            }

                            const reader = new FileReader();
                            reader.onload = function (e) {
                                // Get elements
                                const preview = document.getElementById('coverPreview');
                                const previewImage = document.getElementById('previewImage');
                                const mainContainer = document.getElementById('mainCoverContainer');
                                const placeholderContainer = document.getElementById('placeholderContainer');

                                // Set preview image
                                previewImage.src = e.target.result;

                                // Hide main containers and show preview
                                if (mainContainer) mainContainer.style.display = 'none';
                                if (placeholderContainer) placeholderContainer.style.display = 'none';
                                preview.style.display = 'block';
                            };
                            reader.readAsDataURL(file);
                        }
                    }

                    function removeCoverImage() {
                        const preview = document.getElementById('coverPreview');
                        const mainContainer = document.getElementById('mainCoverContainer');
                        const placeholderContainer = document.getElementById('placeholderContainer');
                        const input = document.getElementById('coverImageInput');
                        const currentCoverImage = document.getElementById('currentCoverImage');

                        // Hide preview
                        preview.style.display = 'none';

                        // Show appropriate container based on whether playlist has cover
                        if (currentCoverImage && currentCoverImage.src && currentCoverImage.src !== '') {
                            // Has existing cover - show main container
                            if (mainContainer) mainContainer.style.display = 'block';
                            if (placeholderContainer) placeholderContainer.style.display = 'none';
                        } else {
                            // No cover - show placeholder
                            if (mainContainer) mainContainer.style.display = 'none';
                            if (placeholderContainer) placeholderContainer.style.display = 'block';
                        }

                        // Clear file input
                        input.value = '';
                    }

                    function saveCoverImage() {
                        const form = document.getElementById('coverImageForm');
                        const fileInput = document.getElementById('coverImageInput');

                        if (!fileInput.files[0]) {
                            alert('Please select an image first');
                            return;
                        }

                        // Show loading state
                        const saveBtn = document.querySelector('.btn-save-cover');
                        const originalContent = saveBtn.innerHTML;
                        saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
                        saveBtn.disabled = true;

                        // Submit form
                        form.submit();
                    }

                    // Add songs modal functionality
                    document.getElementById('addSongsBtn').addEventListener('click', function () {
                        const modal = new bootstrap.Modal(document.getElementById('addSongsModal'));
                        modal.show();
                        // Reset search when opening modal
                        document.getElementById('modalSongSearchInput').value = '';
                        filterSongsInModal();
                    });

                    // Simple filter function - just show/hide existing elements
                    function filterSongsInModal() {
                        const searchQuery = document.getElementById('modalSongSearchInput').value.toLowerCase();
                        const songItems = document.querySelectorAll('.modal-song-item');
                        let visibleCount = 0;

                        songItems.forEach(item => {
                            const title = item.getAttribute('data-song-title').toLowerCase();
                            const artist = item.getAttribute('data-artist-name').toLowerCase();

                            // Show if matches search or no search query
                            if (!searchQuery || title.includes(searchQuery) || artist.includes(searchQuery)) {
                                item.style.display = 'flex';
                                visibleCount++;
                            } else {
                                item.style.display = 'none';
                            }
                        });

                        // Show "no results" message if needed
                        const songsList = document.getElementById('availableSongsList');
                        let noResultsDiv = document.getElementById('noResultsMessage');

                        if (visibleCount === 0) {
                            if (!noResultsDiv) {
                                noResultsDiv = document.createElement('div');
                                noResultsDiv.id = 'noResultsMessage';
                                noResultsDiv.style.cssText = 'text-align: center; padding: 40px; color: #b3b3b3;';
                                noResultsDiv.innerHTML = `
                                    <i class="fas fa-search" style="font-size: 48px; margin-bottom: 16px;"></i>
                                    <p>No songs found</p>
                                `;
                                songsList.appendChild(noResultsDiv);
                            }
                            noResultsDiv.style.display = 'block';
                        } else {
                            if (noResultsDiv) {
                                noResultsDiv.style.display = 'none';
                            }
                        }
                    }

                    function toggleSongSelection(button, songId) {
                        if (button.classList.contains('btn-success')) {
                            button.classList.remove('btn-success');
                            button.classList.add('btn-outline-success');
                            button.textContent = 'Add';
                            button.closest('.song-item').classList.remove('selected');
                        } else {
                            button.classList.remove('btn-outline-success');
                            button.classList.add('btn-success');
                            button.textContent = 'Added';
                            button.closest('.song-item').classList.add('selected');
                        }
                    }

                    function addSelectedSongs() {
                        const selectedSongs = document.querySelectorAll('.song-item.selected');

                        if (selectedSongs.length === 0) {
                            alert('Please select at least one song to add');
                            return;
                        }

                        // Add songs sequentially
                        let songsToAdd = Array.from(selectedSongs).map(item => item.dataset.songId);

                        // Close modal
                        const modal = bootstrap.Modal.getInstance(document.getElementById('addSongsModal'));
                        modal.hide();

                        // Add first song and reload (server will handle one at a time)
                        addSongToPlaylist(songsToAdd[0]);
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

                </script>
            </body>

</html>