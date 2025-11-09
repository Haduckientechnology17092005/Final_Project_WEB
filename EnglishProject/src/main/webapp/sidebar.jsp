<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bean.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="assets/vendor/@fortawesome/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="assets/vendor/remixicon/fonts/remixicon.css"> 
    <link rel="stylesheet" href="assets/css/libs.min.css">
    <link rel="stylesheet" href="assets/css/socialv.css">
    <title>Navigation</title>
    <style>
    body {
        font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif;
        margin: 0;
        padding: 0;
        overflow: hidden;
        min-height: 100vh;
    }
    
    .iq-sidebar {
        height: 100vh;
        overflow-y: auto;
        box-shadow: 4px 0 20px rgba(0, 0, 0, 0.1);
    }
    
    .iq-sidebar::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 4px;
        background-size: 400% 400%;
    }
    
    .menu {
        list-style-type: none;
        padding: 0;
        margin: 0;
    }
    
    ul {
        list-style-type: none;
        padding: 20px 0;
    }
    
    .menu li {
        margin: 8px 16px;
        position: relative;
    }
    
    .nav-item {
        display: flex;
        align-items: center;
        padding: 16px 20px;
        text-decoration: none;
        color: #3f414d;
        border-radius: 12px;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        font-size: 15px;
        font-weight: 500;
        position: relative;
        overflow: hidden;
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid rgba(255, 255, 255, 0.1);
    }
   
    
    .nav-item:hover {
        background: rgba(255, 255, 255, 0.15);
        color: black;
        transform: translateX(8px);
        border-color: rgba(255, 255, 255, 0.2);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
    }
   
    
    
    .menu-icon {
        margin-right: 16px;
        font-size: 1.4em;
        width: 24px;
        text-align: center;
        transition: all 0.3s ease;
        color: #bdc3c7;
    }
    
    .nav-item:hover .menu-icon,
    .nav-item.active .menu-icon {
        color: #ffffff;
        transform: scale(1.1);
    }
    
    .menu-text {
        flex: 1;
        font-weight: 600;
        letter-spacing: 0.3px;
        transition: all 0.3s ease;
    }
    
    .nav-item:hover .menu-text {
        text-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
    }
    
    /* Responsive design */
    @media (max-width: 768px) {
        .menu li {
            margin: 6px 12px;
        }
        
        .nav-item {
            padding: 14px 16px;
            font-size: 14px;
        }
        
        .menu-icon {
            font-size: 1.2em;
            margin-right: 12px;
        }
    }

</style>
</head>
<body>   
	<div class="iq-sidebar sidebar-default menu" style="overflow: hidden;">
    <div id="sidebar-scrollbar">
        <nav>
            <ul id="iq-sidebar-toggle" class="iq-menu">
                <li>
                    <a href="sotay.jsp" target="rightFrame" class="nav-item">
                        <i class="ri-book-2-line menu-icon"></i>
                        <span class="menu-text">SỔ TAY TỪ VỰNG</span>
                    </a>
                </li>
                <li>
                    <a href="review" target="rightFrame" class="nav-item">
                        <i class="ri-refresh-line menu-icon"></i>
                        <span class="menu-text">REVIEW</span>
                    </a>
                </li>
                <li>
                    <a href="tips" target="rightFrame" class="nav-item">
                        <i class="ri-lightbulb-flash-line menu-icon"></i>
                        <span class="menu-text">TIPS OF THE DAY</span>
                    </a>
                </li>
                <li>
                    <a href="profile.jsp" target="rightFrame" class="nav-item">
                        <i class="ri-user-3-line menu-icon"></i>
                        <span class="menu-text">PROFILE</span>
                    </a>
                </li>
                <li>
				    <form action="logout" method="post" target="_top" style="display:inline;">
				        <button type="submit" class="nav-item" 
				                style="background:none; border:none; width:100%; text-align:left; cursor:pointer;">
				            <i class="ri-logout-box-line menu-icon"></i>
				            <span class="menu-text">LOGOUT</span>
				        </button>
				    </form>
				</li>
            </ul>
        </nav>
    </div>
</div>
    
    
    <script>
        // Handle active state for sidebar navigation
        function setActiveNavItem() {
            const currentUrl = window.location.href;
            const navItems = document.querySelectorAll('.sidebar-nav li a');
            
            navItems.forEach(item => {
                item.classList.remove('active');
                
                // Check if current URL matches this nav item
                const href = item.getAttribute('href');
                if (href && currentUrl.includes(href)) {
                    item.classList.add('active');
                }
            });
        }
        
        // Set active state when page loads
        document.addEventListener('DOMContentLoaded', setActiveNavItem);
        
        // Set active state when iframe content changes
        const rightFrame = document.querySelector('frame[name="rightFrame"]');
        if (rightFrame) {
            rightFrame.addEventListener('load', function() {
                // Update active state based on iframe content
                setTimeout(setActiveNavItem, 100);
            });
        }
        
        function logout() {
            if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
                // Send logout request
                fetch('logout', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'action=logout'
                }).then(() => {
                    // Redirect to login page
                    window.parent.location.href = 'login.jsp';
                }).catch(error => {
                    console.error('Logout error:', error);
                    // Fallback redirect
                    window.parent.location.href = 'login.jsp';
                });
            }
        }
    </script>
   
</body>
</html> 