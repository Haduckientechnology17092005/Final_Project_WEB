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
    <title>Quản lý tiến độ học tập - Admin</title>
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
        
        .progress-table {
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
        
        .progress-row {
            display: grid;
            grid-template-columns: 80px 1fr 120px 100px 100px 100px 120px;
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            align-items: center;
        }
        
        .progress-row:hover {
            background: #f8f9fa;
        }
        
        .progress-row:nth-child(even) {
            background: #f8f9fa;
        }
        
        .user-info {
            display: flex;
            flex-direction: column;
        }
        
        .user-email {
            font-weight: 600;
            color: #2c3e50;
        }
        
        .user-id {
            font-size: 12px;
            color: #7f8c8d;
        }
        
        .vocab-word {
            font-weight: 600;
            color: #2c3e50;
        }
        
        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            text-align: center;
        }
        
        .status-learned {
            background: #27ae60;
            color: white;
        }
        
        .status-review {
            background: #f39c12;
            color: white;
        }
        
        .status-none {
            background: #95a5a6;
            color: white;
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
        
        .progress-bar {
            width: 100%;
            height: 8px;
            background: #ecf0f1;
            border-radius: 4px;
            overflow: hidden;
        }
        
        .progress-fill {
            height: 100%;
            background: #3498db;
            transition: width 0.3s ease;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📈 Quản lý tiến độ học tập</h1>
            <p>Theo dõi tiến độ học tập của tất cả người dùng</p>
        </div>
        
        <div class="stats">
            <div class="stat-card">
                <div class="stat-number">${totalUsers}</div>
                <div class="stat-label">Tổng người dùng</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${totalVocabulary}</div>
                <div class="stat-label">Tổng từ vựng</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${totalLearningRecords}</div>
                <div class="stat-label">Bản ghi học tập</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${avgProgress}%</div>
                <div class="stat-label">Tiến độ trung bình</div>
            </div>
        </div>
        
        <div class="actions">
            <input type="text" class="search-box" placeholder="Tìm kiếm người dùng hoặc từ vựng..." id="searchInput">
            <button class="btn btn-primary" onclick="exportProgress()">📥 Xuất báo cáo</button>
            <button class="btn btn-success" onclick="resetProgress()">🔄 Reset tiến độ</button>
        </div>
        
        <div class="filters">
            <select class="filter-select" id="userFilter">
                <option value="">Tất cả người dùng</option>
                <%
                    UserBO userBO = new UserBO();
                    List<User> users = userBO.getAllUsers();
                    if (users != null) {
                        for (User user : users) {
                %>
                    <option value="<%= user.getEmail() %>"><%= user.getEmail() %></option>
                <%
                        }
                    }
                %>
            </select>
            <select class="filter-select" id="statusFilter">
                <option value="">Tất cả trạng thái</option>
                <option value="learned">Đã học</option>
                <option value="review">Cần ôn tập</option>
                <option value="none">Chưa học</option>
            </select>
        </div>
        
        <div class="progress-table">
            <div class="table-header">
                <div class="progress-row">
                    <div>ID</div>
                    <div>Người dùng</div>
                    <div>Từ vựng</div>
                    <div>Trạng thái</div>
                    <div>Tiến độ</div>
                    <div>Ngày cập nhật</div>
                    <div>Thao tác</div>
                </div>
            </div>
            
            <div class="table-content">
                <%
                    LearningBO learningBO = new LearningBO();
                    List<Learning> learningRecords = learningBO.getAllLearningRecords();
                    
                    if (learningRecords != null && !learningRecords.isEmpty()) {
                        for (Learning learning : learningRecords) {
                            // Get vocabulary info
                            VocabularyBO vocabularyBO = new VocabularyBO();
                            Vocabulary vocab = vocabularyBO.getVocabularyById(learning.getVocabId());
                            
                            // Get user info
                            User user = userBO.getUserById(learning.getUserId());
                            
                            // Calculate progress percentage
                            int progressPercent = 0;
                            if (learning.isLearned()) {
                                progressPercent = 100;
                            } else if (learning.isReview()) {
                                progressPercent = 50;
                            }
                %>
                    <div class="progress-row">
                        <div><%= learning.getId() %></div>
                        <div class="user-info">
                            <div class="user-email"><%= user != null ? user.getEmail() : "N/A" %></div>
                            <div class="user-id">User ID: <%= learning.getUserId() %></div>
                        </div>
                        <div class="vocab-word">
                            <%= vocab != null ? vocab.getRaw() : "Vocab ID: " + learning.getVocabId() %>
                        </div>
                        <div>
                            <span class="status-badge <%= learning.isLearned() ? "status-learned" : (learning.isReview() ? "status-review" : "status-none") %>">
                                <%= learning.isLearned() ? "Đã học" : (learning.isReview() ? "Cần ôn tập" : "Chưa học") %>
                            </span>
                        </div>
                        <div>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: <%= progressPercent %>%"></div>
                            </div>
                            <small style="color: #7f8c8d;"><%= progressPercent %>%</small>
                        </div>
                        <div style="font-size: 12px; color: #7f8c8d;">
                            <%= new java.util.Date() %>
                        </div>
                        <div class="action-buttons">
                            <button class="btn btn-primary btn-small" onclick="editProgress(<%= learning.getId() %>)">✏️</button>
                            <button class="btn btn-success btn-small" onclick="markAsLearned(<%= learning.getId() %>)">✅</button>
                            <button class="btn btn-warning btn-small" onclick="markForReview(<%= learning.getId() %>)">⏰</button>
                        </div>
                    </div>
                <%
                        }
                    } else {
                %>
                    <div class="progress-row">
                        <div colspan="7" style="text-align: center; padding: 40px; color: #7f8c8d;">
                            Không có bản ghi học tập nào
                        </div>
                    </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
    
    <script>
        function exportProgress() {
            window.location.href = 'api/learning/export';
        }
        
        function resetProgress() {
            if (confirm('Bạn có chắc muốn reset tiến độ học tập của tất cả người dùng?')) {
                fetch('api/learning/reset', {
                    method: 'POST'
                }).then(response => {
                    if (response.ok) {
                        alert('Đã reset tiến độ thành công');
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra khi reset tiến độ');
                    }
                });
            }
        }
        
        function editProgress(learningId) {
            window.location.href = 'edit-progress.jsp?id=' + learningId;
        }
        
        function markAsLearned(learningId) {
            fetch('api/learning/' + learningId + '/mark-learned', {
                method: 'POST'
            }).then(response => {
                if (response.ok) {
                    location.reload();
                } else {
                    alert('Có lỗi xảy ra khi cập nhật trạng thái');
                }
            });
        }
        
        function markForReview(learningId) {
            fetch('api/learning/' + learningId + '/mark-review', {
                method: 'POST'
            }).then(response => {
                if (response.ok) {
                    location.reload();
                } else {
                    alert('Có lỗi xảy ra khi cập nhật trạng thái');
                }
            });
        }
        
        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const rows = document.querySelectorAll('.progress-row');
            
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchTerm) ? 'grid' : 'none';
            });
        });
        
        // User filter
        document.getElementById('userFilter').addEventListener('change', function() {
            const selectedUser = this.value;
            const rows = document.querySelectorAll('.progress-row');
            
            rows.forEach(row => {
                if (selectedUser === '' || row.querySelector('.user-email').textContent.includes(selectedUser)) {
                    row.style.display = 'grid';
                } else {
                    row.style.display = 'none';
                }
            });
        });
        
        // Status filter
        document.getElementById('statusFilter').addEventListener('change', function() {
            const selectedStatus = this.value;
            const rows = document.querySelectorAll('.progress-row');
            
            rows.forEach(row => {
                const statusBadge = row.querySelector('.status-badge');
                if (selectedStatus === '' || statusBadge.textContent.toLowerCase().includes(selectedStatus)) {
                    row.style.display = 'grid';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html> 