<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>
<%@ page import="dao.AuthorizationUtil" %>

<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || !AuthorizationUtil.isWarehouseStaff(currentUser)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>My Warehouse Inventory - ${warehouseNameForTitle != null ? warehouseNameForTitle : 'N/A'}</title>

    <link href="${pageContext.request.contextPath}/staff/css/light.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        /* Added CSS styles for inventory overview and warehouse inventory pages */
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f0f4f8;
            color: #212529;
        }

        h1.h3 {
            font-weight: 700;
            margin-bottom: 1rem;
            color: #2c3e50;
            text-shadow: 0 1px 1px rgba(0,0,0,0.1);
        }

        .table.info-table {
            background-color: #ffffff;
            border: 1px solid #b0c4de;
            border-radius: 0.5rem;
            box-shadow: 0 2px 6px rgba(176,196,222,0.3);
        }

        .table.info-table tr:first-child td {
            border-top: none;
        }

        .detail-label {
            font-weight: 700;
            color: #495057;
            min-width: 250px;
            padding-right: 15px;
        }

        .detail-value {
            color: #212529;
        }

        .card {
            box-shadow: 0 0.125rem 0.25rem rgb(0 0 0 / 0.075);
            border-radius: 0.375rem;
            margin-bottom: 1.5rem;
        }

        .card-header {
            background-color: #e9ecef;
            border-bottom: 1px solid #dee2e6;
            padding: 0.75rem 1.25rem;
            border-top-left-radius: 0.375rem;
            border-top-right-radius: 0.375rem;
        }

        .card-title {
            font-weight: 600;
            font-size: 1.25rem;
            color: #343a40;
        }

        .attribute-list li {
            padding: 0.3rem 0;
            font-size: 0.95rem;
        }

        .table-striped > tbody > tr:nth-of-type(odd) {
            background-color: #f2f4f7;
        }

        .btn-outline-primary {
            color: #0d6efd;
            border-color: #0d6efd;
        }

        .btn-outline-primary:hover {
            color: #fff;
            background-color: #0d6efd;
            border-color: #0d6efd;
        }

        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            border-radius: 0.2rem;
        }

        .text-center {
            text-align: center;
        }

        .alert {
            border-radius: 0.375rem;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #842029;
            border-color: #f5c2c7;
        }

        .alert-warning {
            background-color: #fff3cd;
            color: #664d03;
            border-color: #ffecb5;
        }

        .container-fluid {
            padding-left: 1.5rem;
            padding-right: 1.5rem;
        }

        .mb-3 {
            margin-bottom: 1rem !important;
        }

        .float-end {
            float: right !important;
        }
    </style>
</head>

<body>
    <div class="wrapper">
        <%-- Sidebar --%>
        <jsp:include page="/staff/WsSidebar.jsp" />

        <div class="main">
            <%-- Navbar --%>
            <jsp:include page="/staff/navbar.jsp" />

            <main class="content">
                <div class="container-fluid p-0">

                    <div class="mb-3">
                        <h1 class="h3 d-inline align-middle">
                            My Warehouse Inventory: ${warehouseNameForTitle != null ? warehouseNameForTitle : 'Not Assigned'}
                        </h1>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title">Products in Your Assigned Warehouse</h5>
                            <h6 class="card-subtitle text-muted">
                                List of all products currently in stock at your assigned warehouse.
                            </h6>
                        </div>
                        <div class="card-body">
                            <table id="warehouseInventoryTable" class="table table-striped" style="width:100%">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Product Code</th>
                                        <th>Product Name</th>
                                        <th>Description</th>
                                        <th>Quantity</th>
                                        <th>Unit</th>
                                        <th>Price</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${inventoryItems}" varStatus="loop">
                                        <tr>
                                            <td>${loop.count}</td>
                                            <td>${item.productCode}</td>
                                            <td>${item.productName}</td>
                                            <td>${item.productDescription}</td>
                                            <td>${item.quantity}</td>
                                            <td>${item.unit}</td>
                                            <td><fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                                            
                                            <td>
                                                <a href="${pageContext.request.contextPath}/staff/inventory-ws-overview?productId=${item.productId}&warehouseId=${item.warehouseId}" 
                                                   class="btn btn-sm btn-outline-primary">
                                                    <i data-feather="eye"></i> View Details
                                                </a>
                                            </td>
                                            
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty inventoryItems && empty errorMessage}">
                                        <tr>
                                            <td colspan="7" class="text-center">No products found in your assigned warehouse or warehouse not assigned.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>

            <jsp:include page="/staff/footer.jsp" />
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/staff/js/app.js"></script>
</body>
</html>
