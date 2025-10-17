package controllers;

import java.io.IOException;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import DALs.SongDAO;
import DALs.ArtistDAO;
import DALs.AlbumDAO;
import domain.entity.Song;
import domain.entity.Artist;
import domain.entity.Album;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Home Controller for Luna Music
 * 
 * @author Vo Anh Ben - CE190709
 */
public class HomeController extends HttpServlet {

    public List<Song> getPopularSongs(List<Song> songs){
       return songs.stream().sorted(Comparator.comparing(Song::getPlayCount).reversed()).toList();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            // Get popular songs (limit to 20)
            var songDAO = new SongDAO();
            List<Song> songs = songDAO.findAll(null);
            if (songs.size() > 20) {
                songs = songs.subList(0, 20);
            }
            request.setAttribute("songs", songs);
            var popularSongs = this.getPopularSongs(songs);
            if(popularSongs != null && popularSongs.size() > 10){
                popularSongs =popularSongs.subList(0,10);
            }
            request.setAttribute("popularSong", popularSongs);


            // Get featured artists (limit to 10)
            var artistDAO = new ArtistDAO();
            List<Artist> artists = artistDAO.findAll(null);
            if (artists.size() > 10) {
                artists = artists.subList(0, 10);
            }
            request.setAttribute("artists", artists);

            // Get featured albums (limit to 15)
            var albumDAO = new AlbumDAO();
            List<Album> albums = albumDAO.findAll(null);
            if (albums.size() > 15) {
                albums = albums.subList(0, 15);
            }
            request.setAttribute("albums", albums);

        } catch (Exception e) {
            System.err.println("Error loading home data: " + e.getMessage());
            e.printStackTrace();
            // Set empty lists if there's an error
            request.setAttribute("songs", List.of());
            request.setAttribute("artists", List.of());
            request.setAttribute("albums", List.of());
        }

        // Forward to home.jsp directly
        request.getRequestDispatcher("/views/layouts/defaultLayout.jsp").forward(request, response);
    }
}
