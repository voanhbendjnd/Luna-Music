# Luna Music - Song CRUD System

## Tổng quan

Hệ thống CRUD hoàn chỉnh cho quản lý bài hát trong Luna Music với khả năng upload file MP3 và hình ảnh.

## Tính năng chính

### 🎵 Song Management

- **Create**: Thêm bài hát mới với upload file MP3
- **Read**: Xem danh sách bài hát với thông tin chi tiết
- **Update**: Chỉnh sửa thông tin bài hát và file
- **Delete**: Xóa bài hát và các mối quan hệ liên quan

### 🎤 Artist Management

- Quản lý nghệ sĩ với mối quan hệ many-to-many với bài hát
- Một bài hát có thể có nhiều nghệ sĩ
- Một nghệ sĩ có thể có nhiều bài hát

### 🎼 Album & Genre Support

- Gán bài hát vào album (optional)
- Phân loại bài hát theo thể loại (optional)
- Upload hình ảnh cover cho album

### 📁 File Upload

- **Audio Files**: MP3, M4A, WAV (tối đa 50MB)
- **Image Files**: JPG, JPEG, PNG, GIF (tối đa 5MB)
- Tự động tạo tên file unique để tránh conflict
- Validation file type và size

## Cấu trúc Database

### Tables

```sql
-- Songs table
CREATE TABLE Songs (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    duration INT NULL,
    play_count INT DEFAULT 0,
    album_id INT NULL,
    genre_id INT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE()
);

-- SongArtists table (Many-to-Many)
CREATE TABLE SongArtists (
    song_id INT NOT NULL,
    artist_id INT NOT NULL,
    PRIMARY KEY (song_id, artist_id)
);
```

## Cấu trúc Code

### Entities

- `Song.java` - Entity chính cho bài hát
- `Artist.java` - Entity cho nghệ sĩ
- `Album.java` - Entity cho album
- `Genre.java` - Entity cho thể loại
- `SongArtist.java` - Entity cho mối quan hệ many-to-many

### DAO Classes

- `SongDAO.java` - CRUD operations cho Songs
- `ArtistDAO.java` - CRUD operations cho Artists
- `AlbumDAO.java` - CRUD operations cho Albums
- `GenreDAO.java` - CRUD operations cho Genres
- `SongArtistDAO.java` - Quản lý mối quan hệ Song-Artist

### Controller

- `AdminController.java` - Xử lý HTTP requests cho Song management
- Hỗ trợ multipart/form-data cho file upload
- Validation và error handling

### JSP Views

- `song.jsp` - Giao diện quản lý bài hát
- Responsive design với Bootstrap
- Audio player tích hợp
- File upload với drag & drop support

## Cách sử dụng

### 1. Truy cập Song Management

```
http://localhost:8080/LunaMusic/admin?action=list&type=songs
```

### 2. Thêm bài hát mới

1. Click "Add Song" button
2. Điền thông tin:
   - **Title**: Tên bài hát (required)
   - **Artists**: Chọn một hoặc nhiều nghệ sĩ (required)
   - **Album**: Chọn album (optional)
   - **Genre**: Chọn thể loại (optional)
   - **Audio File**: Upload file MP3/M4A/WAV (required)
   - **Cover Image**: Upload hình ảnh (optional)
   - **Duration**: Thời lượng (auto-detect hoặc nhập thủ công)

### 3. Chỉnh sửa bài hát

1. Click icon "Edit" trên bài hát cần sửa
2. Thay đổi thông tin cần thiết
3. Upload file mới (nếu muốn thay đổi)
4. Click "Save Changes"

### 4. Xóa bài hát

1. Click icon "Delete" trên bài hát cần xóa
2. Confirm trong modal dialog
3. Bài hát và tất cả mối quan hệ sẽ bị xóa

## File Upload

### Thư mục lưu trữ

```
src/main/webapp/uploads/
├── music/          # Audio files
└── images/         # Image files
```

### URL Access

- Audio files: `http://localhost:8080/LunaMusic/uploads/music/filename.mp3`
- Image files: `http://localhost:8080/LunaMusic/uploads/images/filename.jpg`

## Validation Rules

### File Upload

- **Audio**: MP3, M4A, WAV, tối đa 50MB
- **Images**: JPG, JPEG, PNG, GIF, tối đa 5MB
- Tên file được tự động tạo unique

### Data Validation

- Title: Required, không được để trống
- Artists: Phải chọn ít nhất 1 nghệ sĩ
- File paths: Tự động tạo từ upload

## Error Handling

- File type validation
- File size validation
- Database transaction rollback
- User-friendly error messages
- Logging cho debugging

## Security Features

- File type whitelist
- File size limits
- Unique filename generation
- SQL injection prevention
- XSS protection

## Performance Optimizations

- Batch operations cho Song-Artist relationships
- Lazy loading cho relationships
- Efficient file storage
- Database indexing

## Troubleshooting

### Common Issues

1. **File upload fails**: Kiểm tra file size và type
2. **Audio không play**: Kiểm tra file path và format
3. **Database errors**: Kiểm tra foreign key constraints
4. **Permission errors**: Đảm bảo thư mục uploads có quyền write

### Debug Mode

- Enable console logging trong AdminController
- Check server logs cho detailed errors
- Validate database connections

## Future Enhancements

- [ ] Bulk upload multiple songs
- [ ] Audio metadata extraction
- [ ] Image resizing và optimization
- [ ] Search và filtering nâng cao
- [ ] Playlist management
- [ ] User favorites system
- [ ] Analytics và reporting

## Technical Notes

- Sử dụng Jakarta EE 9.1
- Database: SQL Server
- Frontend: Bootstrap 5, DataTables
- File handling: Java NIO
- Security: Input validation, file type checking
