package bo;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import bean.Vocabulary;
import bean.FillInBlank;
import java.util.Random;

public class ComprehensivePracticeBO {
    
    private FillInBlankBO fillInBlankBO;
    private VocabularyBO vocabularyBO;
    private LearningBO learningBO;
    
    public ComprehensivePracticeBO() {
        this.fillInBlankBO = new FillInBlankBO();
        this.vocabularyBO = new VocabularyBO();
        this.learningBO = new LearningBO();
    }
    
    /**
     * Get comprehensive practice data for all vocabulary
     */
    public Map<String, Object> getComprehensivePracticeData(String userEmail) throws SQLException {
        return getComprehensivePracticeData(userEmail, -1);
    }
    
    /**
     * Get comprehensive practice data for vocabulary with limit
     */
    public Map<String, Object> getComprehensivePracticeData(String userEmail, int limit) throws SQLException {
        Map<String, Object> data = new HashMap<>();
        
        // Get all vocabulary for review and practice
        List<Vocabulary> allVocabulary = learningBO.getAllVocabularyForPractice(userEmail);
        
        // Apply limit if specified
        if (limit > 0 && allVocabulary.size() > limit) {
            allVocabulary = allVocabulary.subList(0, limit);
        }
        
        data.put("allVocabulary", allVocabulary);
        
        // Create comprehensive exercises including FillInBlank
        List<Map<String, Object>> exercises = createComprehensiveExercises(allVocabulary);
        data.put("exercises", exercises);
        data.put("exerciseType", "comprehensive");
        data.put("totalExercises", exercises.size());
        data.put("currentExerciseIndex", 0);
        
        System.out.println("DEBUG: ComprehensivePracticeBO - Created comprehensive exercises: " + exercises.size());
        System.out.println("DEBUG: ComprehensivePracticeBO - Vocabulary limit: " + limit);
        
        return data;
    }
    
    /**
     * Create comprehensive exercises for all vocabulary
     */
    private List<Map<String, Object>> createComprehensiveExercises(List<Vocabulary> allVocabulary) {
        List<Map<String, Object>> exercises = new ArrayList<>();
        Random random = new Random();
        
        if (allVocabulary == null || allVocabulary.isEmpty()) {
            return exercises;
        }
        
        System.out.println("DEBUG: ComprehensivePracticeBO - Processing " + allVocabulary.size() + " vocabulary");
        
        int exerciseId = 1;
        
        // Create exercises for each vocabulary
        for (Vocabulary vocab : allVocabulary) {
            if (vocab.getRaw() == null || vocab.getRaw().trim().isEmpty()) {
                continue;
            }
            
            System.out.println("DEBUG: ComprehensivePracticeBO - Processing vocab: " + vocab.getRaw() + " (ID: " + vocab.getId() + ")");
            System.out.println("DEBUG: ComprehensivePracticeBO - Definitions: " + (vocab.getDefinitions() != null ? vocab.getDefinitions().length() : "null"));
            System.out.println("DEBUG: ComprehensivePracticeBO - Examples: " + (vocab.getExamples() != null ? vocab.getExamples().length() : "null"));
            System.out.println("DEBUG: ComprehensivePracticeBO - Audio: " + (vocab.getAudioUrl() != null ? vocab.getAudioUrl() : "null"));
            
            // First, try to get FillInBlank exercises for this vocabulary
            try {
                List<FillInBlank> fillInBlankExercises = fillInBlankBO.getFillInBlankByVocabularyId(vocab.getId());
                if (fillInBlankExercises != null && !fillInBlankExercises.isEmpty()) {
                    // Add FillInBlank exercises
                    for (FillInBlank fillInBlank : fillInBlankExercises) {
                        Map<String, Object> exercise = new HashMap<>();
                        exercise.put("id", exerciseId++);
                        exercise.put("type", "fill_in_blank");
                        exercise.put("question", "Điền từ thích hợp vào chỗ trống:");
                        exercise.put("content", fillInBlank.getQuestion());
                        exercise.put("correctAnswer", fillInBlank.getCorrectAnswer());
                        exercise.put("vocab_id", vocab.getId());
                        exercise.put("hint", "Hãy đọc kỹ câu và chọn từ phù hợp nhất");
                        exercise.put("fillInBlankId", fillInBlank.getId());
                        exercises.add(exercise);
                        System.out.println("DEBUG: ComprehensivePracticeBO - Added FillInBlank exercise for: " + vocab.getRaw());
                    }
                    continue; // Skip other exercise types if FillInBlank exists
                }
            } catch (SQLException e) {
                System.err.println("Error getting FillInBlank exercises for vocab " + vocab.getId() + ": " + e.getMessage());
            }
            
            // Exercise 1: Definition to word (Priority 1)
            if (vocab.getDefinitions() != null && !vocab.getDefinitions().trim().isEmpty()) {
                String[] definitions = vocab.getDefinitions().split("\\|");
                if (definitions.length > 0 && !definitions[0].trim().isEmpty()) {
                    Map<String, Object> exercise = new HashMap<>();
                    exercise.put("id", exerciseId++);
                    exercise.put("type", "definition_to_word");
                    exercise.put("question", "Dựa vào định nghĩa, hãy viết từ tiếng Anh:");
                    exercise.put("content", definitions[0].trim());
                    exercise.put("correctAnswer", vocab.getRaw().toLowerCase());
                    exercise.put("vocab_id", vocab.getId());
                    exercise.put("hint", "Từ có " + vocab.getRaw().length() + " chữ cái");
                    exercises.add(exercise);
                    System.out.println("DEBUG: ComprehensivePracticeBO - Added Definition exercise for: " + vocab.getRaw());
                }
            } else {
                // Create a simple word-to-word exercise if no definition
                Map<String, Object> exercise = new HashMap<>();
                exercise.put("id", exerciseId++);
                exercise.put("type", "word_to_word");
                exercise.put("question", "Viết lại từ tiếng Anh:");
                exercise.put("content", vocab.getRaw());
                exercise.put("correctAnswer", vocab.getRaw().toLowerCase());
                exercise.put("vocab_id", vocab.getId());
                exercise.put("hint", "Từ có " + vocab.getRaw().length() + " chữ cái");
                exercises.add(exercise);
                System.out.println("DEBUG: ComprehensivePracticeBO - Added Word-to-Word exercise for: " + vocab.getRaw());
            }
            
            // Exercise 2: Example to word (Priority 2)
            if (vocab.getExamples() != null && !vocab.getExamples().trim().isEmpty()) {
                String[] examples = vocab.getExamples().split("\\|");
                if (examples.length > 0 && !examples[0].trim().isEmpty()) {
                    Map<String, Object> exercise = new HashMap<>();
                    exercise.put("id", exerciseId++);
                    exercise.put("type", "example_to_word");
                    exercise.put("question", "Dựa vào câu ví dụ, hãy viết từ tiếng Anh:");
                    exercise.put("content", examples[0].trim());
                    exercise.put("correctAnswer", vocab.getRaw().toLowerCase());
                    exercise.put("vocab_id", vocab.getId());
                    exercise.put("hint", "Từ có " + vocab.getRaw().length() + " chữ cái");
                    exercises.add(exercise);
                    System.out.println("DEBUG: ComprehensivePracticeBO - Added Example exercise for: " + vocab.getRaw());
                }
            }
            
            // Exercise 3: Audio to word (Priority 3 - if audio exists)
            if (vocab.getAudioUrl() != null && !vocab.getAudioUrl().trim().isEmpty()) {
                Map<String, Object> exercise = new HashMap<>();
                exercise.put("id", exerciseId++);
                exercise.put("type", "audio_to_word");
                exercise.put("question", "Nghe phát âm và viết từ tiếng Anh:");
                exercise.put("content", vocab.getAudioUrl());
                exercise.put("correctAnswer", vocab.getRaw().toLowerCase());
                exercise.put("vocab_id", vocab.getId());
                exercise.put("hint", "Từ có " + vocab.getRaw().length() + " chữ cái");
                exercises.add(exercise);
                System.out.println("DEBUG: ComprehensivePracticeBO - Added Audio exercise for: " + vocab.getRaw());
            }
        }
        
        // Shuffle exercises for better learning experience
        for (int i = exercises.size() - 1; i > 0; i--) {
            int j = random.nextInt(i + 1);
            Map<String, Object> temp = exercises.get(i);
            exercises.set(i, exercises.get(j));
            exercises.set(j, temp);
        }
        
        System.out.println("DEBUG: ComprehensivePracticeBO - Created " + exercises.size() + " exercises");
        return exercises;
    }
    
    /**
     * Check answer for comprehensive exercise
     */
    public boolean checkAnswer(String userAnswer, String correctAnswer) {
        if (userAnswer == null || correctAnswer == null) {
            return false;
        }
        
        // Case-insensitive comparison
        return userAnswer.trim().toLowerCase().equals(correctAnswer.trim().toLowerCase());
    }
    
    /**
     * Mark vocabulary as learned
     */
    public boolean markVocabularyAsLearned(String userEmail, int vocabId) throws SQLException {
        return learningBO.markAsLearned(userEmail, vocabId);
    }
} 