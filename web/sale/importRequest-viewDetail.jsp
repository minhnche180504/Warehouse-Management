<%-- 
    Document   : importRequest-viewDetail
    Created on : Jun 15, 2025, 5:10:06 PM
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
        <title>Import Request Details | Warehouse System</title>
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
                        <!-- Header -->
                        <div class="row mb-3">
                            <div class="col-6">
                                <h1 class="h3 fw-bold">Import Request Details</h1>
                            </div>
                            <div class="col-6 text-end">
                                <a href="importRequestList" class="btn btn-secondary">
                                    <i class="align-middle" data-feather="arrow-left"></i> Back to List
                                </a>
                            </div>
                        </div>

                        <!-- Error Message -->
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                <div class="alert-icon">
                                    <i data-feather="alert-triangle"></i>
                                </div>
                                <div class="alert-message">
                                    <strong>Error!</strong> ${errorMessage}
                                </div>
                            </div>
                        </c:if>

                        <!-- Detail Card -->
                        <div class="row">
                            <div class="col-12">
                                <div class="card shadow-sm">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">Request Information</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <!-- Basic Information -->
                                            <div class="col-md-6">
                                                <h6 class="fw-bold mb-3">Basic Information</h6>
                                                <table class="table table-borderless">
                                                    <tr>
                                                        <th style="width: 40%">Request ID:</th>
                                                        <td>IMR-<fmt:formatNumber value="${importRequest.requestId}" pattern="000"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Request Date:</th>
                                                        <td><fmt:formatDate value="${importRequest.requestDate}" pattern="yyyy-MM-dd"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Status:</th>
                                                        <td>
                                                            <span class="badge bg-${importRequest.status == 'Pending' ? 'warning' : 
                                                                                    importRequest.status == 'Approved' ? 'success' : 
                                                                                    importRequest.status == 'Rejected' ? 'danger' : 'secondary'}">
                                                                ${importRequest.status}
                                                            </span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Created By:</th>
                                                        <td>${importRequest.createdByName}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>Warehouse:</th>
                                                        <td>${warehouseName}</td>
                                                    </tr>
                                                </table>
                                            </div>

                                            <!-- Reason Section -->
                                            <div class="col-md-6">
                                                <h6 class="fw-bold mb-3">Reason</h6>
                                                <div class="card bg-light">
                                                    <div class="card-body">
                                                        <p class="mb-0">${importRequest.reason}</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Product Items Table -->
                                        <div class="row mt-4">
                                            <div class="col-12">
                                                <h6 class="fw-bold mb-3">Product Items</h6>
                                                <div class="table-responsive">
                                                    <table class="table table-bordered">
                                                        <thead>
                                                            <tr>
                                                                <th>Product Name</th>
                                                                <th>Product Code</th>
                                                                <th>Quantity</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach items="${importRequest.details}" var="detail">
                                                                <tr>
                                                                    <td>${detail.productName}</td>
                                                                    <td>${detail.productCode}</td>
                                                                    <td>${detail.quantity}</td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
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
                if (typeof feather !== 'undefined') {
                    feather.replace();
                }
            });
        </script>
    </body>
</html>
