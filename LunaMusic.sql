-- tạo theo từng bước
-- bươc 1
create database LunaMusic;

-- bước 2
use LunaMusic;
create table Roles(
	id INT IDENTITY(1,1) PRIMARY KEY,
	name nvarchar(50) not null unique,
	description nvarchar(255),
	active bit default 1,
	createdAt datetime default getdate(),
	createdBy nvarchar(50),
	updatedAt datetime default getdate(),
	updatedBy nvarchar(50),
)

create table Users(
	id INT IDENTITY(1,1) PRIMARY KEY,
    name nVARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL, -- Lưu MÃ BĂM của mật khẩu
    email VARCHAR(100) NOT NULL UNIQUE,
    gender varchar(20) null,
	active bit default 1,
	createdAt datetime default getdate(),
	createdBy nvarchar(50),
	updatedAt datetime default getdate(),
	updatedBy nvarchar(50),
	role_id int null,
	    -- Mối quan hệ 1:N với Roles
	CONSTRAINT FK_User_Role FOREIGN KEY (role_id) 
        REFERENCES Roles(id)
        ON DELETE SET NULL, -- Nếu Role bị xóa, User đó sẽ mất Role
    
    -- Ràng buộc kiểm tra cho giới tính (Mô phỏng ENUM)
    CONSTRAINT CK_User_Gender
        CHECK (gender IS NULL OR gender IN ('MALE', 'FEMALE', 'OTHER', 'PREFER_NOT_TO_SAY'))
)
CREATE TABLE Artists (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(150) NOT NULL UNIQUE,
    bio NVARCHAR(MAX) NULL,
    image_path VARCHAR(500) NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE()
);
GO

---------------------------------------------------
-- 5. Bảng Genres (Thể loại)
---------------------------------------------------
CREATE TABLE Genres (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL UNIQUE,
    description NVARCHAR(255) NULL
);
GO

---------------------------------------------------
-- 6. Bảng Albums
---------------------------------------------------
CREATE TABLE Albums (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    artist_id INT NOT NULL,
    release_year INT NULL,
    cover_image_path VARCHAR(500) NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    
    -- Mối quan hệ 1:N với Artists
    CONSTRAINT FK_Album_Artist FOREIGN KEY (artist_id)
        REFERENCES Artists(id)
        ON DELETE CASCADE -- Nếu Artist bị xóa, các Album của họ cũng bị xóa
);
GO

---------------------------------------------------
-- 7. Bảng Songs (Bài hát)
---------------------------------------------------
CREATE TABLE Songs (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL, -- Đường dẫn file MP3/M4A
    duration INT NULL, -- Thời lượng (giây)
    play_count INT DEFAULT 0,
    is_downloadable BIT DEFAULT 1,
    artist_id INT NOT NULL,
    album_id INT NULL,
    genre_id INT NULL,
    
    -- Mối quan hệ Khóa Ngoại
    CONSTRAINT FK_Song_Artist FOREIGN KEY (artist_id) REFERENCES Artists(id),
    CONSTRAINT FK_Song_Album FOREIGN KEY (album_id) REFERENCES Albums(id) ON DELETE SET NULL,
    CONSTRAINT FK_Song_Genre FOREIGN KEY (genre_id) REFERENCES Genres(id) ON DELETE SET NULL,

    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE()
);
-- bước 3
-- tạo dữ liệu cho người dùng admin và user
INSERT INTO Roles (name, description, active)
VALUES 
('ADMIN', N'Người dùng có toàn quyền quản trị hệ thống', 1),
('MEMBER', N'Người dùng thông thường, có thể nghe nhạc và tạo playlist', 1);
GO


INSERT INTO Users (
    name, 
    password, 
    email, 
    gender, 
    active, 
    role_id,
    createdBy,
    updatedBy
)
VALUES (
    N'Quản Trị Viên Chính',  -- Tên Admin
    '4a29a0026e63a8a04b190f8903c15370',
    'admin@lunamusic.com', 
    'MALE', 
	1, 
	1,          -- Gán ID của Role ADMIN
    N'SYSTEM', 
    N'SYSTEM'
);
-- giải thích mối quan hệ role và user 
-- role với user sinh ra là để phân quyền cho người dùng, ví dụ: m tạo 1 tài khoản, m muốn m là người quản lý web và tất cả chức năng của web thì m phải có role là admin, nếu m không tạo role 
-- cho m thì hệ thống sẽ không biêt m là ai và không phân quyền truy cập các api riêng được, url admin thì chỉ có admin truy cập được
-- về quan hệ, m là người dùng, thì m chỉ  có thể có 1 quyền duy nhất, ví dụ m là khách thì m chỉ có thể là role user thông thường không thể là m có role vừa là user vừa là admin, vì admin là 
-- full quyền, nên người dùng chỉ có 1 quyền, còn 1 role thì có thể có nhiều người dùng