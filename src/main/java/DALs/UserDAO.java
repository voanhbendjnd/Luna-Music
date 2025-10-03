package DALs;

import domain.entity.User;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.Instant;

import constant.GenderEnum;
import utils.DatabaseConfig;

/**
 *
 * @author Vo Anh Ben - CE190709
 */
public class UserDAO extends DatabaseConfig {
    public UserDAO() {
        super();
    }

    public String login(String userName, String password) {
        String query = "Select * from Users where email = ? and password = ?;";
        try {
            var pstmt = connection.prepareStatement(query);
            pstmt.setString(1, userName);
            pstmt.setString(2, password);

            var rs = pstmt.executeQuery();
            if (rs.next()) {
                var user = new User();
                String gender = rs.getString("gender");
                GenderEnum g = GenderEnum.valueOf(gender.toUpperCase());
                user.setActive(rs.getBoolean("active"));
                user.setAvatar(rs.getString("avatar"));
                Timestamp createdAtStr = rs.getTimestamp("createdAt");
                Instant createdAt = createdAtStr.toInstant();
                user.setCreatedAt(createdAt);
                Timestamp updatedAtStr = rs.getTimestamp("updatedAt");
                var updatedAt = updatedAtStr.toInstant();
                user.setCreatedBy(rs.getString("createdBy"));
                user.setEmail(rs.getString("email"));
                user.setGender(g);
                user.setId(rs.getLong("id"));
                user.setName(rs.getString("name"));
                user.setPassword(rs.getString("password"));
                user.setUpdatedAt(updatedAt);
                user.setUpdatedBy(rs.getString("updatedBy"));
                return rs.getString("name");
            }

            return "";
        } catch (SQLException e) {
            System.out.println(e);
        }

        return "";
    }

    public java.util.List<User> findAll(String keyword) {
        java.util.List<User> users = new java.util.ArrayList<>();
        String base = "SELECT id, name, email, password, avatar, active, gender, createdAt, updatedAt, createdBy, updatedBy FROM Users";
        String where = (keyword != null && !keyword.isBlank()) ? " WHERE name LIKE ? OR email LIKE ?" : "";
        String sql = base + where + " ORDER BY id DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            if (!where.isEmpty()) {
                String kw = "%" + keyword.trim() + "%";
                ps.setString(1, kw);
                ps.setString(2, kw);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                users.add(mapRowToUser(rs));
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return users;
    }

    public User findById(long id) {
        String sql = "SELECT id, name, email, password, avatar, active, gender, createdAt, updatedAt, createdBy, updatedBy FROM Users WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapRowToUser(rs);
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public boolean create(User u) {
        String sql = "INSERT INTO Users(name, email, password, avatar, active, gender, createdAt, updatedAt, createdBy, updatedBy) VALUES(?,?,?,?,?,?,?,?,?,?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, u.getName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getAvatar());
            ps.setBoolean(5, u.isActive());
            ps.setString(6, u.getGender() != null ? u.getGender().name() : null);
            ps.setTimestamp(7, java.sql.Timestamp.from(java.time.Instant.now()));
            ps.setTimestamp(8, java.sql.Timestamp.from(java.time.Instant.now()));
            ps.setString(9, u.getCreatedBy());
            ps.setString(10, u.getUpdatedBy());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }

    public boolean update(User u) {
        String sql = "UPDATE Users SET name=?, email=?, password=?, avatar=?, active=?, gender=?, updatedAt=?, updatedBy=? WHERE id=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, u.getName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getAvatar());
            ps.setBoolean(5, u.isActive());
            ps.setString(6, u.getGender() != null ? u.getGender().name() : null);
            ps.setTimestamp(7, java.sql.Timestamp.from(java.time.Instant.now()));
            ps.setString(8, u.getUpdatedBy());
            ps.setLong(9, u.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }

    public boolean delete(long id) {
        String sql = "DELETE FROM Users WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }

    private User mapRowToUser(ResultSet rs) throws SQLException {
        User user = new User();
        String gender = rs.getString("gender");
        user.setActive(rs.getBoolean("active"));
        user.setAvatar(rs.getString("avatar"));
        java.sql.Timestamp createdAtStr = rs.getTimestamp("createdAt");
        if (createdAtStr != null)
            user.setCreatedAt(createdAtStr.toInstant());
        java.sql.Timestamp updatedAtStr = rs.getTimestamp("updatedAt");
        if (updatedAtStr != null)
            user.setUpdatedAt(updatedAtStr.toInstant());
        user.setCreatedBy(rs.getString("createdBy"));
        user.setEmail(rs.getString("email"));
        if (gender != null)
            user.setGender(GenderEnum.valueOf(gender.toUpperCase()));
        user.setId(rs.getLong("id"));
        user.setName(rs.getString("name"));
        user.setPassword(rs.getString("password"));
        user.setUpdatedBy(rs.getString("updatedBy"));
        return user;
    }
}