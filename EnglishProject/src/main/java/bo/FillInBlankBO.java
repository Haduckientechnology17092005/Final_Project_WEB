package bo;

import java.sql.SQLException;
import java.util.List;
import bean.FillInBlank;
import dao.FillInBlankDAO;

public class FillInBlankBO {
    private FillInBlankDAO fillInBlankDAO;
    
    public FillInBlankBO() {
        this.fillInBlankDAO = new FillInBlankDAO();
    }
    
    public List<FillInBlank> getAllFillInBlank() throws SQLException {
        return fillInBlankDAO.getAllFillInBlank();
    }
    
    public FillInBlank getFillInBlankById(int id) throws SQLException {
        return fillInBlankDAO.getFillInBlankById(id);
    }
    
    public List<FillInBlank> getFillInBlankByVocabularyId(int vocabularyId) throws SQLException {
        return fillInBlankDAO.getFillInBlankByVocabularyId(vocabularyId);
    }
    
    public List<FillInBlank> getRandomFillInBlank(int limit) throws SQLException {
        return fillInBlankDAO.getRandomFillInBlank(limit);
    }
    
    public boolean addFillInBlank(FillInBlank fillInBlank) throws SQLException {
        if (!validateFillInBlank(fillInBlank)) {
            return false;
        }
        
        int result = fillInBlankDAO.addFillInBlank(fillInBlank);
        return result > 0;
    }
    
    public boolean updateFillInBlank(FillInBlank fillInBlank) throws SQLException {
        if (!validateFillInBlank(fillInBlank)) {
            return false;
        }
        
        return fillInBlankDAO.updateFillInBlank(fillInBlank);
    }
    
    public boolean deleteFillInBlank(int id) throws SQLException {
        return fillInBlankDAO.deleteFillInBlank(id);
    }
    
    public boolean deleteFillInBlankByVocabularyId(int vocabularyId) throws SQLException {
        return fillInBlankDAO.deleteFillInBlankByVocabularyId(vocabularyId);
    }
    
    public int getTotalFillInBlank() throws SQLException {
        return fillInBlankDAO.getTotalFillInBlank();
    }
    
    public boolean existsByVocabularyId(int vocabularyId) throws SQLException {
        return fillInBlankDAO.existsByVocabularyId(vocabularyId);
    }
    
    public boolean validateFillInBlank(FillInBlank fillInBlank) {
        if (fillInBlank == null) {
            return false;
        }
        
        if (fillInBlank.getQuestion() == null || fillInBlank.getQuestion().trim().isEmpty()) {
            return false;
        }
        
        if (fillInBlank.getCorrectAnswer() == null || fillInBlank.getCorrectAnswer().trim().isEmpty()) {
            return false;
        }
        
        if (fillInBlank.getWrongAnswer1() == null || fillInBlank.getWrongAnswer1().trim().isEmpty()) {
            return false;
        }
        
        if (fillInBlank.getWrongAnswer2() == null || fillInBlank.getWrongAnswer2().trim().isEmpty()) {
            return false;
        }
        
        if (fillInBlank.getVocabularyId() <= 0) {
            return false;
        }
        
        return true;
    }
    
    public List<FillInBlank> getQuestionsForPractice(int limit) throws SQLException {
        return fillInBlankDAO.getRandomFillInBlank(limit);
    }
    
    public boolean checkAnswer(int questionId, String userAnswer) throws SQLException {
        FillInBlank question = fillInBlankDAO.getFillInBlankById(questionId);
        if (question == null) {
            return false;
        }
        
        return question.getCorrectAnswer().equalsIgnoreCase(userAnswer.trim());
    }
} 