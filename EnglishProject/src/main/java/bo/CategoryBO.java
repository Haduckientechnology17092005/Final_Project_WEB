package bo;

import java.sql.SQLException;
import java.util.List;
import bean.Category;
import dao.CategoryDAO;

public class CategoryBO {
    private CategoryDAO categoryDAO;
    
    public CategoryBO() {
        this.categoryDAO = new CategoryDAO();
    }
    
    public List<Category> getAllCategories() throws SQLException {
        return categoryDAO.getAllCategories();
    }
    
    public Category getCategoryById(int id) throws SQLException {
        return categoryDAO.getCategoryById(id);
    }
    
    public Category getCategoryByName(String name) throws SQLException {
        return categoryDAO.getCategoryByName(name);
    }
    
    public int addCategory(Category category) throws SQLException {
        return categoryDAO.addCategory(category);
    }
    
    public boolean updateCategory(Category category) throws SQLException {
        return categoryDAO.updateCategory(category);
    }
    
    public boolean deleteCategory(int id) throws SQLException {
        return categoryDAO.deleteCategory(id);
    }
    
    public Category getOrCreateCategory(String name) throws SQLException {
        return categoryDAO.getOrCreateCategory(name);
    }
    
    public boolean validateCategory(Category category) {
        if (category.getName() == null || category.getName().trim().isEmpty()) {
            return false;
        }
        return true;
    }
} 