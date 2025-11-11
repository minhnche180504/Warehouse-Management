<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.text.SimpleDateFormat, java.util.Date, java.util.ArrayList, java.util.List"%>
<%@page import="dao.WarehouseDAO"%>
<%@page import="model.WarehouseDisplay"%>

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
        <link rel="canonical" href="warehouse-add.jsp" />
        <title> Update Warehouse</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
        <script src="js/settings.js"></script>
        <style>body {
                opacity: 0;
            }
            div.dataTables_filter {
                display: none !important;
            }
        </style>
        <script async src="https://www.googletagmanager.com/gtag/js?id=UA-120946860-10"></script>
        <script>
            window.dataLayer = window.dataLayer || [];
            function gtag() {
                dataLayer.push(arguments);
            }
            gtag('js', new Date());
            gtag('config', 'UA-120946860-10', {'anonymize_ip': true});
        </script>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <jsp:include page="/admin/AdminSidebar.jsp" />
            <div class="main">
            <jsp:include page="/admin/navbar.jsp" />
                <main class="content">
                    <div class="container-fluid p-0">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h1 class="h3 fw-bold">Warehouse List</h1>
                            <a href="warehouse-add.jsp" class="btn btn-primary">
                                <i class="align-middle" data-feather="plus-circle"></i> Add New Warehouse
                            </a>
                        </div>
                        <% String message = request.getParameter("message");
                        String warehouseIdStr = request.getParameter("id");
                        if (message != null) {
                            if ("error_invalid_id".equals(message) && "0".equals(warehouseIdStr)) {
                                // Không hiển thị thông báo lỗi khi id = 0
                            } else {
                                String alertType = "info"; // Default
                                String alertIcon = "info";
                                String alertTitle = "Info!";
                                if ("success_delete".equals(message)) {
                                    message = "Warehouse deleted successfully!";
                                    alertType = "success";
                                    alertIcon = "check-circle";
                                    alertTitle = "Success!";
                                } else if ("error_delete".equals(message)) {
                                    message = "Error deleting warehouse. It might be in use or not found.";
                                    alertType = "danger";
                                    alertIcon = "alert-triangle";
                                    alertTitle = "Error!";
                                } else if ("error_delete_inuse_stock".equals(message)) {
                                    message = "Cannot delete warehouse because it still has stock.";
                                    alertType = "danger";
                                    alertIcon = "alert-triangle";
                                    alertTitle = "Error!";
                                } else if ("success_update".equals(message)) {
                                    message = "Warehouse updated successfully!";
                                    alertType = "success";
                                    alertIcon = "check-circle";
                                    alertTitle = "Success!";
                                } else if ("error_update".equals(message)) {
                                    message = "Error updating warehouse.";
                                    alertType = "danger";
                                    alertIcon = "alert-triangle";
                                    alertTitle = "Error!";
                                }
                        %>
                        <div class="alert alert-<%= alertType %> alert-dismissible fade show" role="alert">
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            <div class="alert-icon">
                                <i data-feather="<%= alertIcon %>"></i>
                            </div>
                            <div class="alert-message">
                                <strong><%= alertTitle %></strong> <%= message %>
                            </div>
                        </div>
                        <%      }
                        } %>
                        <div class="row">
                            <div class="col-12">
                                <div class="card shadow-sm">
                                    <div class="card-header">
                                        <h5 class="card-title fw-semibold">Available Warehouses</h5>
                                        <h6 class="card-subtitle text-muted">List of all registered warehouses in the system.</h6>
                                    </div>
                                    <div class="card-body">
                                        <table id="datatables-warehouses" class="table table-striped table-hover" style="width:100%">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Name</th>
                                                    <th>Address</th>
                                                    <th>Manager</th>
                                                    <th>Status</th>
                                                    <th>Created At</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                                List<WarehouseDisplay> warehouses = new ArrayList<>();
                                                try {
                                                    WarehouseDAO warehouseDAO = new WarehouseDAO();
                                                    warehouses = warehouseDAO.getAllWarehouses();
    
                                                    for(WarehouseDisplay wh : warehouses) {
                                                %>
                                                    <tr>
                                                        <td><%= wh.getWarehouseId() %></td>
                                                        <td><%= wh.getWarehouseName() %></td>
                                                        <td><%= (wh.getAddress() != null ? wh.getAddress() : "N/A") %></td>
                                                        <td><%= (wh.getManagerName() != null && !wh.getManagerName().trim().isEmpty() ? wh.getManagerName().trim() : "N/A") %></td>
                                                        <td>
                                                            <% String status = wh.getStatus();
                                                            String badgeClass = "bg-secondary"; // Default
                                                            if ("Active".equalsIgnoreCase(status)) badgeClass = "bg-success";
                                                            else if ("Inactive".equalsIgnoreCase(status)) badgeClass = "bg-danger";
                                                            else if ("Under Maintenance".equalsIgnoreCase(status)) badgeClass = "bg-warning text-dark";
                                                            else if ("Full".equalsIgnoreCase(status)) badgeClass = "bg-info";
                                                            %>
                                                            <span class="badge <%= badgeClass %>"><%= (status != null ? status : "N/A") %></span>
                                                        </td>
                                                        <td><%= wh.getCreatedAtFormatted() %></td>
                                                        <td class="action-btns">
                                                            <a href="warehouse-update.jsp?id=<%= wh.getWarehouseId() %>" class="btn btn-sm btn-warning" title="Edit">
                                                                <i data-feather="edit-2"></i>
                                                            </a>
                                                            <button type="button" class="btn btn-sm btn-danger delete-warehouse-btn"
                                                                    data-bs-toggle="modal" data-bs-target="#deleteWarehouseModal"
                                                                    data-id="<%= wh.getWarehouseId() %>"
                                                                    data-name="<%= wh.getWarehouseName() %>"
                                                                    title="Delete">
                                                                <i data-feather="trash-2"></i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                <%
                                                    }
                                                } catch (Exception e) {
                                                    e.printStackTrace(); 
                                                    out.println("<tr><td colspan='7' class='text-center text-danger'>Error loading warehouse data: " + e.getMessage() + "</td></tr>");
                                                }
                                                %>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                <!-- Delete Warehouse Modal (Still using modal for delete confirmation) -->
                <div class="modal fade" id="deleteWarehouseModal" tabindex="-1" aria-labelledby="deleteWarehouseModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="deleteWarehouseModalLabel">Confirm Deletion</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                Are you sure you want to delete warehouse: <strong id="deleteWarehouseName"></strong>?
                                This action cannot be undone.
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <form id="deleteWarehouseForm" action="${pageContext.request.contextPath}/admin/DeleteWarehouseServlet" method="POST" style="display: inline;">
                                    <input type="hidden" id="deleteWarehouseIdInput" name="id">
                                    <button type="submit" class="btn btn-danger">Delete</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <footer class="footer">
                    <!-- ... footer content ... -->
                </footer>
            </div>
        </div>
        <script src="js/app.js"></script>
        <script src="js/datatables.js"></script>
        <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            $("#datatables-warehouses").DataTable({
                                responsive: true,
                                "order": [[0, "asc"]]
                            });
                            if (typeof feather !== 'undefined') {
                                feather.replace();
                            }
                            // Handle Delete Warehouse Modal
                            const deleteWarehouseModal = document.getElementById('deleteWarehouseModal');
                            if (deleteWarehouseModal) {
                                deleteWarehouseModal.addEventListener('show.bs.modal', function (event) {
                                    const button = event.relatedTarget; // Button that triggered the modal
                                    const warehouseId = button.getAttribute('data-id');
                                    const warehouseName = button.getAttribute('data-name');
                                    const modalWarehouseName = deleteWarehouseModal.querySelector('#deleteWarehouseName');
                                    const deleteIdInput = deleteWarehouseModal.querySelector('#deleteWarehouseIdInput');
                                    modalWarehouseName.textContent = warehouseName;
                                    deleteIdInput.value = warehouseId;
                                });
                            }
                        });
        </script>
    </body>
</html>
