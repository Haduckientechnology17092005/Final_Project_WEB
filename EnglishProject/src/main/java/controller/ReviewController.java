package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import bo.ReviewBO;
import bean.Vocabulary;
import bean.FillInBlank;

@WebServlet("/review")
public class ReviewController extends HttpServlet {
    
    private ReviewBO reviewBO;
    
    @Override
    public void init() throws ServletException {
        reviewBO = new ReviewBO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Prevent caching
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        
        // Set UTF-8 encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Get user email from User object or String
        String userEmail;
        Object userObj = session.getAttribute("user");
        if (userObj instanceof bean.User) {
            userEmail = ((bean.User) userObj).getEmail();
        } else if (userObj instanceof String) {
            userEmail = (String) userObj;
        } else {
            response.sendRedirect("login.jsp");
            return;
        }
        
        System.out.println("DEBUG: ReviewController - userEmail: " + userEmail);
        
        try {
            // Get review data from BO
            Map<String, Object> reviewData = reviewBO.getReviewData(userEmail);
            
            System.out.println("DEBUG: ReviewController - reviewData keys: " + reviewData.keySet());
            System.out.println("DEBUG: ReviewController - reviewVocabulary size: " + 
                             (reviewData.get("reviewVocabulary") != null ? ((List<?>)reviewData.get("reviewVocabulary")).size() : "null"));
            System.out.println("DEBUG: ReviewController - masteredVocabulary size: " + 
                             (reviewData.get("masteredVocabulary") != null ? ((List<?>)reviewData.get("masteredVocabulary")).size() : "null"));
            
            // Set data as request attributes
            request.setAttribute("reviewVocabulary", reviewData.get("reviewVocabulary"));
            request.setAttribute("masteredVocabulary", reviewData.get("masteredVocabulary"));
            request.setAttribute("totalReview", reviewData.get("totalReview"));
            request.setAttribute("totalMastered", reviewData.get("totalMastered"));
            
            // Forward to JSP
            request.getRequestDispatcher("/review.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unexpected error: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set UTF-8 encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        // Get user email from User object or String
        String userEmail;
        Object userObj = session.getAttribute("user");
        if (userObj instanceof bean.User) {
            userEmail = ((bean.User) userObj).getEmail();
        } else if (userObj instanceof String) {
            userEmail = (String) userObj;
        } else {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("mark_as_learned".equals(action)) {
            try {
                int vocabId = Integer.parseInt(request.getParameter("vocab_id"));
                boolean success = reviewBO.markAsLearned(userEmail, vocabId);
                
                if (success) {
                    response.getWriter().write("success");
                } else {
                    response.getWriter().write("failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().write("error");
            }
        } else if ("mark_for_review".equals(action)) {
            try {
                int vocabId = Integer.parseInt(request.getParameter("vocab_id"));
                boolean success = reviewBO.markForReview(userEmail, vocabId);
                
                if (success) {
                    response.getWriter().write("success");
                } else {
                    response.getWriter().write("failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().write("error");
            }
        }
    }
} 