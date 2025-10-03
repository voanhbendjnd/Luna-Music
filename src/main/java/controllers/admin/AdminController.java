/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controllers.admin;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import DALs.UserDAO;
import domain.entity.User;
import constant.GenderEnum;

/**
 *
 * @author Vo Anh Ben - CE190709
 */
public class AdminController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        if (action == null || action.isBlank() || action.equals("list")) {
            String type = request.getParameter("type");
            if (type == null || type.isBlank())
                type = "users";
            if ("dashboard".equalsIgnoreCase(type)) {
                request.setAttribute("viewPath", "/views/admin/dashboard.jsp");
            } else if ("users".equalsIgnoreCase(type)) {
                String q = request.getParameter("q");
                var dao = new UserDAO();
                var users = dao.findAll(q);
                request.setAttribute("users", users);
                request.setAttribute("q", q == null ? "" : q);
                request.setAttribute("viewPath", "/views/admin/user.jsp");
            } else {
                request.setAttribute("viewTitle", type);
                request.setAttribute("viewPath", "/views/admin/table/placeholder.jsp");
            }
            request.getRequestDispatcher("/views/admin/tables.jsp").forward(request, response);
            return;
        }
        if (action.equals("detail")) {
            var dao = new UserDAO();
            String idStr = request.getParameter("id");
            if (idStr != null) {
                var user = dao.findById(Long.parseLong(idStr));
                request.setAttribute("user", user);
            }
            request.setAttribute("viewPath", "/views/admin/user.jsp");
            request.getRequestDispatcher("/views/admin/tables.jsp").forward(request, response);
            return;
        }
        request.setAttribute("viewPath", "/views/admin/user.jsp");
        request.getRequestDispatcher("/views/admin/tables.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        var dao = new UserDAO();
        if ("create".equals(action)) {
            User u = buildUserFromRequest(request);
            dao.create(u);
            response.sendRedirect(request.getContextPath() + "/admin?action=list");
            return;
        }
        if ("update".equals(action)) {
            User u = buildUserFromRequest(request);
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isBlank())
                u.setId(Long.parseLong(idStr));
            dao.update(u);
            response.sendRedirect(request.getContextPath() + "/admin?action=list");
            return;
        }
        if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isBlank())
                dao.delete(Long.parseLong(idStr));
            response.sendRedirect(request.getContextPath() + "/admin?action=list");
            return;
        }
    }

    private User buildUserFromRequest(HttpServletRequest request) {
        User u = new User();
        u.setName(request.getParameter("name"));
        u.setEmail(request.getParameter("email"));
        u.setPassword(request.getParameter("password"));
        u.setAvatar(request.getParameter("avatar"));
        u.setActive(
                "on".equals(request.getParameter("active")) || "true".equalsIgnoreCase(request.getParameter("active")));
        String gender = request.getParameter("gender");
        if (gender != null && !gender.isBlank()) {
            try {
                u.setGender(GenderEnum.valueOf(gender.toUpperCase()));
            } catch (Exception ignored) {
            }
        }
        u.setCreatedBy("admin");
        u.setUpdatedBy("admin");
        return u;
    }

}
