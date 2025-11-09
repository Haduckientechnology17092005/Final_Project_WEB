<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ôn tập từ vựng</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        
        .header p {
            font-size: 1.1em;
            opacity: 0.9;
        }
        
        .back-btn {
            position: absolute;
            top: 20px;
            left: 20px;
            background: rgba(255,255,255,0.2);
            border: none;
            color: white;
            padding: 10px 15px;
            border-radius: 25px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        
        .back-btn:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
        }
        
        .content {
            padding: 30px;
        }
        
        .stats-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .stat-number {
            font-size: 2.5em;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .stat-label {
            font-size: 1.1em;
            opacity: 0.9;
        }
        
        .vocabulary-section {
            margin-top: 30px;
        }
        
        .section-title {
            font-size: 1.8em;
            margin-bottom: 20px;
            color: #333;
            border-bottom: 3px solid #667eea;
            padding-bottom: 10px;
        }
        
        .vocab-list {
            list-style: none;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .vocab-item {
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            padding: 20px;
            transition: all 0.3s ease;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        
        .vocab-item:hover {
            border-color: #667eea;
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .vocab-word {
            font-size: 1.4em;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
        }
        
        .vocab-phonetic {
            font-size: 1em;
            color: #666;
            margin-bottom: 10px;
            font-style: italic;
        }
        
        .vocab-meaning {
            color: #555;
            margin-bottom: 15px;
            line-height: 1.5;
        }
        
        .vocab-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        .action-btn {
            padding: 8px 15px;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            font-size: 12px;
            transition: all 0.3s ease;
            flex: 1;
        }
        
        .btn-learned {
            background: #28a745;
            color: white;
        }
        
        .btn-learned:hover {
            background: #218838;
            transform: translateY(-2px);
        }
        
        .btn-review {
            background: #ffc107;
            color: #333;
        }
        
        .btn-review:hover {
            background: #e0a800;
            transform: translateY(-2px);
        }
        
        .btn-practice {
            background: #007bff;
            color: white;
        }
        
        .btn-practice:hover {
            background: #0056b3;
            transform: translateY(-2px);
        }
        
        .btn-audio {
            background: #6f42c1;
            color: white;
            padding: 8px 12px;
        }
        
        .btn-audio:hover {
            background: #5a32a3;
            transform: translateY(-2px);
        }
        
        .empty-state {
            text-align: center;
            padding: 50px;
            color: #666;
        }
        
        .empty-state h3 {
            font-size: 1.5em;
            margin-bottom: 15px;
        }
        
        .empty-state p {
            font-size: 1.1em;
            opacity: 0.8;
        }
        
        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 10px;
            }
            
            .header {
                padding: 20px;
            }
            
            .header h1 {
                font-size: 2em;
            }
            
            .content {
                padding: 20px;
            }
            
            .vocab-list {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <button class="back-btn" onclick="window.location.href='sotay.jsp'">← Quay lại</button>
            <h1>Ôn tập từ vựng</h1>
            <p>Luyện tập và củng cố kiến thức từ vựng của bạn</p>
        </div>
        
        <div class="content">
            <!-- Statistics Section -->
            <div class="stats-section">
                <div class="stat-card">
                    <div class="stat-number"><%= request.getAttribute("totalReview") != null ? request.getAttribute("totalReview") : 0 %></div>
                    <div class="stat-label">Cần ôn tập</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= request.getAttribute("totalMastered") != null ? request.getAttribute("totalMastered") : 0 %></div>
                    <div class="stat-label">Đã thành thạo</div>
                </div>
            </div>
            
            <!-- Review Vocabulary Section -->
            <div class="vocabulary-section">
                <h2 class="section-title">Từ vựng cần ôn tập</h2>
                
                <% 
                    List<Vocabulary> reviewVocabulary = (List<Vocabulary>) request.getAttribute("reviewVocabulary");
                    if (reviewVocabulary != null && !reviewVocabulary.isEmpty()) {
                %>
                    <ul class="vocab-list">
                        <% for (Vocabulary vocab : reviewVocabulary) { %>
                            <li class="vocab-item">
                                <div class="vocab-word"><%= vocab.getRaw() %></div>
                                <% if (vocab.getPhonetic() != null && !vocab.getPhonetic().trim().isEmpty()) { %>
                                    <div class="vocab-phonetic">/<%= vocab.getPhonetic() %>/</div>
                                <% } %>
                                <div class="vocab-meaning">
                                    <% 
                                        if (vocab.getDefinitions() != null && !vocab.getDefinitions().trim().isEmpty()) {
                                            String[] definitions = vocab.getDefinitions().split("\\|");
                                            if (definitions.length > 0) {
                                                String firstDefinition = definitions[0].trim();
                                                if (!firstDefinition.isEmpty()) {
                                    %>
                                                <%= firstDefinition %>
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
                                <div class="vocab-actions">
                                    <button class="action-btn btn-audio" onclick="playAudio('<%= vocab.getAudioUrl() %>')">🔊</button>
                                    <button class="action-btn btn-learned" onclick="markAsLearned('<%= vocab.getId() %>')">✓ Đã học</button>
                                    <button class="action-btn btn-practice" onclick="startPractice('<%= vocab.getId() %>')">🎯 Luyện tập</button>
                                </div>
                            </li>
                        <% } %>
                    </ul>
                <% } else { %>
                    <div class="empty-state">
                        <h3>🎉 Tuyệt vời!</h3>
                        <p>Bạn không có từ vựng nào cần ôn tập. Hãy thêm từ vựng mới để bắt đầu học!</p>
                    </div>
                <% } %>
            </div>
            
            <!-- Mastered Vocabulary Section -->
            <div class="vocabulary-section">
                <h2 class="section-title">Từ vựng đã thành thạo</h2>
                
                <% 
                    List<Vocabulary> masteredVocabulary = (List<Vocabulary>) request.getAttribute("masteredVocabulary");
                    if (masteredVocabulary != null && !masteredVocabulary.isEmpty()) {
                %>
                    <ul class="vocab-list">
                        <% for (Vocabulary vocab : masteredVocabulary) { %>
                            <li class="vocab-item">
                                <div class="vocab-word"><%= vocab.getRaw() %></div>
                                <% if (vocab.getPhonetic() != null && !vocab.getPhonetic().trim().isEmpty()) { %>
                                    <div class="vocab-phonetic">/<%= vocab.getPhonetic() %>/</div>
                                <% } %>
                                <div class="vocab-meaning">
                                    <% 
                                        if (vocab.getDefinitions() != null && !vocab.getDefinitions().trim().isEmpty()) {
                                            String[] definitions = vocab.getDefinitions().split("\\|");
                                            if (definitions.length > 0) {
                                                String firstDefinition = definitions[0].trim();
                                                if (!firstDefinition.isEmpty()) {
                                    %>
                                                <%= firstDefinition %>
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
                                <div class="vocab-actions">
                                    <button class="action-btn btn-audio" onclick="playAudio('<%= vocab.getAudioUrl() %>')">🔊</button>
                                    <button class="action-btn btn-review" onclick="markForReview('<%= vocab.getId() %>')">⏰ Ôn lại</button>
                                    <button class="action-btn btn-practice" onclick="startPractice('<%= vocab.getId() %>')">🎯 Luyện tập</button>
                                </div>
                            </li>
                        <% } %>
                    </ul>
                <% } else { %>
                    <div class="empty-state">
                        <h3>📚 Chưa có từ vựng thành thạo</h3>
                        <p>Hãy học và luyện tập để thành thạo từ vựng!</p>
                </div>
                <% } %>
            </div>
            
            <!-- Comprehensive Practice Section -->
            <div class="vocabulary-section">
                <h2 class="section-title">Ôn tập tổng hợp</h2>
                <div style="text-align: center; padding: 30px; background: #f8f9fa; border-radius: 10px;">
                    <div style="margin-bottom: 20px;">
                        <label for="vocab-count" style="display: block; margin-bottom: 10px; font-weight: 600; color: #333;">
                            Chọn số lượng từ vựng cần ôn:
                        </label>
                        <select id="vocab-count" style="padding: 10px; border: 2px solid #ddd; border-radius: 8px; font-size: 16px; min-width: 200px;">
                            <option value="5">5 từ</option>
                            <option value="10">10 từ</option>
                            <option value="20">20 từ</option>
                            <option value="30">30 từ</option>
                            <option value="50">50 từ</option>
                            <option value="100">100 từ</option>
                            <option value="all">Tất cả từ vựng</option>
                        </select>
                    </div>
                    <button class="action-btn btn-practice" onclick="startComprehensivePractice()" style="padding: 15px 30px; font-size: 16px;">
                        🎯 Bắt đầu ôn tập tổng hợp
            </button>
                    <p style="margin-top: 15px; color: #666; font-size: 14px;">
                        Luyện tập từ vựng qua các bài tập đa dạng: ví dụ, định nghĩa, và phát âm
                    </p>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function playAudio(audioUrl) {
            if (!audioUrl || audioUrl.trim() === '') {
                console.log('No audio URL provided');
                return;
            }
            
            // Add leading slash if not present
            if (!audioUrl.startsWith('/')) {
                audioUrl = '/' + audioUrl;
            }
            
            // Add context path if not present
            if (!audioUrl.startsWith('/EnglishProject/')) {
                audioUrl = '/EnglishProject' + audioUrl;
            }
            
            console.log('DEBUG: playAudio final URL:', audioUrl);
            
            const audio = new Audio(audioUrl);
            audio.play().catch(error => {
                console.error('Error playing audio:', error);
            });
        }
        
        function markAsLearned(vocabId) {
            fetch('review', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=mark_as_learned&vocab_id=' + vocabId
            })
            .then(response => response.text())
            .then(result => {
                if (result === 'success') {
                    alert('Đã đánh dấu thành thạo!');
                    location.reload();
                } else {
                    alert('Có lỗi xảy ra. Vui lòng thử lại.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra. Vui lòng thử lại.');
            });
        }
        
        function markForReview(vocabId) {
            fetch('review', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=mark_for_review&vocab_id=' + vocabId
            })
            .then(response => response.text())
            .then(result => {
                if (result === 'success') {
                    alert('Đã đánh dấu cần ôn tập!');
                    location.reload();
                } else {
                    alert('Có lỗi xảy ra. Vui lòng thử lại.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra. Vui lòng thử lại.');
            });
        }
        
        function startPractice(vocabId) {
            // Redirect to practice page with vocabulary ID
            window.location.href = 'practice.jsp?vocab_id=' + vocabId;
        }

        function startComprehensivePractice() {
            const selectedCount = document.getElementById('vocab-count').value;
            let url = 'comprehensive_practice';
            if (selectedCount !== 'all') {
                url += '?count=' + selectedCount;
            }
            window.location.href = url;
        }
    </script>
</body>
</html> 