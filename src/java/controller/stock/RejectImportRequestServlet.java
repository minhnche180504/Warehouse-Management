//package controller.stock;
//
//import dao.ImportRequestDAO;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.*;
//import java.io.IOException;
//
//@WebServlet("/rejectImportRequest")
//public class RejectImportRequestServlet extends HttpServlet {
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        try {
//            int requestId = Integer.parseInt(request.getParameter("id"));
//            ImportRequestDAO dao = new ImportRequestDAO();
//            dao.updateStatus(requestId, "Rejected");
//            response.sendRedirect("stock-request");
//        } catch (Exception e) {
//            e.printStackTrace();
//            response.sendRedirect("importRequestList?error=Failed to reject request");
//        }
//    }
//}
