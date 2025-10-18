package controllers;

import DALs.PlaylistDAO;
import DALs.SongDAO;
import DALs.UserDAO;
import domain.entity.Playlist;
import domain.entity.PlaylistSong;
import domain.entity.Song;
import domain.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 50, // 50MB
        maxRequestSize = 1024 * 1024 * 100 // 100MB
)
@WebServlet(name = "PlaylistController", urlPatterns = { "/playlist", "/playlist/*" })
public class PlaylistController extends HttpServlet {
    private PlaylistDAO playlistDAO;
    private SongDAO songDAO;
    private UserDAO userDAO;

    // File upload directories - Fixed paths on local machine
    private static final String BASE_UPLOAD_PATH = "C:\\Users\\PC\\Documents\\FALL25\\upload";
    private static final String AUDIO_DIR = "music";
    private static final String IMAGE_DIR = "images";

    @Override
    public void init() throws ServletException {
        playlistDAO = new PlaylistDAO();
        songDAO = new SongDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");

        // Debug logging
        System.out.println("PlaylistController doGet - pathInfo: " + pathInfo);
        System.out.println("PlaylistController doGet - action: " + action);
        System.out.println("PlaylistController doGet - requestURI: " + request.getRequestURI());

        if (pathInfo == null || pathInfo.equals("/")) {
            // Show playlist list, create new playlist, or show detail
            if ("create".equals(action)) {
                showCreatePlaylistForm(request, response);
            } else {
                // Check if there's an id parameter for detail view
                String playlistId = request.getParameter("id");
                if (playlistId != null && !playlistId.isEmpty()) {
                    showPlaylistDetail(request, response, Long.parseLong(playlistId));
                } else {
                    showPlaylistList(request, response);
                }
            }
        } else if (pathInfo.startsWith("/detail")) {
            // Show playlist detail
            String playlistId = request.getParameter("id");
            if (playlistId != null) {
                showPlaylistDetail(request, response, Long.parseLong(playlistId));
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Playlist ID is required");
            }
        } else if (pathInfo.startsWith("/edit")) {
            // Show edit playlist form
            String playlistId = request.getParameter("id");
            if (playlistId != null) {
                showEditPlaylistForm(request, response, Long.parseLong(playlistId));
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Playlist ID is required");
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
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
     * Handle file upload and return the saved filename
     * partName ex: audioFile, coverImage
     * subDir ex: music, images
     * allowedExtensions ex: mp3, m4a, wav, jpg, jpeg, png, gif
     */
    private String handleFileUpload(HttpServletRequest request, String partName, String subDir,
            List<String> allowedExtensions) throws IOException, ServletException {
        // get file part ex: audioFile, coverImage
        Part filePart = request.getPart(partName);
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        // get file name ex: filename.mp3, filename.jpg
        String fileName = getFileName(filePart);
        if (fileName == null || fileName.isEmpty()) {
            return null;
        }

        // Validate file extension ex: mp3, jpg
        String fileExtension = getFileExtension(fileName);
        if (!allowedExtensions.contains(fileExtension.toLowerCase())) {
            throw new ServletException("Invalid file type. Allowed: " + allowedExtensions);
        }

        // Create upload directory if it doesn't exist - using fixed local path ex:
        // C:/Users/PC/Documents/FALL25/upload/music
        Path uploadDir = Paths.get(BASE_UPLOAD_PATH, subDir);
        Files.createDirectories(uploadDir);

        // Generate unique filename ex: 1734105600000_filename.mp3
        String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
        Path filePath = uploadDir.resolve(uniqueFileName);

        // Save file ex:
        // C:\Users\PC\Documents\FALL25/upload\music\1734105600000_filename.mp3
        Files.copy(filePart.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return uniqueFileName;
    }

    private static final List<String> ALLOWED_IMAGE_EXTENSIONS = Arrays.asList("jpg", "jpeg", "png", "gif");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createPlaylist(request, response);
        } else if ("update".equals(action)) {
            updatePlaylist(request, response);
        } else if ("updateCover".equals(action)) {
            updatePlaylistCover(request, response);
        } else if ("delete".equals(action)) {
            deletePlaylist(request, response);
        } else if ("addSong".equals(action)) {
            addSongToPlaylist(request, response);
        } else if ("removeSong".equals(action)) {
            removeSongFromPlaylist(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private void showPlaylistList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            User currentUser = null;
            if (session != null) {
                currentUser = (User) session.getAttribute("user");
            }

            List<Playlist> userPlaylists = new ArrayList<>();
            List<Playlist> publicPlaylists = new ArrayList<>();

            if (currentUser != null) {
                // Get user's own playlists
                userPlaylists = playlistDAO.getPlaylistsByUserId(currentUser.getId());
                if (userPlaylists == null) {
                    userPlaylists = new ArrayList<>();
                }
            }

            // Get public playlists (excluding current user's playlists if logged in)
            if (currentUser != null) {
                publicPlaylists = playlistDAO.getPublicPlaylistsExcludingUser(currentUser.getId());
            } else {
                publicPlaylists = playlistDAO.getPublicPlaylists();
            }
            if (publicPlaylists == null) {
                publicPlaylists = new ArrayList<>();
            }

            // Combine playlists for display
            List<Playlist> allPlaylists = new ArrayList<>();
            allPlaylists.addAll(userPlaylists);
            allPlaylists.addAll(publicPlaylists);

            request.setAttribute("userPlaylists", userPlaylists);
            request.setAttribute("publicPlaylists", publicPlaylists);
            request.setAttribute("playlists", allPlaylists);
            request.setAttribute("currentUser", currentUser);
            request.getRequestDispatcher("/views/playlist-list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void showCreatePlaylistForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            User currentUser = null;
            if (session != null) {
                currentUser = (User) session.getAttribute("user");
            }

            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            request.setAttribute("currentUser", currentUser);
            request.getRequestDispatcher("/views/playlist-create.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void showPlaylistDetail(HttpServletRequest request, HttpServletResponse response, Long playlistId)
            throws ServletException, IOException {
        try {
            Playlist playlist = playlistDAO.getPlaylistById(playlistId);

            if (playlist == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Playlist not found");
                return;
            }

            // Get songs in playlist
            List<Song> playlistSongs = playlistDAO.getSongsInPlaylist(playlistId);

            // Get all songs for search functionality
            List<Song> allSongs = songDAO.findAll(null);

            // Create PlaylistSong objects for the view
            List<PlaylistSong> playlistSongList = new ArrayList<>();
            for (Song song : playlistSongs) {
                PlaylistSong playlistSong = new PlaylistSong();
                playlistSong.setSong(song);
                playlistSong.setPlaylist(playlist);
                playlistSongList.add(playlistSong);
            }
            playlist.setPlaylistSongs(playlistSongList);

            request.setAttribute("playlist", playlist);
            request.setAttribute("allSongs", allSongs);
            request.getRequestDispatcher("/views/playlist-detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void showEditPlaylistForm(HttpServletRequest request, HttpServletResponse response, Long playlistId)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            User currentUser = null;
            if (session != null) {
                currentUser = (User) session.getAttribute("user");
            }

            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Playlist playlist = playlistDAO.getPlaylistById(playlistId);

            if (playlist == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Playlist not found");
                return;
            }

            // Check if user owns this playlist
            if (playlist.getUser().getId() != currentUser.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "You don't have permission to edit this playlist");
                return;
            }

            request.setAttribute("playlist", playlist);
            request.setAttribute("currentUser", currentUser);
            request.getRequestDispatcher("/views/playlist-edit.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void createPlaylist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            User currentUser = null;
            if (session != null) {
                currentUser = (User) session.getAttribute("user");
            }

            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String name = request.getParameter("name");
            String description = request.getParameter("description");

            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Playlist name is required");
                showCreatePlaylistForm(request, response);
                return;
            }

            Playlist playlist = new Playlist(name.trim(), currentUser);
            playlist.setDescription(description);
            Playlist createdPlaylist = playlistDAO.createPlaylist(playlist);

            if (createdPlaylist != null) {
                response.sendRedirect(request.getContextPath() + "/playlist/detail?id=" + createdPlaylist.getId());
            } else {
                request.setAttribute("error", "Failed to create playlist");
                showCreatePlaylistForm(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void updatePlaylist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            User currentUser = null;
            if (session != null) {
                currentUser = (User) session.getAttribute("user");
            }

            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Long playlistId = Long.parseLong(request.getParameter("id"));
            String name = request.getParameter("name");
            String description = request.getParameter("description");

            Playlist playlist = playlistDAO.getPlaylistById(playlistId);

            if (playlist == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Playlist not found");
                return;
            }

            // Check if user owns this playlist
            if (playlist.getUser().getId() != currentUser.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "You don't have permission to edit this playlist");
                return;
            }

            playlist.setName(name);
            playlist.setDescription(description);

            Playlist updatedPlaylist = playlistDAO.updatePlaylist(playlist);

            if (updatedPlaylist != null) {
                response.sendRedirect(request.getContextPath() + "/playlist/detail?id=" + updatedPlaylist.getId());
            } else {
                request.setAttribute("error", "Failed to update playlist");
                showEditPlaylistForm(request, response, playlistId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void deletePlaylist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            User currentUser = null;
            if (session != null) {
                currentUser = (User) session.getAttribute("user");
            }

            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Long playlistId = Long.parseLong(request.getParameter("id"));

            Playlist playlist = playlistDAO.getPlaylistById(playlistId);

            if (playlist == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Playlist not found");
                return;
            }

            // Check if user owns this playlist
            if (playlist.getUser().getId() != currentUser.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "You don't have permission to delete this playlist");
                return;
            }

            boolean deleted = playlistDAO.deletePlaylist(playlistId);

            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/playlist");
            } else {
                request.setAttribute("error", "Failed to delete playlist");
                showPlaylistDetail(request, response, playlistId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void addSongToPlaylist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            User currentUser = null;
            if (session != null) {
                currentUser = (User) session.getAttribute("user");
            }

            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Long playlistId = Long.parseLong(request.getParameter("playlistId"));
            Long songId = Long.parseLong(request.getParameter("songId"));

            Playlist playlist = playlistDAO.getPlaylistById(playlistId);

            if (playlist == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Playlist not found");
                return;
            }

            // Check if user owns this playlist
            if (playlist.getUser().getId() != currentUser.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "You don't have permission to modify this playlist");
                return;
            }

            boolean added = playlistDAO.addSongToPlaylist(playlistId, songId);

            if (added) {
                response.sendRedirect(request.getContextPath() + "/playlist/detail?id=" + playlistId);
            } else {
                request.setAttribute("error", "Failed to add song to playlist (song might already exist)");
                showPlaylistDetail(request, response, playlistId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void removeSongFromPlaylist(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            User currentUser = null;
            if (session != null) {
                currentUser = (User) session.getAttribute("user");
            }

            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Long playlistId = Long.parseLong(request.getParameter("playlistId"));
            Long songId = Long.parseLong(request.getParameter("songId"));

            Playlist playlist = playlistDAO.getPlaylistById(playlistId);

            if (playlist == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Playlist not found");
                return;
            }

            // Check if user owns this playlist
            if (playlist.getUser().getId() != currentUser.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "You don't have permission to modify this playlist");
                return;
            }

            boolean removed = playlistDAO.removeSongFromPlaylist(playlistId, songId);

            if (removed) {
                response.sendRedirect(request.getContextPath() + "/playlist/detail?id=" + playlistId);
            } else {
                request.setAttribute("error", "Failed to remove song from playlist");
                showPlaylistDetail(request, response, playlistId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void updatePlaylistCover(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            User currentUser = null;
            if (session != null) {
                currentUser = (User) session.getAttribute("user");
            }

            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Long playlistId = Long.parseLong(request.getParameter("playlistId"));
            Playlist playlist = playlistDAO.getPlaylistById(playlistId);

            if (playlist == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Playlist not found");
                return;
            }

            // Check if user owns this playlist
            if (playlist.getUser().getId() != currentUser.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN,
                        "You don't have permission to modify this playlist");
                return;
            }

            // Handle cover image upload
            String coverImage = handleFileUpload(request, "coverImage", IMAGE_DIR, ALLOWED_IMAGE_EXTENSIONS);
            if (coverImage != null) {
                String coverImagePath = "/uploads/" + IMAGE_DIR + "/" + coverImage;
                boolean updated = playlistDAO.updateCoverImage(coverImagePath, playlist.getId());

                if (updated) {
                    response.sendRedirect(request.getContextPath() + "/playlist/detail?id=" + playlistId);
                } else {
                    request.setAttribute("error", "Failed to update playlist cover");
                    showPlaylistDetail(request, response, playlistId);
                }
            } else {
                request.setAttribute("error", "No image file provided");
                showPlaylistDetail(request, response, playlistId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public void destroy() {
        // Note: All DAOs extend DatabaseConfig and will be garbage collected
        // automatically
        // No need to explicitly close connections as they are managed by the parent
        // class
    }
}
