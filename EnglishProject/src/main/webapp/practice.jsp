<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luyện tập từ vựng - DutEnglish</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f8f9fa;
        }
        
        .practice-container {
            max-width: 600px;
            margin: 0 auto;
        }
        
        .practice-header {
            background: white;
            padding: 20px 24px;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header-left h1 {
            margin: 0;
            font-size: 20px;
            color: #333;
        }
        
        .header-left p {
            margin: 4px 0 0 0;
            color: #666;
            font-size: 14px;
        }
        
        .progress-info {
            text-align: right;
        }
        
        .progress-text {
            font-size: 14px;
            color: #666;
            margin: 0;
        }
        
        .progress-bar {
            width: 200px;
            height: 8px;
            background: #e9ecef;
            border-radius: 4px;
            margin-top: 8px;
            overflow: hidden;
        }
        
        .progress-fill {
            height: 100%;
            background: #ff6600;
            border-radius: 4px;
            transition: width 0.3s ease;
        }
        
        .practice-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            padding: 40px;
            text-align: center;
            margin-bottom: 20px;
            min-height: 400px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        
        .question-text {
            font-size: 18px;
            color: #333;
            margin-bottom: 24px;
            line-height: 1.6;
        }
        
        .word-display {
            font-size: 36px;
            font-weight: 700;
            color: #ff6600;
            margin: 24px 0;
        }
        
        .input-section {
            margin: 24px 0;
        }
        
        .answer-input {
            width: 100%;
            max-width: 400px;
            padding: 16px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            text-align: center;
            outline: none;
            box-sizing: border-box;
        }
        
        .answer-input:focus {
            border-color: #ff6600;
        }
        
        .answer-input.correct {
            border-color: #28a745;
            background-color: #d4edda;
        }
        
        .answer-input.incorrect {
            border-color: #dc3545;
            background-color: #f8d7da;
        }
        
        .hint-text {
            color: #666;
            font-size: 14px;
            margin-top: 8px;
            font-style: italic;
        }
        
        .action-buttons {
            display: flex;
            gap: 12px;
            justify-content: center;
            margin-top: 24px;
        }
        
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }
        
        .btn-primary {
            background: #ff6600;
            color: white;
        }
        
        .btn-primary:hover {
            background: #e55a00;
        }
        
        .btn-primary:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .btn-success {
            background: #28a745;
            color: white;
        }
        
        .btn-success:hover {
            background: #218838;
        }
        
        .result-section {
            margin-top: 20px;
            padding: 16px;
            border-radius: 8px;
            display: none;
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
        
        .correct-answer {
            font-weight: 600;
            margin-top: 8px;
        }
        
        .loading {
            text-align: center;
            padding: 60px;
            color: #666;
        }
        
        .completed {
            text-align: center;
            padding: 60px;
        }
        
        .completed-icon {
            font-size: 64px;
            margin-bottom: 16px;
        }
        
        .completed-title {
            font-size: 24px;
            font-weight: 700;
            color: #333;
            margin-bottom: 8px;
        }
        
        .completed-text {
            color: #666;
            margin-bottom: 24px;
        }
    </style>
</head>
<body>
    <div class="practice-container">
        <!-- Practice Header -->
        <div class="practice-header">
            <div class="header-left">
                <h1 id="practice-title">Luyện tập từ vựng</h1>
                <p id="practice-mode">Đang tải...</p>
            </div>
            <div class="progress-info">
                <p class="progress-text">Câu <span id="current-question">0</span> / <span id="total-questions">0</span></p>
                <div class="progress-bar">
                    <div class="progress-fill" id="progress-fill" style="width: 0%"></div>
                </div>
            </div>
        </div>
        
        <!-- Loading State -->
        <div id="loading" class="practice-card loading">
            Đang tải câu hỏi...
        </div>
        
        <!-- Practice Card -->
        <div id="practice-card" class="practice-card" style="display: none;">
            <div class="question-text" id="question-text"></div>
            <div class="word-display" id="word-display"></div>
            <div class="input-section">
                <input type="text" class="answer-input" id="answer-input" placeholder="Nhập câu trả lời...">
                <div class="hint-text" id="hint-text"></div>
            </div>
            <div class="result-section" id="result-section">
                <div id="result-text"></div>
                <div class="correct-answer" id="correct-answer"></div>
            </div>
            <div class="action-buttons">
                <button class="btn btn-secondary" id="skip-btn">Bỏ qua</button>
                <button class="btn btn-primary" id="check-btn">Kiểm tra</button>
                <button class="btn btn-success" id="next-btn" style="display: none;">Tiếp theo</button>
            </div>
        </div>
        
        <!-- Completed State -->
        <div id="completed" class="practice-card completed" style="display: none;">
            <div class="completed-icon">🎉</div>
            <h2 class="completed-title">Hoàn thành!</h2>
            <p class="completed-text">Bạn đã hoàn thành bài luyện tập</p>
            <div class="action-buttons">
                <button class="btn btn-secondary" onclick="window.location.href='review.jsp'">Về trang ôn tập</button>
                <button class="btn btn-primary" id="restart-btn">Luyện tập lại</button>
            </div>
        </div>
    </div>
    
    <script>
        class PracticeController {
            constructor() {
                this.currentUser = 'test@dutenglish.com'; // TODO: Get from session
                this.mode = this.getUrlParameter('mode') || 'all';
                this.vocabularies = [];
                this.currentIndex = 0;
                this.currentVocab = null;
                this.answered = false;
                
                this.init();
            }
            
            getUrlParameter(name) {
                const urlParams = new URLSearchParams(window.location.search);
                return urlParams.get(name);
            }
            
            async init() {
                this.setupModeDisplay();
                await this.loadVocabularies();
                this.bindEvents();
                this.showNextQuestion();
            }
            
            setupModeDisplay() {
                const modeTexts = {
                    'review': 'Ôn tập từ cũ - Luyện tập các từ cần ôn tập',
                    'learn': 'Học từ mới - Học các từ vựng chưa học',
                    'all': 'Luyện tập tổng hợp - Trộn lẫn tất cả từ vựng'
                };
                
                document.getElementById('practice-mode').textContent = modeTexts[this.mode] || modeTexts['all'];
            }
            
            async loadVocabularies() {
                try {
                    // TODO: Replace with actual API calls based on mode
                    /*
                    let apiUrl;
                    switch(this.mode) {
                        case 'review':
                            apiUrl = '/api/vocabulary/review?email=' + this.currentUser;
                            break;
                        case 'learn':
                            apiUrl = '/api/vocabulary/unlearned?email=' + this.currentUser;
                            break;
                        default:
                            apiUrl = '/api/vocabulary/all?email=' + this.currentUser;
                    }
                    
                    const response = await fetch(apiUrl);
                    const data = await response.json();
                    this.vocabularies = data.vocabularies;
                    */
                    
                    // Mock data for testing
                    await new Promise(resolve => setTimeout(resolve, 1000));
                    this.vocabularies = [
                        {
                            id: 1,
                            word: 'hello',
                            vietnameseMeaning: 'xin chào, chào hỏi',
                            exampleSentence: 'Hello, how are you today?'
                        },
                        {
                            id: 2,
                            word: 'fall in love',
                            vietnameseMeaning: 'yêu ai đó một cách say đắm, bắt đầu cảm thấy tình cảm lãng mạn với ai đó',
                            exampleSentence: 'They fell in love at first sight.'
                        },
                        {
                            id: 3,
                            word: 'nature',
                            vietnameseMeaning: 'thiên nhiên, tự nhiên',
                            exampleSentence: 'I love spending time in nature.'
                        },
                        {
                            id: 4,
                            word: 'beautiful',
                            vietnameseMeaning: 'đẹp, xinh đẹp',
                            exampleSentence: 'The sunset is very beautiful.'
                        }
                    ];
                    
                    // Shuffle vocabularies
                    this.vocabularies = this.shuffleArray(this.vocabularies);
                    
                    document.getElementById('total-questions').textContent = this.vocabularies.length;
                    document.getElementById('loading').style.display = 'none';
                    
                } catch (error) {
                    console.error('Error loading vocabularies:', error);
                    alert('Không thể tải dữ liệu từ vựng');
                }
            }
            
            shuffleArray(array) {
                const shuffled = [...array];
                for (let i = shuffled.length - 1; i > 0; i--) {
                    const j = Math.floor(Math.random() * (i + 1));
                    [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
                }
                return shuffled;
            }
            
            showNextQuestion() {
                if (this.currentIndex >= this.vocabularies.length) {
                    this.showCompleted();
                    return;
                }
                
                this.currentVocab = this.vocabularies[this.currentIndex];
                this.answered = false;
                
                // Update progress
                document.getElementById('current-question').textContent = this.currentIndex + 1;
                const progress = ((this.currentIndex + 1) / this.vocabularies.length) * 100;
                document.getElementById('progress-fill').style.width = progress + '%';
                
                // Random question type
                const questionTypes = ['meaning', 'example'];
                const questionType = questionTypes[Math.floor(Math.random() * questionTypes.length)];
                
                this.displayQuestion(questionType);
                this.resetUI();
                
                document.getElementById('practice-card').style.display = 'flex';
            }
            
            displayQuestion(type) {
                const questionTexts = {
                    'meaning': 'Nghĩa của từ này là gì?',
                    'example': 'Hoàn thành câu ví dụ sau:'
                };
                
                document.getElementById('question-text').textContent = questionTexts[type];
                
                if (type === 'meaning') {
                    document.getElementById('word-display').textContent = this.currentVocab.word;
                    document.getElementById('hint-text').textContent = 'Gợi ý: ' + this.currentVocab.exampleSentence;
                    this.correctAnswer = this.currentVocab.vietnameseMeaning;
                } else {
                    // Show example with blank
                    const example = this.currentVocab.exampleSentence.replace(new RegExp(this.currentVocab.word, 'gi'), '____');
                    document.getElementById('word-display').textContent = example;
                    document.getElementById('hint-text').textContent = 'Gợi ý: ' + this.currentVocab.vietnameseMeaning;
                    this.correctAnswer = this.currentVocab.word;
                }
            }
            
            resetUI() {
                document.getElementById('answer-input').value = '';
                document.getElementById('answer-input').className = 'answer-input';
                document.getElementById('result-section').style.display = 'none';
                document.getElementById('check-btn').style.display = 'inline-block';
                document.getElementById('next-btn').style.display = 'none';
                document.getElementById('answer-input').focus();
            }
            
            bindEvents() {
                document.getElementById('check-btn').addEventListener('click', () => {
                    this.checkAnswer();
                });
                
                document.getElementById('next-btn').addEventListener('click', () => {
                    this.nextQuestion();
                });
                
                document.getElementById('skip-btn').addEventListener('click', () => {
                    this.skipQuestion();
                });
                
                document.getElementById('restart-btn').addEventListener('click', () => {
                    this.restart();
                });
                
                document.getElementById('answer-input').addEventListener('keypress', (e) => {
                    if (e.key === 'Enter') {
                        if (!this.answered) {
                            this.checkAnswer();
                        } else {
                            this.nextQuestion();
                        }
                    }
                });
            }
            
            checkAnswer() {
                const userAnswer = document.getElementById('answer-input').value.trim();
                if (!userAnswer) {
                    alert('Vui lòng nhập câu trả lời');
                    return;
                }
                
                this.answered = true;
                const isCorrect = this.isAnswerCorrect(userAnswer, this.correctAnswer);
                
                this.showResult(isCorrect);
                this.updateLearningProgress(isCorrect);
                
                document.getElementById('check-btn').style.display = 'none';
                document.getElementById('next-btn').style.display = 'inline-block';
            }
            
            isAnswerCorrect(userAnswer, correctAnswer) {
                // Simple fuzzy matching
                const userClean = userAnswer.toLowerCase().trim();
                const correctClean = correctAnswer.toLowerCase().trim();
                
                // Exact match
                if (userClean === correctClean) return true;
                
                // Partial match for Vietnamese meaning (contains main keywords)
                if (correctAnswer === this.currentVocab.vietnameseMeaning) {
                    const keywords = correctClean.split(/[,;]+/).map(k => k.trim());
                    return keywords.some(keyword => userClean.includes(keyword) || keyword.includes(userClean));
                }
                
                return false;
            }
            
            showResult(isCorrect) {
                const resultSection = document.getElementById('result-section');
                const resultText = document.getElementById('result-text');
                const correctAnswer = document.getElementById('correct-answer');
                const answerInput = document.getElementById('answer-input');
                
                resultSection.style.display = 'block';
                
                if (isCorrect) {
                    resultSection.className = 'result-section result-correct';
                    resultText.textContent = '🎉 Chính xác!';
                    answerInput.className = 'answer-input correct';
                    correctAnswer.style.display = 'none';
                } else {
                    resultSection.className = 'result-section result-incorrect';
                    resultText.textContent = '❌ Sai rồi!';
                    answerInput.className = 'answer-input incorrect';
                    correctAnswer.textContent = 'Đáp án đúng: ' + this.correctAnswer;
                    correctAnswer.style.display = 'block';
                }
            }
            
            async updateLearningProgress(isCorrect) {
                try {
                    // TODO: Update learning progress via API
                    /*
                    if (this.mode === 'learn' && isCorrect) {
                        // Create new learning record
                        await fetch('/api/learning', {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({
                                vocabId: this.currentVocab.id,
                                email: this.currentUser,
                                isLearned: false,
                                isReview: false
                            })
                        });
                    }
                    
                    if (isCorrect) {
                        // Mark as learned or update review status
                        await fetch('/api/learning/update', {
                            method: 'PUT',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({
                                vocabId: this.currentVocab.id,
                                email: this.currentUser,
                                isLearned: true
                            })
                        });
                    } else {
                        // Mark as needs review
                        await fetch('/api/learning/review', {
                            method: 'PUT',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({
                                vocabId: this.currentVocab.id,
                                email: this.currentUser,
                                isReview: true
                            })
                        });
                    }
                    */
                    
                    // Mock API calls
                    console.log('Learning progress: vocab ' + this.currentVocab.id + ', correct: ' + isCorrect);
                } catch (error) {
                    console.error('Error updating learning progress:', error);
                }
            }
            
            nextQuestion() {
                this.currentIndex++;
                this.showNextQuestion();
            }
            
            skipQuestion() {
                this.currentIndex++;
                this.showNextQuestion();
            }
            
            showCompleted() {
                document.getElementById('practice-card').style.display = 'none';
                document.getElementById('completed').style.display = 'flex';
            }
            
            restart() {
                this.currentIndex = 0;
                this.vocabularies = this.shuffleArray(this.vocabularies);
                document.getElementById('completed').style.display = 'none';
                this.showNextQuestion();
            }
        }
        
        // Initialize when DOM ready
        document.addEventListener('DOMContentLoaded', () => {
            new PracticeController();
        });
    </script>
</body>
</html> 