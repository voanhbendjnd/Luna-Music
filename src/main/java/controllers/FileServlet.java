/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import java.io.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet to serve files from the fixed upload directory
 * 
 * @author Vo Anh Ben - CE190709
 */
public class FileServlet extends HttpServlet {

    // Base upload path - same as in AdminController
    private static final String BASE_UPLOAD_PATH = "C:\\Users\\PC\\Documents\\FALL25\\upload";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the file path from the request ex: /uploads/music/filename.mp3
        String requestPath = request.getPathInfo();
        if (requestPath == null || requestPath.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Remove leading slash and build full file path
        String filePath = requestPath.substring(1); // Remove leading '/' ex: uploads/music/filename.mp3
        File file = new File(BASE_UPLOAD_PATH, filePath);

        // Check if file exists ex:
        // C:\Users\PC\Documents\FALL25/upload\music\filename.mp3
        if (!file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Security check - ensure the file is within the upload directory ex:
        // C:\Users\PC\Documents\FALL25/upload\music\filename.mp3
        try {
            String canonicalFilePath = file.getCanonicalPath();
            String canonicalBasePath = new File(BASE_UPLOAD_PATH).getCanonicalPath();
            if (!canonicalFilePath.startsWith(canonicalBasePath)) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        } catch (IOException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return;
        }

        // Determine content type based on file extension ex: audio/mpeg
        String contentType = getContentType(file.getName());
        response.setContentType(contentType);

        // Set content length ex: 1000
        response.setContentLengthLong(file.length());

        // Set cache headers for better performance ex: public, max-age=3600
        response.setHeader("Cache-Control", "public, max-age=3600"); // Cache for 1 hour

        // Stream the file to the response ex: 1000 bytes
        try (FileInputStream fis = new FileInputStream(file);
                BufferedInputStream bis = new BufferedInputStream(fis);
                OutputStream out = response.getOutputStream()) {

            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = bis.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
            out.flush();
        } catch (IOException e) {
            // Log the error (you might want to use a proper logging framework) ex: Error
            // serving file: C:\Users\PC\Documents\FALL25/upload\music\filename.mp3, Error:
            // java.io.IOException
            System.err.println("Error serving file: " + file.getAbsolutePath() + ", Error: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Determine content type based on file extension ex: audio/mpeg
     */
    private String getContentType(String fileName) {
        String extension = fileName.toLowerCase();
        // mp3, m4a, wav, jpg, jpeg, png, gif
        if (extension.endsWith(".mp3")) {
            return "audio/mpeg";
        } else if (extension.endsWith(".m4a")) {
            return "audio/mp4";
        } else if (extension.endsWith(".wav")) {
            return "audio/wav";
        } else if (extension.endsWith(".jpg") || extension.endsWith(".jpeg")) {
            return "image/jpeg";
        } else if (extension.endsWith(".png")) {
            return "image/png";
        } else if (extension.endsWith(".gif")) {
            return "image/gif";
        } else {
            // default to application/octet-stream
            return "application/octet-stream";
        }
    }
}
