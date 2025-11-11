FR<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        <title>Sales Order Detail | Warehouse System</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">

        <!-- Font Awesome -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

        <!-- iziToast -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css" rel="stylesheet">

        <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
        <script src="js/settings.js"></script>
        <style>
            .order-status {
                font-size: 1.1em;
                font-weight: bold;
            }
            .order-info-card {
                border-left: 4px solid #007bff;
            }
            .customer-info-card {
                border-left: 4px solid #28a745;
            }
            .items-card {
                border-left: 4px solid #ffc107;
            }
            .total-amount {
                font-size: 1.5rem;
                font-weight: bold;
                color: #28a745;
            }
            .item-row {
                border-bottom: 1px solid #eee;
                padding: 12px 0;
            }
            .item-row:last-child {
                border-bottom: none;
            }
            @media print {
                .no-print {
                    display: none !important;
                }
                .card {
                    border: none !important;
                    box-shadow: none !important;
                }
                body {
                    font-size: 12px;
                }
                .order-header {
                    border-bottom: 3px solid #007bff;
                    margin-bottom: 30px;
                    padding-bottom: 20px;
                }
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
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <h1 class="h2 fw-bold text-primary order-header">Sales Order Detail</h1>
                                <nav aria-label="breadcrumb" class="no-print">
                                    <ol class="breadcrumb">
                                        <li class="breadcrumb-item"><a href="view-sales-order-list">Sales Orders</a></li>
                                        <li class="breadcrumb-item active">Order #${salesOrder.orderNumber}</li>
                                    </ol>
                                </nav>
                            </div>
                            <div class="no-print">
                                <a href="manage-sale-order" class="btn btn-outline-secondary me-2">
                                    <i class="fas fa-arrow-left me-1"></i>Back to List
                                </a>

                                <!-- Print Button -->
                                <button type="button" class="btn btn-outline-primary me-2" onclick="window.print()">
                                    <i class="fas fa-print me-1"></i>Print
                                </button>

                                <!-- Export Excel Button -->
                                <button type="button" class="btn btn-outline-success me-2" onclick="exportToExcel()">
                                    <i class="fas fa-file-excel me-1"></i>Export Excel
                                </button>

                                <!-- Edit Button (if Pending) -->


                                <!-- Actions Dropdown -->
                                <div class="btn-group" role="group">
                                    <!--                                <button type="button" class
                                                                    </button>="btn btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                                                                        <i class="fas fa-cog me-1"></i>Actions-->
                                    <ul class="dropdown-menu">
                                        <!-- Debug info -->
                                        <li><span class="dropdown-item-text small text-muted">Status: ${salesOrder.status}</span></li>
                                        <li><hr class="dropdown-divider"></li>

                                        <li>
                                            <a class="dropdown-item" href="#" onclick="emailOrder()">
                                                <i class="fas fa-envelope me-2"></i>Email Order
                                            </a>
                                        </li>
                                        <li>
                                            <a class="dropdown-item" href="#" onclick="duplicateOrder()">
                                                <i class="fas fa-copy me-2"></i>Duplicate Order
                                            </a>
                                        </li>
                                        <c:if test="${salesOrder.status != 'Cancelled' && salesOrder.status != 'Completed'}">
                                            <li><hr class="dropdown-divider"></li>
                                            <li>
                                                <a class="dropdown-item text-danger" href="cancel-sales-order?id=${salesOrder.soId}"
                                                   onclick="return confirm('Are you sure you want to cancel this order?')">
                                                    <i class="fas fa-times me-2"></i>Cancel Order
                                                </a>
                                            </li>
                                        </c:if>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Messages -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show no-print" role="alert">
                                <strong>Success!</strong> ${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show no-print" role="alert">
                                <strong>Error!</strong> ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <div class="row">
                            <!-- Order Information -->
                            <div class="col-md-6 mb-4">
                                <div class="card h-100 order-info-card">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">
                                            <i class="fas fa-shopping-cart me-2"></i>Order Information
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Order Number:</strong></div>
                                            <div class="col-sm-8">${salesOrder.orderNumber}</div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Status:</strong></div>
                                            <div class="col-sm-8">
                                                <c:choose>
                                                    <c:when test="${salesOrder.status == 'Pending'}">
                                                        <span class="badge bg-warning order-status">${salesOrder.status}</span>
                                                    </c:when>
                                                    <c:when test="${salesOrder.status == 'Processing'}">
                                                        <span class="badge bg-primary order-status">${salesOrder.status}</span>
                                                    </c:when>
                                                    <c:when test="${salesOrder.status == 'Completed'}">
                                                        <span class="badge bg-success order-status">${salesOrder.status}</span>
                                                    </c:when>
                                                    <c:when test="${salesOrder.status == 'Cancelled'}">
                                                        <span class="badge bg-danger order-status">${salesOrder.status}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary order-status">${salesOrder.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Order Date:</strong></div>
                                            <div class="col-sm-8">
                                                <fmt:formatDate value="${salesOrder.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </div>
                                        </div>
                                        <c:if test="${not empty salesOrder.deliveryDate}">
                                            <div class="row mb-3">
                                                <div class="col-sm-4"><strong>Delivery Date:</strong></div>
                                                <div class="col-sm-8">
                                                    <fmt:formatDate value="${salesOrder.deliveryDate}" pattern="dd/MM/yyyy"/>
                                                </div>
                                            </div>
                                        </c:if>
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Created By:</strong></div>
                                            <div class="col-sm-8">${salesOrder.userName}</div>
                                        </div>
                                        <c:if test="${not empty salesOrder.notes}">
                                            <div class="row mb-3">
                                                <div class="col-sm-4"><strong>Notes:</strong></div>
                                                <div class="col-sm-8">${salesOrder.notes}</div>
                                            </div>
                                        </c:if>

                                        <!-- Cancellation Information -->
                                        <c:if test="${salesOrder.status == 'Cancelled'}">
                                            <hr>
                                            <div class="row mb-3">
                                                <div class="col-sm-4"><strong>Cancelled By:</strong></div>
                                                <div class="col-sm-8">${salesOrder.cancelledByName}</div>
                                            </div>
                                            <div class="row mb-3">
                                                <div class="col-sm-4"><strong>Cancelled At:</strong></div>
                                                <div class="col-sm-8">
                                                    <fmt:formatDate value="${salesOrder.cancelledAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </div>
                                            </div>
                                            <c:if test="${not empty salesOrder.cancellationReason}">
                                                <div class="row mb-3">
                                                    <div class="col-sm-4"><strong>Reason:</strong></div>
                                                    <div class="col-sm-8">${salesOrder.cancellationReason}</div>
                                                </div>
                                            </c:if>
                                        </c:if>
                                    </div>
                                </div>
                            </div>

                            <!-- Customer Information -->
                            <div class="col-md-6 mb-4">
                                <div class="card h-100 customer-info-card">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">
                                            <i class="fas fa-user me-2"></i>Customer Information
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Customer Name:</strong></div>
                                            <div class="col-sm-8">${salesOrder.customerName}</div>
                                        </div>
                                        <c:if test="${not empty salesOrder.customerEmail}">
                                            <div class="row mb-3">
                                                <div class="col-sm-4"><strong>Email:</strong></div>
                                                <div class="col-sm-8">${salesOrder.customerEmail}</div>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty salesOrder.deliveryAddress}">
                                            <div class="row mb-3">
                                                <div class="col-sm-4"><strong>Delivery Address:</strong></div>
                                                <div class="col-sm-8">${salesOrder.deliveryAddress}</div>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Order Items -->
                        <div class="row">
                            <div class="col-12">
                                <div class="card items-card">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">
                                            <i class="fas fa-box me-2"></i>Order Items
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <c:choose>
                                            <c:when test="${empty salesOrder.items}">
                                                <div class="text-center py-4">
                                                    <h6 class="text-muted">No items found in this order</h6>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="table-responsive">
                                                    <table class="table table-hover" id="orderItemsTable">
                                                        <thead class="table-light">
                                                            <tr>
                                                                <th>Product Code</th>
                                                                <th>Product Name</th>
                                                                <th class="text-center">Quantity</th>
                                                                <th class="text-end">Unit Price</th>
                                                                <th class="text-end">Total Price</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="item" items="${salesOrder.items}">
                                                                <tr>
                                                                    <td><strong>${item.productCode}</strong></td>
                                                                    <td>${item.productName}</td>
                                                                    <td class="text-center">
                                                                        <span class="badge bg-info">${item.quantity}</span>
                                                                    </td>
                                                                    <td class="text-end">
                                                                        <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                                    </td>
                                                                    <td class="text-end">
                                                                        <strong>
                                                                            <fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                                        </strong>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                        <tfoot class="table-light">
                                                            <tr>
                                                                <th colspan="4" class="text-end">Total Amount:</th>
                                                                <th class="text-end total-amount">
                                                                    <fmt:formatNumber value="${salesOrder.totalAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                                </th>
                                                            </tr>
                                                        </tfoot>
                                                    </table>
                                                </div>

                                                <!-- Order Summary -->
                                                <div class="row mt-4">
                                                    <div class="col-md-6 offset-md-6">
                                                        <div class="border rounded p-3 bg-light">
                                                            <div class="d-flex justify-content-between mb-2">
                                                                <span>Total Items:</span>
                                                                <strong>${salesOrder.items.size()}</strong>
                                                            </div>
                                                            <div class="d-flex justify-content-between mb-2">
                                                                <span>Total Quantity:</span>
                                                                <strong>
                                                                    <c:set var="totalQuantity" value="0"/>
                                                                    <c:forEach var="item" items="${salesOrder.items}">
                                                                        <c:set var="totalQuantity" value="${totalQuantity + item.quantity}"/>
                                                                    </c:forEach>
                                                                    ${totalQuantity}
                                                                </strong>
                                                            </div>
                                                            <hr>
                                                            <div class="d-flex justify-content-between">
                                                                <span class="h5">Grand Total:</span>
                                                                <span class="h5 total-amount">
                                                                    <fmt:formatNumber value="${salesOrder.totalAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                                </span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Centered Approve and Reject Buttons with smaller spacing, visible only if status is 'Pending' -->
                                                <c:if test="${salesOrder.status == 'Pending'}">
                                                    <div class="d-flex justify-content-center mt-4">
                                                        <a href="approve-sales-order?id=${salesOrder.soId}" 
                                                           class="btn btn-lg btn-outline-success me-3" 
                                                           title="Approve Order"
                                                           style="font-size: 1.25rem; padding: 12px 24px; text-align: center; background-color: #28a745; color: white;"
                                                           onclick="return confirm('Are you sure you want to approve this order?')">
                                                            Approve
                                                        </a>

                                                        <button type="button" 
                                                                class="btn btn-lg btn-outline-danger" 
                                                                title="Reject Order"
                                                                style="font-size: 1.25rem; padding: 12px 24px; text-align: center; background-color: #dc3545; color: white;"
                                                                data-bs-toggle="modal" data-bs-target="#rejectModal">
                                                            Reject
                                                        </button>
                                                    </div>
                                                </c:if>

                                                <!-- Modal for rejecting the order -->
                                                <div class="modal fade" id="rejectModal" tabindex="-1" aria-labelledby="rejectModalLabel" aria-hidden="true">
                                                    <div class="modal-dialog">
                                                        <div class="modal-content">
                                                            <div class="modal-header">
                                                                <h5 class="modal-title" id="rejectModalLabel">Reject Order</h5>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                            </div>
                                                            <div class="modal-body">
                                                                <form action="${pageContext.request.contextPath}/manager/reject-sales-order" method="GET">

                                                                    <!-- Hidden input to send orderId -->
                                                                    <input type="hidden" name="id" id="orderIdInput" value="${salesOrder.soId}" />

                                                                    <div class="mb-3">
                                                                        <label for="rejectionReason" class="form-label">Reason for Rejection</label>
                                                                        <textarea id="rejectionReason" name="reason" class="form-control" rows="4" placeholder="Please enter the reason for rejecting the order" required></textarea>
                                                                    </div>

                                                                    <div class="modal-footer">
                                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                        <button type="submit" class="btn btn-danger">Reject</button>
                                                                    </div>
                                                                </form>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Footer -->
                        <div class="row mt-4 no-print">
                            <div class="col-12 text-center">
                                <p class="text-muted mb-0">
                                    <small>
                                        This document was automatically generated by the Warehouse Management System at 
                                        <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm:ss" />
                                    </small>
                                </p>
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
        <!-- Include Bootstrap 5 JS and CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
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

                                                               // Export functions
                                                               function exportToExcel() {
                                                                   const table = document.getElementById('orderItemsTable');
                                                                   const html = table.outerHTML;

                                                                   const link = document.createElement('a');
                                                                   link.download = 'sales-order-${salesOrder.orderNumber}.xls';
                                                                   link.href = 'data:application/vnd.ms-excel,' + encodeURIComponent(html);

                                                                   document.body.appendChild(link);
                                                                   link.click();
                                                                   document.body.removeChild(link);

                                                                   iziToast.success({
                                                                       title: 'Success',
                                                                       message: 'Sales order exported to Excel!',
                                                                       position: 'topRight'
                                                                   });
                                                               }

                                                               function emailOrder() {
                                                                   if (confirm('Send order confirmation email to customer?')) {
                                                                       const orderId = ${salesOrder.soId};
                                                                       const form = document.createElement('form');
                                                                       form.method = 'POST';
                                                                       form.action = '${pageContext.request.contextPath}/manager/email-order';
                                                                       
                                                                       const input = document.createElement('input');
                                                                       input.type = 'hidden';
                                                                       input.name = 'id';
                                                                       input.value = orderId;
                                                                       form.appendChild(input);
                                                                       
                                                                       document.body.appendChild(form);
                                                                       form.submit();
                                                                   }
                                                               }

                                                               function duplicateOrder() {
                                                                   if (confirm('Are you sure you want to duplicate this order? A new order will be created with the same items.')) {
                                                                       const orderId = ${salesOrder.soId};
                                                                       const form = document.createElement('form');
                                                                       form.method = 'POST';
                                                                       form.action = '${pageContext.request.contextPath}/manager/duplicate-order';
                                                                       
                                                                       const input = document.createElement('input');
                                                                       input.type = 'hidden';
                                                                       input.name = 'id';
                                                                       input.value = orderId;
                                                                       form.appendChild(input);
                                                                       
                                                                       document.body.appendChild(form);
                                                                       form.submit();
                                                                   }
                                                               }
        </script>
    </body>
</html>