package dao;

import java.sql.*;

public class DbUtil {
    
    public static void closeResources(AutoCloseable... resources) {
        for (AutoCloseable resource : resources) {
            if (resource != null) {
                try {
                    resource.close();
                } catch (Exception e) {
                    // Silent close
                }
            }
        }
    }
    
    // execute query and return ResultSet - caller must close ResultSet
    public static ResultSet executeQuery(String sql, Object... params) throws SQLException {
        Connection conn = DbConnect.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql);
        
        // Set parameters
        for (int i = 0; i < params.length; i++) {
            stmt.setObject(i + 1, params[i]);
        }
        
        return stmt.executeQuery();
    }
    
    // execute update and return affected rows
    public static int executeUpdate(String sql, Object... params) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DbConnect.getConnection();
            stmt = conn.prepareStatement(sql);
            
            // Set parameters
            for (int i = 0; i < params.length; i++) {
                stmt.setObject(i + 1, params[i]);
            }
            
            return stmt.executeUpdate();
        } finally {
            closeResources(stmt, conn);
        }
    }
    
    // execute insert and return generated key
    public static int executeInsert(String sql, Object... params) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = DbConnect.getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            // Set parameters
            for (int i = 0; i < params.length; i++) {
                stmt.setObject(i + 1, params[i]);
            }
            
            stmt.executeUpdate();
            
            // Get generated key
            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
            
            throw new SQLException("No generated key returned");
        } finally {
            closeResources(rs, stmt, conn);
        }
    }
    
    // check if ResultSet has data and move to first row
    public static boolean hasData(ResultSet rs) {
        try {
            return rs != null && rs.next();
        } catch (SQLException e) {
            return false;
        }
    }
    
    // get count from ResultSet (assumes ResultSet is at first row)
    public static int getCount(ResultSet rs) throws SQLException {
        if (rs != null) {
            return rs.getInt(1);
        }
        return 0;
    }
} 