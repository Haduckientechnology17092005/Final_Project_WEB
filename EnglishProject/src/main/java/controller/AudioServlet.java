package controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/audio/*")
public class AudioServlet extends HttpServlet {
    
    private String audioFolder;
    
    @Override
    public void init() throws ServletException {
        System.out.println("DEBUG: AudioServlet - init() called - Servlet is being loaded");
        
        // Use absolute path to the audio folder
        audioFolder = "C:/Users/LAPTOP T&T/eclipse-workspace/EnglishProject/src/main/webapp/audio";
        System.out.println("DEBUG: AudioServlet - Audio folder: " + audioFolder);
        
        // Verify folder exists
        File folder = new File(audioFolder);
        if (!folder.exists()) {
            System.err.println("DEBUG: AudioServlet - Audio folder does not exist: " + audioFolder);
        } else {
            System.out.println("DEBUG: AudioServlet - Audio folder exists, contains " + folder.list().length + " files");
        }
        
        System.out.println("DEBUG: AudioServlet - init() completed successfully");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("DEBUG: AudioServlet - doGet called");
        System.out.println("DEBUG: AudioServlet - Request URL: " + request.getRequestURL());
        System.out.println("DEBUG: AudioServlet - Request URI: " + request.getRequestURI());
        
        // Get the audio file path from the URL
        String pathInfo = request.getPathInfo();
        System.out.println("DEBUG: AudioServlet - Path info: " + pathInfo);
        
        if (pathInfo == null || pathInfo.equals("/")) {
            System.err.println("DEBUG: AudioServlet - No audio file specified");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "No audio file specified");
            return;
        }
        
        // Remove leading slash and get filename
        String filename = pathInfo.substring(1);
        System.out.println("DEBUG: AudioServlet - Requested audio file: " + filename);
        
        // Validate filename to prevent directory traversal
        if (filename.contains("..") || filename.contains("/") || filename.contains("\\")) {
            System.err.println("DEBUG: AudioServlet - Invalid filename: " + filename);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid filename");
            return;
        }
        
        // Check if file exists
        File audioFile = new File(audioFolder, filename);
        System.out.println("DEBUG: AudioServlet - Looking for file: " + audioFile.getAbsolutePath());
        
        if (!audioFile.exists() || !audioFile.isFile()) {
            System.err.println("DEBUG: AudioServlet - File not found: " + audioFile.getAbsolutePath());
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Audio file not found");
            return;
        }
        
        System.out.println("DEBUG: AudioServlet - File exists, size: " + audioFile.length() + " bytes");
        System.out.println("DEBUG: AudioServlet - Serving file: " + audioFile.getAbsolutePath());
        
        // Set content type based on file extension
        String contentType = getContentType(filename);
        response.setContentType(contentType);
        System.out.println("DEBUG: AudioServlet - Content-Type: " + contentType);
        
        // Set cache headers
        response.setHeader("Cache-Control", "public, max-age=31536000"); // Cache for 1 year
        response.setHeader("Expires", "Thu, 31 Dec 2025 23:59:59 GMT");
        
        // Stream the file
        try (FileInputStream inputStream = new FileInputStream(audioFile);
             OutputStream outputStream = response.getOutputStream()) {
            
            byte[] buffer = new byte[1024];
            int bytesRead;
            int totalBytes = 0;
            while ((bytesRead = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
                totalBytes += bytesRead;
            }
            
            System.out.println("DEBUG: AudioServlet - File served successfully, " + totalBytes + " bytes sent");
            
        } catch (IOException e) {
            System.err.println("Error serving audio file: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error serving audio file");
        }
    }
    
    /**
     * Get content type based on file extension
     */
    private String getContentType(String filename) {
        String extension = filename.substring(filename.lastIndexOf('.') + 1).toLowerCase();
        
        switch (extension) {
            case "mp3":
                return "audio/mpeg";
            case "wav":
                return "audio/wav";
            case "ogg":
                return "audio/ogg";
            case "m4a":
                return "audio/mp4";
            default:
                return "audio/mpeg"; // Default to MP3
        }
    }
} 