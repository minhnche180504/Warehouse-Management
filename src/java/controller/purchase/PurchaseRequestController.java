package controller.purchase;

import dao.PurchaseRequestDAO;
import dao.ProductDAO;
import dao.WarehouseDAO;
import dao.UserDAO;
import model.PurchaseRequest;
import model.PurchaseRequestItem;
import model.Product;
import model.Warehouse;
import model.User;
import utils.AuthorizationService;
import utils.WarehouseAuthUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import model.WarehouseDisplay;

@WebServlet(name = "PurchaseRequestController", urlPatterns = {"/manager/purchase-request"})
public class PurchaseRequestController extends HttpServlet {

    private PurchaseRequestDAO purchaseRequestDAO = new PurchaseRequestDAO();
    private ProductDAO productDAO = new ProductDAO();
    private WarehouseDAO warehouseDAO = new WarehouseDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        switch (action) {
            case "list":
                handleList(request, response);
                break;
            case "create":
                handleShowCreateForm(request, response);
                break;
            case "view":
                handleViewDetails(request, response);
                break;
            case "edit":
                handleShowEditForm(request, response);
                break;
            default:
                handleList(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
            return;
        }
        switch (action) {
            case "save":
                handleSavePurchaseRequest(request, response);
                break;
            case "update":
                handleUpdatePurchaseRequest(request, response);
                break;
            case "delete":
                handleDeletePurchaseRequest(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
                break;
        }
    }

    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String statusFilter = request.getParameter("status");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        java.sql.Date startDate = null;
        java.sql.Date endDate = null;
        try {
            if (startDateStr != null && !startDateStr.trim().isEmpty()) {
                startDate = java.sql.Date.valueOf(startDateStr);
            }
            if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                endDate = java.sql.Date.valueOf(endDateStr);
            }
        } catch (IllegalArgumentException e) {
            // Ignore invalid date format
        }

        // Bỏ filter theo user, chỉ filter theo trạng thái và ngày
        List<PurchaseRequest> purchaseRequests = purchaseRequestDAO.getPurchaseRequestsByFilter(statusFilter, startDateStr);

        request.setAttribute("purchaseRequests", purchaseRequests);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("startDate", startDateStr);

        request.getRequestDispatcher("/manager/purchase-request-list.jsp").forward(request, response);
    }

    private void handleShowCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer defaultWarehouseId = WarehouseAuthUtil.getDefaultWarehouseId(currentUser);
        if (defaultWarehouseId == null) {
            setToastMessage(request, "No warehouse assigned to your account. Please contact administrator.", "error");
            response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
            return;
        }
        List<Product> products = productDAO.getAll();
        List<Warehouse> warehouses = warehouseDAO.getAll();
        String nextPRNumber = purchaseRequestDAO.generatePrNumber();

        request.setAttribute("products", products);
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("defaultWarehouseId", defaultWarehouseId);
        request.setAttribute("isWarehouseLocked", true);
        request.setAttribute("nextPRNumber", nextPRNumber);

        request.getRequestDispatcher("/manager/purchase-request-create.jsp").forward(request, response);
    }

    private void handleViewDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
            return;
        }

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int prId = Integer.parseInt(idStr);
            PurchaseRequest pr = purchaseRequestDAO.getPurchaseRequestById(prId);
            if (pr == null) {
                setToastMessage(request, "Purchase request not found!", "error");
                response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
                return;
            }
            if (pr.getRequestedBy() != currentUser.getUserId()) {
                setToastMessage(request, "You don't have permission to view this purchase request!", "error");
                response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
                return;
            }
            // Lấy thông tin warehouseName từ warehouseDAO
            WarehouseDisplay warehouse = warehouseDAO.getWarehouseById(pr.getWarehouseId());
            if (warehouse != null) {
                pr.setWarehouseName(warehouse.getWarehouseName());
            }
            // Lấy thông tin requester name từ UserDAO
            User requester = userDAO.getUserById(pr.getRequestedBy());
            if (requester != null) {
                pr.setRequestedByName(requester.getFullName());
            }
            // Lấy thông tin confirmByName từ UserDAO
            if (pr.getConfirmBy() != null) {
                User confirmer = userDAO.getUserById(pr.getConfirmBy());
                if (confirmer != null) {
                    pr.setConfirmByName(confirmer.getFullName());
                }
            }
            request.setAttribute("purchaseRequest", pr);
            request.getRequestDispatcher("/manager/purchase-request-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid purchase request ID!", "error");
            response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
        }
    }

    private void handleShowEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
            return;
        }

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int prId = Integer.parseInt(idStr);
            PurchaseRequest pr = purchaseRequestDAO.getPurchaseRequestById(prId);
            if (pr == null) {
                setToastMessage(request, "Purchase request not found!", "error");
                response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
                return;
            }
            if (pr.getRequestedBy() != currentUser.getUserId()) {
                setToastMessage(request, "You don't have permission to edit this purchase request!", "error");
                response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
                return;
            }
            List<Product> products = productDAO.getAll();
            List<Warehouse> warehouses = warehouseDAO.getAll();

            request.setAttribute("purchaseRequest", pr);
            request.setAttribute("products", products);
            request.setAttribute("warehouses", warehouses);

            request.getRequestDispatcher("/manager/purchase-request-edit.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid purchase request ID!", "error");
            response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
        }
    }

    private void handleSavePurchaseRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            setToastMessage(request, "Please login to create purchase requests!", "error");
            response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
            return;
        }

        Timestamp requestDate = new Timestamp(System.currentTimeMillis());

        String warehouseIdStr = request.getParameter("warehouseId");
        String preferredDeliveryDateStr = request.getParameter("preferredDeliveryDate");
        String reason = request.getParameter("reason");
        String submitAction = request.getParameter("submitAction");

        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");
        String[] notes = request.getParameterValues("note");

        if (warehouseIdStr == null || warehouseIdStr.trim().isEmpty()) {
            setToastMessage(request, "Please select a warehouse!", "error");
            response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=create");
            return;
        }

        if (productIds == null || productIds.length == 0) {
            setToastMessage(request, "Please add at least one product!", "error");
            response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=create");
            return;
        }
        try {
            int warehouseId = Integer.parseInt(warehouseIdStr);
            Date preferredDeliveryDate = null;
            if (preferredDeliveryDateStr != null && !preferredDeliveryDateStr.trim().isEmpty()) {
                preferredDeliveryDate = Date.valueOf(preferredDeliveryDateStr);
            }

            PurchaseRequest pr = new PurchaseRequest();
            pr.setRequestedBy(currentUser.getUserId());
            pr.setRequestDate(requestDate);
            pr.setWarehouseId(warehouseId);
            pr.setPreferredDeliveryDate(preferredDeliveryDate);
            pr.setReason(reason);
            
            if ("submit".equals(submitAction)) {
                pr.setStatus("Pending");
            } else {
                pr.setStatus("Save Draft");
            }
            
            pr.setCreatedAt(requestDate);

            List<PurchaseRequestItem> items = new ArrayList<>();
            for (int i = 0; i < productIds.length; i++) {
                PurchaseRequestItem item = new PurchaseRequestItem();
                item.setProductId(Integer.parseInt(productIds[i]));
                item.setQuantity(Integer.parseInt(quantities[i]));
                if (notes != null && i < notes.length) {
                    item.setNote(notes[i]);
                }
                items.add(item);
            }
            pr.setItems(items);

            boolean success = purchaseRequestDAO.createPurchaseRequest(pr);
            if (success) {
                setToastMessage(request, "Purchase request created successfully!", "success");
                response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
            } else {
                setToastMessage(request, "Failed to create purchase request!", "error");
                response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=create");
            }
        } catch (Exception e) {
            e.printStackTrace();
            setToastMessage(request, "Invalid input data!", "error");
            response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=create");
        }
    }

    private void handleUpdatePurchaseRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            setToastMessage(request, "Please login to update purchase requests!", "error");
            response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
            return;
        }

        String prIdStr = request.getParameter("prId");
        String preferredDeliveryDateStr = request.getParameter("preferredDeliveryDate");
        String reason = request.getParameter("reason");
        String status = request.getParameter("status");

        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");
        String[] notes = request.getParameterValues("note");

        if (prIdStr == null || prIdStr.trim().isEmpty()) {
            setToastMessage(request, "Invalid purchase request ID!", "error");
            response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
            return;
        }
        if (productIds == null || productIds.length == 0) {
            setToastMessage(request, "Please add at least one product!", "error");
            response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=edit&id=" + prIdStr);
            return;
        }

        try {
            int prId = Integer.parseInt(prIdStr);
            Date preferredDeliveryDate = null;
            if (preferredDeliveryDateStr != null && !preferredDeliveryDateStr.trim().isEmpty()) {
                preferredDeliveryDate = Date.valueOf(preferredDeliveryDateStr);
            }

            PurchaseRequest pr = purchaseRequestDAO.getPurchaseRequestById(prId);
            if (pr == null) {
                setToastMessage(request, "Purchase request not found!", "error");
                response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
                return;
            }
            if (pr.getRequestedBy() != currentUser.getUserId()) {
                setToastMessage(request, "You don't have permission to update this purchase request!", "error");
                response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
                return;
            }

            pr.setPreferredDeliveryDate(preferredDeliveryDate);
            pr.setReason(reason);
            String submitAction = request.getParameter("submitAction");
            if ("submit".equals(submitAction)) {
                pr.setStatus("Pending");
            } else {
                pr.setStatus(pr.getStatus());
            }

            List<PurchaseRequestItem> items = new ArrayList<>();
            for (int i = 0; i < productIds.length; i++) {
                PurchaseRequestItem item = new PurchaseRequestItem();
                item.setProductId(Integer.parseInt(productIds[i]));
                item.setQuantity(Integer.parseInt(quantities[i]));
                if (notes != null && i < notes.length) {
                    item.setNote(notes[i]);
                }
                items.add(item);
            }
            pr.setItems(items);

            boolean success = purchaseRequestDAO.updatePurchaseRequest(pr);
            if (success) {
                setToastMessage(request, "Purchase request updated successfully!", "success");
                response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=view&id=" + prId);
            } else {
                setToastMessage(request, "Failed to update purchase request!", "error");
                response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=edit&id=" + prId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            setToastMessage(request, "Invalid input data!", "error");
            response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
        }
    }

    private void handleDeletePurchaseRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String prIdStr = request.getParameter("id");
        if (prIdStr == null || prIdStr.trim().isEmpty()) {
            setToastMessage(request, "Invalid purchase request ID!", "error");
            response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
            return;
        }

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            setToastMessage(request, "Please login to delete purchase requests!", "error");
            response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
            return;
        }

        try {
            int prId = Integer.parseInt(prIdStr);
            PurchaseRequest pr = purchaseRequestDAO.getPurchaseRequestById(prId);
            if (pr == null) {
                setToastMessage(request, "Purchase request not found!", "error");
                response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
                return;
            }
            if (pr.getRequestedBy() != currentUser.getUserId()) {
                setToastMessage(request, "You don't have permission to delete this purchase request!", "error");
            response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
            return;
        }
            boolean success = purchaseRequestDAO.deletePurchaseRequest(prId);
            if (success) {
                setToastMessage(request, "Purchase request deleted successfully!", "success");
                response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
            } else {
                setToastMessage(request, "Failed to delete purchase request!", "error");
                response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
            }
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid purchase request ID!", "error");
            response.sendRedirect(request.getContextPath() + "/manager/purchase-request?action=list");
        }
    }

    private void setToastMessage(HttpServletRequest request, String message, String type) {
        HttpSession session = request.getSession();
        session.setAttribute("toastMessage", message);
        session.setAttribute("toastType", type);
    }

    @Override
    public String getServletInfo() {
        return "PurchaseRequestController manages purchase request operations including create, list, view, edit, update, and delete";
    }
}
