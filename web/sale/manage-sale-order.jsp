<%-- 
    Document   : manage-sale-order
    Created on : Jun 13, 2025, 1:51:06 PM
    Author     : Nguyen Duc Thinh
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <title>Sales Orders | Warehouse System</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
        <script src="js/settings.js"></script>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <jsp:include page="/sale/SalesSidebar.jsp" />
            <div class="main">
                <jsp:include page="/sale/navbar.jsp" />
                <main class="content">
                    <div class="container-fluid p-0">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h1 class="h2 fw-bold text-primary">Manage Sales Orders</h1>
                        </div>

                        <!-- Messages -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <strong>Success!</strong> ${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <strong>Error!</strong> ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Search and Filter Section -->
                        <div class="card mb-3">
                            <div class="card-body">
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <label class="form-label">Manage Search Orders</label>
                                        <input type="text" class="form-control" placeholder="Order number, customer name..." id="searchInput">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">Status</label>
                                        <select class="form-select" id="statusFilter">
                                            <option value="">All Status</option>
                                            <option value="Pending">Pending</option>
                                            <option value="Processing">Processing</option>
                                            <option value="Completed">Completed</option>
                                            <option value="Cancelled">Cancelled</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">From Date</label>
                                        <input type="date" class="form-control" id="fromDate">
                                    </div>
                                    <div class="col-md-2">
                                        <label class="form-label">&nbsp;</label>
                                        <div class="d-grid">
                                            <button type="button" class="btn btn-outline-secondary" onclick="clearFilters()">Clear</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Orders Table -->
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Sales Orders List</h5>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${empty orders}">
                                        <div class="text-center py-5">
                                            <h5 class="text-muted">No sales orders found</h5>
                                            <p class="text-muted">Sales Order feature is under development.</p>
                                            <a href="create-sales-order" class="btn btn-primary">Create Demo Order</a>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="table-responsive">
                                            <table class="table table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>Order #</th>
                                                        <th>Customer</th>
                                                        <th>Date</th>
                                                        <th>Status</th>
                                                        <th>Total</th>
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="order" items="${orders}">
                                                        <tr>
                                                            <td><strong>${order.orderNumber}</strong></td>
                                                            <td>${order.customerName}</td>
                                                            <td>${order.orderDate}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${order.status == 'Pending'}">
                                                                        <span class="badge bg-warning">${order.status}</span>
                                                                    </c:when>
                                                                    <c:when test="${order.status == 'Approve'}">
                                                                        <span class="badge bg-success">${order.status}</span>
                                                                    </c:when>
                                                                    <c:when test="${order.status == 'Cancelled'}">
                                                                        <span class="badge bg-danger">${order.status}</span>
                                                                    </c:when>
                                                                    <c:when test="${order.status == 'Reject'}">
                                                                        <span class="badge bg-danger">${order.status}</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-secondary">${order.status}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td><strong>${order.totalAmount}</strong></td>
                                                            <td>
                                                                <a href="view-sales-order-detail?id=${order.soId}" 
                                                                   class="btn btn-sm btn-outline-primary" 
                                                                   title="View Details">
                                                                    View
                                                                </a>

                                                                <c:if test="${order.status == 'Pending'}">
                                                                    <a href="approve-sales-order?id=${order.soId}" 
                                                                       class="btn btn-sm btn-outline-success ms-1" 
                                                                       title="Approve Order"
                                                                       onclick="return confirm('Are you sure you want to approve this order?')">
                                                                        Approve
                                                                    </a>

                                                                    <a href="reject-sales-order?id=${order.soId}" 
                                                                       class="btn btn-sm btn-outline-danger ms-1" 
                                                                       title="Reject Order"
                                                                       onclick="return confirm('Are you sure you want to reject this order?')">
                                                                        Reject
                                                                    </a>
                                                                </c:if>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
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
                                                                           setTimeout(function () {
                                                                               const alerts = document.querySelectorAll('.alert');
                                                                               alerts.forEach(function (alert) {
                                                                                   if (alert) {
                                                                                       var bsAlert = new bootstrap.Alert(alert);
                                                                                       bsAlert.close();
                                                                                   }
                                                                               });
                                                                           }, 5000);

                                                                           // Search functionality
                                                                           document.getElementById('searchInput').addEventListener('input', function () {
                                                                               filterTable();
                                                                           });

                                                                           document.getElementById('statusFilter').addEventListener('change', function () {
                                                                               filterTable();
                                                                           });

                                                                           document.getElementById('fromDate').addEventListener('change', function () {
                                                                               filterTable();
                                                                           });

                                                                           function filterTable() {
                                                                               const searchValue = document.getElementById('searchInput').value.toLowerCase();
                                                                               const statusValue = document.getElementById('statusFilter').value.toLowerCase();
                                                                               const fromDateValue = document.getElementById('fromDate').value;
                                                                               const rows = document.querySelectorAll('table tbody tr');

                                                                               rows.forEach(row => {
                                                                                   const cells = row.cells;
                                                                                   if (cells.length > 0) {
                                                                                       const orderNumber = cells[0].textContent.toLowerCase();
                                                                                       const customer = cells[1].textContent.toLowerCase();
                                                                                       const date = cells[2].textContent;
                                                                                       const status = cells[3].textContent.toLowerCase();

                                                                                       let show = true;

                                                                                       // Search filter
                                                                                       if (searchValue && !orderNumber.includes(searchValue) && !customer.includes(searchValue)) {
                                                                                           show = false;
                                                                                       }

                                                                                       // Status filter
                                                                                       if (statusValue && !status.includes(statusValue)) {
                                                                                           show = false;
                                                                                       }

                                                                                       // Date filter
                                                                                       if (fromDateValue && date) {
                                                                                           const rowDate = new Date(date.split('/').reverse().join('-'));
                                                                                           const filterDate = new Date(fromDateValue);
                                                                                           if (rowDate < filterDate) {
                                                                                               show = false;
                                                                                           }
                                                                                       }

                                                                                       row.style.display = show ? '' : 'none';
                                                                                   }
                                                                               });
                                                                           }

                                                                           function clearFilters() {
                                                                               document.getElementById('searchInput').value = '';
                                                                               document.getElementById('statusFilter').value = '';
                                                                               document.getElementById('fromDate').value = '';
                                                                               filterTable();
                                                                           }
        </script>
    </body>
</html>
