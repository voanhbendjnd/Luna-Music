package DALs;

import domain.entity.Album;
import domain.entity.Artist;
import utils.DatabaseConfig;

import java.sql.*;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

/**
 * AlbumDAO class for CRUD operations on Albums table
 * 
 * @author Vo Anh Ben - CE190709
 */
public class AlbumDAO extends DatabaseConfig {

    public AlbumDAO() {
        super();
    }

    /**
     * Find all albums with optional keyword search
     */
    public List<Album> findAll(String keyword) {
        List<Album> albums = new ArrayList<>();
        String base = "SELECT a.id, a.title, a.artist_id, a.release_year, a.cover_image_path, a.createdAt, " +
                "ar.id as artist_id, ar.name as artist_name, ar.bio as artist_bio, ar.image_path as artist_image_path "
                +
                "FROM Albums a " +
                "JOIN Artists ar ON a.artist_id = ar.id";

        String where = (keyword != null && !keyword.isBlank()) ? " WHERE a.title LIKE ? OR ar.name LIKE ?" : "";
        String sql = base + where + " ORDER BY a.createdAt DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            if (!where.isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                ps.setString(1, kw);
                ps.setString(2, kw);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                albums.add(mapRowToAlbum(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error finding albums: " + e.getMessage());
            e.printStackTrace();
        }
        return albums;
    }

    /**
     * Find album by ID
     */
    public Album findById(long id) {
        String sql = "SELECT a.id, a.title, a.artist_id, a.release_year, a.cover_image_path, a.createdAt, " +
                "ar.id as artist_id, ar.name as artist_name, ar.bio as artist_bio, ar.image_path as artist_image_path "
                +
                "FROM Albums a " +
                "JOIN Artists ar ON a.artist_id = ar.id " +
                "WHERE a.id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRowToAlbum(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error finding album by id: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Find albums by artist ID
     */
    public List<Album> findByArtistId(long artistId) {
        List<Album> albums = new ArrayList<>();
        String sql = "SELECT a.id, a.title, a.artist_id, a.release_year, a.cover_image_path, a.createdAt, " +
                "ar.id as artist_id, ar.name as artist_name, ar.bio as artist_bio, ar.image_path as artist_image_path "
                +
                "FROM Albums a " +
                "JOIN Artists ar ON a.artist_id = ar.id " +
                "WHERE a.artist_id = ? " +
                "ORDER BY a.release_year DESC, a.title ASC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, artistId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                albums.add(mapRowToAlbum(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error finding albums by artist: " + e.getMessage());
            e.printStackTrace();
        }
        return albums;
    }

    /**
     * Create new album
     */
    public boolean create(Album album) {
        String sql = "INSERT INTO Albums(title, artist_id, release_year, cover_image_path, createdAt) VALUES(?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, album.getTitle());
            ps.setLong(2, album.getArtist().getId());
            ps.setObject(3, album.getReleaseYear(), Types.INTEGER);
            ps.setString(4, album.getCoverImagePath());
            ps.setTimestamp(5, Timestamp.from(Instant.now()));

            int result = ps.executeUpdate();
            if (result > 0) {
                // Get generated ID
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    album.setId(generatedKeys.getLong(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.out.println("Error creating album: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update existing album
     */
    public boolean update(Album album) {
        String sql = "UPDATE Albums SET title=?, artist_id=?, release_year=?, cover_image_path=? WHERE id=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, album.getTitle());
            ps.setLong(2, album.getArtist().getId());
            ps.setObject(3, album.getReleaseYear(), Types.INTEGER);
            ps.setString(4, album.getCoverImagePath());
            ps.setLong(5, album.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating album: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    /**
     * Update existing album
     */
    public boolean updateNoImage(Album album) {
        String sql = "UPDATE Albums SET title=?, artist_id=?, release_year=? WHERE id=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, album.getTitle());
            ps.setLong(2, album.getArtist().getId());
            ps.setObject(3, album.getReleaseYear(), Types.INTEGER);
            ps.setLong(4, album.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating album: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete album by ID
     */
    public boolean delete(long id) {
        String sql = "DELETE FROM Albums WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting album: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Check if album title exists for an artist (for validation)
     */
    public boolean existsByTitleAndArtist(String title, long artistId, Long excludeId) {
        String sql = "SELECT COUNT(*) FROM Albums WHERE title = ? AND artist_id = ?";
        if (excludeId != null) {
            sql += " AND id != ?";
        }

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, title);
            ps.setLong(2, artistId);
            if (excludeId != null) {
                ps.setLong(3, excludeId);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error checking album title existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get albums count
     */
    public int getCount() {
        String sql = "SELECT COUNT(*) FROM Albums";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error getting albums count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get albums count by artist
     */
    public int getCountByArtist(long artistId) {
        String sql = "SELECT COUNT(*) FROM Albums WHERE artist_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, artistId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error getting albums count by artist: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Find albums by release year
     */
    public List<Album> findByReleaseYear(int year) {
        List<Album> albums = new ArrayList<>();
        String sql = "SELECT a.id, a.title, a.artist_id, a.release_year, a.cover_image_path, a.createdAt, " +
                "ar.id as artist_id, ar.name as artist_name, ar.bio as artist_bio, ar.image_path as artist_image_path "
                +
                "FROM Albums a " +
                "JOIN Artists ar ON a.artist_id = ar.id " +
                "WHERE a.release_year = ? " +
                "ORDER BY a.title ASC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                albums.add(mapRowToAlbum(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error finding albums by release year: " + e.getMessage());
            e.printStackTrace();
        }
        return albums;
    }

    /**
     * Map ResultSet row to Album object
     */
    private Album mapRowToAlbum(ResultSet rs) throws SQLException {
        Album album = new Album();
        album.setId(rs.getLong("id"));
        album.setTitle(rs.getString("title"));
        album.setReleaseYear(rs.getObject("release_year", Integer.class));
        album.setCoverImagePath(rs.getString("cover_image_path"));

        // Map timestamp
        Timestamp createdAt = rs.getTimestamp("createdAt");
        if (createdAt != null) {
            album.setCreatedAt(createdAt.toInstant());
        }

        // Map artist
        Artist artist = new Artist();
        artist.setId(rs.getLong("artist_id"));
        artist.setName(rs.getString("artist_name"));
        artist.setBio(rs.getString("artist_bio"));
        artist.setImagePath(rs.getString("artist_image_path"));
        album.setArtist(artist);

        return album;
    }
}
