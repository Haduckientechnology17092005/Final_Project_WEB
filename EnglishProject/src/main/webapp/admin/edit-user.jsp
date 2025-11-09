<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bean.*" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa người dùng - Admin</title>
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
            max-width: 600px;
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
        
        .form-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }
        
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #3498db;
        }
        
        .form-group .help-text {
            font-size: 12px;
            color: #7f8c8d;
            margin-top: 5px;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s ease;
            margin-right: 10px;
        }
        
        .btn-primary {
            background: #3498db;
            color: white;
        }
        
        .btn-primary:hover {
            background: #2980b9;
        }
        
        .btn-secondary {
            background: #95a5a6;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #7f8c8d;
        }
        
        .btn-danger {
            background: #e74c3c;
            color: white;
        }
        
        .btn-danger:hover {
            background: #c0392b;
        }
        
        .alert {
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            display: none;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .user-info {
            background: #ecf0f1;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .user-info h3 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .user-info p {
            margin: 5px 0;
            color: #7f8c8d;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>✏️ Chỉnh sửa người dùng</h1>
            <p>Cập nhật thông tin người dùng</p>
        </div>
        
        <div class="alert alert-success" id="successAlert"></div>
        <div class="alert alert-error" id="errorAlert"></div>
        
        <%
            User user = (User) request.getAttribute("user");
            if (user != null) {
        %>
            <div class="user-info">
                <h3>Thông tin hiện tại</h3>
                <p><strong>ID:</strong> <%= user.getId() %></p>
                <p><strong>Email:</strong> <%= user.getEmail() %></p>
                <p><strong>Role:</strong> <%= user.getRole() != null ? user.getRole().toUpperCase() : "USER" %></p>
            </div>
            
            <div class="form-container">
                <form id="editUserForm">
                    <input type="hidden" name="id" value="<%= user.getId() %>">
                    
                    <div class="form-group">
                        <label for="email">Email *</label>
                        <input type="email" id="email" name="email" value="<%= user.getEmail() %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">Mật khẩu mới</label>
                        <input type="password" id="password" name="password" placeholder="Để trống nếu không đổi">
                        <div class="help-text">Chỉ nhập nếu muốn thay đổi mật khẩu</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="role">Vai trò *</label>
                        <select id="role" name="role" required>
                            <option value="user" <%= "user".equals(user.getRole()) ? "selected" : "" %>>User</option>
                            <option value="admin" <%= "admin".equals(user.getRole()) ? "selected" : "" %>>Admin</option>
                            <option value="moderator" <%= "moderator".equals(user.getRole()) ? "selected" : "" %>>Moderator</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">💾 Cập nhật</button>
                        <button type="button" class="btn btn-secondary" onclick="goBack()">🔙 Quay lại</button>
                        <button type="button" class="btn btn-danger" onclick="deleteUser(<%= user.getId() %>)">🗑️ Xóa người dùng</button>
                    </div>
                </form>
            </div>
        <%
            } else {
        %>
            <div class="alert alert-error">
                Không tìm thấy thông tin người dùng
            </div>
        <%
            }
        %>
    </div>
    
    <script>
        document.getElementById('editUserForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            const data = {};
            formData.forEach((value, key) => {
                data[key] = value;
            });
            
            fetch('../admin/user/update', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams(data)
            })
            .then(response => response.json())
            .then(result => {
                if (result.success) {
                    showAlert('success', result.message);
                    setTimeout(() => {
                        window.location.href = 'users.jsp';
                    }, 1500);
                } else {
                    showAlert('error', result.message);
                }
            })
            .catch(error => {
                showAlert('error', 'Có lỗi xảy ra khi cập nhật người dùng');
            });
        });
        
        function deleteUser(userId) {
            if (confirm('Bạn có chắc muốn xóa người dùng này?')) {
                fetch('../admin/user/delete?id=' + userId, {
                    method: 'GET'
                })
                .then(response => response.json())
                .then(result => {
                    if (result.success) {
                        showAlert('success', result.message);
                        setTimeout(() => {
                            window.location.href = 'users.jsp';
                        }, 1500);
                    } else {
                        showAlert('error', result.message);
                    }
                })
                .catch(error => {
                    showAlert('error', 'Có lỗi xảy ra khi xóa người dùng');
                });
            }
        }
        
        function showAlert(type, message) {
            const successAlert = document.getElementById('successAlert');
            const errorAlert = document.getElementById('errorAlert');
            
            if (type === 'success') {
                successAlert.textContent = message;
                successAlert.style.display = 'block';
                errorAlert.style.display = 'none';
            } else {
                errorAlert.textContent = message;
                errorAlert.style.display = 'block';
                successAlert.style.display = 'none';
            }
        }
        
        function goBack() {
            window.location.href = 'users.jsp';
        }
    </script>
</body>
</html> 