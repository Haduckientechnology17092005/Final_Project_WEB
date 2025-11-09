package bo;

import bean.Learning;
import bean.User;
import dao.LearningDAO;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import bean.Vocabulary;

public class LearningBO {
    private LearningDAO learningDAO;
    private UserBO userBO;
    
    public LearningBO() {
        this.learningDAO = new LearningDAO();
        this.userBO = new UserBO();
    }
    
    public List<Learning> getLearningByUser(String email) throws SQLException {
        return learningDAO.getLearningByUser(email);
    }
    
    public Learning getLearningByUserAndVocab(String email, int vocabId) throws SQLException {
        return learningDAO.getLearningByUserAndVocab(email, vocabId);
    }
    
    public boolean addLearning(Learning learning) throws SQLException {
        // Get user_id from email using UserBO
        User user = userBO.getUserByEmail(learning.getEmail());
        if (user == null) {
            return false;
        }
        learning.setUserId(user.getId());
        
        return learningDAO.addLearning(learning);
    }
    
    public boolean updateLearning(Learning learning) throws SQLException {
        return learningDAO.updateLearning(learning);
    }
    
    public boolean deleteLearning(String email, int vocabId) throws SQLException {
        return learningDAO.deleteLearning(email, vocabId);
    }
    
    public Map<String, Integer> getProgressByUser(String email) throws SQLException {
        return learningDAO.getProgressByUser(email);
    }
    
    public List<Vocabulary> getVocabularyWithProgress(String email, String categoryFilter) throws SQLException {
        return learningDAO.getVocabularyWithProgress(email, categoryFilter);
    }
    
    public boolean markAsLearned(String email, int vocabId) throws SQLException {
        System.out.println("DEBUG: LearningBO.markAsLearned - email: " + email + ", vocabId: " + vocabId);
        
        Learning learning = getLearningByUserAndVocab(email, vocabId);
        System.out.println("DEBUG: LearningBO.markAsLearned - existing learning: " + learning);
        
        if (learning == null) {
            // Create new learning record
            learning = new Learning();
            learning.setEmail(email);
            learning.setVocabId(vocabId);
            learning.setLearned(true);
            learning.setReview(false);
            
            // Get user ID from email
            try {
                User user = userBO.getUserByEmail(email);
                if (user != null) {
                    learning.setUserId(user.getId());
                    System.out.println("DEBUG: LearningBO.markAsLearned - user found, userId: " + user.getId());
                } else {
                    System.err.println("DEBUG: User not found for email: " + email);
                    return false;
                }
            } catch (Exception e) {
                System.err.println("DEBUG: Error getting user for email " + email + ": " + e.getMessage());
                return false;
            }
            
            boolean result = addLearning(learning);
            System.out.println("DEBUG: LearningBO.markAsLearned - addLearning result: " + result);
            return result;
        } else {
            learning.setLearned(true);
            learning.setReview(false);
            boolean result = updateLearning(learning);
            System.out.println("DEBUG: LearningBO.markAsLearned - updateLearning result: " + result);
            return result;
        }
    }
    
    public boolean markForReview(String email, int vocabId) throws SQLException {
        Learning learning = getLearningByUserAndVocab(email, vocabId);
        if (learning == null) {
            // Create new learning record
            learning = new Learning();
            learning.setEmail(email);
            learning.setVocabId(vocabId);
            learning.setLearned(false);
            learning.setReview(true);
            return addLearning(learning);
        } else {
            learning.setLearned(false);
            learning.setReview(true);
            return updateLearning(learning);
        }
    }
    
    public boolean validateLearning(Learning learning) {
        if (learning.getEmail() == null || learning.getEmail().trim().isEmpty()) {
            return false;
        }
        if (learning.getVocabId() <= 0) {
            return false;
        }
        return true;
    }
    
    /**
     * Get vocabulary that needs review
     */
    public List<Vocabulary> getVocabularyForReview(String email) throws SQLException {
        return learningDAO.getVocabularyForReview(email);
    }
    
    /**
     * Get vocabulary that has been mastered
     */
    public List<Vocabulary> getVocabularyMastered(String email) throws SQLException {
        return learningDAO.getVocabularyMastered(email);
    }
    
    /**
     * Get all vocabulary for comprehensive practice
     */
    public List<Vocabulary> getAllVocabularyForPractice(String email) throws SQLException {
        return learningDAO.getAllVocabularyForPractice(email);
    }
    
    /**
     * Get all learning records for admin management
     */
    public List<Learning> getAllLearningRecords() throws SQLException {
        return learningDAO.getAllLearningRecords();
    }
} 