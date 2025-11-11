package controller.stock;

import dao.ImportRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import utils.AuthorizationService;

@WebServlet("/manager/approveImportRequest")
public class ApproveImportRequestServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        try {
            int requestId = Integer.parseInt(request.getParameter("id"));
            ImportRequestDAO dao = new ImportRequestDAO();
            dao.updateStatus(requestId, "Processing");
            response.sendRedirect(request.getContextPath()+"/manager/stock-request");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath()+"/manager/importRequestList?error=Failed to approve request");
        }
    }
}
