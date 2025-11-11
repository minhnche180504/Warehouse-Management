<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <script src="<c:url value='/sale/js/settings.js'/>"></script>
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
        .warehouse-info-card {
            border-left: 4px solid #17a2b8;
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
        
        /* NEW: Profit display styling */
        .profit-info {
            background: #f8f9fa;
            border-radius: 6px;
            padding: 8px 12px;
            margin-top: 8px;
            border-left: 3px solid #28a745;
        }
        
        .profit-positive { color: #28a745; font-weight: 600; }
        .profit-negative { color: #dc3545; font-weight: 600; }
        .profit-zero { color: #6c757d; font-weight: 600; }
        
        .price-breakdown {
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 4px;
        }
        
        .selling-price {
            font-weight: 600;
            color: #007bff;
        }
        
        .cost-price {
            color: #6c757d;
        }
        
        @media print { 
            .no-print { display: none !important; } 
            .card { border: none !important; box-shadow: none !important; } 
            body { font-size: 12px; } 
            .order-header { border-bottom: 3px solid #007bff; margin-bottom: 30px; padding-bottom: 20px; }
            .profit-info { display: none !important; }
        }
    </style>
</head>
<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
    <div class="wrapper">
        <jsp:include page="/sale/SalesSidebar.jsp" />
        <div class="main">
            <jsp:include page="/sale/navbar.jsp" />
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
                            <a href="view-sales-order-list" class="btn btn-outline-secondary me-2">
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
                            
                            <!-- Complete Order Button (for delivery orders) -->
                            <c:if test="${salesOrder.status.toLowerCase() == 'delivery'}">
                                <a href="complete-sales-order?id=${salesOrder.soId}" class="btn btn-success me-2"
                                   onclick="return confirm('Are you sure you want to complete this order?')">
                                    <i class="fas fa-check me-1"></i>Complete Order
                                </a>
                            </c:if>
                            
                            <!-- Return Order Button (for delivery orders) -->
                            <c:if test="${salesOrder.status.toLowerCase() == 'delivery'}">
                                <a href="return-sales-order?id=${salesOrder.soId}" class="btn btn-outline-warning me-2"
                                   onclick="return confirm('Are you sure you want to return this order?')">
                                    <i class="fas fa-undo me-1"></i>Return Order
                                </a>
                            </c:if>
                            
                            <!-- Edit Button (if Order status) -->
                            <c:if test="${salesOrder.status == 'Order'}">
                                <a href="edit-sales-order?id=${salesOrder.soId}" class="btn btn-outline-warning me-2">
                                    <i class="fas fa-edit me-1"></i>Edit Order
                                </a>
                            </c:if>
                            
                            <!-- Actions Dropdown -->
                            <div class="btn-group" role="group">
                                <button type="button" class="btn btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fas fa-cog me-1"></i>Actions
                                </button>
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
                        <div class="col-md-4 mb-4">
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
                                                <c:when test="${salesOrder.status == 'Order'}">
                                                    <span class="badge bg-warning text-dark order-status">Order</span>
                                                </c:when>
                                                <c:when test="${salesOrder.status == 'Delivery'}">
                                                    <span class="badge bg-info text-white order-status">Delivery</span>
                                                </c:when>
                                                <c:when test="${salesOrder.status == 'Completed'}">
                                                    <span class="badge bg-success order-status">Completed</span>
                                                </c:when>
                                                <c:when test="${salesOrder.status == 'Cancelled'}">
                                                    <span class="badge bg-danger order-status">Cancelled</span>
                                                </c:when>
                                                <c:when test="${salesOrder.status == 'returning'}">
                                                    <span class="badge bg-warning text-dark order-status">Returning</span>
                                                </c:when>
                                                <c:when test="${salesOrder.status == 'returned'}">
                                                    <span class="badge bg-secondary order-status">Returned</span>
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
                        <div class="col-md-4 mb-4">
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

                        <!-- Warehouse Information -->
                        <div class="col-md-4 mb-4">
                            <div class="card h-100 warehouse-info-card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-warehouse me-2"></i>Warehouse Information
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="row mb-3">
                                        <div class="col-sm-4"><strong>Warehouse:</strong></div>
                                        <div class="col-sm-8">
                                            <c:choose>
                                                <c:when test="${not empty salesOrder.warehouseName}">
                                                    <i class="fas fa-building text-info me-1"></i>
                                                    ${salesOrder.warehouseName}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Not specified</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <c:if test="${not empty salesOrder.warehouseAddress}">
                                        <div class="row mb-3">
                                            <div class="col-sm-4"><strong>Address:</strong></div>
                                            <div class="col-sm-8">
                                                <i class="fas fa-map-marker-alt text-danger me-1"></i>
                                                ${salesOrder.warehouseAddress}
                                            </div>
                                        </div>
                                    </c:if>
                                    <div class="row mb-3">
                                        <div class="col-sm-4"><strong>Ship From:</strong></div>
                                        <div class="col-sm-8">
                                            <c:choose>
                                                <c:when test="${not empty salesOrder.warehouseName}">
                                                    <i class="fas fa-shipping-fast text-success me-1"></i>
                                                    ${salesOrder.warehouseName}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Warehouse ${salesOrder.warehouseId}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
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
                                                            <th>Product</th>
                                                            <th class="text-center">Quantity</th>
                                                            <th class="text-end">Cost Price</th>
                                                            <th class="text-end">Selling Price</th>
                                                            <th class="text-end">Total Price</th>
                                                            <th class="text-end no-print">Profit</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:set var="totalProfit" value="0" />
                                                        <c:forEach var="item" items="${salesOrder.items}">
                                                            <c:set var="costPrice" value="${item.unitPrice}" />
                                                            <c:set var="sellingPrice" value="${item.sellingPrice != null ? item.sellingPrice : item.unitPrice}" />
                                                            <c:set var="itemProfit" value="${(sellingPrice - costPrice) * item.quantity}" />
                                                            <c:set var="totalProfit" value="${totalProfit + itemProfit}" />
                                                            
                                                            <tr>
                                                                <td>
                                                                    <div>
                                                                        <strong>${item.productCode}</strong>
                                                                        <div class="text-muted small">${item.productName}</div>
                                                                    </div>
                                                                </td>
                                                                <td class="text-center">
                                                                    <span class="badge bg-info">${item.quantity}</span>
                                                                </td>
                                                                <td class="text-end cost-price">
                                                                    <fmt:formatNumber value="${costPrice}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                                </td>
                                                                <td class="text-end selling-price">
                                                                    <fmt:formatNumber value="${sellingPrice}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                                    <c:if test="${sellingPrice != costPrice}">
                                                                        <div class="price-breakdown">
                                                                            <c:set var="profitPercent" value="${costPrice > 0 ? ((sellingPrice - costPrice) / costPrice * 100) : 0}" />
                                                                            <span class="${profitPercent > 0 ? 'profit-positive' : (profitPercent < 0 ? 'profit-negative' : 'profit-zero')}">
                                                                                <fmt:formatNumber value="${profitPercent}" pattern="##0.0" />% markup
                                                                            </span>
                                                                        </div>
                                                                    </c:if>
                                                                </td>
                                                                <td class="text-end">
                                                                    <strong>
                                                                        <fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                                    </strong>
                                                                </td>
                                                                <td class="text-end no-print">
                                                                    <c:set var="unitProfit" value="${sellingPrice - costPrice}" />
                                                                    <span class="${unitProfit > 0 ? 'profit-positive' : (unitProfit < 0 ? 'profit-negative' : 'profit-zero')}">
                                                                        <fmt:formatNumber value="${itemProfit}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                                    </span>
                                                                    <div class="price-breakdown">
                                                                        <fmt:formatNumber value="${unitProfit}" type="currency" currencySymbol="₫" groupingUsed="true"/> per unit
                                                                    </div>
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
                                                            <th class="text-end no-print">
                                                                <span class="${totalProfit > 0 ? 'profit-positive' : (totalProfit < 0 ? 'profit-negative' : 'profit-zero')} total-amount">
                                                                    <fmt:formatNumber value="${totalProfit}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                                </span>
                                                                <div class="price-breakdown">Total Profit</div>
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
                                                        <div class="d-flex justify-content-between mb-2">
                                                            <span>Ship From:</span>
                                                            <strong>
                                                                <c:choose>
                                                                    <c:when test="${not empty salesOrder.warehouseName}">
                                                                        ${salesOrder.warehouseName}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        Warehouse ${salesOrder.warehouseId}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </strong>
                                                        </div>
                                                        <div class="d-flex justify-content-between mb-2 no-print">
                                                            <span>Total Profit:</span>
                                                            <strong class="${totalProfit > 0 ? 'profit-positive' : (totalProfit < 0 ? 'profit-negative' : 'profit-zero')}">
                                                                <fmt:formatNumber value="${totalProfit}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                            </strong>
                                                        </div>
                                                        <c:if test="${salesOrder.totalAmount > 0}">
                                                            <div class="d-flex justify-content-between mb-2 no-print">
                                                                <span>Profit Margin:</span>
                                                                <strong class="${totalProfit > 0 ? 'profit-positive' : (totalProfit < 0 ? 'profit-negative' : 'profit-zero')}">
                                                                    <fmt:formatNumber value="${(totalProfit / salesOrder.totalAmount) * 100}" pattern="##0.0" />%
                                                                </strong>
                                                            </div>
                                                        </c:if>
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

                                            <!-- Profit Analysis (No Print) -->
                                            <c:if test="${totalProfit != 0}">
                                                <div class="profit-info no-print">
                                                    <div class="row">
                                                        <div class="col-md-6">
                                                            <h6 class="mb-2">
                                                                <i class="fas fa-chart-line me-1"></i>Profit Analysis
                                                            </h6>
                                                            <div class="small">
                                                                <div>Total Revenue: <span class="fw-bold"><fmt:formatNumber value="${salesOrder.totalAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/></span></div>
                                                                <div>Total Cost: <span class="fw-bold"><fmt:formatNumber value="${salesOrder.totalAmount - totalProfit}" type="currency" currencySymbol="₫" groupingUsed="true"/></span></div>
                                                                <div class="${totalProfit > 0 ? 'profit-positive' : (totalProfit < 0 ? 'profit-negative' : 'profit-zero')}">
                                                                    Net Profit: <span class="fw-bold"><fmt:formatNumber value="${totalProfit}" type="currency" currencySymbol="₫" groupingUsed="true"/></span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6 text-end">
                                                            <c:if test="${salesOrder.totalAmount > 0}">
                                                                <div class="h4 mb-1 ${totalProfit > 0 ? 'profit-positive' : (totalProfit < 0 ? 'profit-negative' : 'profit-zero')}">
                                                                    <fmt:formatNumber value="${(totalProfit / salesOrder.totalAmount) * 100}" pattern="##0.0" />%
                                                                </div>
                                                                <div class="small text-muted">Profit Margin</div>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
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

    <script src="<c:url value='/sale/js/app.js'/>"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
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
                form.action = '${pageContext.request.contextPath}/sale/email-order';
                
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
                form.action = '${pageContext.request.contextPath}/sale/duplicate-order';
                
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