
package controllers;

import java.io.IOException;

import DALs.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 *
 * @author Vo Anh Ben - CE190709
 */
public class LoginController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        var password = request.getParameter("password");
        String username = request.getParameter("email");
        // authentication
        var user = new UserDAO();
        var strUsername = user.login(username, password);
        if (!strUsername.equals("")) {
                String encodedUsername = URLEncoder.encode(strUsername, StandardCharsets.UTF_8.toString());

            Cookie cookie = new Cookie("name", encodedUsername);
            cookie.setMaxAge(60 * 60); // 1 hour
            response.addCookie(cookie);
            response.sendRedirect(request.getContextPath() + "/views/layouts/defaultLayout.jsp");
        } else {
            request.setAttribute("loginError", "Username or password incorrect!.");
            request.getRequestDispatcher("/views/layouts/defaultLayout.jsp").forward(request, response);
        }

    }

}
