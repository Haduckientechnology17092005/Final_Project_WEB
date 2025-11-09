<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bean.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - DutEnglish.com</title>
</head>
<frameset border="0" rows = "80,*" class="frame-body">
    <%
    	String topbarSrc = "top.jsp";
        String sidebarSrc = "sidebar.jsp";
        String rightFrameSrc = "sotay.jsp";
        Object userObj = session.getAttribute("user");
        
        if (userObj instanceof User) {
            User user = (User) userObj;
            if ("admin".equals(user.getRole())) {
                sidebarSrc = "admin/admin-sidebar.jsp";
                rightFrameSrc = "admin/users.jsp";
            }
        }
    %>
    <Frame src="<%= topbarSrc %>" name="topFrame" class="iq-top-navbar" />
    <Frameset cols="200,*">
            <Frame src="<%= sidebarSrc %>" name="leftFrame" class="iq-sidebar">

            </Frame>
            <Frame src="<%= rightFrameSrc %>" name="rightFrame" class="content-page">
                
            </Frame>
                
     </Frameset>
    <noframes>
        <body>
            <p>Browser của bạn không hỗ trợ frame</p>
        </body>
    </noframes>
</frameset>
</html> 
<style>
    /* Fix cho layout frame */
.frame-body {
    margin: 0;
    padding: 0;
    overflow: hidden;
}

/* Đảm bảo các phần tử trong frame hiển thị đúng */
.iq-sidebar, .iq-top-navbar, .content-page {
    margin: 0;
    padding: 0;
}

/* Responsive cho mobile */
@media (max-width: 991px) {
    #main-container {
        flex-direction: column;
    }
    
    #sidebar-frame, #right-frame {
        width: 100%;
        height: auto;
        max-height: 200px;
    }
}
</style>