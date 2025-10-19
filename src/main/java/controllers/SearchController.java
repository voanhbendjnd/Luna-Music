package controllers;

import DALs.SongDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "SearchController", urlPatterns = { "/search" })
public class SearchController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy dữ liệu từ request
        String query = request.getParameter("q");
        String type = request.getParameter("type");
        var songDAO = new SongDAO();
        var res = songDAO.searchAtHome(query);
        var songs = res.getSongs();
        var albums = res.getAlbums();
        var artists = res.getArtists();
        request.setAttribute("songs", songs);
        request.setAttribute("albums", albums);
        request.setAttribute("artists", artists);
        request.setAttribute("popularSong", songs);
        // Set session
        var session = request.getSession();
        session.setAttribute("search", query);
        System.out.println("=== SEARCH REQUEST ===");
        System.out.println("Query: " + query);
        System.out.println("Type: " + type);
        System.out.println("=====================");

        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("/views/layouts/defaultLayout.jsp").forward(request, response);

    }
}