/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.importrequestS;

import dao.ImportRequestDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ImportRequest;
import model.ImportRequestDetail;
import model.Product;
import model.User;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Calendar;
import utils.AuthorizationService;

/**
 *
 * @author nguyen
 */
@WebServlet(name="RequestImport", urlPatterns={"/sale/requestImport"})
public class ImportRequestController extends HttpServlet {
   
    private static final String IMPORT_REQUEST_JSP = "/sale/importRequest.jsp";
    private static final String LIST_URL = "/sale/importRequestList";
   
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
            out.println("<title>Servlet RequestImport</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RequestImport at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 
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
            // Lấy danh sách sản phẩm cho dropdown
            ProductDAO productDAO = new ProductDAO();
            List<Product> products = productDAO.getAll();
            request.setAttribute("products", products);

            // Lấy thông tin user và kho (chỉ để hiển thị)
            setUserAndWarehouseInfo(request);

            // Lấy ngày hiện tại
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            request.setAttribute("requestDate", sdf.format(Calendar.getInstance().getTime()));

            // Forward tới form tạo import request
            request.getRequestDispatcher(IMPORT_REQUEST_JSP).forward(request, response);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error loading products: " + e.getMessage());
            request.getRequestDispatcher(IMPORT_REQUEST_JSP).forward(request, response);
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
        // Chỉ xử lý các thao tác làm thay đổi dữ liệu (thêm, sửa, xóa)
        try {
            // Lấy dữ liệu từ form
            String[] productIds = request.getParameterValues("productIds[]");
            String[] quantities = request.getParameterValues("quantities[]");
            String reason = request.getParameter("reason");
            String requestDateStr = request.getParameter("requestDate");

            // Validate dữ liệu đầu vào
            if (productIds == null || quantities == null || productIds.length == 0) {
                request.setAttribute("errorMessage", "At least one product is required");
                reloadFormData(request);
                request.getRequestDispatcher(IMPORT_REQUEST_JSP).forward(request, response);
                return;
            }

            // Lấy user hiện tại từ session
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                response.sendRedirect("login");
                return;
            }

            ImportRequest importRequest = new ImportRequest();
            // Convert Date to Timestamp
            Date date = Date.valueOf(requestDateStr);
            Timestamp timestamp = new Timestamp(date.getTime());
            importRequest.setRequestDate(timestamp);
            importRequest.setReason(reason);
            importRequest.setCreatedBy(currentUser.getUserId());
            importRequest.setStatus("Pending");

            // Tạo danh sách chi tiết sản phẩm
            List<ImportRequestDetail> details = new ArrayList<>();
            for (int i = 0; i < productIds.length; i++) {
                try {
                    int productId = Integer.parseInt(productIds[i]);
                    int quantity = Integer.parseInt(quantities[i]);

                    if (quantity <= 0) {
                        throw new NumberFormatException("Quantity must be greater than 0");
                    }

                    ImportRequestDetail detail = new ImportRequestDetail();
                    detail.setProductId(productId);
                    detail.setQuantity(quantity);
                    details.add(detail);

                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid product or quantity: " + e.getMessage());
                    reloadFormData(request);
                    request.getRequestDispatcher(IMPORT_REQUEST_JSP).forward(request, response);
                    return;
                }
            }
            ImportRequestDAO importRequestDAO = new ImportRequestDAO();
            boolean success = importRequestDAO.createWithDetails(importRequest, details);

            if (success) {
                response.sendRedirect(request.getContextPath() + LIST_URL + "?success=Import request created successfully!!");
            } else {
                request.setAttribute("errorMessage", "Failed to create import request");
                reloadFormData(request);
                request.getRequestDispatcher(IMPORT_REQUEST_JSP).forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            reloadFormData(request);
            request.getRequestDispatcher(IMPORT_REQUEST_JSP).forward(request, response);
        }
    }
    
    private void reloadFormData(HttpServletRequest request) {
        try {
            // Reload products
            ProductDAO productDAO = new ProductDAO();
            List<Product> products = productDAO.getAll();
            request.setAttribute("products", products);
            
            // Reload user info
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            if (currentUser != null) {
                request.setAttribute("creatorName", currentUser.getFirstName() + " " + currentUser.getLastName());
                // Lấy tên kho
                int warehouseId = currentUser.getWarehouseId();
                if (warehouseId > 0) {
                    dao.WarehouseDAO warehouseDAO = new dao.WarehouseDAO();
                    model.WarehouseDisplay warehouse = warehouseDAO.getWarehouseById(warehouseId);
                    String warehouseName = warehouse != null ? warehouse.getWarehouseName() : "N/A";
                    request.setAttribute("warehouseName", warehouseName);
                } else {
                    request.setAttribute("warehouseName", "N/A");
                }
            }
            
            // Reload current date
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            request.setAttribute("requestDate", sdf.format(Calendar.getInstance().getTime()));
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error reloading form data: " + e.getMessage());
        }
    }

    private void setUserAndWarehouseInfo(HttpServletRequest request) {
        // Get current user
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser != null) {
            request.setAttribute("creatorName", currentUser.getFirstName() + " " + currentUser.getLastName());
            // Lấy tên kho
            int warehouseId = currentUser.getWarehouseId();
            if (warehouseId > 0) {
                dao.WarehouseDAO warehouseDAO = new dao.WarehouseDAO();
                model.WarehouseDisplay warehouse = warehouseDAO.getWarehouseById(warehouseId);
                String warehouseName = warehouse != null ? warehouse.getWarehouseName() : "N/A";
                request.setAttribute("warehouseName", warehouseName);
            } else {
                request.setAttribute("warehouseName", "N/A");
            }
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
