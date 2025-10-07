-- Script để test database và tạo lại bảng SongArtists nếu cần
USE LunaMusic;

-- Kiểm tra xem bảng SongArtists có tồn tại không
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='SongArtists' AND xtype='U')
BEGIN
    PRINT 'Creating SongArtists table...'
    
    CREATE TABLE SongArtists (
        song_id INT NOT NULL,
        artist_id INT NOT NULL,
        PRIMARY KEY (song_id, artist_id),
        
        -- Mối quan hệ Khóa Ngoại
        CONSTRAINT FK_SongArtist_Song FOREIGN KEY (song_id) REFERENCES Songs(id) ON DELETE CASCADE,
        CONSTRAINT FK_SongArtist_Artist FOREIGN KEY (artist_id) REFERENCES Artists(id) ON DELETE CASCADE
    );
    
    PRINT 'SongArtists table created successfully!'
END
ELSE
BEGIN
    PRINT 'SongArtists table already exists!'
END

-- Kiểm tra dữ liệu hiện tại
SELECT 'Artists count:' as Info, COUNT(*) as Count FROM Artists
UNION ALL
SELECT 'Albums count:', COUNT(*) FROM Albums
UNION ALL
SELECT 'Songs count:', COUNT(*) FROM Songs
UNION ALL
SELECT 'SongArtists count:', COUNT(*) FROM SongArtists
UNION ALL
SELECT 'Genres count:', COUNT(*) FROM Genres;

-- Kiểm tra Songs với Artists
SELECT 
    s.id as SongID,
    s.title as SongTitle,
    STRING_AGG(a.name, ', ') as Artists
FROM Songs s
LEFT JOIN SongArtists sa ON s.id = sa.song_id
LEFT JOIN Artists a ON sa.artist_id = a.id
GROUP BY s.id, s.title
ORDER BY s.id;
