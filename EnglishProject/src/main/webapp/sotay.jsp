<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>

<%
    // Get data from request attributes (set by controller)
    Map<String, Integer> progress = (Map<String, Integer>) request.getAttribute("progress");
    List<Vocabulary> vocabularyList = (List<Vocabulary>) request.getAttribute("vocabularyList");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String categoryFilter = (String) request.getAttribute("categoryFilter");
    Integer totalVocabulary = (Integer) request.getAttribute("totalVocabulary");
    
    // Check if data is available (if not, redirect to controller)
    if (progress == null || vocabularyList == null || categories == null) {
        // Data not available, redirect to controller
        response.sendRedirect("sotay");
        return;
    }
    
    // Get progress values with default values
    int mastered = progress.getOrDefault("mastered", 0);
    int needReview = progress.getOrDefault("need_review", 0);
    
    // Get success/error messages
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>  

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sổ từ vựng - DutEnglish</title>
    <link rel="stylesheet" href="../assets/css/libs.min.css">
    <link rel="stylesheet" href="../assets/css/socialv.css?v=4.0.0">
    <link rel="stylesheet" href="../assets/vendor/@fortawesome/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="../assets/vendor/remixicon/fonts/remixicon.css">
    <style>
        .vocabulary-container {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 25px;
            margin-bottom: 25px;
        }
        
        .page-header {
            margin-bottom: 30px;
        }
        
        .page-title {
            font-size: 28px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 8px;
        }
        
        .page-subtitle {
            color: #7e8c9a;
            font-size: 16px;
            margin-bottom: 0;
        }
        
        .alert-custom {
            border-radius: 10px;
            padding: 15px 20px;
            margin-bottom: 25px;
            border: none;
            font-weight: 500;
        }
        
        .alert-success-custom {
            background: linear-gradient(135deg, #d4ffd4, #b8f5b8);
            color: #155724;
            border-left: 4px solid #28a745;
        }
        
        .alert-error-custom {
            background: linear-gradient(135deg, #ffd4d4, #f5b8b8);
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
        
        .progress-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            position: relative;
            overflow: hidden;
        }
        
        .progress-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #ff6b6b, #4ecdc4, #45b7d1, #96ceb4, #ffeaa7);
            background-size: 400% 400%;
            animation: gradientShift 3s ease infinite;
        }
        
        .progress-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 20px;
            color: white;
        }
        
        .progress-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .progress-item {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            padding: 20px;
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.3s ease;
        }
        
        .progress-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .progress-info {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 10px;
        }
        
        .progress-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            background: rgba(255, 255, 255, 0.2);
        }
        
        .progress-text {
            font-size: 14px;
            font-weight: 500;
            opacity: 0.9;
        }
        
        .progress-count {
            font-size: 24px;
            font-weight: 700;
            text-align: right;
        }
        
        .progress-actions {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .btn-custom {
            border: none;
            padding: 15px 25px;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
        }
        
        .btn-primary-custom {
            background: linear-gradient(135deg, #ff9500, #ff6b00);
            color: white;
            box-shadow: 0 4px 15px rgba(255, 149, 0, 0.3);
        }
        
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(255, 149, 0, 0.4);
        }
        
        .btn-secondary-custom {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 2px solid rgba(255, 255, 255, 0.3);
        }
        
        .btn-secondary-custom:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
        }
        
        .vocabulary-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .section-title {
            font-size: 22px;
            font-weight: 600;
            color: #2c3e50;
            margin: 0;
        }
        
        .search-filter-container {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .search-input-custom {
            padding: 12px 20px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 14px;
            background: white;
            min-width: 250px;
            transition: all 0.3s ease;
        }
        
        .search-input-custom:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .filter-dropdown-custom {
            padding: 12px 20px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            font-size: 14px;
            background: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .filter-dropdown-custom:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .vocab-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .vocab-item {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .vocab-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
            border-color: #667eea;
        }
        
        .vocab-main-content {
            display: flex;
            justify-content: between;
            align-items: flex-start;
            gap: 20px;
        }
        
        .vocab-info {
            flex: 1;
        }
        
        .vocab-word {
            font-size: 18px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 8px;
        }
        
        .vocab-phonetic {
            font-size: 14px;
            color: #667eea;
            margin-bottom: 8px;
            font-style: italic;
        }
        
        .vocab-meaning {
            font-size: 15px;
            color: #5a6c7d;
            margin-bottom: 8px;
            line-height: 1.5;
        }
        
        .vocab-category {
            font-size: 12px;
            color: #8898aa;
            background: #f8f9fa;
            padding: 4px 12px;
            border-radius: 20px;
            display: inline-block;
        }
        
        .vocab-actions {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .btn-icon {
            background: none;
            border: none;
            font-size: 18px;
            cursor: pointer;
            padding: 10px;
            border-radius: 50%;
            transition: all 0.3s ease;
            color: #667eea;
        }
        
        .btn-icon:hover {
            background: #f8f9fa;
            transform: scale(1.1);
        }
        
        .expand-button {
            background: none;
            border: none;
            font-size: 16px;
            cursor: pointer;
            padding: 10px;
            border-radius: 50%;
            transition: all 0.3s ease;
            color: #667eea;
        }
        
        .expand-button:hover {
            background: #f8f9fa;
            color: #2c3e50;
        }
        
        .expand-button.expanded {
            transform: rotate(180deg);
            color: #ff9500;
        }
        
        .all-definitions {
            display: none;
            margin-top: 15px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }
        
        .all-definitions.show {
            display: block;
            animation: fadeIn 0.3s ease;
        }
        
        .definition-item {
            padding: 8px 0;
            border-bottom: 1px solid #e9ecef;
            font-size: 14px;
            color: #5a6c7d;
        }
        
        .definition-item:last-child {
            border-bottom: none;
        }
        
        /* Dialog Styles */
        dialog {
            border: none;
            border-radius: 15px;
            padding: 0;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            max-width: 500px;
            width: 90%;
        }
        
        .dialog-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 25px;
            border-radius: 15px 15px 0 0;
        }
        
        .dialog-header h3 {
            margin: 0;
            font-size: 20px;
            font-weight: 600;
        }
        
        .close-btn {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: white;
            padding: 0;
            width: 35px;
            height: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: background-color 0.3s ease;
        }
        
        .close-btn:hover {
            background: rgba(255, 255, 255, 0.2);
        }
        
        .dialog-body {
            padding: 25px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .form-control-custom {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        
        .form-control-custom:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .dialog-actions {
            display: flex;
            gap: 15px;
            margin-top: 25px;
        }
        
        .btn-back {
            background: #6c757d;
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-back:hover {
            background: #5a6268;
            transform: translateY(-1px);
        }
        
        .btn-save {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-save:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }
        
        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            color: #dee2e6;
        }
        
        .empty-state h4 {
            font-size: 20px;
            margin-bottom: 10px;
            color: #6c757d;
        }
        
        .empty-state p {
            font-size: 14px;
            margin-bottom: 0;
        }
        
        .hidden {
            display: none !important;
        }
        
        .active {
            display: block !important;
        }
        
        .w-100 {
            width: 100% !important;
        }
        
        .mt-3 {
            margin-top: 1rem !important;
        }
        
        .mb-3 {
            margin-bottom: 1rem !important;
        }
        
        .mt-2 {
            margin-top: 0.5rem !important;
        }
    </style>
</head>
<body class=" ">
    <!-- loader Start -->
    <div id="loading">
        <div id="loading-center"></div>
    </div>
    <!-- loader END -->

    <!-- Wrapper Start -->
    <div class="wrapper">
        <div class="content-page">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="vocabulary-container">
                            <div class="page-header">
                                <h1 class="page-title">Sổ từ vựng</h1>
                                <p class="page-subtitle">Nhớ từ vựng bạn muốn hiệu quả và dễ dàng 😍</p>
                            </div>
                            
                            <!-- Success/Error Messages -->
                            <% if (success != null) { %>
                                <div class="alert-custom alert-success-custom">
                                    <% if ("added".equals(success)) { %>
                                        <i class="ri-checkbox-circle-fill me-2"></i> Từ vựng đã được thêm thành công!
                                    <% } else if ("progress_updated".equals(success)) { %>
                                        <i class="ri-checkbox-circle-fill me-2"></i> Tiến độ đã được cập nhật!
                                    <% } %>
                                </div>
                            <% } %>
                            
                            <% if (error != null) { %>
                                <div class="alert-custom alert-error-custom">
                                    <% if ("add_failed".equals(error)) { %>
                                        <i class="ri-error-warning-fill me-2"></i> Không thể thêm từ vựng. Vui lòng thử lại.
                                    <% } else if ("update_failed".equals(error)) { %>
                                        <i class="ri-error-warning-fill me-2"></i> Không thể cập nhật tiến độ. Vui lòng thử lại.
                                    <% } else if ("invalid_data".equals(error)) { %>
                                        <i class="ri-error-warning-fill me-2"></i> Dữ liệu không hợp lệ. Vui lòng kiểm tra lại.
                                    <% } else if ("database_error".equals(error)) { %>
                                        <i class="ri-error-warning-fill me-2"></i> Lỗi cơ sở dữ liệu. Vui lòng thử lại sau.
                                    <% } %>
                                </div>
                            <% } %>
                            
                            <!-- Progress Section -->
                            <div class="progress-section">
                                <h2 class="progress-title">Tiến độ học tập</h2>
                                
                                <div class="progress-stats">
                                    <div class="progress-item">
                                        <div class="progress-info">
                                            <div class="progress-icon">
                                                <i class="ri-check-line"></i>
                                            </div>
                                            <span class="progress-text">Đã thành thạo</span>
                                        </div>
                                        <div class="progress-count"><%= mastered %>/<%= totalVocabulary != null ? totalVocabulary : 0 %> từ</div>
                                    </div>
                                    
                                    <div class="progress-item">
                                        <div class="progress-info">
                                            <div class="progress-icon">
                                                <i class="ri-time-line"></i>
                                            </div>
                                            <span class="progress-text">Cần ôn tập ngay</span>
                                        </div>
                                        <div class="progress-count"><%= needReview %> từ</div>
                                    </div>
                                </div>
                                
                                <div class="progress-actions">
                                    <a href="review" class="btn-custom btn-primary-custom">
                                        <i class="ri-target-line"></i>
                                        <span>Luyện tập ngay (<%= needReview %>)</span>
                                    </a>
                                    
                                    <button class="btn-custom btn-secondary-custom" onclick="openAddVocabDialog()">
                                        <i class="ri-add-line"></i>
                                        <span>Thêm từ vựng mới</span>
                                    </button>
                                </div>
                            </div>
                            
                            <!-- Vocabulary Section -->
                            <div class="vocabulary-container">
                                <div class="vocabulary-header">
                                    <div>
                                        <h2 class="section-title">Từ vựng của bạn</h2>
                                        <span class="vocab-count" id="total-vocab-count" style="font-size: 14px; color: #7e8c9a; font-weight: 500;">
                                            <%= totalVocabulary != null ? totalVocabulary : 0 %> từ vựng
                                        </span>
                                    </div>
                                    <div class="search-filter-container">
                                        <input type="text" class="search-input-custom" id="search-input" placeholder="Tìm kiếm từ vựng..." />
                                        <select class="filter-dropdown-custom" id="vocab-filter" onchange="filterVocabulary()">
                                            <option value="all">Tất cả danh mục</option>
                                            <% for (Category category : categories) { %>
                                                <option value="<%= category.getName() %>" <%= categoryFilter.equals(category.getName()) ? "selected" : "" %>>
                                                    <%= category.getName() %>
                                                </option>
                                            <% } %>
                                        </select>
                                    </div>
                                </div>
                                
                                <% if (vocabularyList.isEmpty()) { %>
                                    <div class="empty-state">
                                        <i class="ri-book-open-line"></i>
                                        <h4>Chưa có từ vựng nào</h4>
                                        <p>Hãy thêm từ vựng đầu tiên để bắt đầu học!</p>
                                        <button class="btn-custom btn-primary-custom mt-3" onclick="openAddVocabDialog()">
                                            <i class="ri-add-line"></i>
                                            <span>Thêm từ vựng đầu tiên</span>
                                        </button>
                                    </div>
                                <% } else { %>
                                    <ul class="vocab-list" id="vocab-list">
                                        <% for (Vocabulary vocab : vocabularyList) { %>
                                            <li class="vocab-item" data-vocab-id="<%= vocab.getId() %>" data-category="<%= vocab.getCategoryId() %>" data-word="<%= vocab.getRaw().toLowerCase() %>">
                                                <div class="vocab-main-content">
                                                    <div class="vocab-info">
                                                        <div class="vocab-word"><%= vocab.getRaw() %></div>
                                                        <% if (vocab.getPhonetic() != null && !vocab.getPhonetic().trim().isEmpty()) { %>
                                                            <div class="vocab-phonetic">/<%= vocab.getPhonetic() %>/</div>
                                                        <% } %>
                                                        <div class="vocab-meaning">
                                                            <% 
                                                                if (vocab.getDefinitions() != null && !vocab.getDefinitions().trim().isEmpty()) {
                                                                    String[] definitions = vocab.getDefinitions().split("\\|");
                                                                    // Show first definition by default
                                                                    if (definitions.length > 0) {
                                                                        String firstDefinition = definitions[0].trim();
                                                                        if (!firstDefinition.isEmpty()) {
                                                            %>
                                                                            <div class="definition-item"><%= firstDefinition %></div>
                                                            <%
                                                                        }
                                                                    }
                                                                } else {
                                                            %>
                                                                <em style="color: #999;">Chưa có định nghĩa</em>
                                                            <%
                                                                }
                                                            %>
                                                        </div>
                                                        <div class="vocab-category">
                                                            <% if (vocab.getCategoryId() != null && vocab.getCategoryId() > 0) { %>
                                                                <% 
                                                                    boolean categoryFound = false;
                                                                    for (Category cat : categories) { 
                                                                        if (cat.getId() == vocab.getCategoryId()) { 
                                                                            categoryFound = true;
                                                                %>
                                                                    <%= cat.getName() %>
                                                                <% 
                                                                            break;
                                                                        } 
                                                                    }
                                                                    if (!categoryFound) {
                                                                %>
                                                                    Không xác định
                                                                <% } %>
                                                            <% } else { %>
                                                                Chưa phân loại
                                                            <% } %>
                                                        </div>
                                                    </div>
                                                    <div class="vocab-actions">
                                                        <button class="btn-icon" onclick="playAudio('<%= vocab.getAudioUrl() %>')" title="Phát âm thanh">
                                                            <i class="ri-volume-up-line"></i>
                                                        </button>
                                                        <% 
                                                            if (vocab.getDefinitions() != null && !vocab.getDefinitions().trim().isEmpty()) {
                                                                String[] definitions = vocab.getDefinitions().split("\\|");
                                                                if (definitions.length > 1) {
                                                        %>
                                                            <button class="expand-button" onclick="toggleDefinitions('<%= vocab.getId() %>')" title="Xem thêm định nghĩa" data-vocab-id="<%= vocab.getId() %>">
                                                                <i class="ri-arrow-down-s-line"></i>
                                                            </button>
                                                        <%
                                                                }
                                                            }
                                                        %>
                                                    </div>
                                                </div>
                                                
                                                <% 
                                                    // Add all-definitions as a separate div inside vocab-item
                                                    if (vocab.getDefinitions() != null && !vocab.getDefinitions().trim().isEmpty()) {
                                                        String[] definitions = vocab.getDefinitions().split("\\|");
                                                        if (definitions.length > 1) {
                                                %>
                                                    <div class="all-definitions" id="definitions-<%= vocab.getId() %>">
                                                        <% for (int i = 1; i < definitions.length; i++) { %>
                                                            <% String definition = definitions[i].trim(); %>
                                                            <% if (!definition.isEmpty()) { %>
                                                                <div class="definition-item"><%= definition %></div>
                                                            <% } %>
                                                        <% } %>
                                                    </div>
                                                <%
                                                        }
                                                    }
                                                %>
                                            </li>
                                        <% } %>
                                    </ul>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Wrapper End-->

    <!-- Add Vocabulary Dialog -->
    <dialog id="add-vocab-dialog" role="dialog" aria-labelledby="dialog-title">
        <div class="dialog-content">
            <div class="dialog-header">
                <h3 id="dialog-title">Thêm từ vựng mới</h3>
                <button class="close-btn" aria-label="Đóng" id="close-dialog">
                    <i class="ri-close-line"></i>
                </button>
            </div>
            <div class="dialog-body">
                <!-- Step 1: Input English Word -->
                <div id="step1" class="dialog-step active">
                    <p class="mb-3">Từ tiếng anh (ví dụ: 'nature', 'fall in love')</p>
                    <input type="text" class="form-control-custom" id="english-word" placeholder="Nhập từ hoặc cụm từ tiếng anh..." />
                    <button class="btn-custom btn-primary-custom w-100 mt-3" id="generate-btn">
                        <i class="ri-magic-line"></i>
                        <span>Tạo định nghĩa và ví dụ</span>
                    </button>
                </div>
                
                <!-- Step 2: Complete Form -->
                <div id="step2" class="dialog-step hidden">
                    <form id="add-vocab-form" method="post" action="sotay" accept-charset="UTF-8">
                        <input type="hidden" name="action" value="add_vocabulary" />
                        
                        <div class="form-group">
                            <label>Từ tiếng anh</label>
                            <input type="text" class="form-control-custom" id="word-display" name="word" readonly />
                        </div>
                        
                        <div class="form-group">
                            <label>Định nghĩa tiếng Việt</label>
                            <textarea class="form-control-custom" id="vietnamese-meaning" name="meaning"
                                      placeholder="rơi, ngã; mùa thu; sự suy giảm hoặc giảm sút" required rows="3"></textarea>
                        </div>
                        
                        <div class="form-group">
                            <label>Câu ví dụ</label>
                            <textarea class="form-control-custom" id="example-sentence" name="example"
                                  placeholder="Leaves fall from the trees in autumn." rows="3"></textarea>
                        </div>
                        
                        <div class="form-group">
                            <label>Danh mục (tùy chọn)</label>
                            <select class="form-control-custom" id="category-select" name="category">
                                <option value="">Không có danh mục</option>
                                <% for (Category category : categories) { %>
                                    <option value="<%= category.getName() %>"><%= category.getName() %></option>
                                <% } %>
                                <option value="add-new" style="font-weight: bold; color: #ff9500;">
                                    <i class="ri-add-line"></i> Thêm danh mục mới
                                </option>
                            </select>
                            <input type="text" class="form-control-custom mt-2" id="new-category-input" 
                                   placeholder="Nhập tên danh mục mới..." style="display: none;" />
                            <button type="button" class="btn-back w-100 mt-2" id="back-to-dropdown-btn" 
                                    style="display: none;">
                                <i class="ri-arrow-left-line"></i> Quay lại danh sách
                            </button>
                        </div>
                        
                        <div class="dialog-actions">
                            <button type="button" class="btn-back" id="back-btn">
                                <i class="ri-arrow-left-line"></i> Quay lại
                            </button>
                            <button type="submit" class="btn-save" id="save-btn">
                                <i class="ri-save-line"></i> Lưu từ vựng
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </dialog>

    <!-- Backend Bundle JavaScript -->
    <script src="../assets/js/libs.min.js"></script>
    <!-- app JavaScript -->
    <script src="../assets/js/app.js"></script>

    <script>
        // Dialog functionality
        const dialog = document.getElementById('add-vocab-dialog');
        const closeDialog = document.getElementById('close-dialog');
        const generateBtn = document.getElementById('generate-btn');
        const backBtn = document.getElementById('back-btn');
        const step1 = document.getElementById('step1');
        const step2 = document.getElementById('step2');
        const englishWordInput = document.getElementById('english-word');
        const wordDisplay = document.getElementById('word-display');
        const vietnameseMeaning = document.getElementById('vietnamese-meaning');
        const exampleSentence = document.getElementById('example-sentence');
        const categorySelect = document.getElementById('category-select');
        const newCategoryInput = document.getElementById('new-category-input');
        const backToDropdownBtn = document.getElementById('back-to-dropdown-btn');
        const addVocabForm = document.getElementById('add-vocab-form');
        
        function openAddVocabDialog() {
            dialog.showModal();
        }
        
        function closeAddVocabDialog() {
            dialog.close();
            resetDialog();
        }
        
        function resetDialog() {
            step1.classList.add('active');
            step1.classList.remove('hidden');
            step2.classList.add('hidden');
            step2.classList.remove('active');
            englishWordInput.value = '';
            wordDisplay.value = '';
            vietnameseMeaning.value = '';
            exampleSentence.value = '';
            categorySelect.value = '';
            newCategoryInput.style.display = 'none';
            backToDropdownBtn.style.display = 'none';
            categorySelect.style.display = 'block';
        }
        
        closeDialog.addEventListener('click', closeAddVocabDialog);
        
        generateBtn.addEventListener('click', function() {
            const word = englishWordInput.value.trim();
            if (word) {
                wordDisplay.value = word;
                step1.classList.remove('active');
                step1.classList.add('hidden');
                step2.classList.remove('hidden');
                step2.classList.add('active');
            } else {
                alert('Vui lòng nhập từ tiếng Anh');
            }
        });
        
        backBtn.addEventListener('click', function() {
            step2.classList.remove('active');
            step2.classList.add('hidden');
            step1.classList.remove('hidden');
            step1.classList.add('active');
        });
        
        // Category selection handling
        categorySelect.addEventListener('change', function() {
            if (this.value === 'add-new') {
                this.style.display = 'none';
                newCategoryInput.style.display = 'block';
                backToDropdownBtn.style.display = 'block';
                newCategoryInput.focus();
            }
        });
        
        backToDropdownBtn.addEventListener('click', function() {
            categorySelect.style.display = 'block';
            newCategoryInput.style.display = 'none';
            backToDropdownBtn.style.display = 'none';
            categorySelect.value = '';
        });
        
        // Form submission handling
        addVocabForm.addEventListener('submit', function(e) {
            // If new category input is visible, use its value instead of dropdown value
            if (newCategoryInput.style.display !== 'none') {
                const newCategoryName = newCategoryInput.value.trim();
                if (newCategoryName) {
                    // Change the name attribute of newCategoryInput to 'category' so it gets sent
                    newCategoryInput.name = 'category';
                    // Hide the original category select so it doesn't get sent
                    categorySelect.name = '';
                } else {
                    // If no category name entered, prevent submission
                    e.preventDefault();
                    alert('Vui lòng nhập tên danh mục mới');
                    return false;
                }
            }
        });
        
        // Audio functionality
        function playAudio(audioUrl) {
            console.log('DEBUG: playAudio called with URL:', audioUrl);
            
            if (!audioUrl || audioUrl.trim() === '') {
                console.log('No audio URL provided');
                return;
            }
            
            // Add leading slash if not present (database stores without leading slash)
            if (!audioUrl.startsWith('/')) {
                audioUrl = '/' + audioUrl;
            }
            
            // Add context path if not present
            if (!audioUrl.startsWith('/EnglishProject/')) {
                audioUrl = '/EnglishProject' + audioUrl;
            }
            
            console.log('DEBUG: playAudio final URL:', audioUrl);
            
            // Get the button that was clicked
            const button = event.target.closest('.btn-icon');
            const originalIcon = button.innerHTML;
            
            // Show loading state
            button.innerHTML = '<i class="ri-loader-4-line"></i>';
            button.disabled = true;
            
            try {
                console.log('DEBUG: Creating Audio object with URL:', audioUrl);
                const audio = new Audio(audioUrl);
                
                audio.addEventListener('loadstart', function() {
                    console.log('DEBUG: Audio loading started');
                });
                
                audio.addEventListener('canplay', function() {
                    console.log('DEBUG: Audio can play');
                });
                
                audio.addEventListener('play', function() {
                    console.log('DEBUG: Audio started playing');
                    button.innerHTML = '<i class="ri-volume-up-line"></i>';
                });
                
                audio.addEventListener('pause', function() {
                    console.log('DEBUG: Audio paused');
                    button.innerHTML = originalIcon;
                    button.disabled = false;
                });
                
                audio.addEventListener('ended', function() {
                    console.log('DEBUG: Audio ended');
                    button.innerHTML = originalIcon;
                    button.disabled = false;
                });
                
                audio.addEventListener('error', function(e) {
                    console.error('DEBUG: Audio error:', e);
                    console.error('DEBUG: Audio error details:', audio.error);
                    button.innerHTML = '<i class="ri-error-warning-line"></i>';
                    setTimeout(() => {
                        button.innerHTML = originalIcon;
                        button.disabled = false;
                    }, 2000);
                });
                
                // Play the audio
                console.log('DEBUG: Attempting to play audio');
                audio.play().then(() => {
                    console.log('DEBUG: Audio play() succeeded');
                }).catch(error => {
                    console.error('DEBUG: Audio play() failed:', error);
                    button.innerHTML = '<i class="ri-error-warning-line"></i>';
                    setTimeout(() => {
                        button.innerHTML = originalIcon;
                        button.disabled = false;
                    }, 2000);
                });
                
            } catch (error) {
                console.error('DEBUG: Error creating audio object:', error);
                button.innerHTML = originalIcon;
                button.disabled = false;
            }
        }
        
        // Search functionality
        const searchInput = document.getElementById('search-input');
        searchInput.addEventListener('input', function() {
            filterVocabularyList();
        });
        
        // Combined filter function
        function filterVocabularyList() {
            const searchTerm = searchInput.value.toLowerCase().trim();
            const categoryFilter = document.getElementById('vocab-filter').value;
            const vocabItems = document.querySelectorAll('.vocab-item');
            let visibleCount = 0;
            
            console.log('DEBUG: filterVocabularyList - searchTerm:', searchTerm, 'categoryFilter:', categoryFilter);
            
            vocabItems.forEach(item => {
                const word = item.getAttribute('data-word');
                const categoryName = item.querySelector('.vocab-category').textContent;
                
                // Check if item matches search term
                const matchesSearch = searchTerm === '' || word.includes(searchTerm);
                
                // Check if item matches category filter
                let matchesCategory = true;
                if (categoryFilter !== 'all') {
                    // Check if category name contains the selected filter
                    matchesCategory = categoryName.toLowerCase().includes(categoryFilter.toLowerCase());
                }
                
                console.log('DEBUG: Item word:', word, 'category:', categoryName, 'matchesSearch:', matchesSearch, 'matchesCategory:', matchesCategory);
                
                // Show/hide item based on both search and category filters
                if (matchesSearch && matchesCategory) {
                    item.style.display = 'flex';
                    visibleCount++;
                } else {
                    item.style.display = 'none';
                }
            });
            
            console.log('DEBUG: Total items:', vocabItems.length, 'Visible count:', visibleCount);
            
            // Update count
            updateVisibleCount(visibleCount);
        }
        
        // Update filter function to also trigger search
        function filterVocabulary() {
            const filterValue = document.getElementById('vocab-filter').value;
            // Clear search when changing category
            searchInput.value = '';
            
            // Call filterVocabularyList to update visibility and count
            filterVocabularyList();
        }
        
        // Update visible vocabulary count
        function updateVisibleCount(visibleCount) {
            const totalItems = document.querySelectorAll('.vocab-item').length;
            const countElement = document.getElementById('total-vocab-count');
            const searchTerm = searchInput.value.toLowerCase().trim();
            const categoryFilter = document.getElementById('vocab-filter').value;
            
            console.log('DEBUG: updateVisibleCount - visibleCount:', visibleCount, 'searchTerm:', searchTerm, 'categoryFilter:', categoryFilter);
            
            // Show filtered count if there's active filtering
            if (searchTerm !== '' || categoryFilter !== 'all') {
                const filteredText = visibleCount + '/' + totalItems + ' từ vựng';
                countElement.textContent = filteredText;
                console.log('DEBUG: updateVisibleCount - Showing filtered count:', filteredText);
            } else {
                // Show original total from server
                const originalText = '<%= totalVocabulary != null ? totalVocabulary : 0 %> từ vựng';
                countElement.textContent = originalText;
                console.log('DEBUG: updateVisibleCount - Showing original count:', originalText);
            }
        }
        
        // Expandable definitions functionality
        function toggleDefinitions(vocabId) {
            // If vocabId is undefined or empty, try to get it from the clicked button
            if (!vocabId || vocabId === '') {
                const clickedElement = event.target;
                // Find the button element (in case we clicked on a child element)
                const clickedButton = clickedElement.closest('.expand-button') || clickedElement;
                if (clickedButton && clickedButton.hasAttribute('data-vocab-id')) {
                    vocabId = clickedButton.getAttribute('data-vocab-id');
                } else {
                    console.error('No vocab ID found in parameter or data attribute');
                    return;
                }
            }
            
            const definitionsDiv = document.getElementById('definitions-' + vocabId);
            
            // Check if definitionsDiv exists
            if (!definitionsDiv) {
                console.error(`Definitions div not found for vocab ID: ${vocabId}`);
                return;
            }
            
            const vocabItem = definitionsDiv.closest('.vocab-item');
            if (!vocabItem) {
                console.error(`Vocab item not found for vocab ID: ${vocabId}`);
                return;
            }
            
            const expandButton = vocabItem.querySelector('.expand-button');
            if (!expandButton) {
                console.error(`Expand button not found for vocab ID: ${vocabId}`);
                return;
            }
            
            if (definitionsDiv.style.display === 'none' || definitionsDiv.style.display === '') {
                definitionsDiv.style.display = 'block';
                expandButton.classList.add('expanded');
            } else {
                definitionsDiv.style.display = 'none';
                expandButton.classList.remove('expanded');
            }
        }
        
        // Close dialog when clicking outside
        dialog.addEventListener('click', function(event) {
            const rect = dialog.getBoundingClientRect();
            const isInDialog = (rect.top <= event.clientY && event.clientY <= rect.top + rect.height &&
                rect.left <= event.clientX && event.clientX <= rect.left + rect.width);
            if (!isInDialog) {
                closeAddVocabDialog();
            }
        });
    </script>
</body>
</html>