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
    <title>Quản lý từ vựng - Admin</title>
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
            max-width: 1400px;
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
        
        .search-box {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .filters {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .filter-select {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .vocabulary-table {
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
        
        .vocab-row {
            display: grid;
            grid-template-columns: 60px 1fr 120px 120px 100px 120px 150px;
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            align-items: center;
        }
        
        .vocab-row:hover {
            background: #f8f9fa;
        }
        
        .vocab-row:nth-child(even) {
            background: #f8f9fa;
        }
        
        .vocab-word {
            font-weight: 600;
            color: #2c3e50;
            font-size: 16px;
        }
        
        .vocab-phonetic {
            font-size: 12px;
            color: #7f8c8d;
            font-style: italic;
        }
        
        .vocab-category {
            padding: 5px 10px;
            background: #3498db;
            color: white;
            border-radius: 15px;
            font-size: 12px;
            text-align: center;
        }
        
        .vocab-definitions {
            max-width: 200px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            font-size: 12px;
            color: #555;
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
        
        .audio-btn {
            background: #27ae60;
            color: white;
            border: none;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .audio-btn:hover {
            background: #229954;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📚 Quản lý từ vựng</h1>
            <p>Quản lý tất cả từ vựng trong hệ thống</p>
        </div>
        
        <div class="stats">
            <div class="stat-card">
                <div class="stat-number">${totalVocabulary}</div>
                <div class="stat-label">Tổng từ vựng</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${categoriesCount}</div>
                <div class="stat-label">Danh mục</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${withAudio}</div>
                <div class="stat-label">Có phát âm</div>
            </div>
        </div>
        
        <div class="actions">
            <input type="text" class="search-box" placeholder="Tìm kiếm từ vựng..." id="searchInput">
            <button class="btn btn-primary" onclick="addVocabulary()">➕ Thêm từ vựng</button>
            <button class="btn btn-success" onclick="importVocabulary()">📥 Import</button>
            <button class="btn btn-warning" onclick="generateAudio()">🎵 Tạo phát âm</button>
        </div>
        
        <div class="filters">
            <select class="filter-select" id="categoryFilter">
                <option value="">Tất cả danh mục</option>
                <%
                    CategoryBO categoryBO = new CategoryBO();
                    List<Category> categories = categoryBO.getAllCategories();
                    if (categories != null) {
                        for (Category category : categories) {
                %>
                    <option value="<%= category.getId() %>"><%= category.getName() %></option>
                <%
                        }
                    }
                %>
            </select>
            <select class="filter-select" id="sortFilter">
                <option value="id">Sắp xếp theo ID</option>
                <option value="word">Sắp xếp theo từ</option>
                <option value="category">Sắp xếp theo danh mục</option>
            </select>
        </div>
        
        <div class="vocabulary-table">
            <div class="table-header">
                <div class="vocab-row">
                    <div>ID</div>
                    <div>Từ vựng</div>
                    <div>Phát âm</div>
                    <div>Danh mục</div>
                    <div>Định nghĩa</div>
                    <div>Audio</div>
                    <div>Thao tác</div>
                </div>
            </div>
            
            <div class="table-content">
                <%
                    VocabularyBO vocabularyBO = new VocabularyBO();
                    List<Vocabulary> vocabularies = vocabularyBO.getAllVocabulary();
                    
                    if (vocabularies != null && !vocabularies.isEmpty()) {
                        for (Vocabulary vocab : vocabularies) {
                %>
                    <div class="vocab-row">
                        <div><%= vocab.getId() %></div>
                        <div>
                            <div class="vocab-word"><%= vocab.getRaw() %></div>
                            <div class="vocab-phonetic"><%= vocab.getPhonetic() != null ? vocab.getPhonetic() : "" %></div>
                        </div>
                        <div><%= vocab.getPhonetic() != null ? vocab.getPhonetic() : "N/A" %></div>
                        <div>
                            <span class="vocab-category">
                                <%= vocab.getCategoryId() != null ? "Category " + vocab.getCategoryId() : "N/A" %>
                            </span>
                        </div>
                        <div class="vocab-definitions">
                            <%= vocab.getDefinitions() != null ? vocab.getDefinitions() : "N/A" %>
                        </div>
                        <div>
                            <% if (vocab.getAudioUrl() != null && !vocab.getAudioUrl().isEmpty()) { %>
                                <button class="audio-btn" onclick="playAudio('<%= vocab.getAudioUrl() %>')">▶️</button>
                            <% } else { %>
                                <span style="color: #7f8c8d;">N/A</span>
                            <% } %>
                        </div>
                        <div class="action-buttons">
                            <button class="btn btn-primary btn-small" onclick="editVocabulary(<%= vocab.getId() %>)">✏️</button>
                            <button class="btn btn-warning btn-small" onclick="generateAudioForVocab(<%= vocab.getId() %>)">🎵</button>
                            <button class="btn btn-danger btn-small" onclick="deleteVocabulary(<%= vocab.getId() %>)">🗑️</button>
                        </div>
                    </div>
                <%
                        }
                    } else {
                %>
                    <div class="vocab-row">
                        <div colspan="7" style="text-align: center; padding: 40px; color: #7f8c8d;">
                            Không có từ vựng nào
                        </div>
                    </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
    
    <script>
        function addVocabulary() {
            window.location.href = 'add-vocabulary.jsp';
        }
        
        function editVocabulary(vocabId) {
            window.location.href = 'edit-vocabulary.jsp?id=' + vocabId;
        }
        
        function deleteVocabulary(vocabId) {
            if (confirm('Bạn có chắc muốn xóa từ vựng này?')) {
                fetch('api/vocabulary/' + vocabId, {
                    method: 'DELETE'
                }).then(response => {
                    if (response.ok) {
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra khi xóa từ vựng');
                    }
                });
            }
        }
        
        function importVocabulary() {
            window.location.href = 'vocabulary-import.jsp';
        }
        
        function generateAudio() {
            if (confirm('Tạo phát âm cho tất cả từ vựng chưa có audio?')) {
                fetch('api/vocabulary/generate-audio', {
                    method: 'POST'
                }).then(response => {
                    if (response.ok) {
                        alert('Đang tạo phát âm...');
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra khi tạo phát âm');
                    }
                });
            }
        }
        
        function generateAudioForVocab(vocabId) {
            fetch('api/vocabulary/' + vocabId + '/generate-audio', {
                method: 'POST'
            }).then(response => {
                if (response.ok) {
                    alert('Đã tạo phát âm thành công');
                    location.reload();
                } else {
                    alert('Có lỗi xảy ra khi tạo phát âm');
                }
            });
        }
        
        function playAudio(audioUrl) {
            const audio = new Audio(audioUrl);
            audio.play();
        }
        
        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const rows = document.querySelectorAll('.vocab-row');
            
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchTerm) ? 'grid' : 'none';
            });
        });
        
        // Category filter
        document.getElementById('categoryFilter').addEventListener('change', function() {
            const selectedCategory = this.value;
            const rows = document.querySelectorAll('.vocab-row');
            
            rows.forEach(row => {
                if (selectedCategory === '' || row.querySelector('.vocab-category').textContent.includes(selectedCategory)) {
                    row.style.display = 'grid';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html> 