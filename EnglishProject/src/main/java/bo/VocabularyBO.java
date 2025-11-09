package bo;

import java.sql.SQLException;
import java.util.List;
import bean.Vocabulary;
import dao.VocabularyDAO;

public class VocabularyBO {
    private VocabularyDAO vocabularyDAO;
    
    public VocabularyBO() {
        this.vocabularyDAO = new VocabularyDAO();
    }
    
    public List<Vocabulary> getAllVocabulary() throws SQLException {
        return vocabularyDAO.getAllVocabulary();
    }
    
    public List<Vocabulary> getVocabularyByCategory(int categoryId) throws SQLException {
        return vocabularyDAO.getVocabularyByCategory(categoryId);
    }
    
    public Vocabulary getVocabularyById(int id) throws SQLException {
        return vocabularyDAO.getVocabularyById(id);
    }
    
    public int addVocabulary(Vocabulary vocab) throws SQLException {
        return vocabularyDAO.addVocabulary(vocab);
    }
    
    public boolean updateVocabulary(Vocabulary vocab) throws SQLException {
        return vocabularyDAO.updateVocabulary(vocab);
    }
    
    public boolean deleteVocabulary(int id) throws SQLException {
        return vocabularyDAO.deleteVocabulary(id);
    }
    
    public boolean validateVocabulary(Vocabulary vocab) {
        if (vocab.getRaw() == null || vocab.getRaw().trim().isEmpty()) {
            return false;
        }
        return true;
    }
} 