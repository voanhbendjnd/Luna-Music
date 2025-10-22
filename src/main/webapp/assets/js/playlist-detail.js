
// auto chơi nhạc
function autoPlaySong() {
  const audio = document.getElementById("audioPlayer");
  if (audio) {
    audio.play().then(() => {
      setTimeout(() => {
        audio.muted = false;
      }, 300);
    });
    audio.addEventListener("ended", function () {
      document.getElementById("nextBtn").click();
    });
  }
}
window.autoPlaySong = autoPlaySong;
document.addEventListener("DOMContentLoaded", function () {
  autoPlaySong();
});
// thanh phat nhac
let bottomPlayBtn;
let isPlaying = false;
let audioPlayer;
let currentSongId;
function pauseAudio() {
  if (!audioPlayer) return;

  audioPlayer.pause();
}
function playAudio() {
  if (!audioPlayer) return;

  audioPlayer
    .play()
    .then(() => {
      // Update play count in database
      updatePlayCount();
    })
    .catch((error) => {
      showPlayError();
    });
}

function togglePlay() {
  if (audioPlayer) return;
  if (isPlaying) {
    pauseAudio();
  }
  else {
    playAudio();
  }
}

function initializeEventListeners() {
  if (bottomPlayBtn) {
    bottomPlayBtn.addEventListener("click", togglePlay)
  }
}

document.addEventListener("DOMContentLoaded", function () {
  bottomPlayBtn = document.getElementById("bottomPlayBtn");
  audioPlayer = document.getElementById("audioPlayer");
  const urlParams = new URLSearchParams(window.location.search);
  currentSongId = urlParams.get("id");
  initializeEventListeners();
  initializeAudioPlayer();
  updatePlayButtons();

})
// bat nhac
function onAudioPlay() {
  isPlaying = true;
}
function initializeAudioPlayer() {
  if (audioPlayer) {
    // Ensure initial state is paused
    isPlaying = false;

    // Preload the audio
    audioPlayer.load();

    // Update play count when audio starts playing
    audioPlayer.addEventListener("canplay", function () {});
  }
}


function updatePlayButtons() {
  if (bottomPlayBtn) {
    const icon = bottomPlayBtn.querySelector("i");
    if (icon) {
      icon.className = isPlaying ? "fas fa-pause" : "fas fa-play";
    }
    bottomPlayBtn.classList.toggle("active", isPlaying);
  }
}

function updatePlayCount() {
  if (!currentSongId) return;

  fetch(window.location.pathname, {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded", // server đọc được request.parameter()
    },
    body: "action=updatePlayCount&songId=" + currentSongId,
  });
}

