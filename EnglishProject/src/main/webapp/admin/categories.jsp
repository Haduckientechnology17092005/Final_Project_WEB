<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>
<%@ page import="dao.*" %>
<%@ page import="bo.*" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý danh mục - Admin</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f8f9fa;
            color: #333;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .header h1 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .header p {
            color: #7f8c8d;
        }
        
        .actions {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: #3498db;
            color: white;
        }
        
        .btn-primary:hover {
            background: #2980b9;
        }
        
        .btn-success {
            background: #27ae60;
            color: white;
        }
        
        .btn-success:hover {
            background: #229954;
        }
        
        .btn-danger {
            background: #e74c3c;
            color: white;
        }
        
        .btn-danger:hover {
            background: #c0392b;
        }
        
        .search-box {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .categories-table {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .table-header {
            background: #34495e;
            color: white;
            padding: 15px 20px;
            font-weight: 600;
        }
        
        .table-content {
            max-height: 500px;
            overflow-y: auto;
        }
        
        .category-row {
            display: grid;
            grid-template-columns: 80px 1fr 150px 100px 150px;
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            align-items: center;
        }
        
        .category-row:hover {
            background: #f8f9fa;
        }
        
        .category-row:nth-child(even) {
            background: #f8f9fa;
        }
        
        .category-name {
            font-weight: 600;
            color: #2c3e50;
            font-size: 16px;
        }
        
        .category-count {
            padding: 5px 10px;
            background: #3498db;
            color: white;
            border-radius: 15px;
            font-size: 12px;
            text-align: center;
        }
        
        .action-buttons {
            display: flex;
            gap: 5px;
        }
        
        .btn-small {
            padding: 5px 10px;
            font-size: 12px;
        }
        
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .stat-number {
            font-size: 2em;
            font-weight: bold;
            color: #3498db;
        }
        
        .stat-label {
            color: #7f8c8d;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📂 Quản lý danh mục</h1>
            <p>Quản lý các danh mục từ vựng trong hệ thống</p>
        </div>
        
        <div class="stats">
            <div class="stat-card">
                <div class="stat-number">${totalCategories}</div>
                <div class="stat-label">Tổng danh mục</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${totalVocabulary}</div>
                <div class="stat-label">Tổng từ vựng</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${avgVocabPerCategory}</div>
                <div class="stat-label">TB từ vựng/danh mục</div>
            </div>
        </div>
        
        <div class="actions">
            <input type="text" class="search-box" placeholder="Tìm kiếm danh mục..." id="searchInput">
            <button class="btn btn-primary" onclick="addCategory()">➕ Thêm danh mục</button>
            <button class="btn btn-success" onclick="exportCategories()">📥 Xuất dữ liệu</button>
        </div>
        
        <div class="categories-table">
            <div class="table-header">
                <div class="category-row">
                    <div>ID</div>
                    <div>Tên danh mục</div>
                    <div>Số từ vựng</div>
                    <div>Trạng thái</div>
                    <div>Thao tác</div>
                </div>
            </div>
            
            <div class="table-content">
                <%
                    CategoryBO categoryBO = new CategoryBO();
                    List<Category> categories = categoryBO.getAllCategories();
                    
                    if (categories != null && !categories.isEmpty()) {
                        for (Category category : categories) {
                            // Get vocabulary count for this category
                            int vocabCount = categoryBO.getVocabularyCountByCategory(category.getId());
                %>
                    <div class="category-row">
                        <div><%= category.getId() %></div>
                        <div class="category-name"><%= category.getName() %></div>
                        <div>
                            <span class="category-count"><%= vocabCount %> từ</span>
                        </div>
                        <div>Hoạt động</div>
                        <div class="action-buttons">
                            <button class="btn btn-primary btn-small" onclick="editCategory('<%= category.getId() %>')">✏️</button>
                            <button class="btn btn-success btn-small" onclick="viewVocabularies('<%= category.getId() %>')">👁️</button>
                            <button class="btn btn-danger btn-small" onclick="deleteCategory('<%= category.getId() %>')">🗑️</button>
                        </div>
                    </div>
                <%
                        }
                    } else {
                %>
                    <div class="category-row">
                        <div colspan="5" style="text-align: center; padding: 40px; color: #7f8c8d;">
                            Không có danh mục nào
                        </div>
                    </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
    
    <script>
        function addCategory() {
            window.location.href = 'add-category.jsp';
        }
        
        function editCategory(categoryId) {
            window.location.href = 'edit-category.jsp?id=' + categoryId;
        }
        
        function viewVocabularies(categoryId) {
            window.location.href = 'vocabulary.jsp?category=' + categoryId;
        }
        
        function deleteCategory(categoryId) {
            if (confirm('Bạn có chắc muốn xóa danh mục này? Tất cả từ vựng trong danh mục sẽ bị ảnh hưởng.')) {
                fetch('api/categories/' + categoryId, {
                    method: 'DELETE'
                }).then(response => {
                    if (response.ok) {
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra khi xóa danh mục');
                    }
                });
            }
        }
        
        function exportCategories() {
            window.location.href = 'api/categories/export';
        }
        
        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const rows = document.querySelectorAll('.category-row');
            
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchTerm) ? 'grid' : 'none';
            });
        });
    </script>
</body>
</html> 