package dao;

import java.sql.*;
import java.util.*;
import bean.Learning;
import bean.Vocabulary;

public class LearningDAO {
    
    public List<Learning> getLearningByUser(String email) throws SQLException {
        List<Learning> learningList = new ArrayList<>();
        String sql = "SELECT * FROM learning WHERE email = ?";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Learning learning = new Learning();
                    learning.setId(rs.getInt("id"));
                    learning.setEmail(rs.getString("email"));
                    learning.setUserId(rs.getInt("user_id"));
                    learning.setVocabId(rs.getInt("vocab_id"));
                    learning.setLearned(rs.getBoolean("is_learned"));
                    learning.setReview(rs.getBoolean("is_review"));
                    learningList.add(learning);
                }
            }
        }
        return learningList;
    }
    
    public Learning getLearningByUserAndVocab(String email, int vocabId) throws SQLException {
        String sql = "SELECT * FROM learning WHERE email = ? AND vocab_id = ?";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            stmt.setInt(2, vocabId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Learning learning = new Learning();
                    learning.setId(rs.getInt("id"));
                    learning.setEmail(rs.getString("email"));
                    learning.setUserId(rs.getInt("user_id"));
                    learning.setVocabId(rs.getInt("vocab_id"));
                    learning.setLearned(rs.getBoolean("is_learned"));
                    learning.setReview(rs.getBoolean("is_review"));
                    return learning;
                }
            }
        }
        return null;
    }
    
    public boolean addLearning(Learning learning) throws SQLException {
        String sql = "INSERT INTO learning (email, user_id, vocab_id, is_learned, is_review) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, learning.getEmail());
            stmt.setInt(2, learning.getUserId());
            stmt.setInt(3, learning.getVocabId());
            stmt.setBoolean(4, learning.isLearned());
            stmt.setBoolean(5, learning.isReview());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean updateLearning(Learning learning) throws SQLException {
        String sql = "UPDATE learning SET is_learned = ?, is_review = ? WHERE email = ? AND vocab_id = ?";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setBoolean(1, learning.isLearned());
            stmt.setBoolean(2, learning.isReview());
            stmt.setString(3, learning.getEmail());
            stmt.setInt(4, learning.getVocabId());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean deleteLearning(String email, int vocabId) throws SQLException {
        String sql = "DELETE FROM learning WHERE email = ? AND vocab_id = ?";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            stmt.setInt(2, vocabId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Get vocabulary that needs review
     */
//    public List<Vocabulary> getVocabularyForReview(String email) throws SQLException {
//        List<Vocabulary> vocabularyList = new ArrayList<>();
//        String sql = "SELECT v.*, " +
//                "GROUP_CONCAT(DISTINCT d.definition SEPARATOR '|') as definitions, " +
//                "GROUP_CONCAT(DISTINCT d.example SEPARATOR '|') as examples " +
//                "FROM vocabulary v " +
//                "LEFT JOIN meaning m ON v.id = m.vocab_id " +
//                "LEFT JOIN definition d ON m.id = d.meaning_id " +
//                "GROUP BY v.id " +
//                "ORDER BY RAND()";
//        
//        try (Connection conn = DbConnect.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            
//            stmt.setString(1, email);
//            try (ResultSet rs = stmt.executeQuery()) {
//                while (rs.next()) {
//                    Vocabulary vocab = new Vocabulary();
//                    vocab.setId(rs.getInt("id"));
//                    vocab.setRaw(rs.getString("raw"));
//                    vocab.setPhonetic(rs.getString("phonetic"));
//                    vocab.setAudioUrl(rs.getString("audio_url"));
//                    vocab.setOrigin(rs.getString("origin"));
//                    vocab.setCategoryId(rs.getObject("category_id") != null ? rs.getInt("category_id") : null);
//                    vocab.setDefinitions(rs.getString("definitions"));
//                    vocab.setExamples(rs.getString("examples"));
//                    vocabularyList.add(vocab);
//                }
//            }
//        }
//        return vocabularyList;
//    }
//    
    public List<Vocabulary> getVocabularyForReview(String email) throws SQLException {
        List<Vocabulary> vocabularyList = new ArrayList<>();
        String sql = "SELECT v.id, v.raw, v.phonetic, v.audio_url, v.origin, v.category_id, " +
                     "GROUP_CONCAT(DISTINCT d.definition SEPARATOR '|') as definitions, " +
                     "GROUP_CONCAT(DISTINCT d.example SEPARATOR '|') as examples " +
                     "FROM vocabulary v " +
                     "INNER JOIN learning l ON v.id = l.vocab_id AND l.email = ? " +
                     "LEFT JOIN meaning m ON v.id = m.vocab_id " +
                     "LEFT JOIN definition d ON m.id = d.meaning_id " +
                     "WHERE l.is_review = true " +
                     "GROUP BY v.id, v.raw, v.phonetic, v.audio_url, v.origin, v.category_id " + // ✅ Đầy đủ GROUP BY
                     "ORDER BY v.raw";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Vocabulary vocab = mapResultSetToVocabularyWithDetails(rs);
                    vocabularyList.add(vocab);
                }
            }
        }
        return vocabularyList;
    }
    /**
     * Get vocabulary that has been mastered
     */
//    public List<Vocabulary> getVocabularyMastered(String email) throws SQLException {
//        List<Vocabulary> vocabularyList = new ArrayList<>();
//        String sql = "SELECT v.*, " +
//                     "GROUP_CONCAT(DISTINCT d.definition SEPARATOR '|') as definitions, " +
//                     "GROUP_CONCAT(DISTINCT d.example SEPARATOR '|') as examples " +
//                     "FROM vocabulary v " +
//                     "LEFT JOIN learning l ON v.id = l.vocab_id AND l.email = ? " +
//                     "LEFT JOIN meaning m ON v.id = m.vocab_id " +
//                     "LEFT JOIN definition d ON m.id = d.meaning_id " +
//                     "WHERE l.is_learned = true " +
//                     "GROUP BY v.id " +
//                     "ORDER BY v.raw";
//        
//        try (Connection conn = DbConnect.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            
//            stmt.setString(1, email);
//            try (ResultSet rs = stmt.executeQuery()) {
//                while (rs.next()) {
//                    Vocabulary vocab = new Vocabulary();
//                    vocab.setId(rs.getInt("id"));
//                    vocab.setRaw(rs.getString("raw"));
//                    vocab.setPhonetic(rs.getString("phonetic"));
//                    vocab.setAudioUrl(rs.getString("audio_url"));
//                    vocab.setOrigin(rs.getString("origin"));
//                    vocab.setCategoryId(rs.getObject("category_id") != null ? rs.getInt("category_id") : null);
//                    vocab.setDefinitions(rs.getString("definitions"));
//                    vocab.setExamples(rs.getString("examples"));
//                    vocabularyList.add(vocab);
//                }
//            }
//        }
//        return vocabularyList;
//    }
    public List<Vocabulary> getVocabularyMastered(String email) throws SQLException {
        List<Vocabulary> vocabularyList = new ArrayList<>();
        String sql = "SELECT v.id, v.raw, v.phonetic, v.audio_url, v.origin, v.category_id, " +
                     "GROUP_CONCAT(DISTINCT d.definition SEPARATOR '|') as definitions, " +
                     "GROUP_CONCAT(DISTINCT d.example SEPARATOR '|') as examples " +
                     "FROM vocabulary v " +
                     "INNER JOIN learning l ON v.id = l.vocab_id AND l.email = ? " +
                     "LEFT JOIN meaning m ON v.id = m.vocab_id " +
                     "LEFT JOIN definition d ON m.id = d.meaning_id " +
                     "WHERE l.is_learned = true " +
                     "GROUP BY v.id, v.raw, v.phonetic, v.audio_url, v.origin, v.category_id " + // ✅ Đầy đủ GROUP BY
                     "ORDER BY v.raw";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Vocabulary vocab = mapResultSetToVocabularyWithDetails(rs);
                    vocabularyList.add(vocab);
                }
            }
        }
        return vocabularyList;
    }
    
    /**
     * Get all vocabulary for comprehensive practice
     */
//    public List<Vocabulary> getAllVocabularyForPractice(String email) throws SQLException {
//        List<Vocabulary> vocabularyList = new ArrayList<>();
//        String sql = "SELECT v.*, " +
//                     "GROUP_CONCAT(DISTINCT d.definition SEPARATOR '|') as definitions, " +
//                     "GROUP_CONCAT(DISTINCT d.example SEPARATOR '|') as examples " +
//                     "FROM vocabulary v " +
//                     "LEFT JOIN meaning m ON v.id = m.vocab_id " +
//                     "LEFT JOIN definition d ON m.id = d.meaning_id " +
//                     "GROUP BY v.id " +
//                     "ORDER BY RAND()";
//        
//        System.out.println("DEBUG: LearningDAO - getAllVocabularyForPractice SQL: " + sql);
//        System.out.println("DEBUG: LearningDAO - getAllVocabularyForPractice email: " + email);
//        
//        try (Connection conn = DbConnect.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            
//            try (ResultSet rs = stmt.executeQuery()) {
//                while (rs.next()) {
//                    Vocabulary vocab = new Vocabulary();
//                    vocab.setId(rs.getInt("id"));
//                    vocab.setRaw(rs.getString("raw"));
//                    vocab.setPhonetic(rs.getString("phonetic"));
//                    vocab.setAudioUrl(rs.getString("audio_url"));
//                    vocab.setOrigin(rs.getString("origin"));
//                    vocab.setCategoryId(rs.getObject("category_id") != null ? rs.getInt("category_id") : null);
//                    vocab.setDefinitions(rs.getString("definitions"));
//                    vocab.setExamples(rs.getString("examples"));
//                    vocabularyList.add(vocab);
//                }
//            }
//        }
//        
//        System.out.println("DEBUG: LearningDAO - getAllVocabularyForPractice found " + vocabularyList.size() + " vocabulary");
//        return vocabularyList;
//    }
    public List<Vocabulary> getAllVocabularyForPractice(String email) throws SQLException {
        List<Vocabulary> vocabularyList = new ArrayList<>();
        String sql = "SELECT v.id, v.raw, v.phonetic, v.audio_url, v.origin, v.category_id, " +
                     "GROUP_CONCAT(DISTINCT d.definition SEPARATOR '|') as definitions, " +
                     "GROUP_CONCAT(DISTINCT d.example SEPARATOR '|') as examples " +
                     "FROM vocabulary v " +
                     "LEFT JOIN meaning m ON v.id = m.vocab_id " +
                     "LEFT JOIN definition d ON m.id = d.meaning_id " +
                     "GROUP BY v.id, v.raw, v.phonetic, v.audio_url, v.origin, v.category_id " + // ✅ Đầy đủ GROUP BY
                     "ORDER BY RAND()";
        
        System.out.println("DEBUG: LearningDAO - getAllVocabularyForPractice SQL: " + sql);
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Vocabulary vocab = mapResultSetToVocabularyWithDetails(rs);
                    vocabularyList.add(vocab);
                }
            }
        }
        
        System.out.println("DEBUG: LearningDAO - getAllVocabularyForPractice found " + vocabularyList.size() + " vocabulary");
        return vocabularyList;
    }
    
    public Map<String, Integer> getProgressByUser(String email) throws SQLException {
        Map<String, Integer> progress = new HashMap<>();
        
        // Get total vocabulary count
        String totalSql = "SELECT COUNT(*) as total FROM vocabulary";
        int totalVocabulary = 0;
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(totalSql)) {
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    totalVocabulary = rs.getInt("total");
                }
            }
        }
        
        // Get learning progress
        String progressSql = "SELECT " +
                           "COUNT(CASE WHEN is_learned = 1 THEN 1 END) as mastered, " +
                           "COUNT(CASE WHEN is_review = 1 AND is_learned = 0 THEN 1 END) as need_review " +
                           "FROM learning WHERE email = ?";
        
        int mastered = 0;
        int needReview = 0;
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(progressSql)) {
            
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    mastered = rs.getInt("mastered");
                    needReview = rs.getInt("need_review");
                }
            }
        }
        
        progress.put("mastered", mastered);
        progress.put("need_review", needReview);
        progress.put("total_vocabulary", totalVocabulary);
        
        return progress;
    }
    
//    public List<Vocabulary> getVocabularyWithProgress(String email, String categoryFilter) throws SQLException {
//        List<Vocabulary> vocabList = new ArrayList<>();
//        String sql = "SELECT v.id, v.raw, v.phonetic, v.audio_url, v.origin, v.category_id, " +
//                    "c.name as category_name, " +
//                    "GROUP_CONCAT(d.definition SEPARATOR '|') as definitions, " +
//                    "GROUP_CONCAT(d.example SEPARATOR '|') as examples, " +
//                    "l.is_learned, l.is_review " +
//                    "FROM vocabulary v " +
//                    "LEFT JOIN category c ON v.category_id = c.id " +
//                    "LEFT JOIN meaning m ON v.id = m.vocab_id " +
//                    "LEFT JOIN definition d ON m.id = d.meaning_id " +
//                    "LEFT JOIN learning l ON v.id = l.vocab_id AND l.email = ? " +
//                    "GROUP BY v.id";
//        
//        if (categoryFilter != null && !categoryFilter.equals("all")) {
//            sql += " HAVING category_name = ? OR (category_name IS NULL AND ? = 'uncategorized')";
//        }
//        
//        sql += " ORDER BY v.raw";
//        
//        try (Connection conn = DbConnect.getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            
//            int paramIndex = 1;
//            stmt.setString(paramIndex++, email);
//            
//            if (categoryFilter != null && !categoryFilter.equals("all")) {
//                stmt.setString(paramIndex++, categoryFilter);
//                stmt.setString(paramIndex++, categoryFilter);
//            }
//            
//            try (ResultSet rs = stmt.executeQuery()) {
//                while (rs.next()) {
//                    Vocabulary vocab = new Vocabulary();
//                    int vocabId = rs.getInt("id");
//                    vocab.setId(vocabId);
//                    
//                    String raw = rs.getString("raw");
//                    vocab.setRaw(raw);
//                    vocab.setPhonetic(rs.getString("phonetic"));
//                    vocab.setAudioUrl(rs.getString("audio_url"));
//                    vocab.setOrigin(rs.getString("origin"));
//                    vocab.setCategoryId(rs.getInt("category_id"));
//                    
//                    // Set definitions and examples
//                    String definitions = rs.getString("definitions");
//                    String examples = rs.getString("examples");
//                    
//                    vocab.setDefinitions(definitions);
//                    vocab.setExamples(examples);
//                    
//                    vocabList.add(vocab);
//                }
//            }
//        }
//        return vocabList;
//    }
    public List<Vocabulary> getVocabularyWithProgress(String email, String categoryFilter) throws SQLException {
        List<Vocabulary> vocabList = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT v.id, v.raw, v.phonetic, v.audio_url, v.origin, v.category_id, ")
           .append("c.name as category_name, ")
           .append("GROUP_CONCAT(DISTINCT d.definition SEPARATOR '|') as definitions, ")
           .append("GROUP_CONCAT(DISTINCT d.example SEPARATOR '|') as examples, ")
           .append("MAX(l.is_learned) as is_learned, ")  // ✅ Sử dụng aggregate function
           .append("MAX(l.is_review) as is_review ")      // ✅ Sử dụng aggregate function
           .append("FROM vocabulary v ")
           .append("LEFT JOIN category c ON v.category_id = c.id ")
           .append("LEFT JOIN meaning m ON v.id = m.vocab_id ")
           .append("LEFT JOIN definition d ON m.id = d.meaning_id ")
           .append("LEFT JOIN learning l ON v.id = l.vocab_id AND l.email = ? ")
           .append("GROUP BY v.id, v.raw, v.phonetic, v.audio_url, v.origin, v.category_id, c.name"); // ✅ Đầy đủ GROUP BY
        
        if (categoryFilter != null && !categoryFilter.equals("all")) {
            sql.append(" HAVING category_name = ? OR (category_name IS NULL AND ? = 'uncategorized')");
        }
        
        sql.append(" ORDER BY v.raw");
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            stmt.setString(paramIndex++, email);
            
            if (categoryFilter != null && !categoryFilter.equals("all")) {
                stmt.setString(paramIndex++, categoryFilter);
                stmt.setString(paramIndex++, categoryFilter);
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Vocabulary vocab = mapResultSetToVocabularyWithDetails(rs);
                    vocabList.add(vocab);
                }
            }
        }
        return vocabList;
    }
    private Vocabulary mapResultSetToVocabularyWithDetails(ResultSet rs) throws SQLException {
        Vocabulary vocab = new Vocabulary();
        vocab.setId(rs.getInt("id"));
        vocab.setRaw(rs.getString("raw"));
        vocab.setPhonetic(rs.getString("phonetic"));
        vocab.setAudioUrl(rs.getString("audio_url"));
        vocab.setOrigin(rs.getString("origin"));
        
        // Xử lý category_id có thể null
        Object categoryId = rs.getObject("category_id");
        if (categoryId != null) {
            vocab.setCategoryId((Integer) categoryId);
        }
        
        // Xử lý definitions và examples
        vocab.setDefinitions(rs.getString("definitions"));
        vocab.setExamples(rs.getString("examples"));
        
        return vocab;
    }
    
    /**
     * Get all learning records for admin management
     */
    public List<Learning> getAllLearningRecords() throws SQLException {
        List<Learning> learningList = new ArrayList<>();
        String sql = "SELECT * FROM learning ORDER BY id";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Learning learning = new Learning();
                    learning.setId(rs.getInt("id"));
                    learning.setEmail(rs.getString("email"));
                    learning.setUserId(rs.getInt("user_id"));
                    learning.setVocabId(rs.getInt("vocab_id"));
                    learning.setLearned(rs.getBoolean("is_learned"));
                    learning.setReview(rs.getBoolean("is_review"));
                    learningList.add(learning);
                }
            }
        }
        return learningList;
    }
} 