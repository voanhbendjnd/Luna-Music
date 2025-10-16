package controllers;

import DALs.PlaylistDAO;
import DALs.SongDAO;
import DALs.UserDAO;
import domain.entity.Playlist;
import domain.entity.PlaylistSong;
import domain.entity.Song;
import domain.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "PlaylistController", urlPatterns = { "/playlist", "/playlist/*" })
public class PlaylistController extends HttpServlet {
    private PlaylistDAO playlistDAO;
    private SongDAO songDAO;
    private UserDAO userDAO;

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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            createPlaylist(request, response);
        } else if ("update".equals(action)) {
            updatePlaylist(request, response);
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
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");

            List<Playlist> playlists;
            if (currentUser != null) {
                // Show user's playlists
                playlists = playlistDAO.getPlaylistsByUserId(currentUser.getId());
            } else {
                // Show public playlists
                playlists = playlistDAO.getPublicPlaylists();
            }

            // If no playlists exist, create demo playlists
            if (playlists == null || playlists.isEmpty()) {
                createDemoPlaylists();
                playlists = playlistDAO.getPublicPlaylists();
            }

            request.setAttribute("playlists", playlists);
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
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");

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
                // If playlist doesn't exist, create demo playlists
                createDemoPlaylists();
                playlist = playlistDAO.getPlaylistById(playlistId);

                if (playlist == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Playlist not found");
                    return;
                }
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
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");

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
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");

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

            Playlist playlist = new Playlist(name.trim(), description, currentUser);
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
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");

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
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");

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
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");

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
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");

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

    /**
     * Create demo playlists for testing
     */
    private void createDemoPlaylists() {
        try {
            // Create demo user first
            User demoUser = new User();
            demoUser.setId(1L);
            demoUser.setName("Demo User");
            demoUser.setEmail("demo@example.com");

            // Create demo playlists
            Playlist playlist1 = new Playlist("My Playlist #1", "Demo playlist 1", demoUser);
            Playlist playlist2 = new Playlist("My Playlist #2", "Demo playlist 2", demoUser);

            playlistDAO.createPlaylist(playlist1);
            playlistDAO.createPlaylist(playlist2);

            System.out.println("Demo playlists created successfully");
        } catch (Exception e) {
            System.err.println("Error creating demo playlists: " + e.getMessage());
            e.printStackTrace();
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
