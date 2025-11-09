package controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import bo.UserBO;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    private UserBO userBO = new UserBO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");

        try {
            boolean reset = userBO.resetPassword(token, newPassword);
            if (reset) {
                response.sendRedirect("login.jsp?resetSuccess=1");
            } else {
                response.sendRedirect("reset-password.jsp?token=" + token + "&error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("reset-password.jsp?token=" + token + "&error=1");
        }
    }
}
