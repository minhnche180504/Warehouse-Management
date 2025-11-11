/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.salesorder;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.SaleReportDAO;
import model.SalesReport;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import utils.AuthorizationService;

/**
 *
 * @author nguyen
 */
@WebServlet(name="SalesReportController", urlPatterns={"/sale/sales-report"})
public class SalesReportController extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SalesReportController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SalesReportController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        try {
            String reportType = request.getParameter("type");
            String fromDateStr = request.getParameter("fromDate");
            String toDateStr = request.getParameter("toDate");

            // Mặc định
            if (reportType == null) reportType = "date";

            List<SalesReport> reports = null;
            String type = "";
            Date fromDate, toDate;
            SaleReportDAO dao = new SaleReportDAO();

            if (fromDateStr != null && toDateStr != null && !fromDateStr.isEmpty() && !toDateStr.isEmpty()) {
                // Có bộ lọc - tất cả dữ liệu theo bộ lọc
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                fromDate = sdf.parse(fromDateStr);
                toDate = sdf.parse(toDateStr);

                // Kiểm tra toDate không vượt quá ngày hiện tại
                Date today = new Date();
                today = sdf.parse(sdf.format(today)); 
                if (toDate.after(today)) {
                    request.setAttribute("error", "End date cannot be in the future.");
                    request.getRequestDispatcher("/sale/sales-report.jsp").forward(request, response);
                    return;
                }

                switch (reportType) {
                    case "date":
                        reports = dao.getSummaryReport(fromDate, toDate, "day");
                        type = "date";
                        break;
                    case "month":
                        reports = dao.getSummaryReport(fromDate, toDate, "month");
                        type = "month";
                        break;
                    case "product":
                        reports = dao.getProductReport(fromDate, toDate, "day");
                        type = "product";
                        break;
                    case "customer":
                        reports = dao.getCustomerReport(fromDate, toDate, "day");
                        type = "customer";
                        break;
                    case "supplier":
                        reports = dao.getSupplierReport(fromDate, toDate);
                        type = "supplier";
                        break;
                    case "topproduct":
                        reports = dao.getTopProducts(fromDate, toDate, 10);
                        type = "topproduct";
                        break;
                    default:
                        reports = dao.getSummaryReport(fromDate, toDate, "day");
                        type = "date";
                        break;
                }

                // Tất cả dữ liệu theo bộ lọc
                SalesReport summaryNumbers = dao.getSummaryNumbers(fromDate, toDate);
                List<SalesReport> topProducts = dao.getTopProducts(fromDate, toDate, 5);
                List<SalesReport> topCustomers = dao.getTopCustomers(fromDate, toDate, 5);
                
                request.setAttribute("summaryNumbers", summaryNumbers);
                request.setAttribute("topProducts", topProducts);
                request.setAttribute("topCustomers", topCustomers);

            } else {
                // Không có bộ lọc - mặc định 30 ngày gần nhất (thay vì 7 ngày)
                java.util.Calendar cal = java.util.Calendar.getInstance();
                toDate = cal.getTime();
                cal.add(java.util.Calendar.DATE, -29); // 30 ngày gần nhất
                fromDate = cal.getTime();
                
                reportType = "date";
                type = "date";
                
                System.out.println("Default date range: " + fromDate + " to " + toDate);
                
                reports = dao.getSummaryReport(fromDate, toDate, "day");
                
                // Dữ liệu mặc định cho 30 ngày gần nhất
                SalesReport summaryNumbers = dao.getSummaryNumbers(fromDate, toDate);
                List<SalesReport> topProducts = dao.getTopProducts(fromDate, toDate, 5);
                List<SalesReport> topCustomers = dao.getTopCustomers(fromDate, toDate, 5);
                
                request.setAttribute("summaryNumbers", summaryNumbers);
                request.setAttribute("topProducts", topProducts);
                request.setAttribute("topCustomers", topCustomers);
            }

            System.out.println("reports size: " + (reports == null ? "null" : reports.size()));

            request.setAttribute("reports", reports);
            request.setAttribute("type", type);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error while generating report: " + e.getMessage());
        }
        request.getRequestDispatcher("/sale/sales-report.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
