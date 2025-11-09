package controller;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import bean.User;
import bo.UserBO;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {
    private UserBO userBO = new UserBO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");

        try {
            boolean success = userBO.changePassword(user.getEmail(), currentPassword, newPassword);

            if (success) {
                response.sendRedirect("profile.jsp?success=1");
            } else {
                response.sendRedirect("profile.jsp?error=1");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("profile.jsp?error=1");
        }
    }
}