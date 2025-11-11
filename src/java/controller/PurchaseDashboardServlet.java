/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.AuthorizationService;
import dao.PurchaseOrderDAO;
import java.sql.Date;
import java.time.LocalDate;
import model.User;
import model.PurchaseOrder;
import java.util.List;

/**
 *
 * @author Nguyen Duc Thinh
 */
@WebServlet(name = "PurchaseDashboardServlet", urlPatterns = {"/purchase/purchase-dashboard"})
public class PurchaseDashboardServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet PurchaseDashboardServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PurchaseDashboardServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        // Dashboard stats
        PurchaseOrderDAO poDAO = new PurchaseOrderDAO();
        LocalDate today = LocalDate.now();
        Date lastWeek = Date.valueOf(today.minusDays(7));
        Date lastMonth = Date.valueOf(today.minusDays(30));
        // Get current user
        User currentUser = (User) request.getSession().getAttribute("user");
        int userId = currentUser != null ? currentUser.getUserId() : -1;
        int totalProductsBoughtLastWeek = poDAO.getDistinctProductsBoughtSince(lastWeek);
        int activeSuppliersLastMonth = poDAO.getActiveSuppliersSince(lastMonth);
        int pendingPurchaseOrders = userId != -1 ? poDAO.getPendingPurchaseOrdersByUser(userId).size() : 0;
        // Recent purchase orders (latest 3 for this user)
        List<PurchaseOrder> recentOrders = null;
        if (userId != -1) {
            List<PurchaseOrder> allOrders = poDAO.findPurchaseOrdersByUserWithFilters(userId, null, null, null, null, 1, 3);
            recentOrders = allOrders;
        }
        request.setAttribute("totalProductsBoughtLastWeek", totalProductsBoughtLastWeek);
        request.setAttribute("activeSuppliersLastMonth", activeSuppliersLastMonth);
        request.setAttribute("pendingPurchaseOrders", pendingPurchaseOrders);
        request.setAttribute("recentOrders", recentOrders);
        request.getRequestDispatcher("/purchase/PurchaseDashboard.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
