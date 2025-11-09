<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - English Learning</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .login-header h1 {
            color: #333;
            margin: 0;
            font-size: 28px;
            font-weight: 600;
        }

        .login-header p {
            color: #666;
            margin: 10px 0 0 0;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
            font-size: 14px;
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e5e9;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s ease;
            box-sizing: border-box;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
        }

        .login-btn {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s ease;
        }

        .login-btn:hover {
            transform: translateY(-2px);
        }

        .extra-links {
            text-align: center;
            margin-top: 20px;
        }

        .extra-links a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            margin: 0 10px;
        }

        .extra-links a:hover {
            text-decoration: underline;
        }

        .error-message {
            color: #e74c3c;
            text-align: center;
            margin-bottom: 15px;
            font-size: 14px;
        }

        .success-message {
            color: #27ae60;
            text-align: center;
            margin-bottom: 15px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h1>Welcome Back</h1>
            <p>Sign in to continue your English learning journey</p>
        </div>

        <% if (request.getParameter("error") != null) { %>
            <div class="error-message">
                Invalid email or password. Please try again.
            </div>
        <% } %>

        <% if (request.getParameter("logout") != null) { %>
            <div class="success-message">
                You have been successfully logged out.
            </div>
        <% } %>

        <form action="login" method="post">
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required placeholder="Enter your email">
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="Enter your password">
            </div>

            <button type="submit" class="login-btn">Sign In</button>
        </form>

        <!-- ✨ Thêm 2 nút mới ở đây -->
        <div class="extra-links">
            <a href="register.jsp">Create Account</a> |
            <a href="forgot-password.jsp">Forgot Password?</a>
        </div>
    </div>
</body>
</html>
