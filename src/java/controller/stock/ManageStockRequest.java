/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.stock;

import dao.ImportRequestDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ImportRequest;
import utils.AuthorizationService;

/**
 *
 * @author Nguyen Duc Thinh
 */
@WebServlet(name = "ManageStockRequest", urlPatterns = {"/manager/stock-request"})
public class ManageStockRequest extends HttpServlet {

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
            out.println("<title>Servlet ImportRequestList</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ImportRequestList at " + request.getContextPath() + "</h1>");
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
        ImportRequestDAO dao = new ImportRequestDAO();

        try {
            String productName = request.getParameter("productName");
            String requestDate = request.getParameter("requestDate");

            // Trim input nếu có
            if (productName != null) {
                productName = productName.trim();
            }
            if (requestDate != null) {
                requestDate = requestDate.trim();
            }

            List<ImportRequest> requestList;

            boolean hasProductName = productName != null && !productName.isEmpty();
            boolean hasRequestDate = requestDate != null && !requestDate.isEmpty();

            if (hasProductName || hasRequestDate) {
                // Gọi hàm tìm kiếm tùy theo các tham số truyền vào
                requestList = dao.search(productName, requestDate);
            } else {
                requestList = dao.getAlls();
            }

            request.setAttribute("importRequests", requestList);
            request.getRequestDispatcher("/manager/stock-adjustment.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/manager/stock-request?error=" + e.getMessage());
        }
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
        ImportRequestDAO dao = new ImportRequestDAO();
        try {
            List<ImportRequest> requestList = dao.getAlls();
            request.setAttribute("importRequests", requestList);
            request.getRequestDispatcher("/manager/stock-adjustment.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/manager/stock-request?error=" + e.getMessage());
        }
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
