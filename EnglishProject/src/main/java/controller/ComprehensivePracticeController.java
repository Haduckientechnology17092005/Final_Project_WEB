package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import bo.ComprehensivePracticeBO;
import bean.Vocabulary;

@WebServlet("/comprehensive_practice")
public class ComprehensivePracticeController extends HttpServlet {
    
    private ComprehensivePracticeBO comprehensivePracticeBO;
    
    @Override
    public void init() throws ServletException {
        comprehensivePracticeBO = new ComprehensivePracticeBO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
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
        
        System.out.println("DEBUG: ComprehensivePracticeController - userEmail: " + userEmail);
        
        try {
            // Get count parameter for limiting vocabulary
            String countParam = request.getParameter("count");
            int limit = -1; // -1 means no limit
            if (countParam != null && !countParam.trim().isEmpty() && !countParam.equals("all")) {
                try {
                    limit = Integer.parseInt(countParam);
                } catch (NumberFormatException e) {
                    System.err.println("Invalid count parameter: " + countParam);
                }
            }
            
            // Get comprehensive practice data from BO
            Map<String, Object> practiceData = comprehensivePracticeBO.getComprehensivePracticeData(userEmail, limit);
            
            System.out.println("DEBUG: ComprehensivePracticeController - practiceData keys: " + practiceData.keySet());
            System.out.println("DEBUG: ComprehensivePracticeController - exercises: " + 
                             (practiceData.get("exercises") != null ? ((List<?>)practiceData.get("exercises")).size() : "null"));
            System.out.println("DEBUG: ComprehensivePracticeController - totalExercises: " + practiceData.get("totalExercises"));
            System.out.println("DEBUG: ComprehensivePracticeController - currentExerciseIndex: " + practiceData.get("currentExerciseIndex"));
            System.out.println("DEBUG: ComprehensivePracticeController - limit: " + limit);
            
            // Set data as request attributes
            request.setAttribute("exercises", practiceData.get("exercises"));
            request.setAttribute("totalExercises", practiceData.get("totalExercises"));
            request.setAttribute("currentExerciseIndex", practiceData.get("currentExerciseIndex"));
            
            // Forward to JSP
            request.getRequestDispatcher("/comprehensive_practice.jsp").forward(request, response);
            
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
        
        if ("check_answer".equals(action)) {
            try {
                String userAnswer = request.getParameter("user_answer");
                String correctAnswer = request.getParameter("correct_answer");
                String vocabIdParam = request.getParameter("vocab_id");
                
                System.out.println("DEBUG: ComprehensivePracticeController - userAnswer: " + userAnswer);
                System.out.println("DEBUG: ComprehensivePracticeController - correctAnswer: " + correctAnswer);
                System.out.println("DEBUG: ComprehensivePracticeController - vocabIdParam: " + vocabIdParam);
                
                boolean isCorrect = comprehensivePracticeBO.checkAnswer(userAnswer, correctAnswer);
                
                System.out.println("DEBUG: ComprehensivePracticeController - isCorrect: " + isCorrect);
                
                // If answer is correct, mark vocabulary as learned
                if (isCorrect && vocabIdParam != null && !vocabIdParam.trim().isEmpty()) {
                    try {
                        int vocabId = Integer.parseInt(vocabIdParam);
                        System.out.println("DEBUG: ComprehensivePracticeController - marking vocab as learned: " + vocabId);
                        boolean marked = comprehensivePracticeBO.markVocabularyAsLearned(userEmail, vocabId);
                        System.out.println("DEBUG: ComprehensivePracticeController - marked successfully: " + marked);
                    } catch (NumberFormatException e) {
                        System.err.println("Invalid vocab_id: " + vocabIdParam);
                    }
                } else {
                    System.out.println("DEBUG: ComprehensivePracticeController - not marking as learned. isCorrect: " + isCorrect + ", vocabIdParam: " + vocabIdParam);
                }
                
                // Return JSON response
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                String jsonResponse = "{\"correct\":" + isCorrect + "}";
                response.getWriter().write(jsonResponse);
                
            } catch (Exception e) {
                e.printStackTrace();
                response.setContentType("application/json");
                response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
            }
        }
    }
} 