/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.authentication;

import dao.UserDAO2;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author nguyen
 */
@WebServlet(name="changePasswordSales", urlPatterns={"/sale/changePassword"})
public class changePasswordSales extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String error = (String) request.getAttribute("error");
            String success = (String) request.getAttribute("success");
            
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Change Password</title>");
            out.println("<style>");
            out.println(".error { color: red; margin: 10px 0; }");
            out.println(".success { color: green; margin: 10px 0; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            if (error != null) {
                out.println("<div class='error'>" + error + "</div>");
            }
            if (success != null) {
                out.println("<div class='success'>" + success + "</div>");
            }
            out.println("<h1>Change Password</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Get current user from session
        model.User currentUser = (model.User) request.getSession().getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }
        request.getRequestDispatcher("/sale/changePassword.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Get current user from session
        model.User currentUser = (model.User) request.getSession().getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate passwords
        if (currentPassword == null || newPassword == null || confirmPassword == null ||
            currentPassword.isEmpty() || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("error", "Please fill in all fields!");
            request.getRequestDispatcher("/sale/changePassword.jsp").forward(request, response);
            return;
        }

        // Check if current password is correct
        if (!currentUser.getPassword().equals(currentPassword)) {
            request.setAttribute("error", "Current password is incorrect!");
            request.getRequestDispatcher("/sale/changePassword.jsp").forward(request, response);
            return;
        }

        // Check if new password matches confirmation
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New passwords do not match!");
            request.getRequestDispatcher("/sale/changePassword.jsp").forward(request, response);
            return;
        }

        // Update password
        UserDAO2 d = new UserDAO2();
        boolean success = d.changePassword(currentUser.getUserId(), newPassword);

        if (success) {
            // Update session user with new password
            currentUser.setPassword(newPassword);
            request.getSession().setAttribute("user", currentUser);
            request.setAttribute("success", "Password changed successfully!");
            request.getRequestDispatcher("/sale/changePassword.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "An error occurred while changing password!");
            request.getRequestDispatcher("/sale/changePassword.jsp").forward(request, response);
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
