package controller.product;

import dao.ProductDAO;
import dao.ProductAttributeDAO;
import dao.UnitDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;
import model.ProductAttribute;
import model.Unit;
import utils.AuthorizationService;
import utils.ProductAttributeHelper;

/**
 * Servlet for handling product editing
 */
@WebServlet(name = "EditProduct", urlPatterns = {"/admin/edit-product"})
public class EditProduct extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        try {
            // Get product ID from request
            String productIdStr = request.getParameter("id");
            
            if (productIdStr == null || productIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath()+"/admin/list-product");
                return;
            }
            
            int productId;
            try {
                productId = Integer.parseInt(productIdStr);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath()+"/admin/list-product");
                return;
            }
            
            // Get product by ID
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.getById(productId);
            if (product == null) {
                response.sendRedirect(request.getContextPath()+"/admin/list-product");
                return;
            }
            
            // Get all active units for dropdown
            UnitDAO unitDAO = new UnitDAO();
            List<Unit> units = unitDAO.getAllActive();
            request.setAttribute("units", units);
            
            // Set product in request scope
            request.setAttribute("product", product);
            
            // Forward to product edit JSP
            request.getRequestDispatcher("/admin/product-edit.jsp").forward(request, response);
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
            // Get form parameters
            String productIdStr = request.getParameter("product_id");
            String code = request.getParameter("code");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String unitIdStr = request.getParameter("unit_id");
            String supplierIdStr = request.getParameter("supplier_id");
            
            // Validate product ID
            if (productIdStr == null || productIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath()+"/admin/list-product");
                return;
            }
            
            int productId;            
            try {
                productId = Integer.parseInt(productIdStr);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath()+"/admin/list-product");
                return;
            }
            
            // Validate required fields
            if (code == null || code.trim().isEmpty() || name == null || name.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Product code and name are required");
                
                // Retrieve product for form re-display
                ProductDAO dao = new ProductDAO();
                Product product = dao.getById(productId);
                request.setAttribute("product", product);
                
                // Get units for dropdown re-display
                UnitDAO unitDAO = new UnitDAO();
                List<Unit> units = unitDAO.getAllActive();
                request.setAttribute("units", units);
                
                request.getRequestDispatcher("/admin/product-edit.jsp").forward(request, response);
                return;
            }
            
            // Create product object for update
            Product product = new Product();
            product.setProductId(productId);
            product.setCode(code);
            product.setName(name);
            product.setDescription(description);
            
            // Process unit ID
            if (unitIdStr != null && !unitIdStr.trim().isEmpty()) {
                try {
                    int unitId = Integer.parseInt(unitIdStr);
                    product.setUnitId(unitId);
                    
                    // Get Unit object to set name and code
                    UnitDAO unitDAO = new UnitDAO();
                    Unit unit = unitDAO.getById(unitId);
                    if (unit != null) {
                        product.setUnitName(unit.getUnitName());
                        product.setUnitCode(unit.getUnitCode());
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid unit ID format");
                    
                    // Get units for dropdown re-display
                    UnitDAO unitDAO = new UnitDAO();
                    List<Unit> units = unitDAO.getAllActive();
                    request.setAttribute("units", units);
                    
                    request.setAttribute("product", product);
                    request.getRequestDispatcher("/admin/product-edit.jsp").forward(request, response);
                    return;
                }
            }
            
            // Parse supplier ID
            if (supplierIdStr != null && !supplierIdStr.trim().isEmpty()) {
                try {
                    Integer supplierId = Integer.parseInt(supplierIdStr);
                    product.setSupplierId(supplierId);
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid supplier ID format");
                    request.setAttribute("product", product);
                    
                    // Get units for dropdown re-display
                    UnitDAO unitDAO = new UnitDAO();
                    List<Unit> units = unitDAO.getAllActive();
                    request.setAttribute("units", units);
                    
                    request.getRequestDispatcher("/admin/product-edit.jsp").forward(request, response);
                    return;
                }
            }
            
            // Check if code already exists (excluding current product)
            ProductDAO productDAO = new ProductDAO();
            if (productDAO.isCodeExists(code, productId)) {
                request.setAttribute("errorMessage", "Product code already exists for another product");
                request.setAttribute("product", product);
                
                // Get units for dropdown re-display
                UnitDAO unitDAO = new UnitDAO();
                List<Unit> units = unitDAO.getAllActive();
                request.setAttribute("units", units);
                
                request.getRequestDispatcher("/admin/product-edit.jsp").forward(request, response);
                return;
            }
            
            // Process product attributes
            List<ProductAttribute> attributes = extractAttributesFromRequest(request, productId);
            product.setAttributes(attributes);
            
            // Update product
            boolean success = productDAO.update(product);
            if (success) {
                // Success - set message and redirect to product list
                request.getSession().setAttribute("successMessage", "Product updated successfully");
                response.sendRedirect(request.getContextPath()+"/admin/list-product");
            } else {
                // Error
                request.setAttribute("errorMessage", "Failed to update product");
                request.setAttribute("product", product);
                
                // Get units for dropdown re-display
                UnitDAO unitDAO = new UnitDAO();
                List<Unit> units = unitDAO.getAllActive();
                request.setAttribute("units", units);
                
                request.getRequestDispatcher("/admin/product-edit.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    /**
     * Extract product attributes from the request parameters
     * @param request The HTTP request containing attribute parameters
     * @param productId The ID of the product
     * @return A list of ProductAttribute objects
     */
    private List<ProductAttribute> extractAttributesFromRequest(HttpServletRequest request, int productId) {
        List<ProductAttribute> attributes = new ArrayList<>();
        Map<String, String> attributeValues = new HashMap<>();
        
        // Process predefined laptop attributes (attr_RAM, attr_CPU, etc.)
        for (String attrName : ProductAttributeHelper.getCommonLaptopAttributeNames()) {
            String paramName = "attr_" + attrName;
            String value = request.getParameter(paramName);
            
            if (value != null && !value.trim().isEmpty()) {
                attributeValues.put(attrName, value.trim());
            }
        }
        
        // Process custom attributes (custom_attr_name_X and custom_attr_value_X)
        Enumeration<String> parameterNames = request.getParameterNames();
        while (parameterNames.hasMoreElements()) {
            String paramName = parameterNames.nextElement();
            
            if (paramName.startsWith("custom_attr_name_")) {
                String index = paramName.substring("custom_attr_name_".length());
                String valueParam = "custom_attr_value_" + index;
                
                String name = request.getParameter(paramName);
                String value = request.getParameter(valueParam);
                
                if (name != null && !name.trim().isEmpty() && 
                    value != null && !value.trim().isEmpty()) {
                    attributeValues.put(name.trim(), value.trim());
                }
            }
        }
        
        // Convert the map to attribute objects
        for (Map.Entry<String, String> entry : attributeValues.entrySet()) {
            ProductAttribute attribute = new ProductAttribute();
            attribute.setProductId(productId);
            attribute.setAttributeName(entry.getKey());
            attribute.setAttributeValue(entry.getValue());
            attributes.add(attribute);
        }
        
        return attributes;
    }

    @Override
    public String getServletInfo() {
        return "Product Editing Servlet";
    }
}
