/**
 * Playlist Detail Page JavaScript
 * Handles search functionality and playlist interactions
 */

document.addEventListener("DOMContentLoaded", function () {
  initializePlaylistDetail();
});

function initializePlaylistDetail() {
  const searchInput = document.getElementById("songSearchInput");
  const searchClearBtn = document.getElementById("searchClearBtn");
  const searchResults = document.getElementById("searchResults");
  const searchResultsContent = document.getElementById("searchResultsContent");

  let searchTimeout;

  // Search input event
  if (searchInput) {
    searchInput.addEventListener("input", function (e) {
      const query = e.target.value.trim();

      // Show/hide clear button
      if (searchClearBtn) {
        searchClearBtn.style.display = query ? "block" : "none";
      }

      // Clear previous timeout
      clearTimeout(searchTimeout);

      if (query.length >= 2) {
        // Debounce search
        searchTimeout = setTimeout(() => {
          performSearch(query);
        }, 300);
      } else {
        hideSearchResults();
      }
    });
  }

  // Clear button event
  if (searchClearBtn) {
    searchClearBtn.addEventListener("click", function () {
      if (searchInput) {
        searchInput.value = "";
        searchInput.focus();
      }
      if (searchClearBtn) {
        searchClearBtn.style.display = "none";
      }
      hideSearchResults();
    });
  }

  // Hide results when clicking outside
  document.addEventListener("click", function (e) {
    if (!e.target.closest(".add-songs-section")) {
      hideSearchResults();
    }
  });

  // Initialize action buttons
  initializeActionButtons();
}

function performSearch(query) {
  if (!window.allSongs) {
    return;
  }

  showLoading();

  // Filter songs based on query
  const filteredSongs = window.allSongs.filter(
    (song) =>
      song.title.toLowerCase().includes(query.toLowerCase()) ||
      song.artistName.toLowerCase().includes(query.toLowerCase())
  );

  displaySearchResults(filteredSongs);
}

function showLoading() {
  const searchResultsContent = document.getElementById("searchResultsContent");
  const searchResults = document.getElementById("searchResults");

  if (searchResultsContent && searchResults) {
    searchResultsContent.innerHTML = `
            <div class="search-loading">
                <i class="fas fa-spinner fa-spin"></i>
                Searching...
            </div>
        `;
    searchResults.style.display = "block";
  }
}

function displaySearchResults(songs) {
  const searchResultsContent = document.getElementById("searchResultsContent");
  const searchResults = document.getElementById("searchResults");

  if (!searchResultsContent || !searchResults) return;

  let html = "";

  if (songs.length > 0) {
    songs.forEach((song) => {
      html += `
                <div class="search-result-item">
                    <img src="${song.coverImage}" 
                         alt="${song.title}" class="search-result-cover"
                         onerror="this.src='${
                           window.currentContextPath || ""
                         }/assets/img/default-song.png'">
                    <div class="search-result-info">
                        <div class="search-result-title">${escapeHtml(
                          song.title
                        )}</div>
                        <div class="search-result-artist">${escapeHtml(
                          song.artistName
                        )}</div>
                    </div>
                    <button class="add-song-btn" onclick="addSongToPlaylist(${
                      song.id
                    })" title="Add to playlist">
                        <i class="fas fa-plus"></i>
                    </button>
                </div>
            `;
    });
  } else {
    html = `
            <div class="search-no-results">
                <i class="fas fa-search"></i>
                No songs found for "${
                  document.getElementById("songSearchInput").value
                }"
            </div>
        `;
  }

  searchResultsContent.innerHTML = html;
  searchResults.style.display = "block";
}

function hideSearchResults() {
  const searchResults = document.getElementById("searchResults");
  if (searchResults) {
    searchResults.style.display = "none";
  }
}

function addSongToPlaylist(songId) {
  if (!window.playlistId) {
    return;
  }

  // Create form to add song to playlist
  const form = document.createElement("form");
  form.method = "POST";
  form.action = (window.currentContextPath || "") + "/playlist";

  const actionInput = document.createElement("input");
  actionInput.type = "hidden";
  actionInput.name = "action";
  actionInput.value = "addSong";

  const playlistIdInput = document.createElement("input");
  playlistIdInput.type = "hidden";
  playlistIdInput.name = "playlistId";
  playlistIdInput.value = window.playlistId;

  const songIdInput = document.createElement("input");
  songIdInput.type = "hidden";
  songIdInput.name = "songId";
  songIdInput.value = songId;

  form.appendChild(actionInput);
  form.appendChild(playlistIdInput);
  form.appendChild(songIdInput);

  document.body.appendChild(form);
  form.submit();
}

function initializeActionButtons() {
  // Add collaborator button
  const addCollaboratorBtn = document.getElementById("addCollaboratorBtn");
  if (addCollaboratorBtn) {
    addCollaboratorBtn.addEventListener("click", function () {
      // TODO: Implement add collaborator functionality
      // Add collaborator feature coming soon
    });
  }

  // More options button
  const moreOptionsBtn = document.getElementById("moreOptionsBtn");
  if (moreOptionsBtn) {
    moreOptionsBtn.addEventListener("click", function () {
      // TODO: Implement more options menu
      // More options feature coming soon
    });
  }
}

function escapeHtml(text) {
  const div = document.createElement("div");
  div.textContent = text;
  return div.innerHTML;
}

// Export functions for global use
window.addSongToPlaylist = addSongToPlaylist;

// Initialize audio player
document.addEventListener("DOMContentLoaded", function () {
  initializeAudioPlayer();
});

function initializeAudioPlayer() {
  // Get elements
  audioElement = document.getElementById("audioElement");
  playerBar = document.getElementById("audioPlayerBar");
  playerPlayBtn = document.getElementById("playerPlayBtn");
  playerPlayIcon = document.getElementById("playerPlayIcon");
  playerProgressBar = document.getElementById("playerProgressBar");
  playerProgressFill = document.getElementById("playerProgressFill");
  playerCurrentTime = document.getElementById("playerCurrentTime");
  playerDuration = document.getElementById("playerDuration");
  playerCover = document.getElementById("playerCover");
  playerTitle = document.getElementById("playerTitle");
  playerArtist = document.getElementById("playerArtist");
  playerNextBtn = document.getElementById("playerNextBtn");
  playerPrevBtn = document.getElementById("playerPrevBtn");

  // Add event listeners
  if (playerPlayBtn) {
    playerPlayBtn.addEventListener("click", togglePlay);
  }

  if (playerNextBtn) {
    playerNextBtn.addEventListener("click", playNextSong);
  }

  if (playerPrevBtn) {
    playerPrevBtn.addEventListener("click", playPreviousSong);
  }

  if (playerProgressBar) {
    playerProgressBar.addEventListener("click", seek);
  }

  if (audioElement) {
    audioElement.addEventListener("timeupdate", updateProgress);
    audioElement.addEventListener("loadedmetadata", updateDuration);
    audioElement.addEventListener("ended", onSongEnded);
    audioElement.addEventListener("play", function () {
      isPlaying = true;
      updatePlayButton();
    });
    audioElement.addEventListener("pause", function () {
      isPlaying = false;
      updatePlayButton();
    });
  }
}

/**
 * Play song functionality - Updated to use audio player
 */
function playSong(songId) {
  const index = playlistSongs.findIndex((song) => song.id === songId);
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
  audioElement
    .play()
    .then(() => {
      // Show player bar
      playerBar.classList.add("active");
      document.body.classList.add("player-active");
    })
    .catch((error) => {
      console.error("Error playing audio:", error);
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
    playerPlayIcon.className = "fas fa-pause";
  } else {
    playerPlayIcon.className = "fas fa-play";
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
  playerProgressFill.style.width = percent + "%";

  // Update current time display
  const minutes = Math.floor(audioElement.currentTime / 60);
  const seconds = Math.floor(audioElement.currentTime % 60);
  playerCurrentTime.textContent =
    minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
}

function updateDuration() {
  if (!audioElement.duration) return;

  const minutes = Math.floor(audioElement.duration / 60);
  const seconds = Math.floor(audioElement.duration % 60);
  playerDuration.textContent =
    minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
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
  return mins + ":" + (secs < 10 ? "0" : "") + secs;
}


/**
 * Remove song from playlist
 */
function removeSongFromPlaylist(event, playlistId, songId) {}

// Export functions globally
window.playSong = playSong;
window.removeSongFromPlaylist = removeSongFromPlaylist;
