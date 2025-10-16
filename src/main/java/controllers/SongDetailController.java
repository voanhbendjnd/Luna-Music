package controllers;

import DALs.SongDAO;
import DALs.AlbumDAO;
import domain.entity.Song;
import domain.entity.Album;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Song Detail Controller - Handles song detail page with music player
 */
public class SongDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            String songIdParam = request.getParameter("id");
            if (songIdParam == null || songIdParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            Long songId = Long.parseLong(songIdParam);

            // Get song details
            SongDAO songDAO = new SongDAO();
            Song song = songDAO.findById(songId);

            if (song == null) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            // Get albumID by songsID
            var albumId = songDAO.findAlbumBySongID(songId);

            // Get related songs (same album or same artist)
            List<Song> relatedSongs = songDAO.findRelatedSongs(songId, 5, albumId);

            // Get album details if available
            AlbumDAO albumDAO = new AlbumDAO();
            Album album = null;
            if (song.getAlbum() != null) {
                album = albumDAO.findById(song.getAlbum().getId());
            }

            // Set attributes for JSP
            request.setAttribute("song", song);
            request.setAttribute("album", album);
            request.setAttribute("relatedSongs", relatedSongs);

            // Forward to song detail page
            request.getRequestDispatcher("/views/song-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            System.err.println("Invalid song ID: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/home");
        } catch (Exception e) {
            System.err.println("Error loading song detail: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
