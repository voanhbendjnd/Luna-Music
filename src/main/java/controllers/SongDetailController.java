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
            List<Song> relatedSongs;
            // Get albumID by songsID
            var albumId = songDAO.findAlbumBySongID(songId);
            if (albumId != null && albumId != 0) {
                relatedSongs = songDAO.findRelatedSongs(songId, 5, albumId);
            } else {
                relatedSongs = songDAO.findNoRelatedSongs(songId);
            }

            // Get related songs (same album or same artist)

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
        response.setContentType("application/json;charset=UTF-8");

        try {
            String action = request.getParameter("action");

            if ("updatePlayCount".equals(action)) {
                String songIdParam = request.getParameter("songId");
                if (songIdParam != null && !songIdParam.trim().isEmpty()) {
                    Long songId = Long.parseLong(songIdParam);
                    SongDAO songDAO = new SongDAO();
                    boolean success = songDAO.incrementPlayCount(songId);

                    if (success) {
                        response.getWriter().write("{\"success\": true, \"message\": \"Play count updated\"}");
                    } else {
                        response.getWriter()
                                .write("{\"success\": false, \"message\": \"Failed to update play count\"}");
                    }
                } else {
                    response.getWriter().write("{\"success\": false, \"message\": \"Invalid song ID\"}");
                }
            } else if ("next".equals(action)) {
                String songIdParam = request.getParameter("songId");
                if (songIdParam != null && !songIdParam.trim().isEmpty()) {
                    Long songId = Long.parseLong(songIdParam);
                    request.getSession().setAttribute("preSong", songIdParam);
                    SongDAO songDAO = new SongDAO();
                    Long nextSongId = songDAO.nextRandomSong(songId);

                    if (nextSongId != null && nextSongId != 0) {
                        String nextUrl = request.getContextPath() + "/song-detail?id=" + nextSongId;
                        response.getWriter().write("{\"success\": true, \"url\": \"" + nextUrl + "\"}");
                    } else {
                        response.getWriter().write("{\"success\": false, \"message\": \"No next song found\"}");
                    }
                } else {
                    response.getWriter().write("{\"success\": false, \"message\": \"Invalid song ID\"}");
                }
            }
            else if("prev".equals(action)){
                String songIdParam =  request.getParameter("songId");
                String songId = request.getSession().getAttribute("preSong").toString();
                if(songIdParam.equals(songId)){
                    var songDAO = new SongDAO();
                    Long nextSongId = songDAO.nextRandomSong(Long.parseLong(songIdParam));
                    String nextUrl = request.getContextPath() + "/song-detail?id=" + nextSongId;
                    response.getWriter().write("{\"success\": true, \"url\": \"" + nextUrl + "\"}");
                }
                else{
                    var songDAO = new SongDAO();
                    Long preSong = songDAO.preSong(Long.parseLong(songId));
                    String nextUrl = request.getContextPath() + "/song-detail?id=" + preSong;
                    response.getWriter().write("{\"success\": true, \"url\": \"" + nextUrl + "\"}");
                }


            }

            else {
                response.getWriter().write("{\"success\": false, \"message\": \"Invalid action\"}");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid song ID format\"}");
        } catch (Exception e) {
            System.err.println("Error updating play count: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"Internal server error\"}");
        }
    }
}
