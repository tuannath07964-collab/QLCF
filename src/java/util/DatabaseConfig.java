package util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * Secure database configuration with HikariCP connection pooling.
 * Credentials are loaded from environment variables or system properties.
 */
public class DatabaseConfig {
    
    private static HikariDataSource dataSource;
    
    static {
        try {
            // Load configuration from environment variables or use defaults
            String hostname = System.getenv("DB_HOST");
            if (hostname == null) {
                hostname = System.getProperty("db.host", "localhost");
            }
            
            String port = System.getenv("DB_PORT");
            if (port == null) {
                port = System.getProperty("db.port", "1433");
            }
            
            String dbname = System.getenv("DB_NAME");
            if (dbname == null) {
                dbname = System.getProperty("db.name", "QLCF");
            }
            
            String username = System.getenv("DB_USER");
            if (username == null) {
                username = System.getProperty("db.user", "sa");
            }
            
            String password = System.getenv("DB_PASSWORD");
            if (password == null) {
                password = System.getProperty("db.password", "");
            }
            
            // HikariCP configuration
            HikariConfig config = new HikariConfig();
            
            String url = String.format(
                "jdbc:sqlserver://%s:%s;databaseName=%s;encrypt=true;trustServerCertificate=true",
                hostname, port, dbname
            );
            
            config.setJdbcUrl(url);
            config.setUsername(username);
            config.setPassword(password);
            
            // Connection pool settings
            int maxPoolSize = Integer.parseInt(
                System.getenv("DB_POOL_MAX") != null ? 
                    System.getenv("DB_POOL_MAX") : 
                    System.getProperty("db.pool.max-size", "20")
            );
            int minIdle = Integer.parseInt(
                System.getenv("DB_POOL_MIN") != null ? 
                    System.getenv("DB_POOL_MIN") : 
                    System.getProperty("db.pool.min-idle", "5")
            );
            
            config.setMaximumPoolSize(maxPoolSize);
            config.setMinimumIdle(minIdle);
            config.setConnectionTimeout(30000);
            config.setIdleTimeout(600000);
            config.setMaxLifetime(1800000);
            
            // Driver class
            config.setDriverClassName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            
            // Auto commit false for transaction control
            config.setAutoCommit(true);
            
            dataSource = new HikariDataSource(config);
            System.out.println("[DatabaseConfig] Connection pool initialized successfully");
            System.out.println("[DatabaseConfig] Max Pool Size: " + maxPoolSize);
            System.out.println("[DatabaseConfig] Min Idle: " + minIdle);
            
        } catch (Exception e) {
            System.err.println("[DatabaseConfig] CRITICAL ERROR: Failed to initialize database connection pool");
            e.printStackTrace();
            throw new RuntimeException("Database configuration failed", e);
        }
    }
    
    /**
     * Get a connection from the pool.
     * @return Connection from HikariCP pool
     * @throws SQLException if connection cannot be obtained
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("Database connection pool not initialized");
        }
        return dataSource.getConnection();
    }
    
    /**
     * Get the data source for advanced operations.
     * @return HikariDataSource instance
     */
    public static HikariDataSource getDataSource() {
        return dataSource;
    }
    
    /**
     * Close the connection pool (call on application shutdown).
     */
    public static void close() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            System.out.println("[DatabaseConfig] Connection pool closed");
        }
    }
}
