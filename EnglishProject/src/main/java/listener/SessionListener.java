package listener;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class SessionListener implements HttpSessionListener {
    
    @Override
    public void sessionCreated(HttpSessionEvent se) {
        // Don't count session creation - only count when user logs in
        System.out.println("Session created but not counted yet");
    }
    
    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        Object user = session.getAttribute("user");
        
        // Only decrement if user was logged in
        if (user != null) {
            Integer activeSessions = (Integer) session.getServletContext().getAttribute("activeSessions");
            
            if (activeSessions != null && activeSessions > 0) {
                activeSessions--;
                session.getServletContext().setAttribute("activeSessions", activeSessions);
                System.out.println("Logged-in session destroyed. Active sessions: " + activeSessions);
            }
        }
    }
} 