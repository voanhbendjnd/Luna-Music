package controllers;

import java.io.IOException;
import java.util.List;
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
 *
 * @author Vo Anh Ben - CE190709
 */
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            // Get data for home page
            System.out.println("Starting to load home page data...");
            SongDAO songDAO = new SongDAO();
            ArtistDAO artistDAO = new ArtistDAO();
            AlbumDAO albumDAO = new AlbumDAO();

            System.out.println("DAO objects created successfully");

            // Get trending songs (most played songs)
            System.out.println("Loading trending songs...");
            List<Song> trendingSongs = songDAO.findAll(null);
            System.out.println("Loaded " + (trendingSongs != null ? trendingSongs.size() : 0) + " songs");

            // Sort by play count descending and limit to 8
            if (trendingSongs != null && !trendingSongs.isEmpty()) {
                trendingSongs.sort((s1, s2) -> {
                    Integer count1 = s1.getPlayCount() != null ? s1.getPlayCount() : 0;
                    Integer count2 = s2.getPlayCount() != null ? s2.getPlayCount() : 0;
                    return count2.compareTo(count1);
                });
                if (trendingSongs.size() > 8) {
                    trendingSongs = trendingSongs.subList(0, 8);
                }
            }

            // Get popular artists (artists with most songs)
            System.out.println("Loading popular artists...");
            List<Artist> popularArtists = artistDAO.findAll();
            System.out.println("Loaded " + (popularArtists != null ? popularArtists.size() : 0) + " artists");

            // Limit to 8
            if (popularArtists != null && popularArtists.size() > 8) {
                popularArtists = popularArtists.subList(0, 8);
            }

            // Get albums
            System.out.println("Loading albums...");
            List<Album> albums = albumDAO.findAll();
            System.out.println("Loaded " + (albums != null ? albums.size() : 0) + " albums");

            // Limit to 8
            if (albums != null && albums.size() > 8) {
                albums = albums.subList(0, 8);
            }

            // Debug logging
            System.out.println("Trending songs count: " + (trendingSongs != null ? trendingSongs.size() : 0));
            System.out.println("Popular artists count: " + (popularArtists != null ? popularArtists.size() : 0));
            System.out.println("Albums count: " + (albums != null ? albums.size() : 0));

            // Set attributes
            request.setAttribute("trendingSongs", trendingSongs);
            request.setAttribute("popularArtists", popularArtists);
            request.setAttribute("albums", albums);
            request.setAttribute("pageTitle", "Luna Music - Home");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading home page data");
        }

        request.getRequestDispatcher("/views/layouts/defaultLayout.jsp").forward(request, response);
    }

}
