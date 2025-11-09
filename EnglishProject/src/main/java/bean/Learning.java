package bean;

public class Learning {
    private int id;
    private String email;
    private int userId;
    private int vocabId;
    private boolean isLearned;
    private boolean isReview;
    
    public Learning() {
    }
    
    public Learning(int id, String email, int userId, int vocabId, boolean isLearned, boolean isReview) {
        this.id = id;
        this.email = email;
        this.userId = userId;
        this.vocabId = vocabId;
        this.isLearned = isLearned;
        this.isReview = isReview;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public int getVocabId() {
        return vocabId;
    }
    
    public void setVocabId(int vocabId) {
        this.vocabId = vocabId;
    }
    
    public boolean isLearned() {
        return isLearned;
    }
    
    public void setLearned(boolean learned) {
        isLearned = learned;
    }
    
    public boolean isReview() {
        return isReview;
    }
    
    public void setReview(boolean review) {
        isReview = review;
    }
    
    @Override
    public String toString() {
        return "Learning{" +
                "id=" + id +
                ", email='" + email + '\'' +
                ", userId=" + userId +
                ", vocabId=" + vocabId +
                ", isLearned=" + isLearned +
                ", isReview=" + isReview +
                '}';
    }
} 