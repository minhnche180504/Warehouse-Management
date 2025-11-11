package controller.inventorytransfer;

import dao.InventoryTransferDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.InventoryTransfer;
import utils.AuthorizationService;

@WebServlet(name = "ListInventoryTransfer", urlPatterns = {"/manager/list-inventory-transfer"})
public class ListInventoryTransfer extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        try {
            String statusFilter = request.getParameter("status");
            
            InventoryTransferDAO transferDAO = new InventoryTransferDAO();
            List<InventoryTransfer> transfers;
            
            if (statusFilter != null && !statusFilter.isEmpty() && !"all".equals(statusFilter)) {
                transfers = transferDAO.getInventoryTransfersByStatus(statusFilter);
            } else {
                transfers = transferDAO.getAllInventoryTransfers();
            }
            
            request.setAttribute("transfers", transfers);
            request.setAttribute("statusFilter", statusFilter);
            
            request.getRequestDispatcher("/manager/inventory-transfer-list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "List Inventory Transfer Servlet";
    }
}
