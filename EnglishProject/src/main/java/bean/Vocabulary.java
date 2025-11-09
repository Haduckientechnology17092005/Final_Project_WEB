package bean;

public class Vocabulary {
    private int id;
    private String raw;
    private String phonetic;
    private String audioUrl;
    private String origin;
    private Integer categoryId;
    private String definitions;
    private String examples;
    
    public Vocabulary() {
    }
    
    public Vocabulary(int id, String raw, String phonetic, String audioUrl, String origin, Integer categoryId) {
        this.id = id;
        this.raw = raw;
        this.phonetic = phonetic;
        this.audioUrl = audioUrl;
        this.origin = origin;
        this.categoryId = categoryId;
    }
    
    public Vocabulary(int id, String raw, String phonetic, String audioUrl, String origin, Integer categoryId, String definitions, String examples) {
        this.id = id;
        this.raw = raw;
        this.phonetic = phonetic;
        this.audioUrl = audioUrl;
        this.origin = origin;
        this.categoryId = categoryId;
        this.definitions = definitions;
        this.examples = examples;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getRaw() {
        return raw;
    }
    
    public void setRaw(String raw) {
        this.raw = raw;
    }
    
    public String getPhonetic() {
        return phonetic;
    }
    
    public void setPhonetic(String phonetic) {
        this.phonetic = phonetic;
    }
    
    public String getAudioUrl() {
        return audioUrl;
    }
    
    public void setAudioUrl(String audioUrl) {
        this.audioUrl = audioUrl;
    }
    
    public String getOrigin() {
        return origin;
    }
    
    public void setOrigin(String origin) {
        this.origin = origin;
    }
    
    public Integer getCategoryId() {
        return categoryId;
    }
    
    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }
    
    public String getDefinitions() {
        return definitions;
    }
    
    public void setDefinitions(String definitions) {
        this.definitions = definitions;
    }
    
    public String getExamples() {
        return examples;
    }
    
    public void setExamples(String examples) {
        this.examples = examples;
    }
    
    @Override
    public String toString() {
        return "Vocabulary{" +
                "id=" + id +
                ", raw='" + raw + '\'' +
                ", phonetic='" + phonetic + '\'' +
                ", audioUrl='" + audioUrl + '\'' +
                ", origin='" + origin + '\'' +
                ", categoryId=" + categoryId +
                ", definitions='" + definitions + '\'' +
                ", examples='" + examples + '\'' +
                '}';
    }
} 