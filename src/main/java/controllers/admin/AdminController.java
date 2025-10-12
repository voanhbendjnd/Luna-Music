/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers.admin;

import java.io.IOException;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import DALs.UserDAO;
import DALs.SongDAO;
import DALs.ArtistDAO;
import DALs.AlbumDAO;
import DALs.GenreDAO;
import DALs.SongArtistDAO;
import DALs.RoleDAO;
import domain.entity.User;
import domain.entity.Song;
import domain.entity.Artist;
import domain.entity.Album;
import domain.entity.Genre;
import domain.entity.Role;
import constant.GenderEnum;

/**
 *
 * @author Vo Anh Ben - CE190709
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 50, // 50MB
        maxRequestSize = 1024 * 1024 * 100 // 100MB
)
public class AdminController extends HttpServlet {

    // File upload directories
    private static final String UPLOAD_DIR = "uploads";
    private static final String AUDIO_DIR = "music";
    private static final String IMAGE_DIR = "images";

    // Allowed file extensions
    private static final List<String> ALLOWED_AUDIO_EXTENSIONS = Arrays.asList("mp3", "m4a", "wav");
    private static final List<String> ALLOWED_IMAGE_EXTENSIONS = Arrays.asList("jpg", "jpeg", "png", "gif");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        if (action == null || action.isBlank() || action.equals("list")) {
            String type = request.getParameter("type");
            if (type == null || type.isBlank())
                type = "dashboard";
            if ("dashboard".equalsIgnoreCase(type)) {
                request.setAttribute("viewPath", "/views/admin/dashboard.jsp");
            } else if ("users".equalsIgnoreCase(type)) {
                String q = request.getParameter("q");
                var dao = new UserDAO();
                var roleDAO = new RoleDAO();
                var users = dao.findAll(q);
                var roles = roleDAO.findAll();
                request.setAttribute("users", users);
                request.setAttribute("roles", roles);
                request.setAttribute("q", q == null ? "" : q);
                request.setAttribute("viewPath", "/views/admin/user.jsp");
            } else if ("songs".equalsIgnoreCase(type)) {
                String q = request.getParameter("q");
                var songDAO = new SongDAO();
                var artistDAO = new ArtistDAO();
                var albumDAO = new AlbumDAO();
                var genreDAO = new GenreDAO();

                var songs = songDAO.findAll(q);
                var artists = artistDAO.findAll(null);
                var albums = albumDAO.findAll(null);
                var genres = genreDAO.findAll(null);

                request.setAttribute("songs", songs);
                request.setAttribute("artists", artists);
                request.setAttribute("albums", albums);
                request.setAttribute("genres", genres);
                request.setAttribute("q", q == null ? "" : q);
                request.setAttribute("viewPath", "/views/admin/song.jsp");
            } else if ("artists".equalsIgnoreCase(type)) {
                String q = request.getParameter("q");
                var artistDAO = new ArtistDAO();
                var artists = artistDAO.findAll(q);
                request.setAttribute("artists", artists);
                request.setAttribute("q", q == null ? "" : q);
                request.setAttribute("viewPath", "/views/admin/artist.jsp");
            } else if ("albums".equalsIgnoreCase(type)) {
                String q = request.getParameter("q");
                var albumDAO = new AlbumDAO();
                var artistDAO = new ArtistDAO();
                var albums = albumDAO.findAll(q);
                var artists = artistDAO.findAll(null);
                request.setAttribute("albums", albums);
                request.setAttribute("artists", artists);
                request.setAttribute("q", q == null ? "" : q);
                request.setAttribute("viewPath", "/views/admin/album.jsp");
            } else if ("genres".equalsIgnoreCase(type)) {
                String q = request.getParameter("q");
                var genreDAO = new GenreDAO();
                var genres = genreDAO.findAll(q);
                request.setAttribute("genres", genres);
                request.setAttribute("q", q == null ? "" : q);
                request.setAttribute("viewPath", "/views/admin/genre.jsp");
            } else {
                request.setAttribute("viewTitle", type);
                request.setAttribute("viewPath", "/views/admin/table/placeholder.jsp");
            }
            request.getRequestDispatcher("/views/admin/tables.jsp").forward(request, response);
            return;
        }
        if (action.equals("detail")) {
            var dao = new UserDAO();
            String idStr = request.getParameter("id");
            if (idStr != null) {
                var user = dao.findById(Long.parseLong(idStr));
                request.setAttribute("user", user);
            }
            request.setAttribute("viewPath", "/views/admin/user.jsp");
            request.getRequestDispatcher("/views/admin/tables.jsp").forward(request, response);
            return;
        }
        request.setAttribute("viewPath", "/views/admin/user.jsp");
        request.getRequestDispatcher("/views/admin/tables.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String type = request.getParameter("type");

        // Handle Song operations
        if ("songs".equalsIgnoreCase(type)) {
            handleSongOperationsUpdate(request, response, action);
            return;
        }

        // Handle Artist operations
        if ("artists".equalsIgnoreCase(type)) {
            handleArtistOperations(request, response, action);
            return;
        }

        // Handle Album operations
        if ("albums".equalsIgnoreCase(type)) {
            handleAlbumOperations(request, response, action);
            return;
        }

        // Handle Genre operations
        if ("genres".equalsIgnoreCase(type)) {
            handleGenreOperations(request, response, action);
            return;
        }

        // Handle User operations (existing code)
        var dao = new UserDAO();
        try {
            if ("create".equals(action)) {
                User u = buildUserFromRequest(request);

                // Check if email already exists
                User existingUser = dao.findByEmail(u.getEmail());
                if (existingUser != null) {
                    // Load users data and show error message on the same page
                    String q = request.getParameter("q");
                    var roleDAO = new RoleDAO();
                    var users = dao.findAll(q);
                    var roles = roleDAO.findAll();
                    request.setAttribute("users", users);
                    request.setAttribute("roles", roles);
                    request.setAttribute("q", q == null ? "" : q);
                    request.setAttribute("error", "Email already exists! Please use a different email.");
                    request.setAttribute("viewPath", "/views/admin/user.jsp");
                    request.getRequestDispatcher("/views/admin/tables.jsp").forward(request, response);
                    return;
                }

                boolean success = dao.create(u);
                if (success) {
                    request.setAttribute("success", "User created successfully!");
                    response.sendRedirect(request.getContextPath() + "/admin?action=list&type=users");
                } else {
                    // Load users data and show error message on the same page
                    String q = request.getParameter("q");
                    var roleDAO = new RoleDAO();
                    var users = dao.findAll(q);
                    var roles = roleDAO.findAll();
                    request.setAttribute("users", users);
                    request.setAttribute("roles", roles);
                    request.setAttribute("q", q == null ? "" : q);
                    request.setAttribute("error", "Failed to create user. Please try again.");
                    request.setAttribute("viewPath", "/views/admin/user.jsp");
                    request.getRequestDispatcher("/views/admin/tables.jsp").forward(request, response);
                }
                return;
            }
            if ("update".equals(action)) {
                User u = buildUserFromRequest(request);
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isBlank()) {
                    u.setId(Long.parseLong(idStr));

                    // Check if email already exists for another user
                    User existingUser = dao.findByEmail(u.getEmail());
                    if (existingUser != null && !existingUser.getId().equals(u.getId())) {
                        // Load users data and show error message on the same page
                        String q = request.getParameter("q");
                        var roleDAO = new RoleDAO();
                        var users = dao.findAll(q);
                        var roles = roleDAO.findAll();
                        request.setAttribute("users", users);
                        request.setAttribute("roles", roles);
                        request.setAttribute("q", q == null ? "" : q);
                        request.setAttribute("error", "Email already exists! Please use a different email.");
                        request.setAttribute("viewPath", "/views/admin/user.jsp");
                        request.getRequestDispatcher("/views/admin/tables.jsp").forward(request, response);
                        return;
                    }
                }

                boolean success = dao.update(u);
                if (success) {
                    request.setAttribute("success", "User updated successfully!");
                    response.sendRedirect(request.getContextPath() + "/admin?action=list&type=users");
                } else {
                    // Load users data and show error message on the same page
                    String q = request.getParameter("q");
                    var roleDAO = new RoleDAO();
                    var users = dao.findAll(q);
                    var roles = roleDAO.findAll();
                    request.setAttribute("users", users);
                    request.setAttribute("roles", roles);
                    request.setAttribute("q", q == null ? "" : q);
                    request.setAttribute("error", "Failed to update user. Please try again.");
                    request.setAttribute("viewPath", "/views/admin/user.jsp");
                    request.getRequestDispatcher("/views/admin/tables.jsp").forward(request, response);
                }
                return;
            }
            if ("delete".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isBlank())
                    dao.delete(Long.parseLong(idStr));
                response.sendRedirect(request.getContextPath() + "/admin?action=list&type=users");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Load users data and show error message on the same page
            String q = request.getParameter("q");
            var roleDAO = new RoleDAO();
            var users = dao.findAll(q);
            var roles = roleDAO.findAll();
            request.setAttribute("users", users);
            request.setAttribute("roles", roles);
            request.setAttribute("q", q == null ? "" : q);
            request.setAttribute("error", "Operation failed: " + e.getMessage());
            request.setAttribute("viewPath", "/views/admin/user.jsp");
            request.getRequestDispatcher("/views/admin/tables.jsp").forward(request, response);
        }
    }

    private User buildUserFromRequest(HttpServletRequest request) {
        User u = new User();
        u.setName(request.getParameter("name"));
        u.setEmail(request.getParameter("email"));
        u.setPassword(request.getParameter("password"));
        // u.setAvatar(request.getParameter("avatar"));
        u.setActive(
                "on".equals(request.getParameter("active")) || "true".equalsIgnoreCase(request.getParameter("active")));
        String gender = request.getParameter("gender");
        if (gender != null && !gender.isBlank()) {
            try {
                u.setGender(GenderEnum.valueOf(gender.toUpperCase()));
            } catch (Exception ignored) {
            }
        }

        // Handle role parameter
        String roleIdStr = request.getParameter("role");
        if (roleIdStr != null && !roleIdStr.isBlank()) {
            try {
                Long roleId = Long.parseLong(roleIdStr);
                Role role = new Role();
                role.setId(roleId);
                u.setRole(role);
            } catch (NumberFormatException ignored) {
            }
        }

        u.setCreatedBy("admin");
        u.setUpdatedBy("admin");
        return u;
    }

    /**
     * Handle Song CRUD operations
     */
    private void handleSongOperationsUpdate(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        var songDAO = new SongDAO();
        var songArtistDAO = new SongArtistDAO();

        try {
            if ("create".equals(action)) {
                Song song = buildSongFromRequest(request);
                if (songDAO.create(song)) {
                    // Handle artist relationships
                    String[] artistIds = request.getParameterValues("artistIds");
                    if (artistIds != null && artistIds.length > 0) {
                        List<Long> artistIdList = new ArrayList<>();
                        for (String artistId : artistIds) {
                            if (artistId != null && !artistId.trim().isEmpty()) {
                                artistIdList.add(Long.parseLong(artistId));
                            }
                        }
                        songArtistDAO.createMultiple(song.getId(), artistIdList);
                    }
                }
                response.sendRedirect(request.getContextPath() + "/admin?action=list&type=songs");

            } else if ("update".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isBlank()) {
                    Song song = buildSongFromRequest(request);
                    song.setId(Long.parseLong(idStr));
                    // find song
                    var currentSong = songDAO.findById(Long.parseLong(idStr));
                    if (currentSong != null) {
                        var checkAudio = false;
                        var checkImage = false;
                        // Handle file uploads
                        String audioFilePath = handleFileUpload(request, "audioFile", AUDIO_DIR,
                                ALLOWED_AUDIO_EXTENSIONS);
                        if (audioFilePath != null) {
                            checkAudio = true;
                            currentSong.setFilePath("/uploads/" + AUDIO_DIR + "/" + audioFilePath);
                        }
                        // Handle cover image upload (for song)
                        String coverImagePath = handleFileUpload(request, "coverImage", IMAGE_DIR,
                                ALLOWED_IMAGE_EXTENSIONS);
                        if (coverImagePath != null) {
                            checkImage = true;
                            currentSong.setCoverImage("/uploads/" + IMAGE_DIR + "/" + coverImagePath);
                        }
                        currentSong.setTitle(request.getParameter("title"));

                        // Handle duration
                        String durationStr = request.getParameter("duration");
                        if (durationStr != null && !durationStr.trim().isEmpty() && checkAudio) {
                            try {
                                currentSong.setDuration(Integer.parseInt(durationStr));
                            } catch (NumberFormatException e) {
                                // Keep duration as null if parsing fails
                            }
                        }

                        // Set default play count
                        song.setPlayCount(0);

                        // Handle album
                        String albumIdStr = request.getParameter("albumId");
                        if (albumIdStr != null && !albumIdStr.trim().isEmpty()) {
                            try {
                                var albumDAO = new AlbumDAO();
                                var album = albumDAO.findById(Long.parseLong(albumIdStr));
                                currentSong.setAlbum(album);
                            } catch (NumberFormatException e) {
                                // Keep album as null if parsing fails
                            }
                        }

                        // Handle genre
                        String genreIdStr = request.getParameter("genreId");
                        if (genreIdStr != null && !genreIdStr.trim().isEmpty()) {
                            try {
                                var genreDAO = new GenreDAO();
                                Genre genre = genreDAO.findById(Long.parseLong(genreIdStr));
                                currentSong.setGenre(genre);
                            } catch (NumberFormatException e) {
                                // Keep genre as null if parsing fails
                            }
                        }
                        var updateSuccess = false;
                        if (!checkImage && !checkAudio) {
                            updateSuccess = songDAO.updateNoAudioAndImage(currentSong);
                        } else if (checkAudio && !checkImage) {
                            updateSuccess = songDAO.updateNoImage(currentSong);
                        } else if (checkImage && !checkAudio) {
                            updateSuccess = songDAO.updateNoAudio(currentSong);
                        } else if (checkAudio && checkImage) {
                            updateSuccess = songDAO.update(currentSong);
                        }
                        if (updateSuccess) {
                            String[] artistIds = request.getParameterValues("artistIds");
                            List<Long> artistIdList = new ArrayList<>();
                            if (artistIds != null) {
                                for (String artistId : artistIds) {
                                    if (artistId != null && !artistId.trim().isEmpty()) {
                                        artistIdList.add(Long.parseLong(artistId));
                                    }
                                }
                            }
                            songArtistDAO.updateSongArtists(song.getId(), artistIdList);
                        }
                    }
                    //

                    // if (songDAO.update(song)) {
                    // // Update artist relationships
                    // String[] artistIds = request.getParameterValues("artistIds");
                    // List<Long> artistIdList = new ArrayList<>();
                    // if (artistIds != null) {
                    // for (String artistId : artistIds) {
                    // if (artistId != null && !artistId.trim().isEmpty()) {
                    // artistIdList.add(Long.parseLong(artistId));
                    // }
                    // }
                    // }
                    // songArtistDAO.updateSongArtists(song.getId(), artistIdList);
                    // }
                }
                response.sendRedirect(request.getContextPath() + "/admin?action=list&type=songs");

            } else if ("delete".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isBlank()) {
                    long songId = Long.parseLong(idStr);
                    // Delete song-artist relationships first
                    songArtistDAO.deleteBySongId(songId);
                    // Then delete the song
                    songDAO.delete(songId);
                }
                response.sendRedirect(request.getContextPath() + "/admin?action=list&type=songs");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin?action=list&type=songs&error=" +
                    java.net.URLEncoder.encode("Operation failed: " + e.getMessage(), "UTF-8"));
        }
    }

    /**
     * Handle Song CRUD operations
     */
    private void handleSongOperations(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        var songDAO = new SongDAO();
        var songArtistDAO = new SongArtistDAO();

        try {
            if ("create".equals(action)) {
                Song song = buildSongFromRequest(request);
                if (songDAO.create(song)) {
                    // Handle artist relationships
                    String[] artistIds = request.getParameterValues("artistIds");
                    if (artistIds != null && artistIds.length > 0) {
                        List<Long> artistIdList = new ArrayList<>();
                        for (String artistId : artistIds) {
                            if (artistId != null && !artistId.trim().isEmpty()) {
                                artistIdList.add(Long.parseLong(artistId));
                            }
                        }
                        songArtistDAO.createMultiple(song.getId(), artistIdList);
                    }
                }
                response.sendRedirect(request.getContextPath() + "/admin?action=list&type=songs");

            } else if ("update".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isBlank()) {
                    Song song = buildSongFromRequest(request);
                    song.setId(Long.parseLong(idStr));

                    if (songDAO.update(song)) {
                        // Update artist relationships
                        String[] artistIds = request.getParameterValues("artistIds");
                        List<Long> artistIdList = new ArrayList<>();
                        if (artistIds != null) {
                            for (String artistId : artistIds) {
                                if (artistId != null && !artistId.trim().isEmpty()) {
                                    artistIdList.add(Long.parseLong(artistId));
                                }
                            }
                        }
                        songArtistDAO.updateSongArtists(song.getId(), artistIdList);
                    }
                }
                response.sendRedirect(request.getContextPath() + "/admin?action=list&type=songs");

            } else if ("delete".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isBlank()) {
                    long songId = Long.parseLong(idStr);
                    // Delete song-artist relationships first
                    songArtistDAO.deleteBySongId(songId);
                    // Then delete the song
                    songDAO.delete(songId);
                }
                response.sendRedirect(request.getContextPath() + "/admin?action=list&type=songs");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin?action=list&type=songs&error=" +
                    java.net.URLEncoder.encode("Operation failed: " + e.getMessage(), "UTF-8"));
        }
    }

    /**
     * Build Song object from request parameters and uploaded files
     */
    private Song buildSongFromRequest(HttpServletRequest request) throws IOException, ServletException {
        Song song = new Song();
        song.setTitle(request.getParameter("title"));

        // Handle duration
        String durationStr = request.getParameter("duration");
        if (durationStr != null && !durationStr.trim().isEmpty()) {
            try {
                song.setDuration(Integer.parseInt(durationStr));
            } catch (NumberFormatException e) {
                // Keep duration as null if parsing fails
            }
        }

        // Set default play count
        song.setPlayCount(0);

        // Handle album
        String albumIdStr = request.getParameter("albumId");
        if (albumIdStr != null && !albumIdStr.trim().isEmpty()) {
            try {
                Album album = new Album();
                album.setId(Long.parseLong(albumIdStr));
                song.setAlbum(album);
            } catch (NumberFormatException e) {
                // Keep album as null if parsing fails
            }
        }

        // Handle genre
        String genreIdStr = request.getParameter("genreId");
        if (genreIdStr != null && !genreIdStr.trim().isEmpty()) {
            try {
                Genre genre = new Genre();
                genre.setId(Long.parseLong(genreIdStr));
                song.setGenre(genre);
            } catch (NumberFormatException e) {
                // Keep genre as null if parsing fails
            }
        }

        // Handle file uploads
        String audioFilePath = handleFileUpload(request, "audioFile", AUDIO_DIR, ALLOWED_AUDIO_EXTENSIONS);
        if (audioFilePath != null) {
            song.setFilePath("/uploads/" + AUDIO_DIR + "/" + audioFilePath);
        }

        // Handle cover image upload (for song)
        String coverImagePath = handleFileUpload(request, "coverImage", IMAGE_DIR, ALLOWED_IMAGE_EXTENSIONS);
        if (coverImagePath != null) {
            song.setCoverImage("/uploads/" + IMAGE_DIR + "/" + coverImagePath);
        }

        return song;
    }

    /**
     * Handle file upload and return the saved filename
     */
    private String handleFileUpload(HttpServletRequest request, String partName, String subDir,
            List<String> allowedExtensions) throws IOException, ServletException {
        Part filePart = request.getPart(partName);
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        String fileName = getFileName(filePart);
        if (fileName == null || fileName.isEmpty()) {
            return null;
        }

        // Validate file extension
        String fileExtension = getFileExtension(fileName);
        if (!allowedExtensions.contains(fileExtension.toLowerCase())) {
            throw new ServletException("Invalid file type. Allowed: " + allowedExtensions);
        }

        // Create upload directory if it doesn't exist
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR + File.separator + subDir;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // Generate unique filename
        String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
        Path filePath = Paths.get(uploadPath + File.separator + uniqueFileName);

        // Save file
        Files.copy(filePart.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return uniqueFileName;
    }

    /**
     * Extract filename from Part
     */
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return null;
    }

    /**
     * Get file extension from filename
     */
    private String getFileExtension(String fileName) {
        if (fileName == null || fileName.isEmpty()) {
            return "";
        }
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex == -1 || lastDotIndex == fileName.length() - 1) {
            return "";
        }
        return fileName.substring(lastDotIndex + 1);
    }

    /**
     * Handle Artist CRUD operations
     */
    private void handleArtistOperations(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        var artistDAO = new ArtistDAO();

        try {
            if ("create".equals(action)) {
                Artist artist = buildArtistFromRequest(request);
                artistDAO.create(artist);
                response.sendRedirect(request.getContextPath() + "/admin?action=list&type=artists");

            } else if ("update".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isBlank()) {
                    Artist artist = buildArtistFromRequest(request);
                    artist.setId(Long.parseLong(idStr));
                    artistDAO.update(artist);
                }
                response.sendRedirect(request.getContextPath() + "/admin?action=list&type=artists");

            } else if ("delete".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isBlank()) {
                    artistDAO.delete(Long.parseLong(idStr));
                }
                response.sendRedirect(request.getContextPath() + "/admin?action=list&type=artists");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin?action=list&type=artists&error=" +
                    java.net.URLEncoder.encode("Operation failed: " + e.getMessage(), "UTF-8"));
        }
    }

    /**
     * Handle Album CRUD operations
     */
    private void handleAlbumOperations(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        var albumDAO = new AlbumDAO();

        try {
            if ("create".equals(action)) {
                Album album = buildAlbumFromRequest(request);
                albumDAO.create(album);
                response.sendRedirect(request.getContextPath() + "/admin?action=list&type=albums");

            } else if ("update".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isBlank()) {
                    Album album = buildAlbumFromRequest(request);
                    album.setId(Long.parseLong(idStr));
                    albumDAO.update(album);
                }
                response.sendRedirect(request.getContextPath() + "/admin?action=list&type=albums");

            } else if ("delete".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isBlank()) {
                    albumDAO.delete(Long.parseLong(idStr));
                }
                response.sendRedirect(request.getContextPath() + "/admin?action=list&type=albums");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin?action=list&type=albums&error=" +
                    java.net.URLEncoder.encode("Operation failed: " + e.getMessage(), "UTF-8"));
        }
    }

    /**
     * Handle Genre CRUD operations
     */
    private void handleGenreOperations(HttpServletRequest request, HttpServletResponse response, String action)
            throws ServletException, IOException {
        var genreDAO = new GenreDAO();

        try {
            if ("create".equals(action)) {
                Genre genre = buildGenreFromRequest(request);
                genreDAO.create(genre);
                response.sendRedirect(request.getContextPath() + "/admin?action=list&type=genres");

            } else if ("update".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isBlank()) {
                    Genre genre = buildGenreFromRequest(request);
                    genre.setId(Long.parseLong(idStr));
                    genreDAO.update(genre);
                }
                response.sendRedirect(request.getContextPath() + "/admin?action=list&type=genres");

            } else if ("delete".equals(action)) {
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.isBlank()) {
                    genreDAO.delete(Long.parseLong(idStr));
                }
                response.sendRedirect(request.getContextPath() + "/admin?action=list&type=genres");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin?action=list&type=genres&error=" +
                    java.net.URLEncoder.encode("Operation failed: " + e.getMessage(), "UTF-8"));
        }
    }

    /**
     * Build Artist object from request parameters and uploaded files
     */
    private Artist buildArtistFromRequest(HttpServletRequest request) throws IOException, ServletException {
        Artist artist = new Artist();
        artist.setName(request.getParameter("name"));
        artist.setBio(request.getParameter("bio"));

        // Handle image upload
        String imagePath = handleFileUpload(request, "imageFile", IMAGE_DIR, ALLOWED_IMAGE_EXTENSIONS);
        if (imagePath != null) {
            artist.setImagePath("/uploads/" + IMAGE_DIR + "/" + imagePath);
        }

        return artist;
    }

    /**
     * Build Album object from request parameters and uploaded files
     */
    private Album buildAlbumFromRequest(HttpServletRequest request) throws IOException, ServletException {
        Album album = new Album();
        album.setTitle(request.getParameter("title"));

        // Handle release year
        String releaseYearStr = request.getParameter("releaseYear");
        if (releaseYearStr != null && !releaseYearStr.trim().isEmpty()) {
            try {
                album.setReleaseYear(Integer.parseInt(releaseYearStr));
            } catch (NumberFormatException e) {
                // Keep release year as null if parsing fails
            }
        }

        // Handle artist
        String artistIdStr = request.getParameter("artistId");
        if (artistIdStr != null && !artistIdStr.trim().isEmpty()) {
            try {
                Artist artist = new Artist();
                artist.setId(Long.parseLong(artistIdStr));
                album.setArtist(artist);
            } catch (NumberFormatException e) {
                // Keep artist as null if parsing fails
            }
        }

        // Handle cover image upload
        String coverImagePath = handleFileUpload(request, "coverImage", IMAGE_DIR, ALLOWED_IMAGE_EXTENSIONS);
        if (coverImagePath != null) {
            album.setCoverImagePath("/uploads/" + IMAGE_DIR + "/" + coverImagePath);
        }

        return album;
    }

    /**
     * Build Genre object from request parameters
     */
    private Genre buildGenreFromRequest(HttpServletRequest request) {
        Genre genre = new Genre();
        genre.setName(request.getParameter("name"));
        genre.setDescription(request.getParameter("description"));
        return genre;
    }

}
