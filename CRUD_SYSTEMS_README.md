# Luna Music - Complete CRUD Systems

## 🎵 Tổng quan

Hệ thống CRUD hoàn chỉnh cho quản lý toàn bộ thư viện nhạc Luna Music với khả năng upload file và quản lý mối quan hệ phức tạp.

## 📋 Các hệ thống CRUD đã tạo

### 1. 🎤 **Artist Management** (`/admin?type=artists`)

- **Tính năng**: Quản lý nghệ sĩ với upload ảnh
- **File**: `src/main/webapp/views/admin/artist.jsp`
- **DAO**: `ArtistDAO.java`
- **Chức năng**:
  - ✅ Create, Read, Update, Delete
  - ✅ Upload ảnh nghệ sĩ (JPG, PNG, GIF)
  - ✅ Bio và thông tin cá nhân
  - ✅ Search theo tên và bio
  - ✅ Image preview và validation

### 2. 🎼 **Album Management** (`/admin?type=albums`)

- **Tính năng**: Quản lý album với upload ảnh cover và chọn artist
- **File**: `src/main/webapp/views/admin/album.jsp`
- **DAO**: `AlbumDAO.java`
- **Chức năng**:
  - ✅ Create, Read, Update, Delete
  - ✅ Upload ảnh cover album
  - ✅ Chọn artist từ dropdown
  - ✅ Năm phát hành (optional)
  - ✅ Search theo title và artist
  - ✅ Image preview và validation

### 3. 🏷️ **Genre Management** (`/admin?type=genres`)

- **Tính năng**: Quản lý thể loại nhạc
- **File**: `src/main/webapp/views/admin/genre.jsp`
- **DAO**: `GenreDAO.java`
- **Chức năng**:
  - ✅ Create, Read, Update, Delete
  - ✅ Tên và mô tả thể loại
  - ✅ Search theo tên và mô tả
  - ✅ Auto-capitalize tên thể loại
  - ✅ Badge styling cho tên thể loại

### 4. 🎵 **Song Management** (`/admin?type=songs`)

- **Tính năng**: Quản lý bài hát với upload MP3 và nhiều nghệ sĩ
- **File**: `src/main/webapp/views/admin/song.jsp`
- **DAO**: `SongDAO.java`, `SongArtistDAO.java`
- **Chức năng**:
  - ✅ Create, Read, Update, Delete
  - ✅ Upload file MP3/M4A/WAV
  - ✅ Multi-select artists (many-to-many)
  - ✅ Chọn album và genre
  - ✅ Audio player tích hợp
  - ✅ Auto-detect duration
  - ✅ Play count tracking

## 🗄️ Database Schema

### Tables được sử dụng:

```sql
-- Artists table
CREATE TABLE Artists (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(150) NOT NULL UNIQUE,
    bio NVARCHAR(MAX) NULL,
    image_path VARCHAR(500) NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE()
);

-- Albums table
CREATE TABLE Albums (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    artist_id INT NOT NULL,
    release_year INT NULL,
    cover_image_path VARCHAR(500) NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Album_Artist FOREIGN KEY (artist_id) REFERENCES Artists(id)
);

-- Genres table
CREATE TABLE Genres (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL UNIQUE,
    description NVARCHAR(255) NULL
);

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
    updatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Song_Album FOREIGN KEY (album_id) REFERENCES Albums(id),
    CONSTRAINT FK_Song_Genre FOREIGN KEY (genre_id) REFERENCES Genres(id)
);

-- SongArtists table (Many-to-Many)
CREATE TABLE SongArtists (
    song_id INT NOT NULL,
    artist_id INT NOT NULL,
    PRIMARY KEY (song_id, artist_id),
    CONSTRAINT FK_SongArtist_Song FOREIGN KEY (song_id) REFERENCES Songs(id),
    CONSTRAINT FK_SongArtist_Artist FOREIGN KEY (artist_id) REFERENCES Artists(id)
);
```

## 🎛️ Controller Architecture

### AdminController.java

- **MultipartConfig**: Hỗ trợ file upload
- **File Upload Handling**: Validation và lưu trữ
- **CRUD Operations**: Xử lý tất cả operations
- **Error Handling**: Comprehensive error management

### Methods chính:

```java
// Song Operations
handleSongOperations()
buildSongFromRequest()

// Artist Operations
handleArtistOperations()
buildArtistFromRequest()

// Album Operations
handleAlbumOperations()
buildAlbumFromRequest()

// Genre Operations
handleGenreOperations()
buildGenreFromRequest()

// File Upload
handleFileUpload()
getFileName()
getFileExtension()
```

## 📁 File Upload System

### Thư mục lưu trữ:

```
src/main/webapp/uploads/
├── music/          # Audio files (MP3, M4A, WAV)
└── images/         # Image files (JPG, PNG, GIF)
```

### Validation Rules:

- **Audio Files**: MP3, M4A, WAV (tối đa 50MB)
- **Image Files**: JPG, JPEG, PNG, GIF (tối đa 5MB)
- **Unique Filenames**: Timestamp prefix để tránh conflict
- **File Type Checking**: Whitelist validation

### URL Access:

- Audio: `http://localhost:8080/LunaMusic/uploads/music/filename.mp3`
- Images: `http://localhost:8080/LunaMusic/uploads/images/filename.jpg`

## 🎨 UI/UX Features

### Responsive Design

- ✅ Bootstrap 5 framework
- ✅ Mobile-friendly tables
- ✅ Responsive modals
- ✅ Touch-friendly buttons

### Interactive Elements

- ✅ Image preview before upload
- ✅ Audio player integration
- ✅ Multi-select for artists
- ✅ Auto-capitalize genre names
- ✅ Loading states during operations

### Data Visualization

- ✅ DataTables integration
- ✅ Search và filtering
- ✅ Pagination
- ✅ Sorting capabilities
- ✅ Badge styling for categories

## 🔗 Entity Relationships

### Relationship Map:

```
Artist (1) ←→ (N) Album
Artist (N) ←→ (N) Song (through SongArtists)
Album (1) ←→ (N) Song
Genre (1) ←→ (N) Song
```

### Navigation Flow:

```
Dashboard → Users/Songs/Artists/Albums/Genres
```

## 🚀 Cách sử dụng

### 1. Truy cập Admin Panel

```
http://localhost:8080/LunaMusic/admin
```

### 2. Navigation Menu

- **Dashboard**: Tổng quan hệ thống
- **User Management**: Quản lý người dùng
- **Song Management**: Quản lý bài hát
- **Artist Management**: Quản lý nghệ sĩ
- **Album Management**: Quản lý album
- **Genre Management**: Quản lý thể loại

### 3. CRUD Operations

Mỗi trang đều có đầy đủ:

- **Create**: Thêm mới với form validation
- **Read**: Xem danh sách với search/filter
- **Update**: Chỉnh sửa với pre-populated data
- **Delete**: Xóa với confirmation dialog

## 🛡️ Security & Validation

### File Upload Security

- File type whitelist
- File size limits
- Unique filename generation
- Path traversal protection

### Data Validation

- Input sanitization
- SQL injection prevention
- XSS protection
- Required field validation

### Error Handling

- Comprehensive error messages
- Transaction rollback
- Graceful failure handling
- User-friendly notifications

## 📊 Performance Optimizations

### Database

- Efficient JOIN queries
- Batch operations for relationships
- Proper indexing
- Connection pooling

### Frontend

- Lazy loading for images
- Efficient DOM manipulation
- Minimal JavaScript
- CSS optimization

## 🔧 Technical Stack

### Backend

- **Java**: Jakarta EE 9.1
- **Database**: SQL Server
- **Architecture**: MVC Pattern
- **File Handling**: Java NIO

### Frontend

- **Framework**: Bootstrap 5
- **Tables**: DataTables
- **Icons**: Font Awesome 6
- **JavaScript**: Vanilla JS

### File Management

- **Upload**: Multipart form data
- **Storage**: Local file system
- **Validation**: Server-side checking
- **Access**: Static resource mapping

## 🎯 Future Enhancements

### Planned Features

- [ ] Bulk upload operations
- [ ] Advanced search filters
- [ ] Image resizing và optimization
- [ ] Audio metadata extraction
- [ ] Export/Import functionality
- [ ] Analytics dashboard
- [ ] User permissions system
- [ ] API endpoints
- [ ] Mobile app support

### Technical Improvements

- [ ] Caching layer
- [ ] CDN integration
- [ ] Database optimization
- [ ] Security enhancements
- [ ] Performance monitoring
- [ ] Automated testing

## 📝 Notes

### Development

- Tất cả code đều có comments đầy đủ
- Consistent coding style
- Error handling comprehensive
- User experience optimized

### Maintenance

- Regular backup procedures
- File cleanup policies
- Database maintenance
- Security updates

### Support

- Comprehensive documentation
- Error logging
- Debug information
- Troubleshooting guides

---

## 🎉 Kết luận

Hệ thống CRUD hoàn chỉnh cho Luna Music đã được tạo thành công với:

✅ **4 hệ thống CRUD đầy đủ** (Song, Artist, Album, Genre)  
✅ **File upload system** với validation  
✅ **Responsive UI/UX** với Bootstrap 5  
✅ **Database relationships** phức tạp  
✅ **Security features** comprehensive  
✅ **Error handling** robust  
✅ **Performance optimizations**

Hệ thống sẵn sàng để sử dụng trong production environment! 🚀
