-- Script to check and populate database
USE LunaMusicPro;

-- Check if tables exist and have data
SELECT 'Artists' as TableName, COUNT(*) as Count FROM Artists
UNION ALL
SELECT 'Albums', COUNT(*) FROM Albums
UNION ALL
SELECT 'Songs', COUNT(*) FROM Songs
UNION ALL
SELECT 'Genres', COUNT(*) FROM Genres
UNION ALL
SELECT 'SongArtists', COUNT(*) FROM SongArtists;

-- Check if lyric column exists
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Songs' AND COLUMN_NAME = 'lyric';

-- If lyric column doesn't exist, add it
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Songs' AND COLUMN_NAME = 'lyric')
BEGIN
    ALTER TABLE Songs ADD lyric NVARCHAR(255);
    PRINT 'Added lyric column to Songs table';
END
ELSE
BEGIN
    PRINT 'Lyric column already exists';
END

-- Insert sample data if tables are empty
IF NOT EXISTS (SELECT 1 FROM Artists)
BEGIN
    INSERT INTO Artists (name, bio, image_path)
    VALUES 
    (N'Taylor Swift', N'American singer-songwriter known for narrative songs about her personal life', '/uploads/images/taylor_swift.jpg'),
    (N'Ed Sheeran', N'English singer-songwriter known for his acoustic folk-pop style', '/uploads/images/ed_sheeran.jpg'),
    (N'Ariana Grande', N'American singer and actress known for her wide vocal range', '/uploads/images/ariana_grande.jpg'),
    (N'Justin Bieber', N'Canadian singer-songwriter and pop icon', '/uploads/images/justin_bieber.jpg');
    PRINT 'Inserted sample artists';
END

IF NOT EXISTS (SELECT 1 FROM Genres)
BEGIN
    INSERT INTO Genres (name, description)
    VALUES 
    (N'Pop', N'Popular music with catchy melodies and commercial appeal'),
    (N'Rock', N'Music characterized by amplified instruments and strong rhythms'),
    (N'Hip Hop', N'Music genre with rhythmic speech and beats'),
    (N'R&B', N'Rhythm and blues music with soulful vocals'),
    (N'Country', N'Music originating from rural American culture');
    PRINT 'Inserted sample genres';
END

IF NOT EXISTS (SELECT 1 FROM Albums)
BEGIN
    INSERT INTO Albums (title, artist_id, release_year, cover_image_path)
    VALUES 
    (N'Midnights', 1, 2022, '/uploads/images/midnights_cover.jpg'),
    (N'Divide', 2, 2017, '/uploads/images/divide_cover.jpg'),
    (N'Positions', 3, 2020, '/uploads/images/positions_cover.jpg'),
    (N'Changes', 4, 2020, '/uploads/images/changes_cover.jpg');
    PRINT 'Inserted sample albums';
END

IF NOT EXISTS (SELECT 1 FROM Songs)
BEGIN
    INSERT INTO Songs (title, file_path, duration, play_count, album_id, genre_id, lyric)
    VALUES 
    (N'Anti-Hero', '/uploads/music/anti_hero.mp3', 201, 1500000, 1, 1, N'I have this thing where I get older but just never wiser'),
    (N'Shake It Off', '/uploads/music/shake_it_off.mp3', 219, 2000000, 1, 1, N'I stay out too late, got nothing in my brain'),
    (N'Shape of You', '/uploads/music/shape_of_you.mp3', 233, 2500000, 2, 1, N'The club isnt the best place to find a lover'),
    (N'Perfect', '/uploads/music/perfect.mp3', 263, 1800000, 2, 1, N'I found a love for me, darling just dive right in'),
    (N'34+35', '/uploads/music/34_35.mp3', 174, 1200000, 3, 1, N'You might think Im crazy the way Ive been cravin'),
    (N'positions', '/uploads/music/positions.mp3', 172, 1100000, 3, 1, N'Heaven sent you to me'),
    (N'Yummy', '/uploads/music/yummy.mp3', 210, 900000, 4, 1, N'Yeah, you got that yummy, yum'),
    (N'Holy', '/uploads/music/holy.mp3', 207, 800000, 4, 1, N'You are holy, holy, holy');
    PRINT 'Inserted sample songs';
END

IF NOT EXISTS (SELECT 1 FROM SongArtists)
BEGIN
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
    PRINT 'Inserted sample song-artist relationships';
END

-- Final check
SELECT 'Final Counts:' as Info;
SELECT 'Artists' as TableName, COUNT(*) as Count FROM Artists
UNION ALL
SELECT 'Albums', COUNT(*) FROM Albums
UNION ALL
SELECT 'Songs', COUNT(*) FROM Songs
UNION ALL
SELECT 'Genres', COUNT(*) FROM Genres
UNION ALL
SELECT 'SongArtists', COUNT(*) FROM SongArtists;
