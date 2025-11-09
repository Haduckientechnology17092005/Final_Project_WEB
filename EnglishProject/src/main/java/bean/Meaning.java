package bean;

public class Meaning {
    private int id;
    private int vocabId;
    private String partOfSpeech;
    
    public Meaning() {
    }
    
    public Meaning(int id, int vocabId, String partOfSpeech) {
        this.id = id;
        this.vocabId = vocabId;
        this.partOfSpeech = partOfSpeech;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getVocabId() {
        return vocabId;
    }
    
    public void setVocabId(int vocabId) {
        this.vocabId = vocabId;
    }
    
    public String getPartOfSpeech() {
        return partOfSpeech;
    }
    
    public void setPartOfSpeech(String partOfSpeech) {
        this.partOfSpeech = partOfSpeech;
    }
    
    @Override
    public String toString() {
        return "Meaning{" +
                "id=" + id +
                ", vocabId=" + vocabId +
                ", partOfSpeech='" + partOfSpeech + '\'' +
                '}';
    }
} 