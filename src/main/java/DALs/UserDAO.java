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
        String base = "SELECT id, name, email, password, avatar, active, gender, role_id, createdAt, updatedAt, createdBy, updatedBy FROM Users";
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
            System.out.println("Error finding users: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    public User findById(long id) {
        String sql = "SELECT id, name, email, password, avatar, active, gender, role_id, createdAt, updatedAt, createdBy, updatedBy FROM Users WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapRowToUser(rs);
        } catch (SQLException e) {
            System.out.println("Error finding user by id: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean create(User u) {
        String sql = "INSERT INTO Users(name, email, password, avatar, active, gender, createdAt, updatedAt, createdBy, updatedBy, role_id) VALUES(?,?,?,?,?,?,?,?,?,?,?)";
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
            // Handle role - set to null if role is null or role id is null
            if (u.getRole() != null && u.getRole().getId() != null) {
                ps.setLong(11, u.getRole().getId());
            } else {
                ps.setNull(11, java.sql.Types.INTEGER);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error creating user: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(User u) {
        String sql = "UPDATE Users SET name=?, email=?, password=?, avatar=?, active=?, gender=?, role_id=?, updatedAt=?, updatedBy=? WHERE id=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, u.getName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getAvatar());
            ps.setBoolean(5, u.isActive());
            ps.setString(6, u.getGender() != null ? u.getGender().name() : null);
            // Handle role - set to null if role is null or role id is null
            if (u.getRole() != null && u.getRole().getId() != null) {
                ps.setLong(7, u.getRole().getId());
            } else {
                ps.setNull(7, java.sql.Types.INTEGER);
            }
            ps.setTimestamp(8, java.sql.Timestamp.from(java.time.Instant.now()));
            ps.setString(9, u.getUpdatedBy());
            ps.setLong(10, u.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating user: " + e.getMessage());
            e.printStackTrace();
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
        
        // Handle role_id - create a simple Role object with just the ID
        Long roleId = rs.getLong("role_id");
        if (!rs.wasNull() && roleId != null) {
            domain.entity.Role role = new domain.entity.Role();
            role.setId(roleId);
            user.setRole(role);
        }
        
        return user;
    }
}