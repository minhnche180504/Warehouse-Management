package controller.warehouse;
import dao.WarehouseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import utils.AuthorizationService;

@WebServlet("/admin/DeleteWarehouseServlet")
public class DeleteWarehouseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String warehouseIdStr = request.getParameter("id");
        String redirectURL = "warehouse-list.jsp";

        if (warehouseIdStr == null || warehouseIdStr.trim().isEmpty()) {
            response.sendRedirect(redirectURL + request.getContextPath()+"/admin/?message=error_delete_noid");
            return;
        }

        int warehouseId;
        try {
            warehouseId = Integer.parseInt(warehouseIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(redirectURL + request.getContextPath()+"/admin/?message=error_delete_invalidid");
            return;
        }

        try {
            // SỬA LỖI: Sử dụng WarehouseDAO thay vì DBConnection trực tiếp
            WarehouseDAO warehouseDAO = new WarehouseDAO();

            // Kiểm tra tồn kho trước khi xóa
            int totalProducts = warehouseDAO.getTotalProductsPerWarehouse(warehouseId);
            if (totalProducts > 0) {
                response.sendRedirect(redirectURL + request.getContextPath() + "/admin/?message=error_delete_inuse_stock");
                return;
            }
            
            boolean success = warehouseDAO.deleteWarehouse(warehouseId);

            if (success) {
                response.sendRedirect(redirectURL + request.getContextPath()+"/admin/?message=success_delete");
            } else {
                response.sendRedirect(redirectURL + request.getContextPath()+"/admin/?message=error_delete_notfound");
            }

        } catch (Exception e) {
            e.printStackTrace();
            
            // Xử lý lỗi constraint (kho đang được sử dụng)
            if (e.getMessage() != null && e.getMessage().toLowerCase().contains("constraint")) {
                response.sendRedirect(redirectURL + request.getContextPath()+"/admin/?message=error_delete_inuse_constraint");
            } else {
                response.sendRedirect(redirectURL + request.getContextPath()+"/admin/?message=error_delete_db");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        doPost(request, response);
    }
}
