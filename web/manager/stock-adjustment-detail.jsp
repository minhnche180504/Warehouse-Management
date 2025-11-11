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
        <style>
            /* Đảm bảo nút Approve không kéo dài */
            .btn-group {
                display: flex;
                justify-content: space-between; /* Đảm bảo khoảng cách giữa các nút */
                gap: 10px; /* Khoảng cách giữa các nút */
                width: auto; /* Đảm bảo container không kéo dài ra */
            }

            .btn-group button {
                flex-grow: 0; /* Không cho phép nút kéo dài */
                padding: 10px 20px; /* Padding cho nút */
                font-size: 14px; /* Kích thước chữ */
                height: 40px; /* Chiều cao cố định */
                box-sizing: border-box; /* Đảm bảo nút có kích thước đúng */
            }

            /* Cải thiện giao diện khi nút bị nhấn */
            #approveForm button,
            #rejectForm button {
                height: 40px; /* Đảm bảo chiều cao cố định */
                padding: 10px 20px; /* Padding cho nút */
                font-size: 14px;
                text-align: center;
                box-sizing: border-box;
                width: auto; /* Đảm bảo nút không kéo dài ra */
            }

        </style>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <jsp:include page="/manager/ManagerSidebar.jsp" />
            <div class="main">
                <jsp:include page="/manager/navbar.jsp" />
                <main class="content">
                    <div class="container-fluid p-0">
                        <!-- Header -->
                        <div class="row mb-3">
                            <div class="col-6">
                                <h1 class="h3 fw-bold">Approve Adjustment Stock</h1>
                            </div>
                            <div class="col-6 text-end">
                                <a href="stock-request" class="btn btn-secondary">
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
                                                        <td>${importRequest.requestId}</td>
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

                                                    <!-- Order Type -->
                                                    <h6 class="fw-bold mb-3">Order Type</h6>
                                                    <form action="process-import-request" method="post" id="approveForm">
                                                        <select name="orderType" class="form-select" required>
                                                            <option value="">Select order type</option>
                                                            <option value="Purchase Order" ${importRequest.type == 'Purchase Order' ? 'selected' : ''}>Purchase Order</option>
                                                            <option value="Transfer Order" ${importRequest.type == 'Transfer Order' ? 'selected' : ''}>Transfer Order</option>
                                                        </select>

                                                        <input type="hidden" name="requestId" value="${importRequest.requestId}" />
                                                        <input type="hidden" name="action" value="approve" />
                                                    </form>
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

                                                        <!-- Action Buttons - Align both buttons at the bottom, horizontally -->
                                                        <c:if test="${importRequest.status == 'Pending'}">
                                                            <div class="row mt-4">
                                                                <div class="col-12 text-center">
                                                                    <div class="btn-group" role="group">
                                                                        <button type="submit" form="approveForm" class="btn btn-success">Approve</button>
                                                                        <form id="rejectForm" action="process-import-request" method="post" style="display: inline-block;">
                                                                            <input type="hidden" name="requestId" value="${importRequest.requestId}" />
                                                                            <input type="hidden" name="action" value="reject" />
                                                                            <div id="rejectionReasonContainer" style="display: none; margin-bottom: 10px;">
                                                                                <textarea name="rejectionReason" class="form-control mb-2" rows="3" placeholder="Enter rejection reason..." required></textarea>
                                                                            </div>
                                                                            <button type="button" class="btn btn-danger btn-lg px-4" onclick="showRejectionReason()">Reject</button>
                                                                            <button id="confirmRejectBtn" type="submit" class="btn btn-danger btn-sm mt-2" style="display: none;">Confirm Reject</button>
                                                                        </form>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:if>
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
            function showRejectionReason() {
                document.getElementById('rejectionReasonContainer').style.display = 'block';
                document.getElementById('confirmRejectBtn').style.display = 'inline-block';
            }
            </script>
        </body>
    </html>
