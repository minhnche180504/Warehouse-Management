<%@page import="model.User" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    User user = (User) session.getAttribute("user");
    String dashboardURL = request.getContextPath() + "/login"; // Mặc định

    if (user != null) {
        int roleId = user.getRoleId();
        switch (roleId) {
            case 1:
                dashboardURL = request.getContextPath() + "/admin/admindashboard";
                break;
            case 2:
                dashboardURL = request.getContextPath() + "/manager/manager-dashboard";
                break;
            case 3:
                dashboardURL = request.getContextPath() + "/sale/sales-dashboard";
                break;
            case 5:
                dashboardURL = request.getContextPath() + "/purchase/purchase-dashboard";
                break;
            case 4:
                dashboardURL = request.getContextPath() + "/staff/warehouse-staff-dashboard";
                break;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>404 - Page Not Found | Warehouse Pro</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

  
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

      
        <script src="https://unpkg.com/feather-icons"></script>

       
        <link href="${pageContext.request.contextPath}/admin/css/light.css" rel="stylesheet">
    </head>
    <body class="d-flex align-items-center justify-content-center vh-100 bg-light text-center">
        <div>
            <div class="mb-4">
                <i data-feather="alert-octagon" width="64" height="64" class="text-danger"></i>
            </div>
            <h1 class="display-4 fw-bold">404</h1>
            <p class="lead mb-3">Oops! The page you're looking for doesn't exist.</p>
            <p class="text-muted mb-4">It might have been moved or deleted, or you might not have permission to view this page.</p>
            <a href="<%= dashboardURL %>" class="btn btn-primary">
                <i data-feather="arrow-left" class="me-1"></i> Back to Dashboard
            </a>
        </div>

        <script>
            feather.replace();
        </script>
    </body>
</html>
