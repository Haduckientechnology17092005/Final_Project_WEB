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
    <title>Quản lý bài tập điền từ - Admin</title>
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
        
        .btn-warning {
            background: #f39c12;
            color: white;
        }
        
        .btn-warning:hover {
            background: #e67e22;
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
        
        .exercises-table {
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
        
        .exercise-row {
            display: grid;
            grid-template-columns: 60px 2fr 1fr 1fr 1fr 120px;
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            align-items: center;
        }
        
        .exercise-row:hover {
            background: #f8f9fa;
        }
        
        .exercise-row:nth-child(even) {
            background: #f8f9fa;
        }
        
        .exercise-question {
            font-weight: 600;
            color: #2c3e50;
            font-size: 14px;
            line-height: 1.4;
        }
        
        .exercise-answer {
            font-size: 12px;
            color: #27ae60;
            font-weight: 600;
        }
        
        .exercise-options {
            font-size: 12px;
            color: #7f8c8d;
        }
        
        .vocab-link {
            color: #3498db;
            text-decoration: none;
            font-weight: 600;
        }
        
        .vocab-link:hover {
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
            <h1>✏️ Quản lý bài tập điền từ</h1>
            <p>Quản lý các bài tập điền từ trong hệ thống</p>
        </div>
        
        <div class="stats">
            <div class="stat-card">
                <div class="stat-number">${totalExercises}</div>
                <div class="stat-label">Tổng bài tập</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${activeExercises}</div>
                <div class="stat-label">Bài tập hoạt động</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${vocabulariesWithExercises}</div>
                <div class="stat-label">Từ vựng có bài tập</div>
            </div>
        </div>
        
        <div class="actions">
            <input type="text" class="search-box" placeholder="Tìm kiếm bài tập..." id="searchInput">
            <button class="btn btn-primary" onclick="addExercise()">➕ Thêm bài tập</button>
            <button class="btn btn-success" onclick="generateExercises()">🎲 Tạo tự động</button>
            <button class="btn btn-warning" onclick="importExercises()">📥 Import</button>
        </div>
        
        <div class="exercises-table">
            <div class="table-header">
                <div class="exercise-row">
                    <div>ID</div>
                    <div>Câu hỏi</div>
                    <div>Đáp án đúng</div>
                    <div>Đáp án sai</div>
                    <div>Từ vựng</div>
                    <div>Thao tác</div>
                </div>
            </div>
            
            <div class="table-content">
                <%
                    FillInBlankBO fillInBlankBO = new FillInBlankBO();
                    List<FillInBlank> exercises = fillInBlankBO.getAllFillInBlank();
                    
                    if (exercises != null && !exercises.isEmpty()) {
                        for (FillInBlank exercise : exercises) {
                %>
                    <div class="exercise-row">
                        <div><%= exercise.getId() %></div>
                        <div class="exercise-question">
                            <%= exercise.getQuestion() != null ? exercise.getQuestion() : "N/A" %>
                        </div>
                        <div class="exercise-answer">
                            <%= exercise.getCorrectAnswer() != null ? exercise.getCorrectAnswer() : "N/A" %>
                        </div>
                        <div class="exercise-options">
                            <%= exercise.getWrongAnswer1() != null ? exercise.getWrongAnswer1() : "N/A" %><br>
                            <%= exercise.getWrongAnswer2() != null ? exercise.getWrongAnswer2() : "N/A" %>
                        </div>
                        <div>
                            <a href="vocabulary.jsp?id=<%= exercise.getVocabularyId() %>" class="vocab-link">
                                Vocab ID: <%= exercise.getVocabularyId() %>
                            </a>
                        </div>
                        <div class="action-buttons">
                            <button class="btn btn-primary btn-small" onclick="editExercise(<%= exercise.getId() %>)">✏️</button>
                            <button class="btn btn-success btn-small" onclick="previewExercise(<%= exercise.getId() %>)">👁️</button>
                            <button class="btn btn-danger btn-small" onclick="deleteExercise(<%= exercise.getId() %>)">🗑️</button>
                        </div>
                    </div>
                <%
                        }
                    } else {
                %>
                    <div class="exercise-row">
                        <div colspan="6" style="text-align: center; padding: 40px; color: #7f8c8d;">
                            Không có bài tập nào
                        </div>
                    </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
    
    <script>
        function addExercise() {
            window.location.href = 'add-exercise.jsp';
        }
        
        function editExercise(exerciseId) {
            window.location.href = 'edit-exercise.jsp?id=' + exerciseId;
        }
        
        function previewExercise(exerciseId) {
            window.open('preview-exercise.jsp?id=' + exerciseId, '_blank');
        }
        
        function deleteExercise(exerciseId) {
            if (confirm('Bạn có chắc muốn xóa bài tập này?')) {
                fetch('api/exercises/' + exerciseId, {
                    method: 'DELETE'
                }).then(response => {
                    if (response.ok) {
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra khi xóa bài tập');
                    }
                });
            }
        }
        
        function generateExercises() {
            if (confirm('Tạo bài tập tự động cho các từ vựng chưa có bài tập?')) {
                fetch('api/exercises/generate', {
                    method: 'POST'
                }).then(response => {
                    if (response.ok) {
                        alert('Đang tạo bài tập...');
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra khi tạo bài tập');
                    }
                });
            }
        }
        
        function importExercises() {
            window.location.href = 'import-exercises.jsp';
        }
        
        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const rows = document.querySelectorAll('.exercise-row');
            
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchTerm) ? 'grid' : 'none';
            });
        });
    </script>
</body>
</html> 