package controllers;

import DALs.PlaylistDAO;
import DALs.SongDAO;
import domain.entity.Playlist;
import domain.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SearchController", urlPatterns = { "/search" })
public class SearchController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy dữ liệu từ request
        String query = request.getParameter("q");
        String type = request.getParameter("type");
        var songDAO = new SongDAO();
        var res = songDAO.searchAtHome(query);
        var songs = res.getSongs();
        var albums = res.getAlbums();
        var artists = res.getArtists();
        request.setAttribute("songs", songs);
        request.setAttribute("albums", albums);
        request.setAttribute("artists", artists);
        request.setAttribute("popularSong", songs);
        var session = request.getSession(false);
        User currentUser = (User)session.getAttribute("user");
        // Get user playlists if user is logged in
        if (currentUser != null) {
            var playlistDAO = new PlaylistDAO();
            List<Playlist> userPlaylists = playlistDAO.getPlaylistsByUserId(currentUser.getId());
            if (userPlaylists == null) {
                userPlaylists = List.of();
            }
            request.setAttribute("userPlaylists", userPlaylists);
        } else {
            request.setAttribute("userPlaylists", List.of());
        }
        // Set session
        session.setAttribute("search", query);
        System.out.println("=== SEARCH REQUEST ===");
        System.out.println("Query: " + query);
        System.out.println("Type: " + type);
        System.out.println("=====================");

        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("/views/layouts/defaultLayout.jsp").forward(request, response);

    }
}