package controller.product;

import dao.ProductAttributeDAO;
import dao.ProductDAO;
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
 * Servlet for handling product creation
 */
@WebServlet(name = "CreateProduct", urlPatterns = {"/admin/create-product"})
public class CreateProduct extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        try {
            // Get all active units to populate the dropdown
            UnitDAO unitDAO = new UnitDAO();
            List<Unit> units = unitDAO.getAllActive();
            request.setAttribute("units", units);
            
            // Forward to the product creation form
            request.getRequestDispatcher("/admin/product-add.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred loading units: " + e.getMessage());
            request.getRequestDispatcher("/admin/product-add.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get form parameters
            String code = request.getParameter("code");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String unitIdStr = request.getParameter("unit_id");
            String supplierIdStr = request.getParameter("supplier_id");
            
            // Load units for form redisplay if needed
            UnitDAO unitDAO = new UnitDAO();
            List<Unit> units = unitDAO.getAllActive();
            request.setAttribute("units", units);
            
            // Validate required fields
            if (code == null || code.trim().isEmpty() || name == null || name.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Product code and name are required");
                request.getRequestDispatcher("/admin/product-add.jsp").forward(request, response);
                return;
            }
            
            // Create a new product object
            Product product = new Product();
            product.setCode(code);
            product.setName(name);
            product.setDescription(description);
            
            // Parse unit ID
            if (unitIdStr != null && !unitIdStr.trim().isEmpty()) {
                try {
                    int unitId = Integer.parseInt(unitIdStr);
                    product.setUnitId(unitId);
                    
                    // Get Unit object and set it
                    Unit unit = unitDAO.getById(unitId);
                    if (unit != null) {
                        product.setUnitName(unit.getUnitName());
                        product.setUnitCode(unit.getUnitCode());
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Invalid unit ID format");
                    request.getRequestDispatcher("/admin/product-add.jsp").forward(request, response);
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
                    request.getRequestDispatcher("/admin/product-add.jsp").forward(request, response);
                    return;
                }
            }
            
            // Check if code already exists
            ProductDAO productDAO = new ProductDAO();
            if (productDAO.isCodeExists(code, null)) {
                request.setAttribute("errorMessage", "Product code already exists");
                request.getRequestDispatcher("/admin/product-add.jsp").forward(request, response);
                return;
            }
            
            // Create product
            int productId = productDAO.create(product);
            
            if (productId > 0) {
                // Process product attributes
                processProductAttributes(request, productId);
                
                // Success - set message and redirect to product list
                request.getSession().setAttribute("successMessage", "Product created successfully");
                response.sendRedirect(request.getContextPath()+"/admin/list-product");
            } else {
                // Error
                request.setAttribute("errorMessage", "Failed to create product");
                request.getRequestDispatcher("/admin/product-add.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/admin/product-add.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Product Creation Servlet";
    }
    
    private void processProductAttributes(HttpServletRequest request, int productId) {
        try {
            Map<String, String> attributeValues = new HashMap<>();
            
            // Process predefined laptop attributes
            List<String> attributeNames = ProductAttributeHelper.getCommonLaptopAttributeNames();
            for (String attrName : attributeNames) {
                String paramName = "attr_" + attrName;
                String value = request.getParameter(paramName);
                if (value != null && !value.trim().isEmpty()) {
                    attributeValues.put(attrName, value.trim());
                }
            }
            
            // Process custom attributes
            Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                if (paramName.startsWith("custom_attr_name_")) {
                    String index = paramName.substring("custom_attr_name_".length());
                    String nameValue = request.getParameter(paramName);
                    String valueParam = "custom_attr_value_" + index;
                    String attrValue = request.getParameter(valueParam);
                    
                    if (nameValue != null && !nameValue.trim().isEmpty() 
                            && attrValue != null && !attrValue.trim().isEmpty()) {
                        attributeValues.put(nameValue.trim(), attrValue.trim());
                    }
                }
            }
            
            // Create and save attributes
            if (!attributeValues.isEmpty()) {
                ProductAttributeDAO attributeDAO = new ProductAttributeDAO();
                for (Map.Entry<String, String> entry : attributeValues.entrySet()) {
                    ProductAttribute attribute = new ProductAttribute();
                    attribute.setProductId(productId);
                    attribute.setAttributeName(entry.getKey());
                    attribute.setAttributeValue(entry.getValue());
                    attributeDAO.createAttribute(attribute);
                }
            }
        } catch (Exception e) {
            System.err.println("Error processing product attributes: " + e.getMessage());
        }
    }
}
