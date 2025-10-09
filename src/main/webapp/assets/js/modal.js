// Modal Management
class ModalManager {
  constructor() {
    this.currentModal = null;
    this.audioPlayer = null;
    this.currentSong = null;
    this.isPlaying = false;
    this.currentTime = 0;
    this.duration = 0;
  }

  // Show modal overlay
  showModal(content) {
    const overlay = document.createElement("div");
    overlay.className = "modal-overlay";
    overlay.innerHTML = content;

    document.body.appendChild(overlay);
    this.currentModal = overlay;

    // Add close functionality
    const closeBtn = overlay.querySelector(".modal-close");
    if (closeBtn) {
      closeBtn.addEventListener("click", () => this.hideModal());
    }

    // Close on overlay click
    overlay.addEventListener("click", (e) => {
      if (e.target === overlay) {
        this.hideModal();
      }
    });

    // Prevent body scroll
    document.body.style.overflow = "hidden";
  }

  // Hide modal
  hideModal() {
    if (this.currentModal) {
      document.body.removeChild(this.currentModal);
      this.currentModal = null;
      document.body.style.overflow = "";
    }
  }

  // Show song detail modal
  showSongDetailModal(song) {
    this.currentSong = song;
    const content = `
            <div class="modal-content song-detail-modal">
                <button class="modal-close">&times;</button>
                <div class="song-detail-header">
                    <div class="song-detail-album-art">
                        ${
                          song.coverImage
                            ? `<img src="${song.coverImage}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 12px;" alt="${song.title}">`
                            : "🎵"
                        }
                    </div>
                    <div class="song-detail-info">
                        <div class="song-detail-label">Song</div>
                        <div class="song-detail-title">${song.title}</div>
                        <div class="song-detail-artist">
                            <div class="song-detail-artist-image">
                                ${
                                  song.songArtists &&
                                  song.songArtists.length > 0 &&
                                  song.songArtists[0].artist.imagePath
                                    ? `<img src="${song.songArtists[0].artist.imagePath}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;" alt="${song.songArtists[0].artist.name}">`
                                    : "👤"
                                }
                            </div>
                            <div class="song-detail-artist-name">
                                ${
                                  song.songArtists &&
                                  song.songArtists.length > 0
                                    ? song.songArtists[0].artist.name
                                    : "Unknown Artist"
                                }
                            </div>
                        </div>
                        <div class="song-detail-meta">
                            ${
                              song.songArtists && song.songArtists.length > 0
                                ? song.songArtists[0].artist.name
                                : "Unknown Artist"
                            } - 
                            ${
                              song.album ? song.album.title : "Unknown Album"
                            } - 
                            ${
                              song.album && song.album.releaseYear
                                ? song.album.releaseYear
                                : "Unknown Year"
                            } - 
                            ${
                              song.duration
                                ? this.formatDuration(song.duration)
                                : "0:00"
                            } - 
                            ${
                              song.playCount
                                ? song.playCount.toLocaleString()
                                : "0"
                            }
                        </div>
                        <div class="song-detail-controls">
                            <button class="song-detail-play-btn" onclick="modalManager.playSong(${
                              song.id
                            })">
                                <i class="fas fa-play"></i>
                            </button>
                            <button class="song-detail-action-btn" onclick="modalManager.addToQueue(${
                              song.id
                            })">
                                <i class="fas fa-plus"></i>
                            </button>
                            <button class="song-detail-action-btn" onclick="modalManager.downloadSong(${
                              song.id
                            })">
                                <i class="fas fa-download"></i>
                            </button>
                            <button class="song-detail-action-btn" onclick="modalManager.showMoreOptions(${
                              song.id
                            })">
                                <i class="fas fa-ellipsis-h"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="song-detail-body">
                    <div class="song-detail-left">
                        <div class="lyrics-section">
                            <div class="lyrics-title">Lyrics</div>
                            <div class="lyrics-content">
                                ${
                                  song.lyric ||
                                  "No lyrics available for this song."
                                }
                            </div>
                            ${
                              song.lyric && song.lyric.length > 200
                                ? '<div class="lyrics-show-more" onclick="modalManager.showMoreLyrics()">...Show more</div>'
                                : ""
                            }
                        </div>
                    </div>
                    <div class="song-detail-right">
                        <div class="artist-info">
                            <div class="artist-info-image">
                                ${
                                  song.songArtists &&
                                  song.songArtists.length > 0 &&
                                  song.songArtists[0].artist.imagePath
                                    ? `<img src="${song.songArtists[0].artist.imagePath}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;" alt="${song.songArtists[0].artist.name}">`
                                    : "👤"
                                }
                            </div>
                            <div class="artist-info-label">Artist</div>
                            <div class="artist-info-name">
                                ${
                                  song.songArtists &&
                                  song.songArtists.length > 0
                                    ? song.songArtists[0].artist.name
                                    : "Unknown Artist"
                                }
                            </div>
                        </div>
                        <div class="recommended-section">
                            <div class="recommended-title">Recommended</div>
                            <div class="recommended-subtitle">Based on this song</div>
                            <div class="recommended-song" onclick="modalManager.openSongDetail(1)">
                                <div class="recommended-song-image">🎵</div>
                                <div class="recommended-song-info">
                                    <div class="recommended-song-title">Recommended Song</div>
                                    <div class="recommended-song-artist">Artist Name</div>
                                </div>
                                <div class="recommended-song-meta">405,331,400 • 2:26</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;
    this.showModal(content);
  }

  // Show artist detail modal
  showArtistDetailModal(artist) {
    const content = `
            <div class="modal-content artist-detail-modal">
                <button class="modal-close">&times;</button>
                <div class="artist-detail-header">
                    <div class="artist-detail-image">
                        ${
                          artist.imagePath
                            ? `<img src="${artist.imagePath}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;" alt="${artist.name}">`
                            : "👤"
                        }
                    </div>
                    <div class="artist-detail-info">
                        <div class="artist-detail-verified">
                            <div class="artist-detail-verified-icon">✓</div>
                            <div class="artist-detail-verified-text">Verified Artist</div>
                        </div>
                        <div class="artist-detail-name">${artist.name}</div>
                        <div class="artist-detail-listeners">2,038,027 monthly listeners</div>
                        <div class="artist-detail-controls">
                            <button class="artist-detail-play-btn" onclick="modalManager.playArtistSongs(${
                              artist.id
                            })">
                                <i class="fas fa-play"></i>
                            </button>
                            <button class="artist-detail-follow-btn" onclick="modalManager.followArtist(${
                              artist.id
                            })">
                                Follow
                            </button>
                            <button class="artist-detail-more-btn" onclick="modalManager.showMoreOptions(${
                              artist.id
                            })">
                                <i class="fas fa-ellipsis-h"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="artist-detail-body">
                    <div class="artist-detail-left">
                        <div class="popular-songs-section">
                            <div class="popular-songs-title">Popular</div>
                            <div id="artist-songs-list">
                                <!-- Songs will be loaded here -->
                            </div>
                            <div style="margin-top: 16px;">
                                <a href="#" style="color: white; text-decoration: none;">See more</a>
                            </div>
                        </div>
                    </div>
                    <div class="artist-detail-right">
                        <div class="artist-pick-section">
                            <div class="artist-pick-title">Artist pick</div>
                            <div class="artist-pick-item" onclick="modalManager.openSongDetail(1)">
                                <div class="artist-pick-image">🎵</div>
                                <div class="artist-pick-info">
                                    <div class="artist-pick-posted-by">
                                        <div class="artist-pick-profile">👤</div>
                                        <div class="artist-pick-posted-text">Posted By ${
                                          artist.name
                                        }</div>
                                    </div>
                                    <div class="artist-pick-title">Popular Song</div>
                                    <div class="artist-pick-type">Single</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;
    this.showModal(content);

    // Load artist songs
    this.loadArtistSongs(artist.id);
  }

  // Show album detail modal
  showAlbumDetailModal(album) {
    const content = `
            <div class="modal-content album-detail-modal">
                <button class="modal-close">&times;</button>
                <div class="album-detail-header">
                    <div class="album-detail-image">
                        ${
                          album.coverImagePath
                            ? `<img src="${album.coverImagePath}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 12px;" alt="${album.title}">`
                            : "💿"
                        }
                    </div>
                    <div class="album-detail-info">
                        <div class="album-detail-type">Album</div>
                        <div class="album-detail-title">${album.title}</div>
                        <div class="album-detail-artist">
                            <div class="album-detail-artist-image">
                                ${
                                  album.artist && album.artist.imagePath
                                    ? `<img src="${album.artist.imagePath}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;" alt="${album.artist.name}">`
                                    : "👤"
                                }
                            </div>
                            <div class="album-detail-artist-name">
                                ${
                                  album.artist
                                    ? album.artist.name
                                    : "Unknown Artist"
                                }
                            </div>
                        </div>
                        <div class="album-detail-meta">
                            ${album.releaseYear || "Unknown Year"} • ${
      album.songCount || 0
    } songs, ${album.totalDuration || "0 min 0 sec"}
                        </div>
                        <div class="album-detail-controls">
                            <button class="album-detail-play-btn" onclick="modalManager.playAlbumSongs(${
                              album.id
                            })">
                                <i class="fas fa-play"></i>
                            </button>
                            <button class="album-detail-action-btn" onclick="modalManager.addAlbumToQueue(${
                              album.id
                            })">
                                <i class="fas fa-plus"></i>
                            </button>
                            <button class="album-detail-action-btn" onclick="modalManager.showMoreOptions(${
                              album.id
                            })">
                                <i class="fas fa-ellipsis-h"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="album-detail-body">
                    <div class="tracklist-section">
                        <div class="tracklist-header">
                            <div class="tracklist-header-number">#</div>
                            <div class="tracklist-header-title">Title</div>
                            <div class="tracklist-header-duration">
                                <i class="fas fa-clock"></i>
                            </div>
                        </div>
                        <div id="album-tracks-list">
                            <!-- Tracks will be loaded here -->
                        </div>
                    </div>
                </div>
            </div>
        `;
    this.showModal(content);

    // Load album tracks
    this.loadAlbumTracks(album.id);
  }

  // Show now playing modal
  showNowPlayingModal(song) {
    this.currentSong = song;
    const content = `
            <div class="modal-content now-playing-modal">
                <div class="now-playing-header">
                    <div class="now-playing-nav">
                        <button class="now-playing-back-btn" onclick="modalManager.hideModal()">
                            <i class="fas fa-chevron-down"></i>
                        </button>
                        <div class="now-playing-title">Now Playing</div>
                    </div>
                </div>
                <div class="now-playing-content">
                    <div class="now-playing-left">
                        <div class="now-playing-album-art">
                            ${
                              song.coverImage
                                ? `<img src="${song.coverImage}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 20px;" alt="${song.title}">`
                                : "🎵"
                            }
                        </div>
                        <div class="now-playing-song-info">
                            <div class="now-playing-song-title">${
                              song.title
                            }</div>
                            <div class="now-playing-song-artist">
                                ${
                                  song.songArtists &&
                                  song.songArtists.length > 0
                                    ? song.songArtists[0].artist.name
                                    : "Unknown Artist"
                                }
                            </div>
                        </div>
                        <div class="now-playing-controls">
                            <button class="now-playing-control-btn" onclick="modalManager.shuffleToggle()">
                                <i class="fas fa-random"></i>
                            </button>
                            <button class="now-playing-control-btn" onclick="modalManager.previousSong()">
                                <i class="fas fa-step-backward"></i>
                            </button>
                            <button class="now-playing-play-btn" onclick="modalManager.togglePlayPause()">
                                <i class="fas fa-play" id="play-pause-icon"></i>
                            </button>
                            <button class="now-playing-control-btn" onclick="modalManager.nextSong()">
                                <i class="fas fa-step-forward"></i>
                            </button>
                            <button class="now-playing-control-btn" onclick="modalManager.repeatToggle()">
                                <i class="fas fa-redo"></i>
                            </button>
                        </div>
                        <div class="now-playing-progress">
                            <div class="now-playing-progress-bar" onclick="modalManager.seekTo(event)">
                                <div class="now-playing-progress-fill" id="progress-fill" style="width: 0%"></div>
                            </div>
                            <div class="now-playing-time">
                                <span id="current-time">0:00</span>
                                <span id="total-time">${
                                  song.duration
                                    ? this.formatDuration(song.duration)
                                    : "0:00"
                                }</span>
                            </div>
                        </div>
                    </div>
                    <div class="now-playing-right">
                        <div class="now-playing-lyrics">
                            <div class="now-playing-lyrics-title">Lyrics</div>
                            <div class="now-playing-lyrics-content">
                                ${
                                  song.lyric ||
                                  "No lyrics available for this song."
                                }
                            </div>
                        </div>
                        <div class="now-playing-recommended">
                            <div class="now-playing-recommended-title">Recommended</div>
                            <div class="now-playing-recommended-subtitle">Based on this song</div>
                            <div class="recommended-song" onclick="modalManager.openSongDetail(1)">
                                <div class="recommended-song-image">🎵</div>
                                <div class="recommended-song-info">
                                    <div class="recommended-song-title">Recommended Song</div>
                                    <div class="recommended-song-artist">Artist Name</div>
                                </div>
                                <div class="recommended-song-meta">405,331,400 • 2:26</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="now-playing-bottom-bar">
                    <div class="now-playing-bottom-info">
                        <div class="now-playing-bottom-image">
                            ${
                              song.coverImage
                                ? `<img src="${song.coverImage}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 8px;" alt="${song.title}">`
                                : "🎵"
                            }
                        </div>
                        <div class="now-playing-bottom-details">
                            <div class="now-playing-bottom-title">${
                              song.title
                            }</div>
                            <div class="now-playing-bottom-artist">
                                ${
                                  song.songArtists &&
                                  song.songArtists.length > 0
                                    ? song.songArtists[0].artist.name
                                    : "Unknown Artist"
                                }
                            </div>
                        </div>
                    </div>
                    <div class="now-playing-bottom-controls">
                        <button class="now-playing-control-btn" onclick="modalManager.togglePlayPause()">
                            <i class="fas fa-play" id="bottom-play-pause-icon"></i>
                        </button>
                        <button class="now-playing-control-btn" onclick="modalManager.previousSong()">
                            <i class="fas fa-step-backward"></i>
                        </button>
                        <button class="now-playing-control-btn" onclick="modalManager.nextSong()">
                            <i class="fas fa-step-forward"></i>
                        </button>
                    </div>
                    <div class="now-playing-bottom-progress">
                        <div class="now-playing-bottom-progress-bar" onclick="modalManager.seekTo(event)">
                            <div class="now-playing-bottom-progress-fill" id="bottom-progress-fill" style="width: 0%"></div>
                        </div>
                    </div>
                    <div class="now-playing-bottom-time" id="bottom-current-time">0:00</div>
                    <div class="now-playing-bottom-actions">
                        <button class="now-playing-bottom-action-btn" onclick="modalManager.shuffleToggle()">
                            <i class="fas fa-random"></i>
                        </button>
                        <button class="now-playing-bottom-action-btn" onclick="modalManager.repeatToggle()">
                            <i class="fas fa-redo"></i>
                        </button>
                        <button class="now-playing-bottom-action-btn" onclick="modalManager.showQueue()">
                            <i class="fas fa-list"></i>
                        </button>
                    </div>
                </div>
            </div>
        `;
    this.showModal(content);

    // Initialize audio player
    this.initializeAudioPlayer(song);
  }

  // Load artist songs
  async loadArtistSongs(artistId) {
    try {
      const response = await fetch(`/LunaMusic/api/artist/${artistId}/songs`);
      const songs = await response.json();

      const songsList = document.getElementById("artist-songs-list");
      if (songsList) {
        songsList.innerHTML = songs
          .slice(0, 5)
          .map(
            (song, index) => `
                    <div class="popular-song-item" onclick="modalManager.openSongDetail(${
                      song.id
                    })">
                        <div class="popular-song-number">${index + 1}</div>
                        <div class="popular-song-image">
                            ${
                              song.coverImage
                                ? `<img src="${song.coverImage}" style="width: 100%; height: 100%; object-fit: cover; border-radius: 8px;" alt="${song.title}">`
                                : "🎵"
                            }
                        </div>
                        <div class="popular-song-info">
                            <div class="popular-song-title">${song.title}</div>
                            <div class="popular-song-play-count">${
                              song.playCount
                                ? song.playCount.toLocaleString()
                                : "0"
                            } plays</div>
                        </div>
                        <div class="popular-song-duration">${
                          song.duration
                            ? this.formatDuration(song.duration)
                            : "0:00"
                        }</div>
                    </div>
                `
          )
          .join("");
      }
    } catch (error) {
      console.error("Error loading artist songs:", error);
    }
  }

  // Load album tracks
  async loadAlbumTracks(albumId) {
    try {
      const response = await fetch(`/LunaMusic/api/album/${albumId}/tracks`);
      const tracks = await response.json();

      const tracksList = document.getElementById("album-tracks-list");
      if (tracksList) {
        tracksList.innerHTML = tracks
          .map(
            (track, index) => `
                    <div class="track-item" onclick="modalManager.openSongDetail(${
                      track.id
                    })">
                        <div class="track-number">${index + 1}</div>
                        <div class="track-info">
                            <div class="track-title">${track.title}</div>
                            <div class="track-artist">
                                ${
                                  track.songArtists &&
                                  track.songArtists.length > 0
                                    ? track.songArtists[0].artist.name
                                    : "Unknown Artist"
                                }
                            </div>
                        </div>
                        <div class="track-duration">${
                          track.duration
                            ? this.formatDuration(track.duration)
                            : "0:00"
                        }</div>
                        <div class="track-actions">
                            <button class="track-action-btn" onclick="modalManager.addToQueue(${
                              track.id
                            })">
                                <i class="fas fa-plus"></i>
                            </button>
                            <button class="track-action-btn" onclick="modalManager.showMoreOptions(${
                              track.id
                            })">
                                <i class="fas fa-ellipsis-h"></i>
                            </button>
                        </div>
                    </div>
                `
          )
          .join("");
      }
    } catch (error) {
      console.error("Error loading album tracks:", error);
    }
  }

  // Initialize audio player
  initializeAudioPlayer(song) {
    if (this.audioPlayer) {
      this.audioPlayer.pause();
      this.audioPlayer = null;
    }

    this.audioPlayer = new Audio(song.filePath);
    this.duration = song.duration || 0;

    this.audioPlayer.addEventListener("loadedmetadata", () => {
      this.duration = this.audioPlayer.duration;
      this.updateTimeDisplay();
    });

    this.audioPlayer.addEventListener("timeupdate", () => {
      this.currentTime = this.audioPlayer.currentTime;
      this.updateProgress();
      this.updateTimeDisplay();
    });

    this.audioPlayer.addEventListener("ended", () => {
      this.isPlaying = false;
      this.updatePlayPauseButtons();
      this.nextSong();
    });
  }

  // Update progress bars
  updateProgress() {
    const progress = (this.currentTime / this.duration) * 100;
    const progressFill = document.getElementById("progress-fill");
    const bottomProgressFill = document.getElementById("bottom-progress-fill");

    if (progressFill) {
      progressFill.style.width = progress + "%";
    }
    if (bottomProgressFill) {
      bottomProgressFill.style.width = progress + "%";
    }
  }

  // Update time display
  updateTimeDisplay() {
    const currentTimeEl = document.getElementById("current-time");
    const bottomCurrentTimeEl = document.getElementById("bottom-current-time");
    const totalTimeEl = document.getElementById("total-time");

    if (currentTimeEl) {
      currentTimeEl.textContent = this.formatTime(this.currentTime);
    }
    if (bottomCurrentTimeEl) {
      bottomCurrentTimeEl.textContent = this.formatTime(this.currentTime);
    }
    if (totalTimeEl) {
      totalTimeEl.textContent = this.formatTime(this.duration);
    }
  }

  // Update play/pause buttons
  updatePlayPauseButtons() {
    const playPauseIcon = document.getElementById("play-pause-icon");
    const bottomPlayPauseIcon = document.getElementById(
      "bottom-play-pause-icon"
    );

    if (playPauseIcon) {
      playPauseIcon.className = this.isPlaying ? "fas fa-pause" : "fas fa-play";
    }
    if (bottomPlayPauseIcon) {
      bottomPlayPauseIcon.className = this.isPlaying
        ? "fas fa-pause"
        : "fas fa-play";
    }
  }

  // Seek to position
  seekTo(event) {
    if (!this.audioPlayer) return;

    const progressBar = event.currentTarget;
    const rect = progressBar.getBoundingClientRect();
    const x = event.clientX - rect.left;
    const percentage = x / rect.width;
    const newTime = percentage * this.duration;

    this.audioPlayer.currentTime = newTime;
    this.currentTime = newTime;
  }

  // Play song
  playSong(songId) {
    if (this.currentSong && this.currentSong.id === songId) {
      this.togglePlayPause();
    } else {
      // Load and play new song
      fetch(`/LunaMusic/api/song/${songId}`)
        .then((response) => response.json())
        .then((song) => {
          this.showNowPlayingModal(song);
          this.play();
        })
        .catch((error) => {
          console.error("Error loading song:", error);
        });
    }
  }

  // Play
  play() {
    if (this.audioPlayer) {
      this.audioPlayer.play();
      this.isPlaying = true;
      this.updatePlayPauseButtons();
    }
  }

  // Pause
  pause() {
    if (this.audioPlayer) {
      this.audioPlayer.pause();
      this.isPlaying = false;
      this.updatePlayPauseButtons();
    }
  }

  // Toggle play/pause
  togglePlayPause() {
    if (this.isPlaying) {
      this.pause();
    } else {
      this.play();
    }
  }

  // Previous song
  previousSong() {
    // Implementation for previous song
    console.log("Previous song");
  }

  // Next song
  nextSong() {
    // Implementation for next song
    console.log("Next song");
  }

  // Shuffle toggle
  shuffleToggle() {
    // Implementation for shuffle toggle
    console.log("Shuffle toggle");
  }

  // Repeat toggle
  repeatToggle() {
    // Implementation for repeat toggle
    console.log("Repeat toggle");
  }

  // Play artist songs
  playArtistSongs(artistId) {
    // Implementation for playing all artist songs
    console.log("Play artist songs:", artistId);
  }

  // Play album songs
  playAlbumSongs(albumId) {
    // Implementation for playing all album songs
    console.log("Play album songs:", albumId);
  }

  // Add to queue
  addToQueue(songId) {
    // Implementation for adding to queue
    console.log("Add to queue:", songId);
  }

  // Add album to queue
  addAlbumToQueue(albumId) {
    // Implementation for adding album to queue
    console.log("Add album to queue:", albumId);
  }

  // Download song
  downloadSong(songId) {
    // Implementation for downloading song
    console.log("Download song:", songId);
  }

  // Follow artist
  followArtist(artistId) {
    // Implementation for following artist
    console.log("Follow artist:", artistId);
  }

  // Show more options
  showMoreOptions(id) {
    // Implementation for showing more options
    console.log("Show more options:", id);
  }

  // Show more lyrics
  showMoreLyrics() {
    // Implementation for showing more lyrics
    console.log("Show more lyrics");
  }

  // Show queue
  showQueue() {
    // Implementation for showing queue
    console.log("Show queue");
  }

  // Format duration in seconds to MM:SS
  formatDuration(seconds) {
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = Math.floor(seconds % 60);
    return `${minutes}:${remainingSeconds.toString().padStart(2, "0")}`;
  }

  // Format time in seconds to MM:SS
  formatTime(seconds) {
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = Math.floor(seconds % 60);
    return `${minutes}:${remainingSeconds.toString().padStart(2, "0")}`;
  }
}

// Global modal manager instance
const modalManager = new ModalManager();

// Global functions for JSP integration
function openSongDetail(songId) {
  fetch(`/LunaMusic/api/song/${songId}`)
    .then((response) => response.json())
    .then((data) => {
      modalManager.showSongDetailModal(data);
    })
    .catch((error) => {
      console.error("Error:", error);
    });
}

function openArtistDetail(artistId) {
  fetch(`/LunaMusic/api/artist/${artistId}`)
    .then((response) => response.json())
    .then((data) => {
      modalManager.showArtistDetailModal(data);
    })
    .catch((error) => {
      console.error("Error:", error);
    });
}

function openAlbumDetail(albumId) {
  fetch(`/LunaMusic/api/album/${albumId}`)
    .then((response) => response.json())
    .then((data) => {
      modalManager.showAlbumDetailModal(data);
    })
    .catch((error) => {
      console.error("Error:", error);
    });
}
