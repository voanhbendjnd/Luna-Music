# Luna Music - Music Player Interface

## Tổng quan

Đã cập nhật giao diện Luna Music với các tính năng mới theo yêu cầu:

### 1. Cập nhật Database

- Thêm trường `lyric` vào bảng `Songs` (NVARCHAR(255))
- Cập nhật entity `Song.java` với getter/setter cho `lyric`
- Cập nhật `SongDAO.java` để hỗ trợ trường `lyric`

### 2. Giao diện Home mới

- **Songs Section**: Hiển thị danh sách bài hát với hình ảnh album
- **Popular Artists Section**: Hiển thị nghệ sĩ phổ biến với hình ảnh tròn
- **Albums Section**: Hiển thị album với hình ảnh cover

### 3. Modal System

Tạo hệ thống modal hoàn chỉnh với các loại:

#### Song Detail Modal

- Hiển thị thông tin chi tiết bài hát
- Album art, tên bài hát, nghệ sĩ
- Nút phát nhạc, thêm vào queue, download
- Hiển thị lyrics
- Thông tin nghệ sĩ và bài hát gợi ý

#### Artist Detail Modal

- Thông tin nghệ sĩ với hình ảnh
- Danh sách bài hát phổ biến của nghệ sĩ
- Nút phát tất cả bài hát
- Artist pick section

#### Album Detail Modal

- Thông tin album với cover art
- Tracklist đầy đủ
- Nút phát tất cả bài hát trong album
- Thông tin nghệ sĩ và năm phát hành

#### Now Playing Modal

- Giao diện phát nhạc full-screen
- Album art lớn
- Điều khiển phát nhạc (play/pause, next/previous, shuffle, repeat)
- Progress bar có thể click để seek
- Hiển thị lyrics
- Bottom bar với điều khiển cơ bản

### 4. API Endpoints

Tạo các API controllers để hỗ trợ modal:

#### Song API (`/api/song/*`)

- `GET /api/song/` - Lấy tất cả bài hát
- `GET /api/song/{id}` - Lấy bài hát theo ID
- `POST /api/song/` - Tạo bài hát mới
- `PUT /api/song/{id}` - Cập nhật bài hát
- `DELETE /api/song/{id}` - Xóa bài hát

#### Artist API (`/api/artist/*`)

- `GET /api/artist/` - Lấy tất cả nghệ sĩ
- `GET /api/artist/{id}` - Lấy nghệ sĩ theo ID
- `GET /api/artist/{id}/songs` - Lấy bài hát của nghệ sĩ
- `POST /api/artist/` - Tạo nghệ sĩ mới
- `PUT /api/artist/{id}` - Cập nhật nghệ sĩ
- `DELETE /api/artist/{id}` - Xóa nghệ sĩ

#### Album API (`/api/album/*`)

- `GET /api/album/` - Lấy tất cả album
- `GET /api/album/{id}` - Lấy album theo ID
- `GET /api/album/{id}/tracks` - Lấy tracks của album
- `POST /api/album/` - Tạo album mới
- `PUT /api/album/{id}` - Cập nhật album
- `DELETE /api/album/{id}` - Xóa album

### 5. Tính năng tương tác

- Click vào bài hát → Mở modal chi tiết bài hát → Có thể phát nhạc
- Click vào nghệ sĩ → Mở modal nghệ sĩ → Chọn bài hát → Mở modal chi tiết → Phát nhạc
- Click vào album → Mở modal album → Chọn bài hát → Mở modal chi tiết → Phát nhạc
- Phát nhạc → Mở Now Playing modal với giao diện đầy đủ

### 6. Files đã tạo/cập nhật

#### Backend

- `src/main/java/domain/entity/Song.java` - Thêm trường lyric
- `src/main/java/DALs/SongDAO.java` - Cập nhật hỗ trợ lyric
- `src/main/java/DALs/AlbumDAO.java` - Thêm songCount và totalDuration
- `src/main/java/DALs/ArtistDAO.java` - Thêm phương thức findAll()
- `src/main/java/controllers/HomeController.java` - Cập nhật truyền dữ liệu
- `src/main/java/controllers/api/SongController.java` - API controller mới
- `src/main/java/controllers/api/ArtistController.java` - API controller mới
- `src/main/java/controllers/api/AlbumController.java` - API controller mới
- `src/main/webapp/WEB-INF/web.xml` - Thêm mapping cho API
- `pom.xml` - Thêm dependency Gson

#### Frontend

- `src/main/webapp/views/home.jsp` - Giao diện home mới
- `src/main/webapp/views/layouts/defaultLayout.jsp` - Thêm CSS/JS
- `src/main/webapp/assets/css/modal.css` - CSS cho modal system
- `src/main/webapp/assets/js/modal.js` - JavaScript cho modal system

### 7. Cách sử dụng

1. Chạy ứng dụng với Tomcat
2. Truy cập trang home
3. Click vào các card để mở modal tương ứng
4. Sử dụng các nút điều khiển để phát nhạc
5. Modal Now Playing sẽ hiển thị khi phát nhạc

### 8. Lưu ý

- Cần có dữ liệu trong database để hiển thị
- Đảm bảo đường dẫn hình ảnh và file nhạc đúng
- Modal responsive trên mobile
- Sử dụng Font Awesome cho icons
- Hỗ trợ CORS cho API calls

### 9. Database Schema Update

```sql
ALTER TABLE Songs
ADD lyric NVARCHAR(255);
```

Đã hoàn thành tất cả yêu cầu theo hình ảnh mẫu!
