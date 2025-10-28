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
  window.location.href = currentContextPath + "/artist-detail?id=" + artistId;
}

/**
 * Navigate to album page
 * @param {number} albumId - The album ID
 */
function viewAlbum(albumId) {
  window.location.href = currentContextPath + "/album-detail?id=" + albumId;
}

/**
 * Initialize playlist functionality
 */
function initializePlaylistFunctionality() {
  // Load playlists
  // loadPlaylists();

  // Initialize add to library button
  const addToLibraryBtn = document.getElementById("addToLibraryBtn");
  if (addToLibraryBtn) {
    addToLibraryBtn.addEventListener("click", function () {
      createPlaylist();
    });
  }

  // Initialize library search
  initializeLibrarySearch();
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

  playlistItems.forEach((item) => {
    const playlistNameElement = item.querySelector(".playlist-name");

    if (playlistNameElement) {
      const playlistName = playlistNameElement.textContent.toLowerCase();

      if (playlistName.includes(query)) {
        item.style.display = "flex";
      } else {
        item.style.display = "none";
      }
    }
  });
}





/**
 * Create a new playlist
 */
function createPlaylist() {
  window.location.href = currentContextPath + "/playlist?action=create";
}


function viewPlaylist(playlistId) {
  const url = currentContextPath + "/playlist?id=" + playlistId;

  window.location.href = url;
}
function showAllSongsSuggest(buttonElement) {
  const container = document.getElementById("new-songs-container-new");
  if (!container) {
    return;
  }
  let isShowingAll = buttonElement.getAttribute('data-showing-all') === 'true';

  if (!isShowingAll) {
        const allCards = container.querySelectorAll('.album-card');
        allCards.forEach(card => {
            card.style.display = 'block'; 
        });
        buttonElement.textContent = 'Show Less';
        buttonElement.setAttribute('data-showing-all', 'true');i

    } else {
        const allCards = container.querySelectorAll('.album-card');
        allCards.forEach((card, index) => {
            if (index >= 10) {
                card.style.display = 'none';
            } else {
                card.style.display = 'block'; 
            }
        });
        buttonElement.textContent = 'Show All';
        buttonElement.setAttribute('data-showing-all', 'false'); 
    }

}

function showAllSongs(buttonElement) {
  const container = document.getElementById("new-songs-container");
  if (!container) {
    return;
  }
  let isShowingAll = buttonElement.getAttribute('data-showing-all') === 'true';

  if (!isShowingAll) {
        const allCards = container.querySelectorAll('.album-card');
        allCards.forEach(card => {
            card.style.display = 'block'; 
        });
        buttonElement.textContent = 'Show Less';
        buttonElement.setAttribute('data-showing-all', 'true');i

    } else {
        const allCards = container.querySelectorAll('.album-card');
        allCards.forEach((card, index) => {
            if (index >= 10) {
                card.style.display = 'none';
            } else {
                card.style.display = 'block'; 
            }
        });
        buttonElement.textContent = 'Show All';
        buttonElement.setAttribute('data-showing-all', 'false'); 
    }

}

function showAllArtists(buttonElement) {
  const container = document.getElementById("artists-container");
  if (!container) {
    return;
  }
  let isShowingAll = buttonElement.getAttribute('data-showing-all') === 'true';

  if (!isShowingAll) {
        const allCards = container.querySelectorAll('.artist-card');
        allCards.forEach(card => {
            card.style.display = 'block'; 
        });
        buttonElement.textContent = 'Show Less';
        buttonElement.setAttribute('data-showing-all', 'true');i

    } else {
        const allCards = container.querySelectorAll('.artist-card');
        allCards.forEach((card, index) => {
            if (index >= 10) {
                card.style.display = 'none';
            } else {
                card.style.display = 'block'; 
            }
        });
        buttonElement.textContent = 'Show All';
        buttonElement.setAttribute('data-showing-all', 'false'); 
    }
}

function showAllAlbums(buttonElement) {
  const container = document.getElementById("albums-container");
 if (!container) {
    return;
  }
  let isShowingAll = buttonElement.getAttribute('data-showing-all') === 'true';

  if (!isShowingAll) {
        const allCards = container.querySelectorAll('.album-card');
        allCards.forEach(card => {
            card.style.display = 'block'; 
        });
        buttonElement.textContent = 'Show Less';
        buttonElement.setAttribute('data-showing-all', 'true');i

    } else {
        const allCards = container.querySelectorAll('.album-card');
        allCards.forEach((card, index) => {
            if (index >= 10) {
                card.style.display = 'none';
            } else {
                card.style.display = 'block'; 
            }
        });
        buttonElement.textContent = 'Show All';
        buttonElement.setAttribute('data-showing-all', 'false'); 
    }
}

function showAllPopularSongs(buttonElement) {
  // Show all hidden songs in the popular songs container
  const container = document.getElementById("popular-songs-container");
  if (!container) {
    return;
  }
  let isShowingAll = buttonElement.getAttribute('data-showing-all') === 'true';

  if (!isShowingAll) {
        const allCards = container.querySelectorAll('.album-card');
        allCards.forEach(card => {
            card.style.display = 'block'; 
        });
        buttonElement.textContent = 'Show Less';
        buttonElement.setAttribute('data-showing-all', 'true');i

    } else {
        const allCards = container.querySelectorAll('.album-card');
        allCards.forEach((card, index) => {
            if (index >= 10) {
                card.style.display = 'none';
            } else {
                card.style.display = 'block'; 
            }
        });
        buttonElement.textContent = 'Show All';
        buttonElement.setAttribute('data-showing-all', 'false'); 
    }
}
/**
 * Remove playlist
 */
function deletePlaylist(event, playlistId) {
  event.stopPropagation(); // Khong cho click ra ngoài
  const form = document.createElement("form");
  form.method = "POST";
  form.action = currentContextPath + "/playlist";

  const actionInput = document.createElement("input");
  actionInput.type = "hidden";
  actionInput.name = "action";
  actionInput.value = "delete";

  const playlistIdInput = document.createElement("input");
  playlistIdInput.type = "hidden";
  playlistIdInput.name = "playlistId";
  playlistIdInput.value = playlistId;

  form.appendChild(actionInput);
  form.appendChild(playlistIdInput);

  document.body.appendChild(form);
  form.submit();
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
window.deletePlaylist = deletePlaylist;
