# Playlist Audio Player Feature

## 🎵 Tính năng mới

Thêm audio player vào playlist-detail để phát nhạc trực tiếp trong playlist mà không cần mở song-detail page.

### ✅ **Features Implemented:**

1. ✅ Phát nhạc trực tiếp trong playlist
2. ✅ Fixed bottom audio player bar
3. ✅ Play/Pause control
4. ✅ Next/Previous buttons
5. ✅ Auto-play next random song khi hết bài
6. ✅ Progress bar với seek functionality
7. ✅ Display song info (cover, title, artist)
8. ✅ Time display (current/duration)

---

## 🎨 UI Components

### Fixed Bottom Player Bar

```
┌─────────────────────────────────────────────────────────┐
│ [Cover] Song Title       [Prev] [Play] [Next]           │
│         Artist Name       ●━━━━━━━━━━━━━━━━━            │
│                          0:45          3:21             │
└─────────────────────────────────────────────────────────┘
```

**Sections:**

- **Left**: Song info (cover image, title, artist)
- **Center**: Player controls (prev, play/pause, next) + progress bar

---

## 🔧 Implementation Details

### 1. **CSS Styles** (Line 276-465)

#### Player Bar Container

```css
.audio-player-bar {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  height: 90px;
  background: linear-gradient(to top, #181818, #282828);
  z-index: 1000;
}
```

#### Key Features:

- Fixed bottom position
- Hidden by default
- Shows with `.active` class
- Gradient background
- Box shadow for depth

---

### 2. **HTML Structure** (Line 755-798)

```html
<div class="audio-player-bar" id="audioPlayerBar">
  <!-- Song Info -->
  <div class="player-song-info">
    <img id="playerCover" class="player-song-cover" />
    <div class="player-song-details">
      <div class="player-song-title" id="playerTitle"></div>
      <div class="player-song-artist" id="playerArtist"></div>
    </div>
  </div>

  <!-- Player Controls -->
  <div class="player-controls-center">
    <div class="player-buttons">
      <button id="playerPrevBtn"><i class="fas fa-step-backward"></i></button>
      <button id="playerPlayBtn"><i class="fas fa-play"></i></button>
      <button id="playerNextBtn"><i class="fas fa-step-forward"></i></button>
    </div>
    <div class="player-progress-container">
      <span id="playerCurrentTime">0:00</span>
      <div id="playerProgressBar">
        <div id="playerProgressFill"></div>
      </div>
      <span id="playerDuration">0:00</span>
    </div>
  </div>

  <!-- Hidden Audio Element -->
  <audio id="audioElement" preload="metadata"></audio>
</div>
```

---

### 3. **JavaScript Functionality** (Line 638-861)

#### A. **Data Structure**

```javascript
const playlistSongs = [
  {
    id: 1,
    title: "Song Title",
    artist: "Artist Name",
    coverImage: "/path/to/cover.jpg",
    filePath: "/path/to/audio.mp3",
    duration: 180,
  },
  // ... more songs
];
```

**Data from JSP:**

```jsp
<c:forEach var="playlistSong" items="${playlist.playlistSongs}">
    {
        id: ${playlistSong.song.id},
        title: `${playlistSong.song.title}`,
        artist: `...`,
        coverImage: `${pageContext.request.contextPath}${playlistSong.song.coverImage}`,
        filePath: `${pageContext.request.contextPath}${playlistSong.song.filePath}`,
        duration: ${playlistSong.song.duration}
    }
</c:forEach>
```

---

#### B. **Core Functions**

**1. `initializeAudioPlayer()`**

- Initialize all DOM elements
- Add event listeners
- Setup audio element events

**2. `playSong(songId)`**

```javascript
function playSong(songId) {
  const index = playlistSongs.findIndex((song) => song.id === songId);
  if (index === -1) return;
  loadAndPlaySong(index);
}
```

- Called when user clicks on a song in playlist
- Finds song in array
- Loads and plays the song

**3. `loadAndPlaySong(index)`**

```javascript
function loadAndPlaySong(index) {
  currentSongIndex = index;
  const song = playlistSongs[index];

  // Update UI
  playerCover.src = song.coverImage;
  playerTitle.textContent = song.title;
  playerArtist.textContent = song.artist;

  // Load and play audio
  audioElement.src = song.filePath;
  audioElement.load();
  audioElement.play().then(() => {
    playerBar.classList.add("active");
    document.body.classList.add("player-active");
  });
}
```

**4. `playNextSong()` - Random Next**

```javascript
function playNextSong() {
  // Random next song (excluding current)
  let nextIndex;
  do {
    nextIndex = Math.floor(Math.random() * playlistSongs.length);
  } while (nextIndex === currentSongIndex);

  loadAndPlaySong(nextIndex);
}
```

- Picks random song from playlist
- Excludes currently playing song
- Automatically called when song ends

**5. `onSongEnded()` - Auto-play**

```javascript
function onSongEnded() {
  // Auto-play next random song
  playNextSong();
}
```

- Event listener on `audio.ended`
- Automatically plays next random song

**6. `togglePlay()`**

```javascript
function togglePlay() {
  if (!audioElement.src) {
    // Play first song if nothing loaded
    loadAndPlaySong(0);
    return;
  }

  if (isPlaying) {
    audioElement.pause();
  } else {
    audioElement.play();
  }
}
```

**7. `updateProgress()`**

```javascript
function updateProgress() {
  const percent = (audioElement.currentTime / audioElement.duration) * 100;
  playerProgressFill.style.width = percent + "%";

  // Update time display
  playerCurrentTime.textContent = formatTime(audioElement.currentTime);
}
```

**8. `seek(e)` - Progress Bar Click**

```javascript
function seek(e) {
  const rect = playerProgressBar.getBoundingClientRect();
  const percent = (e.clientX - rect.left) / rect.width;
  audioElement.currentTime = percent * audioElement.duration;
}
```

**9. `seek(e)` - Progress Bar Seek**

```javascript
function seek(e) {
  const rect = playerProgressBar.getBoundingClientRect();
  const percent = (e.clientX - rect.left) / rect.width;
  audioElement.currentTime = percent * audioElement.duration;
}
```

---

## 🔄 User Flow

### Playing a Song

1. **User clicks on song in playlist**

   ```
   onClick → playSong(songId) → loadAndPlaySong(index)
   ```

2. **Player loads song**

   ```
   - Set audio src
   - Update UI (cover, title, artist)
   - Start playing
   - Show player bar
   ```

3. **Player bar appears**

   ```
   - Fixed bottom bar slides in
   - Shows song info
   - Progress bar starts updating
   ```

4. **Song ends**
   ```
   - onSongEnded event fires
   - Automatically plays random next song
   - Updates UI with new song info
   ```

---

## 🎯 Features Breakdown

### Auto-play Next Song (Random)

**Logic:**

```javascript
// When song ends
audio.addEventListener("ended", () => {
  // Pick random song (exclude current)
  let nextIndex;
  do {
    nextIndex = Math.floor(Math.random() * playlistSongs.length);
  } while (nextIndex === currentSongIndex);

  // Play it
  loadAndPlaySong(nextIndex);
});
```

**Behavior:**

- ✅ Random selection from playlist
- ✅ Never plays same song twice in a row
- ✅ Continuous playback
- ✅ Like shuffle mode

### Previous Button

**Logic:**

- If not first song → play previous
- If first song → play last song (wrap around)

### Next Button

**Logic:**

- Random next song (same as auto-play)

---

## 📊 Comparison with song-detail

| Feature        | song-detail             | playlist-detail      |
| -------------- | ----------------------- | -------------------- |
| Location       | Separate page           | Same page            |
| Audio player   | Full page               | Bottom bar           |
| Next song      | Navigate to song-detail | Stay on page         |
| Auto-play next | Random from related     | Random from playlist |
| UI             | Full detail page        | Compact player bar   |

---

## 🎨 Styling Details

### Colors

- Background: `linear-gradient(to top, #181818, #282828)`
- Progress bar: `#1db954` (Spotify green)
- Text: White/`#b3b3b3`
- Hover: `#1ed760` (lighter green)

### Animations

- Hover scale on buttons: `transform: scale(1.1)`
- Progress bar hover: Shows draggable knob
- Smooth transitions: `0.2s ease`

### Responsive

- Fixed height: `90px`
- Flex layout for responsiveness
- Min-width constraints on time displays
- Max-width on center controls (600px)

---

## 🚀 Testing Checklist

- [x] Click song → plays immediately
- [x] Play/Pause button works
- [x] Next button → random song
- [x] Previous button → previous song
- [x] Song ends → auto-play next random
- [x] Progress bar updates
- [x] Click progress bar → seeks
- [x] Song info displays correctly
- [x] Player bar shows/hides correctly

---

## 💡 Key Advantages

1. **No Page Reload**: Play music without leaving playlist
2. **Continuous Playback**: Auto-play keeps music going
3. **Random Discovery**: Shuffle-like experience
4. **Better UX**: Fixed player bar always accessible
5. **Performance**: No server requests for next song

---

## 🎵 Result

**Before:**

- ❌ Click song → redirect to song-detail
- ❌ Need to go back to playlist
- ❌ Interrupts browsing

**After:**

- ✅ Click song → plays immediately in player bar
- ✅ Browse playlist while music plays
- ✅ Auto-play next random song
- ✅ Smooth, uninterrupted experience

**Perfect audio player for playlist! 🎧✨**

---

## 📝 Recent Updates

### October 18, 2025 - Volume Control Removal & Icon Update

1. **Removed Volume Control**

   - Simplified player UI
   - Removed volume bar and icon
   - Removed related JavaScript functions

2. **Icon Consistency**

   - Updated to use FontAwesome icons matching song-detail page
   - Previous: `fa-step-backward`
   - Next: `fa-step-forward`

3. **CSS Cleanup**
   - Removed volume control styles
   - Cleaner, more focused player design

**Files Modified:**

- ✅ `src/main/webapp/views/playlist-detail.jsp` - Removed volume HTML, CSS, and JS
- ✅ `PLAYLIST_AUDIO_PLAYER.md` - Updated documentation
