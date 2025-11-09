package filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import bo.UserBO;
import bean.User;

public class AuthFilter implements Filter {
    
    private static final String[] PUBLIC_URLS = {
        "/",
        "/index.jsp",
        "/login.jsp",
        "/login",
        "/register.jsp",
        "/register",
        "/css/",
        "/js/",
        "/images/",
        "/audio/",
        "/favicon.ico"
    };
    
    private static final String[] ADMIN_URLS = {
        "/admin/",
        "/user?action=list"
    };
    
    private static final String[] MODERATOR_URLS = {
        "/moderator/",
        "/vocabulary/manage"
    };
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String relativePath = requestURI.substring(contextPath.length());
        
        // Check if URL is public
        if (isPublicUrl(relativePath)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check authentication
        HttpSession session = httpRequest.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(contextPath + "/login.jsp");
            return;
        }
        
        // Check role-based access
        if (requiresRole(relativePath)) {
            String requiredRole = getRequiredRole(relativePath);
            if (!hasRequiredRole(session, requiredRole)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return;
            }
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // cleanup code if needed
    }
    
    private boolean isPublicUrl(String url) {
        for (String publicUrl : PUBLIC_URLS) {
            if (url.startsWith(publicUrl)) {
                return true;
            }
        }
        return false;
    }
    
    private boolean requiresRole(String url) {
        return isAdminUrl(url) || isModeratorUrl(url);
    }
    
    private boolean isAdminUrl(String url) {
        for (String adminUrl : ADMIN_URLS) {
            if (url.startsWith(adminUrl)) {
                return true;
            }
        }
        return false;
    }
    
    private boolean isModeratorUrl(String url) {
        for (String moderatorUrl : MODERATOR_URLS) {
            if (url.startsWith(moderatorUrl)) {
                return true;
            }
        }
        return false;
    }
    
    private String getRequiredRole(String url) {
        if (isAdminUrl(url)) {
            return "admin";
        } else if (isModeratorUrl(url)) {
            return "moderator";
        }
        return "user";
    }
    
    private boolean hasRequiredRole(HttpSession session, String requiredRole) {
        try {
            Object userObj = session.getAttribute("user");
            String userEmail;
            
            if (userObj instanceof User) {
                userEmail = ((User) userObj).getEmail();
            } else if (userObj instanceof String) {
                userEmail = (String) userObj;
            } else {
                return false;
            }
            
            UserBO userBO = new UserBO();
            return userBO.hasPermission(userEmail, requiredRole);
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
} 