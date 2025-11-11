package controller.inventorytransfer;

import dao.InventoryTransferDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.InventoryTransfer;
import model.User;
import utils.AuthorizationService;

@WebServlet(name = "ViewInventoryTransfer", urlPatterns = {"/manager/view-inventory-transfer"})
public class ViewInventoryTransfer extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        try {
            HttpSession session = request.getSession();
            User loggedInUser = (User) session.getAttribute("user");

            if (loggedInUser == null) {
                response.sendRedirect("login");
                return;
            }
            
            String transferIdParam = request.getParameter("id");
            if (transferIdParam == null || transferIdParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/manager/list-inventory-transfer");
                return;
            }

            int transferId = Integer.parseInt(transferIdParam);
            InventoryTransferDAO transferDAO = new InventoryTransferDAO();
            InventoryTransfer transfer = transferDAO.getInventoryTransferById(transferId);

            if (transfer == null) {
                request.setAttribute("errorMessage", "Inventory transfer not found.");
                response.sendRedirect(request.getContextPath() + "/manager/list-inventory-transfer");
                return;
            }

            request.setAttribute("transfer", transfer);
            request.setAttribute("currentUser", loggedInUser);
            request.getRequestDispatcher("/manager/inventory-transfer-view.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            User loggedInUser = (User) session.getAttribute("user");

            if (loggedInUser == null) {
                response.sendRedirect("login");
                return;
            }

            String action = request.getParameter("action");
            String transferIdParam = request.getParameter("transferId");
            
            if (transferIdParam == null || transferIdParam.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/manager/list-inventory-transfer");
                return;
            }

            int transferId = Integer.parseInt(transferIdParam);
            InventoryTransferDAO transferDAO = new InventoryTransferDAO();
            InventoryTransfer transfer = transferDAO.getInventoryTransferById(transferId);

            if (transfer == null) {
                session.setAttribute("errorMessage", "Inventory transfer not found.");
                response.sendRedirect(request.getContextPath() + "/manager/list-inventory-transfer");
                return;
            }

            boolean success = false;
            String successMessage = "";

            switch (action) {
                case "delete":
                    if ("draft".equals(transfer.getStatus())) {
                        success = transferDAO.deleteInventoryTransfer(transferId);
                        successMessage = "Inventory transfer deleted successfully!";
                    } else {
                        session.setAttribute("errorMessage", "Only draft transfers can be deleted.");
                        response.sendRedirect(request.getContextPath() + "/manager/view-inventory-transfer?id=" + transferId);
                        return;
                    }
                    break;

                case "approve":
                    if ("pending".equals(transfer.getStatus())) {
                        // Check if current user's warehouse matches source warehouse
                        if (loggedInUser.getWarehouseId() == null || !loggedInUser.getWarehouseId().equals(transfer.getSourceWarehouseId())) {
                            session.setAttribute("errorMessage", "Only source warehouse manager can approve this transfer.");
                            response.sendRedirect(request.getContextPath() + "/manager/view-inventory-transfer?id=" + transferId);
                            return;
                        }
                        
                        transfer.setStatus("processing");
                        success = transferDAO.updateInventoryTransfer(transfer);
                        successMessage = "Inventory transfer approved successfully!";
                        
                        if (success) {
//                            InventoryDAO inventoryDAO = new InventoryDAO();
//                            try {
//                                for (InventoryTransferItem item : transfer.getItems()) {
//                                    if (!inventoryDAO.updateInventory(item.getProductId(), transfer.getSourceWarehouseId(), -item.getQuantity())) {
//                                        break;
//                                    }
//                                    if (inventoryDAO.getCurrentStock(item.getProductId(), transfer.getDestinationWarehouseId()) == 0) {
//                                        inventoryDAO.createInventoryRecord(item.getProductId(), transfer.getDestinationWarehouseId(), 0);
//                                    }
//                                    if (!inventoryDAO.updateInventory(item.getProductId(), transfer.getDestinationWarehouseId(), item.getQuantity())) {
//                                        break;
//                                    }
//                                }
//                            } catch (Exception e) {
//                                e.printStackTrace();
//                                session.setAttribute("errorMessage", "Transfer approved but inventory update failed: " + e.getMessage());
//                                response.sendRedirect("view-inventory-transfer?id=" + transferId);
//                                return;
//                            }
                        }
                    } else {
                        session.setAttribute("errorMessage", "Only pending transfers can be approved.");
                        response.sendRedirect(request.getContextPath() + "/manager/view-inventory-transfer?id=" + transferId);
                        return;
                    }
                    break;

                case "reject":
                    if ("pending".equals(transfer.getStatus())) {
                        // Check if current user's warehouse matches source warehouse
                        if (loggedInUser.getWarehouseId() == null || !loggedInUser.getWarehouseId().equals(transfer.getSourceWarehouseId())) {
                            session.setAttribute("errorMessage", "Only source warehouse manager can reject this transfer.");
                            response.sendRedirect(request.getContextPath() + "/manager/view-inventory-transfer?id=" + transferId);
                            return;
                        }
                        
                         transfer.setStatus("rejected");
                        success = transferDAO.updateInventoryTransfer(transfer);
                        successMessage = "Inventory transfer rejected successfully!";
                    } else {
                        session.setAttribute("errorMessage", "Only pending transfers can be rejected.");
                        response.sendRedirect(request.getContextPath() + "/manager/view-inventory-transfer?id=" + transferId);
                        return;
                    }
                    break;

                case "submit":
                    if ("draft".equals(transfer.getStatus())) {
                        transfer.setStatus("pending");
                        success = transferDAO.updateInventoryTransfer(transfer);
                        successMessage = "Inventory transfer submitted successfully!";
                    } else {
                        session.setAttribute("errorMessage", "Only draft transfers can be submitted.");
                        response.sendRedirect(request.getContextPath() + "/manager/view-inventory-transfer?id=" + transferId);
                        return;
                    }
                    break;

                default:
                    session.setAttribute("errorMessage", "Invalid action.");
                    response.sendRedirect(request.getContextPath() + "/manager/view-inventory-transfer?id=" + transferId);
                    return;
            }

            if (success) {
                session.setAttribute("successMessage", successMessage);
                if ("delete".equals(action)) {
                    response.sendRedirect(request.getContextPath() + "/manager/list-inventory-transfer");
                } else {
                    response.sendRedirect(request.getContextPath() + "/manager/view-inventory-transfer?id=" + transferId);
                }
            } else {
                session.setAttribute("errorMessage", "Operation failed. Please try again.");
                response.sendRedirect(request.getContextPath() + "/manager/view-inventory-transfer?id=" + transferId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "View Inventory Transfer Servlet";
    }
}
