<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List,model.Unit,dao.UnitDAO" %>
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
        <link rel="canonical" href="forms-layouts.html" />
        <title>Unit Management | Warehouse System</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
        <script src="js/settings.js"></script>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <jsp:include page="/admin/AdminSidebar.jsp" />
            <div class="main">
                <jsp:include page="/admin/navbar.jsp" />               
                <main class="content">                    
                    <div class="container-fluid p-0">
                        <div class="row mb-3">
                            <div class="col-6">
                                <h1 class="h2 mb-3 fw-bold text-primary">Unit Management</h1>
                            </div>
                            <div class="col-6 text-end">
                                <a href="create-unit" class="btn btn-primary">
                                    <i class="align-middle" data-feather="plus"></i> Add New Unit
                                </a>
                            </div>
                        </div>
                        
                        <!-- Alert Messages -->
                        <% if (session.getAttribute("successMessage") != null) { %>
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <strong>Success!</strong> <%= session.getAttribute("successMessage") %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <% session.removeAttribute("successMessage"); %>
                        <% } %>
                        
                        <% if (request.getAttribute("errorMessage") != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong>Error!</strong> <%= request.getAttribute("errorMessage") %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <% } %>
                        
                        <!-- Filter Controls -->
                        <div class="card">
                            <div class="card-body">
                                <form action="list-unit" method="get" class="row g-2">
                                    <div class="col-auto form-check form-switch my-2">
                                        <input class="form-check-input" type="checkbox" id="showInactive" name="showInactive" value="true" 
                                            <%= (request.getAttribute("showInactive") != null && (Boolean)request.getAttribute("showInactive")) ? "checked" : "" %>>
                                        <label class="form-check-label" for="showInactive">Show Inactive Units</label>
                                    </div>
                                </form>
                            </div>
                        </div>
                        
                        <!-- Units Table -->
                        <div class="card">
                            <div class="card-body">
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Name</th>
                                                <th>Code</th>
                                                <th>Description</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% 
                                                List<Unit> units = (List<Unit>)request.getAttribute("units");
                                                if (units != null && !units.isEmpty()) {
                                                    for (Unit unit : units) {
                                            %>
                                                <tr>
                                                    <td><%= unit.getUnitId() %></td>
                                                    <td><%= unit.getUnitName() %></td>
                                                    <td><%= unit.getUnitCode() %></td>
                                                    <td><%= unit.getDescription() != null ? unit.getDescription() : "" %></td>
                                                    <td>
                                                        <% if (unit.isIsActive()) { %>
                                                            <span class="badge bg-success">Active</span>
                                                        <% } else { %>
                                                            <span class="badge bg-danger">Inactive</span>
                                                        <% } %>
                                                    </td>
                                                    <td class="table-action">
                                                        <a href="edit-unit?id=<%= unit.getUnitId() %>" class="btn btn-sm btn-primary text-white">
                                                            <i class="align-middle" data-feather="edit-2"></i> Edit
                                                        </a>
                                                        <% if (unit.isIsActive()) { %>
                                                            <a href="delete-unit?id=<%= unit.getUnitId() %>" 
                                                               class="btn btn-sm btn-danger text-white" 
                                                               onclick="return confirm('Are you sure you want to delete this unit?')">
                                                                <i class="align-middle" data-feather="trash"></i> Delete
                                                            </a>
                                                        <% } else { %>
                                                            <a href="restore-unit?id=<%= unit.getUnitId() %>" 
                                                               class="btn btn-sm btn-success text-white" 
                                                               onclick="return confirm('Are you sure you want to reactivate this unit?')">
                                                                <i class="align-middle" data-feather="refresh-cw"></i> Activate
                                                            </a>
                                                        <% } %>
                                                    </td>
                                                </tr>
                                            <% 
                                                    }
                                                } else {
                                            %>
                                                <tr>
                                                    <td colspan="6" class="text-center">No units found</td>
                                                </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                <footer class="footer">
                    <div class="container-fluid">
                        <div class="row text-muted">
                            <div class="col-12 text-center">
                                <p class="mb-0">
                                    <a class="text-muted" href="#" target="_blank"><strong>Warehouse Management System</strong></a> &copy;
                                </p>
                            </div>
                        </div>
                    </div>
                </footer>
            </div>
        </div>

        <script src="js/app.js"></script>
        <script>
            // Auto-hide alerts after 5 seconds
            setTimeout(function() {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(function(alert) {
                    if (alert) {
                        var bsAlert = new bootstrap.Alert(alert);
                        bsAlert.close();
                    }
                });
            }, 5000);
            
            // Submit form when checkbox is changed
            document.getElementById('showInactive').addEventListener('change', function() {
                this.form.submit();
            });
        </script>
    </body>
</html>
