package bo;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.UUID;

public class AudioBO {
    
    private static final String AUDIO_FOLDER = "C:/Users/LAPTOP T&T/eclipse-workspace/EnglishProject/src/main/webapp/audio";
    private static final String GOOGLE_TTS_URL = "https://translate.google.com/translate_tts";
    private static final String DICTIONARY_API_URL = "https://api.dictionaryapi.dev/api/v2/entries/en/";
    
    public AudioBO() {
        // Audio folder already exists, no need to create
        System.out.println("Using existing audio folder: " + AUDIO_FOLDER);
    }
    
    /**
     * Generate audio file and phonetics for a vocabulary word
     * @param word The English word
     * @return AudioInfo containing audioUrl and phonetic
     */
    public AudioInfo generateAudioAndPhonetics(String word) {
        String phonetic = "";
        String audioUrl = "";
        
        try {
            // Get phonetics from dictionary API
            phonetic = getPhoneticsFromDictionary(word);
            System.out.println("DEBUG: AudioBO - Phonetic for '" + word + "': " + phonetic);
            
        } catch (Exception e) {
            System.err.println("Error getting phonetics for word: " + word + " - " + e.getMessage());
        }
        
        try {
            // Generate audio file
            audioUrl = generateAudioFile(word);
            System.out.println("DEBUG: AudioBO - Audio URL for '" + word + "': " + audioUrl);
            
        } catch (Exception e) {
            System.err.println("Error generating audio for word: " + word + " - " + e.getMessage());
        }
        
        return new AudioInfo(audioUrl, phonetic);
    }
    
    /**
     * Get phonetics from dictionary API
     */
    private String getPhoneticsFromDictionary(String word) {
        try {
            String encodedWord = URLEncoder.encode(word, "UTF-8");
            URL url = new URL(DICTIONARY_API_URL + encodedWord);
            
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setRequestProperty("Accept", "application/json");
            connection.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36");
            connection.setConnectTimeout(5000);
            connection.setReadTimeout(5000);
            
            int responseCode = connection.getResponseCode();
            System.out.println("DEBUG: AudioBO - Dictionary API response code: " + responseCode);
            
            if (responseCode == 200) {
                InputStream inputStream = connection.getInputStream();
                byte[] bytes = new byte[inputStream.available()];
                inputStream.read(bytes);
                String response = new String(bytes, StandardCharsets.UTF_8);
                inputStream.close();
                
                System.out.println("DEBUG: AudioBO - Dictionary API response: " + response.substring(0, Math.min(200, response.length())));
                
                // Parse JSON response to extract phonetic
                return parsePhoneticFromResponse(response);
                
            } else {
                System.err.println("Dictionary API returned error code: " + responseCode);
                // Try alternative API endpoint
                return getPhoneticsFromAlternativeAPI(word);
            }
            
        } catch (Exception e) {
            System.err.println("Error fetching phonetics from dictionary API: " + e.getMessage());
            // Try alternative API endpoint
            return getPhoneticsFromAlternativeAPI(word);
        }
    }
    
    /**
     * Try alternative API for phonetics
     */
    private String getPhoneticsFromAlternativeAPI(String word) {
        try {
            // Use a simpler approach - generate phonetic manually
            return generateSimplePhonetic(word);
        } catch (Exception e) {
            System.err.println("Error in alternative phonetic generation: " + e.getMessage());
            return "";
        }
    }
    
    /**
     * Generate simple phonetic representation
     */
    private String generateSimplePhonetic(String word) {
        // Simple phonetic generation based on common patterns
        String phonetic = word.toLowerCase();
        
        // Common phonetic patterns
        phonetic = phonetic.replaceAll("th", "θ");
        phonetic = phonetic.replaceAll("ch", "tʃ");
        phonetic = phonetic.replaceAll("sh", "ʃ");
        phonetic = phonetic.replaceAll("ph", "f");
        phonetic = phonetic.replaceAll("ck", "k");
        phonetic = phonetic.replaceAll("qu", "kw");
        
        // Add stress mark for first syllable
        if (phonetic.length() > 2) {
            phonetic = "ˈ" + phonetic;
        }
        
        return phonetic;
    }
    
    /**
     * Parse phonetic from dictionary API response
     */
    private String parsePhoneticFromResponse(String response) {
        try {
            // Simple regex to extract phonetic from JSON response
            // Look for "phonetic" field in the JSON
            Pattern pattern = Pattern.compile("\"phonetic\":\\s*\"([^\"]+)\"");
            Matcher matcher = pattern.matcher(response);
            
            if (matcher.find()) {
                return matcher.group(1);
            }
            
            // If no phonetic field, try to extract from phonetics array
            pattern = Pattern.compile("\"text\":\\s*\"([^\"]+)\"");
            matcher = pattern.matcher(response);
            
            if (matcher.find()) {
                return matcher.group(1);
            }
            
        } catch (Exception e) {
            System.err.println("Error parsing phonetic from response: " + e.getMessage());
        }
        
        return "";
    }
    
    /**
     * Generate audio file using Google TTS
     */
    private String generateAudioFile(String word) {
        try {
            // Build Google TTS URL
            String encodedWord = URLEncoder.encode(word, "UTF-8");
            String ttsUrl = GOOGLE_TTS_URL + "?ie=UTF-8&q=" + encodedWord + "&tl=en&client=tw-ob";
            
            System.out.println("DEBUG: AudioBO - Google TTS URL: " + ttsUrl);
            
            // Download audio file
            URL url = new URL(ttsUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setRequestProperty("User-Agent", "Mozilla/5.0");
            
            int responseCode = connection.getResponseCode();
            System.out.println("DEBUG: AudioBO - Google TTS response code: " + responseCode);
            
            if (responseCode == 200) {
                // Create filename with UUID hash like Python script
                String filename = UUID.randomUUID().toString().replace("-", "") + ".mp3";
                String filePath = AUDIO_FOLDER + File.separator + filename;
                
                System.out.println("DEBUG: AudioBO - Using filename: " + filename);
                System.out.println("DEBUG: AudioBO - Full file path: " + filePath);
                
                InputStream inputStream = connection.getInputStream();
                FileOutputStream outputStream = new FileOutputStream(filePath);
                
                byte[] buffer = new byte[1024];
                int bytesRead;
                int totalBytes = 0;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                    totalBytes += bytesRead;
                }
                
                inputStream.close();
                outputStream.close();
                
                System.out.println("DEBUG: AudioBO - Downloaded " + totalBytes + " bytes");
                System.out.println("DEBUG: AudioBO - Audio file generated: " + filePath);
                
                // Check if file actually exists
                File createdFile = new File(filePath);
                if (createdFile.exists()) {
                    System.out.println("DEBUG: AudioBO - File exists, size: " + createdFile.length() + " bytes");
                    // Return URL format that matches database (without leading slash)
                    return "audio/" + filename;
                } else {
                    System.err.println("DEBUG: AudioBO - File was not created!");
                    return "";
                }
                
            } else {
                System.err.println("Google TTS returned error code: " + responseCode);
            }
            
        } catch (Exception e) {
            System.err.println("Error generating audio file: " + e.getMessage());
            e.printStackTrace();
        }
        
        return "";
    }
    
    /**
     * Get filename from response headers or generate from word
     */
    private String getFilenameFromResponse(HttpURLConnection connection, String word) {
        try {
            // Try to get filename from Content-Disposition header
            String contentDisposition = connection.getHeaderField("Content-Disposition");
            if (contentDisposition != null && contentDisposition.contains("filename=")) {
                String filename = contentDisposition.split("filename=")[1].replaceAll("\"", "");
                if (filename.endsWith(".mp3")) {
                    return filename;
                }
            }
        } catch (Exception e) {
            System.err.println("Error parsing Content-Disposition: " + e.getMessage());
        }
        
        // Fallback: generate filename from word
        return word.toLowerCase().replaceAll("[^a-z0-9]", "_") + ".mp3";
    }
    
    /**
     * Inner class to hold audio information
     */
    public static class AudioInfo {
        private String audioUrl;
        private String phonetic;
        
        public AudioInfo(String audioUrl, String phonetic) {
            this.audioUrl = audioUrl;
            this.phonetic = phonetic;
        }
        
        public String getAudioUrl() {
            return audioUrl;
        }
        
        public String getPhonetic() {
            return phonetic;
        }
    }
} 