package dao;

import java.sql.*;
import java.util.*;
import bean.Category;

public class CategoryDAO {
    
    public List<Category> getAllCategories() throws SQLException {
        List<Category> categoryList = new ArrayList<>();
        String sql = "SELECT * FROM category ORDER BY name";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Category category = new Category();
                category.setId(rs.getInt("id"));
                category.setName(rs.getString("name"));
                categoryList.add(category);
            }
        }
        return categoryList;
    }
    
    public Category getCategoryById(int id) throws SQLException {
        String sql = "SELECT * FROM category WHERE id = ?";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Category category = new Category();
                    category.setId(rs.getInt("id"));
                    category.setName(rs.getString("name"));
                    return category;
                }
            }
        }
        return null;
    }
    
    public Category getCategoryByName(String name) throws SQLException {
        String sql = "SELECT * FROM category WHERE name = ?";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, name);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Category category = new Category();
                    category.setId(rs.getInt("id"));
                    category.setName(rs.getString("name"));
                    return category;
                }
            }
        }
        return null;
    }
    
    public int addCategory(Category category) throws SQLException {
        String sql = "INSERT INTO category (name) VALUES (?)";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, category.getName());
            stmt.executeUpdate();
            
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }
    
    public boolean updateCategory(Category category) throws SQLException {
        String sql = "UPDATE category SET name = ? WHERE id = ?";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, category.getName());
            stmt.setInt(2, category.getId());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    public boolean deleteCategory(int id) throws SQLException {
        String sql = "DELETE FROM category WHERE id = ?";
        
        try (Connection conn = DbConnect.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }
    
    public Category getOrCreateCategory(String name) throws SQLException {
        Category existingCategory = getCategoryByName(name);
        if (existingCategory != null) {
            return existingCategory;
        }
        
        Category newCategory = new Category();
        newCategory.setName(name);
        int newId = addCategory(newCategory);
        if (newId > 0) {
            newCategory.setId(newId);
            return newCategory;
        }
        return null;
    }
} 