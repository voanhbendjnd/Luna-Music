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
}