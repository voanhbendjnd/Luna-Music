package DALs;

import domain.entity.Genre;
import utils.DatabaseConfig;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * GenreDAO class for CRUD operations on Genres table
 * 
 * @author Vo Anh Ben - CE190709
 */
public class GenreDAO extends DatabaseConfig {

    public GenreDAO() {
        super();
    }

    /**
     * Find all genres with optional keyword search
     */
    public List<Genre> findAll(String keyword) {
        List<Genre> genres = new ArrayList<>();
        String base = "SELECT id, name, description FROM Genres";
        String where = (keyword != null && !keyword.isBlank()) ? " WHERE name LIKE ? OR description LIKE ?" : "";
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
                genres.add(mapRowToGenre(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error finding genres: " + e.getMessage());
            e.printStackTrace();
        }
        return genres;
    }

    /**
     * Find genre by ID
     */
    public Genre findById(long id) {
        String sql = "SELECT id, name, description FROM Genres WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRowToGenre(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error finding genre by id: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Find genre by name
     */
    public Genre findByName(String name) {
        String sql = "SELECT id, name, description FROM Genres WHERE name = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRowToGenre(rs);
            }
        } catch (SQLException e) {
            System.out.println("Error finding genre by name: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Create new genre
     */
    public boolean create(Genre genre) {
        String sql = "INSERT INTO Genres(name, description) VALUES(?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, genre.getName());
            ps.setString(2, genre.getDescription());

            int result = ps.executeUpdate();
            if (result > 0) {
                // Get generated ID
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    genre.setId(generatedKeys.getLong(1));
                }
                return true;
            }
        } catch (SQLException e) {
            System.out.println("Error creating genre: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Update existing genre
     */
    public boolean update(Genre genre) {
        String sql = "UPDATE Genres SET name=?, description=? WHERE id=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, genre.getName());
            ps.setString(2, genre.getDescription());
            ps.setLong(3, genre.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating genre: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Delete genre by ID
     */
    public boolean delete(long id) {
        String sql = "DELETE FROM Genres WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting genre: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Check if genre name exists (for validation)
     */
    public boolean existsByName(String name, Long excludeId) {
        String sql = "SELECT COUNT(*) FROM Genres WHERE name = ?";
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
            System.out.println("Error checking genre name existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Get genres count
     */
    public int getCount() {
        String sql = "SELECT COUNT(*) FROM Genres";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error getting genres count: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Get most popular genres (by song count)
     */
    public List<Genre> getMostPopular(int limit) {
        List<Genre> genres = new ArrayList<>();
        String sql = "SELECT g.id, g.name, g.description, COUNT(s.id) as song_count " +
                "FROM Genres g " +
                "LEFT JOIN Songs s ON g.id = s.genre_id " +
                "GROUP BY g.id, g.name, g.description " +
                "ORDER BY song_count DESC, g.name ASC " +
                "LIMIT ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Genre genre = mapRowToGenre(rs);
                genres.add(genre);
            }
        } catch (SQLException e) {
            System.out.println("Error getting most popular genres: " + e.getMessage());
            e.printStackTrace();
        }
        return genres;
    }

    /**
     * Get genres with song count
     */
    public List<Genre> findAllWithSongCount() {
        List<Genre> genres = new ArrayList<>();
        String sql = "SELECT g.id, g.name, g.description, COUNT(s.id) as song_count " +
                "FROM Genres g " +
                "LEFT JOIN Songs s ON g.id = s.genre_id " +
                "GROUP BY g.id, g.name, g.description " +
                "ORDER BY g.name ASC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Genre genre = mapRowToGenre(rs);
                genres.add(genre);
            }
        } catch (SQLException e) {
            System.out.println("Error getting genres with song count: " + e.getMessage());
            e.printStackTrace();
        }
        return genres;
    }

    /**
     * Map ResultSet row to Genre object
     */
    private Genre mapRowToGenre(ResultSet rs) throws SQLException {
        Genre genre = new Genre();
        genre.setId(rs.getLong("id"));
        genre.setName(rs.getString("name"));
        genre.setDescription(rs.getString("description"));
        return genre;
    }
}
