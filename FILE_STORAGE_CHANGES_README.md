# File Storage Changes - Luna Music

## Tổng quan thay đổi

Dự án Luna Music đã được cập nhật để thay đổi nơi lưu trữ các file nhạc và hình ảnh từ thư mục `target` sang các thư mục cố định trên máy tính.

## Thay đổi chi tiết

### 1. Thư mục lưu trữ mới

- **File nhạc**: `C:\Users\PC\Documents\FALL25\upload\music`
- **Hình ảnh**: `C:\Users\PC\Documents\FALL25\upload\images`

### 2. Files đã được cập nhật

#### AdminController.java

- Thay đổi `UPLOAD_DIR` thành `BASE_UPLOAD_PATH` với đường dẫn cố định
- Cập nhật logic tạo thư mục upload trong method `handleFileUpload()`

#### FileServlet.java (MỚI)

- Servlet mới để serve các file từ thư mục cố định
- Xử lý security checks để đảm bảo file access an toàn
- Hỗ trợ các loại file: MP3, M4A, WAV, JPG, PNG, GIF
- Cache headers để tối ưu performance

#### web.xml

- Thêm servlet mapping cho `FileServlet`
- Cập nhật URL pattern `/uploads/*` để sử dụng `FileServlet` thay vì default servlet

### 3. Cách thức hoạt động

1. **Upload files**:

   - AdminController nhận file upload
   - Lưu file vào thư mục cố định `C:\Users\PC\Documents\FALL25\upload\[music|images]`
   - Lưu đường dẫn tương đối vào database: `/uploads/music/filename.mp3`

2. **Serve files**:
   - Khi user truy cập `/uploads/music/filename.mp3`
   - FileServlet nhận request và serve file từ thư mục cố định
   - Đảm bảo security và set proper content-type

### 4. Lợi ích

- ✅ **Persistent storage**: Files không bị mất khi rebuild project
- ✅ **Fixed location**: Dễ quản lý và backup files
- ✅ **Security**: Path traversal protection
- ✅ **Performance**: Cache headers cho static files
- ✅ **Flexibility**: Dễ dàng thay đổi đường dẫn storage

### 5. Testing

Để test các thay đổi:

1. **Upload file**: Sử dụng admin panel để upload file nhạc/hình ảnh
2. **Verify storage**: Kiểm tra file có được lưu trong thư mục cố định không
3. **Test access**: Truy cập file qua URL `/uploads/music/filename.mp3`

### 6. URL Access

- **Audio files**: `http://localhost:8080/LunaMusic/uploads/music/filename.mp3`
- **Image files**: `http://localhost:8080/LunaMusic/uploads/images/filename.jpg`

### 7. Backup và Migration

Nếu cần migrate files từ thư mục cũ:

```bash
# Copy files từ target sang thư mục mới
xcopy "target\LunaMusic-1.0-SNAPSHOT\uploads\*" "C:\Users\PC\Documents\FALL25\upload\" /E /I /Y
```

### 8. Troubleshooting

**Lỗi thường gặp:**

1. **Permission denied**: Đảm bảo ứng dụng có quyền ghi vào thư mục
2. **File not found**: Kiểm tra đường dẫn trong database có đúng không
3. **Content-type issues**: FileServlet sẽ tự động detect content-type

**Kiểm tra:**

```powershell
# Kiểm tra thư mục tồn tại
Test-Path "C:\Users\PC\Documents\FALL25\upload\music"
Test-Path "C:\Users\PC\Documents\FALL25\upload\images"

# Kiểm tra quyền ghi
New-Item -ItemType File -Path "C:\Users\PC\Documents\FALL25\upload\music\test.txt" -Force
```

## Kết luận

Việc thay đổi này giúp dự án Luna Music có hệ thống lưu trữ file ổn định và dễ quản lý hơn, đồng thời đảm bảo files không bị mất khi deploy hoặc rebuild project.
