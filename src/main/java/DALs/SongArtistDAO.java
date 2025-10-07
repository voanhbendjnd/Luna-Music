package DALs;

import domain.entity.SongArtist;
import domain.entity.Song;
import domain.entity.Artist;
import utils.DatabaseConfig;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * SongArtistDAO class for managing many-to-many relationship between Songs and
 * Artists
 * 
 * @author Vo Anh Ben - CE190709
 */
public class SongArtistDAO extends DatabaseConfig {

    public SongArtistDAO() {
        super();
    }

    /**
     * Create song-artist relationship
     */
    public boolean create(long songId, long artistId) {
        String sql = "INSERT INTO SongArtists(song_id, artist_id) VALUES(?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, songId);
            ps.setLong(2, artistId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error creating song-artist relationship: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Create multiple song-artist relationships
     */
    public boolean createMultiple(long songId, List<Long> artistIds) {
        if (artistIds == null || artistIds.isEmpty()) {
            return true;
        }

        String sql = "INSERT INTO SongArtists(song_id, artist_id) VALUES(?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            for (Long artistId : artistIds) {
                ps.setLong(1, songId);
                ps.setLong(2, artistId);
                ps.addBatch();
            }
            int[] results = ps.executeBatch();

            // Check if all insertions were successful
            for (int result : results) {
                if (result <= 0) {
                    return false;
                }
            }
            return true;
        } catch (SQLException e) {
            System.out.println("Error creating multiple song-artist relationships: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete song-artist relationship
     */
    public boolean delete(long songId, long artistId) {
        String sql = "DELETE FROM SongArtists WHERE song_id = ? AND artist_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, songId);
            ps.setLong(2, artistId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting song-artist relationship: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete all relationships for a song
     */
    public boolean deleteBySongId(long songId) {
        String sql = "DELETE FROM SongArtists WHERE song_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, songId);
            return ps.executeUpdate() >= 0; // >= 0 because it's OK if no relationships exist
        } catch (SQLException e) {
            System.out.println("Error deleting song-artist relationships by song id: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete all relationships for an artist
     */
    public boolean deleteByArtistId(long artistId) {
        String sql = "DELETE FROM SongArtists WHERE artist_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, artistId);
            return ps.executeUpdate() >= 0; // >= 0 because it's OK if no relationships exist
        } catch (SQLException e) {
            System.out.println("Error deleting song-artist relationships by artist id: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update song-artist relationships (delete old ones and create new ones)
     */
    public boolean updateSongArtists(long songId, List<Long> artistIds) {
        try {
            // Start transaction
            connection.setAutoCommit(false);

            // Delete existing relationships
            if (!deleteBySongId(songId)) {
                connection.rollback();
                return false;
            }

            // Create new relationships
            if (artistIds != null && !artistIds.isEmpty()) {
                if (!createMultiple(songId, artistIds)) {
                    connection.rollback();
                    return false;
                }
            }

            // Commit transaction
            connection.commit();
            return true;

        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException rollbackEx) {
                System.out.println("Error during rollback: " + rollbackEx.getMessage());
            }
            System.out.println("Error updating song-artist relationships: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                System.out.println("Error resetting auto-commit: " + e.getMessage());
            }
        }
        return false;
    }

    /**
     * Find all song-artist relationships for a song
     */
    public List<SongArtist> findBySongId(long songId) {
        List<SongArtist> songArtists = new ArrayList<>();
        String sql = "SELECT sa.song_id, sa.artist_id, s.title as song_title, s.file_path, " +
                "a.name as artist_name, a.bio, a.image_path " +
                "FROM SongArtists sa " +
                "JOIN Songs s ON sa.song_id = s.id " +
                "JOIN Artists a ON sa.artist_id = a.id " +
                "WHERE sa.song_id = ? " +
                "ORDER BY a.name ASC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, songId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                songArtists.add(mapRowToSongArtist(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error finding song-artist relationships by song id: " + e.getMessage());
            e.printStackTrace();
        }
        return songArtists;
    }

    /**
     * Find all song-artist relationships for an artist
     */
    public List<SongArtist> findByArtistId(long artistId) {
        List<SongArtist> songArtists = new ArrayList<>();
        String sql = "SELECT sa.song_id, sa.artist_id, s.title as song_title, s.file_path, " +
                "a.name as artist_name, a.bio, a.image_path " +
                "FROM SongArtists sa " +
                "JOIN Songs s ON sa.song_id = s.id " +
                "JOIN Artists a ON sa.artist_id = a.id " +
                "WHERE sa.artist_id = ? " +
                "ORDER BY s.title ASC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, artistId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                songArtists.add(mapRowToSongArtist(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error finding song-artist relationships by artist id: " + e.getMessage());
            e.printStackTrace();
        }
        return songArtists;
    }

    /**
     * Check if song-artist relationship exists
     */
    public boolean exists(long songId, long artistId) {
        String sql = "SELECT COUNT(*) FROM SongArtists WHERE song_id = ? AND artist_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, songId);
            ps.setLong(2, artistId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error checking song-artist relationship existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get artist IDs for a song
     */
    public List<Long> getArtistIdsBySongId(long songId) {
        List<Long> artistIds = new ArrayList<>();
        String sql = "SELECT artist_id FROM SongArtists WHERE song_id = ? ORDER BY artist_id ASC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, songId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                artistIds.add(rs.getLong("artist_id"));
            }
        } catch (SQLException e) {
            System.out.println("Error getting artist IDs by song id: " + e.getMessage());
            e.printStackTrace();
        }
        return artistIds;
    }

    /**
     * Get song IDs for an artist
     */
    public List<Long> getSongIdsByArtistId(long artistId) {
        List<Long> songIds = new ArrayList<>();
        String sql = "SELECT song_id FROM SongArtists WHERE artist_id = ? ORDER BY song_id ASC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, artistId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                songIds.add(rs.getLong("song_id"));
            }
        } catch (SQLException e) {
            System.out.println("Error getting song IDs by artist id: " + e.getMessage());
            e.printStackTrace();
        }
        return songIds;
    }

    /**
     * Get count of songs for an artist
     */
    public int getSongCountByArtistId(long artistId) {
        String sql = "SELECT COUNT(*) FROM SongArtists WHERE artist_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, artistId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error getting song count by artist id: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get count of artists for a song
     */
    public int getArtistCountBySongId(long songId) {
        String sql = "SELECT COUNT(*) FROM SongArtists WHERE song_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, songId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error getting artist count by song id: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Map ResultSet row to SongArtist object
     */
    private SongArtist mapRowToSongArtist(ResultSet rs) throws SQLException {
        SongArtist songArtist = new SongArtist();

        // Create and set song
        Song song = new Song();
        song.setId(rs.getLong("song_id"));
        song.setTitle(rs.getString("song_title"));
        song.setFilePath(rs.getString("file_path"));
        songArtist.setSong(song);

        // Create and set artist
        Artist artist = new Artist();
        artist.setId(rs.getLong("artist_id"));
        artist.setName(rs.getString("artist_name"));
        artist.setBio(rs.getString("bio"));
        artist.setImagePath(rs.getString("image_path"));
        songArtist.setArtist(artist);

        return songArtist;
    }
}
