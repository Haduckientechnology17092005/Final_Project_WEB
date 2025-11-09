package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import bo.SoTayBO;
import bean.Vocabulary;
import bean.Category;

@WebServlet("/sotay")
public class SoTayController extends HttpServlet {
    
    private SoTayBO soTayBO;
    
    @Override
    public void init() throws ServletException {
        soTayBO = new SoTayBO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
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
        
        String categoryFilter = request.getParameter("category");
        if (categoryFilter == null) {
            categoryFilter = "all";
        }
        
        System.out.println("DEBUG: SoTayController - userEmail: " + userEmail + ", categoryFilter: " + categoryFilter);
        
        try {
            // Get data from BO
            Map<String, Object> data = soTayBO.getSoTayData(userEmail, categoryFilter);
            
            System.out.println("DEBUG: SoTayController - data keys: " + data.keySet());
            System.out.println("DEBUG: SoTayController - progress: " + data.get("progress"));
            System.out.println("DEBUG: SoTayController - vocabularyList size: " + 
                             (data.get("vocabulary") != null ? ((java.util.List<?>)data.get("vocabulary")).size() : "null"));
            System.out.println("DEBUG: SoTayController - categories size: " + 
                             (data.get("categories") != null ? ((java.util.List<?>)data.get("categories")).size() : "null"));
            
            // Set data as request attributes
            request.setAttribute("progress", data.get("progress"));
            request.setAttribute("vocabularyList", data.get("vocabulary"));
            request.setAttribute("categories", data.get("categories"));
            request.setAttribute("categoryFilter", categoryFilter);
            request.setAttribute("totalVocabulary", data.get("totalVocabulary"));
            
            // Forward to JSP
            request.getRequestDispatcher("/sotay.jsp").forward(request, response);
            
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
        
        // Set UTF-8 encoding for request and response
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
        
        try {
            if ("add_vocabulary".equals(action)) {
                // Handle add vocabulary
                String word = request.getParameter("word");
                String meaning = request.getParameter("meaning");
                String example = request.getParameter("example");
                String categoryName = request.getParameter("category");
                
                System.out.println("DEBUG: SoTayController - word: " + word);
                System.out.println("DEBUG: SoTayController - meaning: " + meaning);
                System.out.println("DEBUG: SoTayController - example: " + example);
                System.out.println("DEBUG: SoTayController - categoryName: " + categoryName);
                
                if (word != null && !word.trim().isEmpty() && meaning != null && !meaning.trim().isEmpty()) {
                    Vocabulary vocab = new Vocabulary();
                    vocab.setRaw(word.trim());
                    
                    // Generate audio and phonetics will be handled by SoTayBO
                    vocab.setPhonetic(""); // Will be generated by AudioBO
                    vocab.setAudioUrl(""); // Will be generated by AudioBO
                    vocab.setOrigin(""); // Can be generated later
                    
                    // Set category if provided
                    if (categoryName != null && !categoryName.trim().isEmpty()) {
                        if ("add-new".equals(categoryName.trim())) {
                            // Get new category name from form
                            String newCategoryName = request.getParameter("new-category-input");
                            if (newCategoryName != null && !newCategoryName.trim().isEmpty()) {
                                System.out.println("DEBUG: SoTayController - Creating new category: " + newCategoryName.trim());
                                Category category = soTayBO.getCategoryBO().getOrCreateCategory(newCategoryName.trim());
                                if (category != null) {
                                    System.out.println("DEBUG: SoTayController - New category created with ID: " + category.getId());
                                    vocab.setCategoryId(category.getId());
                                } else {
                                    System.out.println("DEBUG: SoTayController - Failed to create new category");
                                    vocab.setCategoryId(null);
                                }
                            } else {
                                System.out.println("DEBUG: SoTayController - No new category name provided");
                                vocab.setCategoryId(null);
                            }
                        } else {
                            System.out.println("DEBUG: SoTayController - Using existing category: " + categoryName.trim());
                            Category category = soTayBO.getCategoryBO().getOrCreateCategory(categoryName.trim());
                            if (category != null) {
                                System.out.println("DEBUG: SoTayController - Category found/created with ID: " + category.getId());
                                vocab.setCategoryId(category.getId());
                            } else {
                                System.out.println("DEBUG: SoTayController - Failed to create category");
                                vocab.setCategoryId(null);
                            }
                        }
                    } else {
                        System.out.println("DEBUG: SoTayController - No category selected");
                        vocab.setCategoryId(null);
                    }
                    
                    System.out.println("DEBUG: SoTayController - Adding vocabulary with audio generation");
                    boolean success = soTayBO.addVocabularyToUser(userEmail, vocab, meaning.trim(), example);
                    if (success) {
                        response.sendRedirect("sotay?success=added");
                    } else {
                        response.sendRedirect("sotay?error=add_failed");
                    }
                } else {
                    response.sendRedirect("sotay?error=invalid_data");
                }
                
            } else if ("update_progress".equals(action)) {
                // Handle progress update
                int vocabId = Integer.parseInt(request.getParameter("vocab_id"));
                boolean isLearned = Boolean.parseBoolean(request.getParameter("is_learned"));
                boolean isReview = Boolean.parseBoolean(request.getParameter("is_review"));
                
                boolean success = soTayBO.updateProgress(userEmail, vocabId, isLearned, isReview);
                if (success) {
                    response.sendRedirect("sotay?success=progress_updated");
                } else {
                    response.sendRedirect("sotay?error=update_failed");
                }
                
            } else {
                response.sendRedirect("sotay?error=invalid_action");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("sotay?error=database_error");
        } catch (NumberFormatException e) {
            response.sendRedirect("sotay?error=invalid_id");
        }
    }
} 