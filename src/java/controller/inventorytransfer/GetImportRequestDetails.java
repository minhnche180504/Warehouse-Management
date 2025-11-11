package controller.inventorytransfer;

import dao.ImportRequestDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ImportRequest;
import model.ImportRequestDetail;
import utils.AuthorizationService;

@WebServlet(name = "GetImportRequestDetails", urlPatterns = {"/get-import-request-details"})
public class GetImportRequestDetails extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        StringBuilder jsonResponse = new StringBuilder();
        
        try {
            String requestIdParam = request.getParameter("requestId");
            if (requestIdParam == null || requestIdParam.isEmpty()) {
                out.print("{\"success\": false, \"message\": \"Request ID is required\"}");
                return;
            }
            
            int requestId = Integer.parseInt(requestIdParam);
            
            ImportRequestDAO importRequestDAO = new ImportRequestDAO();
            ImportRequest importRequest = importRequestDAO.getById(requestId);
            
            if (importRequest == null) {
                out.print("{\"success\": false, \"message\": \"Import request not found\"}");
                return;
            }
            
            // Get the details for this import request
            List<ImportRequestDetail> details = importRequest.getDetails();
            
            if (details == null || details.isEmpty()) {
                out.print("{\"success\": false, \"message\": \"No details found for this import request\"}");
                return;
            }
            
            // Build JSON response manually
            jsonResponse.append("{\"success\": true, \"details\": [");
            
            for (int i = 0; i < details.size(); i++) {
                ImportRequestDetail detail = details.get(i);
                if (i > 0) {
                    jsonResponse.append(",");
                }
                jsonResponse.append("{");
                jsonResponse.append("\"productId\": ").append(detail.getProductId()).append(",");
                jsonResponse.append("\"quantity\": ").append(detail.getQuantity()).append(",");
                jsonResponse.append("\"productName\": \"").append(escapeJson(detail.getProductName())).append("\",");
                jsonResponse.append("\"productCode\": \"").append(escapeJson(detail.getProductCode())).append("\"");
                jsonResponse.append("}");
            }
            
            jsonResponse.append("]}");
            
        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Invalid request ID format\"}");
            return;
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\": false, \"message\": \"An error occurred: " + escapeJson(e.getMessage()) + "\"}");
            return;
        }
        
        out.print(jsonResponse.toString());
        out.flush();
    }
    
    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }

    @Override
    public String getServletInfo() {
        return "Get Import Request Details Servlet";
    }
}
