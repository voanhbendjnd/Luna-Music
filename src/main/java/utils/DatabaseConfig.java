package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConfig {
    public Connection connection;

    public DatabaseConfig() {
        try {
            String url = "jdbc:sqlserver://localhost:1433;"
                    + "databaseName=LunaMusic;"
                    + "user=sa;"
                    + "password=1607;"
                    + "encrypt=true;"
                    + "trustServerCertificate=true;";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url);
            System.out.println(">>> Success");
        } catch (ClassNotFoundException | SQLException ex) {
            System.out.println("Database connection failed: " + ex);
        }
    }
}
