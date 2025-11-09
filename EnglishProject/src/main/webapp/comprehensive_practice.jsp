<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="bean.*" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ôn tập tổng hợp</title>
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
            max-width: 800px;
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
        
        .progress-bar {
            width: 100%;
            height: 10px;
            background: #e9ecef;
            border-radius: 5px;
            margin-bottom: 20px;
            overflow: hidden;
        }
        
        .progress-fill {
            height: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 5px;
            transition: width 0.3s ease;
        }
        
        .progress-text {
            text-align: center;
            font-size: 16px;
            color: #666;
            margin-bottom: 30px;
        }
        
        .exercise-section {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 20px;
        }
        
        .exercise-card {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .exercise-question {
            font-size: 1.3em;
            color: #333;
            margin-bottom: 20px;
            font-weight: 600;
        }
        
        .exercise-content {
            margin-bottom: 25px;
        }
        
        .exercise-text {
            font-size: 1.1em;
            color: #555;
            line-height: 1.6;
            margin-bottom: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #667eea;
        }
        
        .audio-player {
            text-align: center;
            margin-bottom: 20px;
        }
        
        .audio-btn {
            background: #6f42c1;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 25px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .audio-btn:hover {
            background: #5a32a3;
            transform: translateY(-2px);
        }
        
        .answer-input {
            width: 100%;
            padding: 15px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            outline: none;
            transition: border-color 0.3s ease;
        }
        
        .answer-input:focus {
            border-color: #667eea;
        }
        
        .hint {
            color: #666;
            font-size: 14px;
            margin-top: 10px;
            font-style: italic;
        }
        
        .exercise-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 25px;
        }
        
        .action-btn {
            padding: 12px 24px;
            border: none;
            border-radius: 25px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-check {
            background: #28a745;
            color: white;
        }
        
        .btn-check:hover {
            background: #218838;
            transform: translateY(-2px);
        }
        
        .btn-next {
            background: #007bff;
            color: white;
        }
        
        .btn-next:hover {
            background: #0056b3;
            transform: translateY(-2px);
        }
        
        .btn-finish {
            background: #ffc107;
            color: #333;
        }
        
        .btn-finish:hover {
            background: #e0a800;
            transform: translateY(-2px);
        }
        
        .btn-skip {
            background: #6c757d;
            color: white;
        }
        
        .btn-skip:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        
        .result-message {
            padding: 15px;
            border-radius: 8px;
            margin-top: 20px;
            text-align: center;
            font-weight: 600;
        }
        
        .result-correct {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .result-incorrect {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .result-skipped {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
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
            
            .exercise-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <button class="back-btn" onclick="window.location.href='review?refresh=' + new Date().getTime()">← Quay lại</button>
            <h1>Ôn tập tổng hợp</h1>
            <p>Luyện tập tất cả từ vựng qua các bài tập đa dạng</p>
        </div>
        
        <div class="content">
            <%
                List<Map<String, Object>> exercises = (List<Map<String, Object>>) request.getAttribute("exercises");
                Integer totalExercises = (Integer) request.getAttribute("totalExercises");
                Integer currentExerciseIndex = (Integer) request.getAttribute("currentExerciseIndex");
                
                if (exercises != null && !exercises.isEmpty() && currentExerciseIndex < exercises.size()) {
                    Map<String, Object> currentExercise = exercises.get(currentExerciseIndex);
                    String type = (String) currentExercise.get("type");
            %>
                <!-- Progress Bar -->
                <div class="progress-bar">
                    <div class="progress-fill" id="progress-fill" style="width: <%= (currentExerciseIndex + 1) * 100 / totalExercises %>%"></div>
                </div>
                
                <!-- Exercise Section -->
                <div class="exercise-section">
                    <div class="exercise-card">
                        <div class="exercise-question"><%= currentExercise.get("question") %></div>
                        <div class="exercise-content">
                            <% if ("fill_in_blank".equals(type)) { %>
                                <div class="exercise-text"><%= currentExercise.get("content") %></div>
                            <% } else if ("definition_to_word".equals(type)) { %>
                                <div class="exercise-text"><%= currentExercise.get("content") %></div>
                            <% } else if ("example_to_word".equals(type)) { %>
                                <div class="exercise-text"><%= currentExercise.get("content") %></div>
                            <% } else if ("word_to_definition".equals(type)) { %>
                                <div class="exercise-text">Từ: <strong><%= currentExercise.get("content") %></strong></div>
                            <% } else if ("audio_to_word".equals(type)) { %>
                                <div class="audio-player">
                                    <button class="audio-btn" onclick="playAudio('<%= currentExercise.get("content") %>')">
                                        🔊 Nghe phát âm
                                    </button>
                                </div>
                            <% } %>
                            <input type="text" class="answer-input" id="user-answer" placeholder="Nhập đáp án của bạn..." />
                            <div class="hint">💡 <%= currentExercise.get("hint") %></div>
                        </div>
                        <div class="exercise-actions">
                            <button class="action-btn btn-skip" onclick="skipExercise()" id="skip-btn">Bỏ qua</button>
                            <button class="action-btn btn-check" onclick="checkAnswer()">Kiểm tra</button>
                            <% if (currentExerciseIndex < totalExercises - 1) { %>
                                <button class="action-btn btn-next" onclick="nextExercise()" style="display: none;" id="next-btn">Tiếp theo</button>
                            <% } else { %>
                                <button class="action-btn btn-finish" onclick="finishPractice()" style="display: none;" id="finish-btn">Hoàn thành</button>
                            <% } %>
                        </div>
                        <div id="result-message" style="display: none;"></div>
                    </div>
                </div>
            <% } else { %>
                <div class="empty-state">
                    <h3>📚 Không có bài tập</h3>
                    <p>Không có từ vựng nào để luyện tập. Hãy thêm từ vựng mới!</p>
                </div>
            <% } %>
        </div>
    </div>
    
    <script>
        let allExercises = [];
        let currentExerciseIndex = <%= currentExerciseIndex != null ? currentExerciseIndex : 0 %>;
        let totalExercises = <%= totalExercises != null ? totalExercises : 0 %>;
        let currentExercise = null;
        
        <% if (exercises != null && !exercises.isEmpty()) { %>
            <% for (int i = 0; i < exercises.size(); i++) { %>
                <% 
                    Object vocabIdObj = exercises.get(i).get("vocab_id");
                    System.out.println("DEBUG: JSP - Exercise " + i + " vocab_id: " + vocabIdObj);
                %>
                allExercises.push({
                    id: <%= exercises.get(i).get("id") %>,
                    type: <%= exercises.get(i).get("type") != null ? "\"" + exercises.get(i).get("type").toString().replace("\"", "\\\"") + "\"" : "null" %>,
                    question: <%= exercises.get(i).get("question") != null ? "\"" + exercises.get(i).get("question").toString().replace("\"", "\\\"").replace("\n", "\\n") + "\"" : "null" %>,
                    content: <%= exercises.get(i).get("content") != null ? "\"" + exercises.get(i).get("content").toString().replace("\"", "\\\"").replace("\n", "\\n") + "\"" : "null" %>,
                    correctAnswer: <%= exercises.get(i).get("correctAnswer") != null ? "\"" + exercises.get(i).get("correctAnswer").toString().replace("\"", "\\\"").replace("\n", "\\n") + "\"" : "null" %>,
                    hint: <%= exercises.get(i).get("hint") != null ? "\"" + exercises.get(i).get("hint").toString().replace("\"", "\\\"").replace("\n", "\\n") + "\"" : "null" %>,
                    vocabId: <%= vocabIdObj != null ? vocabIdObj : "null" %>
                });
            <% } %>
        <% } %>
        
        // Load current exercise
        function loadCurrentExercise() {
            if (allExercises.length > 0 && currentExerciseIndex < allExercises.length) {
                currentExercise = allExercises[currentExerciseIndex];
                displayExercise(currentExercise);
                updateProgress();
            }
        }
        
        // Display exercise
        function displayExercise(exercise) {
            const questionElement = document.querySelector('.exercise-question');
            const contentElement = document.querySelector('.exercise-content');
            const answerInput = document.getElementById('user-answer');
            const hintElement = document.querySelector('.hint');
            
            // Update question
            questionElement.textContent = exercise.question;
            
            // Clear previous content
            contentElement.innerHTML = '';
            
            // Add content based on type
            if (exercise.type === 'fill_in_blank' || exercise.type === 'definition_to_word' || exercise.type === 'example_to_word' || exercise.type === 'word_to_word') {
                const textDiv = document.createElement('div');
                textDiv.className = 'exercise-text';
                textDiv.textContent = exercise.content;
                contentElement.appendChild(textDiv);
            } else if (exercise.type === 'audio_to_word') {
                const audioDiv = document.createElement('div');
                audioDiv.className = 'audio-player';
                audioDiv.innerHTML = '<button class="audio-btn" onclick="playAudio(\'' + exercise.content + '\')">🔊 Nghe phát âm</button>';
                contentElement.appendChild(audioDiv);
            }
            
            // Add input field
            const inputDiv = document.createElement('input');
            inputDiv.type = 'text';
            inputDiv.className = 'answer-input';
            inputDiv.id = 'user-answer';
            inputDiv.placeholder = 'Nhập đáp án của bạn...';
            contentElement.appendChild(inputDiv);
            
            // Add hint
            const hintDiv = document.createElement('div');
            hintDiv.className = 'hint';
            hintDiv.innerHTML = '💡 ' + exercise.hint;
            contentElement.appendChild(hintDiv);
            
            // Clear input
            answerInput.value = '';
            
            // Update hint
            hintElement.innerHTML = '💡 ' + exercise.hint;
            
            // Reset result message
            const resultMessage = document.getElementById('result-message');
            resultMessage.style.display = 'none';
            
            // Reset buttons
            const checkBtn = document.querySelector('.btn-check');
            const nextBtn = document.getElementById('next-btn');
            const finishBtn = document.getElementById('finish-btn');
            const skipBtn = document.getElementById('skip-btn');
            
            checkBtn.disabled = false;
            checkBtn.textContent = 'Kiểm tra';
            
            if (nextBtn) nextBtn.style.display = 'none';
            if (finishBtn) finishBtn.style.display = 'none';
            if (skipBtn) skipBtn.style.display = 'inline-block';
        }
        
        // Update progress
        function updateProgress() {
            const progressFill = document.getElementById('progress-fill');
            
            console.log('DEBUG: updateProgress called, currentExerciseIndex:', currentExerciseIndex);
            
            if (progressFill) {
                const progress = ((currentExerciseIndex + 1) / totalExercises) * 100;
                progressFill.style.width = progress + '%';
                
                console.log('DEBUG: Progress bar updated to', progress + '%');
            } else {
                console.error('DEBUG: progressFill not found');
            }
        }
        
        // Initialize
        loadCurrentExercise();
        
        // Play audio function
        function playAudio(audioUrl) {
            if (!audioUrl || audioUrl.trim() === '') {
                console.log('No audio URL provided');
                return;
            }
            
            // Fix audio path
            if (!audioUrl.startsWith('/')) {
                audioUrl = '/' + audioUrl;
            }
            
            if (!audioUrl.startsWith('/EnglishProject/')) {
                audioUrl = '/EnglishProject' + audioUrl;
            }
            
            console.log('DEBUG: playAudio final URL:', audioUrl);
            
            const audio = new Audio(audioUrl);
            
            // Handle audio loading errors
            audio.addEventListener('error', function(e) {
                console.error('Audio loading error:', e);
                alert('Không thể phát audio. File có thể không tồn tại.');
            });
            
            audio.addEventListener('loadstart', function() {
                console.log('DEBUG: Audio loading started');
            });
            
            audio.addEventListener('canplay', function() {
                console.log('DEBUG: Audio can play');
            });
            
            audio.play().catch(error => {
                console.error('Error playing audio:', error);
                alert('Không thể phát audio. Vui lòng thử lại.');
            });
        }
        
        // Check answer function
        function checkAnswer() {
            const userAnswer = document.getElementById('user-answer').value.trim();
            const resultMessage = document.getElementById('result-message');
            const checkBtn = document.querySelector('.btn-check');
            const nextBtn = document.getElementById('next-btn');
            const finishBtn = document.getElementById('finish-btn');
            
            if (!userAnswer) {
                alert('Vui lòng nhập đáp án!');
                return;
            }
            
            if (!currentExercise) {
                alert('Không có bài tập hiện tại!');
                return;
            }
            
            console.log('DEBUG: checkAnswer - currentExercise:', currentExercise);
            console.log('DEBUG: checkAnswer - vocabId:', currentExercise.vocabId);
            console.log('DEBUG: checkAnswer - userAnswer:', userAnswer);
            console.log('DEBUG: checkAnswer - correctAnswer:', currentExercise.correctAnswer);
            
            checkBtn.disabled = true;
            checkBtn.textContent = 'Đang kiểm tra...';
            
            const requestBody = 'action=check_answer&user_answer=' + encodeURIComponent(userAnswer) + '&correct_answer=' + encodeURIComponent(currentExercise.correctAnswer) + '&vocab_id=' + currentExercise.vocabId;
            console.log('DEBUG: checkAnswer - requestBody:', requestBody);
            
            fetch('comprehensive_practice', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: requestBody
            })
            .then(response => response.json())
            .then(data => {
                checkBtn.disabled = false;
                checkBtn.textContent = 'Kiểm tra';
                
                console.log('DEBUG: checkAnswer - vocab_id:', currentExercise.vocabId);
                console.log('DEBUG: checkAnswer - user_answer:', userAnswer);
                console.log('DEBUG: checkAnswer - correct_answer:', currentExercise.correctAnswer);
                console.log('DEBUG: checkAnswer - response:', data);
                
                if (data.correct) {
                    resultMessage.className = 'result-message result-correct';
                    resultMessage.textContent = '✅ Đúng rồi! Chúc mừng bạn!';
                    resultMessage.style.display = 'block';
                    
                    if (nextBtn) {
                        nextBtn.style.display = 'inline-block';
                    }
                    if (finishBtn) {
                        finishBtn.style.display = 'inline-block';
                    }
                } else {
                    resultMessage.className = 'result-message result-incorrect';
                    resultMessage.textContent = '❌ Chưa đúng. Hãy thử lại!';
                    resultMessage.style.display = 'block';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                checkBtn.disabled = false;
                checkBtn.textContent = 'Kiểm tra';
                alert('Có lỗi xảy ra. Vui lòng thử lại.');
            });
        }
        
        // Next exercise function
        function nextExercise() {
            currentExerciseIndex++;
            if (currentExerciseIndex < totalExercises) {
                loadCurrentExercise();
                updateProgress(); // Add this line to update progress
            } else {
                finishPractice();
            }
        }
        
        // Finish practice function
        function finishPractice() {
            alert('Bạn đã hoàn thành bài tập tổng hợp!');
            // Force refresh the review page to show updated data
            window.location.href = 'review?refresh=' + new Date().getTime();
        }

        // Skip exercise function
        function skipExercise() {
            // Go directly to next exercise without confirmation
            nextExercise();
        }
    </script>
</body>
</html> 