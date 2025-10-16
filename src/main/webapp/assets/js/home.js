/**
 * Home page JavaScript functionality
 * Handles horizontal scrolling and interactions
 */

// Context path for navigation
let currentContextPath = "";

// Initialize when DOM is loaded
document.addEventListener("DOMContentLoaded", function () {
  console.log("Home.js loaded. Initializing...");

  // Get context path from meta tag
  const contextPathMeta = document.querySelector('meta[name="context-path"]');
  if (contextPathMeta) {
    currentContextPath = contextPathMeta.getAttribute("content");
    console.log("Context path:", currentContextPath);
  }

  // Initialize horizontal scrolling
  initializeHorizontalScroll();

  // Initialize click events
  initializeClickEvents();
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
          console.log("Song card clicked (backup):", songId);
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
        console.log("Artist card clicked (backup)");
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
        console.log("Album card clicked (backup)");
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
  console.log("Playing song:", songId);
  console.log("Current context path:", currentContextPath);
  console.log(
    "Full URL will be:",
    currentContextPath + "/song-detail?id=" + songId
  );

  // Navigate to song detail page
  window.location.href = currentContextPath + "/song-detail?id=" + songId;
}

/**
 * Navigate to artist page
 * @param {number} artistId - The artist ID
 */
function viewArtist(artistId) {
  console.log("Viewing artist:", artistId);
  window.location.href = currentContextPath + "/artist?id=" + artistId;
}

/**
 * Navigate to album page
 * @param {number} albumId - The album ID
 */
function viewAlbum(albumId) {
  console.log("Viewing album:", albumId);
  window.location.href = currentContextPath + "/album?id=" + albumId;
}

// Export functions for global use
window.playSong = playSong;
window.viewArtist = viewArtist;
window.viewAlbum = viewAlbum;
