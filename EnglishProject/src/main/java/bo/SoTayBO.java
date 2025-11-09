package bo;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import bean.Category;
import bean.Vocabulary;
import dao.DbConnect;

public class SoTayBO {
    private VocabularyBO vocabularyBO;
    private CategoryBO categoryBO;
    private LearningBO learningBO;
    private AudioBO audioBO;
    
    public SoTayBO() {
        this.vocabularyBO = new VocabularyBO();
        this.categoryBO = new CategoryBO();
        this.learningBO = new LearningBO();
        this.audioBO = new AudioBO();
    }
    
    public Map<String, Object> getSoTayData(String userEmail, String categoryFilter) throws SQLException {
        Map<String, Object> data = new HashMap<>();
        
        // Get progress data
        Map<String, Integer> progress = learningBO.getProgressByUser(userEmail);
        data.put("progress", progress);
        
        // Get vocabulary with progress
        List<Vocabulary> vocabularyList = learningBO.getVocabularyWithProgress(userEmail, categoryFilter);
        data.put("vocabulary", vocabularyList);
        
        // Get total vocabulary count
        int totalVocabulary = vocabularyList.size();
        data.put("totalVocabulary", totalVocabulary);
        
        // Get all categories
        List<Category> categories = categoryBO.getAllCategories();
        data.put("categories", categories);
        
        return data;
    }
    
    public Map<String, Object> getSoTayData(String userEmail) throws SQLException {
        return getSoTayData(userEmail, "all");
    }
    
    public boolean addVocabularyToUser(String userEmail, Vocabulary vocab, String meaning, String example) throws SQLException {
        // Validate vocabulary
        if (!vocabularyBO.validateVocabulary(vocab)) {
            return false;
        }
        
        // Generate audio and phonetics if not provided
        if ((vocab.getAudioUrl() == null || vocab.getAudioUrl().isEmpty()) ||
            (vocab.getPhonetic() == null || vocab.getPhonetic().isEmpty())) {
            
            System.out.println("Generating audio and phonetics for word: " + vocab.getRaw());
            try {
                AudioBO.AudioInfo audioInfo = audioBO.generateAudioAndPhonetics(vocab.getRaw());
                
                if (vocab.getAudioUrl() == null || vocab.getAudioUrl().isEmpty()) {
                    vocab.setAudioUrl(audioInfo.getAudioUrl());
                }
                
                if (vocab.getPhonetic() == null || vocab.getPhonetic().isEmpty()) {
                    vocab.setPhonetic(audioInfo.getPhonetic());
                }
                
                System.out.println("DEBUG: SoTayBO - Audio generation completed for word: " + vocab.getRaw());
                System.out.println("DEBUG: SoTayBO - Final audio URL: " + vocab.getAudioUrl());
                System.out.println("DEBUG: SoTayBO - Final phonetic: " + vocab.getPhonetic());
                
            } catch (Exception e) {
                System.err.println("Error generating audio/phonetics for word: " + vocab.getRaw() + " - " + e.getMessage());
                // Continue with vocabulary addition even if audio generation fails
                if (vocab.getAudioUrl() == null || vocab.getAudioUrl().isEmpty()) {
                    vocab.setAudioUrl("");
                }
                if (vocab.getPhonetic() == null || vocab.getPhonetic().isEmpty()) {
                    vocab.setPhonetic("");
                }
            }
        }
        
        // Add vocabulary
        int vocabId = vocabularyBO.addVocabulary(vocab);
        if (vocabId <= 0) {
            return false;
        }
        
        // Save meaning and example to definition table
        if (meaning != null && !meaning.trim().isEmpty()) {
            try {
                // Create meaning record
                int meaningId = createMeaning(vocabId, "noun"); // Default to noun
                
                // Create definition record
                createDefinition(meaningId, meaning.trim(), example);
                
                System.out.println("DEBUG: SoTayBO - Saved meaning and example for vocab ID: " + vocabId);
            } catch (Exception e) {
                System.err.println("Error saving meaning/example: " + e.getMessage());
                // Continue even if definition saving fails
            }
        }
        
        // Add to user's learning list
        return learningBO.markForReview(userEmail, vocabId);
    }
    
    public boolean addVocabularyToUser(String userEmail, Vocabulary vocab) throws SQLException {
        return addVocabularyToUser(userEmail, vocab, null, null);
    }
    
    private int createMeaning(int vocabId, String partOfSpeech) throws SQLException {
        // Insert into meaning table
        String sql = "INSERT INTO Meaning (vocab_id, partOfSpeech) VALUES (?, ?)";
        try (java.sql.Connection conn = dao.DbConnect.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, vocabId);
            pstmt.setString(2, partOfSpeech);
            pstmt.executeUpdate();
            
            java.sql.ResultSet rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                int meaningId = rs.getInt(1);
                System.out.println("DEBUG: SoTayBO - Created meaning with ID: " + meaningId);
                return meaningId;
            }
        }
        return 0;
    }
    
    private void createDefinition(int meaningId, String definition, String example) throws SQLException {
        // Insert into definition table
        String sql = "INSERT INTO Definition (meaning_id, definition, example) VALUES (?, ?, ?)";
        try (java.sql.Connection conn = dao.DbConnect.getConnection();
             java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, meaningId);
            pstmt.setString(2, definition);
            pstmt.setString(3, example);
            pstmt.executeUpdate();
            
            System.out.println("DEBUG: SoTayBO - Created definition for meaning ID: " + meaningId);
        }
    }
    
    public boolean updateProgress(String userEmail, int vocabId, boolean isLearned, boolean isReview) throws SQLException {
        if (isLearned) {
            return learningBO.markAsLearned(userEmail, vocabId);
        } else if (isReview) {
            return learningBO.markForReview(userEmail, vocabId);
        }
        return false;
    }
    
    // Getter methods for BO instances
    public CategoryBO getCategoryBO() {
        return categoryBO;
    }
    
    public VocabularyBO getVocabularyBO() {
        return vocabularyBO;
    }
    
    public LearningBO getLearningBO() {
        return learningBO;
    }
    
    public AudioBO getAudioBO() {
        return audioBO;
    }
} 