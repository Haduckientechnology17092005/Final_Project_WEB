package dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import bean.User;

public class LoginDAO {
    
    // validate user credentials against database
    public User validateUser(String email, String password) {
        String sql = "SELECT * FROM user WHERE email = ? AND password = ?";
        ResultSet rs = null;
        
        try {
            rs = DbUtil.executeQuery(sql, email, password);
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbUtil.closeResources(rs);
        }
        
        return null;
    }
    
    // check if email exists in database
    public boolean checkUserExists(String email) {
        String sql = "SELECT COUNT(*) FROM user WHERE email = ?";
        ResultSet rs = null;
        
        try {
            rs = DbUtil.executeQuery(sql, email);
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbUtil.closeResources(rs);
        }
        
        return false;
    }
    
    // get user by email
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM user WHERE email = ?";
        ResultSet rs = null;
        
        try {
            rs = DbUtil.executeQuery(sql, email);
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DbUtil.closeResources(rs);
        }
        
        return null;
    }
    
    public boolean isVerified(String email) {
        User user = getUserByEmail(email);
        return user != null && user.isEmailVerified();
    }
} 