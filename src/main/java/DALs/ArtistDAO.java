package DALs;

import domain.entity.Artist;
import utils.DatabaseConfig;

import java.sql.*;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

/**
 * ArtistDAO class for CRUD operations on Artists table
 * 
 * @author Vo Anh Ben - CE190709
 */
public class ArtistDAO extends DatabaseConfig {

    public ArtistDAO() {
        super();
    }

    /**
     * Find all artists with optional keyword search
     */
    public List<Artist> findAll(String keyword) {
        List<Artist> artists = new ArrayList<>();
        String base = "SELECT id, name, bio, image_path, createdAt, updatedAt FROM Artists";
        String where = (keyword != null && !keyword.isBlank()) ? " WHERE name LIKE ? OR bio LIKE ?" : "";
        String sql = base + where + " ORDER BY name ASC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            if (!where.isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                ps.setString(1, kw);
                ps.setString(2, kw);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                artists.add(mapRowToArtist(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error finding artists: " + e.getMessage());
            e.printStackTrace();
        }
        return artists;
    }

    /**
     * Find artist by ID
     */
    public Artist findById(long id) {
        String sql = "SELECT id, name, bio, image_path, createdAt, updatedAt FROM Artists WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRowToArtist(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error finding artist by id: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Find artist by name
     */
    public Artist findByName(String name) {
        String sql = "SELECT id, name, bio, image_path, createdAt, updatedAt FROM Artists WHERE name = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRowToArtist(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error finding artist by name: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Create new artist
     */
    public boolean create(Artist artist) {
        String sql = "INSERT INTO Artists(name, bio, image_path) VALUES(?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, artist.getName());
            ps.setString(2, artist.getBio());
            ps.setString(3, artist.getImagePath());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error creating artist: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update existing artist
     */
    public boolean update(Artist artist) {
        String sql = "UPDATE Artists SET name=?, bio=?, image_path=?, updatedAt=? WHERE id=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, artist.getName());
            ps.setString(2, artist.getBio());
            ps.setString(3, artist.getImagePath());
            ps.setTimestamp(4, Timestamp.from(Instant.now()));
            ps.setLong(5, artist.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating artist: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update existing artist
     */
    public boolean updateNoImage(Artist artist) {
        String sql = "UPDATE Artists SET name=?, bio=?, updatedAt=? WHERE id=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, artist.getName());
            ps.setString(2, artist.getBio());
            ps.setTimestamp(3, Timestamp.from(Instant.now()));
            ps.setLong(4, artist.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating artist: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete artist by ID
     */
    public boolean delete(long id) {
        String sql = "DELETE FROM Artists WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting artist: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Check if artist name exists (for validation)
     */
    public boolean existsByName(String name, Long excludeId) {
        String sql = "SELECT COUNT(*) FROM Artists WHERE name = ?";
        if (excludeId != null) {
            sql += " AND id != ?";
        }

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, name);
            if (excludeId != null) {
                ps.setLong(2, excludeId);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error checking artist name existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get artists count
     */
    public int getCount() {
        String sql = "SELECT COUNT(*) FROM Artists";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error getting artists count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Find artists by song ID (through SongArtists table)
     */
    public List<Artist> findBySongId(long songId) {
        List<Artist> artists = new ArrayList<>();
        String sql = "SELECT a.id, a.name, a.bio, a.image_path, a.createdAt, a.updatedAt " +
                "FROM Artists a " +
                "JOIN SongArtists sa ON a.id = sa.artist_id " +
                "WHERE sa.song_id = ? " +
                "ORDER BY a.name ASC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, songId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                artists.add(mapRowToArtist(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error finding artists by song id: " + e.getMessage());
            e.printStackTrace();
        }
        return artists;
    }

    /**
     * Map ResultSet row to Artist object
     */
    private Artist mapRowToArtist(ResultSet rs) throws SQLException {
        Artist artist = new Artist();
        artist.setId(rs.getLong("id"));
        artist.setName(rs.getString("name"));
        artist.setBio(rs.getString("bio"));
        artist.setImagePath(rs.getString("image_path"));

        // Map timestamps
        Timestamp createdAt = rs.getTimestamp("createdAt");
        if (createdAt != null) {
            artist.setCreatedAt(createdAt.toInstant());
        }
        Timestamp updatedAt = rs.getTimestamp("updatedAt");
        if (updatedAt != null) {
            artist.setUpdatedAt(updatedAt.toInstant());
        }

        return artist;
    }
}
