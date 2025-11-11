/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.user;

import dao.UserDAO2;
import dao.WarehouseDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import model.Warehouse;
import utils.AuthorizationService;

@WebServlet(name = "ManagerProfile", urlPatterns = {"/manager/UserProfile"})
public class ManagerProfile extends HttpServlet {

    private int getUserId(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath()+"login");
            return -1;
        }
        String idParam = request.getParameter("id");
        if (idParam != null && currentUser.getRole().getRoleId() == 1) {
            return Integer.parseInt(idParam);
        } else {
            return currentUser.getUserId();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }

        User sessionUser = (User) request.getSession().getAttribute("user");
        if (sessionUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String idParam = request.getParameter("id");
        int id;
        if (idParam != null && sessionUser.getRole().getRoleId() == 1) {
            System.out.println(sessionUser.getRole());
            try {
                id = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                id = sessionUser.getUserId();
            }
        } else {
            id = sessionUser.getUserId();
        }
        UserDAO2 userDAO = new UserDAO2();
        User user = userDAO.getUserById(id);
        request.setAttribute("user", user);

        // If admin, fetch warehouse list for dropdown
        if (sessionUser.getRole().getRoleId() == 1) {
            WarehouseDAO warehouseDAO = new WarehouseDAO();
            List<Warehouse> warehouses = warehouseDAO.getAll();
            request.setAttribute("warehouses", warehouses);
        }

        String successMessage = (String) request.getSession().getAttribute("successMessage");
        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            request.getSession().removeAttribute("successMessage");
        }
        request.getRequestDispatcher("/manager/UserProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String idParam = request.getParameter("user_id");
        int id;
        if (idParam != null && currentUser.getRole().getRoleId() == 1) {
            try {
                id = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                id = currentUser.getUserId();
            }
        } else {
            id = currentUser.getUserId();
        }
        try {
            String firstName = request.getParameter("first_name");
            String lastName = request.getParameter("last_name");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String dob = request.getParameter("date_of_birth");
            String gender = request.getParameter("gender");
            User updatedUser = new User();
            updatedUser.setUserId(id);
            updatedUser.setFirstName(firstName);
            updatedUser.setLastName(lastName);
            updatedUser.setEmail(email);
            updatedUser.setAddress(address);
            updatedUser.setDateOfBirth(java.sql.Date.valueOf(dob));
            updatedUser.setGender(gender);

            // If admin, get warehouse id from request and set it
            if (currentUser.getRole().getRoleId() == 1) {
                String warehouseIdStr = request.getParameter("warehouse_id");
                if (warehouseIdStr != null && !warehouseIdStr.isEmpty()) {
                    try {
                        int warehouseId = Integer.parseInt(warehouseIdStr);
                        updatedUser.setWarehouseId(warehouseId);
                    } catch (NumberFormatException e) {
                        updatedUser.setWarehouseId(null);
                    }
                } else {
                    updatedUser.setWarehouseId(null);
                }
            }

            UserDAO2 userDAO = new UserDAO2();
            boolean updated = userDAO.changeUser(updatedUser);

            if (updated) {
                request.getSession().setAttribute("successMessage", "Profile updated successfully!");
                response.sendRedirect(request.getContextPath()+"/manager/UserProfile?id=" + id);
            } else {
                request.setAttribute("errorMessage", "Failed to update profile");
                request.setAttribute("user", updatedUser);
                request.getRequestDispatcher("/manager/UserProfile.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher("/manager/UserProfile.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "User Profile Controller";
    }
}
