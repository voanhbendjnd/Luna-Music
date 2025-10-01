package controllers;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import utils.DatabaseConfig;

/**
 *
 * @author Vo Anh Ben - CE190709
 */
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
                request.getRequestDispatcher("/views/login.jsp").forward(request,response);

        try (PrintWriter out = response.getWriter()) {
            var db = new DatabaseConfig();
            Connection conn = db.connection;
            if (conn != null && !conn.isClosed()) {
                out.println("<h1>Database Connection Successful!</h1>");
            } else {
                out.println("<h1>Database Connection Failed!</h1>");
            }
            // Optionally close the connection here if DBContext didn't manage it.
            try {
                if (conn != null && !conn.isClosed())
                    conn.close();
            } catch (Exception ignored) {
            }
        } catch (Exception ex) {
            // Print a friendly message to browser and full stack trace to server logs
            response.getWriter().println("<h1>Test failed: " + ex.getMessage() + "</h1>");
            ex.printStackTrace();
        }
    }

}
