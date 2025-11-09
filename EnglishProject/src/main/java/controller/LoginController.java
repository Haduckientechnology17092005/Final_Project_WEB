package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import bo.LoginBO;
import bean.User;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LoginBO loginBO;
    
    public void init() {
        loginBO = new LoginBO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // check if logout parameter is present
        String logout = request.getParameter("logout");
        if (logout != null && logout.equals("1")) {
            // handle logout
            HttpSession session = request.getSession(false);
            if (session != null) {
                // Decrement active sessions counter before invalidating session
                Integer activeSessions = (Integer) session.getServletContext().getAttribute("activeSessions");
                if (activeSessions != null && activeSessions > 0) {
                    activeSessions--;
                    session.getServletContext().setAttribute("activeSessions", activeSessions);
                }
                session.invalidate();
            }
            response.sendRedirect("login.jsp?logout=1");
            return;
        }
        
        // redirect to login page
        response.sendRedirect("login.jsp");
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // validate user credentials
        User user = loginBO.authenticateUser(email, password);
        
        if (user != null) {
            // create session and store user info
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("email", user.getEmail());
            session.setAttribute("userId", user.getId());
            
            // Increment active sessions counter
            Integer activeSessions = (Integer) session.getServletContext().getAttribute("activeSessions");
            if (activeSessions == null) {
                activeSessions = 0;
            }
            activeSessions++;
            session.getServletContext().setAttribute("activeSessions", activeSessions);
            
            // redirect to dashboard
            response.sendRedirect("dashboard.jsp");
        } else {
            // redirect back to login with error
            response.sendRedirect("login.jsp?error=1");
        }
    }
} 