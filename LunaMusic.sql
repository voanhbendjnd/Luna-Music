-- tạo theo từng bước
-- bươc 1
create database LunaMusicPro;

-- bước 2
use LunaMusicPro;
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
        CHECK (gender IS NULL OR gender IN ('MALE', 'FEMALE', 'OTHER'))
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
    album_id INT NULL,
    genre_id INT NULL,
    
    -- Mối quan hệ Khóa Ngoại
    CONSTRAINT FK_Song_Album FOREIGN KEY (album_id) REFERENCES Albums(id) ON DELETE SET NULL,
    CONSTRAINT FK_Song_Genre FOREIGN KEY (genre_id) REFERENCES Genres(id) ON DELETE SET NULL,

    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE()
);
GO

---------------------------------------------------
-- 8. Bảng SongArtists (Many-to-Many giữa Songs và Artists)
---------------------------------------------------
CREATE TABLE SongArtists (
    song_id INT NOT NULL,
    artist_id INT NOT NULL,
    PRIMARY KEY (song_id, artist_id),
    
    -- Mối quan hệ Khóa Ngoại
    CONSTRAINT FK_SongArtist_Song FOREIGN KEY (song_id) REFERENCES Songs(id) ON DELETE CASCADE,
    CONSTRAINT FK_SongArtist_Artist FOREIGN KEY (artist_id) REFERENCES Artists(id) ON DELETE CASCADE
);
GO
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

-- bước 4
-- Thêm dữ liệu mẫu cho Artists
INSERT INTO Artists (name, bio, image_path)
VALUES 
(N'Taylor Swift', N'American singer-songwriter known for narrative songs about her personal life', '/uploads/images/taylor_swift.jpg'),
(N'Ed Sheeran', N'English singer-songwriter known for his acoustic folk-pop style', '/uploads/images/ed_sheeran.jpg'),
(N'Ariana Grande', N'American singer and actress known for her wide vocal range', '/uploads/images/ariana_grande.jpg'),
(N'Justin Bieber', N'Canadian singer-songwriter and pop icon', '/uploads/images/justin_bieber.jpg');

-- Thêm dữ liệu mẫu cho Genres
INSERT INTO Genres (name, description)
VALUES 
(N'Pop', N'Popular music with catchy melodies and commercial appeal'),
(N'Rock', N'Music characterized by amplified instruments and strong rhythms'),
(N'Hip Hop', N'Music genre with rhythmic speech and beats'),
(N'R&B', N'Rhythm and blues music with soulful vocals'),
(N'Country', N'Music originating from rural American culture');

-- Thêm dữ liệu mẫu cho Albums
INSERT INTO Albums (title, artist_id, release_year, cover_image_path)
VALUES 
(N'Midnights', 1, 2022, '/uploads/images/midnights_cover.jpg'),
(N'Divide', 2, 2017, '/uploads/images/divide_cover.jpg'),
(N'Positions', 3, 2020, '/uploads/images/positions_cover.jpg'),
(N'Changes', 4, 2020, '/uploads/images/changes_cover.jpg');

-- Thêm dữ liệu mẫu cho Songs
INSERT INTO Songs (title, file_path, duration, play_count, album_id, genre_id)
VALUES 
(N'Anti-Hero', '/uploads/music/anti_hero.mp3', 201, 1500000, 1, 1),
(N'Shake It Off', '/uploads/music/shake_it_off.mp3', 219, 2000000, 1, 1),
(N'Shape of You', '/uploads/music/shape_of_you.mp3', 233, 2500000, 2, 1),
(N'Perfect', '/uploads/music/perfect.mp3', 263, 1800000, 2, 1),
(N'34+35', '/uploads/music/34_35.mp3', 174, 1200000, 3, 1),
(N'positions', '/uploads/music/positions.mp3', 172, 1100000, 3, 1),
(N'Yummy', '/uploads/music/yummy.mp3', 210, 900000, 4, 1),
(N'Holy', '/uploads/music/holy.mp3', 207, 800000, 4, 1);

-- Thêm dữ liệu mẫu cho SongArtists (Many-to-Many relationships)
INSERT INTO SongArtists (song_id, artist_id)
VALUES 
(1, 1), -- Anti-Hero by Taylor Swift
(2, 1), -- Shake It Off by Taylor Swift
(3, 2), -- Shape of You by Ed Sheeran
(4, 2), -- Perfect by Ed Sheeran
(5, 3), -- 34+35 by Ariana Grande
(6, 3), -- positions by Ariana Grande
(7, 4), -- Yummy by Justin Bieber
(8, 4); -- Holy by Justin Bieber
-- giải thích mối quan hệ role và user 
-- role với user sinh ra là để phân quyền cho người dùng, ví dụ: m tạo 1 tài khoản, m muốn m là người quản lý web và tất cả chức năng của web thì m phải có role là admin, nếu m không tạo role 
-- cho m thì hệ thống sẽ không biêt m là ai và không phân quyền truy cập các api riêng được, url admin thì chỉ có admin truy cập được
-- về quan hệ, m là người dùng, thì m chỉ  có thể có 1 quyền duy nhất, ví dụ m là khách thì m chỉ có thể là role user thông thường không thể là m có role vừa là user vừa là admin, vì admin là 
-- full quyền, nên người dùng chỉ có 1 quyền, còn 1 role thì có thể có nhiều người dùng

ALTER TABLE Songs
ADD coverImage VARCHAR(500);