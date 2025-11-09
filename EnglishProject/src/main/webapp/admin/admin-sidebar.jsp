<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>

<div class="admin-sidebar">
    <div class="admin-header">
        <h2>🔧 ADMIN PANEL</h2>
        <p>Quản lý hệ thống</p>
    </div>
    
    <nav class="admin-nav">
        <div class="nav-section">
            <h3>👥 Quản lý người dùng</h3>
            <ul>
                <li><a href="users.jsp" target="rightFrame">
                    <span class="menu-icon">👤</span>Danh sách người dùng
                </a></li>
            </ul>
        </div>
        
        <div class="nav-section">
            <h3>📚 Quản lý từ vựng</h3>
            <ul>
                <li><a href="vocabulary.jsp" target="rightFrame">
                    <span class="menu-icon">📖</span>Danh sách từ vựng
                </a></li>
                <li><a href="add-vocabulary.jsp" target="rightFrame">
                    <span class="menu-icon">➕</span>Thêm từ vựng
                </a></li>
            </ul>
        </div>
        
        <div class="nav-section">
            <h3>📂 Quản lý danh mục</h3>
            <ul>
                <li><a href="categories.jsp" target="rightFrame">
                    <span class="menu-icon">📁</span>Danh mục từ vựng
                </a></li>
                <li><a href="add-category.jsp" target="rightFrame">
                    <span class="menu-icon">➕</span>Thêm danh mục
                </a></li>
            </ul>
        </div>
        
        <div class="nav-section">
            <h3>📝 Quản lý định nghĩa</h3>
            <ul>
                <li><a href="definitions.jsp" target="rightFrame">
                    <span class="menu-icon">📋</span>Danh sách định nghĩa
                </a></li>
            </ul>
        </div>
        
        <div class="nav-section">
            <h3>🎯 Quản lý bài tập</h3>
            <ul>
                <li><a href="add-exercise.jsp" target="rightFrame">
                    <span class="menu-icon">➕</span>Bài tập
                </a></li>
            </ul>
        </div>
    </nav>
    
    <div class="admin-footer">
        <div class="admin-user-info">
            <div class="user-avatar">AD</div>
            <div class="user-details">
                <%
                    Object userObj = session.getAttribute("user");
                    String userName = "Unknown";
                    String userRole = "Unknown";
                    if (userObj != null && userObj instanceof bean.User) {
                        bean.User user = (bean.User) userObj;
                        userName = user.getEmail();
                        userRole = user.getRole();
                    }
                %>
                <div class="user-name"><%= userName %></div>
                <div class="user-role"><%= userRole %></div>
            </div>
        </div>
        <button class="logout-btn" onclick="logout()">🚪 Đăng xuất</button>
    </div>
</div>

<style>
.admin-sidebar {
    width: 280px;
    height: 100vh;
    background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
    color: white;
    padding: 20px;
    overflow-y: auto;
    box-shadow: 2px 0 10px rgba(0,0,0,0.1);
}

.admin-header {
    text-align: center;
    padding: 20px 0;
    border-bottom: 1px solid rgba(255,255,255,0.1);
    margin-bottom: 20px;
}

.admin-header h2 {
    font-size: 1.5em;
    margin-bottom: 5px;
    color: #ecf0f1;
}

.admin-header p {
    font-size: 0.9em;
    opacity: 0.8;
}

.admin-nav {
    flex: 1;
}

.nav-section {
    margin-bottom: 25px;
}

.nav-section h3 {
    font-size: 0.9em;
    color: #bdc3c7;
    margin-bottom: 10px;
    padding: 0 10px;
    text-transform: uppercase;
    letter-spacing: 1px;
}

.nav-section ul {
    list-style: none;
    padding: 0;
    margin: 0;
}

.nav-section li {
    margin-bottom: 5px;
}

.nav-section a {
    display: flex;
    align-items: center;
    padding: 12px 15px;
    color: #ecf0f1;
    text-decoration: none;
    border-radius: 8px;
    transition: all 0.3s ease;
    font-size: 0.9em;
}

.nav-section a:hover {
    background: rgba(255,255,255,0.1);
    transform: translateX(5px);
}

.nav-section a.active {
    background: rgba(52, 152, 219, 0.3);
    border-left: 3px solid #3498db;
}

.menu-icon {
    margin-right: 10px;
    font-size: 1.1em;
}

.admin-footer {
    margin-top: auto;
    padding-top: 20px;
    border-top: 1px solid rgba(255,255,255,0.1);
}

.admin-user-info {
    display: flex;
    align-items: center;
    margin-bottom: 15px;
    padding: 10px;
    background: rgba(255,255,255,0.05);
    border-radius: 8px;
}

.user-avatar {
    width: 40px;
    height: 40px;
    background: #3498db;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
    margin-right: 10px;
}

.user-details {
    flex: 1;
}

.user-name {
    font-weight: 600;
    font-size: 0.9em;
}

.user-role {
    font-size: 0.8em;
    opacity: 0.8;
    color: #3498db;
}

.logout-btn {
    width: 100%;
    padding: 10px;
    background: #e74c3c;
    color: white;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-size: 0.9em;
    transition: all 0.3s ease;
}

.logout-btn:hover {
    background: #c0392b;
    transform: translateY(-2px);
}

@media (max-width: 768px) {
    .admin-sidebar {
        width: 100%;
        height: auto;
    }
}
</style>

<script>
function logout() {
    window.top.location.href = '../login?logout=1';
}

// Set active state for current page
document.addEventListener('DOMContentLoaded', function() {
    const currentUrl = window.location.href;
    const navLinks = document.querySelectorAll('.admin-nav a');
    
    navLinks.forEach(link => {
        if (currentUrl.includes(link.getAttribute('href'))) {
            link.classList.add('active');
        }
    });
});
</script> 