package controllers.api;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import DALs.AlbumDAO;
import DALs.SongDAO;
import domain.entity.Album;
import domain.entity.Song;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

/**
 * API Controller for Albums
 * 
 * @author Vo Anh Ben - CE190709
 */
public class AlbumController extends HttpServlet {

    private AlbumDAO albumDAO;
    private SongDAO songDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        albumDAO = new AlbumDAO();
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
                // Get all albums
                List<Album> albums = albumDAO.findAll();
                out.print(gson.toJson(albums));
            } else if (pathInfo.matches("/\\d+")) {
                // Get album by ID
                String idStr = pathInfo.substring(1);
                long id = Long.parseLong(idStr);
                Album album = albumDAO.findById(id);

                if (album != null) {
                    out.print(gson.toJson(album));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print(gson.toJson(new ErrorResponse("Album not found")));
                }
            } else if (pathInfo.matches("/\\d+/tracks")) {
                // Get tracks by album ID
                String idStr = pathInfo.substring(1, pathInfo.lastIndexOf('/'));
                long id = Long.parseLong(idStr);
                List<Song> tracks = songDAO.findByAlbumId(id);
                out.print(gson.toJson(tracks));
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(new ErrorResponse("Invalid request path")));
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(new ErrorResponse("Invalid album ID")));
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

            Album album = gson.fromJson(jsonString, Album.class);

            if (albumDAO.create(album)) {
                response.setStatus(HttpServletResponse.SC_CREATED);
                out.print(gson.toJson(album));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(gson.toJson(new ErrorResponse("Failed to create album")));
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

            Album album = gson.fromJson(jsonString, Album.class);
            album.setId(id);

            if (albumDAO.update(album)) {
                out.print(gson.toJson(album));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(gson.toJson(new ErrorResponse("Failed to update album")));
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(new ErrorResponse("Invalid album ID")));
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

            if (albumDAO.delete(id)) {
                out.print(gson.toJson(new SuccessResponse("Album deleted successfully")));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(gson.toJson(new ErrorResponse("Failed to delete album")));
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(new ErrorResponse("Invalid album ID")));
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
