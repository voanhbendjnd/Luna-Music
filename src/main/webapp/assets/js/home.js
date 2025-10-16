/**
 * Luna Music Home Page JavaScript
 * Handles interactions for artists, albums, and songs
 */

// Global variables
let currentContextPath = "";

// Initialize when DOM is loaded
document.addEventListener("DOMContentLoaded", function () {
  // Get context path for navigation
  currentContextPath =
    document
      .querySelector('meta[name="context-path"]')
      ?.getAttribute("content") || "";

  // Initialize horizontal scroll functionality
  initializeHorizontalScroll();

  // Initialize lazy loading for images
  initializeLazyLoading();

  // Initialize keyboard navigation
  initializeKeyboardNavigation();
});

/**
 * Initialize horizontal scroll with mouse drag functionality
 */
function initializeHorizontalScroll() {
  document.querySelectorAll(".horizontal-scroll").forEach((scrollContainer) => {
    let isDown = false;
    let startX;
    let scrollLeft;

    // Mouse events
    scrollContainer.addEventListener("mousedown", (e) => {
      isDown = true;
      scrollContainer.classList.add("active");
      startX = e.pageX - scrollContainer.offsetLeft;
      scrollLeft = scrollContainer.scrollLeft;
      e.preventDefault();
    });

    scrollContainer.addEventListener("mouseleave", () => {
      isDown = false;
      scrollContainer.classList.remove("active");
    });

    scrollContainer.addEventListener("mouseup", () => {
      isDown = false;
      scrollContainer.classList.remove("active");
    });

    scrollContainer.addEventListener("mousemove", (e) => {
      if (!isDown) return;
      e.preventDefault();
      const x = e.pageX - scrollContainer.offsetLeft;
      const walk = (x - startX) * 2;
      scrollContainer.scrollLeft = scrollLeft - walk;
    });

    // Touch events for mobile
    scrollContainer.addEventListener("touchstart", (e) => {
      isDown = true;
      startX = e.touches[0].pageX - scrollContainer.offsetLeft;
      scrollLeft = scrollContainer.scrollLeft;
    });

    scrollContainer.addEventListener("touchend", () => {
      isDown = false;
    });

    scrollContainer.addEventListener("touchmove", (e) => {
      if (!isDown) return;
      const x = e.touches[0].pageX - scrollContainer.offsetLeft;
      const walk = (x - startX) * 2;
      scrollContainer.scrollLeft = scrollLeft - walk;
    });
  });
}

/**
 * Initialize lazy loading for images
 */
function initializeLazyLoading() {
  const images = document.querySelectorAll("img[data-src]");

  const imageObserver = new IntersectionObserver((entries, observer) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        const img = entry.target;
        img.src = img.dataset.src;
        img.classList.remove("loading");
        observer.unobserve(img);
      }
    });
  });

  images.forEach((img) => {
    img.classList.add("loading");
    imageObserver.observe(img);
  });
}

/**
 * Initialize keyboard navigation
 */
function initializeKeyboardNavigation() {
  document.addEventListener("keydown", function (e) {
    // Arrow key navigation for horizontal scrolls
    if (e.key === "ArrowLeft" || e.key === "ArrowRight") {
      const focusedElement = document.activeElement;
      const scrollContainer = focusedElement.closest(".horizontal-scroll");

      if (scrollContainer) {
        e.preventDefault();
        const scrollAmount = 200;

        if (e.key === "ArrowLeft") {
          scrollContainer.scrollLeft -= scrollAmount;
        } else {
          scrollContainer.scrollLeft += scrollAmount;
        }
      }
    }
  });
}

/**
 * Navigate to artist page
 * @param {number} artistId - The artist ID
 */
function viewArtist(artistId) {
  console.log("Viewing artist:", artistId);

  // Add loading state
  showLoadingState();

  // Navigate to artist page
  window.location.href = currentContextPath + "/artist?id=" + artistId;
}

/**
 * Navigate to album page
 * @param {number} albumId - The album ID
 */
function viewAlbum(albumId) {
  console.log("Viewing album:", albumId);

  // Add loading state
  showLoadingState();

  // Navigate to album page
  window.location.href = currentContextPath + "/album?id=" + albumId;
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
 * Show loading state
 */
function showLoadingState() {
  document.body.classList.add("loading");

  // Add loading overlay
  const overlay = document.createElement("div");
  overlay.className = "loading-overlay";
  overlay.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
  document.body.appendChild(overlay);
}

/**
 * Show play notification
 * @param {string} message - The notification message
 */
function showPlayNotification(message) {
  // Create notification element
  const notification = document.createElement("div");
  notification.className = "play-notification";
  notification.innerHTML = `
        <div class="notification-content">
            <i class="fas fa-music"></i>
            <span>${message}</span>
        </div>
    `;

  // Add to page
  document.body.appendChild(notification);

  // Animate in
  setTimeout(() => {
    notification.classList.add("show");
  }, 100);

  // Remove after 3 seconds
  setTimeout(() => {
    notification.classList.remove("show");
    setTimeout(() => {
      document.body.removeChild(notification);
    }, 300);
  }, 3000);
}

/**
 * Handle image load errors
 * @param {HTMLImageElement} img - The image element
 * @param {string} fallbackSrc - Fallback image source
 */
function handleImageError(img, fallbackSrc) {
  img.onerror = null; // Prevent infinite loop
  img.src =
    fallbackSrc || currentContextPath + "/assets/img/default-placeholder.png";
}

/**
 * Debounce function for performance optimization
 * @param {Function} func - Function to debounce
 * @param {number} wait - Wait time in milliseconds
 * @returns {Function} Debounced function
 */
function debounce(func, wait) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

// Export functions for global use
window.viewArtist = viewArtist;
window.viewAlbum = viewAlbum;
window.playSong = playSong;
window.handleImageError = handleImageError;

// Debug: Log that functions are available
console.log("Home.js loaded. Functions available:", {
  viewArtist: typeof window.viewArtist,
  viewAlbum: typeof window.viewAlbum,
  playSong: typeof window.playSong,
  handleImageError: typeof window.handleImageError,
});
