<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.text.SimpleDateFormat, java.util.Date, java.util.ArrayList, java.util.List" %>
<%@page import="dao.WarehouseDAO"%>
<%@page import="model.WarehouseDisplay"%>
<%@page import="model.User" %>

<%
    String warehouseIdStr = request.getParameter("id");
    WarehouseDisplay warehouse = null;
    List<User> managers = new ArrayList<>();
    String managerFullNameForDisplay = "N/A"; 
    String createdAtFormattedForDisplay = "N/A";

    
    if (warehouseIdStr == null || warehouseIdStr.trim().isEmpty()) {
        response.sendRedirect("warehouse-list.jsp?message=error_invalid_id");
        return;
    }

    try {
        WarehouseDAO warehouseDAO = new WarehouseDAO();
        
        // 1. Lấy thông tin warehouse theo ID
        try {
            warehouse = warehouseDAO.getWarehouseById(Integer.parseInt(warehouseIdStr));
        } catch (NumberFormatException nfe) {
            // Bỏ qua lỗi định dạng id, không redirect lỗi
            warehouse = null;
        }
        
        if (warehouse == null) {
            response.sendRedirect("warehouse-list.jsp?message=error_notfound");
            return;
        }
        
        // 2. Lấy danh sách managers
        managers = warehouseDAO.getAllManagers();
        
        // 3. Lấy tên manager để hiển thị (nếu có)
        if (warehouse.getManagerId() > 0) {
            User currentManager = warehouseDAO.getManagerById(warehouse.getManagerId());
            if (currentManager != null) {
                managerFullNameForDisplay = currentManager.getFirstName() + " " + currentManager.getLastName();
            }
        }
        
        // 4. Format ngày tạo để hiển thị
        createdAtFormattedForDisplay = warehouse.getCreatedAtFormatted();

    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("warehouse-list.jsp?message=error_db_fetch");
        return;
    }
    
    if (warehouse == null) {
        response.sendRedirect("warehouse-list.jsp?message=error_notfound_critical");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Responsive Admin &amp; Dashboard Template based on Bootstrap 5">
        <meta name="author" content="AdminKit">
        <meta name="keywords" content="adminkit, bootstrap, bootstrap 5, admin, dashboard, template, responsive, css, sass, html, theme, front-end, ui kit, web">
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link rel="shortcut icon" href="img/icons/icon-48x48.png" />
        <title>Update Warehouse</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="${pageContext.request.contextPath}/admin/css/light.css" rel="stylesheet">
        <script src="${pageContext.request.contextPath}/admin/js/settings.js"></script>
        <style>
            body {
                opacity: 0;
            }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <jsp:include page="/admin/AdminSidebar.jsp" />
            <div class="main">
                <jsp:include page="/admin/navbar.jsp" />
                <main class="content">
                    <div class="container-fluid p-0">
                        <h1 class="h2 mb-4 fw-bold text-primary">Update Warehouse</h1>
                        <div class="row">
                            <div class="col-12">
                                <div class="card shadow-sm">
                                    <div class="card-header pb-0 border-bottom-0">
                                        <h5 class="card-title mb-0 fw-semibold">Warehouse Information</h5>
                                        <hr class="mt-2 mb-0">
                                    </div>
                                    <div class="card-body pt-3">
                                        <%
                                        String msg = request.getParameter("msg");
                                        String alertClass = "";
                                        String alertIcon = "";
                                        String alertTitle = "";
                                        String alertMessageText = "";
                                        boolean showAlert = false;
                                        if ("success".equals(msg)) {
                                            alertClass = "success";
                                            alertIcon = "check-circle";
                                            alertTitle = "Success!";
                                            alertMessageText = "Warehouse updated successfully!";
                                            showAlert = true;
                                        } else if ("duplicate".equals(msg)) {
                                            alertClass = "danger";
                                            alertIcon = "alert-triangle";
                                            alertTitle = "Error!";
                                            alertMessageText = "Warehouse name already exists!";
                                            showAlert = true;
                                        } else if ("fail".equals(msg)) {
                                            alertClass = "danger";
                                            alertIcon = "alert-triangle";
                                            alertTitle = "Error!";
                                            alertMessageText = "Update warehouse failed!";
                                            showAlert = true;
                                        } else if ("error_inactive_with_stock".equals(msg)) {
                                            alertClass = "danger";
                                            alertIcon = "alert-triangle";
                                            alertTitle = "Error!";
                                            alertMessageText = "Cannot set warehouse status to Inactive while it still has stock.";
                                            showAlert = true;
                                        }
                                        if (showAlert) {
                                        %>
                                        <div class="alert alert-<%= alertClass %> alert-dismissible fade show" role="alert">
                                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            <div class="alert-icon">
                                                <i data-feather="<%= alertIcon %>"></i>
                                            </div>
                                            <div class="alert-message">
                                                <strong><%= alertTitle %></strong> <%= alertMessageText %>
                                            </div>
                                        </div>
                                        <%
                                        }
                                        %>

                                        <!-- Current Info Display -->
                                        <div class="alert alert-info mb-4">
                                            <div class="alert-icon">
                                                <i data-feather="info"></i>
                                            </div>
                                            <div class="alert-message">
                                                <strong>Current Information:</strong><br>
                                                <strong>Warehouse ID:</strong> #<%= warehouse.getWarehouseId() %> | 
                                                <strong>Current Manager:</strong> <%= managerFullNameForDisplay %> | 
                                                <strong>Created Date:</strong> <%= createdAtFormattedForDisplay %>
                                            </div>
                                        </div>

                                        <script>
                                            function validateForm() {
                                                // Validate warehouse name
                                                var name = document.getElementById("name").value.trim();
                                                var namePattern = /^[\p{L}0-9\s\-,]+$/u;
                                                if (name === "") {
                                                    alert("Warehouse name is required.");
                                                    document.getElementById("name").focus();
                                                    return false;
                                                }
                                                if (!namePattern.test(name)) {
                                                    alert("Warehouse name can only contain letters (including Vietnamese), numbers, spaces, hyphens (-), and commas (,).");
                                                    document.getElementById("name").focus();
                                                    return false;
                                                }
                                                // Validate address
                                                var address = document.getElementById("address").value.trim();
                                                var addressPattern = /^[\p{L}0-9\s\-,]+$/u;
                                                if (address === "") {
                                                    alert("Address is required.");
                                                    document.getElementById("address").focus();
                                                    return false;
                                                }
                                                if (/^\d+$/.test(address)) {
                                                    alert("Address cannot be only numbers.");
                                                    document.getElementById("address").focus();
                                                    return false;
                                                }
                                                if (!addressPattern.test(address)) {
                                                    alert("Address can only contain letters (including Vietnamese), numbers, spaces, hyphens (-), and commas (,).");
                                                    document.getElementById("address").focus();
                                                    return false;
                                                }
                                                // Validate region
                                                var region = document.getElementById("region").value;
                                                if (region === "") {
                                                    alert("Region is required.");
                                                    document.getElementById("region").focus();
                                                    return false;
                                                }
                                                return true;
                                            }
                                        </script>

                                        <form action="${pageContext.request.contextPath}/admin/UpdateWarehouseServlet" method="post" onsubmit="return validateForm();">
                                            <input type="hidden" name="warehouseId" value="<%= warehouse.getWarehouseId() %>">

                                            <div class="row mb-3 align-items-center">
                                                <div class="col-md-6 mb-3 mb-md-0">
                                                    <label for="warehouseName" class="form-label fw-medium">Warehouse Name</label>
                                                    <input type="text" class="form-control form-control-lg" id="warehouseName" name="warehouseName" 
                                                           value="<%= warehouse.getWarehouseName() %>" required>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="address" class="form-label fw-medium">Address</label>
                                                    <input type="text" class="form-control form-control-lg" id="address" name="address" 
                                                           value="<%= warehouse.getAddress() != null ? warehouse.getAddress() : "" %>">
                                                </div>
                                            </div>

                                            <div class="row mb-3 align-items-center">
                                                <div class="col-md-6 mb-3 mb-md-0">
                                                    <label for="managerId" class="form-label fw-medium">Manager</label>
                                                    <select class="form-select form-select-lg" id="managerId" name="managerId">
                                                        <option value="">-- Select Manager --</option>
                                                        <%
                                                        for (User manager : managers) {
                                                        %>
                                                        <option value="<%= manager.getUserId() %>" 
                                                                <%= (warehouse.getManagerId() == manager.getUserId()) ? "selected" : "" %>>
                                                            <%= manager.getFirstName() %> <%= manager.getLastName() %>
                                                        </option>
                                                        <%
                                                        }
                                                        %>
                                                    </select>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="status" class="form-label fw-medium">Status</label>
                                                    <select class="form-select form-select-lg" id="status" name="status" required>
                                                        <option value="">-- Select Status --</option>
                                                        <option value="Active" <%= "Active".equals(warehouse.getStatus()) ? "selected" : "" %>>Active</option>
                                                        <option value="Inactive" <%= "Inactive".equals(warehouse.getStatus()) ? "selected" : "" %>>Inactive</option>
                                                        <option value="Under Maintenance" <%= "Under Maintenance".equals(warehouse.getStatus()) ? "selected" : "" %>>Under Maintenance</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="row mb-4 align-items-center">
                                                <div class="col-md-6 mb-3 mb-md-0">
                                                    <label for="region" class="form-label fw-medium">Region</label>
                                                    <select class="form-select form-select-lg" id="region" name="region" required>
                                                        <option value="">-- Select Region --</option>
                                                        <option value="Miền Bắc" <%= "Miền Bắc".equals(warehouse.getRegion()) ? "selected" : "" %>>Miền Bắc</option>
                                                        <option value="Miền Trung" <%= "Miền Trung".equals(warehouse.getRegion()) ? "selected" : "" %>>Miền Trung</option>
                                                        <option value="Miền Nam" <%= "Miền Nam".equals(warehouse.getRegion()) ? "selected" : "" %>>Miền Nam</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="created_date" class="form-label fw-medium">Created Date</label>
                                                    <input type="text" class="form-control form-control-lg" id="created_date" 
                                                           value="<%= createdAtFormattedForDisplay %>" readonly>
                                                </div>
                                            </div>

                                            <div class="row mt-4">
                                                <div class="col-12 text-end">
                                                    <a href="warehouse-list.jsp" class="btn btn-secondary btn-lg px-4 me-2">
                                                        <i class="align-middle me-1" data-feather="arrow-left"></i> Cancel
                                                    </a>
                                                    <button type="submit" class="btn btn-primary btn-lg px-4">
                                                        <i class="align-middle me-1" data-feather="save"></i> Update Warehouse
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                <footer class="footer">
                </footer>
            </div>
        </div>
        <script src="${pageContext.request.contextPath}/admin/js/app.js"></script>
        <script>
                                            document.addEventListener("DOMContentLoaded", function () {
                                                feather.replace();
                                            });
        </script>
    </body>
</html>
