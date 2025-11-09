package controller;

import bo.UserBO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/verify")
public class VerificationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private UserBO userBO;

    @Override
    public void init() throws ServletException {
        userBO = new UserBO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");

        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("message", "Token không hợp lệ!");
            request.getRequestDispatcher("verify-result.jsp").forward(request, response);
            return;
        }

        try {
            boolean verified = userBO.verifyEmail(token);
            if (verified) {
                request.setAttribute("message", "Xác thực email thành công! Bạn có thể đăng nhập ngay.");
            } else {
                request.setAttribute("message", "Token không hợp lệ hoặc đã hết hạn!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Đã xảy ra lỗi khi xác thực email.");
        }

        request.getRequestDispatcher("verify-result.jsp").forward(request, response);
    }
}
