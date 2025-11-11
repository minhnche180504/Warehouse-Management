<%-- 
    Document   : customer-detail
    Created on : Jun 16, 2025, 2:27:03 PM
    Author     : nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        <title>Customer Details | Warehouse System</title>
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
                        <div class="row mb-3">
                            <div class="col-6">
                                <h1 class="h2 mb-3 fw-bold text-primary">Customer Details</h1>
                            </div>
                            <div class="col-6 text-end">
                                <a href="listCustomer" class="btn btn-secondary me-2">
                                    <i class="align-middle" data-feather="arrow-left"></i> Back to List
                                </a>
                                <a href="updateCustomer?id=${customer.customerId}" class="btn btn-warning me-2">
                                    <i class="align-middle" data-feather="edit-2"></i> Edit
                                </a>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-12">
                                <div class="card shadow-sm">
                                    <div class="card-header pb-0 border-bottom-0">
                                        <h5 class="card-title mb-0 fw-semibold">Customer Information</h5>
                                        <hr class="mt-2 mb-0">
                                    </div>
                                    <div class="card-body pt-3">
                                        <div class="row">
                                            <div class="col-md-6 mb-4">
                                                <h6 class="text-muted mb-2">Customer ID</h6>
                                                <p class="mb-0 fw-semibold">${customer.customerId}</p>
                                            </div>
                                            <div class="col-md-6 mb-4">
                                                <h6 class="text-muted mb-2">Customer Name</h6>
                                                <p class="mb-0 fw-semibold">${customer.customerName}</p>
                                            </div>
                                            <div class="col-md-6 mb-4">
                                                <h6 class="text-muted mb-2">Phone Number</h6>
                                                <p class="mb-0 fw-semibold">${customer.phone != null ? customer.phone : 'N/A'}</p>
                                            </div>
                                            <div class="col-md-6 mb-4">
                                                <h6 class="text-muted mb-2">Email</h6>
                                                <p class="mb-0 fw-semibold">${customer.email != null ? customer.email : 'N/A'}</p>
                                            </div>
                                            <div class="col-12 mb-4">
                                                <h6 class="text-muted mb-2">Address</h6>
                                                <p class="mb-0 fw-semibold">${customer.address != null ? customer.address : 'N/A'}</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Sales Order History Section -->
                        <div class="row mt-4">
                            <div class="col-12">
                                <div class="card shadow-sm">
                                    <div class="card-header pb-0 border-bottom-0">
                                        <h5 class="card-title mb-0 fw-semibold">Purchase History</h5>
                                        <hr class="mt-2 mb-0">
                                    </div>
                                    <div class="card-body pt-3">
                                        <c:if test="${empty orders}">
                                            <div class="text-center py-4">
                                                <i data-feather="shopping-bag" class="text-muted mb-2" style="width: 48px; height: 48px;"></i>
                                                <p class="text-muted mb-0">No purchase history found for this customer.</p>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty orders}">
                                            <div class="table-responsive">
                                                <table class="table table-striped table-hover">
                                                    <thead>
                                                        <tr>
                                                            <th>Order Number</th>
                                                            <th>Date</th>
                                                            <th>Total Amount</th>
                                                            <th>Status</th>
                                                            <th>Created By</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="order" items="${orders}">
                                                            <tr>
                                                                <td>${order.orderNumber}</td>
                                                                <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                                <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="VND"/></td>
                                                                <td>
                                                                    <span class="badge bg-${order.status == 'Completed' ? 'success' : 
                                                                                          order.status == 'Pending' ? 'warning' : 
                                                                                          order.status == 'Cancelled' ? 'danger' : 'secondary'}">
                                                                        ${order.status}
                                                                    </span>
                                                                </td>
                                                                <td>${order.userName}</td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                <footer class="footer">
                    <div class="container-fluid">
                        <div class="row text-muted">
                            <div class="col-6 text-start">
                                <p class="mb-0">
                                    <a class="text-muted" href="#" target="_blank"><strong>Warehouse Management System</strong></a> &copy;
                                </p>
                            </div>
                            <div class="col-6 text-end">
                                <ul class="list-inline">
                                    <li class="list-inline-item">
                                        <a class="text-muted" href="#">Support</a>
                                    </li>
                                    <li class="list-inline-item">
                                        <a class="text-muted" href="#">Help Center</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </footer>
            </div>
        </div>
        <script src="js/app.js"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                feather.replace();
            });
        </script>
    </body>
</html>
