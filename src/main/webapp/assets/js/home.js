/**
 * Home page JavaScript functionality
 * Handles horizontal scrolling and interactions
 */

// Context path for navigation
let currentContextPath = "";

// Initialize when DOM is loaded
document.addEventListener("DOMContentLoaded", function () {
  // Get context path from meta tag
  const contextPathMeta = document.querySelector('meta[name="context-path"]');
  if (contextPathMeta) {
    currentContextPath = contextPathMeta.getAttribute("content");
  }

  // Initialize horizontal scrolling
  initializeHorizontalScroll();

  // Initialize click events
  initializeClickEvents();

  // Initialize playlist functionality
  initializePlaylistFunctionality();
});

/**
 * Initialize horizontal scrolling functionality for desktop
 */
function initializeHorizontalScroll() {
  const horizontalScrolls = document.querySelectorAll(".horizontal-scroll");

  horizontalScrolls.forEach(function (scrollContainer) {
    let isDown = false;
    let startX;
    let scrollLeft;
    let startTime;

    // Mouse events for desktop
    scrollContainer.addEventListener("mousedown", function (e) {
      // Don't start drag if clicking on cards
      if (e.target.closest(".artist-card, .album-card")) {
        return; // Let the card handle the click
      }

      isDown = true;
      scrollContainer.classList.add("active");
      startX = e.pageX - scrollContainer.offsetLeft;
      scrollLeft = scrollContainer.scrollLeft;
      startTime = Date.now();
      e.preventDefault();
    });

    scrollContainer.addEventListener("mouseleave", function () {
      isDown = false;
      scrollContainer.classList.remove("active");
    });

    scrollContainer.addEventListener("mouseup", function (e) {
      isDown = false;
      scrollContainer.classList.remove("active");

      // Check if it was a click (not a drag)
      const endTime = Date.now();
      const timeDiff = endTime - startTime;
      if (timeDiff < 200) {
        // Less than 200ms = click - allow click events to propagate
        // Don't prevent default here
        return;
      }
    });

    scrollContainer.addEventListener("mousemove", function (e) {
      if (!isDown) return;
      e.preventDefault();
      const x = e.pageX - scrollContainer.offsetLeft;
      const walk = (x - startX) * 2; // Scroll speed multiplier
      scrollContainer.scrollLeft = scrollLeft - walk;
    });

    // Wheel event for horizontal scrolling
    scrollContainer.addEventListener("wheel", function (e) {
      if (e.deltaY !== 0) {
        e.preventDefault();
        scrollContainer.scrollLeft += e.deltaY;
      }
    });

    // Prevent click events during drag, but allow normal clicks
    scrollContainer.addEventListener(
      "click",
      function (e) {
        // Only prevent if we were actually dragging
        if (isDown && startTime) {
          const endTime = Date.now();
          const timeDiff = endTime - startTime;
          if (timeDiff > 200) {
            // Only prevent if it was a long drag
            e.preventDefault();
            e.stopPropagation();
          }
        }
      },
      true
    );
  });
}

/**
 * Initialize click events for cards
 * This function adds backup event listeners but doesn't interfere with onclick attributes
 */
function initializeClickEvents() {
  // Song cards - only add backup if no onclick attribute exists
  document
    .querySelectorAll(".album-card[data-song-id]")
    .forEach(function (card) {
      const songId = card.getAttribute("data-song-id");
      const onclick = card.getAttribute("onclick");

      if (songId && !onclick) {
        // Only add backup listener if no onclick attribute
        card.addEventListener("click", function (e) {
          playSong(parseInt(songId));
        });
      }
    });

  // Artist cards - only add backup if no onclick attribute exists
  document.querySelectorAll(".artist-card").forEach(function (card) {
    const onclick = card.getAttribute("onclick");

    if (!onclick) {
      // Add backup listener for cards without onclick
      card.addEventListener("click", function (e) {
        // You can add default behavior here if needed
      });
    }
  });

  // Album cards - only add backup if no onclick attribute exists
  document.querySelectorAll(".album-card").forEach(function (card) {
    const onclick = card.getAttribute("onclick");
    const dataSongId = card.getAttribute("data-song-id");

    if (!onclick && !dataSongId) {
      // Add backup listener for cards without onclick or data-song-id
      card.addEventListener("click", function (e) {
        // You can add default behavior here if needed
      });
    }
  });
}

/**
 * Play song functionality
 * @param {number} songId - The song ID
 */
function playSong(songId) {
  // Navigate to song detail page
  window.location.href = currentContextPath + "/song-detail?id=" + songId;
}

/**
 * Navigate to artist page
 * @param {number} artistId - The artist ID
 */
function viewArtist(artistId) {
  window.location.href = currentContextPath + "/artist?id=" + artistId;
}

/**
 * Navigate to album page
 * @param {number} albumId - The album ID
 */
function viewAlbum(albumId) {
  window.location.href = currentContextPath + "/album?id=" + albumId;
}

/**
 * Initialize playlist functionality
 */
function initializePlaylistFunctionality() {
  // Load playlists
  loadPlaylists();

  // Initialize add to library button
  const addToLibraryBtn = document.getElementById("addToLibraryBtn");
  if (addToLibraryBtn) {
    addToLibraryBtn.addEventListener("click", function () {
      createPlaylist();
    });
  }

  // Initialize tab navigation
  initializeTabNavigation();

  // Initialize library search
  initializeLibrarySearch();
}

/**
 * Initialize tab navigation
 */
function initializeTabNavigation() {
  const navTabs = document.querySelectorAll(".nav-link");

  navTabs.forEach((tab) => {
    tab.addEventListener("click", function () {
      const targetTab = this.getAttribute("data-tab");

      // Remove active class from all tabs and reset styles
      navTabs.forEach((t) => {
        t.classList.remove("active");
        t.style.backgroundColor = "transparent";
        t.style.color = "#b3b3b3";
        t.style.border = "none";
      });

      // Add active class to clicked tab and set green style
      this.classList.add("active");
      this.style.backgroundColor = "#28a745";
      this.style.color = "white";
      this.style.border = "none";

      // Hide all tab content
      document.querySelectorAll(".tab-content").forEach((content) => {
        content.classList.remove("active");
      });

      // Show target tab content
      const targetContent = document.getElementById(targetTab + "Tab");
      if (targetContent) {
        targetContent.classList.add("active");
      }
    });
  });
}

/**
 * Initialize library search functionality
 */
function initializeLibrarySearch() {
  const searchInput = document.querySelector(".library-search-input");
  const sortBtn = document.getElementById("sortBtn");

  if (searchInput) {
    searchInput.addEventListener("input", function (e) {
      const query = e.target.value.trim().toLowerCase();
      filterPlaylists(query);
    });
  }

  if (sortBtn) {
    sortBtn.addEventListener("click", function () {
      // TODO: Implement sort functionality
      // Sort functionality coming soon
    });
  }
}

/**
 * Filter playlists based on search query
 */
function filterPlaylists(query) {
  const playlistItems = document.querySelectorAll(".playlist-item");

  if (query === "") {
    // Show all playlists when search is empty
    playlistItems.forEach((item) => {
      item.style.display = "flex";
    });
    return;
  }

  let visibleCount = 0;
  playlistItems.forEach((item) => {
    const playlistNameElement = item.querySelector(".playlist-name");
    const playlistDetailsElement = item.querySelector(".playlist-details");

    if (playlistNameElement && playlistDetailsElement) {
      const playlistName = playlistNameElement.textContent.toLowerCase();
      const playlistDetails = playlistDetailsElement.textContent.toLowerCase();

      if (playlistName.includes(query) || playlistDetails.includes(query)) {
        item.style.display = "flex";
        visibleCount++;
      } else {
        item.style.display = "none";
      }
    }
  });
}

/**
 * Load playlists for the current user
 */
function loadPlaylists() {
  // Load playlists for sidebar only
  loadSidebarPlaylists();
}

/**
 * Load playlists for sidebar
 */
function loadSidebarPlaylists() {
  // Playlists are already loaded from server-side rendering in JSP
  // No need to make AJAX call - data is already available in the DOM
  return;
}
/**
 * Display playlists from server response
 */
function displayPlaylistsFromResponse(html) {
  const playlistsList = document.getElementById("playlistsList");
  if (!playlistsList) return;

  // For now, just show demo playlists
  // In a real implementation, you would parse the HTML or JSON response
  showDemoPlaylists();
}

/**
 * Create a playlist item element for sidebar
 */
function createPlaylistItem(playlist) {
  const item = document.createElement("div");
  item.className = "playlist-item";
  item.onclick = () => viewPlaylist(playlist.id);

  item.innerHTML = `
    <div class="playlist-cover">
      <i class="fas fa-music"></i>
    </div>
    <div class="playlist-info">
      <div class="playlist-name">${playlist.name}</div>
      <div class="playlist-details">${playlist.songCount} songs • ${playlist.totalDuration}</div>
    </div>
  `;

  return item;
}

/**
 * Create a new playlist
 */
function createPlaylist() {
  window.location.href = currentContextPath + "/playlist?action=create";
}

/**
 * View playlist detail
 */
function viewPlaylist(playlistId) {
  // Use the simplest URL pattern that should work
  const url = currentContextPath + "/playlist?id=" + playlistId;

  // Navigate to playlist detail page
  window.location.href = url;
}

// Show All Functions
function showAllSongs() {
  // Show all hidden songs in the new songs container
  const container = document.getElementById("new-songs-container");
  if (container) {
    const hiddenCards = container.querySelectorAll(
      '.album-card[style*="display: none"]'
    );
    hiddenCards.forEach((card) => {
      card.style.display = "block";
    });
  }

  // Hide the show all button
  const showAllBtn = document.querySelector('button[onclick="showAllSongs()"]');
  if (showAllBtn) {
    showAllBtn.style.display = "none";
  }
}

function showAllArtists() {
  // Show all hidden artists in the artists container
  const container = document.getElementById("artists-container");
  if (container) {
    const hiddenCards = container.querySelectorAll(
      '.artist-card[style*="display: none"]'
    );
    hiddenCards.forEach((card) => {
      card.style.display = "block";
    });
  }

  // Hide the show all button
  const showAllBtn = document.querySelector(
    'button[onclick="showAllArtists()"]'
  );
  if (showAllBtn) {
    showAllBtn.style.display = "none";
  }
}

function showAllAlbums() {
  // Show all albums (no limit applied in JSP, so just hide button)
  const showAllBtn = document.querySelector(
    'button[onclick="showAllAlbums()"]'
  );
  if (showAllBtn) {
    showAllBtn.style.display = "none";
  }
}

function showAllPopularSongs() {
  // Show all hidden songs in the popular songs container
  const container = document.getElementById("popular-songs-container");
  if (container) {
    const hiddenCards = container.querySelectorAll(
      '.album-card[style*="display: none"]'
    );
    hiddenCards.forEach((card) => {
      card.style.display = "block";
    });
  }

  // Hide the show all button
  const showAllBtn = document.querySelector(
    'button[onclick="showAllPopularSongs()"]'
  );
  if (showAllBtn) {
    showAllBtn.style.display = "none";
  }
}

// Export functions for global use
window.playSong = playSong;
window.viewArtist = viewArtist;
window.viewAlbum = viewAlbum;
window.viewPlaylist = viewPlaylist;
window.createPlaylist = createPlaylist;
window.showAllSongs = showAllSongs;
window.showAllArtists = showAllArtists;
window.showAllAlbums = showAllAlbums;
window.showAllPopularSongs = showAllPopularSongs;
