package controllers;

import DALs.PlaylistDAO;
import DALs.SongDAO;
import domain.entity.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

//@WebServlet(name = "SearchController", urlPatterns = { "/search" })
public class SearchController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        var songDAO = new SongDAO();
        String query = request.getParameter("q");
        String genre = request.getParameter("genre");
        if(genre != null){
            var res = songDAO.filterSongByGenre(genre);
            var songs = res.getSongs();
            var albums = res.getAlbums();
            var artists = res.getArtists();
            this.getResultSong(request, response, genre, songs, albums, artists);
            return;
        }
        if(query != null){
            var res = songDAO.searchAtHome(query);
            var songs = res.getSongs();
            var albums = res.getAlbums();
            var artists = res.getArtists();
            this.getResultSong(request, response, query, songs, albums, artists);
            return;
        }


    }
    public void getResultSong(HttpServletRequest request, HttpServletResponse response, String search, List<Song> songs, List<Album> albums, List<Artist> artists)
            throws ServletException, IOException {
        if(songs != null && !songs.isEmpty()){
            request.setAttribute("songs", songs);

        }
        if(albums != null && !albums.isEmpty()){
            request.setAttribute("albums", albums);

        }
        if(artists != null && !artists.isEmpty()){
            request.setAttribute("artists", artists);

        }

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
        session.setAttribute("search", search);
        System.out.println("=== SEARCH REQUEST ===");
        System.out.println("Query: " + search);
        System.out.println("=====================");

        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("/views/layouts/defaultLayout.jsp").forward(request, response);
    }

}