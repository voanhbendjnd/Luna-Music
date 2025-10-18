/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import java.io.IOException;

import DALs.AlbumDAO;
import DALs.ArtistDAO;
import DALs.SongDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Vo Anh Ben - CE190709
 */
public class ArtistController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            String artistId = request.getParameter("id");
            if (artistId == null || artistId.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            var artistDAO = new ArtistDAO();
            var artist = artistDAO.findById(Long.parseLong(artistId));
            var albumDAO = new AlbumDAO();
            var albums = albumDAO.findByArtistId(Long.parseLong(artistId));

            // Set attributes for JSP
            request.setAttribute("artist", artist);
            request.setAttribute("albums", albums);

            // Forward to song detail page
            request.getRequestDispatcher("/views/artist-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            System.err.println("Invalid song ID: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/home");
        } catch (Exception e) {
            System.err.println("Error loading song detail: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
