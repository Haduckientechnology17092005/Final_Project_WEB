<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forgot Password</title>
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

        .container {
            background: #fff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        h1 {
            text-align: center;
            color: #333;
            font-size: 26px;
            margin-bottom: 10px;
        }

        p {
            text-align: center;
            color: #666;
            margin-bottom: 25px;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            font-weight: 500;
            display: block;
            margin-bottom: 8px;
            color: #333;
        }

        input[type="email"] {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e5e9;
            border-radius: 6px;
            font-size: 14px;
            box-sizing: border-box;
        }

        input[type="email"]:focus {
            border-color: #667eea;
            outline: none;
        }

        button {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: transform 0.2s ease;
        }

        button:hover {
            transform: translateY(-2px);
        }

        .back-link {
            text-align: center;
            margin-top: 20px;
        }

        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }

        .back-link a:hover {
            text-decoration: underline;
        }

        .message {
            text-align: center;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .error { color: #e74c3c; }
        .success { color: #27ae60; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Forgot Password</h1>
        <p>Enter your email and we’ll send you a password reset link.</p>

        <% if (request.getParameter("success") != null) { %>
            <div class="message success">A reset link has been sent to your email.</div>
        <% } else if (request.getParameter("error") != null) { %>
            <div class="message error">Email not found. Please try again.</div>
        <% } %>

        <form action="forgot-password" method="post">
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" required placeholder="Enter your registered email">
            </div>

            <button type="submit">Send Reset Link</button>
        </form>

        <div class="back-link">
            <a href="login.jsp">Back to Login</a>
        </div>
    </div>
</body>
</html>
