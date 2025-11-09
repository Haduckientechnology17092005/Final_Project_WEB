package bean;

public class FillInBlank {
    private int id;
    private String question;
    private String correctAnswer;
    private String wrongAnswer1;
    private String wrongAnswer2;
    private int vocabularyId;
    
    // Default constructor
    public FillInBlank() {
    }
    
    // Constructor with all fields
    public FillInBlank(int id, String question, String correctAnswer, String wrongAnswer1, String wrongAnswer2, int vocabularyId) {
        this.id = id;
        this.question = question;
        this.correctAnswer = correctAnswer;
        this.wrongAnswer1 = wrongAnswer1;
        this.wrongAnswer2 = wrongAnswer2;
        this.vocabularyId = vocabularyId;
    }
    
    // Constructor without id (for insert)
    public FillInBlank(String question, String correctAnswer, String wrongAnswer1, String wrongAnswer2, int vocabularyId) {
        this.question = question;
        this.correctAnswer = correctAnswer;
        this.wrongAnswer1 = wrongAnswer1;
        this.wrongAnswer2 = wrongAnswer2;
        this.vocabularyId = vocabularyId;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getQuestion() {
        return question;
    }
    
    public void setQuestion(String question) {
        this.question = question;
    }
    
    public String getCorrectAnswer() {
        return correctAnswer;
    }
    
    public void setCorrectAnswer(String correctAnswer) {
        this.correctAnswer = correctAnswer;
    }
    
    public String getWrongAnswer1() {
        return wrongAnswer1;
    }
    
    public void setWrongAnswer1(String wrongAnswer1) {
        this.wrongAnswer1 = wrongAnswer1;
    }
    
    public String getWrongAnswer2() {
        return wrongAnswer2;
    }
    
    public void setWrongAnswer2(String wrongAnswer2) {
        this.wrongAnswer2 = wrongAnswer2;
    }
    
    public int getVocabularyId() {
        return vocabularyId;
    }
    
    public void setVocabularyId(int vocabularyId) {
        this.vocabularyId = vocabularyId;
    }
    
    @Override
    public String toString() {
        return "FillInBlank{" +
                "id=" + id +
                ", question='" + question + '\'' +
                ", correctAnswer='" + correctAnswer + '\'' +
                ", wrongAnswer1='" + wrongAnswer1 + '\'' +
                ", wrongAnswer2='" + wrongAnswer2 + '\'' +
                ", vocabularyId=" + vocabularyId +
                '}';
    }
} 