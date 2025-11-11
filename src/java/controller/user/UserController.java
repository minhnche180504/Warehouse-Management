package controller.user;

import dao.RoleDAO;
import dao.UserDAO2;
import model.Role;
import model.User;
import dao.AuthorizationUtil;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import utils.AuthorizationService;

@WebServlet(name = "UserController", urlPatterns = {
    "/admin/users", 
    "/admin/add",
    "/admin/user-deactivate", 
    "/admin/user-activate"
})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1 MB
    maxFileSize = 1024 * 1024 * 10,     // 10 MB
    maxRequestSize = 1024 * 1024 * 100  // 100 MB
)
public class UserController extends HttpServlet {

    /**
     * Lấy thông tin user hiện tại từ session
     */
    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }

    /**
     * Xử lý các request GET
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuthorizationService authService = AuthorizationService.getInstance();
        if (!authService.authorize(request, response)) {
            return;
        }
        
        User currentUser = getCurrentUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getServletPath();
        
        try {
            switch (action) {
                case "/admin/users":
                    listUsers(request, response);
                    break;
                case "/admin/add":
                    showAddForm(request, response);
                    break;
                case "/admin/user-deactivate":
                    deactivateUser(request, response);
                    break;
                case "/admin/user-activate":
                    activateUser(request, response);
                    break;
                default:
                    listUsers(request, response);
                    break;
            }
        } catch (Exception e) {
            System.out.println("Error in UserController doGet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request.");
            request.getRequestDispatcher("/admin/viewlistuser.jsp").forward(request, response);
        }
    }

    /**
     * Xử lý các request POST
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User currentUser = getCurrentUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getServletPath();
        
        try {
            switch (action) {
                case "/admin/add":
                    addUser(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                    break;
            }
        } catch (Exception e) {
            System.out.println("Error in UserController doPost: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request.");
            request.getRequestDispatcher("/admin/viewlistuser.jsp").forward(request, response);
        }
    }
    
    /**
     * Hiển thị danh sách tất cả users (both active and inactive)
     */
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User currentUser = getCurrentUser(request);
        
        // Kiểm tra quyền xem danh sách users
        if (!AuthorizationUtil.canViewUsers(currentUser)) {
            request.setAttribute("error", "You don't have permission to view users list.");
            response.sendRedirect(request.getContextPath() + "/admin/AdminDashboard.jsp");
            return;
        }
        
        UserDAO2 userDAO = new UserDAO2();
        List<User> users = userDAO.getAllUsers(); // Get both active and inactive users
        
        // Get list of warehouses for filter dropdown
        dao.WarehouseDAO warehouseDAO = new dao.WarehouseDAO();
        List<model.Warehouse> warehouses = warehouseDAO.getAll();
        
        request.setAttribute("users", users);
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("currentUser", currentUser);
        
        request.getRequestDispatcher("/admin/viewlistuser.jsp").forward(request, response);
    }
    
    /**
     * Hiển thị form thêm user mới
     */
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User currentUser = getCurrentUser(request);
        
        // Kiểm tra quyền tạo user
        if (!AuthorizationUtil.canCreateUser(currentUser)) {
            request.setAttribute("error", "You don't have permission to create users.");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        
        RoleDAO roleDAO = new RoleDAO();
        List<Role> roles = roleDAO.getAllRoles();
        
        // Nếu user hiện tại là Warehouse Manager, loại bỏ role Admin khỏi danh sách
        if (AuthorizationUtil.isWarehouseManager(currentUser)) {
            roles.removeIf(role -> AuthorizationUtil.ROLE_ADMIN.equals(role.getRoleName()));
        }
        
        // Lấy danh sách kho để hiển thị trong dropdown
        dao.WarehouseDAO warehouseDAO = new dao.WarehouseDAO();
        List<model.Warehouse> warehouses = warehouseDAO.getAll();
        
        request.setAttribute("roles", roles);
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("currentUser", currentUser);
        
        request.getRequestDispatcher("/admin/add.jsp").forward(request, response);
    }
    
    /**
     * Xử lý thêm user mới (user mới luôn được tạo với trạng thái active)
     */
    private void addUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User currentUser = getCurrentUser(request);
        
        // Kiểm tra quyền tạo user
        if (!AuthorizationUtil.canCreateUser(currentUser)) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }
        
        // Lấy thông tin từ form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String roleIdStr = request.getParameter("roleId");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String dobString = request.getParameter("dateOfBirth");
        String warehouseIdStr = request.getParameter("warehouseId"); // NEW: Get warehouse ID
        
        // Validation cơ bản
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty() ||
            roleIdStr == null || roleIdStr.trim().isEmpty()) {
            
            request.setAttribute("error", "Please fill in all required fields.");
            redirectToAddForm(request, response, currentUser);
            return;
        }
        
        int roleId;
        try {
            roleId = Integer.parseInt(roleIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid role selection.");
            redirectToAddForm(request, response, currentUser);
            return;
        }
        
        // NEW: Parse warehouse ID
        Integer warehouseId = null;
        if (warehouseIdStr != null && !warehouseIdStr.trim().isEmpty()) {
            try {
                warehouseId = Integer.parseInt(warehouseIdStr);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid warehouse selection.");
                redirectToAddForm(request, response, currentUser);
                return;
            }
        }
        
        // Kiểm tra xem Warehouse Manager có đang cố tạo Admin không
        RoleDAO roleDAO = new RoleDAO();
        Role selectedRole = roleDAO.getRoleById(roleId);
        if (selectedRole == null) {
            request.setAttribute("error", "Invalid role selection.");
            redirectToAddForm(request, response, currentUser);
            return;
        }
        
        if (AuthorizationUtil.isWarehouseManager(currentUser) && 
            AuthorizationUtil.ROLE_ADMIN.equals(selectedRole.getRoleName())) {
            request.setAttribute("error", "You don't have permission to create Admin users.");
            redirectToAddForm(request, response, currentUser);
            return;
        }
        
        // Xử lý ngày sinh
        Date dateOfBirth = null;
        if (dobString != null && !dobString.trim().isEmpty()) {
            try {
                dateOfBirth = Date.valueOf(dobString);
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", "Invalid date format.");
                redirectToAddForm(request, response, currentUser);
                return;
            }
        }
        
        // Xử lý upload ảnh profile
        String profilePic = "";
        try {
            Part filePart = request.getPart("profilePic");
            if (filePart != null && filePart.getSize() > 0) {
                profilePic = handleFileUpload(filePart);
                if (profilePic == null) {
                    request.setAttribute("error", "Failed to upload profile picture.");
                    redirectToAddForm(request, response, currentUser);
                    return;
                }
            }
        } catch (Exception e) {
            // Ignore file upload errors and continue
            System.out.println("File upload error (ignored): " + e.getMessage());
        }
        
        // Tạo đối tượng User (luôn active = true khi tạo mới)
        User user = new User();
        user.setUsername(username.trim());
        user.setPassword(password); // Trong thực tế nên hash password
        user.setFirstName(firstName.trim());
        user.setLastName(lastName.trim());
        user.setRoleId(roleId);
        user.setGender(gender);
        user.setAddress(address);
        user.setEmail(email);
        user.setDateOfBirth(dateOfBirth);
        user.setProfilePic(profilePic);
        user.setActive(true); // Always create user as active
        user.setWarehouseId(warehouseId); // NEW: Set warehouse ID
        
        // Lưu vào database
        UserDAO2 userDAO = new UserDAO2();
        boolean success = userDAO.addUser(user);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/users?success=User added successfully and is now active");
        } else {
            request.setAttribute("error", "Failed to add user. Username might already exist.");
            request.setAttribute("user", user);
            redirectToAddForm(request, response, currentUser);
        }
    }
    
    /**
     * Deactivate user (soft delete)
     */
    private void deactivateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User currentUser = getCurrentUser(request);
        String userIdStr = request.getParameter("id");
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Invalid user ID");
            return;
        }
        
        int userId;
        try {
            userId = Integer.parseInt(userIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Invalid user ID format");
            return;
        }
        
        // Không cho phép user deactivate chính mình
        if (currentUser.getUserId() == userId) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=You cannot deactivate yourself");
            return;
        }
        
        UserDAO2 userDAO = new UserDAO2();
        User targetUser = userDAO.getUserById(userId);
        
        if (targetUser == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=User not found");
            return;
        }
        
        // Kiểm tra quyền deactivate user
        if (!AuthorizationUtil.canDeleteUser(currentUser, targetUser)) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=You don't have permission to deactivate this user");
            return;
        }
        
        // Kiểm tra user đã inactive chưa
        if (!targetUser.isActive()) {
            response.sendRedirect(request.getContextPath() + "/admin/users?info=User is already inactive");
            return;
        }
        
        boolean success = userDAO.deactivateUser(userId);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/users?success=User deactivated successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Failed to deactivate user");
        }
    }
    
    /**
     * Activate user
     */
    private void activateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User currentUser = getCurrentUser(request);
        String userIdStr = request.getParameter("id");
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Invalid user ID");
            return;
        }
        
        int userId;
        try {
            userId = Integer.parseInt(userIdStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Invalid user ID format");
            return;
        }
        
        UserDAO2 userDAO = new UserDAO2();
        User targetUser = userDAO.getUserById(userId);
        
        if (targetUser == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=User not found");
            return;
        }
        
        // Kiểm tra quyền activate user
        if (!AuthorizationUtil.canDeleteUser(currentUser, targetUser)) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=You don't have permission to activate this user");
            return;
        }
        
        // Kiểm tra user đã active chưa
        if (targetUser.isActive()) {
            response.sendRedirect(request.getContextPath() + "/admin/users?info=User is already active");
            return;
        }
        
        boolean success = userDAO.activateUser(userId);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/users?success=User activated successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=Failed to activate user");
        }
    }
    
    /**
     * Xử lý upload file ảnh profile
     */
    private String handleFileUpload(Part filePart) {
        try {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            
            // Kiểm tra định dạng file
            String fileExtension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
            if (!fileExtension.matches("\\.(jpg|jpeg|png|gif)$")) {
                System.out.println("Invalid file format: " + fileExtension);
                return null;
            }
            
            String uploadDir = getServletContext().getRealPath("/uploads");
            File uploadDirFile = new File(uploadDir);
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdirs();
            }
            
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
            String filePath = uploadDir + File.separator + uniqueFileName;
            filePart.write(filePath);
            
            return "uploads/" + uniqueFileName;
            
        } catch (Exception e) {
            System.out.println("Error uploading file: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Redirect đến form add với thông tin roles
     */
    private void redirectToAddForm(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws ServletException, IOException {
        
        RoleDAO roleDAO = new RoleDAO();
        List<Role> roles = roleDAO.getAllRoles();
        
        if (AuthorizationUtil.isWarehouseManager(currentUser)) {
            roles.removeIf(role -> AuthorizationUtil.ROLE_ADMIN.equals(role.getRoleName()));
        }
        
        dao.WarehouseDAO warehouseDAO = new dao.WarehouseDAO();
        List<model.Warehouse> warehouses = warehouseDAO.getAll();
        
        request.setAttribute("roles", roles);
        request.setAttribute("warehouses", warehouses);
        request.setAttribute("currentUser", currentUser);
        request.getRequestDispatcher("/admin/add.jsp").forward(request, response);
    }
}