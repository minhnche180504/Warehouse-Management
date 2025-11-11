package controller.supplier;

import dao.SupplierDAO;
import model.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import utils.AuthorizationService;

@WebServlet(name = "ManageSupplierController", urlPatterns = {"/purchase/manage-supplier"})
public class ManageSupplierController extends HttpServlet {

    private SupplierDAO supplierDAO = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
         AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                handleListWithFilters(request, response);
                break;
            case "add":
                handleShowAddForm(request, response);
                break;
            case "edit":
                handleShowEditForm(request, response);
                break;
            case "delete":
                handleDelete(request, response);
                break;
            case "restore":
                handleRestore(request, response);
                break;
            case "check-duplicate":
                handleCheckDuplicate(request, response);
                break;
            default:
                handleListWithFilters(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect(request.getContextPath()+"/purchase/manage-supplier?action=list");
            return;
        }
        
        switch (action) {
            case "create":
                handleCreate(request, response);
                break;
            case "update":
                handleUpdate(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath()+"/purchase/manage-supplier?action=list");
                break;
        }
    }

    private void handleListWithFilters(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get filter parameters
        String nameFilter = request.getParameter("name");
        String emailFilter = request.getParameter("email");
        String phoneFilter = request.getParameter("phone");
        String contactPersonFilter = request.getParameter("contactPerson");
        String statusFilter = request.getParameter("status");

        // Get pagination parameters
        Integer page = 1;
        Integer pageSize = 10;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        List<Supplier> suppliers = supplierDAO.findSuppliersWithFilters(
                nameFilter, emailFilter, phoneFilter, contactPersonFilter, statusFilter, page, pageSize);

        Integer totalSuppliers = supplierDAO.getTotalFilteredSuppliers(
                nameFilter, emailFilter, phoneFilter, contactPersonFilter, statusFilter);
        Integer totalPages = (int) Math.ceil((double) totalSuppliers / pageSize);

        // Set attributes for JSP
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalSuppliers", totalSuppliers);

        // Set filter values for maintaining state
        request.setAttribute("nameFilter", nameFilter);
        request.setAttribute("emailFilter", emailFilter);
        request.setAttribute("phoneFilter", phoneFilter);
        request.setAttribute("contactPersonFilter", contactPersonFilter);
        request.setAttribute("statusFilter", statusFilter);

        request.getRequestDispatcher("/purchase/manage-supplier.jsp").forward(request, response);
    }

    private void handleShowAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/purchase/add-supplier.jsp").forward(request, response);
    }

    private void handleShowEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()+"/purchase/manage-supplier?action=list");
            return;
        }

        try {
            Integer supplierId = Integer.parseInt(idStr);
            Supplier supplier = supplierDAO.getByIdIncludeDeleted(supplierId);
            
            if (supplier != null) {
                if (supplier.getIsDelete()) {
                    setToastMessage(request, "Cannot edit deleted supplier. Please restore it first!", "error");
                    response.sendRedirect(request.getContextPath()+"/purchase/manage-supplier?action=list");
                    return;
                }
                request.setAttribute("supplier", supplier);
                request.getRequestDispatcher("/purchase/edit-supplier.jsp").forward(request, response);
            } else {
                setToastMessage(request, "Supplier not found!", "error");
                response.sendRedirect(request.getContextPath()+"/purchase/manage-supplier?action=list");
            }
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid supplier ID!", "error");
            response.sendRedirect(request.getContextPath()+"/purchase/manage-supplier?action=list");
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get form parameters
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String contactPerson = request.getParameter("contactPerson");

        // Perform comprehensive validation
        String validationError = validateSupplierFields(name, email, phone, address, contactPerson, null);
        if (validationError != null) {
            request.setAttribute("errorMessage", validationError);
            preserveFormData(request, name, address, phone, email, contactPerson);
            request.getRequestDispatcher("/purchase/add-supplier.jsp").forward(request, response);
            return;
        }

        // Check if name already exists
        if (supplierDAO.isNameExists(name.trim(), null)) {
            request.setAttribute("errorMessage", "Supplier name already exists");
            preserveFormData(request, name, address, phone, email, contactPerson);
            request.getRequestDispatcher("/purchase/add-supplier.jsp").forward(request, response);
            return;
        }

        // Check if phone already exists
        if (supplierDAO.isPhoneExists(phone.trim(), null)) {
            request.setAttribute("errorMessage", "Phone number already exists");
            preserveFormData(request, name, address, phone, email, contactPerson);
            request.getRequestDispatcher("/purchase/add-supplier.jsp").forward(request, response);
            return;
        }

        // Check if email already exists
        if (supplierDAO.isEmailExists(email.trim(), null)) {
            request.setAttribute("errorMessage", "Email address already exists");
            preserveFormData(request, name, address, phone, email, contactPerson);
            request.getRequestDispatcher("/purchase/add-supplier.jsp").forward(request, response);
            return;
        }

        // Create supplier object
        Supplier supplier = Supplier.builder()
                .name(name.trim())
                .address(address != null && !address.trim().isEmpty() ? address.trim() : null)
                .phone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null)
                .email(email != null && !email.trim().isEmpty() ? email.trim() : null)
                .contactPerson(contactPerson != null && !contactPerson.trim().isEmpty() ? contactPerson.trim() : null)
                .build();

        // Insert supplier
        Integer supplierId = supplierDAO.insert(supplier);

        if (supplierId > 0) {
            setToastMessage(request, "Supplier created successfully!", "success");
            response.sendRedirect(request.getContextPath()+"/purchase/manage-supplier?action=list");
        } else {
            request.setAttribute("errorMessage", "Failed to create supplier");
            preserveFormData(request, name, address, phone, email, contactPerson);
            request.getRequestDispatcher("/purchase/add-supplier.jsp").forward(request, response);
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()+"/purchase/manage-supplier?action=list");
            return;
        }

        try {
            Integer supplierId = Integer.parseInt(idStr);
            
            // Get form parameters
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String contactPerson = request.getParameter("contactPerson");

            // Perform comprehensive validation
            String validationError = validateSupplierFields(name, email, phone, address, contactPerson, supplierId);
            if (validationError != null) {
                Supplier supplier = supplierDAO.getById(supplierId);
                request.setAttribute("supplier", supplier);
                request.setAttribute("errorMessage", validationError);
                request.getRequestDispatcher("/purchase/edit-supplier.jsp").forward(request, response);
                return;
            }

            // Check if name already exists (excluding current supplier)
            if (supplierDAO.isNameExists(name.trim(), supplierId)) {
                Supplier supplier = supplierDAO.getById(supplierId);
                request.setAttribute("supplier", supplier);
                request.setAttribute("errorMessage", "Supplier name already exists");
                request.getRequestDispatcher("/purchase/edit-supplier.jsp").forward(request, response);
                return;
            }

            // Check if phone already exists (excluding current supplier)
            if (supplierDAO.isPhoneExists(phone.trim(), supplierId)) {
                Supplier supplier = supplierDAO.getById(supplierId);
                request.setAttribute("supplier", supplier);
                request.setAttribute("errorMessage", "Phone number already exists");
                request.getRequestDispatcher("/purchase/edit-supplier.jsp").forward(request, response);
                return;
            }

            // Check if email already exists (excluding current supplier)
            if (supplierDAO.isEmailExists(email.trim(), supplierId)) {
                Supplier supplier = supplierDAO.getById(supplierId);
                request.setAttribute("supplier", supplier);
                request.setAttribute("errorMessage", "Email address already exists");
                request.getRequestDispatcher("/purchase/edit-supplier.jsp").forward(request, response);
                return;
            }

            // Create supplier object for update
            Supplier supplier = Supplier.builder()
                    .supplierId(supplierId)
                    .name(name.trim())
                    .address(address != null && !address.trim().isEmpty() ? address.trim() : null)
                    .phone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null)
                    .email(email != null && !email.trim().isEmpty() ? email.trim() : null)
                    .contactPerson(contactPerson != null && !contactPerson.trim().isEmpty() ? contactPerson.trim() : null)
                    .build();

            // Update supplier
            Boolean success = supplierDAO.update(supplier);

            if (success) {
                setToastMessage(request, "Supplier updated successfully!", "success");
                response.sendRedirect(request.getContextPath()+"/purchase/manage-supplier?action=list");
            } else {
                request.setAttribute("supplier", supplier);
                request.setAttribute("errorMessage", "Failed to update supplier");
                request.getRequestDispatcher("/purchase/edit-supplier.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid supplier ID!", "error");
            response.sendRedirect(request.getContextPath()+"/purchase/manage-supplier?action=list");
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()+"/purchase/manage-supplier?action=list");
            return;
        }

        try {
            Integer supplierId = Integer.parseInt(idStr);
            Boolean success = supplierDAO.delete(supplierId);

            if (success) {
                setToastMessage(request, "Supplier deleted successfully!", "success");
            } else {
                setToastMessage(request, "Failed to delete supplier!", "error");
            }
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid supplier ID!", "error");
        }

        response.sendRedirect(request.getContextPath()+"/purchase/manage-supplier?action=list");
    }

    private void handleRestore(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath()+"/purchase/manage-supplier?action=list");
            return;
        }

        try {
            Integer supplierId = Integer.parseInt(idStr);
            Boolean success = supplierDAO.restore(supplierId);

            if (success) {
                setToastMessage(request, "Supplier restored successfully!", "success");
            } else {
                setToastMessage(request, "Failed to restore supplier!", "error");
            }
        } catch (NumberFormatException e) {
            setToastMessage(request, "Invalid supplier ID!", "error");
        }

        response.sendRedirect(request.getContextPath()+"/purchase/manage-supplier?action=list");
    }

    private void handleCheckDuplicate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String type = request.getParameter("type");
        String value = request.getParameter("value");
        String idStr = request.getParameter("id");
        
        if (type == null || value == null || value.trim().isEmpty()) {
            response.getWriter().print("{\"exists\": false}");
            return;
        }
        
        Integer supplierId = null;
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                supplierId = Integer.parseInt(idStr);
            } catch (NumberFormatException e) {
                // If ID is invalid, treat as new supplier
                supplierId = null;
            }
        }
        
        boolean exists = false;
        
        switch (type.toLowerCase()) {
            case "name":
                exists = supplierDAO.isNameExists(value.trim(), supplierId);
                break;
            case "phone":
                exists = supplierDAO.isPhoneExists(value.trim(), supplierId);
                break;
            case "email":
                exists = supplierDAO.isEmailExists(value.trim(), supplierId);
                break;
            default:
                exists = false;
                break;
        }
        
        response.getWriter().print("{\"exists\": " + exists + "}");
    }

    private void preserveFormData(HttpServletRequest request, String name, String address, 
                                  String phone, String email, String contactPerson) {
        request.setAttribute("name", name);
        request.setAttribute("address", address);
        request.setAttribute("phone", phone);
        request.setAttribute("email", email);
        request.setAttribute("contactPerson", contactPerson);
    }

    private void setToastMessage(HttpServletRequest request, String message, String type) {
        HttpSession session = request.getSession();
        session.setAttribute("toastMessage", message);
        session.setAttribute("toastType", type);
    }

    @Override
    public String getServletInfo() {
        return "Manage Supplier Controller";
    }

    /**
     * Comprehensive validation for supplier fields
     * @param name Supplier name
     * @param email Email address
     * @param phone Phone number
     * @param address Address
     * @param contactPerson Contact person name
     * @param supplierId Supplier ID (null for new supplier)
     * @return Error message if validation fails, null if validation passes
     */
    private String validateSupplierFields(String name, String email, String phone, 
                                         String address, String contactPerson, Integer supplierId) {
        // Validate required field: name
        if (name == null || name.trim().isEmpty()) {
            return "Supplier name is required";
        }

        // Validate name length
        if (name.trim().length() > 100) {
            return "Supplier name must not exceed 100 characters";
        }

        // Validate name format (no special characters except spaces, dots, dashes)
        if (!name.trim().matches("^[a-zA-Z0-9\\s\\.\\-&'(),]+$")) {
            return "Supplier name contains invalid characters";
        }

        // Validate required field: email
        if (email == null || email.trim().isEmpty()) {
            return "Email is required";
        }

        // Validate email length
        if (email.trim().length() > 100) {
            return "Email must not exceed 100 characters";
        }

        // Validate email format
        if (!isValidEmail(email.trim())) {
            return "Invalid email format";
        }

        // Validate required field: phone
        if (phone == null || phone.trim().isEmpty()) {
            return "Phone number is required";
        }

        // Validate phone format - must start with 0 and have exactly 10 digits
        if (!isValidPhone(phone.trim())) {
            return "Phone number must start with 0 and contain exactly 10 digits";
        }

        // Validate required field: address
        if (address == null || address.trim().isEmpty()) {
            return "Address is required";
        }

        // Validate address length
        if (address.trim().length() > 255) {
            return "Address must not exceed 255 characters";
        }

        // Validate required field: contact person
        if (contactPerson == null || contactPerson.trim().isEmpty()) {
            return "Contact person is required";
        }

        // Validate contact person length
        if (contactPerson.trim().length() > 100) {
            return "Contact person name must not exceed 100 characters";
        }

        if (!contactPerson.trim().matches("^[a-zA-Z\\s\\.\\-']+$")) {
            return "Contact person name contains invalid characters";
        }

        return null; // All validations passed
    }

    /**
     * Validate email format
     */
    private boolean isValidEmail(String email) {
        String emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        return email.matches(emailRegex);
    }

    /**
     * Validate phone number format - must start with 0 and have exactly 10 digits
     */
    private boolean isValidPhone(String phone) {
        // Remove all non-digit characters
        String digitsOnly = phone.replaceAll("[^0-9]", "");
        // Check if it starts with 0 and has exactly 10 digits
        return digitsOnly.startsWith("0") && digitsOnly.length() == 10;
    }
} 