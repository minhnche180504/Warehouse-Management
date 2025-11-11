package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.ImportRequest;
import model.ImportRequestDetail;

public class ImportRequestDAO extends DBConnect {

    private PreparedStatement statement;
    private ResultSet resultSet;

    private void closeResources() {
        try {
            if (resultSet != null) {
                resultSet.close();
            }
            if (statement != null) {
                statement.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public ImportRequest getById(int requestId) {
        ImportRequest request = null;
        String sql = "SELECT ir.*, u.first_name + ' ' + u.last_name as created_by_name "
                + "FROM Import_Request ir "
                + "JOIN [User] u ON ir.created_by = u.user_id "
                + "WHERE ir.request_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    request = new ImportRequest();
                    request.setRequestId(rs.getInt("request_id"));
                    request.setRequestDate(rs.getTimestamp("request_date"));
                    request.setCreatedBy(rs.getInt("created_by"));
                    request.setCreatedByName(rs.getString("created_by_name"));
                    request.setReason(rs.getString("reason"));
                    request.setStatus(rs.getString("status"));
                    try {
                        request.setRejectionReason(rs.getString("rejection_reason"));
                    } catch (SQLException e) {
                        request.setRejectionReason(null);
                    }

                    // Lấy các sản phẩm ở bảng chi tiết
                    String detailSql = "SELECT ird.*, p.name as product_name, p.code as product_code "
                            + "FROM Import_Request_Detail ird "
                            + "JOIN Product p ON ird.product_id = p.product_id "
                            + "WHERE ird.request_id = ?";

                    try (PreparedStatement detailPs = connection.prepareStatement(detailSql)) {
                        detailPs.setInt(1, requestId);
                        try (ResultSet detailRs = detailPs.executeQuery()) {
                            List<ImportRequestDetail> details = new ArrayList<>();
                            while (detailRs.next()) {
                                ImportRequestDetail detail = new ImportRequestDetail();
                                detail.setDetailId(detailRs.getInt("detail_id"));
                                detail.setRequestId(detailRs.getInt("request_id"));
                                detail.setProductId(detailRs.getInt("product_id"));
                                detail.setQuantity(detailRs.getInt("quantity"));
                                detail.setProductName(detailRs.getString("product_name"));
                                detail.setProductCode(detailRs.getString("product_code"));
                                details.add(detail);
                            }
                            request.setDetails(details);
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving import request by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return request;
    }

    public ImportRequest getDetailById(int requestId) {
        ImportRequest request = null;
        String sql = "SELECT ir.*, u.first_name + ' ' + u.last_name as created_by_name, "
                + "p.name as product_name, p.code as product_code "
                + "FROM Import_Request ir "
                + "JOIN [User] u ON ir.created_by = u.user_id "
                + "JOIN Product p ON ir.product_id = p.product_id "
                + "WHERE ir.request_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    request = new ImportRequest();
                    request.setRequestId(rs.getInt("request_id"));
                    request.setProductId(rs.getInt("product_id"));
                    request.setProductName(rs.getString("product_name"));
                    request.setProductCode(rs.getString("product_code"));
                    request.setQuantity(rs.getInt("quantity"));
                    request.setRequestDate(rs.getTimestamp("request_date"));
                    request.setCreatedBy(rs.getInt("created_by"));
                    request.setCreatedByName(rs.getString("created_by_name"));
                    request.setReason(rs.getString("reason"));
                    request.setStatus(rs.getString("status"));
                    request.setType(rs.getString("order_type"));  // Added order_type field

                    // Xử lý rejection_reason có thể không tồn tại
                    try {
                        request.setRejectionReason(rs.getString("rejection_reason"));
                    } catch (SQLException e) {
                        request.setRejectionReason(null);
                    }

                    // Tạo product details string
                    String productDetails = rs.getString("product_name") + " (" + rs.getString("product_code") + ") - " + rs.getInt("quantity");
                    request.setProductDetails(productDetails);

                    // Tạo list chi tiết
                    List<ImportRequestDetail> details = new ArrayList<>();

                    // Thêm sản phẩm ở bảng cha vào list
                    ImportRequestDetail mainDetail = new ImportRequestDetail();
                    mainDetail.setProductId(rs.getInt("product_id"));
                    mainDetail.setProductName(rs.getString("product_name"));
                    mainDetail.setProductCode(rs.getString("product_code"));
                    mainDetail.setQuantity(rs.getInt("quantity"));
                    details.add(mainDetail);

                    // Lấy các sản phẩm ở bảng chi tiết
                    String detailSql = "SELECT ird.*, p.name as product_name, p.code as product_code "
                            + "FROM Import_Request_Detail ird "
                            + "JOIN Product p ON ird.product_id = p.product_id "
                            + "WHERE ird.request_id = ?";

                    try (PreparedStatement detailPs = connection.prepareStatement(detailSql)) {
                        detailPs.setInt(1, requestId);
                        try (ResultSet detailRs = detailPs.executeQuery()) {
                            while (detailRs.next()) {
                                ImportRequestDetail detail = new ImportRequestDetail();
                                detail.setDetailId(detailRs.getInt("detail_id"));
                                detail.setRequestId(detailRs.getInt("request_id"));
                                detail.setProductId(detailRs.getInt("product_id"));
                                detail.setQuantity(detailRs.getInt("quantity"));
                                detail.setProductName(detailRs.getString("product_name"));
                                detail.setProductCode(detailRs.getString("product_code"));
                                details.add(detail);
                            }
                        }
                    }
                    request.setDetails(details);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving import request by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return request;
    }

    public void updateStatus(int requestId, String status) throws SQLException {
        String sql = "UPDATE Import_Request SET status = ? WHERE request_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, requestId);
            ps.executeUpdate();
        }
    }

    public void rejectRequest(int requestId, String reason) throws Exception {
        String sql = "UPDATE Import_Request SET status = ?, rejection_reason = ? WHERE request_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "Rejected");
            ps.setString(2, reason);
            ps.setInt(3, requestId);
            ps.executeUpdate();
        }
    }

    public List<ImportRequest> getAll() {
        List<ImportRequest> requests = new ArrayList<>();

        String sql = "SELECT ir.*, u.first_name + ' ' + u.last_name as created_by_name "
                + "FROM Import_Request ir "
                + "JOIN [User] u ON ir.created_by = u.user_id "
                + "ORDER BY ir.request_date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ImportRequest request = new ImportRequest();
                request.setRequestId(rs.getInt("request_id"));
                request.setRequestDate(rs.getTimestamp("request_date"));
                request.setCreatedBy(rs.getInt("created_by"));
                request.setCreatedByName(rs.getString("created_by_name"));
                request.setReason(rs.getString("reason"));
                request.setStatus(rs.getString("status"));
                try {
                    request.setRejectionReason(rs.getString("rejection_reason"));
                } catch (SQLException e) {
                    request.setRejectionReason(null);
                }

                // Lấy danh sách sản phẩm cho từng request
                String detailSql = "SELECT ird.*, p.name as product_name, p.code as product_code "
                        + "FROM Import_Request_Detail ird "
                        + "JOIN Product p ON ird.product_id = p.product_id "
                        + "WHERE ird.request_id = ?";
                try (PreparedStatement detailPs = connection.prepareStatement(detailSql)) {
                    detailPs.setInt(1, request.getRequestId());
                    try (ResultSet detailRs = detailPs.executeQuery()) {
                        List<ImportRequestDetail> details = new ArrayList<>();
                        while (detailRs.next()) {
                            ImportRequestDetail detail = new ImportRequestDetail();
                            detail.setDetailId(detailRs.getInt("detail_id"));
                            detail.setRequestId(detailRs.getInt("request_id"));
                            detail.setProductId(detailRs.getInt("product_id"));
                            detail.setQuantity(detailRs.getInt("quantity"));
                            detail.setProductName(detailRs.getString("product_name"));
                            detail.setProductCode(detailRs.getString("product_code"));
                            details.add(detail);
                        }
                        request.setDetails(details);
                    }
                }
                requests.add(request);
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving all import requests: " + e.getMessage());
            e.printStackTrace();
        }

        return requests;
    }

    public List<ImportRequest> getAlls() {
        List<ImportRequest> requests = new ArrayList<>();

        // Cập nhật câu truy vấn không bao gồm bảng Product nữa
        String sql = "SELECT ir.*, u.first_name + ' ' + u.last_name as created_by_name, "
                + "ir.order_type as request_type " // Giữ lại trường 'order_type'
                + "FROM Import_Request ir "
                + "JOIN [User] u ON ir.created_by = u.user_id "
                + "ORDER BY ir.request_date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            System.out.println("=== DAO: Executing getAlls() query ===");
            System.out.println("SQL: " + sql);

            while (rs.next()) {
                ImportRequest request = new ImportRequest();
                request.setRequestId(rs.getInt("request_id"));
                request.setRequestDate(rs.getTimestamp("request_date"));
                request.setCreatedBy(rs.getInt("created_by"));
                request.setCreatedByName(rs.getString("created_by_name"));
                request.setReason(rs.getString("reason"));
                request.setStatus(rs.getString("status"));

                // Lấy giá trị order_type từ kết quả truy vấn
                request.setType(rs.getString("order_type"));  // Giữ lại dòng này để gán giá trị order_type

                // Xử lý rejection_reason có thể không tồn tại
                try {
                    request.setRejectionReason(rs.getString("rejection_reason"));
                } catch (SQLException e) {
                    request.setRejectionReason(null);
                }

                // Tạo product details string (không lấy thông tin sản phẩm nữa)
                request.setProductDetails("No product details available");  // Nếu không cần chi tiết sản phẩm

                System.out.println("Found import request: ID=" + request.getRequestId()
                        + ", Status=" + request.getStatus()
                        + ", Type=" + request.getType());  // In ra order_type

                // Thêm request vào danh sách
                requests.add(request);
            }

            System.out.println("Total import requests found: " + requests.size());

        } catch (SQLException e) {
            System.err.println("Error retrieving all import requests: " + e.getMessage());
            e.printStackTrace();
        }

        return requests;
    }

    public List<ImportRequest> search(String productName, String requestDate) throws SQLException {
        List<ImportRequest> requests = new ArrayList<>();

        String sql = "SELECT ir.*, u.first_name + ' ' + u.last_name AS created_by_name, "
                + "p.name as product_name, p.code as product_code "
                + "FROM Import_Request ir "
                + "JOIN [User] u ON ir.created_by = u.user_id "
                + "JOIN Product p ON ir.product_id = p.product_id "
                + "WHERE 1=1 ";

        List<Object> params = new ArrayList<>();

        if (productName != null && !productName.isEmpty()) {
            sql += " AND p.name LIKE ?";
            params.add("%" + productName + "%");
        }

        if (requestDate != null && !requestDate.isEmpty()) {
            sql += " AND CAST(ir.request_date AS DATE) = ?";
            params.add(requestDate);
        }

        sql += " ORDER BY ir.request_date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ImportRequest req = new ImportRequest();
                    req.setRequestId(rs.getInt("request_id"));
                    req.setProductId(rs.getInt("product_id"));
                    req.setProductName(rs.getString("product_name"));
                    req.setProductCode(rs.getString("product_code"));
                    req.setQuantity(rs.getInt("quantity"));
                    req.setRequestDate(rs.getTimestamp("request_date"));
                    req.setCreatedBy(rs.getInt("created_by"));
                    req.setCreatedByName(rs.getString("created_by_name"));
                    req.setReason(rs.getString("reason"));
                    req.setStatus(rs.getString("status"));

                    // Xử lý rejection_reason có thể không tồn tại
                    try {
                        req.setRejectionReason(rs.getString("rejection_reason"));
                    } catch (SQLException e) {
                        req.setRejectionReason(null);
                    }

                    // Tạo product details string
                    String productDetails = rs.getString("product_name") + " (" + rs.getString("product_code") + ") - " + rs.getInt("quantity");
                    req.setProductDetails(productDetails);

                    requests.add(req);
                }
            }
        }

        return requests;
    }

    public boolean createWithDetails(ImportRequest request, List<ImportRequestDetail> details) {
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            System.out.println("=== DAO: Starting createWithDetails ===");
            System.out.println("Request: " + request);
            System.out.println("Details count: " + details.size());

            connection.setAutoCommit(false); // Start transaction

            // Insert import request - chỉ lưu thông tin chung
            String sql = "INSERT INTO Import_Request (request_date, created_by, reason, status) VALUES (?, ?, ?, ?)";
            System.out.println("SQL for import request: " + sql);
            ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            ps.setTimestamp(1, request.getRequestDate());
            ps.setInt(2, request.getCreatedBy());
            ps.setString(3, request.getReason());
            ps.setString(4, request.getStatus());

            System.out.println("Parameters set: date=" + request.getRequestDate()
                    + ", createdBy=" + request.getCreatedBy()
                    + ", reason=" + request.getReason()
                    + ", status=" + request.getStatus());

            int affectedRows = ps.executeUpdate();
            System.out.println("Import request insert affected rows: " + affectedRows);

            if (affectedRows == 0) {
                throw new SQLException("Creating import request failed, no rows affected.");
            }

            // Get generated request ID
            rs = ps.getGeneratedKeys();
            if (!rs.next()) {
                throw new SQLException("Creating import request failed, no ID obtained.");
            }
            int requestId = rs.getInt(1);
            System.out.println("Generated request ID: " + requestId);

            // Lưu toàn bộ sản phẩm vào Import_Request_Detail
            sql = "INSERT INTO Import_Request_Detail (request_id, product_id, quantity) VALUES (?, ?, ?)";
            System.out.println("SQL for details: " + sql);
            ps = connection.prepareStatement(sql);

            for (ImportRequestDetail detail : details) {
                ps.setInt(1, requestId);
                ps.setInt(2, detail.getProductId());
                ps.setInt(3, detail.getQuantity());
                System.out.println("Adding detail to batch: requestId=" + requestId
                        + ", productId=" + detail.getProductId()
                        + ", quantity=" + detail.getQuantity());
                ps.addBatch();
            }

            int[] batchResults = ps.executeBatch();
            System.out.println("Batch execution results: " + java.util.Arrays.toString(batchResults));

            connection.commit(); // Commit transaction
            System.out.println("Transaction committed successfully");
            return true;

        } catch (SQLException e) {
            System.out.println("SQL Exception in createWithDetails: " + e.getMessage());
            e.printStackTrace();
            try {
                if (connection != null) {
                    connection.rollback(); // Rollback transaction on error
                    System.out.println("Transaction rolled back");
                }
            } catch (SQLException ex) {
                System.out.println("Error during rollback: " + ex.getMessage());
                ex.printStackTrace();
            }
            return false;
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (connection != null) {
                    connection.setAutoCommit(true); // Reset auto-commit
                }
            } catch (SQLException e) {
                System.out.println("Error closing resources: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }

    public boolean updateWithDetails(int requestId, String reason, List<ImportRequestDetail> details) {
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            connection.setAutoCommit(false); // Start transaction

            // Update import request - chỉ cập nhật reason (không còn product_id, quantity)
            String sql = "UPDATE Import_Request SET reason = ? WHERE request_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setString(1, reason);
            ps.setInt(2, requestId);

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Updating import request failed, no rows affected.");
            }

            // Delete existing details
            sql = "DELETE FROM Import_Request_Detail WHERE request_id = ?";
            ps = connection.prepareStatement(sql);
            ps.setInt(1, requestId);
            ps.executeUpdate();

            // Insert new details (toàn bộ sản phẩm)
            if (details.size() > 0) {
                sql = "INSERT INTO Import_Request_Detail (request_id, product_id, quantity) VALUES (?, ?, ?)";
                ps = connection.prepareStatement(sql);

                for (ImportRequestDetail detail : details) {
                    ps.setInt(1, requestId);
                    ps.setInt(2, detail.getProductId());
                    ps.setInt(3, detail.getQuantity());
                    ps.addBatch();
                }

                ps.executeBatch();
            }

            connection.commit(); // Commit transaction
            return true;

        } catch (SQLException e) {
            try {
                if (connection != null) {
                    connection.rollback(); // Rollback transaction on error
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (connection != null) {
                    connection.setAutoCommit(true); // Reset auto-commit
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public List<ImportRequest> getAllApprovedImportRequests() {
        List<ImportRequest> requests = new ArrayList<>();
        String sql = "SELECT ir.*, u.first_name + ' ' + u.last_name as created_by_name "
                + "FROM Import_Request ir "
                + "JOIN [User] u ON ir.created_by = u.user_id "
                + "WHERE ir.status = 'Approved' "
                + "ORDER BY ir.request_date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ImportRequest request = new ImportRequest();
                request.setRequestId(rs.getInt("request_id"));
                request.setRequestDate(rs.getTimestamp("request_date"));
                request.setCreatedBy(rs.getInt("created_by"));
                request.setCreatedByName(rs.getString("created_by_name"));
                request.setReason(rs.getString("reason"));
                request.setStatus(rs.getString("status"));

                // Get details with product information
                String detailSql = "SELECT ird.*, p.name as product_name, p.code as product_code "
                        + "FROM Import_Request_Detail ird "
                        + "JOIN Product p ON ird.product_id = p.product_id "
                        + "WHERE ird.request_id = ?";

                try (PreparedStatement detailPs = connection.prepareStatement(detailSql)) {
                    detailPs.setInt(1, request.getRequestId());
                    try (ResultSet detailRs = detailPs.executeQuery()) {
                        List<ImportRequestDetail> details = new ArrayList<>();
                        while (detailRs.next()) {
                            ImportRequestDetail detail = new ImportRequestDetail();
                            detail.setDetailId(detailRs.getInt("detail_id"));
                            detail.setRequestId(detailRs.getInt("request_id"));
                            detail.setProductId(detailRs.getInt("product_id"));
                            detail.setQuantity(detailRs.getInt("quantity"));
                            detail.setProductName(detailRs.getString("product_name"));
                            detail.setProductCode(detailRs.getString("product_code"));
                            details.add(detail);
                        }
                        request.setDetails(details);
                    }
                }
                requests.add(request);
            }

        } catch (SQLException e) {
            System.err.println("Error retrieving approved import requests: " + e.getMessage());
            e.printStackTrace();
        }

        return requests;
    }

    private ImportRequest mapResultSetToImportRequest(ResultSet rs) throws SQLException {
        ImportRequest request = new ImportRequest();
        request.setRequestId(rs.getInt("request_id"));
        request.setProductId(rs.getInt("product_id"));
        request.setProductName(rs.getString("product_name"));
        request.setProductCode(rs.getString("product_code"));
        request.setQuantity(rs.getInt("quantity"));
        request.setRequestDate(rs.getTimestamp("request_date"));
        request.setCreatedBy(rs.getInt("created_by"));
        request.setCreatedByName(rs.getString("created_by_name"));
        request.setReason(rs.getString("reason"));
        request.setStatus(rs.getString("status"));
        return request;
    }

    public void approveRequests(int requestId, String orderType) {
        String sql = "UPDATE Import_Request SET status = ?, order_type = ? WHERE request_id = ?";
        try (
                PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, "Approved"); // Cập nhật status thành Approved
            stmt.setString(2, orderType); // Cập nhật orderType
            stmt.setInt(3, requestId); // Cập nhật requestId để xác định yêu cầu cần phê duyệt

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Từ chối yêu cầu và lưu lý do từ chối cùng với orderType
    public void rejectRequests(int requestId, String rejectionReason, String orderType) {
        String sql = "UPDATE Import_Request SET status = ?, rejection_reason = ?, order_type = ? WHERE request_id = ?";
        try (
                PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, "Rejected");
            stmt.setString(2, rejectionReason);
            stmt.setString(3, orderType); // Cập nhật orderType khi từ chối
            stmt.setInt(4, requestId);

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public List<ImportRequest> getByOrderType(String orderType) {
    List<ImportRequest> requests = new ArrayList<>();
    String sql =
        "SELECT ir.*, u.first_name + ' ' + u.last_name AS created_by_name " +
        "FROM Import_Request ir " +
        "JOIN [User] u ON ir.created_by = u.user_id " +
        "WHERE ir.order_type = ? " +
        "ORDER BY ir.request_date DESC";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setString(1, orderType);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ImportRequest req = new ImportRequest();
                req.setRequestId(rs.getInt("request_id"));
                req.setRequestDate(rs.getTimestamp("request_date"));
                req.setCreatedBy(rs.getInt("created_by"));
                req.setCreatedByName(rs.getString("created_by_name"));
                req.setReason(rs.getString("reason"));
                req.setStatus(rs.getString("status"));
                // capture the order_type field
                req.setType(rs.getString("order_type"));
                // rejection_reason may be null
                try {
                    req.setRejectionReason(rs.getString("rejection_reason"));
                } catch (SQLException e) {
                    req.setRejectionReason(null);
                }
                // you can choose to load details here or leave them null
                requests.add(req);
            }
        }
    } catch (SQLException e) {
        System.err.println("Error in getByOrderType: " + e.getMessage());
        e.printStackTrace();
    }
    return requests;
}

    public static void main(String[] args) {
        // JDBC connection (Thay đổi với thông tin của bạn)
        String url = "jdbc:sqlserver://localhost;databaseName=ISP392_DTB";
        String username = "your_username";
        String password = "your_password";
        // Tạo đối tượng DAO và gọi phương thức getAlls()
        ImportRequestDAO importRequestDAO = new ImportRequestDAO();
        List<ImportRequest> requests = importRequestDAO.getAlls();
        // In danh sách các yêu cầu import
        for (ImportRequest request : requests) {
            System.out.println("Request ID: " + request.getRequestId());
            System.out.println("Product Name: " + request.getProductName());
            System.out.println("Request Type: " + request.getType());
            System.out.println("Created By: " + request.getCreatedByName());
            System.out.println("Status: " + request.getStatus());
            System.out.println("-----------------------------");
        }
    }
}
