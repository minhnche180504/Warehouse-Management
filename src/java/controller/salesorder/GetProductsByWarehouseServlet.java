package controller.salesorder;

import dao.InventoryDAO;
import model.Inventory;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import utils.AuthorizationService;

@WebServlet("/sale/get-products-by-warehouse")
public class GetProductsByWarehouseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            String warehouseIdStr = request.getParameter("warehouseId");
            
            if (warehouseIdStr == null || warehouseIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            
            int warehouseId = Integer.parseInt(warehouseIdStr);
            
            // Lấy products từ database thật
            InventoryDAO inventoryDAO = new InventoryDAO();
            List<Inventory> products = inventoryDAO.getProductsByWarehouse(warehouseId);
            
            // Tạo JSON response
            StringBuilder json = new StringBuilder();
            json.append("[");
            
            for (int i = 0; i < products.size(); i++) {
                Inventory product = products.get(i);
                if (i > 0) json.append(",");
                
                json.append("{")
                    .append("\"productId\":").append(product.getProductId()).append(",")
                    .append("\"productCode\":\"").append(escapeJson(product.getProductCode())).append("\",")
                    .append("\"productName\":\"").append(escapeJson(product.getProductName())).append("\",")
                    .append("\"price\":").append(product.getPrice()).append(",")
                    .append("\"availableQuantity\":").append(product.getQuantity()).append(",")
                    .append("\"unit\":\"").append(escapeJson(product.getUnit())).append("\"")
                    .append("}");
            }
            
            json.append("]");
            
            try (PrintWriter out = response.getWriter()) {
                out.print(json.toString());
                out.flush();
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * Escape JSON string để tránh lỗi syntax
     */
    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}