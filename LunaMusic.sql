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
    password VARCHAR(255) NOT NULL, 
    email VARCHAR(100) NOT NULL UNIQUE,
    gender varchar(20) null,
	active bit default 1,
	createdAt datetime default getdate(),
	createdBy nvarchar(50),
	updatedAt datetime default getdate(),
	updatedBy nvarchar(50),
	role_id int null,
    salt nvarchar(255),
	    -- Mối quan hệ 1:N với Roles
	CONSTRAINT FK_User_Role FOREIGN KEY (role_id) 
        REFERENCES Roles(id)
        ON DELETE SET NULL, -- Nếu Role bị xóa, User đó sẽ mất Role
    
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
    coverImage nvarchar(255),
    lyric nvarchar(500),
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

ALTER TABLE Songs
ADD lyric NVARCHAR(MAX);
-- 9. Bảng Playlists (Danh sách phát)
  CREATE TABLE Playlists (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    -- Khóa ngoại trỏ đến chủ sở hữu Playlist
    user_id INT NOT NULL, 
    description NVARCHAR(MAX) NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE(),
    coverImage nvarchar(255),
    -- Mối quan hệ 1:N với Users
    -- LƯU Ý: Thay thế 'Users' bằng tên bảng người dùng thực tế của bạn
    CONSTRAINT FK_Playlist_User FOREIGN KEY (user_id)
        REFERENCES Users(id) 
        ON DELETE CASCADE -- Nếu User bị xóa, tất cả Playlists của họ cũng bị xóa
);
GO

---------------------------------------------------
-- 10. Bảng PlaylistSongs (Bảng liên kết N:N)
---------------------------------------------------
CREATE TABLE PlaylistSongs (
    playlist_id INT NOT NULL,
    song_id INT NOT NULL,
    added_at DATETIME DEFAULT GETDATE(),
    coverImage VARCHAR(500) NULL,
    PRIMARY KEY (playlist_id, song_id), -- Khóa chính kép

    -- Khóa ngoại trỏ đến Playlists
    CONSTRAINT FK_PlaylistSong_Playlist FOREIGN KEY (playlist_id)
        REFERENCES Playlists(id)
        ON DELETE CASCADE, -- Nếu Playlist bị xóa, các liên kết bài hát cũng bị xóa

    -- Khóa ngoại trỏ đến Songs
    CONSTRAINT FK_PlaylistSong_Song FOREIGN KEY (song_id)
        REFERENCES Songs(id)
        ON DELETE CASCADE -- Nếu Bài hát bị xóa, nó sẽ bị xóa khỏi tất cả Playlists
);
GO