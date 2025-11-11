<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet,java.text.SimpleDateFormat,java.util.Date" %>
<%@ page import="dao.WarehouseDAO" %>
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
        <title>View Warehouse</title>
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
                        <!-- Search form -->
                        <form class="row g-3 mb-3" method="get" action="/admin/warehouse-list.jsp">
                            <div class="col-auto">
                                <input type="text" class="form-control" name="searchName" placeholder="Search warehouse name..." value="<%= request.getParameter("searchName") != null ? request.getParameter("searchName") : "" %>">
                            </div>
                            <div class="col-auto">
                                <button type="submit" class="btn btn-outline-primary mb-3">
                                    <i class="align-middle" data-feather="search"></i> Search
                                </button>
                            </div>
                        </form>
                        <!-- End search form -->
                        <% 
                        String searchName = request.getParameter("searchName");
                        %>
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
                                                    <th>Manager Name</th>
                                                    <th>Manager Email</th>
                                                    <th>Status</th>
                                                    <th>Created At</th>
                                                    <th>Region</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                WarehouseDAO warehouseDAO = new WarehouseDAO();
                                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd ");
                                                boolean foundWarehouses = false;
                                                try {
                                                    java.util.List<model.WarehouseDisplay> warehouses;

                                                    // Nếu có tìm kiếm, sử dụng method search
                                                    if (searchName != null && !searchName.trim().isEmpty()) {
                                                        warehouses = warehouseDAO.searchWarehouses(searchName, null, null);
                                                    } else {
                                                        warehouses = warehouseDAO.getAllWarehouses();
                                                    }

                                                    for (model.WarehouseDisplay wh : warehouses) {
                                                        foundWarehouses = true;
                                                        int warehouseId = wh.getWarehouseId();
                                                        String warehouseName = wh.getWarehouseName();
                                                        String address = wh.getAddress();
                                                        String managerFullName = (wh.getManagerName() != null && !wh.getManagerName().trim().isEmpty()) ? wh.getManagerName().trim() : "N/A";
                                                        String managerEmail = wh.getManagerMail(); 
                                                        String status = wh.getStatus();
                                                        String createdAtFormatted = wh.getCreatedAtFormatted();

                                                        // Xác định class cho badge status
                                                        String badgeClass = "bg-secondary";
                                                        if ("Active".equalsIgnoreCase(status)) badgeClass = "bg-success";
                                                        else if ("Inactive".equalsIgnoreCase(status)) badgeClass = "bg-danger";
                                                        else if ("Under Maintenance".equalsIgnoreCase(status)) badgeClass = "bg-warning text-dark";
                                                        else if ("Full".equalsIgnoreCase(status)) badgeClass = "bg-info";
                                                %>
                                                <tr>
                                                    <td><%= warehouseId %></td>
                                                    <td><%= (warehouseName != null ? warehouseName : "") %></td>
                                                    <td><%= (address != null ? address : "N/A") %></td>
                                                    <td><%= managerFullName %></td>
                                                    <td><%= (managerEmail != null ? managerEmail : "N/A") %></td>
                                                    <td>
                                                        <span class="badge <%= badgeClass %>"><%= (status != null ? status : "N/A") %></span>
                                                    </td>
                                                    <td><%= (createdAtFormatted != null ? createdAtFormatted : "N/A") %></td>
                                                    <td><%= (wh.getRegion() != null ? wh.getRegion() : "N/A") %></td>
                                                </tr>
                                                <%
                                                    }
                                                    if (!foundWarehouses) {
                                                %>
                                                <tr>
                                                    <td colspan="7" class="text-center">No warehouses found.</td>
                                                </tr>
                                                <%
                                                    }
                                                } catch (Exception e) {
                                                    e.printStackTrace(); // Log error
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
                <!-- ...existing code... -->
                <footer class="footer">
                </footer>
            </div>
        </div>
        <script src="js/app.js"></script>
        <script src="js/datatables.js"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Initialize DataTables
                $("#datatables-warehouses").DataTable({
                    responsive: true
                });
                if (typeof feather !== 'undefined') {
                    feather.replace();
                }
            });
        </script>
    </body>
</html>
