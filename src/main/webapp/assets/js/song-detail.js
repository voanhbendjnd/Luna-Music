/**
 * Song Detail Page JavaScript
 * Handles music player functionality
 */

// Global variables
let audioPlayer;
let mainPlayBtn;
let bottomPlayBtn;
let isPlaying = false;
let currentSongId;
let progressFill;
let currentTimeSpan;
let nextBtn;

// Initialize when DOM is loaded
document.addEventListener("DOMContentLoaded", function () {
  // Get elements
  audioPlayer = document.getElementById("audioPlayer");
  mainPlayBtn = document.getElementById("mainPlayBtn");
  bottomPlayBtn = document.getElementById("bottomPlayBtn");
  progressFill = document.getElementById("progressFill");
  currentTimeSpan = document.getElementById("currentTime");
  nextBtn = document.getElementById("nextBtn");
  prevBtn = document.getElementById("prevBtn");
  // Get current song ID from URL
  const urlParams = new URLSearchParams(window.location.search);
  currentSongId = urlParams.get("id");

  console.log("Song Detail Page Loaded. Song ID:", currentSongId);

  // Initialize event listeners
  initializeEventListeners();

  // Initialize audio player
  initializeAudioPlayer();

  // Set initial button state
  updatePlayButtons();
});

/**
 * Initialize event listeners
 */
function initializeEventListeners() {
  // Previous button click
  if (prevBtn) {
    prevBtn.addEventListener("click", playPreviousSong);
  }
  // Play button clicks
  if (mainPlayBtn) {
    mainPlayBtn.addEventListener("click", togglePlay);
  }

  if (bottomPlayBtn) {
    bottomPlayBtn.addEventListener("click", togglePlay);
  }

  // Next button click
  if (nextBtn) {
    nextBtn.addEventListener("click", playNextSong);
  }

  // Progress bar click
  const progressBar = document.querySelector(".progress-bar");
  if (progressBar) {
    progressBar.addEventListener("click", onProgressBarClick);
  }

  // Audio events
  if (audioPlayer) {
    audioPlayer.addEventListener("loadedmetadata", onAudioLoaded);
    audioPlayer.addEventListener("play", onAudioPlay);
    audioPlayer.addEventListener("pause", onAudioPause);
    audioPlayer.addEventListener("ended", onAudioEnded);
    audioPlayer.addEventListener("error", onAudioError);
    audioPlayer.addEventListener("timeupdate", onTimeUpdate);
  }
}

/**
 * Initialize audio player
 */
function initializeAudioPlayer() {
  if (audioPlayer) {
    // Ensure initial state is paused
    isPlaying = false;

    // Preload the audio
    audioPlayer.load();

    // Update play count when audio starts playing
    audioPlayer.addEventListener("canplay", function () {
      console.log("Audio ready to play");
    });
  }
}

/**
 * Toggle play/pause
 */
function togglePlay() {
  if (!audioPlayer) return;

  if (isPlaying) {
    pauseAudio();
  } else {
    playAudio();
  }
}

/**
 * Play audio
 */
function playAudio() {
  if (!audioPlayer) return;

  audioPlayer
    .play()
    .then(() => {
      // Update play count in database
      updatePlayCount();
    })
    .catch((error) => {
      console.error("Error playing audio:", error);
      showPlayError();
    });
}

/**
 * Pause audio
 */
function pauseAudio() {
  if (!audioPlayer) return;

  audioPlayer.pause();
}

/**
 * Audio loaded event
 */
function onAudioLoaded() {
  console.log("Audio metadata loaded");
  console.log("Duration:", audioPlayer.duration, "seconds");
}

/**
 * Audio play event
 */
function onAudioPlay() {
  isPlaying = true;
  updatePlayButtons();
  console.log("Audio started playing");
}

/**
 * Audio pause event
 */
function onAudioPause() {
  isPlaying = false;
  updatePlayButtons();
  console.log("Audio paused");
}

/**
 * Update play buttons state
 */
function updatePlayButtons() {
  console.log("Updating play buttons. isPlaying:", isPlaying);

  // Update main play button
  if (mainPlayBtn) {
    const icon = mainPlayBtn.querySelector("i");
    if (icon) {
      icon.className = isPlaying ? "fas fa-pause" : "fas fa-play";
      console.log("Main button icon updated to:", icon.className);
    }
    mainPlayBtn.classList.toggle("active", isPlaying);
  }

  // Update bottom play button
  if (bottomPlayBtn) {
    const icon = bottomPlayBtn.querySelector("i");
    if (icon) {
      icon.className = isPlaying ? "fas fa-pause" : "fas fa-play";
      console.log("Bottom button icon updated to:", icon.className);
    }
  }
}

/**
 * Audio ended event
 */
function onAudioEnded() {
  isPlaying = false;
  if (playBtn) {
    playBtn.innerHTML = '<i class="fas fa-play"></i>';
    playBtn.classList.remove("playing");
  }

  // Reset audio to beginning
  audioPlayer.currentTime = 0;
}

/**
 * Audio error event
 */
function onAudioError(error) {
  console.error("Audio error:", error);
  showPlayError();
}

/**
 * Update play count in database call controller SongDetailController.java
 */
function updatePlayCount() {
  if (!currentSongId) return;

  fetch(window.location.pathname, {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: "action=updatePlayCount&songId=" + currentSongId,
  })
    .then((response) => response.json())
    .then((data) => {
      if (data.success) {
        console.log("Play count updated successfully");
      } else {
        console.error("Failed to update play count:", data.message);
      }
    })
    .catch((error) => {
      console.error("Error updating play count:", error);
    });
}

/**
 * Play next song
 */
function playNextSong() {
  fetch(window.location.pathname, {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: "action=next&songId=" + currentSongId,
  })
    .then((response) => response.json())
    .then((data) => {
      if (data.success) {
        console.log("Next song played successfully");
        window.location.href = data.url; // redirect to next song
      } else {
        console.error("Failed to play next song:", data.message);
      }
    })
    .catch((error) => {
      console.error("Error playing next song:", error);
      showPlayError();
    });
}
/**
 * Play previous song
 */
function playPreviousSong() {
  fetch(window.location.pathname, {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: "action=prev&songId=" + currentSongId,
  })
    .then((response) => response.json())
    .then((data) => {
      if (data.success) {
        console.log("Previous song played successfully");
        window.location.href = data.url; // redirect to previous song
      } else {
        console.error("Failed to play previous song:", data.message);
      }
    })
    .catch((error) => {
      console.error("Error playing previous song:", error);
      showPlayError();
    });
}
/**
 * Show play error notification
 */
function showPlayError() {
  // Create error notification
  const notification = document.createElement("div");
  notification.className = "error-notification";
  notification.innerHTML = `
        <div class="notification-content">
            <i class="fas fa-exclamation-triangle"></i>
            <span>Không thể phát nhạc. Vui lòng thử lại sau.</span>
        </div>
    `;

  // Add styles
  notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #ff4757;
        color: white;
        padding: 1rem 1.5rem;
        border-radius: 10px;
        box-shadow: 0 10px 30px rgba(255, 71, 87, 0.3);
        z-index: 1000;
        animation: slideIn 0.3s ease;
    `;

  // Add to page
  document.body.appendChild(notification);

  // Remove after 5 seconds
  setTimeout(() => {
    notification.style.animation = "slideOut 0.3s ease";
    setTimeout(() => {
      if (document.body.contains(notification)) {
        document.body.removeChild(notification);
      }
    }, 300);
  }, 5000);
}

/**
 * Play related song
 */
function playRelatedSong(songId) {
  // Navigate to the related song's detail page
  window.location.href = `${window.location.pathname}?id=${songId}`;
}

/**
 * Format time in MM:SS format
 */
function formatTime(seconds) {
  const minutes = Math.floor(seconds / 60);
  const remainingSeconds = Math.floor(seconds % 60);
  return `${minutes}:${remainingSeconds.toString().padStart(2, "0")}`;
}

/**
 * Handle progress bar click
 */
function onProgressBarClick(event) {
  if (!audioPlayer) return;

  const progressBar = event.currentTarget;
  const rect = progressBar.getBoundingClientRect();
  const clickX = event.clientX - rect.left;
  const width = rect.width;
  const percentage = clickX / width;

  const newTime = percentage * audioPlayer.duration;
  audioPlayer.currentTime = newTime;

  console.log("Progress bar clicked:", percentage, "New time:", newTime);
}

/**
 * Update progress bar and time display
 */
function onTimeUpdate() {
  if (!audioPlayer || !progressFill || !currentTimeSpan) return;

  const currentTime = audioPlayer.currentTime;
  const duration = audioPlayer.duration;

  if (duration > 0) {
    const percentage = (currentTime / duration) * 100;
    progressFill.style.width = percentage + "%";

    // Update time display
    const minutes = Math.floor(currentTime / 60);
    const seconds = Math.floor(currentTime % 60);
    currentTimeSpan.textContent = `${minutes}:${seconds
      .toString()
      .padStart(2, "0")}`;
  }
}

/**
 * Add CSS animations
 */
const style = document.createElement("style");
style.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes slideOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);
