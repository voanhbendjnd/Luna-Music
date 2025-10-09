package controllers;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import DALs.SongDAO;
import DALs.ArtistDAO;
import DALs.AlbumDAO;
import domain.entity.Song;
import domain.entity.Artist;
import domain.entity.Album;

/**
 * Test Controller for debugging database connection
 * 
 * @author Vo Anh Ben - CE190709
 */
public class TestController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<html><head><title>Database Test</title></head><body>");
        out.println("<h1>Database Connection Test</h1>");

        try {
            // Test SongDAO
            out.println("<h2>Testing SongDAO</h2>");
            SongDAO songDAO = new SongDAO();
            java.util.List<Song> songs = songDAO.findAll(null);
            out.println("<p>Songs found: " + (songs != null ? songs.size() : "null") + "</p>");

            if (songs != null && !songs.isEmpty()) {
                out.println("<ul>");
                for (Song song : songs) {
                    out.println("<li>" + song.getTitle() + " - " +
                            (song.getSongArtists() != null && !song.getSongArtists().isEmpty()
                                    ? song.getSongArtists().get(0).getArtist().getName()
                                    : "Unknown Artist")
                            + "</li>");
                }
                out.println("</ul>");
            }

            // Test ArtistDAO
            out.println("<h2>Testing ArtistDAO</h2>");
            ArtistDAO artistDAO = new ArtistDAO();
            java.util.List<Artist> artists = artistDAO.findAll();
            out.println("<p>Artists found: " + (artists != null ? artists.size() : "null") + "</p>");

            if (artists != null && !artists.isEmpty()) {
                out.println("<ul>");
                for (Artist artist : artists) {
                    out.println("<li>" + artist.getName() + "</li>");
                }
                out.println("</ul>");
            }

            // Test AlbumDAO
            out.println("<h2>Testing AlbumDAO</h2>");
            AlbumDAO albumDAO = new AlbumDAO();
            java.util.List<Album> albums = albumDAO.findAll();
            out.println("<p>Albums found: " + (albums != null ? albums.size() : "null") + "</p>");

            if (albums != null && !albums.isEmpty()) {
                out.println("<ul>");
                for (Album album : albums) {
                    out.println("<li>" + album.getTitle() + " - " +
                            (album.getArtist() != null ? album.getArtist().getName() : "Unknown Artist") + "</li>");
                }
                out.println("</ul>");
            }

        } catch (Exception e) {
            out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }

        out.println("</body></html>");
    }
}
