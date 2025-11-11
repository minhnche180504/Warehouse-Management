/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.importrequestS;

import dao.ImportRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ImportRequest;

import java.io.IOException;
import java.io.PrintWriter;
import utils.AuthorizationService;

/**
 *
 * @author nguyen
 */
@WebServlet(name="ImportRequestViewDetail", urlPatterns={"/sale/importRequestViewDetail"})
public class ImportRequestViewDetail extends HttpServlet {
    
    private static final String DETAIL_JSP = "importRequest-viewDetail.jsp";
    
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
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath()+"/sale/importRequestList?error=Missing import request ID");
                return;
            }
            
            int requestId;
            try {
                requestId = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath()+"/sale/importRequestList?error=Invalid import request ID");
                return;
            }
            
            ImportRequestDAO importRequestDAO = new ImportRequestDAO();
            ImportRequest importRequest = importRequestDAO.getById(requestId);
            
            if (importRequest == null) {
                response.sendRedirect(request.getContextPath()+"/sale/importRequestList?error=Import request not found");
                return;
            }
            
            // Lấy tên kho từ createdBy (user_id)
            int createdById = importRequest.getCreatedBy();
            String warehouseName = "N/A";
            if (createdById > 0) {
                dao.WarehouseDAO warehouseDAO = new dao.WarehouseDAO();
                model.User user = new dao.UserDAO2().getUserById(createdById);
                if (user != null && user.getWarehouseId() != null && user.getWarehouseId() > 0) {
                    model.WarehouseDisplay warehouse = warehouseDAO.getWarehouseById(user.getWarehouseId());
                    if (warehouse != null) warehouseName = warehouse.getWarehouseName();
                }
            }
            request.setAttribute("warehouseName", warehouseName);

            request.setAttribute("importRequest", importRequest);
            request.getRequestDispatcher(DETAIL_JSP).forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()+"/sale/importRequestList?error=" + e.getMessage());
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
