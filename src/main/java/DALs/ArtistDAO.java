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

    public int countArtist(String key) {
        var sql = "select count(*) total from Artists ";
        var where = (key != null && !key.isEmpty()) ? " where name like ? " :"";
        try {
            var ps = connection.prepareStatement(sql);
            if(!where.isEmpty()){
                ps.setString(1, "%" + key + "%");
            }
            var rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            return 0;
        }
        return 0;
    }
    public List<Artist> findAllWithPagination(String keyword, int limit, int offset) {
        List<Artist> artists = new ArrayList<>();
        String base = "SELECT id, name, bio, image_path, createdAt, updatedAt FROM Artists";
        String where = (keyword != null && !keyword.isBlank()) ? " WHERE name LIKE ? " : "";
        String sql = base + where + " ORDER BY id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            int index = 1;
            if (!where.isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                ps.setString(index++, kw);
            }
            ps.setInt(index++, offset);
            ps.setInt(index++, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                artists.add(mapRowToArtist(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error finding artists: " + e.getMessage());
            return null;
        }
        return artists;
    }

    /**
     * Find all artists with optional keyword search
     */
    public List<Artist> findAll(String keyword) {
        List<Artist> artists = new ArrayList<>();
        String base = "SELECT id, name, bio, image_path, createdAt, updatedAt FROM Artists";
        String where = (keyword != null && !keyword.isBlank()) ? " WHERE name LIKE ? " : "";
        String sql = base + where + " ORDER BY name ASC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            if (!where.isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                ps.setString(1, kw);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                artists.add(mapRowToArtist(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error finding artists: " + e.getMessage());
            return null;
        }
        return artists;
    }
    public List<Artist> fetchAllArtistByGenre(String key){
        var artists = new ArrayList<Artist>();
        var sql = "SELECT a.id, a.name, a.bio, a.image_path, a.createdAt, a.updatedAt FROM Artists a inner join SongArtists sa on sa.artist_id = a.id " +
                "inner join Songs s on sa.song_id = s.id inner join Genres g on g.id = s.genre_id  where g.name = ?";
        try{
            var ps = connection.prepareStatement(sql);
            ps.setString(1, key);
            var rs = ps.executeQuery();
            while(rs.next()){
                var id = rs.getLong("id");
                if(artists.stream().anyMatch(x-> x.getId().equals(id))){
                    continue;
                }
                artists.add(mapRowToArtist(rs));

            }
            return artists;
        }
        catch(SQLException ex){
            return null;
        }
    }

    /**
     * Search artists by name
     */
    public List<Artist> searchByName(String query) {
        return findAll(query);
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

    public boolean delete(long id) {
        try {
            connection.setAutoCommit(false);
            String deleteAlbumsSql = "DELETE FROM Albums WHERE artist_id = ?";
            try (PreparedStatement psAlbums = connection.prepareStatement(deleteAlbumsSql)) {
                psAlbums.setLong(1, id);
                psAlbums.executeUpdate();
            }
            String deleteArtistSql = "DELETE FROM Artists WHERE id = ?";
            int rowsDeleted;
            try (PreparedStatement psArtist = connection.prepareStatement(deleteArtistSql)) {
                psArtist.setLong(1, id);
                rowsDeleted = psArtist.executeUpdate();
            }
            connection.commit();
            return rowsDeleted > 0;
        } catch (SQLException e) {
            try {
                if (connection != null) {
                    connection.rollback();
                }
            } catch (SQLException ex) {
                System.err.println("Rollback failed: " + ex.getMessage());
            }
            System.err.println("Error deleting artist in transaction: " + e.getMessage());

        } finally {
            try {
                if (connection != null) {
                    connection.setAutoCommit(true);
                }
            } catch (SQLException ex) {
                System.err.println("Error resetting AutoCommit: " + ex.getMessage());
            }
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
