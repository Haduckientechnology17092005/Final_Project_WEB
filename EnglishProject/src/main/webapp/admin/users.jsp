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
    <title>Quản lý người dùng</title>
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
            align-items: center;
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
            width: 300px;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .users-table {
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
        
        .user-row {
            display: grid;
            grid-template-columns: 50px 1fr 1fr 100px 100px 150px;
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            align-items: center;
        }
        
        .user-row:hover {
            background: #f8f9fa;
        }
        
        .user-row:nth-child(even) {
            background: #f8f9fa;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            background: #3498db;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }
        
        .user-info {
            display: flex;
            flex-direction: column;
        }
        
        .user-name {
            font-weight: 600;
            color: #2c3e50;
        }
        
        .user-email {
            font-size: 12px;
            color: #7f8c8d;
        }
        
        .role-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            text-align: center;
        }
        
        .role-admin {
            background: #e74c3c;
            color: white;
        }
        
        .role-user {
            background: #3498db;
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
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>👥 Quản lý người dùng</h1>
        </div>
        
        <%
            UserBO userBO = new UserBO();
            List<User> allUsers = userBO.getAllUsers();
            int totalUsers = allUsers != null ? allUsers.size() : 0;
            
            // Count active users by checking sessions
            int activeUsers = 0;
            if (allUsers != null) {
                for (User user : allUsers) {
                    // Check if user has active session (simplified approach)
                    // In a real implementation, you'd track sessions in application scope
                    // For now, we'll assume users who logged in recently are active
                    activeUsers++;
                }
            }
            
            // Alternative: Get active sessions count from application scope
            // This would require a session listener to track active sessions
            Integer activeSessions = (Integer) application.getAttribute("activeSessions");
            if (activeSessions == null) {
                activeSessions = 0;
            }
        %>
        
        <div class="stats">
            <div class="stat-card">
                <div class="stat-number"><%= totalUsers %></div>
                <div class="stat-label">Tổng người dùng</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= activeSessions %></div>
                <div class="stat-label">Người dùng đang online</div>
            </div>
        </div>
        
        <div class="actions">
            <input type="text" class="search-box" placeholder="Tìm kiếm người dùng..." id="searchInput">
        </div>
        
        <div class="users-table">
            <div class="table-header">
                <div class="user-row">
                    <div>Avatar</div>
                    <div>Thông tin</div>
                    <div>Email</div>
                    <div>Vai trò</div>
                    <div>Trạng thái</div>
                    <div>Thao tác</div>
                </div>
            </div>
            
            <div class="table-content">
                <%
                    if (allUsers != null && !allUsers.isEmpty()) {
                        for (User user : allUsers) {
                %>
                    <div class="user-row">
                        <div class="user-avatar">
                            <%= user.getEmail().substring(0, 2).toUpperCase() %>
                        </div>
                        <div class="user-info">
                            <div class="user-name">User ID: <%= user.getId() %></div>
                            <div class="user-email"><%= user.getEmail() %></div>
                        </div>
                        <div><%= user.getEmail() %></div>
                        <div>
                            <span class="role-badge <%= "admin".equals(user.getRole()) ? "role-admin" : "role-user" %>">
                                <%= user.getRole() != null ? user.getRole().toUpperCase() : "USER" %>
                            </span>
                        </div>
                        <div>Hoạt động</div>
                        <div class="action-buttons">
                            <button class="btn btn-primary btn-small" onclick="editUser('<%= user.getId() %>')">✏️</button>
                            <button class="btn btn-danger btn-small" onclick="deleteUser('<%= user.getId() %>')">🗑️</button>
                        </div>
                    </div>
                <%
                        }
                    } else {
                %>
                    <div class="user-row">
                        <div colspan="6" style="text-align: center; padding: 40px; color: #7f8c8d;">
                            Không có người dùng nào
                        </div>
                    </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
    
    <script>
        function addUser() {
            window.location.href = 'add-user.jsp';
        }
        
        function editUser(userId) {
            window.location.href = '../admin/user/edit?id=' + userId;
        }
        
        function deleteUser(userId) {
            if (confirm('Bạn có chắc muốn xóa người dùng này?')) {
                fetch('../admin/user/delete?id=' + userId, {
                    method: 'GET'
                }).then(response => response.json())
                .then(result => {
                    if (result.success) {
                        alert('Xóa người dùng thành công');
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra khi xóa người dùng: ' + result.message);
                    }
                })
                .catch(error => {
                    alert('Có lỗi xảy ra khi xóa người dùng');
                });
            }
        }
        
        function exportUsers() {
            window.location.href = 'api/users/export';
        }
        
        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const rows = document.querySelectorAll('.user-row');
            
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchTerm) ? 'grid' : 'none';
            });
        });
    </script>
</body>
</html> 
