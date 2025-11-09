<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>DutEnglish - Học tiếng anh IELTS</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            line-height: 1.6;
        }
        
        .header {
            background: white;
            padding: 15px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
        }
        
        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo {
            display: flex;
            align-items: center;
            font-size: 20px;
            font-weight: bold;
            color: #333;
        }
        
        .logo::before {
            content: "🚀";
            margin-right: 8px;
        }
        
        .nav-menu {
            display: flex;
            gap: 30px;
        }
        
        .nav-item {
            color: #666;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }
        
        .nav-item:hover {
            color: #ff6600;
        }
        
        .login-btn {
            background: #ff6600;
            color: white;
            padding: 10px 20px;
            border-radius: 20px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .login-btn:hover {
            background: #e55a00;
            transform: translateY(-2px);
        }
        
        .main-content {
            margin-top: 80px;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
            padding: 60px 20px;
            text-align: center;
        }
        
        .hero-section h1 {
            font-size: 48px;
            font-weight: bold;
            color: #333;
            margin-bottom: 15px;
            line-height: 1.2;
        }
        
        .hero-section .highlight {
            color: #ff6600;
        }
        
        .hero-section .subtitle {
            font-size: 18px;
            color: #666;
            margin-bottom: 40px;
        }
        
        .cta-button {
            background: #ff6600;
            color: white;
            padding: 18px 40px;
            border-radius: 30px;
            text-decoration: none;
            font-size: 18px;
            font-weight: bold;
            display: inline-block;
            margin-bottom: 60px;
            transition: all 0.3s ease;
            box-shadow: 0 10px 30px rgba(255, 102, 0, 0.3);
        }
        
        .cta-button:hover {
            background: #e55a00;
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(255, 102, 0, 0.4);
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="nav-container">
            <div class="logo">DutEnglish</div>
            <nav class="nav-menu">
                <a href="login.jsp" class="login-btn">Đăng nhập</a>
            </nav>
        </div>
    </header>

    <main class="main-content">
        <section class="hero-section">
            <h1>Cải thiện kỹ năng tiếng Anh, học tập và thi tiếng Anh <span class="highlight">hiệu quả</span> 🤩</h1>
            <p class="subtitle">Cùng DutEnglish</p>
            <a href="login.jsp" class="cta-button">Bắt đầu học ngay</a>
        </section>
    </main>
</body>
</html> 