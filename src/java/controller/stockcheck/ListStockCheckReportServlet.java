package controller.stockcheck;

import dao.StockCheckReportDAO;
import dao.WarehouseDAO; // Add to get warehouse list for filter
import dao.AuthorizationUtil;
import model.StockCheckReport;
import model.User;
import model.WarehouseDisplay; // Add

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;


@WebServlet(name = "ListStockCheckReportServlet", urlPatterns = {"/manager/list-stock-check-reports", "/staff/list-stock-check-reports"})
public class ListStockCheckReportServlet extends HttpServlet {

    private static final String STATUS_DRAFT = "Draft";

    private StockCheckReportDAO stockCheckReportDAO;
    private WarehouseDAO warehouseDAO; // Add

    @Override
    public void init() throws ServletException {
        stockCheckReportDAO = new StockCheckReportDAO();
        warehouseDAO = new WarehouseDAO(); // Initialize
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
        
        String warehouseIdStr = request.getParameter("warehouseId");
        String status = request.getParameter("status");
        String fromDateStr = request.getParameter("fromDate");
        String toDateStr = request.getParameter("toDate");
        String reportCode = request.getParameter("reportCode");

        Integer warehouseId = null;
        int userWarehouseId = currentUser.getWarehouseId();

        if (AuthorizationUtil.isWarehouseManager(currentUser) || AuthorizationUtil.isWarehouseStaff(currentUser)) {
            warehouseId = userWarehouseId;
        } else {
            if (warehouseIdStr != null && !warehouseIdStr.isEmpty()) {
                try {
                    warehouseId = Integer.parseInt(warehouseIdStr);
                } catch (NumberFormatException e) { /* Ignore */ }
            }
        }

        Date fromDate = null;
        if (fromDateStr != null && !fromDateStr.isEmpty()) {
            try {
                fromDate = new SimpleDateFormat("yyyy-MM-dd").parse(fromDateStr);
            } catch (ParseException e) { /* Ignore */ }
        }

        Date toDate = null;
        if (toDateStr != null && !toDateStr.isEmpty()) {
            try {
                toDate = new SimpleDateFormat("yyyy-MM-dd").parse(toDateStr);
            } catch (ParseException e) { /* Ignore */ }
        }
        
        Integer userIdFilter = null;

        // Staff members can only ever see their own reports, regardless of status.
        if (AuthorizationUtil.isWarehouseStaff(currentUser) && AuthorizationUtil.isWarehouseManager(currentUser)) {
            userIdFilter = currentUser.getUserId();
        } 
        // Managers and Admins can see all reports, but when they filter for "Draft",
        // they should only see their own drafts.
        else if (STATUS_DRAFT.equals(status)) {
            userIdFilter = currentUser.getUserId();
        }

        List<StockCheckReport> reports = stockCheckReportDAO.getStockCheckReportsByFilters(warehouseId, status, fromDate, toDate, reportCode, userIdFilter);
        
        request.setAttribute("reports", reports);
        request.setAttribute("currentUser", currentUser); 
        request.setAttribute("selectedWarehouseId", warehouseIdStr);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedFromDate", fromDateStr);
        request.setAttribute("selectedToDate", toDateStr);
        request.setAttribute("searchedReportCode", reportCode);
        
        try {
            List<WarehouseDisplay> warehouses = warehouseDAO.getAllWarehouses();
            request.setAttribute("warehouses", warehouses);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading warehouse list: " + e.getMessage());
        }

        String servletPath = request.getServletPath();
        if (servletPath.startsWith("/staff")) {
            request.getRequestDispatcher("/staff/list-stock-check-reports.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/manager/list-stock-check-reports.jsp").forward(request, response);
        }
    }
}
