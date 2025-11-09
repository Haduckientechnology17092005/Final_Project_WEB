package controller;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import bean.User;
import bo.UserBO;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserBO userBO;

    @Override
    public void init() {
        userBO = new UserBO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị form đăng ký
        RequestDispatcher dispatcher = request.getRequestDispatcher("register.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username").trim();
        String email = request.getParameter("email").trim();
        String password = request.getParameter("password").trim();

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password);

        try {
            boolean registered = userBO.registerUser(user);
            if (registered) {
                request.setAttribute("success", "Đăng ký thành công! Vui lòng kiểm tra email để xác thực.");
            } else {
                request.setAttribute("error", "Đăng ký thất bại! Email đã tồn tại hoặc dữ liệu không hợp lệ.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống, vui lòng thử lại sau.");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("register.jsp");
        dispatcher.forward(request, response);
    }
}
