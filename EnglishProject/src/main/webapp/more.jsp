<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>More</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background: #f5f5f5;
        }
        .container {
            max-width: 900px;
            margin: 40px auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        h1, h2 {
            text-align: center;
            color: #333;
        }
        p {
            color: #555;
            line-height: 1.6;
        }
        .section {
            margin-bottom: 40px;
        }
        .donate {
            text-align: center;
        }
        .donate img {
            width: 200px;
            margin: 10px 0;
        }
        .thank {
            color: #27ae60;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>More About This Project</h1>

        <div class="section">
            <h2>About the Project</h2>
            <p>
                This project is designed to help users manage their accounts, reset passwords, and explore features.
                <br>
                Technologies used: Java, JSP, Servlet, MySQL, and Tomcat.
            </p>
        </div>

        <div class="section">
            <h2>How to Use</h2>
            <p>
                You can register, login, reset your password, and manage your profile. Please verify your email to fully activate your account.
            </p>
        </div>

        <div class="section donate">
            <h2>Support the Project</h2>
            <p>Scan the QR code below to donate. Thank you for your support!</p>
            <img src="images/qr-donate.jpg" alt="QR Code for Donation">
            <p class="thank">Your support keeps this project alive!</p>
        </div>

        <div class="section">
            <h2>Contact & Feedback</h2>
            <p>
                For feedback or questions, email us at: <a href="mailto:project@example.com">project@example.com</a>
            </p>
        </div>
    </div>
</body>
</html>
