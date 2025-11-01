package controllers;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import java.io.IOException;
import java.util.Comparator;
import java.util.List;

import DALs.SongDAO;
import DALs.ArtistDAO;
import DALs.AlbumDAO;
import DALs.PlaylistDAO;
import domain.entity.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Home Controller for Luna Music
 * 
 * @author Vo Anh Ben - CE190709
 */
public class HomeController extends HttpServlet {
    public List<Song> getPopularSongs(List<Song> songs) {
        return songs.stream().sorted(Comparator.comparing(Song::getPlayCount).reversed()).toList();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = null;
        String apiUrl = "";
        final String api_key = "87e69dc0130b8ca868d368ff5e762d81";
        if (session != null && session.getAttribute("user") != null) {
            currentUser = (User) session.getAttribute("user");
            request.setAttribute("user", currentUser);
            apiUrl += "http://api.openweathermap.org/data/2.5/weather?q=" + currentUser.getCity() + "&appid=" + api_key
                    + "&units=metric";

        }
        response.setContentType("text/html;charset=UTF-8");
        if (!apiUrl.isBlank() && currentUser.getCity() != null) {
            try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
                HttpGet httpGet = new HttpGet(apiUrl);

                try (CloseableHttpResponse apiResponse = httpClient.execute(httpGet)) {
                    String jsonResponse = EntityUtils.toString(apiResponse.getEntity());

                    ObjectMapper mapper = new ObjectMapper();
                    JsonNode root = mapper.readTree(jsonResponse);

                    // String description =
                    // root.path("weather").get(0).path("description").asText();
                    String main = root.path("weather").get(0).path("main").asText();
                    double temperature = root.path("main").path("temp").asDouble();
                    request.setAttribute("city", currentUser.getCity().replace("%20", " ").trim());
                    request.setAttribute("weatherDesc", main);
                    request.setAttribute("temperature", String.format("%.1f", temperature) + "°C");
                    var songDAO = new SongDAO();
                    var songs = songDAO.getSongByTempOptimal(main);
                    request.setAttribute("mySongs", songs);

                } catch (Exception e) {
                    response.sendRedirect(request.getContextPath() + "/");
                    return;
                }
            }

        }
        var action = request.getParameter("action");
        if (action != null) {
            if(action.equalsIgnoreCase("filter")){
                this.filterHome(request, response, request.getParameter("type"));
                return;
            }
            else if(action.equalsIgnoreCase("search")){

            }

        }

        if (session != null && session.getAttribute("search") != null) {
            session.removeAttribute("search");
        }
        var songDAO = new SongDAO();
        List<Song> songs = songDAO.findAll(null);
        if (songs.size() > 20) {
            songs = songs.subList(0, 20);
        }
        request.setAttribute("songs", songs);
        var popularSongs = this.getPopularSongs(songs);
        if (popularSongs != null && popularSongs.size() > 20) {
            popularSongs = popularSongs.subList(0, 20);
        }
        request.setAttribute("popularSong", popularSongs);

        var artistDAO = new ArtistDAO();
        List<Artist> artists = artistDAO.findAll(null);
        if (artists.size() > 20) {
            artists = artists.subList(0, 20);
        }
        request.setAttribute("artists", artists);

        var albumDAO = new AlbumDAO();
        List<Album> albums = albumDAO.findAll(null);
        if (albums.size() > 20) {
            albums = albums.subList(0, 20);
        }
        request.setAttribute("albums", albums);

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
        request.getRequestDispatcher("/views/layouts/defaultLayout.jsp").forward(request, response);
    }

    public void filterHome(HttpServletRequest request, HttpServletResponse response, String filter)
            throws ServletException, IOException {
        var songDAO = new SongDAO();
        var albumDAO = new AlbumDAO();
        var artistDAO = new ArtistDAO();
        HttpSession session = request.getSession(false);
        User currentUser = null;
        if (session != null && session.getAttribute("user") != null) {
            currentUser = (User) session.getAttribute("user");
            request.setAttribute("user", currentUser);
        }
        if (session != null && session.getAttribute("search") != null) {
            session.removeAttribute("search");
        }
        var songs = songDAO.getSongsAtFilterHome(filter);
        var populars = songs.stream().sorted(Comparator.comparing(Song::getPlayCount).reversed()).toList();
        var albums = albumDAO.fetchAlbumsByGenre(filter);
        var artists = artistDAO.fetchAllArtistByGenre(filter);
        request.setAttribute("popularSong", populars);
        request.setAttribute("songs", songs);
        request.setAttribute("albums", albums);
        request.setAttribute("artists", artists);

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
        request.getRequestDispatcher("/views/layouts/defaultLayout.jsp").forward(request, response);

    }

}
