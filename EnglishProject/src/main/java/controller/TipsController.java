package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import bo.TipsBO;

@WebServlet("/tips")
public class TipsController extends HttpServlet {
    
    private TipsBO tipsBO;
    
    @Override
    public void init() throws ServletException {
        tipsBO = new TipsBO(getServletContext());
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("DEBUG: TipsController - doGet called");
        
        // Set UTF-8 encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Add cache-busting headers
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("DEBUG: TipsController - No session or user, redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            // Get random tip filename
            System.out.println("DEBUG: TipsController - Getting random tip file");
            String randomTipFile = tipsBO.getRandomTipFile();
            
            if (randomTipFile != null) {
                System.out.println("DEBUG: TipsController - Redirecting to: tips/" + randomTipFile);
                
                // Add timestamp to prevent caching
                String redirectUrl = "tips/" + randomTipFile + "?t=" + System.currentTimeMillis();
                response.sendRedirect(redirectUrl);
            } else {
                System.out.println("DEBUG: TipsController - No tip files found, redirecting to default");
                
                // Fallback to default tip
                response.sendRedirect("tips/tip1.html?t=" + System.currentTimeMillis());
            }
            
        } catch (Exception e) {
            System.err.println("DEBUG: TipsController - Error: " + e.getMessage());
            e.printStackTrace();
            
            // Fallback to default tip on error
            response.sendRedirect("tips/tip1.html?t=" + System.currentTimeMillis());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
} 