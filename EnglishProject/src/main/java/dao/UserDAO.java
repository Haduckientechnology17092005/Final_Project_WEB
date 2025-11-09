package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import bean.User;

public class UserDAO {

    // --- LẤY TOÀN BỘ USER ---
    public List<User> getAllUsers() throws SQLException {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT * FROM user ORDER BY id";

        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                userList.add(mapResultSetToUser(rs));
            }
        }
        return userList;
    }

    // --- LẤY USER THEO ID ---
    public User getUserById(int id) throws SQLException {
        String sql = "SELECT * FROM user WHERE id = ?";

        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        return null;
    }

    // --- LẤY USER THEO EMAIL ---
    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM user WHERE email = ?";

        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        return null;
    }

    // --- THÊM USER MỚI (đăng ký) ---
    public boolean addUser(User user) throws SQLException {
        String sql = "INSERT INTO user (email, username, password, role, email_verified, verification_token) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getUsername());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getRole() != null ? user.getRole() : "user");
            stmt.setBoolean(5, user.isEmailVerified());
            stmt.setString(6, user.getVerificationToken());

            return stmt.executeUpdate() > 0;
        }
    }

    // --- CẬP NHẬT USER ---
    public boolean updateUser(User user) throws SQLException {
        String sql = "UPDATE user SET email = ?, username = ?, password = ?, role = ?, email_verified = ? WHERE id = ?";

        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getUsername());
            stmt.setString(3, user.getPassword());
            stmt.setString(4, user.getRole());
            stmt.setBoolean(5, user.isEmailVerified());
            stmt.setInt(6, user.getId());

            return stmt.executeUpdate() > 0;
        }
    }

    // --- XÓA USER ---
    public boolean deleteUser(int id) throws SQLException {
        String sql = "DELETE FROM user WHERE id = ?";

        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    // --- KIỂM TRA EMAIL ĐÃ TỒN TẠI ---
    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM user WHERE email = ?";

        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    // --- LẤY USER THEO TOKEN XÁC THỰC EMAIL ---
    public User getUserByVerificationToken(String token) throws SQLException {
        String sql = "SELECT * FROM user WHERE verification_token = ?";
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        return null;
    }

    // --- CẬP NHẬT TRẠNG THÁI XÁC THỰC EMAIL ---
    public boolean verifyEmail(String token) throws SQLException {
        String sql = "UPDATE user SET email_verified = TRUE, verification_token = NULL WHERE verification_token = ?";
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            return stmt.executeUpdate() > 0;
        }
    }

    // --- TẠO TOKEN QUÊN MẬT KHẨU ---
    public boolean setResetToken(String email, String token, Timestamp expiry) throws SQLException {
        String sql = "UPDATE user SET reset_token = ?, 	reset_token_expiry = ? WHERE email = ?";
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            stmt.setTimestamp(2, expiry);
            stmt.setString(3, email);
            return stmt.executeUpdate() > 0;
        }
    }

    // --- LẤY USER THEO TOKEN QUÊN MẬT KHẨU ---
    public User getUserByResetToken(String token) throws SQLException {
        String sql = "SELECT * FROM user WHERE reset_token = ? AND reset_token_expiry > UTC_TIMESTAMP()";
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, token);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        return null;
    }

    // --- CẬP NHẬT MẬT KHẨU SAU KHI RESET ---
    public boolean updatePassword(String email, String newPassword) throws SQLException {
        String sql = "UPDATE user SET password = ?, reset_token = NULL, reset_token_expiry = NULL WHERE email = ?";
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, newPassword);
            stmt.setString(2, email);
            return stmt.executeUpdate() > 0;
        }
    }

    // --- ÁNH XẠ RESULTSET SANG OBJECT ---
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setEmail(rs.getString("email"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role"));
        user.setEmailVerified(rs.getBoolean("email_verified"));
        user.setVerificationToken(rs.getString("verification_token"));
        user.setResetToken(rs.getString("reset_Token"));
        user.setResesetTokenExpiry(rs.getTimestamp("reset_token_expiry"));
        return user;
    }

	public boolean validateUser(String email, String password) throws SQLException {
		// TODO Auto-generated method stub
		String sql = "SELECT COUNT(*) as count FROM user WHERE email = ? AND password = ?"; 
		try (Connection conn = DbConnect.getConnection(); 
			PreparedStatement stmt = conn.prepareStatement(sql)) { 
			stmt.setString(1, email); 
			stmt.setString(2, password); 
			try (ResultSet rs = stmt.executeQuery()) 
			{ 
				if (rs.next()) 
				{ 
					return rs.getInt("count") > 0; 
				} 
			} 
		} 
		return false;
	}
	
	public List<User> getUsersByRole(String role) throws SQLException { 
		List<User> userList = new ArrayList<>(); 
		String sql = "SELECT * FROM user WHERE role = ? ORDER BY id"; 
		try (Connection conn = DbConnect.getConnection(); 
			PreparedStatement stmt = conn.prepareStatement(sql)) { 
			stmt.setString(1, role); try (ResultSet rs = stmt.executeQuery()) { 
				while (rs.next()) { 
					User user = new User(); 
					user.setId(rs.getInt("id")); 
					user.setEmail(rs.getString("email")); 
					user.setPassword(rs.getString("password")); 
					user.setRole(rs.getString("role")); 
					userList.add(user); 
				} 
			} 
		} 
		return userList; 
	}
	public boolean updateUserRole(int userId, String role) throws SQLException { 
		String sql = "UPDATE user SET role = ? WHERE id = ?"; 
		try (Connection conn = DbConnect.getConnection(); 
				PreparedStatement stmt = conn.prepareStatement(sql)) { 
			stmt.setString(1, role); 
			stmt.setInt(2, userId); 
			return stmt.executeUpdate() > 0; 
		} 
	}
}
