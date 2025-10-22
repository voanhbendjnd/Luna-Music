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
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/playlist-detail.css">

            </head>
            <%@include file="/views/components/header.jsp" %>

                <body>
                    <div class="playlist-container">
                        <div class="back-button-container">
                            <a class="btn btn-outline-light back-btn" href="${pageContext.request.contextPath}/home">
                                <i class="fas fa-arrow-left"></i>
                            </a>
                        </div>

                        <!-- Playlist Header -->
                        <div class="playlist-header" style="margin-top: 20px;">
                            <div class="playlist-info-section">
                                <div class="playlist-type">My Playlist</div>
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
                                        <c:forEach var="playlistSong" items="${playlist.playlistSongs}"
                                            varStatus="status">
                                            <div class="song-item" onclick="playSong(${playlistSong.song.id})">
                                                <div class="song-number">${status.index + 1}</div>
                                                <c:if test="${not empty playlistSong.song.coverImage}">

                                                    <img src="${pageContext.request.contextPath}${playlistSong.song.coverImage}"
                                                        alt="${playlistSong.song.title}" class="song-cover">
                                                </c:if>
                                                <c:if test="${empty playlistSong.song.coverImage}">
                                                    <i class="fas fa-music"></i>

                                                </c:if>

                                                <div class="song-info">
                                                    <div class="song-title">${playlistSong.song.title}</div>
                                                    <div class="song-artist">
                                                        <c:forEach var="songArtist"
                                                            items="${playlistSong.song.songArtists}"
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
                    <!-- Bottom Player Bar -->
                    <div class="bottom-player-bar" style="background-color: #000000;">
                        <div class="player-content">
                            <div class="bottom-song-info">
                                <img id="bottomCover" src="" alt="Cover" class="bottom-cover"
                                    onerror="this.src='${pageContext.request.contextPath}/assets/img/LogoFinal1.png'"
                                    style="width: 50px; height: 50px; border-radius: 5px;">
                                <div class="song-meta">
                                    <div id="bottomSongTitle" class="bottom-title" style="color:white;">Song
                                    </div>
                                    <div id="bottomSongArtist" class="bottom-artist" style="color:gray;">Artist</div>
                                </div>
                            </div>
                            <!-- Progress Bar -->
                            <div class="progress-container">
                                <div class="progress-bar">
                                    <div class="progress-fill" id="progressFill"></div>
                                </div>
                            </div>

                            <!-- Main Controls -->
                            <div class="main-controls">
                                <button class="control-btn shuffle-btn">
                                    <a id="nextBtnShuffle">
                                        <i class="fas fa-random"></i>
                                    </a>
                                </button>
                                <button class="control-btn prev-btn">
                                    <a id="prevBtn">
                                        <i class="fas fa-step-backward"></i>
                                    </a>
                                </button>
                                <button class="control-btn main-play-btn" id="bottomPlayBtn">
                                    <i class="fas fa-play"></i>
                                </button>
                                <button class="control-btn next-btn">
                                    <a id="nextBtn">
                                        <i class="fas fa-step-forward"></i>
                                    </a>
                                </button>
                                <button class="control-btn repeat-btn">
                                    <a href="${pageContext.request.contextPath}/song-detail?id=${song.id}"
                                        style="color: white;">
                                        <i class="fas fa-redo"></i>
                                    </a>
                                </button>
                            </div>
                        </div>
                    </div>
                    <!-- Audio Player -->
                    <audio id="audioPlayer" preload="metadata">
                    </audio>
                    <%@include file="/views/components/footer.jsp" %>
                        <script>
                            document.addEventListener("DOMContentLoaded", function () {
                                const currentContextPath = "${pageContext.request.contextPath}";
                                const playlistId = ${ playlist.id };

                                // === DỮ LIỆU DANH SÁCH BÀI HÁT ===
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

                                // === KHAI BÁO BIẾN TOÀN CỤC ===
                                const audioPlayer = document.getElementById("audioPlayer");
                                const bottomCover = document.getElementById("bottomCover");
                                const bottomSongTitle = document.getElementById("bottomSongTitle");
                                const bottomSongArtist = document.getElementById("bottomSongArtist");
                                const bottomPlayBtn = document.getElementById("bottomPlayBtn");
                                const progressFill = document.getElementById("progressFill");
                                const currentTimeSpan = document.getElementById("currentTime");
                                const totalTimeSpan = document.getElementById("totalTime"); // Nhớ thêm id="totalTime" trong HTML

                                let currentSongIndex = -1;
                                let isPlaying = false;

                                // === HÀM PHÁT BÀI HÁT ===
                                function playSongByIndex(index) {
                                    if (index < 0 || index >= playlistSongs.length) return;

                                    const song = playlistSongs[index];
                                    currentSongIndex = index;

                                    audioPlayer.src = song.filePath;
                                    audioPlayer.load();
                                    audioPlayer.play()
                                        .then(() => {
                                            isPlaying = true;
                                            bottomPlayBtn.innerHTML = '<i class="fas fa-pause"></i>';
                                        })
                                        .catch(err => console.error("Error playing song:", err));

                                    // Cập nhật UI
                                    bottomCover.src = song.coverImage;
                                    bottomSongTitle.textContent = song.title;
                                    bottomSongArtist.textContent = song.artist;
                                }

                                // === GÁN HÀM GỌI TỪ HTML ===
                                window.playSong = function (songID) {
                                    const index = playlistSongs.findIndex(song => song.id === songID);
                                    if (index === -1) return;
                                    playSongByIndex(index);
                                };

                                // === NÚT PLAY/PAUSE Ở DƯỚI ===
                                bottomPlayBtn.addEventListener("click", function () {
                                    if (currentSongIndex === -1) return; // chưa chọn bài hát nào

                                    if (audioPlayer.paused) {
                                        audioPlayer.play();
                                        bottomPlayBtn.innerHTML = '<i class="fas fa-pause"></i>';
                                    } else {
                                        audioPlayer.pause();
                                        bottomPlayBtn.innerHTML = '<i class="fas fa-play"></i>';
                                    }
                                });

                                // === CẬP NHẬT THANH TIẾN TRÌNH ===
                                audioPlayer.addEventListener("timeupdate", function () {
                                    if (audioPlayer.duration) {
                                        const progress = (audioPlayer.currentTime / audioPlayer.duration) * 100;
                                        progressFill.style.width = progress + "%";
                                    }
                                });

                                // === TỰ ĐỘNG PHÁT BÀI TIẾP THEO ===
                                audioPlayer.addEventListener("ended", function () {
                                    if (currentSongIndex + 1 < playlistSongs.length) {
                                        playSongByIndex(currentSongIndex + 1);
                                    } else {
                                        // Hết playlist
                                        isPlaying = false;
                                        bottomPlayBtn.innerHTML = '<i class="fas fa-play"></i>';
                                    }
                                });
                            });
                        </script>


                </body>