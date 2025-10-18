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
