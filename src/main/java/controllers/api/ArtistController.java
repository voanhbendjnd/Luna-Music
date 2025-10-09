package controllers.api;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import DALs.ArtistDAO;
import DALs.SongDAO;
import domain.entity.Artist;
import domain.entity.Song;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

/**
 * API Controller for Artists
 * 
 * @author Vo Anh Ben - CE190709
 */
public class ArtistController extends HttpServlet {

    private ArtistDAO artistDAO;
    private SongDAO songDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        artistDAO = new ArtistDAO();
        songDAO = new SongDAO();
        gson = new GsonBuilder().setPrettyPrinting().create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");

        String pathInfo = request.getPathInfo();
        PrintWriter out = response.getWriter();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // Get all artists
                List<Artist> artists = artistDAO.findAll();
                out.print(gson.toJson(artists));
            } else if (pathInfo.matches("/\\d+")) {
                // Get artist by ID
                String idStr = pathInfo.substring(1);
                long id = Long.parseLong(idStr);
                Artist artist = artistDAO.findById(id);

                if (artist != null) {
                    out.print(gson.toJson(artist));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print(gson.toJson(new ErrorResponse("Artist not found")));
                }
            } else if (pathInfo.matches("/\\d+/songs")) {
                // Get songs by artist ID
                String idStr = pathInfo.substring(1, pathInfo.lastIndexOf('/'));
                long id = Long.parseLong(idStr);
                List<Song> songs = songDAO.findByArtistId(id);
                out.print(gson.toJson(songs));
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(new ErrorResponse("Invalid request path")));
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(new ErrorResponse("Invalid artist ID")));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(new ErrorResponse("Internal server error: " + e.getMessage())));
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");

        PrintWriter out = response.getWriter();

        try {
            // Parse JSON request body
            StringBuilder jsonBuilder = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                jsonBuilder.append(line);
            }
            String jsonString = jsonBuilder.toString();

            Artist artist = gson.fromJson(jsonString, Artist.class);

            if (artistDAO.create(artist)) {
                response.setStatus(HttpServletResponse.SC_CREATED);
                out.print(gson.toJson(artist));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(gson.toJson(new ErrorResponse("Failed to create artist")));
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(new ErrorResponse("Internal server error: " + e.getMessage())));
            e.printStackTrace();
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");

        String pathInfo = request.getPathInfo();
        PrintWriter out = response.getWriter();

        try {
            if (pathInfo == null || !pathInfo.matches("/\\d+")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(new ErrorResponse("Invalid request path")));
                return;
            }

            String idStr = pathInfo.substring(1);
            long id = Long.parseLong(idStr);

            // Parse JSON request body
            StringBuilder jsonBuilder = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                jsonBuilder.append(line);
            }
            String jsonString = jsonBuilder.toString();

            Artist artist = gson.fromJson(jsonString, Artist.class);
            artist.setId(id);

            if (artistDAO.update(artist)) {
                out.print(gson.toJson(artist));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(gson.toJson(new ErrorResponse("Failed to update artist")));
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(new ErrorResponse("Invalid artist ID")));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(new ErrorResponse("Internal server error: " + e.getMessage())));
            e.printStackTrace();
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");

        String pathInfo = request.getPathInfo();
        PrintWriter out = response.getWriter();

        try {
            if (pathInfo == null || !pathInfo.matches("/\\d+")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(new ErrorResponse("Invalid request path")));
                return;
            }

            String idStr = pathInfo.substring(1);
            long id = Long.parseLong(idStr);

            if (artistDAO.delete(id)) {
                out.print(gson.toJson(new SuccessResponse("Artist deleted successfully")));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(gson.toJson(new ErrorResponse("Failed to delete artist")));
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(new ErrorResponse("Invalid artist ID")));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(new ErrorResponse("Internal server error: " + e.getMessage())));
            e.printStackTrace();
        }
    }

    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
        response.setStatus(HttpServletResponse.SC_OK);
    }

    // Helper classes for JSON responses
    private static class ErrorResponse {
        private String error;

        public ErrorResponse(String error) {
            this.error = error;
        }

        public String getError() {
            return error;
        }
    }

    private static class SuccessResponse {
        private String message;

        public SuccessResponse(String message) {
            this.message = message;
        }

        public String getMessage() {
            return message;
        }
    }
}
