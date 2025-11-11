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
        <title>Add Warehouse</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
        <script src="js/settings.js"></script>
        <style>
            body {
                opacity: 0;
            }
        </style>
        <script>
            window.dataLayer = window.dataLayer || [];
            function gtag() {
                dataLayer.push(arguments);
            }
            gtag('js', new Date());
            gtag('config', 'UA-120946860-10', {'anonymize_ip': true});
        </script>
    </head>
    <body>
        <div class="wrapper">
            <jsp:include page="/admin/AdminSidebar.jsp" />
            <div class="main">
                <jsp:include page="/admin/navbar.jsp" />
                <main class="content">
                    <div class="container-fluid p-0">
                        <h1 class="h2 mb-4 fw-bold text-primary">Add New Warehouse</h1>
                        <div class="row">
                            <div class="col-12">
                                <div class="card shadow-sm">
                                    <div class="card-header pb-0 border-bottom-0">
                                        <h5 class="card-title mb-0 fw-semibold">Warehouse Information</h5>
                                        <hr class="mt-2 mb-0">
                                    </div>
                                    <% String error = (String)request.getAttribute("error");
if (error != null) { %>
                                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                        <div class="alert-icon">
                                            <i data-feather="alert-triangle"></i>
                                        </div>
                                        <div class="alert-message">
                                            <strong>Error!</strong> <%= error %>
                                        </div>
                                    </div>
                                    <% } %>
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
                                        alertMessageText = "Warehouse created successfully!";
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
                                        alertMessageText = "Add warehouse failed!";
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
                                        <form action="${pageContext.request.contextPath}/admin/addWarehouse" method="post" onsubmit="return validateForm();">
                                            <div class="row mb-3 align-items-center">
                                                <div class="col-md-6 mb-3 mb-md-0">
                                                    <label for="name" class="form-label fw-medium">Warehouse Name</label>
                                                    <input type="text" class="form-control form-control-lg" id="name" name="name" required>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="address" class="form-label fw-medium">Address</label>
                                                    <input type="text" class="form-control form-control-lg" id="address" name="address">
                                                </div>
                                            </div>
                                            <div class="row mb-3 align-items-center">
                                                <div class="col-md-6 mb-3 mb-md-0">
                                                    <label for="manager_id" class="form-label fw-medium">Manager</label>
                                                    <select class="form-select form-select-lg" id="manager_id" name="manager_id" required>
                                                        <option value="" selected disabled>-- Select Manager --</option>
                                                        <%
                                                        try {
                                                        WarehouseDAO warehouseDAO = new WarehouseDAO();
                                                        java.util.List<model.User> managers = warehouseDAO.getAllManagers();
                                                        for (model.User manager : managers) {
                                                        %>
                                                        <option value="<%= manager.getUserId() %>">
                                                            <%= manager.getFirstName() %> <%= manager.getLastName() %>
                                                        </option>
                                                        <%
                                                        }
                                                        } catch (Exception e) {
                                                        e.printStackTrace();
                                                        out.println("<option disabled>Error loading managers: " + e.getMessage() + "</option>");
                                                        }
                                                        %>
                                                    </select>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="status" class="form-label fw-medium">Status</label>
                                                    <input type="text" class="form-control form-control-lg" id="status" name="status" value="Active" readonly>
                                                </div>
                                            </div>
                                            <div class="row mb-4 align-items-center">
                                                <div class="col-md-6 mb-3 mb-md-0">
                                                    <label for="region" class="form-label fw-medium">Region</label>
                                                    <select class="form-select form-select-lg" id="region" name="region" required>
                                                        <option value="" selected disabled>-- Select Region --</option>
                                                        <option value="Miền Bắc">Miền Bắc</option>
                                                        <option value="Miền Trung">Miền Trung</option>
                                                        <option value="Miền Nam">Miền Nam</option>
                                                    </select>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="created_date" class="form-label fw-medium">Created Date</label>
                                                    <input type="date" class="form-control form-control-lg" id="created_date" name="created_date" value="<%= new SimpleDateFormat("yyyy-MM-dd").format(new Date()) %>" required>
                                                </div>
                                            </div>
                                            <div class="row mt-4">
                                                <div class="col-12 text-end">
                                                    <button type="submit" class="btn btn-primary btn-lg px-4">
                                                        <i class="align-middle me-1" data-feather="plus-circle"></i> Add Warehouse
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
        <script src="js/app.js"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
        // Initialize Feather icons
                feather.replace();
            });
        </script>
    </body>
</html>
