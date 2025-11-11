/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.stock;

import dao.ImportRequestDAO;
import java.io.IOException;
import java.io.PrintWriter;
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
@WebServlet(name = "StockAdjustmentViewDetail", urlPatterns = {"/manager/stock-adjustment-detail"})
public class StockAdjustmentViewDetail extends HttpServlet {

    private static final String DETAIL_JSP = "/manager/stock-adjustment-detail.jsp";
    
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
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ImportRequestViewDetail</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ImportRequestViewDetail at " + request.getContextPath () + "</h1>");
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
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        try {
            String idParam = request.getParameter("requestId");
            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath()+"/manager/stock-adjustment?error=Missing import request ID");
                return;
            }
            
            int requestId;
            try {
                requestId = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath()+"/manager/stock-adjustment?error=Invalid import request ID");
                return;
            }
            
            ImportRequestDAO importRequestDAO = new ImportRequestDAO();
            ImportRequest importRequest = importRequestDAO.getById(requestId);
            
            if (importRequest == null) {
                response.sendRedirect(request.getContextPath()+"/manager/stock-adjustment?error=Import request not found");
                return;
            }
            
            request.setAttribute("importRequest", importRequest);
            request.getRequestDispatcher(DETAIL_JSP).forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()+"/manager/stock-adjustment?error=" + e.getMessage());
        }
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
        doGet(request, response);
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
