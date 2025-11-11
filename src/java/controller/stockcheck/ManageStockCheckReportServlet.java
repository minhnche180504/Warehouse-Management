package controller.stockcheck;

import dao.ProductDAO;
import dao.StockCheckReportDAO;
import dao.WarehouseDAO;
import dao.InventoryDAO;
import model.Product;
import model.StockCheckReport;
import model.StockCheckReportItem;
import model.User;
import model.WarehouseDisplay;
import dao.AuthorizationUtil;
import model.Inventory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ManageStockCheckReportServlet", urlPatterns = {"/manager/manage-stock-check-report", "/staff/manage-stock-check-report"})
public class ManageStockCheckReportServlet extends HttpServlet {

    private StockCheckReportDAO stockCheckReportDAO;
    private WarehouseDAO warehouseDAO;
    private ProductDAO productDAO;
    private InventoryDAO inventoryDAO;

    @Override
    public void init() throws ServletException {
        stockCheckReportDAO = new StockCheckReportDAO();
        warehouseDAO = new WarehouseDAO();
        productDAO = new ProductDAO();
        inventoryDAO = new InventoryDAO(); // Thêm dòng này
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action"); // view, edit, printPdf
        String reportIdStr = request.getParameter("reportId");

        if (reportIdStr == null || reportIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Invalid report ID.");
            response.sendRedirect(request.getContextPath() + "/manager/list-stock-check-reports");
            return;
        }

        if ("printPdf".equalsIgnoreCase(action)) {
            try {
                int reportId = Integer.parseInt(reportIdStr);
                printStockCheckReportPdf(reportId, request, response);
            } catch (NumberFormatException e) {
                session.setAttribute("errorMessage", "Invalid report ID.");
                response.sendRedirect(request.getContextPath() + "/manager/list-stock-check-reports");
            }
            return;
        }

        // Determine JSP path based on servlet path
        String servletPath = request.getServletPath();
        String jspPath;
        if (servletPath.startsWith("/staff/")) {
            jspPath = "/staff/manage-stock-check-report.jsp";
        } else {
            jspPath = "/manager/manage-stock-check-report.jsp";
        }

        try {
            int reportId = Integer.parseInt(reportIdStr);
            StockCheckReport report = stockCheckReportDAO.getStockCheckReportById(reportId);

            if (report == null) {
                session.setAttribute("errorMessage", "Stock check report not found with ID: " + reportId);
                response.sendRedirect(request.getContextPath() + "/manager/list-stock-check-reports");
                return;
            }

            boolean canEditReport = false;
            boolean isCreator = currentUser.getUserId() == report.getCreatedBy();
            boolean isManager = AuthorizationUtil.isWarehouseManager(currentUser);
            boolean isStaff = AuthorizationUtil.isWarehouseStaff(currentUser);
            
            if ("edit".equalsIgnoreCase(action)) {
                if ((isStaff || isManager)
                        && isCreator
                        && "Draft".equalsIgnoreCase(report.getStatus())) {
                    canEditReport = true;
                } else {
                    session.setAttribute("errorMessage", "You do not have permission to edit this report.");
                    response.sendRedirect(request.getContextPath() + "/manager/manage-stock-check-report?action=view&reportId=" + reportId);
                    return;
                }
            }

            List<WarehouseDisplay> warehouses = warehouseDAO.getAllWarehouses();
            int warehouseId = report.getWarehouseId();
            List<Inventory> products = inventoryDAO.getProductsByWarehouse(warehouseId);

            request.setAttribute("report", report);
            request.setAttribute("warehouses", warehouses);
            request.setAttribute("products", products);
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("viewAction", action == null ? "view" : action);
            request.setAttribute("canEditReport", canEditReport);
            request.setAttribute("isCreator", isCreator);
            request.setAttribute("isManager", isManager);
            request.setAttribute("isStaff", isStaff);

            request.setAttribute("isWarehouseManager", AuthorizationUtil.isWarehouseManager(currentUser));
            request.setAttribute("isWarehouseStaff", AuthorizationUtil.isWarehouseStaff(currentUser));

            String successMessage = (String) session.getAttribute("successMessage");
            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
                session.removeAttribute("successMessage");
            }
            String errorMessage = (String) session.getAttribute("errorMessage");
            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
                session.removeAttribute("errorMessage");
            }

            request.getRequestDispatcher(jspPath).forward(request, response);

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid report ID.");
            response.sendRedirect(request.getContextPath() + "/manager/list-stock-check-reports");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error loading report data: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/manager/list-stock-check-reports");
        }
    }

    private void printStockCheckReportPdf(int reportId, HttpServletRequest request, HttpServletResponse response) throws IOException {
        StockCheckReport report = stockCheckReportDAO.getStockCheckReportById(reportId);
        if (report == null) {
            response.sendRedirect(request.getContextPath() + "/manager/list-stock-check-reports");
            return;
        }

        // TODO: Implement PDF generation logic here using a PDF library like iText or Apache PDFBox
        // For now, just send a placeholder response
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"stock_check_report_" + report.getReportCode() + ".pdf\"");

        // Example: write simple PDF content (replace with real PDF generation)
        try (java.io.OutputStream out = response.getOutputStream()) {
            String pdfContent = "Stock Check Report: " + report.getReportCode() + "\\nWarehouse: " + report.getWarehouseName() + "\\nDate: " + report.getReportDate();
            out.write(pdfContent.getBytes());
            out.flush();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String formAction = request.getParameter("formAction");
        String reportIdStr = request.getParameter("reportId");

        if (reportIdStr == null || reportIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Report ID cannot be empty.");
            response.sendRedirect(request.getContextPath() + "/manager/list-stock-check-reports");
            return;
        }

        int reportId = 0;
        try {
            reportId = Integer.parseInt(reportIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid report ID.");
            response.sendRedirect(request.getContextPath() + "/manager/list-stock-check-reports");
            return;
        }

        try {
            switch (formAction) {
                case "update":
                    handleUpdate(request, response, currentUser, reportId);
                    break;
                case "delete":
                    handleDelete(request, response, currentUser, reportId);
                    break;
                case "approve":
                    handleApprove(request, response, currentUser, reportId);
                    break;
                case "reject":
                    handleReject(request, response, currentUser, reportId);
                    break;
                case "complete":
                    handleComplete(request, response, currentUser, reportId);
                    break;
                default:
                    session.setAttribute("errorMessage", "Invalid action.");
                    response.sendRedirect(request.getContextPath() + "/manager/list-stock-check-reports");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "A system error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/manager/manage-stock-check-report?action=view&reportId=" + reportId);
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, User currentUser, int reportId) throws ServletException, IOException {
        StockCheckReport existingReport = stockCheckReportDAO.getStockCheckReportById(reportId);
        if (existingReport == null) {
            request.getSession().setAttribute("errorMessage", "Report to update not found (ID: " + reportId + ").");
            response.sendRedirect(request.getContextPath() + "/manager/list-stock-check-reports");
            return;
        }

        if (!((AuthorizationUtil.isWarehouseStaff(currentUser) || AuthorizationUtil.isWarehouseManager(currentUser))
                && currentUser.getUserId() == existingReport.getCreatedBy())) {
            request.getSession().setAttribute("errorMessage", "You do not have permission to update this report.");
            response.sendRedirect(request.getContextPath() + "/manager/manage-stock-check-report?action=view&reportId=" + reportId);
            return;
        }

        if (!"Draft".equalsIgnoreCase(existingReport.getStatus())) {
            request.getSession().setAttribute("errorMessage", "Only reports with 'Draft' status can be updated.");
            response.sendRedirect(request.getContextPath() + "/manager/manage-stock-check-report?action=view&reportId=" + reportId);
            return;
        }

        try {
            String reportCode = request.getParameter("reportCode");
            int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
            String reportDateStr = request.getParameter("reportDate");
            String notes = request.getParameter("notes");

            if (reportCode == null || reportCode.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Report code cannot be empty.");
                preserveAndForwardToManagePage(request, response, existingReport, "edit");
                return;
            }
            reportCode = reportCode.trim();
            if (!existingReport.getReportCode().equals(reportCode) && stockCheckReportDAO.isReportCodeExists(reportCode, reportId)) {
                request.setAttribute("errorMessage", "Report code '" + reportCode + "' already exists.");
                existingReport.setReportCode(reportCode);
                preserveAndForwardToManagePage(request, response, existingReport, "edit");
                return;
            }
            if (warehouseId <= 0) {
                request.setAttribute("errorMessage", "Please select a warehouse.");
                preserveAndForwardToManagePage(request, response, existingReport, "edit");
                return;
            }
            if (reportDateStr == null || reportDateStr.isEmpty()) {
                request.setAttribute("errorMessage", "Report date cannot be empty.");
                preserveAndForwardToManagePage(request, response, existingReport, "edit");
                return;
            }
            Date reportDate = Date.valueOf(reportDateStr);

            existingReport.setReportCode(reportCode);
            existingReport.setWarehouseId(warehouseId);
            existingReport.setReportDate(reportDate);
            existingReport.setNotes(notes);

            List<StockCheckReportItem> items = new ArrayList<>();
            String[] productIds = request.getParameterValues("productId");
            String[] systemQuantities = request.getParameterValues("systemQuantity");
            String[] countedQuantities = request.getParameterValues("countedQuantity");
            String[] reasons = request.getParameterValues("reason");

            if (productIds != null) {
                for (int i = 0; i < productIds.length; i++) {
                    if (productIds[i] == null || productIds[i].trim().isEmpty()) {
                        continue;
                    }

                    int productIdItem;
                    int sysQty;
                    int countedQty;

                    try {
                        productIdItem = Integer.parseInt(productIds[i]);
                    } catch (NumberFormatException e) {
                        request.setAttribute("errorMessage", "Invalid product ID for row " + (i + 1) + ".");
                        preserveAndForwardToManagePage(request, response, existingReport, "edit");
                        return;
                    }
                    if (systemQuantities == null || i >= systemQuantities.length || systemQuantities[i] == null || systemQuantities[i].trim().isEmpty()) {
                        request.setAttribute("errorMessage", "System quantity for product ID '" + productIds[i] + "' (row " + (i + 1) + ") cannot be empty.");
                        preserveAndForwardToManagePage(request, response, existingReport, "edit");
                        return;
                    }
                    try {
                        sysQty = Integer.parseInt(systemQuantities[i]);
                        if (sysQty < 0) {
                            request.setAttribute("errorMessage", "System quantity for product ID '" + productIds[i] + "' (row " + (i + 1) + ") cannot be negative.");
                            preserveAndForwardToManagePage(request, response, existingReport, "edit");
                            return;
                        }
                    } catch (NumberFormatException e) {
                        request.setAttribute("errorMessage", "Invalid system quantity for product ID '" + productIds[i] + "' (row " + (i + 1) + ").");
                        preserveAndForwardToManagePage(request, response, existingReport, "edit");
                        return;
                    }
                    if (countedQuantities == null || i >= countedQuantities.length || countedQuantities[i] == null || countedQuantities[i].trim().isEmpty()) {
                        request.setAttribute("errorMessage", "Counted quantity for product ID '" + productIds[i] + "' (row " + (i + 1) + ") cannot be empty.");
                        preserveAndForwardToManagePage(request, response, existingReport, "edit");
                        return;
                    }
                    try {
                        countedQty = Integer.parseInt(countedQuantities[i]);
                        if (countedQty < 0) {
                            request.setAttribute("errorMessage", "Counted quantity for product ID '" + productIds[i] + "' (row " + (i + 1) + ") cannot be negative.");
                            preserveAndForwardToManagePage(request, response, existingReport, "edit");
                            return;
                        }
                    } catch (NumberFormatException e) {
                        request.setAttribute("errorMessage", "Invalid counted quantity for product ID '" + productIds[i] + "' (row " + (i + 1) + ").");
                        preserveAndForwardToManagePage(request, response, existingReport, "edit");
                        return;
                    }

                    StockCheckReportItem item = new StockCheckReportItem();
                    item.setProductId(productIdItem);
                    item.setSystemQuantity(sysQty);
                    item.setCountedQuantity(countedQty);
                    if (reasons != null && i < reasons.length && reasons[i] != null) {
                        item.setReason(reasons[i].trim());
                    } else {
                        item.setReason("");
                    }
                    items.add(item);
                }
            }
            if (items.isEmpty()) {
                request.setAttribute("errorMessage", "Stock check report must have at least one product.");
                preserveAndForwardToManagePage(request, response, existingReport, "edit");
                return;
            }
            existingReport.setItems(items);

            if (AuthorizationUtil.isWarehouseManager(currentUser)) {
                existingReport.setStatus("Completed");
            } else {
                existingReport.setStatus("Pending");
            }

            boolean success = stockCheckReportDAO.updateStockCheckReport(existingReport);
            if (success) {
                request.getSession().setAttribute("successMessage", "Stock check report " + existingReport.getReportCode() + " has been updated successfully!");
                response.sendRedirect(request.getContextPath() + "/manager/manage-stock-check-report?action=view&reportId=" + reportId);
            } else {
                request.setAttribute("errorMessage", "Error updating stock check report. The report might no longer be in 'Draft' status.");
                preserveAndForwardToManagePage(request, response, existingReport, "edit");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid input data (e.g., warehouse ID, quantity must be a number).");
            preserveAndForwardToManagePage(request, response, existingReport, "edit");
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", "Invalid report date.");
            preserveAndForwardToManagePage(request, response, existingReport, "edit");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "System error on update: " + e.getMessage());
            preserveAndForwardToManagePage(request, response, existingReport, "edit");
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, User currentUser, int reportId) throws IOException {
        StockCheckReport report = stockCheckReportDAO.getStockCheckReportById(reportId);
        if (report == null) {
            request.getSession().setAttribute("errorMessage", "Report to delete not found.");
            response.sendRedirect(request.getContextPath() + getListUrl(request));
            return;
        }
        if (!(currentUser.getUserId() == report.getCreatedBy() && (AuthorizationUtil.isWarehouseStaff(currentUser) || AuthorizationUtil.isWarehouseManager(currentUser)))) {
            request.getSession().setAttribute("errorMessage", "You do not have permission to delete this report.");
            response.sendRedirect(request.getContextPath() + getManageUrl(request, reportId));
            return;
        }
        if (!"Draft".equalsIgnoreCase(report.getStatus())) {
            request.getSession().setAttribute("errorMessage", "Only reports with 'Draft' status can be deleted.");
            response.sendRedirect(request.getContextPath() + getManageUrl(request, reportId));
            return;
        }

        boolean success = stockCheckReportDAO.deleteStockCheckReport(reportId);
        if (success) {
            request.getSession().setAttribute("successMessage", "Stock check report " + report.getReportCode() + " has been deleted successfully.");
            response.sendRedirect(request.getContextPath() + getListUrl(request));
        } else {
            request.getSession().setAttribute("errorMessage", "Error deleting stock check report. The report might no longer be in 'Draft' status.");
            response.sendRedirect(request.getContextPath() + getManageUrl(request, reportId));
        }
    }

    // Helper methods
    private String getListUrl(HttpServletRequest request) {
        String servletPath = request.getServletPath();
        if (servletPath.startsWith("/staff/")) {
            return "/staff/list-stock-check-reports";
        } else {
            return "/manager/list-stock-check-reports";
        }
    }

    private String getManageUrl(HttpServletRequest request, int reportId) {
        String servletPath = request.getServletPath();
        if (servletPath.startsWith("/staff/")) {
            return "/staff/manage-stock-check-report?action=view&reportId=" + reportId;
        } else {
            return "/manager/manage-stock-check-report?action=view&reportId=" + reportId;
        }
    }

    private void handleApprove(HttpServletRequest request, HttpServletResponse response, User currentUser, int reportId) throws IOException {
        StockCheckReport report = stockCheckReportDAO.getStockCheckReportById(reportId);
        if (report == null) {
            request.getSession().setAttribute("errorMessage", "Report not found.");
            response.sendRedirect(request.getContextPath() + "/manager/list-stock-check-reports");
            return;
        }
        if (!AuthorizationUtil.isWarehouseManager(currentUser)) {
            request.getSession().setAttribute("errorMessage", "You do not have permission to approve this report.");
            response.sendRedirect(request.getContextPath() + "/manager/manage-stock-check-report?action=view&reportId=" + reportId);
            return;
        }
        if (!"Pending".equalsIgnoreCase(report.getStatus())) {
            request.getSession().setAttribute("errorMessage", "Only 'Pending' reports can be approved.");
            response.sendRedirect(request.getContextPath() + "/manager/manage-stock-check-report?action=view&reportId=" + reportId);
            return;
        }
        String managerNotes = request.getParameter("managerNotes_approve");
        boolean success = stockCheckReportDAO.approveReport(reportId, currentUser.getUserId(), managerNotes);
        if (success) {
            request.getSession().setAttribute("successMessage", "Report " + report.getReportCode() + " has been approved.");
        } else {
            request.getSession().setAttribute("errorMessage", "Error approving report.");
        }
        response.sendRedirect(request.getContextPath() + "/manager/manage-stock-check-report?action=view&reportId=" + reportId);
    }

    private void handleReject(HttpServletRequest request, HttpServletResponse response, User currentUser, int reportId) throws IOException {
        StockCheckReport report = stockCheckReportDAO.getStockCheckReportById(reportId);
        if (report == null) {
            request.getSession().setAttribute("errorMessage", "Report not found.");
            response.sendRedirect(request.getContextPath() + "/manager/list-stock-check-reports");
            return;
        }
        if (!(AuthorizationUtil.isWarehouseManager(currentUser) && currentUser.getUserId() != report.getCreatedBy())) {
            request.getSession().setAttribute("errorMessage", "You do not have permission to reject this report.");
            response.sendRedirect(request.getContextPath() + "/manager/manage-stock-check-report?action=view&reportId=" + reportId);
            return;
        }
        if (!"Pending".equalsIgnoreCase(report.getStatus())) {
            request.getSession().setAttribute("errorMessage", "Only 'Pending' reports can be rejected.");
            response.sendRedirect(request.getContextPath() + "/manager/manage-stock-check-report?action=view&reportId=" + reportId);
            return;
        }
        String managerNotes = request.getParameter("managerNotes_reject");
        if (managerNotes == null || managerNotes.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Rejection reason cannot be empty.");
            response.sendRedirect(request.getContextPath() + "/manager/manage-stock-check-report?action=view&reportId=" + reportId + "&showRejectModal=true");
            return;
        }
        boolean success = stockCheckReportDAO.rejectReport(reportId, currentUser.getUserId(), managerNotes);
        if (success) {
            request.getSession().setAttribute("successMessage", "Report " + report.getReportCode() + " has been rejected.");
        } else {
            request.getSession().setAttribute("errorMessage", "Error rejecting report.");
        }
        response.sendRedirect(request.getContextPath() + "/manager/manage-stock-check-report?action=view&reportId=" + reportId);
    }

    private void handleComplete(HttpServletRequest request, HttpServletResponse response, User currentUser, int reportId) throws IOException {
        StockCheckReport report = stockCheckReportDAO.getStockCheckReportById(reportId);
        if (report == null) {
            request.getSession().setAttribute("errorMessage", "Report not found.");
            response.sendRedirect(request.getContextPath() + "/manager/list-stock-check-reports");
            return;
        }
        boolean isManager = AuthorizationUtil.isWarehouseManager(currentUser);
        boolean isCreator = currentUser.getUserId() == report.getCreatedBy();
        // Nếu là manager và là creator, cho phép complete khi Pending
        if (isManager && isCreator && "Pending".equalsIgnoreCase(report.getStatus())) {
            boolean success = stockCheckReportDAO.completeReport(reportId);
            if (success) {
                request.getSession().setAttribute("successMessage", "Report " + report.getReportCode() + " has been completed.");
            } else {
                request.getSession().setAttribute("errorMessage", "Error completing report.");
            }
            response.sendRedirect(request.getContextPath() + "/manager/manage-stock-check-report?action=view&reportId=" + reportId);
            return;
        }
        // Logic cũ cho các trường hợp khác
        if (!isManager) {
            request.getSession().setAttribute("errorMessage", "You do not have permission to complete this report.");
            response.sendRedirect(request.getContextPath() + "/manager/manage-stock-check-report?action=view&reportId=" + reportId);
            return;
        }
        if (!"Approved".equalsIgnoreCase(report.getStatus())) {
            request.getSession().setAttribute("errorMessage", "Only 'Approved' reports can be completed.");
            response.sendRedirect(request.getContextPath() + "/manager/manage-stock-check-report?action=view&reportId=" + reportId);
            return;
        }
        boolean success = stockCheckReportDAO.completeReport(reportId);
        if (success) {
            request.getSession().setAttribute("successMessage", "Report " + report.getReportCode() + " has been completed.");
        } else {
            request.getSession().setAttribute("errorMessage", "Error completing report.");
        }
        response.sendRedirect(request.getContextPath() + "/manager/manage-stock-check-report?action=view&reportId=" + reportId);
    }

    private void preserveAndForwardToManagePage(HttpServletRequest request, HttpServletResponse response, StockCheckReport report, String viewAction) throws ServletException, IOException {
        try {
            List<WarehouseDisplay> warehouses = warehouseDAO.getAllWarehouses();
            int warehouseId = report.getWarehouseId();
            List<Inventory> products = inventoryDAO.getProductsByWarehouse(warehouseId);
            request.setAttribute("warehouses", warehouses);
            request.setAttribute("products", products);
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("report", report);
        request.setAttribute("viewAction", viewAction);
        request.setAttribute("currentUser", request.getSession().getAttribute("user"));
        // Determine JSP path based on servlet path
        String servletPath = request.getServletPath();
        String jspPath;
        if (servletPath.startsWith("/staff/")) {
            jspPath = "/staff/manage-stock-check-report.jsp";
        } else {
            jspPath = "/manager/manage-stock-check-report.jsp";
        }
        request.getRequestDispatcher(jspPath).forward(request, response);
    }
}
