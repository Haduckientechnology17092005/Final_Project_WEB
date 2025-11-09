package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import bean.FillInBlank;
import dao.DbConnect;

public class FillInBlankDAO {
    
    public List<FillInBlank> getAllFillInBlank() throws SQLException {
        List<FillInBlank> fillInBlankList = new ArrayList<>();
        String sql = "SELECT * FROM fill_in_blank ORDER BY id";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                FillInBlank fillInBlank = new FillInBlank();
                fillInBlank.setId(rs.getInt("id"));
                fillInBlank.setQuestion(rs.getString("question"));
                fillInBlank.setCorrectAnswer(rs.getString("correct_answer"));
                fillInBlank.setWrongAnswer1(rs.getString("wrong_answer_1"));
                fillInBlank.setWrongAnswer2(rs.getString("wrong_answer_2"));
                fillInBlank.setVocabularyId(rs.getInt("vocabulary_id"));
                
                fillInBlankList.add(fillInBlank);
            }
        }
        return fillInBlankList;
    }
    
    public FillInBlank getFillInBlankById(int id) throws SQLException {
        String sql = "SELECT * FROM fill_in_blank WHERE id = ?";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    FillInBlank fillInBlank = new FillInBlank();
                    fillInBlank.setId(rs.getInt("id"));
                    fillInBlank.setQuestion(rs.getString("question"));
                    fillInBlank.setCorrectAnswer(rs.getString("correct_answer"));
                    fillInBlank.setWrongAnswer1(rs.getString("wrong_answer_1"));
                    fillInBlank.setWrongAnswer2(rs.getString("wrong_answer_2"));
                    fillInBlank.setVocabularyId(rs.getInt("vocabulary_id"));
                    
                    return fillInBlank;
                }
            }
        }
        return null;
    }
    
    public List<FillInBlank> getFillInBlankByVocabularyId(int vocabularyId) throws SQLException {
        List<FillInBlank> fillInBlankList = new ArrayList<>();
        String sql = "SELECT * FROM fill_in_blank WHERE vocabulary_id = ?";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, vocabularyId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    FillInBlank fillInBlank = new FillInBlank();
                    fillInBlank.setId(rs.getInt("id"));
                    fillInBlank.setQuestion(rs.getString("question"));
                    fillInBlank.setCorrectAnswer(rs.getString("correct_answer"));
                    fillInBlank.setWrongAnswer1(rs.getString("wrong_answer_1"));
                    fillInBlank.setWrongAnswer2(rs.getString("wrong_answer_2"));
                    fillInBlank.setVocabularyId(rs.getInt("vocabulary_id"));
                    
                    fillInBlankList.add(fillInBlank);
                }
            }
        }
        return fillInBlankList;
    }
    
    public List<FillInBlank> getRandomFillInBlank(int limit) throws SQLException {
        List<FillInBlank> fillInBlankList = new ArrayList<>();
        String sql = "SELECT * FROM fill_in_blank ORDER BY RAND() LIMIT ?";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    FillInBlank fillInBlank = new FillInBlank();
                    fillInBlank.setId(rs.getInt("id"));
                    fillInBlank.setQuestion(rs.getString("question"));
                    fillInBlank.setCorrectAnswer(rs.getString("correct_answer"));
                    fillInBlank.setWrongAnswer1(rs.getString("wrong_answer_1"));
                    fillInBlank.setWrongAnswer2(rs.getString("wrong_answer_2"));
                    fillInBlank.setVocabularyId(rs.getInt("vocabulary_id"));
                    
                    fillInBlankList.add(fillInBlank);
                }
            }
        }
        return fillInBlankList;
    }
    
    public int addFillInBlank(FillInBlank fillInBlank) throws SQLException {
        String sql = "INSERT INTO fill_in_blank (question, correct_answer, wrong_answer_1, wrong_answer_2, vocabulary_id) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, fillInBlank.getQuestion());
            stmt.setString(2, fillInBlank.getCorrectAnswer());
            stmt.setString(3, fillInBlank.getWrongAnswer1());
            stmt.setString(4, fillInBlank.getWrongAnswer2());
            stmt.setInt(5, fillInBlank.getVocabularyId());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        }
        return -1;
    }
    
    public boolean updateFillInBlank(FillInBlank fillInBlank) throws SQLException {
        String sql = "UPDATE fill_in_blank SET question = ?, correct_answer = ?, wrong_answer_1 = ?, wrong_answer_2 = ?, vocabulary_id = ? WHERE id = ?";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, fillInBlank.getQuestion());
            stmt.setString(2, fillInBlank.getCorrectAnswer());
            stmt.setString(3, fillInBlank.getWrongAnswer1());
            stmt.setString(4, fillInBlank.getWrongAnswer2());
            stmt.setInt(5, fillInBlank.getVocabularyId());
            stmt.setInt(6, fillInBlank.getId());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean deleteFillInBlank(int id) throws SQLException {
        String sql = "DELETE FROM fill_in_blank WHERE id = ?";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean deleteFillInBlankByVocabularyId(int vocabularyId) throws SQLException {
        String sql = "DELETE FROM fill_in_blank WHERE vocabulary_id = ?";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, vocabularyId);
            return stmt.executeUpdate() > 0;
        }
    }
    
    public int getTotalFillInBlank() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM fill_in_blank";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }
    
    public boolean existsByVocabularyId(int vocabularyId) throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM fill_in_blank WHERE vocabulary_id = ?";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, vocabularyId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("count") > 0;
                }
            }
        }
        return false;
    }
} 