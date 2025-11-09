package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbConnect {
    
    // Database connection parameters
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/english?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "";
    
    // Load driver once at startup
    static {
        try {
            Class.forName(DB_DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL Driver not found: " + e.getMessage());
        }
    }
    
    // get database connection
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
            if (conn == null) {
                throw new SQLException("Failed to create database connection");
            }
            return conn;
        } catch (SQLException e) {
            System.err.println("Database connection failed: " + e.getMessage());
            throw e;
        }
    }
    
    // test database connection
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            System.err.println("Database connection test failed: " + e.getMessage());
            return false;
        }
    }
    
    // get database configuration info
    public static String getDbUrl() {
        return DB_URL;
    }
    
    public static String getDbUsername() {
        return DB_USERNAME;
    }
    
    public static String getDbDriver() {
        return DB_DRIVER;
    }
    
    // print database configuration for debugging
    public static void printConfiguration() {
        System.out.println("=== Database Configuration ===");
        System.out.println("Driver: " + DB_DRIVER);
        System.out.println("URL: " + DB_URL);
        System.out.println("Username: " + DB_USERNAME);
        System.out.println("Connection Test: " + (testConnection() ? "SUCCESS" : "FAILED"));
        System.out.println("=============================");
    }
} 