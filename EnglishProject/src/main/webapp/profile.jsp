<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="bean.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profile</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background: #f5f5f5;
        }
        .container {
            max-width: 600px;
            margin: 50px auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        h1, h2 {
            text-align: center;
            color: #333;
        }
        .profile-info {
            text-align: center;
            margin-bottom: 30px;
        }
        .profile-info img {
            width: 120px;
            border-radius: 50%;
            margin-bottom: 10px;
        }
        .profile-info p {
            margin: 5px 0;
            color: #555;
        }
        form {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            color: #333;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        button {
            width: 100%;
            padding: 12px;
            background: #667eea;
            color: #fff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background: #5a67d8;
        }
        .success { color: #27ae60; text-align: center; margin-bottom: 15px; }
        .error { color: #e74c3c; text-align: center; margin-bottom: 15px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Profile</h1>

        <div class="profile-info">
            <img src="images/avatar.jpg" alt="Avatar">
            <p><strong>Email:</strong> <%= user.getEmail() %></p>
            <p><strong>Role:</strong> <%= user.getRole() %></p>
            <p><strong>Email Verified:</strong> <%= user.isEmailVerified() ? "Yes" : "No" %></p>
        </div>

        <h2>Change Password</h2>
        <% if (request.getParameter("success") != null) { %>
            <div class="success">Password updated successfully!</div>
        <% } else if (request.getParameter("error") != null) { %>
            <div class="error">Error updating password. Try again.</div>
        <% } %>

        <form action="change-password" method="post">
            <label for="current">Current Password</label>
            <input type="password" id="current" name="currentPassword" required>

            <label for="new">New Password</label>
            <input type="password" id="new" name="newPassword" required>

            <button type="submit">Update Password</button>
        </form>
    </div>
</body>
</html>
