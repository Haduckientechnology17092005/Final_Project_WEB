package dao;

import java.sql.*;
import java.util.*;
import bean.Vocabulary;
import bean.Category;
import bean.Meaning;
import bean.Definition;

public class VocabularyDAO {
    
    public List<Vocabulary> getAllVocabulary() throws SQLException {
        List<Vocabulary> vocabList = new ArrayList<>();
        String sql = "SELECT * FROM vocabulary ORDER BY raw";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Vocabulary vocab = new Vocabulary();
                vocab.setId(rs.getInt("id"));
                vocab.setRaw(rs.getString("raw"));
                vocab.setPhonetic(rs.getString("phonetic"));
                vocab.setAudioUrl(rs.getString("audio_url"));
                vocab.setOrigin(rs.getString("origin"));
                vocab.setCategoryId(rs.getInt("category_id"));
                vocabList.add(vocab);
            }
        }
        return vocabList;
    }
    
    public List<Vocabulary> getVocabularyByCategory(int categoryId) throws SQLException {
        List<Vocabulary> vocabList = new ArrayList<>();
        String sql = "SELECT * FROM vocabulary WHERE category_id = ? ORDER BY raw";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Vocabulary vocab = new Vocabulary();
                    vocab.setId(rs.getInt("id"));
                    vocab.setRaw(rs.getString("raw"));
                    vocab.setPhonetic(rs.getString("phonetic"));
                    vocab.setAudioUrl(rs.getString("audio_url"));
                    vocab.setOrigin(rs.getString("origin"));
                    vocab.setCategoryId(rs.getInt("category_id"));
                    vocabList.add(vocab);
                }
            }
        }
        return vocabList;
    }
    
    public Vocabulary getVocabularyById(int id) throws SQLException {
        String sql = "SELECT * FROM vocabulary WHERE id = ?";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Vocabulary vocab = new Vocabulary();
                    vocab.setId(rs.getInt("id"));
                    vocab.setRaw(rs.getString("raw"));
                    vocab.setPhonetic(rs.getString("phonetic"));
                    vocab.setAudioUrl(rs.getString("audio_url"));
                    vocab.setOrigin(rs.getString("origin"));
                    vocab.setCategoryId(rs.getInt("category_id"));
                    return vocab;
                }
            }
        }
        return null;
    }
    
    public int addVocabulary(Vocabulary vocab) throws SQLException {
        String sql = "INSERT INTO vocabulary (raw, phonetic, audio_url, origin, category_id) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, vocab.getRaw());
            stmt.setString(2, vocab.getPhonetic());
            stmt.setString(3, vocab.getAudioUrl());
            stmt.setString(4, vocab.getOrigin());
            stmt.setObject(5, vocab.getCategoryId());
            
            stmt.executeUpdate();
            
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }
    
    public boolean updateVocabulary(Vocabulary vocab) throws SQLException {
        String sql = "UPDATE vocabulary SET raw = ?, phonetic = ?, audio_url = ?, origin = ?, category_id = ? WHERE id = ?";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, vocab.getRaw());
            stmt.setString(2, vocab.getPhonetic());
            stmt.setString(3, vocab.getAudioUrl());
            stmt.setString(4, vocab.getOrigin());
            stmt.setObject(5, vocab.getCategoryId());
            stmt.setInt(6, vocab.getId());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean deleteVocabulary(int id) throws SQLException {
        String sql = "DELETE FROM vocabulary WHERE id = ?";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }
} 