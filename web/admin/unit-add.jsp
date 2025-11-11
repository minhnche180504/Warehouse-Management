<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <title>Add Unit | Warehouse System</title>
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
                        <h1 class="h2 mb-3 fw-bold text-primary">Add New Unit</h1>
                        
                        <!-- Error Message -->
                        <% if (request.getAttribute("errorMessage") != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong>Error!</strong> <%= request.getAttribute("errorMessage") %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                        <% } %>
                        
                        <div class="row">
                            <div class="col-12 col-lg-8">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">Unit Details</h5>
                                    </div>
                                    <div class="card-body">
                                        <form action="${pageContext.request.contextPath}/admin/create-unit" method="post">
                                            <div class="mb-3">
                                                <label class="form-label">Unit Name <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control" name="unitName" required
                                                       placeholder="Enter full unit name (e.g., Kilogram)"
                                                       value="${param.unitName}">
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Unit Code <span class="text-danger">*</span></label>
                                                <input type="text" class="form-control" name="unitCode" required
                                                       placeholder="Enter short code (e.g., kg)"
                                                       value="${param.unitCode}"
                                                       maxlength="10">
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Description</label>
                                                <textarea class="form-control" name="description" rows="3"
                                                          placeholder="Enter unit description">${param.description}</textarea>
                                            </div>
                                            <div class="mb-3">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox"
                                                           name="isActive" id="isActive" checked>
                                                    <label class="form-check-label" for="isActive">
                                                        Active
                                                    </label>
                                                </div>
                                            </div>
                                            <div class="text-center mt-4">
                                                <button type="submit" class="btn btn-lg btn-primary">Save Unit</button>
                                                <a href="list-unit" class="btn btn-lg btn-secondary ms-2">Cancel</a>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            <div class="col-12 col-lg-4">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">Unit Information</h5>
                                    </div>
                                    <div class="card-body">
                                        <p>
                                            Units are used to specify the measurement for products in the inventory.
                                        </p>
                                        <p>
                                            <strong>Examples:</strong>
                                        </p>
                                        <ul>
                                            <li><strong>Name:</strong> Kilogram, <strong>Code:</strong> kg</li>
                                            <li><strong>Name:</strong> Piece, <strong>Code:</strong> pcs</li>
                                            <li><strong>Name:</strong> Meter, <strong>Code:</strong> m</li>
                                            <li><strong>Name:</strong> Liter, <strong>Code:</strong> l</li>
                                        </ul>
                                        <p class="mb-0">
                                            <strong>Note:</strong> Unit name and code must be unique in the system.
                                        </p>
                                    </div>
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
        </script>
    </body>
</html>
