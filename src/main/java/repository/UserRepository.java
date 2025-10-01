package repository;

import domain.entity.User;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import utils.DatabaseConfig;

/**
 *
 * @author Vo Anh Ben - CE190709
 */
public class UserRepository extends DatabaseConfig {
     public UserRepository (){
         super();
     }
     public String CheckUser(String userName, String password) {
        String query = "Select * from Users where Username = ? and Password = ?;";
        try {
            PreparedStatement pstmt = connection.prepareStatement(query);
            pstmt.setString(1, userName);
            pstmt.setString(2, password);

            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                User cus = new User();
                return rs.getString("Username");
            }
            
            
            return "";
        } catch (SQLException e) {
            System.out.println(e);
        }

        return "";
    }
}