package controllers;

import java.io.IOException;
import java.util.Base64;

import DALs.UserDAO;
import domain.entity.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.HashPassword;

/**
 *
 * @author Vo Anh Ben - CE190709
 */
public class AccountController extends HttpServlet {

   

 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        var session = request.getSession(false);
        var action = request.getParameter("action");
        if(action != null){
            if("update-password".equalsIgnoreCase(action)){
                request.getRequestDispatcher("/views/update-password.jsp").forward(request, response);
                return;
            }
        }

        if(session != null && session.getAttribute("user") != null){
//            request.setAttribute("user", session.getAttribute("user"));
            request.getRequestDispatcher("/views/account.jsp").forward(request, response);
        }
        else{
            response.sendRedirect(request.getContextPath() + "/");
        }
        return;
    }

  
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        var userDAO = new UserDAO();
        var action = request.getParameter("action");
        var session = request.getSession(false);
        if(action != null){
            if(action.equalsIgnoreCase("update-password")){
                var oldPassword = request.getParameter("oldPassword");
                if(session != null && session.getAttribute("user") != null){
                    User user = (User)session.getAttribute("user");
                    byte [] passwordDB = Base64.getDecoder().decode(user.getPassword());
                    byte [] salt = Base64.getDecoder().decode(user.getSalt());
                    var checkPassword = HashPassword.isExpectedPassword(oldPassword.toCharArray(), salt,  passwordDB);
                    if(checkPassword){
                        var password = request.getParameter("password");
                        byte [] newSalt = HashPassword.getNextSalt();
                        byte[] hashedPassword = HashPassword.hash(password.toCharArray(), newSalt);
                        String lastPassword = Base64.getEncoder().encodeToString(hashedPassword);
                        String lastSalt = Base64.getEncoder().encodeToString(newSalt);
                        if(userDAO.updatePassword(lastPassword, lastSalt, user.getEmail())) {
                            request.setAttribute("successMsg", "Update password success");
                            request.getRequestDispatcher("/views/update-password.jsp").forward(request, response);
                        }
                        else{
                            request.setAttribute("errorMsg", "Change password failed");
                            request.getRequestDispatcher("/views/update-password.jsp").forward(request, response);
                        }
                    }
                    else{
                        request.setAttribute("errorMsg", "Old password incorrect!");
                        request.getRequestDispatcher("/views/update-password.jsp").forward(request, response);
                    }
                    return;
                }
            }
            else if(action.equalsIgnoreCase("update-user")){
                var name = request.getParameter("name");
                var gender = request.getParameter("gender");
                var city = request.getParameter("city");
                if(session != null && session.getAttribute("user") != null){
                    var user = (User) session.getAttribute("user");
                    if(userDAO.updateAccount(name, gender, city, user.getEmail())){
                        var currentUser = userDAO.findByEmail(user.getEmail());
                        session.setAttribute("user", currentUser);
//                        request.setAttribute("user", currentUser);
                        request.setAttribute("successMsg", "Update password success");
                        request.getRequestDispatcher("/views/account.jsp").forward(request, response);
                        return;
                    }

                }
            }
        }
    }

  

}
