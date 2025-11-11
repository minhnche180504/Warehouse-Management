 package controller;

import dao.InventoryDAO;
import dao.InventoryTransferDAO;
import dao.ProductDAO;
import dao.PurchaseOrderDAO;
import dao.SalesOrderDAO;
import dao.StockCheckReportDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Inventory;
import model.InventoryTransferDisplay;
import model.Product;
import model.PurchaseOrder;
import model.SalesOrderDisplay;
import model.StockCheckReport;
import utils.AuthorizationService;

@WebServlet(name = "WSDashboardServlet", urlPatterns = {"/staff/warehouse-staff-dashboard"})
public class WSDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        // Gọi processRequest để load dữ liệu trước khi forward
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            ProductDAO productDAO = new ProductDAO();
            SalesOrderDAO salesOrderDAO = new SalesOrderDAO();
            PurchaseOrderDAO purchaseOrderDAO = new PurchaseOrderDAO();
            InventoryTransferDAO inventoryTransferDAO = new InventoryTransferDAO();
            StockCheckReportDAO stockCheckReportDAO = new StockCheckReportDAO();
            InventoryDAO inventoryDAO = new InventoryDAO();

            // Lấy warehouseId từ session hoặc user
            Integer warehouseId = null;
            Object userObj = request.getSession().getAttribute("user");
            if (userObj != null) {
                try {
                    java.lang.reflect.Method getWarehouseIdMethod = userObj.getClass().getMethod("getWarehouseId");
                    Object wid = getWarehouseIdMethod.invoke(userObj);
                    if (wid instanceof Integer) {
                        warehouseId = (Integer) wid;
                    }
                } catch (Exception e) {
                    // Không lấy được warehouseId, để null
                }
            }
            if (warehouseId == null) {
                // Nếu không có warehouseId, có thể lấy mặc định hoặc báo lỗi
                warehouseId = 1; // Mặc định warehouseId = 1, bạn có thể thay đổi theo yêu cầu
            }

            // Tổng số sản phẩm
            int totalProducts = 0;
            int totalQuantity = 0;
            List<Product> productList = new java.util.ArrayList<>();
            List<Inventory> inventoryList = new java.util.ArrayList<>();
            List<SalesOrderDisplay> salesOrders = new java.util.ArrayList<>();
            List<PurchaseOrder> purchaseOrders = new java.util.ArrayList<>();
            List<InventoryTransferDisplay> inventoryTransfers = new java.util.ArrayList<>();
            List<StockCheckReport> stockChecks = new java.util.ArrayList<>();
            try {
                totalProducts = productDAO.getTotalProducts(warehouseId);
            } catch (Exception ex) { ex.printStackTrace(); }
            try {
                totalQuantity = inventoryDAO.getTotalStockQuantity(warehouseId);
            } catch (Exception ex) { ex.printStackTrace(); }
            try {
                productList = productDAO.getRecentProducts(warehouseId, 5);
            } catch (Exception ex) { ex.printStackTrace(); }
            try {
                inventoryList = inventoryDAO.getProductsByWarehouse(warehouseId);
            } catch (Exception ex) { ex.printStackTrace(); }
            try {
                for (Product product : productList) {
                    for (Inventory inventory : inventoryList) {
                        if (product.getProductId() == inventory.getProductId()) {
                            product.setStockQuantity(inventory.getQuantity());
                            break;
                        }
                    }
                }
            } catch (Exception ex) { ex.printStackTrace(); }
            try {
                salesOrders = salesOrderDAO.getSalesOrdersForWarehouse(warehouseId);
            } catch (Exception ex) { ex.printStackTrace(); }
            try {
                purchaseOrders = purchaseOrderDAO.getPurchaseOrdersForWarehouse(warehouseId);
            } catch (Exception ex) { ex.printStackTrace(); }
            try {
                inventoryTransfers = inventoryTransferDAO.getPendingInventoryTransfersForWarehouse(warehouseId);
            } catch (Exception ex) { ex.printStackTrace(); }
            try {
                stockChecks = stockCheckReportDAO.getUnapprovedStockCheckReports(warehouseId);
            } catch (Exception ex) { ex.printStackTrace(); }
            System.out.println("Dashboard Data Counts: totalProducts=" + totalProducts + ", totalQuantity=" + totalQuantity
                + ", productList=" + productList.size() + ", salesOrders=" + salesOrders.size()
                + ", purchaseOrders=" + purchaseOrders.size() + ", inventoryTransfers=" + inventoryTransfers.size()
                + ", stockChecks=" + stockChecks.size());

            // Set thuộc tính cho JSP
            request.setAttribute("totalProducts", totalProducts);
            request.setAttribute("totalQuantity", totalQuantity);
            request.setAttribute("productList", productList);
            request.setAttribute("salesOrders", salesOrders);
            request.setAttribute("purchaseOrders", purchaseOrders);
            request.setAttribute("inventoryTransfers", inventoryTransfers);
            request.setAttribute("stockChecks", stockChecks);

            request.getRequestDispatcher("/staff/WSDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace(); // Log lỗi chi tiết ra console/server log
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải dashboard: " + e.getMessage());
            request.getRequestDispatcher("/404.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Warehouse Staff Dashboard Controller";
    }
}
