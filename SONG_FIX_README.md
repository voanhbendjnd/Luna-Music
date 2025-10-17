# 🔧 Fix Song Management Issues

PS C:\Users\PC\Documents\FALL25\PRJ301\ProjectFinal\Luna-Music> git merge auth
Updating 26aeb7b..a282000
error: Your local changes to the following files would be overwritten by merge:
target/classes/DALs/RoleDAO.class
target/classes/DALs/UserDAO.class
target/classes/controllers/LoginController.class
target/classes/controllers/RegisterController.class
target/classes/domain/entity/User.class
Please commit your changes or stash them before you merge.
Aborting
git restore target/

## 🚨 Vấn đề đã xác định

### 1. **Database Schema không khớp**

- File `LunaMusic.sql` thiếu bảng `SongArtists`
- Code sử dụng many-to-many relationship nhưng database chỉ có 1-1 relationship
- Điều này khiến `song.jsp` không hiển thị được bài hát và không thể thêm bài hát mới

### 2. **Missing Data**

- Database chưa có dữ liệu mẫu để test
- Không có Artists, Albums, Genres để populate dropdown trong form

## ✅ Giải pháp đã thực hiện

### 1. **Cập nhật Database Schema**

Đã sửa file `LunaMusic.sql`:

```sql
-- Bảng Songs (đã loại bỏ artist_id)
CREATE TABLE Songs (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    duration INT NULL,
    play_count INT DEFAULT 0,
    is_downloadable BIT DEFAULT 1,
    album_id INT NULL,
    genre_id INT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Song_Album FOREIGN KEY (album_id) REFERENCES Albums(id) ON DELETE SET NULL,
    CONSTRAINT FK_Song_Genre FOREIGN KEY (genre_id) REFERENCES Genres(id) ON DELETE SET NULL
);

-- Bảng SongArtists (Many-to-Many)
CREATE TABLE SongArtists (
    song_id INT NOT NULL,
    artist_id INT NOT NULL,
    PRIMARY KEY (song_id, artist_id),
    CONSTRAINT FK_SongArtist_Song FOREIGN KEY (song_id) REFERENCES Songs(id) ON DELETE CASCADE,
    CONSTRAINT FK_SongArtist_Artist FOREIGN KEY (artist_id) REFERENCES Artists(id) ON DELETE CASCADE
);
```

### 2. **Thêm dữ liệu mẫu**

Đã thêm sample data cho:

- **4 Artists**: Taylor Swift, Ed Sheeran, Ariana Grande, Justin Bieber
- **5 Genres**: Pop, Rock, Hip Hop, R&B, Country
- **4 Albums**: Midnights, Divide, Positions, Changes
- **8 Songs**: Với file paths và relationships
- **8 SongArtists relationships**: Liên kết songs với artists

### 3. **Sửa lỗi code**

- Loại bỏ commented code trong `ArtistDAO.java`
- Database schema giờ đã khớp với code logic

## 🚀 Cách triển khai

### Bước 1: Chạy lại Database Script

```sql
-- Chạy file LunaMusic.sql để tạo lại database với schema mới
-- Hoặc chạy test_database.sql để kiểm tra và tạo bảng SongArtists nếu cần
```

### Bước 2: Kiểm tra Database Connection

- Đảm bảo `DatabaseConfig.java` kết nối đúng database
- Test connection trong `AdminController`

### Bước 3: Test Song Management

1. Truy cập `/admin?action=list&type=songs`
2. Kiểm tra danh sách bài hát hiển thị
3. Test thêm bài hát mới
4. Test edit/delete bài hát

## 📋 Checklist

- [x] Tạo bảng `SongArtists` trong database
- [x] Loại bỏ `artist_id` từ bảng `Songs`
- [x] Thêm sample data cho Artists, Albums, Genres
- [x] Thêm sample Songs với relationships
- [x] Sửa commented code trong ArtistDAO
- [x] Tạo test script để verify database

## 🎯 Kết quả mong đợi

Sau khi fix:

1. **song.jsp** sẽ hiển thị danh sách bài hát có sẵn
2. **Form thêm bài hát** sẽ có dropdown Artists, Albums, Genres
3. **Upload file** sẽ hoạt động bình thường
4. **CRUD operations** sẽ hoạt động đầy đủ

## 🔍 Debug Tips

Nếu vẫn có lỗi:

1. Kiểm tra console logs trong browser
2. Kiểm tra server logs
3. Verify database connection
4. Check file upload permissions
5. Verify database schema matches code expectations
