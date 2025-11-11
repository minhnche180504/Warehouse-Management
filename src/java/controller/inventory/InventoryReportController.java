package controller.inventory;

import dao.InventoryReportDAO;
import dao.InventoryHistoryDAO;
import dao.WarehouseDAO;
import model.InventoryReport;
import model.InventoryHistory;
import model.WarehouseDisplay;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import utils.AuthorizationService;
import utils.WarehouseAuthUtil;

@WebServlet(name = "InventoryReportController", urlPatterns = {"/manager/inventory-report"})
public class InventoryReportController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                handleListWithFilters(request, response);
                break;
            case "export":
                handleExport(request, response);
                break;
            case "history":
                handleProductHistory(request, response);
                break;
            default:
                handleListWithFilters(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    private void handleListWithFilters(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get current user from session
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get the assigned warehouse for the current user
        Integer userWarehouseId = WarehouseAuthUtil.getDefaultWarehouseId(currentUser);
        if (userWarehouseId == null) {
            setToastMessage(request, "No warehouse assigned to your account. Please contact administrator.", "error");
            response.sendRedirect(request.getContextPath() + "/manager/ManagerDashboard.jsp");
            return;
        }
        
        // Get filter parameters
        String productFilter = request.getParameter("product");
        String supplierFilter = request.getParameter("supplier");
        String stockLevel = request.getParameter("stockLevel");
        
        // Get warehouse filter from request, default to user's warehouse if not provided or empty
        String warehouseParam = request.getParameter("warehouse");
        Integer warehouseFilter = null;
        if (warehouseParam == null || warehouseParam.isEmpty()) {
            warehouseFilter = userWarehouseId;
        } else {
            try {
                warehouseFilter = Integer.parseInt(warehouseParam);
            } catch (NumberFormatException e) {
                warehouseFilter = userWarehouseId;
            }
        }
        
        // Get pagination parameters
        int page = 1;
        int pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        InventoryReportDAO inventoryDAO = new InventoryReportDAO();
        List<InventoryReport> reports = inventoryDAO.getInventoryReportWithFilters(
                productFilter, warehouseFilter, supplierFilter, stockLevel, page, pageSize);
        
        int totalReports = inventoryDAO.getTotalFilteredCount(
                productFilter, warehouseFilter, supplierFilter, stockLevel);
        int totalPages = (int) Math.ceil((double) totalReports / pageSize);
        
        // Get all warehouses for dropdown
        WarehouseDAO warehouseDAO = new WarehouseDAO();
        List<WarehouseDisplay> warehouses = warehouseDAO.getAllWarehouses();
        
        // Get warehouse statistics for selected warehouse
        int totalProductsAllWarehouses = warehouseDAO.getTotalProductsPerWarehouse(warehouseFilter);
        java.util.Map<Integer, Integer> warehouseProductSummary = warehouseDAO.getWarehouseProductSummaryByWarehouseId(warehouseFilter);
        
        // Determine if selected warehouse is user's warehouse
        boolean isUserWarehouse = warehouseFilter.equals(userWarehouseId);
        
        // Set attributes for JSP
        request.setAttribute("reports", reports);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalReports", totalReports);
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("totalProductsAllWarehouses", totalProductsAllWarehouses);
        request.setAttribute("warehouseProductSummary", warehouseProductSummary);
        request.setAttribute("isWarehouseLocked", false); // Unlock warehouse selection
        request.setAttribute("isUserWarehouse", isUserWarehouse); // For hiding history action if needed
        
        // Set filter values for maintaining state
        request.setAttribute("productFilter", productFilter);
        request.setAttribute("warehouseFilter", warehouseFilter);
        request.setAttribute("supplierFilter", supplierFilter);
        request.setAttribute("stockLevelFilter", stockLevel);
        
        request.getRequestDispatcher("/manager/inventory-report.jsp").forward(request, response);
    }
    
    private void handleExport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get current user from session
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get the assigned warehouse for the current user
        Integer userWarehouseId = WarehouseAuthUtil.getDefaultWarehouseId(currentUser);
        if (userWarehouseId == null) {
            setToastMessage(request, "No warehouse assigned to your account. Please contact administrator.", "error");
            response.sendRedirect(request.getContextPath() + "/manager/inventory-report?action=list");
            return;
        }
        
        // Get filter parameters for export
        String productFilter = request.getParameter("product");
        String supplierFilter = request.getParameter("supplier");
        String stockLevel = request.getParameter("stockLevel");
        
        // Force warehouse filter to user's assigned warehouse
        Integer warehouseFilter = userWarehouseId;
        
        InventoryReportDAO inventoryDAO = new InventoryReportDAO();
        List<InventoryReport> reports = inventoryDAO.getInventoryReportWithFilters(
                productFilter, warehouseFilter, supplierFilter, stockLevel, null, null);
        
        // Set response headers for CSV download
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"inventory_report.csv\"");
        
        // Generate CSV content
        StringBuilder csv = new StringBuilder();
        csv.append("Product Code,Product Name,Unit Cost,Total Value,On Hand,Free to Use,Incoming,Outgoing,Replenishment,Location\n");
        
        for (InventoryReport report : reports) {
            csv.append("\"").append(report.getProductCode()).append("\",");
            csv.append("\"").append(report.getProductName()).append("\",");
            csv.append("\"").append(report.getUnitCost()).append("\",");
            csv.append("\"").append(report.getTotalValue()).append("\",");
            csv.append("\"").append(report.getOnHand()).append("\",");
            csv.append("\"").append(report.getFreeToUse()).append("\",");
            csv.append("\"").append(report.getIncoming()).append("\",");
            csv.append("\"").append(report.getOutgoing()).append("\",");
            csv.append("\"").append(report.getReplenishment()).append("\",");
            csv.append("\"").append(report.getLocation()).append("\"\n");
        }
        
        response.getWriter().print(csv.toString());
        response.getWriter().flush();
    }
    
    private void handleProductHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get current user from session
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get the assigned warehouse for the current user
        Integer userWarehouseId = WarehouseAuthUtil.getDefaultWarehouseId(currentUser);
        if (userWarehouseId == null) {
            setToastMessage(request, "No warehouse assigned to your account. Please contact administrator.", "error");
            response.sendRedirect(request.getContextPath() + "/manager/inventory-report?action=list");
            return;
        }
        
        // Get parameters
        String productIdStr = request.getParameter("productId");
        String transactionType = request.getParameter("transactionType");
        
        if (productIdStr == null || productIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/inventory-report?action=list");
            return;
        }
        
        Integer productId = null;
        try {
            productId = Integer.parseInt(productIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/manager/inventory-report?action=list");
            return;
        }
        
        // Get pagination parameters
        int page = 1;
        int pageSize = 15;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        InventoryHistoryDAO historyDAO = new InventoryHistoryDAO();
        // Get history only for the user's assigned warehouse
        List<InventoryHistory> history = historyDAO.getProductInventoryHistoryByWarehouse(
                productId, userWarehouseId, transactionType, page, pageSize);
        
        int totalHistory = historyDAO.getTotalHistoryCountByWarehouse(productId, userWarehouseId, transactionType);
        int totalPages = (int) Math.ceil((double) totalHistory / pageSize);
        
        // Get product info for display
        if (!history.isEmpty()) {
            InventoryHistory firstRecord = history.get(0);
            request.setAttribute("productCode", firstRecord.getProductCode());
            request.setAttribute("productName", firstRecord.getProductName());
        }
        
        // Set attributes for JSP
        request.setAttribute("history", history);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalHistory", totalHistory);
        request.setAttribute("productId", productId);
        request.setAttribute("transactionTypeFilter", transactionType);
        
        request.getRequestDispatcher("/manager/inventory-history.jsp").forward(request, response);
    }
    
    private void setToastMessage(HttpServletRequest request, String message, String type) {
        HttpSession session = request.getSession();
        session.setAttribute("toastMessage", message);
        session.setAttribute("toastType", type);
    }
}