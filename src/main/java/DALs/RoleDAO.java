package DALs;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import domain.entity.Role;
import utils.DatabaseConfig;

public class RoleDAO extends DatabaseConfig {
    public Role mapRowToRole(ResultSet rs) throws SQLException {
        var role = new Role();
        role.setActive(rs.getBoolean("active"));
        role.setDescription(rs.getString("description"));
        role.setId(rs.getLong("id"));
        role.setName(rs.getString("name"));
        role.setCreatedAt(rs.getTimestamp("createdAt").toInstant());
        role.setCreatedBy(rs.getString("createdBy"));
        role.setUpdatedAt(rs.getTimestamp("updatedAt").toInstant());
        role.setUpdatedBy(rs.getString("updatedBy"));
        return role;

    }
    public Role findByName(String name){
        try{
            var sql ="select id, name from Roles where name = ?";
            var ps = connection.prepareStatement(sql);
            ps.setString(1, name);
            var rs = ps.executeQuery();
            if(rs.next()){
                var role = new Role();
                role.setId(rs.getLong("id"));
                role.setName(rs.getString("name"));
                return role;
            }
        }
        catch(SQLException ex){
            return null;
        }
        return null;
    }

    public boolean existsById(Long id) {
        String sql = "select * from Roles where id = ?";
        try {
            var ps = connection.prepareStatement(sql);
            ps.setLong(1, id);
            return ps.executeUpdate() > 0 ? true : false;
        } catch (SQLException ex) {
            return false;
        }
    }

    public Role findById(Long id) {
        String sql = "select * from Roles where id = ?";
        try {
            var ps = connection.prepareStatement(sql);
            ps.setLong(1, id);
            var rs = ps.executeQuery();
            if (rs.next()) {
                return mapRowToRole(rs);
            }
        } catch (SQLException ex) {
            return null;
        }
        return null;
    }

    public List<Role> findAll() {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT id, name, description, active, createdAt, updatedAt, createdBy, updatedBy FROM Roles WHERE active = 1 ORDER BY name ASC";
        try {
            var ps = connection.prepareStatement(sql);
            var rs = ps.executeQuery();
            while (rs.next()) {
                roles.add(mapRowToRole(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error finding roles: " + e.getMessage());
            e.printStackTrace();
        }
        return roles;
    }
}
