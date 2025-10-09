# Debug Guide - Luna Music Home Page Not Showing Data

## Vấn đề

Giao diện home page hiển thị các section trống (Songs, Popular Artists, Albums) thay vì hiển thị dữ liệu từ database.

## Các bước debug

### 1. Kiểm tra Database Connection

1. Mở trình duyệt và truy cập: `http://localhost:8080/LunaMusic/test`
2. Kiểm tra xem có thông báo "Database connection failed" hay không
3. Nếu có lỗi kết nối, kiểm tra:
   - SQL Server có đang chạy không
   - Database `LunaMusicPro` có tồn tại không
   - Username/password trong `DatabaseConfig.java` có đúng không

### 2. Kiểm tra Database Data

1. Truy cập: `http://localhost:8080/LunaMusic/test-data.html`
2. Click "Test Connection" để kiểm tra kết nối database
3. Click "Test Songs API", "Test Artists API", "Test Albums API" để kiểm tra dữ liệu
4. Click "Test Home Page Data" để kiểm tra home controller

### 3. Kiểm tra Console Logs

1. Mở Tomcat console/logs
2. Truy cập home page: `http://localhost:8080/LunaMusic/`
3. Tìm các log messages:
   - "Starting to load home page data..."
   - "DAO objects created successfully"
   - "Loading trending songs..."
   - "Loaded X songs"
   - "JSP - Trending songs: X"

### 4. Chạy SQL Script

Nếu database trống, chạy script SQL:

```sql
-- Chạy file LunaMusic.sql để tạo database và dữ liệu mẫu
-- Hoặc chạy file check_database.sql để kiểm tra và thêm dữ liệu
```

### 5. Kiểm tra Database Schema

Đảm bảo các bảng được tạo đúng:

```sql
USE LunaMusicPro;
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES;
```

### 6. Kiểm tra Dữ liệu Mẫu

```sql
USE LunaMusicPro;
SELECT COUNT(*) FROM Artists;
SELECT COUNT(*) FROM Albums;
SELECT COUNT(*) FROM Songs;
SELECT COUNT(*) FROM SongArtists;
```

## Các nguyên nhân có thể

### 1. Database Connection Issues

- SQL Server không chạy
- Database không tồn tại
- Sai username/password
- Port không đúng (1433)

### 2. Database Empty

- Chưa chạy script tạo dữ liệu mẫu
- Dữ liệu bị xóa

### 3. DAO Issues

- Lỗi trong SQL queries
- Lỗi mapping dữ liệu
- Lỗi kết nối trong DAO

### 4. JSP Issues

- Lỗi trong JSP code
- Dữ liệu không được truyền từ controller
- Lỗi rendering

## Cách khắc phục

### 1. Nếu Database Connection Failed

```java
// Kiểm tra DatabaseConfig.java
String url = "jdbc:sqlserver://localhost:1433;"
        + "databaseName=LunaMusicPro;"
        + "user=sa;"
        + "password=1607;"
        + "encrypt=true;"
        + "trustServerCertificate=true;";
```

### 2. Nếu Database Empty

Chạy script SQL:

```sql
-- Tạo database
CREATE DATABASE LunaMusicPro;
USE LunaMusicPro;

-- Chạy toàn bộ script trong LunaMusic.sql
```

### 3. Nếu DAO Issues

Kiểm tra SQL queries trong:

- `SongDAO.java`
- `ArtistDAO.java`
- `AlbumDAO.java`

### 4. Nếu JSP Issues

Kiểm tra:

- `home.jsp` có lỗi syntax không
- Dữ liệu có được truyền từ `HomeController.java` không
- Console có lỗi JavaScript không

## Test URLs

- Home Page: `http://localhost:8080/LunaMusic/`
- Database Test: `http://localhost:8080/LunaMusic/test`
- Test Page: `http://localhost:8080/LunaMusic/test-data.html`
- Songs API: `http://localhost:8080/LunaMusic/api/song/`
- Artists API: `http://localhost:8080/LunaMusic/api/artist/`
- Albums API: `http://localhost:8080/LunaMusic/api/album/`

## Expected Results

- Database Test: Hiển thị số lượng records trong mỗi bảng
- API Tests: Trả về JSON data với danh sách songs/artists/albums
- Home Page: Hiển thị cards với dữ liệu thay vì "No data available"

## Debug Logs

Kiểm tra console logs để thấy:

```
Starting to load home page data...
DAO objects created successfully
Loading trending songs...
Loaded 8 songs
Loading popular artists...
Loaded 4 artists
Loading albums...
Loaded 4 albums
Trending songs count: 8
Popular artists count: 4
Albums count: 4
JSP - Trending songs: 8
JSP - Popular artists: 4
JSP - Albums: 4
```

Nếu không thấy các log này, có thể có lỗi trong quá trình load dữ liệu.
