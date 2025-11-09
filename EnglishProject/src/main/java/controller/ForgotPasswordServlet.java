package controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import bo.UserBO;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private UserBO userBO = new UserBO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        System.out.println("Email nhận được từ form: " + email);

        try {
            boolean sent = userBO.forgotPassword(email);
            if (sent) {
                response.sendRedirect("login.jsp?success=1");
            } else {
                response.sendRedirect("forgot-password.jsp?error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("forgot-password.jsp?error=1");
        }
    }
}

