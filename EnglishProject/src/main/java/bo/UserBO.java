package bo;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import java.util.UUID;

import bean.User;
import dao.UserDAO;
import util.EmailUtil;

import java.time.Instant;
import java.util.concurrent.TimeUnit;

public class UserBO {
    private UserDAO userDAO;

    public UserBO() {
        this.userDAO = new UserDAO();
    }

    // ------------------- CRUD -------------------

    public List<User> getAllUsers() throws SQLException {
        return userDAO.getAllUsers();
    }

    public User getUserById(int id) throws SQLException {
        return userDAO.getUserById(id);
    }

    public User getUserByEmail(String email) throws SQLException {
        return userDAO.getUserByEmail(email);
    }

    public boolean updateUser(User user) throws SQLException {
        if (!validateUser(user)) return false;
        return userDAO.updateUser(user);
    }

    public boolean deleteUser(int id) throws SQLException {
        return userDAO.deleteUser(id);
    }

    // ------------------- XÁC THỰC NGƯỜI DÙNG -------------------

    public boolean validateUser(String email, String password) throws SQLException {
        return userDAO.validateUser(email, password);
    }

    public boolean emailExists(String email) throws SQLException {
        return userDAO.emailExists(email);
    }

    // ------------------- PHÂN QUYỀN -------------------

    public List<User> getUsersByRole(String role) throws SQLException {
        return userDAO.getUsersByRole(role);
    }

    public boolean updateUserRole(int userId, String role) throws SQLException {
        if (!validateRole(role)) return false;
        return userDAO.updateUserRole(userId, role);
    }

    // ------------------- ĐĂNG KÝ -------------------

    /**
     * Đăng ký người dùng mới và gửi email xác thực.
     */
    public boolean registerUser(User user) throws SQLException {
        if (!validateUser(user)) return false;
        if (emailExists(user.getEmail())) return false;

        // Tạo token xác thực
        String verificationToken = UUID.randomUUID().toString();
        user.setVerificationToken(verificationToken);
        user.setEmailVerified(false);
        user.setRole("user");

        // Thêm vào DB
        boolean added = userDAO.addUser(user);
        if (!added) return false;

        // Gửi mail xác thực
        String subject = "Xác thực tài khoản của bạn";
        String link = "http://localhost:8080/EnglishProject/verify?token=" + verificationToken;
        String body = "<h3>Xin chào " + user.getUsername() + ",</h3>"
                + "<p>Vui lòng xác thực email của bạn bằng cách click vào liên kết dưới đây:</p>"
                + "<a href='" + link + "'>Xác thực ngay</a>"
                + "<p>Nếu bạn không đăng ký tài khoản, vui lòng bỏ qua email này.</p>";

        EmailUtil.sendEmail(user.getEmail(), subject, body);
        return true;
    }

    // ------------------- QUÊN MẬT KHẨU -------------------
    public boolean forgotPassword(String email) throws SQLException {
        User user = userDAO.getUserByEmail(email);
        if (user == null) return false;

        // Tạo token reset với UTC
        String resetToken = UUID.randomUUID().toString();
        Timestamp expiry = Timestamp.from(Instant.now().plusSeconds(15 * 60)); // 15 phút

        boolean updated = userDAO.setResetToken(email, resetToken, expiry);
        if (!updated) return false;

        // Gửi mail reset
        String subject = "Khôi phục mật khẩu";
        String link = "http://localhost:8080/EnglishProject/reset-password.jsp?token=" + resetToken;
        String body = "<h3>Xin chào " + user.getUsername() + ",</h3>"
                + "<p>Bạn vừa yêu cầu đặt lại mật khẩu. Vui lòng click vào liên kết dưới đây để đổi mật khẩu:</p>"
                + "<a href='" + link + "'>Đặt lại mật khẩu</a>"
                + "<p>Liên kết này sẽ hết hạn sau 15 phút.</p>";

        System.out.println("Gửi mail tới: " + email);
        System.out.println("Token reset: " + resetToken);

        EmailUtil.sendEmail(email, subject, body);
        return true;
    }

    // ------------------- RESET MẬT KHẨU -------------------

    /**
     * Đặt lại mật khẩu khi có token hợp lệ.
     */
    public boolean resetPassword(String token, String newPassword) throws SQLException {
        User user = userDAO.getUserByResetToken(token);
        if (user == null) return false;

        return userDAO.updatePassword(user.getEmail(), newPassword);
    }

    // ------------------- XÁC THỰC EMAIL -------------------

    public boolean verifyEmail(String token) throws SQLException {
        return userDAO.verifyEmail(token);
    }

    // ------------------- HÀM HỖ TRỢ -------------------

    public boolean validateUser(User user) {
        if (user == null) return false;
        if (user.getEmail() == null || user.getEmail().trim().isEmpty()) return false;
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) return false;
        if (!user.getEmail().contains("@")) return false;
        return true;
    }

    public boolean validateRole(String role) {
        if (role == null || role.trim().isEmpty()) return false;
        String[] validRoles = {"user", "admin", "moderator"};
        for (String validRole : validRoles) {
            if (validRole.equalsIgnoreCase(role)) return true;
        }
        return false;
    }

    // ------------------- KIỂM TRA QUYỀN -------------------

    public boolean isAdmin(String email) throws SQLException {
        User user = getUserByEmail(email);
        return user != null && "admin".equals(user.getRole());
    }

    public boolean isModerator(String email) throws SQLException {
        User user = getUserByEmail(email);
        return user != null && ("moderator".equals(user.getRole()) || "admin".equals(user.getRole()));
    }

    public boolean hasPermission(String email, String requiredRole) throws SQLException {
        User user = getUserByEmail(email);
        if (user == null) return false;

        switch (requiredRole.toLowerCase()) {
            case "admin":
                return "admin".equals(user.getRole());
            case "moderator":
                return "moderator".equals(user.getRole()) || "admin".equals(user.getRole());
            case "user":
                return true;
            default:
                return false;
        }
    }
    
    public boolean changePassword(String email, String currentPassword, String newPassword) throws SQLException {
        if (!validateUser(email, currentPassword)) {
            return false;
        }
        return userDAO.updatePassword(email, newPassword);
    }
}
