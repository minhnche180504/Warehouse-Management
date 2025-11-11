package controller.stock;

import dao.ImportRequestDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Nguyen Duc Thinh
 */
@WebServlet("/manager/process-import-request")
public class ProcessImportRequestServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy các tham số từ form
        int requestId = Integer.parseInt(request.getParameter("requestId"));
        String orderType = request.getParameter("orderType"); // Lấy orderType từ form
        String action = request.getParameter("action");
        String rejectionReason = request.getParameter("rejectionReason");

        System.out.println("Received Order Type: " + orderType); // Kiểm tra giá trị orderType

        ImportRequestDAO dao = new ImportRequestDAO();

        // Xử lý yêu cầu phê duyệt hoặc từ chối
        if ("approve".equalsIgnoreCase(action)) {
            if (orderType != null && !orderType.isEmpty()) {
                dao.approveRequests(requestId, orderType);
                request.setAttribute("message", "Request has been approved successfully.");
            } else {
                request.setAttribute("message", "Order Type is missing.");
            }
        } else if ("reject".equalsIgnoreCase(action)) {
            dao.rejectRequests(requestId, rejectionReason, orderType);
            request.setAttribute("message", "Request has been rejected successfully.");
        } else {
            request.setAttribute("message", "Invalid action.");
        }

        // Quay lại trang danh sách yêu cầu hoặc trang chi tiết yêu cầu
        request.getRequestDispatcher("/manager/stock-request").forward(request, response);
    }
}

