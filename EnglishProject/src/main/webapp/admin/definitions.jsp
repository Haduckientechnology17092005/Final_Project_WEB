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
    <title>Quản lý định nghĩa - Admin</title>
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
            max-width: 1200px;
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
        
        .definitions-table {
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
            max-height: 600px;
            overflow-y: auto;
        }
        
        .definition-row {
            display: grid;
            grid-template-columns: 60px 2fr 1fr 1fr 120px;
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            align-items: center;
        }
        
        .definition-row:hover {
            background: #f8f9fa;
        }
        
        .definition-row:nth-child(even) {
            background: #f8f9fa;
        }
        
        .definition-text {
            font-weight: 600;
            color: #2c3e50;
            font-size: 14px;
            line-height: 1.4;
        }
        
        .example-text {
            font-size: 12px;
            color: #7f8c8d;
            font-style: italic;
        }
        
        .meaning-link {
            color: #3498db;
            text-decoration: none;
            font-weight: 600;
        }
        
        .meaning-link:hover {
            text-decoration: underline;
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
            <h1>📋 Quản lý định nghĩa</h1>
            <p>Quản lý các định nghĩa từ vựng trong hệ thống</p>
        </div>
        
        <div class="stats">
            <div class="stat-card">
                <div class="stat-number">${totalDefinitions}</div>
                <div class="stat-label">Tổng định nghĩa</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${totalMeanings}</div>
                <div class="stat-label">Tổng loại từ</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${avgDefinitionsPerVocab}</div>
                <div class="stat-label">TB định nghĩa/từ</div>
            </div>
        </div>
        
        <div class="actions">
            <input type="text" class="search-box" placeholder="Tìm kiếm định nghĩa..." id="searchInput">
            <button class="btn btn-primary" onclick="addDefinition()">➕ Thêm định nghĩa</button>
            <button class="btn btn-success" onclick="importDefinitions()">📥 Import</button>
        </div>
        
        <div class="definitions-table">
            <div class="table-header">
                <div class="definition-row">
                    <div>ID</div>
                    <div>Định nghĩa</div>
                    <div>Ví dụ</div>
                    <div>Loại từ</div>
                    <div>Thao tác</div>
                </div>
            </div>
            
            <div class="table-content">
                <%
                    // Get definitions with meaning info
                    // This would need a custom DAO method to join with meaning table
                    // For now, we'll show a placeholder
                %>
                <div class="definition-row">
                    <div colspan="5" style="text-align: center; padding: 40px; color: #7f8c8d;">
                        Cần implement DAO method để lấy định nghĩa với thông tin meaning
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function addDefinition() {
            window.location.href = 'add-definition.jsp';
        }
        
        function editDefinition(definitionId) {
            window.location.href = 'edit-definition.jsp?id=' + definitionId;
        }
        
        function deleteDefinition(definitionId) {
            if (confirm('Bạn có chắc muốn xóa định nghĩa này?')) {
                fetch('api/definitions/' + definitionId, {
                    method: 'DELETE'
                }).then(response => {
                    if (response.ok) {
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra khi xóa định nghĩa');
                    }
                });
            }
        }
        
        function importDefinitions() {
            window.location.href = 'import-definitions.jsp';
        }
        
        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const rows = document.querySelectorAll('.definition-row');
            
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchTerm) ? 'grid' : 'none';
            });
        });
    </script>
</body>
</html> 