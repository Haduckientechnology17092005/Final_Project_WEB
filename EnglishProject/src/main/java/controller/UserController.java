package controller;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import bo.UserBO;
import bean.User;

@WebServlet({"/user", "/users"})
public class UserController extends HttpServlet {
    
    private UserBO userBO;
    
    @Override
    public void init() throws ServletException {
        userBO = new UserBO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("profile".equals(action)) {
                // Show user profile
                String userEmail = getUserEmailFromSession(session);
                User user = userBO.getUserByEmail(userEmail);
                request.setAttribute("user", user);
                request.getRequestDispatcher("/user-profile.jsp").forward(request, response);
                
            } else if ("list".equals(action)) {
                // List all users (admin only)
                String userEmail = getUserEmailFromSession(session);
                if (!userBO.isAdmin(userEmail)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    return;
                }
                
                request.setAttribute("users", userBO.getAllUsers());
                request.getRequestDispatcher("/admin/user-list.jsp").forward(request, response);
                
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("update_profile".equals(action)) {
                // Update user profile
                String userEmail = getUserEmailFromSession(session);
                User currentUser = userBO.getUserByEmail(userEmail);
                
                String newEmail = request.getParameter("email");
                String newPassword = request.getParameter("password");
                
                if (newEmail != null && !newEmail.trim().isEmpty()) {
                    currentUser.setEmail(newEmail.trim());
                }
                if (newPassword != null && !newPassword.trim().isEmpty()) {
                    currentUser.setPassword(newPassword.trim());
                }
                
                boolean success = userBO.updateUser(currentUser);
                if (success) {
                    response.sendRedirect("user?action=profile&success=updated");
                } else {
                    response.sendRedirect("user?action=profile&error=update_failed");
                }
                
            } else if ("update_role".equals(action)) {
                // Update user role (admin only)
                String adminEmail = getUserEmailFromSession(session);
                if (!userBO.isAdmin(adminEmail)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    return;
                }
                
                int userId = Integer.parseInt(request.getParameter("user_id"));
                String newRole = request.getParameter("role");
                
                boolean success = userBO.updateUserRole(userId, newRole);
                if (success) {
                    response.sendRedirect("user?action=list&success=role_updated");
                } else {
                    response.sendRedirect("user?action=list&error=role_update_failed");
                }
                
            } else if ("delete_user".equals(action)) {
                // Delete user (admin only)
                String adminEmail = getUserEmailFromSession(session);
                if (!userBO.isAdmin(adminEmail)) {
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                    return;
                }
                
                int userId = Integer.parseInt(request.getParameter("user_id"));
                
                boolean success = userBO.deleteUser(userId);
                if (success) {
                    response.sendRedirect("user?action=list&success=user_deleted");
                } else {
                    response.sendRedirect("user?action=list&error=delete_failed");
                }
                
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("user?action=profile&error=database_error");
        } catch (NumberFormatException e) {
            response.sendRedirect("user?action=profile&error=invalid_id");
        }
    }
    
    private String getUserEmailFromSession(HttpSession session) {
        Object userObj = session.getAttribute("user");
        if (userObj instanceof bean.User) {
            return ((bean.User) userObj).getEmail();
        } else if (userObj instanceof String) {
            return (String) userObj;
        }
        return null;
    }
} 