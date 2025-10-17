
package controllers;

import java.io.IOException;

import DALs.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.HashPassword;

import java.util.Base64;

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
        var userDAO = new UserDAO();
        var user = userDAO.LoginWithEmail(username);
        if (user != null) {
            byte[] saveHash = Base64.getDecoder().decode(user.getPassword());
            byte[] saveSalt = Base64.getDecoder().decode(user.getSalt());
            boolean checkLoginSuccess = HashPassword.isExpectedPassword(password.toCharArray(), saveSalt, saveHash);
            if (checkLoginSuccess) {
                request.getSession().setAttribute("user", user);
                response.sendRedirect(request.getContextPath() + "/");
            } else {
                request.setAttribute("error", "Username or password incorrect!");
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "User not found!");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }

}
