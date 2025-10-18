# Playlist Cover Image Update

## 🎯 Yêu cầu

Khi mở playlist-detail:

- ✅ Hiển thị ảnh cover hiện tại của playlist (nếu có)
- ✅ Thay vì "Choose photo" placeholder, có button "Change Photo" khi hover
- ✅ Click vào ảnh hoặc button để thay đổi ảnh

---

## 🔄 Những thay đổi đã thực hiện

### 1. **CSS Updates** (Line 28-105)

#### New Styles:

**`.playlist-cover-container`** - Container chính

```css
.playlist-cover-container {
  position: relative;
  width: 200px;
  height: 200px;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  background: linear-gradient(135deg, #1e1e1e, #2a2a2a);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.5);
}
```

**`.playlist-cover-overlay`** - Overlay hiện khi hover

```css
.playlist-cover-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.playlist-cover-container:hover .playlist-cover-overlay {
  opacity: 1; /* Show on hover */
}
```

**`.change-photo-btn`** - Button thay đổi ảnh

```css
.change-photo-btn {
  background: rgba(29, 185, 84, 0.9);
  border: none;
  color: white;
  padding: 10px 20px;
  border-radius: 25px;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 8px;
  transition: all 0.3s ease;
}
```

---

### 2. **HTML Structure** (Line 289-338)

#### 3 Containers:

**A. Main Cover Container** (Khi có ảnh)

```jsp
<div class="playlist-cover-container" id="mainCoverContainer"
    style="display: ${not empty playlist.coverImage ? 'block' : 'none'};">
    <!-- Current cover image -->
    <img src="${pageContext.request.contextPath}${playlist.coverImage}"
         class="playlist-cover-image"
         id="currentCoverImage">

    <!-- Overlay with Change Photo button (shows on hover) -->
    <div class="playlist-cover-overlay">
        <button type="button" class="change-photo-btn">
            <i class="fas fa-camera"></i>
            <span>Change Photo</span>
        </button>
    </div>
</div>
```

**B. Placeholder Container** (Khi chưa có ảnh)

```jsp
<div class="playlist-cover-container" id="placeholderContainer"
    style="display: ${empty playlist.coverImage ? 'block' : 'none'};">
    <div class="playlist-cover-placeholder">
        <i class="fas fa-image"></i>
        <span class="choose-photo-text">Choose photo</span>
    </div>
</div>
```

**C. Preview Container** (Khi chọn ảnh mới)

```jsp
<div class="cover-preview" id="coverPreview" style="display: none;">
    <img id="previewImage" src="" alt="Cover Preview">
    <button type="button" class="btn-remove-cover" onclick="removeCoverImage()">
        <i class="fas fa-times"></i>
    </button>
    <button type="button" class="btn-save-cover" onclick="saveCoverImage()">
        <i class="fas fa-save"></i>
    </button>
</div>
```

---

### 3. **JavaScript Updates** (Line 586-649)

#### Updated Functions:

**`handleCoverImageUpload()`**

```javascript
function handleCoverImageUpload(event) {
  // ... validation ...

  reader.onload = function (e) {
    const preview = document.getElementById("coverPreview");
    const previewImage = document.getElementById("previewImage");
    const mainContainer = document.getElementById("mainCoverContainer");
    const placeholderContainer = document.getElementById(
      "placeholderContainer"
    );

    // Set preview image
    previewImage.src = e.target.result;

    // Hide main containers and show preview
    if (mainContainer) mainContainer.style.display = "none";
    if (placeholderContainer) placeholderContainer.style.display = "none";
    preview.style.display = "block";
  };
}
```

**`removeCoverImage()`**

```javascript
function removeCoverImage() {
  const preview = document.getElementById("coverPreview");
  const mainContainer = document.getElementById("mainCoverContainer");
  const placeholderContainer = document.getElementById("placeholderContainer");
  const currentCoverImage = document.getElementById("currentCoverImage");

  // Hide preview
  preview.style.display = "none";

  // Show appropriate container based on whether playlist has cover
  if (currentCoverImage && currentCoverImage.src) {
    // Has existing cover - show main container
    mainContainer.style.display = "block";
  } else {
    // No cover - show placeholder
    placeholderContainer.style.display = "block";
  }

  input.value = "";
}
```

---

## 🎨 UI/UX Flow

### Case 1: Playlist CÓ ảnh cover

1. **Initial Display:**

   - Hiển thị `mainCoverContainer` với ảnh cover hiện tại
   - `placeholderContainer` ẩn
   - `coverPreview` ẩn

2. **On Hover:**

   - Overlay xuất hiện với độ mờ đen
   - Button "Change Photo" hiện lên
   - Smooth transition effect

3. **Click to Change:**

   - File picker mở ra
   - Chọn ảnh mới → Preview hiện lên
   - Có button X (remove) và ✓ (save)

4. **After Save:**
   - Form submit → Page reload
   - Hiển thị ảnh mới

---

### Case 2: Playlist CHƯA có ảnh cover

1. **Initial Display:**

   - Hiển thị `placeholderContainer` với icon và text "Choose photo"
   - `mainCoverContainer` ẩn

2. **Click to Upload:**

   - File picker mở ra
   - Chọn ảnh → Preview hiện lên

3. **After Save:**
   - Form submit → Page reload
   - Hiển thị ảnh mới (chuyển sang Case 1)

---

## 📊 Technical Details

### JSTL Conditional Display

```jsp
<!-- Show main container if playlist has coverImage -->
style="display: ${not empty playlist.coverImage ? 'block' : 'none'};"

<!-- Show placeholder if playlist has NO coverImage -->
style="display: ${empty playlist.coverImage ? 'block' : 'none'};"
```

### Fallback Image

```jsp
onerror="this.src='${pageContext.request.contextPath}/assets/img/default-playlist.png'"
```

Nếu ảnh cover không load được, sẽ hiển thị ảnh mặc định.

---

## ✨ Features

| Feature               | Status | Description                                 |
| --------------------- | ------ | ------------------------------------------- |
| Display current cover | ✅     | Shows playlist cover if exists              |
| Hover effect          | ✅     | Overlay with "Change Photo" button on hover |
| Upload new cover      | ✅     | Click to open file picker                   |
| Preview before save   | ✅     | Shows preview with save/cancel buttons      |
| Validation            | ✅     | Max 5MB, JPG/PNG/GIF only                   |
| Fallback image        | ✅     | Shows default if cover not found            |
| Smooth transitions    | ✅     | CSS transitions for better UX               |

---

## 🎯 Result

**Before:**

- ❌ Chỉ có placeholder "Choose photo"
- ❌ Không hiển thị ảnh cover hiện tại
- ❌ UX kém

**After:**

- ✅ Hiển thị ảnh cover đẹp với shadow
- ✅ Button "Change Photo" hiện khi hover
- ✅ Smooth transitions và hover effects
- ✅ Professional UI/UX
- ✅ Clear visual feedback

---

## 💡 Best Practices Applied

1. **Progressive Enhancement**: Placeholder → Current Image → New Image
2. **Visual Feedback**: Hover effects, transitions
3. **Graceful Degradation**: Fallback images
4. **Validation**: File size and type checking
5. **Responsive Design**: Fixed size with proper aspect ratio
6. **Accessibility**: Alt text, semantic HTML

---

## 🚀 Usage

1. **View playlist with cover:**

   - Ảnh hiển thị ngay lập tức
   - Hover để thấy button "Change Photo"

2. **Change cover:**

   - Click vào ảnh hoặc button
   - Chọn file mới
   - Preview → Save
   - Page reload với ảnh mới

3. **Upload first cover:**
   - Click vào placeholder
   - Chọn file
   - Preview → Save
   - Ảnh xuất hiện

Perfect! Playlist cover image feature hoàn chỉnh! 🎵✨
