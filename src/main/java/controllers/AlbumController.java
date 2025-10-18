/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import DALs.AlbumDAO;
import DALs.SongDAO;
import domain.entity.Album;
import domain.entity.Song;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Vo Anh Ben - CE190709
 */
public class AlbumController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            String albumId = request.getParameter("id");
            if (albumId == null || albumId.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            // Get album details if available
            AlbumDAO albumDAO = new AlbumDAO();
            var album =  albumDAO.findById(Long.parseLong(albumId));
            // Get song with albumID
            var songDAO = new SongDAO();
            var songs = songDAO.findByAlbumId(Long.parseLong(albumId));

            // Set attributes for JSP
            request.setAttribute("album", album);
            request.setAttribute("songs", songs);

            // Forward to song detail page
            request.getRequestDispatcher("/views/album-detail.jsp").forward(request, response);

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
