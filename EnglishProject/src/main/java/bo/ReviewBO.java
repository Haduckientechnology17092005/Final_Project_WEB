package bo;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import bean.Vocabulary;
import bean.FillInBlank;

public class ReviewBO {
    
    private LearningBO learningBO;
    private VocabularyBO vocabularyBO;
    private FillInBlankBO fillInBlankBO;
    
    public ReviewBO() {
        this.learningBO = new LearningBO();
        this.vocabularyBO = new VocabularyBO();
        this.fillInBlankBO = new FillInBlankBO();
    }
    
    /**
     * Get review data for user
     */
    public Map<String, Object> getReviewData(String userEmail) throws SQLException {
        Map<String, Object> data = new HashMap<>();
        
        // Get vocabulary that needs review
        List<Vocabulary> reviewVocabulary = learningBO.getVocabularyForReview(userEmail);
        data.put("reviewVocabulary", reviewVocabulary);
        data.put("totalReview", reviewVocabulary.size());
        
        // Get mastered vocabulary
        List<Vocabulary> masteredVocabulary = learningBO.getVocabularyMastered(userEmail);
        data.put("masteredVocabulary", masteredVocabulary);
        data.put("totalMastered", masteredVocabulary.size());
        
        System.out.println("DEBUG: ReviewBO - Review vocabulary count: " + reviewVocabulary.size());
        System.out.println("DEBUG: ReviewBO - Mastered vocabulary count: " + masteredVocabulary.size());
        
        return data;
    }
    
    /**
     * Mark vocabulary as learned
     */
    public boolean markAsLearned(String userEmail, int vocabId) throws SQLException {
        return learningBO.markAsLearned(userEmail, vocabId);
    }
    
    /**
     * Mark vocabulary for review
     */
    public boolean markForReview(String userEmail, int vocabId) throws SQLException {
        return learningBO.markForReview(userEmail, vocabId);
    }
    
    /**
     * Get practice questions for vocabulary
     */
    public List<FillInBlank> getPracticeQuestions(int vocabId) throws SQLException {
        return fillInBlankBO.getQuestionsForPractice(vocabId);
    }
    
    /**
     * Check answer for practice question
     */
    public boolean checkAnswer(int questionId, String userAnswer) throws SQLException {
        return fillInBlankBO.checkAnswer(questionId, userAnswer);
    }
} 