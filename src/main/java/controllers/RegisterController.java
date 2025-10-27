
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
public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.getRequestDispatcher("/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        var email = request.getParameter("email");
        var userDAO = new UserDAO();
        // valid data
        if(userDAO.existsByEmail(email)){
            request.setAttribute("errorMsg", "Email already exists");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        var city = request.getParameter("city");
        var name = request.getParameter("name");
        var gender = request.getParameter("gender");
        var password = request.getParameter("password");



        // create salt
        byte[] salt = HashPassword.getNextSalt();
        // hash password
        byte[] hashedPassword = HashPassword.hash(password.toCharArray(), salt);
        String lastPassword = Base64.getEncoder().encodeToString(hashedPassword);
        String lastSalt = Base64.getEncoder().encodeToString(salt);
        // save
        var check = userDAO.Register(name, gender, email, lastPassword, lastSalt, city);
        if (check) {
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("loginError", "Username or password incorrect!.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
        }

    }

}
