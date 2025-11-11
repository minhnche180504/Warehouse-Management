package controller.export;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.LoggerUtil;
import utils.PDFExportUtil;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

/**
 * Base servlet for PDF export
 * Extend this for specific export types
 */
@WebServlet(name = "ExportPDFServlet", urlPatterns = {"/export/pdf/*"})
public class ExportPDFServlet extends HttpServlet {
    
    private static final LoggerUtil.Logger logger = LoggerUtil.getLogger(ExportPDFServlet.class);
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Export type not specified");
                return;
            }
            
            // Parse export type from path
            String exportType = pathInfo.substring(1); // Remove leading /
            
            byte[] pdfBytes = generatePDF(exportType, request);
            
            if (pdfBytes == null || pdfBytes.length == 0) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to generate PDF");
                return;
            }
            
            // Set response headers
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + exportType + ".pdf\"");
            response.setContentLength(pdfBytes.length);
            
            // Write PDF to response
            try (OutputStream out = response.getOutputStream()) {
                out.write(pdfBytes);
                out.flush();
            }
            
            logger.info("PDF exported successfully: {}", exportType);
            
        } catch (Exception e) {
            logger.error("Error exporting PDF", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error generating PDF");
        }
    }
    
    /**
     * Generate PDF based on export type
     * Override this method in subclasses for specific exports
     */
    protected byte[] generatePDF(String exportType, HttpServletRequest request) {
        // Default implementation - override in subclasses
        String title = "Export Report";
        String[] headers = {"Column 1", "Column 2", "Column 3"};
        List<String[]> data = new ArrayList<>();
        data.add(new String[]{"Data 1", "Data 2", "Data 3"});
        
        return PDFExportUtil.generatePDF(title, headers, data);
    }
}

