package bean;

public class Definition {
    private int id;
    private int meaningId;
    private String definition;
    private String example;
    
    public Definition() {
    }
    
    public Definition(int id, int meaningId, String definition, String example) {
        this.id = id;
        this.meaningId = meaningId;
        this.definition = definition;
        this.example = example;
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getMeaningId() {
        return meaningId;
    }
    
    public void setMeaningId(int meaningId) {
        this.meaningId = meaningId;
    }
    
    public String getDefinition() {
        return definition;
    }
    
    public void setDefinition(String definition) {
        this.definition = definition;
    }
    
    public String getExample() {
        return example;
    }
    
    public void setExample(String example) {
        this.example = example;
    }
    
    @Override
    public String toString() {
        return "Definition{" +
                "id=" + id +
                ", meaningId=" + meaningId +
                ", definition='" + definition + '\'' +
                ", example='" + example + '\'' +
                '}';
    }
} 