package DALs;

import domain.entity.Song;
import domain.entity.Album;
import domain.entity.Genre;
import domain.entity.SongArtist;
import domain.entity.Artist;
import utils.DatabaseConfig;

import java.sql.*;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

/**
 * SongDAO class for CRUD operations on Songs table
 * 
 * @author Vo Anh Ben - CE190709
 */
public class SongDAO extends DatabaseConfig {

    public SongDAO() {
        super();
    }

    /**
     * Find all songs with optional keyword search
     */
    public List<Song> findAll(String keyword) {
        List<Song> songs = new ArrayList<>();
        String base = "SELECT s.id, s.title, s.file_path, s.coverImage, s.duration, s.play_count, s.album_id, s.genre_id, "
                +
                "s.createdAt, s.updatedAt, " +
                "a.id as album_id, a.title as album_title, a.cover_image_path, " +
                "g.id as genre_id, g.name as genre_name " +
                "FROM Songs s " +
                "LEFT JOIN Albums a ON s.album_id = a.id " +
                "LEFT JOIN Genres g ON s.genre_id = g.id";

        String where = (keyword != null && !keyword.isBlank())
                ? " WHERE s.title LIKE ? OR EXISTS (SELECT 1 FROM SongArtists sa JOIN Artists ar ON sa.artist_id = ar.id WHERE sa.song_id = s.id AND ar.name LIKE ?)"
                : "";
        String sql = base + where + " ORDER BY s.id DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            if (!where.isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                ps.setString(1, kw);
                ps.setString(2, kw);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Song song = mapRowToSong(rs);
                // Load song artists
                song.setSongArtists(findSongArtistsBySongId(song.getId()));
                songs.add(song);
            }
        } catch (SQLException e) {
            System.out.println("Error finding songs: " + e.getMessage());
            e.printStackTrace();
        }
        return songs;
    }

    /**
     * Find song by ID
     */
    public Song findById(long id) {
        String sql = "SELECT s.id, s.title, s.file_path, s.coverImage, s.duration, s.play_count, s.album_id, s.genre_id, "
                +
                "s.createdAt, s.updatedAt, " +
                "a.id as album_id, a.title as album_title, a.cover_image_path, " +
                "g.id as genre_id, g.name as genre_name " +
                "FROM Songs s " +
                "LEFT JOIN Albums a ON s.album_id = a.id " +
                "LEFT JOIN Genres g ON s.genre_id = g.id " +
                "WHERE s.id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Song song = mapRowToSong(rs);
                // Load song artists
                song.setSongArtists(findSongArtistsBySongId(song.getId()));
                return song;
            }
        } catch (SQLException e) {
            System.out.println("Error finding song by id: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Create new song
     */
    public boolean create(Song song) {
        String sql = "INSERT INTO Songs(title, file_path, coverImage, duration, play_count, album_id, genre_id, createdAt, updatedAt) "
                +
                "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, song.getTitle());
            ps.setString(2, song.getFilePath());
            ps.setString(3, song.getCoverImage());
            ps.setObject(4, song.getDuration(), Types.INTEGER);
            ps.setObject(5, song.getPlayCount(), Types.INTEGER);

            // Handle album_id
            if (song.getAlbum() != null && song.getAlbum().getId() != null) {
                ps.setLong(6, song.getAlbum().getId());
            } else {
                ps.setNull(6, Types.INTEGER);
            }

            // Handle genre_id
            if (song.getGenre() != null && song.getGenre().getId() != null) {
                ps.setLong(7, song.getGenre().getId());
            } else {
                ps.setNull(7, Types.INTEGER);
            }

            Instant now = Instant.now();
            ps.setTimestamp(8, Timestamp.from(now));
            ps.setTimestamp(9, Timestamp.from(now));

            int result = ps.executeUpdate();
            if (result > 0) {
                // Get generated ID
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    song.setId(generatedKeys.getLong(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.out.println("Error creating song: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update existing song
     */
    public boolean update(Song song) {
        String sql = "UPDATE Songs SET title=?, file_path=?, coverImage=?, duration=?, play_count=?, album_id=?, genre_id=?, updatedAt=? WHERE id=?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, song.getTitle());
            ps.setString(2, song.getFilePath());
            ps.setString(3, song.getCoverImage());
            ps.setObject(4, song.getDuration(), Types.INTEGER);
            ps.setObject(5, song.getPlayCount(), Types.INTEGER);

            // Handle album_id
            if (song.getAlbum() != null && song.getAlbum().getId() != null) {
                ps.setLong(6, song.getAlbum().getId());
            } else {
                ps.setNull(6, Types.INTEGER);
            }

            // Handle genre_id
            if (song.getGenre() != null && song.getGenre().getId() != null) {
                ps.setLong(7, song.getGenre().getId());
            } else {
                ps.setNull(7, Types.INTEGER);
            }

            ps.setTimestamp(8, Timestamp.from(Instant.now()));
            ps.setLong(9, song.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating song: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update existing song
     */
    public boolean updateNoImage(Song song) {
        String sql = "UPDATE Songs SET title=?, file_path=?, duration=?, play_count=?, album_id=?, genre_id=?, updatedAt=? WHERE id=?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, song.getTitle());
            ps.setString(2, song.getFilePath());
            ps.setObject(3, song.getDuration(), Types.INTEGER);
            ps.setObject(4, song.getPlayCount(), Types.INTEGER);

            // Handle album_id
            if (song.getAlbum() != null && song.getAlbum().getId() != null) {
                ps.setLong(5, song.getAlbum().getId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }

            // Handle genre_id
            if (song.getGenre() != null && song.getGenre().getId() != null) {
                ps.setLong(6, song.getGenre().getId());
            } else {
                ps.setNull(6, Types.INTEGER);
            }

            ps.setTimestamp(7, Timestamp.from(Instant.now()));
            ps.setLong(8, song.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating song: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update existing song
     */
    public boolean updateNoAudioAndImage(Song song) {
        String sql = "UPDATE Songs SET title=?, play_count=?, album_id=?, genre_id=?, updatedAt=? WHERE id=?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, song.getTitle());
            ps.setObject(2, song.getPlayCount(), Types.INTEGER);

            // Handle album_id
            if (song.getAlbum() != null && song.getAlbum().getId() != null) {
                ps.setLong(3, song.getAlbum().getId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            // Handle genre_id
            if (song.getGenre() != null && song.getGenre().getId() != null) {
                ps.setLong(4, song.getGenre().getId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }

            ps.setTimestamp(5, Timestamp.from(Instant.now()));
            ps.setLong(6, song.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating song: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update existing song
     */
    public boolean updateNoAudio(Song song) {
        String sql = "UPDATE Songs SET title=?, coverImage=?, play_count=?, album_id=?, genre_id=?, updatedAt=? WHERE id=?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, song.getTitle());
            ps.setString(2, song.getCoverImage());
            ps.setObject(3, song.getPlayCount(), Types.INTEGER);

            // Handle album_id
            if (song.getAlbum() != null && song.getAlbum().getId() != null) {
                ps.setLong(4, song.getAlbum().getId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }

            // Handle genre_id
            if (song.getGenre() != null && song.getGenre().getId() != null) {
                ps.setLong(5, song.getGenre().getId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }

            ps.setTimestamp(6, Timestamp.from(Instant.now()));
            ps.setLong(7, song.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating song: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete song by ID
     */
    public boolean delete(long id) {
        String sql = "DELETE FROM Songs WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting song: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Find songs by artist ID
     */
    public List<Song> findByArtistId(long artistId) {
        List<Song> songs = new ArrayList<>();
        String sql = "SELECT s.id, s.title, s.file_path, s.coverImage, s.duration, s.play_count, s.album_id, s.genre_id, "
                +
                "s.createdAt, s.updatedAt, " +
                "a.id as album_id, a.title as album_title, a.cover_image_path, " +
                "g.id as genre_id, g.name as genre_name " +
                "FROM Songs s " +
                "LEFT JOIN Albums a ON s.album_id = a.id " +
                "LEFT JOIN Genres g ON s.genre_id = g.id " +
                "JOIN SongArtists sa ON s.id = sa.song_id " +
                "WHERE sa.artist_id = ? " +
                "ORDER BY s.id DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, artistId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Song song = mapRowToSong(rs);
                song.setSongArtists(findSongArtistsBySongId(song.getId()));
                songs.add(song);
            }
        } catch (SQLException e) {
            System.out.println("Error finding songs by artist: " + e.getMessage());
            e.printStackTrace();
        }
        return songs;
    }

    /**
     * Find songs by album ID
     */
    public List<Song> findByAlbumId(long albumId) {
        List<Song> songs = new ArrayList<>();
        String sql = "SELECT s.id, s.title, s.file_path, s.coverImage, s.duration, s.play_count, s.album_id, s.genre_id, "
                +
                "s.createdAt, s.updatedAt, " +
                "a.id as album_id, a.title as album_title, a.cover_image_path, " +
                "g.id as genre_id, g.name as genre_name " +
                "FROM Songs s " +
                "LEFT JOIN Albums a ON s.album_id = a.id " +
                "LEFT JOIN Genres g ON s.genre_id = g.id " +
                "WHERE s.album_id = ? " +
                "ORDER BY s.id DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, albumId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Song song = mapRowToSong(rs);
                song.setSongArtists(findSongArtistsBySongId(song.getId()));
                songs.add(song);
            }
        } catch (SQLException e) {
            System.out.println("Error finding songs by album: " + e.getMessage());
            e.printStackTrace();
        }
        return songs;
    }

    /**
     * Find songs by genre ID
     */
    public List<Song> findByGenreId(long genreId) {
        List<Song> songs = new ArrayList<>();
        String sql = "SELECT s.id, s.title, s.file_path, s.coverImage, s.duration, s.play_count, s.album_id, s.genre_id, "
                +
                "s.createdAt, s.updatedAt, " +
                "a.id as album_id, a.title as album_title, a.cover_image_path, " +
                "g.id as genre_id, g.name as genre_name " +
                "FROM Songs s " +
                "LEFT JOIN Albums a ON s.album_id = a.id " +
                "LEFT JOIN Genres g ON s.genre_id = g.id " +
                "WHERE s.genre_id = ? " +
                "ORDER BY s.id DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, genreId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Song song = mapRowToSong(rs);
                song.setSongArtists(findSongArtistsBySongId(song.getId()));
                songs.add(song);
            }
        } catch (SQLException e) {
            System.out.println("Error finding songs by genre: " + e.getMessage());
            e.printStackTrace();
        }
        return songs;
    }

    /**
     * Update play count for a song
     */
    public boolean incrementPlayCount(long songId) {
        String sql = "UPDATE Songs SET play_count = COALESCE(play_count, 0) + 1 WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, songId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error incrementing play count: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Map ResultSet row to Song object
     */
    private Song mapRowToSong(ResultSet rs) throws SQLException {
        Song song = new Song();
        song.setId(rs.getLong("id"));
        song.setTitle(rs.getString("title"));
        song.setFilePath(rs.getString("file_path"));
        song.setCoverImage(rs.getString("coverImage"));
        song.setDuration(rs.getObject("duration", Integer.class));
        song.setPlayCount(rs.getObject("play_count", Integer.class));

        // Map timestamps
        Timestamp createdAt = rs.getTimestamp("createdAt");
        if (createdAt != null) {
            song.setCreatedAt(createdAt.toInstant());
        }
        Timestamp updatedAt = rs.getTimestamp("updatedAt");
        if (updatedAt != null) {
            song.setUpdatedAt(updatedAt.toInstant());
        }

        // Map album
        Long albumId = rs.getObject("album_id", Long.class);
        if (albumId != null) {
            Album album = new Album();
            album.setId(albumId);
            album.setTitle(rs.getString("album_title"));
            album.setCoverImagePath(rs.getString("cover_image_path"));
            song.setAlbum(album);
        }

        // Map genre
        Long genreId = rs.getObject("genre_id", Long.class);
        if (genreId != null) {
            Genre genre = new Genre();
            genre.setId(genreId);
            genre.setName(rs.getString("genre_name"));
            song.setGenre(genre);
        }

        return song;
    }

    /**
     * Find song artists by song ID
     */
    private List<SongArtist> findSongArtistsBySongId(long songId) {
        List<SongArtist> songArtists = new ArrayList<>();
        String sql = "SELECT sa.song_id, sa.artist_id, a.name as artist_name, a.bio, a.image_path " +
                "FROM SongArtists sa " +
                "JOIN Artists a ON sa.artist_id = a.id " +
                "WHERE sa.song_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, songId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SongArtist songArtist = new SongArtist();

                // Create song object
                Song song = new Song();
                song.setId(rs.getLong("song_id"));
                songArtist.setSong(song);

                // Create artist object
                Artist artist = new Artist();
                artist.setId(rs.getLong("artist_id"));
                artist.setName(rs.getString("artist_name"));
                artist.setBio(rs.getString("bio"));
                artist.setImagePath(rs.getString("image_path"));
                songArtist.setArtist(artist);

                songArtists.add(songArtist);
            }
        } catch (SQLException e) {
            System.out.println("Error finding song artists: " + e.getMessage());
            e.printStackTrace();
        }
        return songArtists;
    }

    /**
     * Find related songs (same album or same artist)
     */
    public List<Song> findRelatedSongs(Long songId, int limit) {
        List<Song> relatedSongs = new ArrayList<>();
        String sql = "SELECT DISTINCT s.id, s.title, s.duration, s.coverImage, s.play_count, s.album_id, s.genre_id, " +
                "s.createdAt, s.updatedAt " +
                "FROM Songs s " +
                "INNER JOIN SongArtist sa ON s.id = sa.song_id " +
                "WHERE sa.artist_id IN ( " +
                "    SELECT sa2.artist_id FROM SongArtist sa2 WHERE sa2.song_id = ? " +
                ") AND s.id != ? " +
                "UNION " +
                "SELECT DISTINCT s.id, s.title, s.duration, s.coverImage, s.play_count, s.album_id, s.genre_id, " +
                "s.createdAt, s.updatedAt " +
                "FROM Songs s " +
                "WHERE s.album_id = (SELECT album_id FROM Songs WHERE id = ?) AND s.id != ? " +
                "ORDER BY play_count DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, songId);
            ps.setLong(2, songId);
            ps.setLong(3, songId);
            ps.setLong(4, songId);

            ResultSet rs = ps.executeQuery();
            int count = 0;
            while (rs.next() && count < limit) {
                relatedSongs.add(mapRowToSong(rs));
                count++;
            }
        } catch (SQLException e) {
            System.out.println("Error finding related songs: " + e.getMessage());
            e.printStackTrace();
        }
        return relatedSongs;
    }
}
