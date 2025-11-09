<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="UTF-8"%>
   <%@ page import="bean.User" %>
   
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="assets/css/libs.min.css">
    <link rel="stylesheet" href="assets/css/socialv.css?v=4.0.0">
    <link rel="stylesheet" href="assets/vendor/@fortawesome/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="assets/vendor/remixicon/fonts/remixicon.css"> 
    <style>
        body { margin: 0; padding: 0; overflow: hidden; }
        .iq-top-navbar { margin: 0; }
        
        /* CSS cho role badges */
        .role-badge {
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .role-admin {
            background-color: #dc3545;
            color: white;
        }
        
        .role-moderator {
            background-color: #fd7e14;
            color: white;
        }
        
        .role-user {
            background-color: #6c757d;
            color: white;
        }
        
        .profile-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #007bff;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 10px;
        }
        
        .profile-info {
            display: flex;
            align-items: center;
        }
        
        .profile-details h4 {
            margin: 0;
            font-size: 0.9rem;
        }
        
        .profile-details p {
            margin: 0;
        }
        .role-badge {
            display: inline-block;
            padding: 2px 6px;
            border-radius: 8px;
            font-size: 10px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .role-user {
            background-color: #e3f2fd;
            color: #1976d2;
        }
        
        .role-moderator {
            background-color: #fff3e0;
            color: #f57c00;
        }
        
        .role-admin {
            background-color: #fce4ec;
            color: #c2185b;
        }
        
        .logout-btn {
            background: none;
            border: none;
            color: #6c757d;
            cursor: pointer;
            padding: 0.5rem;
            border-radius: 0.25rem;
            transition: background-color 0.3s;
        }
        
        .logout-btn:hover {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
    <div class="iq-top-navbar">
        <div class="iq-navbar-custom">
            <nav class="navbar navbar-expand-lg navbar-light p-0">
                <div class="iq-navbar-logo d-flex justify-content-between">
                    <a href="#">
                        <img src="./assets/images/logo.png" class="img-fluid" alt="">
                        <span>EnglishTime</span>
                    </a>
                    <div class="iq-menu-bt align-self-center">
                        <div class="wrapper-menu">
                            <div class="main-circle"><i class="ri-menu-line"></i></div>
                        </div>
                    </div>
                </div>

                <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                    data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                    aria-label="Toggle navigation">
                    <i class="ri-menu-3-line"></i>
                </button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav  ms-auto navbar-list">
                        <li>
                            <a href="#" class="  d-flex align-items-center">
                                <i class="ri-home-line"></i>
                            </a>
                        </li>
                        <li class="nav-item dropdown">
                             <a href="#" class="dropdown-toggle" id="group-drop" data-bs-toggle="dropdown"
                                    aria-haspopup="true" aria-expanded="false"><i class="ri-group-line"></i></a>
                        </li>
                        <li class="nav-item dropdown">
                                  <a href="#" class="search-toggle   dropdown-toggle" id="notification-drop" data-bs-toggle="dropdown">
                                      <i class="ri-notification-4-line"></i>
                                  </a>
                        </li>
                        <li class="nav-item dropdown">
                                  <a href="#" class="dropdown-toggle" id="mail-drop" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                      <i class="ri-mail-line"></i>
                                  </a>
                        </li>
                        <li class="nav-item dropdown">
                            <a href="#" class="d-flex align-items-center dropdown-toggle" id="drop-down-arrow" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <div class="profile-section">
							        <%
							            // Get user information from session
							            String userEmail = "Guest";
							            String userRole = "user";
							            String userInitials = "GU";
							            
							            Object userObj = session.getAttribute("user");
							            if (userObj instanceof User) {
							                User user = (User) userObj;
							                userEmail = user.getEmail();
							                userRole = user.getRole() != null ? user.getRole() : "user";
							                // Get initials from email
							                String[] emailParts = userEmail.split("@");
							                if (emailParts.length > 0) {
							                    String name = emailParts[0];
							                    if (name.length() >= 2) {
							                        userInitials = name.substring(0, 2).toUpperCase();
							                    } else {
							                        userInitials = name.toUpperCase();
							                    }
							                }
							            } else if (userObj instanceof String) {
							                userEmail = (String) userObj;
							                // Get initials from email
							                String[] emailParts = userEmail.split("@");
							                if (emailParts.length > 0) {
							                    String name = emailParts[0];
							                    if (name.length() >= 2) {
							                        userInitials = name.substring(0, 2).toUpperCase();
							                    } else {
							                        userInitials = name.toUpperCase();
							                    }
							                }
							            }
							            
							            // Determine role display name and badge class
							            String roleDisplayName;
							            String roleBadgeClass;
							            switch (userRole.toLowerCase()) {
							                case "admin":
							                    roleDisplayName = "Admin";
							                    roleBadgeClass = "role-admin";
							                    break;
							                case "moderator":
							                    roleDisplayName = "Moderator";
							                    roleBadgeClass = "role-moderator";
							                    break;
							                default:
							                    roleDisplayName = "User";
							                    roleBadgeClass = "role-user";
							                    break;
							            }
							        %>
							        
							        <div class="profile-info">
							            <div class="profile-avatar"><%= userInitials %></div>
							            <div class="caption profile-details">
							            	<h4><%= userEmail %></h4>
	                                        <p><span class="role-badge <%= roleBadgeClass %>"><%= roleDisplayName %></span></p>
	                                    </div>
							        </div>
							        
							    </div>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="drop-down-arrow">
                                <li><a class="dropdown-item" href="profile.html">Hồ sơ</a></li>
                                <li><a class="dropdown-item" href="settings.html">Cài đặt</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><button class="dropdown-item text-danger logout-btn" onclick="logout()">Đăng xuất</button></li>
                            </ul>
                        </li>
                    </ul>               
                </div>
            </nav>
        </div>
    </div>
    
    <script>
        
        // Function to update user interface
        function updateUserInterface() {
            const user = getUserInfo();
            const roleInfo = getRoleInfo(user.role);
            const initials = user.initials || getInitialsFromEmail(user.email);
            
            // Update DOM elements
            document.getElementById('userAvatar').textContent = initials;
            document.getElementById('userEmail').textContent = user.email;
            
            const roleBadge = document.getElementById('userRole');
            roleBadge.textContent = roleInfo.displayName;
            roleBadge.className = `role-badge ${roleInfo.badgeClass}`;
        }
        
        // Function to handle logout
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
                    // Clear local storage
                    localStorage.removeItem('userData');
                    // Redirect to login page
                    window.parent.location.href = 'login.jsp';
                }).catch(error => {
                    console.error('Logout error:', error);
                    // Fallback redirect
                    window.parent.location.href = 'login.jsp';
                });
            }
        }
        
        // Function to set active state for sidebar navigation
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
        
        // Initialize when page loads
        document.addEventListener('DOMContentLoaded', function() {
            updateUserInterface();
            setActiveNavItem();
            
            // Set active state when iframe content changes
            const rightFrame = document.querySelector('frame[name="rightFrame"]');
            if (rightFrame) {
                rightFrame.addEventListener('load', function() {
                    setTimeout(setActiveNavItem, 100);
                });
            }
        });
        
        // Demo function to simulate user login (for testing)
        function demoLogin(email, role) {
            const userData = {
                email: email,
                role: role,
                initials: getInitialsFromEmail(email)
            };
            localStorage.setItem('userData', JSON.stringify(userData));
            updateUserInterface();
            alert(`Đã đăng nhập với: ${email} (${role})`);
        }
        
        // Đồng bộ với frame chính
        window.addEventListener('click', function(e) {
            if (e.target.tagName === 'A' && e.target.href) {
                e.preventDefault();
                window.parent.postMessage({
                    type: 'navigate',
                    url: e.target.href
                }, '*');
            }
        });
    </script>
</body>
</html>