package bo;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;
import javax.servlet.ServletContext;

public class TipsBO {
    
    private static final String TIPS_FOLDER = "tips";
    private ServletContext servletContext;
    
    public TipsBO() {
        // Default constructor
    }
    
    public TipsBO(ServletContext servletContext) {
        this.servletContext = servletContext;
    }
    
    /**
     * Get a random tip filename from the tips folder
     */
    public String getRandomTipFile() throws IOException {
        try {
            // Get all tip files
            List<File> tipFiles = getTipFiles();
            
            if (tipFiles.isEmpty()) {
                System.out.println("DEBUG: TipsBO - No tip files found");
                return null;
            }
            
            // Create new Random instance each time for true randomness
            Random random = new Random();
            
            // Show available files
            System.out.println("DEBUG: TipsBO - Available tip files:");
            for (int i = 0; i < tipFiles.size(); i++) {
                System.out.println("DEBUG: TipsBO - [" + i + "] " + tipFiles.get(i).getName());
            }
            
            // Select random file
            int randomIndex = random.nextInt(tipFiles.size());
            File randomFile = tipFiles.get(randomIndex);
            
            System.out.println("DEBUG: TipsBO - Random index: " + randomIndex);
            System.out.println("DEBUG: TipsBO - Selected tip file: " + randomFile.getName());
            
            // Return the filename (relative path)
            return randomFile.getName();
            
        } catch (Exception e) {
            System.err.println("DEBUG: TipsBO - Error getting random tip: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Get all tip files from the tips folder
     */
    private List<File> getTipFiles() throws IOException {
        File tipsFolder;
        
        if (servletContext != null) {
            // Use ServletContext to get the real path
            String realPath = servletContext.getRealPath("/tips");
            tipsFolder = new File(realPath);
            System.out.println("DEBUG: TipsBO - Using ServletContext path: " + realPath);
        } else {
            // Fallback to relative path
            tipsFolder = new File("src/main/webapp/tips");
            System.out.println("DEBUG: TipsBO - Using fallback path: " + tipsFolder.getAbsolutePath());
        }
        
        if (!tipsFolder.exists() || !tipsFolder.isDirectory()) {
            System.err.println("DEBUG: TipsBO - Tips folder not found at: " + tipsFolder.getAbsolutePath());
            return new ArrayList<>();
        }
        
        System.out.println("DEBUG: TipsBO - Found tips folder at: " + tipsFolder.getAbsolutePath());
        
        File[] files = tipsFolder.listFiles((dir, name) -> 
            name.toLowerCase().endsWith(".html")
        );
        
        if (files == null || files.length == 0) {
            System.err.println("DEBUG: TipsBO - No tip files found in folder: " + tipsFolder.getAbsolutePath());
            return new ArrayList<>();
        }
        
        System.out.println("DEBUG: TipsBO - Found " + files.length + " tip files");
        return Arrays.asList(files);
    }
} 