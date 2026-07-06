package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final String DRIVER =
            "com.microsoft.sqlserver.jdbc.SQLServerDriver";

    private static final String URL =
            "jdbc:sqlserver://localhost:1433;"
            + "databaseName=QLCF;"
            + "encrypt=true;"
            + "trustServerCertificate=true";

    private static final String USER = "sa";

    private static final String PASSWORD = "admin";

    public static Connection getConnection() {

        Connection conn = null;

        try {

            Class.forName(DRIVER);

            conn = DriverManager.getConnection(URL, USER, PASSWORD);

            System.out.println("Kết nối thành công!");

        } catch (Exception e) {

            e.printStackTrace();

        }

        return conn;

    }

}