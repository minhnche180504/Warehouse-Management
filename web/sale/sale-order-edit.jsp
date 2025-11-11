<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Edit Sales Order | Warehouse System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
    <style>
        /* Edit Page Header - Clean orange header */
        .edit-header {
            background: linear-gradient(135deg, #fd7e14 0%, #dc6f00 100%);
            color: white;
            padding: 2rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            box-shadow: 0 4px 20px rgba(253, 126, 20, 0.2);
        }
        
        .edit-header .page-title {
            margin: 0;
            font-size: 2rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .edit-header .breadcrumb {
            background: none;
            padding: 0;
            margin: 0.5rem 0 0 0;
        }
        
        .edit-header .breadcrumb-item {
            color: rgba(255, 255, 255, 0.7);
        }
        
        .edit-header .breadcrumb-item a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            transition: color 0.3s ease;
        }
        
        .edit-header .breadcrumb-item a:hover {
            color: white;
        }
        
        .edit-header .breadcrumb-item.active {
            color: white;
            font-weight: 600;
        }
        
        .edit-header .btn-light {
            background: rgba(255, 255, 255, 0.95);
            border: none;
            color: #dc6f00;
            font-weight: 600;
            border-radius: 8px;
            padding: 0.75rem 1.5rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .edit-header .btn-light:hover {
            background: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(255, 255, 255, 0.3);
            color: #dc6f00;
        }
        
        .edit-header .btn-outline-light {
            border: 2px solid rgba(255, 255, 255, 0.7);
            color: white;
            font-weight: 600;
            border-radius: 8px;
            padding: 0.75rem 1.5rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .edit-header .btn-outline-light:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: white;
            color: white;
            transform: translateY(-2px);
        }
        
        .edit-header .header-actions {
            display: flex;
            gap: 0.75rem;
            align-items: center;
        }
        
        /* Product Selection Area - Blue theme consistent with add page */
        .product-selection-area {
            border: 2px dashed #dee2e6;
            border-radius: 12px;
            padding: 2rem;
            margin-bottom: 20px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            text-align: center;
            transition: all 0.3s ease;
        }
        
        .product-selection-area:hover {
            border-color: #007bff;
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
        }
        
        /* Blue theme for buttons to match add page */
        .add-product-btn {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            border: none;
            color: white;
            padding: 12px 30px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(0, 123, 255, 0.3);
        }
        
        .add-product-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 123, 255, 0.4);
            background: linear-gradient(135deg, #0056b3 0%, #004085 100%);
            color: white;
        }
        
        /* Edit warning box - subtle orange accent */
        .edit-warning {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            border: 1px solid #fd7e14;
            border-radius: 12px;
            padding: 2rem;
            margin-bottom: 2rem;
            border-left: 4px solid #fd7e14;
            box-shadow: 0 2px 10px rgba(253, 126, 20, 0.1);
        }
        
        .edit-warning .warning-icon {
            background: linear-gradient(135deg, #fd7e14 0%, #dc6f00 100%);
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            margin-right: 1rem;
            flex-shrink: 0;
        }
        
        /* Selected Products Container - Blue theme */
        .selected-products-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .selected-product-header {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
            padding: 15px 20px;
            border-bottom: 2px solid #007bff;
            font-weight: 600;
        }
        
        .selected-product-item {
            border-bottom: 1px solid #f1f3f4;
            padding: 20px;
            transition: background-color 0.3s ease;
        }
        
        .selected-product-item:hover {
            background-color: #f8f9fa;
        }
        
        .selected-product-item:last-child {
            border-bottom: none;
        }
        
        /* Original Order Info Box */
        .original-info {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 12px;
            padding: 2rem;
            margin-bottom: 2rem;
            border-left: 4px solid #6c757d;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .order-info-badge {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 600;
            display: inline-block;
        }
        
        /* Status Badge Display */
        .status-badge {
            padding: 0.5rem 0.75rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.875rem;
            display: inline-block;
        }
        
        .status-order {
            background: linear-gradient(135deg, #ffc107 0%, #ffb300 100%);
            color: #856404;
        }
        
        .status-delivery {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
        }
        
        .status-completed {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        
        .status-cancelled {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            color: white;
        }
        
        /* Current Items Table */
        .current-items-section {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border: 1px solid #dee2e6;
        }
        
        .current-items-header {
            color: #495057;
            font-weight: 600;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #dee2e6;
        }
        
        /* Modal styling - Blue theme */
        .product-modal .modal-dialog {
            max-width: 900px;
        }
        
        .modal-header {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
            border-bottom: none;
        }
        
        .modal-header .btn-close {
            filter: invert(1);
        }
        
        .search-container {
            background: #f8f9fa;
            padding: 20px;
            border-bottom: 1px solid #dee2e6;
        }
        
        .product-table {
            max-height: 400px;
            overflow-y: auto;
        }
        
        .product-row {
            cursor: pointer;
            transition: background-color 0.2s ease;
        }
        
        .product-row:hover {
            background-color: #f8f9fa;
        }
        
        /* Quantity Controls */
        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .quantity-btn {
            width: 30px;
            height: 30px;
            border: 1px solid #dee2e6;
            background: white;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .quantity-btn:hover:not(:disabled) {
            background: #e9ecef;
            border-color: #007bff;
        }
        
        .quantity-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        
        .quantity-input {
            width: 80px;
            text-align: center;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            padding: 6px;
        }
        
        .quantity-input:disabled {
            background-color: #f8f9fa;
            opacity: 0.5;
        }
        
        /* UPDATED: Price Controls Styling - Same as add page */
        .price-controls {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            margin-top: 10px;
        }
        
        .price-input {
            width: 120px;
            text-align: right;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            padding: 6px 8px;
            font-weight: 600;
        }
        
        .price-input:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }
        
        .profit-display {
            font-size: 0.875rem;
            font-weight: 600;
        }
        
        .profit-positive { color: #28a745; }
        .profit-negative { color: #dc3545; }
        .profit-zero { color: #6c757d; }
        
        .profit-percentage-input {
            width: 80px;
            text-align: center;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            padding: 4px 6px;
        }
        
        .btn-auto-profit {
            background: #28a745;
            border: none;
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.75rem;
            transition: all 0.2s ease;
            margin-right: 6px;
        }
        
        .btn-auto-profit:hover {
            background: #218838;
            color: white;
        }
        
        .profit-buttons-container {
            display: flex;
            gap: 8px;
            align-items: center;
        }
        
        /* Stock Badges */
        .stock-badge {
            font-size: 0.85rem;
            padding: 4px 8px;
            border-radius: 12px;
        }
        
        .stock-high { background-color: #d4edda; color: #155724; }
        .stock-medium { background-color: #fff3cd; color: #856404; }
        .stock-low { background-color: #f8d7da; color: #721c24; }
        .stock-out { background-color: #f5c6cb; color: #721c24; }
        
        /* Product Info */
        .product-info {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        
        .product-name {
            font-weight: 600;
            color: #212529;
        }
        
        .product-code {
            font-size: 0.875rem;
            color: #6c757d;
        }
        
        .price-display {
            font-weight: 600;
            color: #28a745;
            font-size: 1.1rem;
        }
        
        /* Select Product Button */
        .btn-select-product {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-select-product:hover:not(:disabled) {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
            color: white;
        }
        
        .btn-select-product:disabled {
            background: #6c757d;
            transform: none;
            box-shadow: none;
            cursor: not-allowed;
            opacity: 0.5;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }
        
        /* Total Summary - Blue theme to match add page */
        .total-summary {
            background: linear-gradient(135deg, #e8f5e8 0%, #d4edda 100%);
            border-radius: 12px;
            padding: 20px;
            margin-top: 20px;
        }
        
        /* Search Input */
        .search-input {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 12px 16px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }
        
        .search-input:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
            outline: none;
        }
        
        /* Update Order Button - Orange accent for edit mode */
        .btn-update-order {
            background: linear-gradient(135deg, #fd7e14 0%, #dc6f00 100%);
            border: none;
            color: white;
            font-weight: 600;
            padding: 0.75rem 2rem;
            border-radius: 8px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(253, 126, 20, 0.3);
        }
        
        .btn-update-order:hover {
            background: linear-gradient(135deg, #dc6f00 0%, #bf6000 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(253, 126, 20, 0.4);
            color: white;
        }
        
        /* Form styling improvements */
        .form-select, .form-control {
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
        }
        
        .form-select:focus, .form-control:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }
        
        /* Card improvements */
        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        
        .card-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-bottom: 2px solid #dee2e6;
            padding: 1.5rem 2rem;
        }
        
        .card-body {
            padding: 2rem;
        }
        
        /* Responsive improvements */
        @media (max-width: 768px) {
            .edit-header {
                padding: 1.5rem;
                text-align: center;
            }
            
            .edit-header .d-flex {
                flex-direction: column;
                gap: 1rem;
            }
            
            .edit-header .header-actions {
                justify-content: center;
                flex-wrap: wrap;
            }
            
            .original-info .row > div {
                margin-bottom: 1rem;
            }
            
            .product-modal .modal-dialog {
                max-width: 95%;
                margin: 1rem auto;
            }
            
            .quantity-controls {
                flex-direction: column;
                gap: 5px;
            }
            
            .quantity-input {
                width: 100%;
            }
            
            .edit-warning {
                padding: 1.5rem;
            }
            
            .warning-icon {
                margin-bottom: 1rem;
                margin-right: 0;
            }
            
            .price-controls {
                padding: 10px;
            }
            
            .price-input {
                width: 100%;
                margin-bottom: 5px;
            }
        }
        
        /* Fix for dropdown and form elements */
        .form-select {
            cursor: pointer;
            position: relative;
            z-index: 1;
        }
        
        .form-select:disabled {
            cursor: not-allowed;
            opacity: 0.5;
        }
        
        /* Ensure modal appears above everything */
        .modal {
            z-index: 1055;
        }
        
        .modal-backdrop {
            z-index: 1050;
        }
        
        /* Sidebar toggle fix */
        .sidebar-toggle {
            z-index: 1040;
        }
        
        /* Ensure form elements are clickable */
        .form-control,
        .form-select,
        .btn {
            position: relative;
            z-index: 1;
        }
        
        /* Alert improvements */
        .alert {
            border: none;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
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
                    <!-- Clean Edit Header -->
                    <div class="edit-header">
                        <div class="d-flex justify-content-between align-items-start flex-wrap">
                            <div>
                                <h1 class="page-title">
                                    <i class="fas fa-edit"></i>
                                    Edit Sales Order
                                </h1>
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb">
                                        <li class="breadcrumb-item">
                                            <a href="view-sales-order-list">Sales Orders</a>
                                        </li>
                                        <li class="breadcrumb-item">
                                            <a href="view-sales-order-detail?id=${salesOrder.soId}">${salesOrder.orderNumber}</a>
                                        </li>
                                        <li class="breadcrumb-item active">Edit</li>
                                    </ol>
                                </nav>
                            </div>
                            <div class="header-actions">
                                <a href="view-sales-order-detail?id=${salesOrder.soId}" class="btn btn-light">
                                    <i class="fas fa-eye"></i>
                                    View Detail
                                </a>
                                <a href="view-sales-order-list" class="btn btn-outline-light">
                                    <i class="fas fa-arrow-left"></i>
                                    Back to List
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Messages -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <strong>Success!</strong> <c:out value="${success}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong>Error!</strong> <c:out value="${error}" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Edit Warning -->
                    <div class="edit-warning">
                        <div class="d-flex align-items-start">
                            <div class="warning-icon">
                                <i class="fas fa-exclamation-triangle"></i>
                            </div>
                            <div>
                                <h5 class="text-warning fw-bold mb-3">Edit Mode Instructions</h5>
                                <div class="text-dark">
                                    <p class="mb-2">
                                        <strong>To edit this order:</strong> Click "Select Products" button below to choose products. 
                                        Your new selection will <strong>REPLACE ALL</strong> current products.
                                    </p>
                                    <p class="mb-2">
                                        <strong>Current items:</strong> ${salesOrder.items.size()} products worth 
                                        <fmt:formatNumber value="${salesOrder.totalAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                    </p>
                                    <p class="mb-0">
                                        <strong>Note:</strong> Only orders with "Order" status can be edited. Stock availability will be checked.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Original Order Info -->
                    <div class="original-info">
                        <h6 class="text-muted mb-3 fw-bold">
                            <i class="fas fa-info-circle me-2"></i>Original Order Information
                        </h6>
                        <div class="row align-items-center">
                            <div class="col-md-3">
                                <div class="mb-2">
                                    <strong class="text-muted">Order Number:</strong><br>
                                    <span class="order-info-badge">${salesOrder.orderNumber}</span>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="mb-2">
                                    <strong class="text-muted">Status:</strong><br>
                                    <c:choose>
                                        <c:when test="${salesOrder.status == 'Order'}">
                                            <span class="status-badge status-order">Order</span>
                                        </c:when>
                                        <c:when test="${salesOrder.status == 'Delivery'}">
                                            <span class="status-badge status-delivery">Delivery</span>
                                        </c:when>
                                        <c:when test="${salesOrder.status == 'Completed'}">
                                            <span class="status-badge status-completed">Completed</span>
                                        </c:when>
                                        <c:when test="${salesOrder.status == 'Cancelled'}">
                                            <span class="status-badge status-cancelled">Cancelled</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">${salesOrder.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="mb-2">
                                    <strong class="text-muted">Created:</strong><br>
                                    <span class="text-dark fw-medium">
                                        <fmt:formatDate value="${salesOrder.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </span>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="mb-2">
                                    <strong class="text-muted">Original Total:</strong><br>
                                    <span class="text-success fw-bold fs-6">
                                        <fmt:formatNumber value="${salesOrder.totalAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Edit Order Form -->
                    <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-edit me-2"></i>Edit Order Information
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <form method="post" action="edit-sales-order" accept-charset="UTF-8" id="editOrderForm">
                                        <input type="hidden" name="soId" value="${salesOrder.soId}">
                                        
                                        <!-- Basic Order Info -->
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label for="customerId" class="form-label">Customer <span class="text-danger">*</span></label>
                                                <select class="form-select" id="customerId" name="customerId" required>
                                                    <option value="">-- Select Customer --</option>
                                                    <c:forEach var="customer" items="${customers}">
                                                        <option value="${customer.customerId}" 
                                                                data-address="${customer.address}"
                                                                ${customer.customerId == salesOrder.customerId ? 'selected' : ''}>
                                                            <c:out value="${customer.customerName}" />
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="warehouseId" class="form-label">Warehouse <span class="text-danger">*</span></label>
                                                <select class="form-select" id="warehouseId" name="warehouseId" required>
                                                    <option value="">-- Select Warehouse --</option>
                                                    <c:forEach var="warehouse" items="${warehouses}">
                                                        <option value="${warehouse.warehouseId}"
                                                                ${warehouse.warehouseId == salesOrder.warehouseId ? 'selected' : ''}>
                                                            <c:out value="${warehouse.warehouseName}" />
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label for="orderDate" class="form-label">Order Date</label>
                                                <input type="date" class="form-control" id="orderDate" name="orderDate" 
                                                       value="<fmt:formatDate value='${salesOrder.orderDate}' pattern='yyyy-MM-dd'/>" max="9999-12-31">
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="deliveryDate" class="form-label">Expected Delivery Date</label>
                                                <input type="date" class="form-control" id="deliveryDate" name="deliveryDate" 
                                                       value="<fmt:formatDate value='${salesOrder.deliveryDate}' pattern='yyyy-MM-dd'/>" max="9999-12-31">
                                            </div>
                                        </div>

                                        <div class="mb-4">
                                            <label for="deliveryAddress" class="form-label">Delivery Address</label>
                                            <textarea class="form-control" id="deliveryAddress" name="deliveryAddress" 
                                                      rows="3" placeholder="Enter delivery address...">${salesOrder.deliveryAddress}</textarea>
                                            <small class="form-text text-muted">Default: Customer address (editable)</small>
                                        </div>

                                        <!-- Current Items Display -->
                                        <div class="current-items-section">
                                            <div class="current-items-header">
                                                <i class="fas fa-box me-2"></i>Current Order Items
                                                <span class="badge bg-primary ms-2">${salesOrder.items.size()} items</span>
                                            </div>
                                            
                                            <c:if test="${not empty salesOrder.items}">
                                                <div class="table-responsive">
                                                    <table class="table table-sm table-hover mb-0">
                                                        <thead class="table-light">
                                                            <tr>
                                                                <th>Product</th>
                                                                <th class="text-center">Quantity</th>
                                                                <th class="text-end">Cost Price</th>
                                                                <th class="text-end">Selling Price</th>
                                                                <th class="text-end">Total</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach var="item" items="${salesOrder.items}">
                                                                <tr>
                                                                    <td>
                                                                        <div class="product-info">
                                                                            <div class="product-name">${item.productCode}</div>
                                                                            <div class="product-code">${item.productName}</div>
                                                                        </div>
                                                                    </td>
                                                                    <td class="text-center fw-medium">${item.quantity}</td>
                                                                    <td class="text-end">
                                                                        <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                                    </td>
                                                                    <td class="text-end price-display">
                                                                        <fmt:formatNumber value="${item.sellingPrice}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                                    </td>
                                                                    <td class="text-end price-display fw-bold">
                                                                        <fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </c:if>
                                        </div>

                                        <!-- Product Selection Section -->
                                        <div id="productSection">
                                            <h6 class="mb-3"><i class="fas fa-plus me-2"></i>Update Products</h6>
                                            
                                            <!-- Add Product Button -->
                                            <div class="product-selection-area" id="addProductArea">
                                                <i class="fas fa-edit mb-3" style="font-size: 3rem; color: #007bff; opacity: 0.7;"></i>
                                                <h5 class="mb-3">Select New Products</h5>
                                                <p class="text-muted mb-4">Click to select products that will REPLACE the current items</p>
                                                <button type="button" class="btn add-product-btn" onclick="openProductModal()">
                                                    <i class="fas fa-edit me-2"></i>Select Products
                                                </button>
                                            </div>
                                            
                                            <!-- Selected Products -->
                                            <div id="selectedProductsContainer" style="display: none;">
                                                <div class="selected-products-container">
                                                    <div class="selected-product-header">
                                                        <i class="fas fa-shopping-cart me-2"></i>New Product Selection
                                                    </div>
                                                    <div id="selectedProductsList">
                                                        <!-- Selected products will be added here -->
                                                    </div>
                                                    <div class="total-summary">
                                                        <div class="row align-items-center">
                                                            <div class="col-md-6">
                                                                <div class="d-flex align-items-center gap-3">
                                                                    <span class="fw-bold">Total Items: <span id="itemCount">0</span></span>
                                                                    <button type="button" class="btn add-product-btn btn-sm" onclick="openProductModal()">
                                                                        <i class="fas fa-plus me-1"></i>Add More
                                                                    </button>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-6 text-end">
                                                                <h4 class="mb-0 text-success">
                                                                    <i class="fas fa-dollar-sign me-1"></i>
                                                                    New Total: <span id="totalAmount">0 ₫</span>
                                                                </h4>
                                                                <div class="text-muted">
                                                                    Total Profit: <span id="totalProfit" class="fw-bold profit-positive">0 ₫</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="mb-4">
                                            <label for="notes" class="form-label">Notes</label>
                                            <textarea class="form-control" id="notes" name="notes" 
                                                      rows="3" placeholder="Enter any additional notes...">${salesOrder.notes}</textarea>
                                        </div>

                                        <!-- Hidden fields for selected products -->
                                        <div id="hiddenProductFields"></div>

                                        <div class="d-grid gap-2 d-md-flex justify-content-md-end pt-4 border-top">
                                            <a href="view-sales-order-detail?id=${salesOrder.soId}" class="btn btn-outline-secondary me-md-2">
                                                <i class="fas fa-times me-1"></i>Cancel Edit
                                            </a>
                                            <button type="submit" class="btn btn-update-order" id="submitBtn">
                                                <i class="fas fa-save me-1"></i>Update Sales Order
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            
            <!-- Footer -->
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

    <!-- Product Selection Modal -->
    <div class="modal fade product-modal" id="productModal" tabindex="-1" aria-labelledby="productModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="productModalLabel">
                        <i class="fas fa-search me-2"></i>Select Products
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                
                <!-- Search Section -->
                <div class="search-container">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <input type="text" class="form-control search-input" id="productSearch" 
                                   placeholder="Search by product name or code..." style="border-radius: 25px; padding: 10px 20px;" />
                        </div>
                    </div>
                </div>
                
                <!-- Products Table -->
                <div class="modal-body p-0">
                    <div class="product-table">
                        <table class="table table-hover mb-0">
                            <thead class="table-light sticky-top">
                                <tr>
                                    <th>Product</th>
                                    <th>Cost Price</th>
                                    <th>Stock</th>
                                    <th>Quantity</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody id="productTableBody">
                                <!-- Products will be loaded here -->
                            </tbody>
                        </table>
                        
                        <!-- Loading State -->
                        <div id="loadingState" class="text-center py-5" style="display: none;">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                            <p class="mt-2 text-muted">Loading products...</p>
                        </div>
                        
                        <!-- Empty State -->
                        <div id="emptyState" class="empty-state" style="display: none;">
                            <i class="fas fa-box-open"></i>
                            <h5>No Products Found</h5>
                            <p>No products available in the selected warehouse or matching your search criteria.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/feather-icons"></script>
    <script src="js/app.js"></script>
    
    <script>
        // Global variables
        var availableProducts = [];
        var selectedProducts = [];
        var currentWarehouseId = null;
        var isEditMode = true;

        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Edit mode initialization...');
            
            if (typeof feather !== 'undefined') {
                feather.replace();
            }
            
            initializeSidebar();
            setupEventListeners();
            autoHideAlerts();
            
            // Set default warehouse and show product section immediately
            var warehouseSelect = document.getElementById('warehouseId');
            if (warehouseSelect) {
                // Find the selected warehouse or set first available
                for (var i = 0; i < warehouseSelect.options.length; i++) {
                    if (warehouseSelect.options[i].selected) {
                        currentWarehouseId = warehouseSelect.options[i].value;
                        break;
                    }
                }
                
                // If no warehouse selected, select the first one
                if (!currentWarehouseId && warehouseSelect.options.length > 1) {
                    warehouseSelect.selectedIndex = 1;
                    currentWarehouseId = warehouseSelect.value;
                }
                
                // Always show product section in edit mode
                var productSection = document.getElementById('productSection');
                if (productSection && currentWarehouseId) {
                    productSection.style.display = 'block';
                    console.log('Product section shown for edit mode with warehouse:', currentWarehouseId);
                }
            }
        });

        function initializeSidebar() {
            document.querySelectorAll('[data-bs-toggle="collapse"]').forEach(function(element) {
                element.addEventListener('click', function(e) {
                    e.preventDefault();
                    
                    const target = document.querySelector(this.getAttribute('data-bs-target'));
                    const arrow = this.querySelector('.sidebar-arrow');
                    
                    if (target) {
                        if (target.classList.contains('show')) {
                            target.classList.remove('show');
                            if (arrow) arrow.style.transform = 'rotate(0deg)';
                        } else {
                            document.querySelectorAll('.sidebar-dropdown.show').forEach(function(dropdown) {
                                if (dropdown !== target) {
                                    dropdown.classList.remove('show');
                                    const otherArrow = document.querySelector('[data-bs-target="#' + dropdown.id + '"] .sidebar-arrow');
                                    if (otherArrow) otherArrow.style.transform = 'rotate(0deg)';
                                }
                            });
                            
                            target.classList.add('show');
                            if (arrow) arrow.style.transform = 'rotate(90deg)';
                        }
                    }
                });
            });

            const sidebarToggle = document.querySelector('.sidebar-toggle');
            if (sidebarToggle) {
                sidebarToggle.addEventListener('click', function() {
                    const sidebar = document.getElementById('sidebar');
                    if (sidebar) {
                        sidebar.classList.toggle('sidebar-mobile-show');
                    }
                });
            }

            document.addEventListener('click', function(event) {
                const sidebar = document.getElementById('sidebar');
                const toggle = document.querySelector('.sidebar-toggle');
                
                if (window.innerWidth < 992 && 
                    sidebar && toggle &&
                    !sidebar.contains(event.target) && 
                    !toggle.contains(event.target) &&
                    sidebar.classList.contains('sidebar-mobile-show')) {
                    sidebar.classList.remove('sidebar-mobile-show');
                }
            });
        }

        function setupEventListeners() {
            var warehouseSelect = document.getElementById('warehouseId');
            var customerSelect = document.getElementById('customerId');
            var orderForm = document.getElementById('editOrderForm');
            var productSearch = document.getElementById('productSearch');
            
            if (warehouseSelect) {
                warehouseSelect.addEventListener('change', onWarehouseChange);
            }
            
            if (customerSelect) {
                customerSelect.addEventListener('change', onCustomerChange);
            }
            
            if (orderForm) {
                orderForm.addEventListener('submit', validateForm);
            }
            
            if (productSearch) {
                productSearch.addEventListener('input', filterProducts);
            }
        }

        function onCustomerChange() {
            var customerId = this.value;
            var selectedOption = this.options[this.selectedIndex];
            var customerAddress = selectedOption.getAttribute('data-address') || '';
            
            var deliveryAddressField = document.getElementById('deliveryAddress');
            if (deliveryAddressField && customerId) {
                if (!deliveryAddressField.value.trim()) {
                    deliveryAddressField.value = customerAddress;
                }
            }
        }

        function onWarehouseChange() {
            var warehouseId = this.value;
            var productSection = document.getElementById('productSection');
            
            console.log('Warehouse changed to:', warehouseId);
            
            if (warehouseId && warehouseId !== '') {
                currentWarehouseId = warehouseId;
                if (productSection) {
                    productSection.style.display = 'block';
                }
                selectedProducts = [];
                updateSelectedProductsDisplay();
            } else {
                if (productSection) {
                    productSection.style.display = 'none';
                }
                currentWarehouseId = null;
                availableProducts = [];
                selectedProducts = [];
            }
        }

        function openProductModal() {
            if (!currentWarehouseId) {
                alert('Please select a warehouse first');
                return;
            }
            
            var modalElement = document.getElementById('productModal');
            if (modalElement) {
                var modal = new bootstrap.Modal(modalElement);
                modal.show();
                loadProducts(currentWarehouseId);
            }
        }

        function loadProducts(warehouseId) {
            console.log('Loading products for warehouse:', warehouseId);
            showLoadingState();
            
            var url = 'get-products-by-warehouse?warehouseId=' + encodeURIComponent(warehouseId);
            
            fetch(url)
                .then(function(response) {
                    if (!response.ok) {
                        throw new Error('Network response was not ok: ' + response.status);
                    }
                    return response.json();
                })
                .then(function(data) {
                    console.log('Products loaded for edit:', data);
                    availableProducts = data || [];
                    hideLoadingState();
                    displayProductsInModal();
                })
                .catch(function(error) {
                    console.error('Error loading products:', error);
                    hideLoadingState();
                    showEmptyState('Error loading products: ' + error.message);
                });
        }

        function showLoadingState() {
            var loadingElement = document.getElementById('loadingState');
            var emptyElement = document.getElementById('emptyState');
            var tableBody = document.getElementById('productTableBody');
            
            if (loadingElement) loadingElement.style.display = 'block';
            if (emptyElement) emptyElement.style.display = 'none';
            if (tableBody) tableBody.innerHTML = '';
        }

        function hideLoadingState() {
            var loadingElement = document.getElementById('loadingState');
            if (loadingElement) loadingElement.style.display = 'none';
        }

        function showEmptyState(message) {
            var emptyElement = document.getElementById('emptyState');
            if (emptyElement) {
                emptyElement.style.display = 'block';
                if (message) {
                    var msgElement = emptyElement.querySelector('p');
                    if (msgElement) {
                        msgElement.textContent = message;
                    }
                }
            }
        }

        function displayProductsInModal() {
            var tbody = document.getElementById('productTableBody');
            if (!tbody) {
                console.error('Product table body not found!');
                return;
            }
            
            tbody.innerHTML = '';
            
            if (!availableProducts || availableProducts.length === 0) {
                showEmptyState('No products available in this warehouse.');
                return;
            }
            
            var filteredProducts = getFilteredProducts();
            
            if (filteredProducts.length === 0) {
                showEmptyState('No products match your search criteria.');
                return;
            }
            
            filteredProducts.forEach(function(product, index) {
                try {
                    var row = createProductRow(product);
                    tbody.appendChild(row);
                } catch (error) {
                    console.error('Error creating product row for product', product, error);
                }
            });
        }

        function getFilteredProducts() {
            var searchInput = document.getElementById('productSearch');
            
            var searchTerm = searchInput ? searchInput.value.toLowerCase() : '';
            
            return availableProducts.filter(function(product) {
                if (!product) return false;
                
                var matchesSearch = !searchTerm || 
                    (product.productName && product.productName.toLowerCase().includes(searchTerm)) || 
                    (product.productCode && product.productCode.toLowerCase().includes(searchTerm));
                
                var notSelected = !isProductSelected(product.productId);
                
                return matchesSearch && notSelected;
            });
        }

        function createProductRow(product) {
            if (!product) {
                console.error('Product is null or undefined');
                return document.createElement('tr');
            }
            
            var tr = document.createElement('tr');
            tr.className = 'product-row';
            
            var stockClass = getStockClass(product.availableQuantity || 0);
            var stockText = getStockText(product.availableQuantity || 0);
            var isDisabled = (product.availableQuantity || 0) === 0;
            var maxQuantity = product.availableQuantity || 1;
            
            tr.innerHTML = 
                '<td>' +
                    '<div class="product-info">' +
                        '<div class="product-name">' + escapeHtml(product.productName || 'Unknown Product') + '</div>' +
                        '<div class="product-code">Code: ' + escapeHtml(product.productCode || 'N/A') + '</div>' +
                    '</div>' +
                '</td>' +
                '<td>' +
                    '<span class="price-display">' + formatCurrency(product.price || 0) + '</span>' +
                    '<div style="font-size: 0.75rem; color: #6c757d;">cost price</div>' +
                '</td>' +
                '<td>' +
                    '<span class="stock-badge ' + stockClass + '">' + (product.availableQuantity || 0) + ' ' + escapeHtml(product.unit || 'pcs') + '</span>' +
                    '<div style="font-size: 0.75rem; color: #6c757d; margin-top: 2px;">' + stockText + '</div>' +
                '</td>' +
                '<td>' +
                    '<div class="quantity-controls">' +
                        '<button type="button" class="quantity-btn" onclick="adjustQuantity(' + product.productId + ', -1)" ' + (isDisabled ? 'disabled' : '') + '>' +
                            '<i class="fas fa-minus"></i>' +
                        '</button>' +
                        '<input type="number" class="quantity-input" id="qty_' + product.productId + '" ' +
                               'value="1" min="1" max="' + maxQuantity + '" ' +
                               'onchange="validateQuantity(' + product.productId + ', this.value)" ' + (isDisabled ? 'disabled' : '') + '>' +
                        '<button type="button" class="quantity-btn" onclick="adjustQuantity(' + product.productId + ', 1)" ' + (isDisabled ? 'disabled' : '') + '>' +
                            '<i class="fas fa-plus"></i>' +
                        '</button>' +
                    '</div>' +
                '</td>' +
                '<td>' +
                    '<button type="button" class="btn btn-select-product btn-sm" ' +
                            'onclick="selectProductFromModal(' + product.productId + ')" ' + (isDisabled ? 'disabled' : '') + '>' +
                        '<i class="fas fa-plus me-1"></i>Add' +
                    '</button>' +
                '</td>';
            
            return tr;
        }

        function getStockClass(quantity) {
            if (quantity === 0) return 'stock-out';
            if (quantity <= 5) return 'stock-low';
            if (quantity <= 20) return 'stock-medium';
            return 'stock-high';
        }

        function getStockText(quantity) {
            if (quantity === 0) return 'Out of stock';
            if (quantity <= 5) return 'Low stock';
            if (quantity <= 20) return 'Limited stock';
            return 'In stock';
        }

        function adjustQuantity(productId, delta) {
            var input = document.getElementById('qty_' + productId);
            if (!input) return;
            
            var newValue = parseInt(input.value || 1) + delta;
            var product = findProductById(productId);
            
            if (product && newValue >= 1 && newValue <= product.availableQuantity) {
                input.value = newValue;
            }
        }

        function validateQuantity(productId, value) {
            var product = findProductById(productId);
            if (!product) return;
            
            var qty = parseInt(value) || 1;
            var input = document.getElementById('qty_' + productId);
            if (!input) return;
            
            if (qty < 1) {
                input.value = 1;
            } else if (qty > product.availableQuantity) {
                input.value = product.availableQuantity;
                alert('Maximum available quantity is ' + product.availableQuantity);
            }
        }

        function selectProductFromModal(productId) {
            var product = findProductById(productId);
            var qtyInput = document.getElementById('qty_' + productId);
            
            if (!product || !qtyInput) {
                console.error('Product or quantity input not found for ID:', productId);
                return;
            }
            
            var quantity = parseInt(qtyInput.value) || 1;
            
            // Add to selected products với selling price mặc định bằng cost price
            selectedProducts.push({
                productId: productId,
                quantity: quantity,
                sellingPrice: product.price, // Mặc định bằng cost price
                product: product
            });
            
            updateSelectedProductsDisplay();
            displayProductsInModal(); // Refresh to hide selected product
            
            // Close modal if no more products to add
            var remainingProducts = getFilteredProducts();
            if (remainingProducts.length === 0) {
                var modalElement = document.getElementById('productModal');
                if (modalElement) {
                    var modal = bootstrap.Modal.getInstance(modalElement);
                    if (modal) modal.hide();
                }
            }
        }

        function updateSelectedProductsDisplay() {
            var container = document.getElementById('selectedProductsContainer');
            var addProductArea = document.getElementById('addProductArea');
            var listDiv = document.getElementById('selectedProductsList');
            
            if (!container || !addProductArea || !listDiv) {
                console.error('Required display elements not found');
                return;
            }
            
            if (selectedProducts.length === 0) {
                container.style.display = 'none';
                addProductArea.style.display = 'block';
                updateTotalAmount();
                updateHiddenFields();
                return;
            }
            
            container.style.display = 'block';
            addProductArea.style.display = 'none';
            listDiv.innerHTML = '';
            
            selectedProducts.forEach(function(item, index) {
                var productDiv = createSelectedProductElement(item, index);
                listDiv.appendChild(productDiv);
            });
            
            updateTotalAmount();
            updateHiddenFields();
        }

        function createSelectedProductElement(item, index) {
            var div = document.createElement('div');
            div.className = 'selected-product-item';
            
            var product = item.product;
            var costPrice = product.price || 0;
            var sellingPrice = item.sellingPrice || costPrice;
            var totalPrice = sellingPrice * item.quantity;
            var profitPerUnit = sellingPrice - costPrice;
            var totalProfit = profitPerUnit * item.quantity;
            var profitPercentage = costPrice > 0 ? (profitPerUnit / costPrice * 100) : 0;
            
            var profitClass = profitPerUnit > 0 ? 'profit-positive' : 
                             (profitPerUnit < 0 ? 'profit-negative' : 'profit-zero');
            
            div.innerHTML = 
                '<div class="row align-items-center">' +
                    '<div class="col-md-3">' +
                        '<div class="product-info">' +
                            '<div class="product-name">' + escapeHtml(product.productName || 'Unknown') + '</div>' +
                            '<div class="product-code">Code: ' + escapeHtml(product.productCode || 'N/A') + '</div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="col-md-2">' +
                        '<div class="text-center">' +
                            '<div class="quantity-controls">' +
                                '<button type="button" class="quantity-btn" onclick="adjustSelectedQuantity(' + index + ', -1)">' +
                                    '<i class="fas fa-minus"></i>' +
                                '</button>' +
                                '<input type="number" class="quantity-input" value="' + item.quantity + '" ' +
                                       'min="1" max="' + (product.availableQuantity || 1) + '" ' +
                                       'onchange="updateSelectedQuantity(' + index + ', this.value)">' +
                                '<button type="button" class="quantity-btn" onclick="adjustSelectedQuantity(' + index + ', 1)">' +
                                    '<i class="fas fa-plus"></i>' +
                                '</button>' +
                            '</div>' +
                            '<div style="font-size: 0.75rem; color: #6c757d; margin-top: 4px;">Max: ' + (product.availableQuantity || 0) + '</div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="col-md-4">' +
                        '<div class="price-controls">' +
                            '<div class="row align-items-center mb-2">' +
                                '<div class="col-sm-4 text-end"><label class="form-label mb-0">Cost:</label></div>' +
                                '<div class="col-sm-8"><span class="text-muted">' + formatCurrency(costPrice) + '</span></div>' +
                            '</div>' +
                            '<div class="row align-items-center mb-2">' +
                                '<div class="col-sm-4 text-end"><label class="form-label mb-0">Sell:</label></div>' +
                                '<div class="col-sm-8">' +
                                    '<input type="number" class="price-input" value="' + sellingPrice + '" ' +
                                           'onchange="updateSellingPrice(' + index + ', this.value)" ' +
                                           'min="0" step="1000">' +
                                '</div>' +
                            '</div>' +
                            '<div class="row align-items-center mb-2">' +
                                '<div class="col-sm-4 text-end"><label class="form-label mb-0">%:</label></div>' +
                                '<div class="col-sm-8">' +
                                    '<div class="d-flex align-items-center gap-2">' +
                                        '<input type="number" class="profit-percentage-input" value="' + profitPercentage.toFixed(1) + '" ' +
                                               'onchange="updateProfitPercentage(' + index + ', this.value)" ' +
                                               'step="1">' +
                                        '<div class="profit-buttons-container">' +
                                            '<button type="button" class="btn-auto-profit" onclick="setAutoProfitPercentage(' + index + ', 20)" title="Set 20%">20%</button>' +
                                            '<button type="button" class="btn-auto-profit" onclick="setAutoProfitPercentage(' + index + ', 30)" title="Set 30%">30%</button>' +
                                            '<button type="button" class="btn-auto-profit" onclick="setAutoProfitPercentage(' + index + ', 40)" title="Set 40%">40%</button>' +
                                        '</div>' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                            '<div class="profit-display ' + profitClass + '">' +
                                'Profit: ' + formatCurrency(profitPerUnit) + '/unit' +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="col-md-2">' +
                        '<div class="text-end">' +
                            '<div class="price-display text-success fw-bold">' + formatCurrency(totalPrice) + '</div>' +
                            '<div style="font-size: 0.75rem;" class="' + profitClass + '">+' + formatCurrency(totalProfit) + '</div>' +
                        '</div>' +
                    '</div>' +
                    '<div class="col-md-1">' +
                        '<button type="button" class="btn btn-outline-danger btn-sm" ' +
                                'onclick="removeSelectedProduct(' + index + ')" title="Remove">' +
                            '<i class="fas fa-trash"></i>' +
                        '</button>' +
                    '</div>' +
                '</div>';
            
            return div;
        }

        function adjustSelectedQuantity(index, delta) {
            if (index < 0 || index >= selectedProducts.length) return;
            
            var item = selectedProducts[index];
            var newQuantity = item.quantity + delta;
            
            if (newQuantity >= 1 && newQuantity <= item.product.availableQuantity) {
                item.quantity = newQuantity;
                updateSelectedProductsDisplay();
            }
        }

        function updateSelectedQuantity(index, value) {
            if (index < 0 || index >= selectedProducts.length) return;
            
            var item = selectedProducts[index];
            var qty = parseInt(value) || 1;
            
            if (qty < 1) {
                qty = 1;
            } else if (qty > item.product.availableQuantity) {
                qty = item.product.availableQuantity;
                alert('Maximum available quantity is ' + item.product.availableQuantity);
            }
            
            item.quantity = qty;
            updateSelectedProductsDisplay();
        }

        function updateSellingPrice(index, value) {
            if (index < 0 || index >= selectedProducts.length) return;
            
            var item = selectedProducts[index];
            var sellingPrice = parseFloat(value) || item.product.price;
            
            if (sellingPrice < 0) {
                sellingPrice = 0;
            }
            
            item.sellingPrice = sellingPrice;
            updateSelectedProductsDisplay();
        }

        function updateProfitPercentage(index, value) {
            if (index < 0 || index >= selectedProducts.length) return;
            
            var item = selectedProducts[index];
            var profitPercentage = parseFloat(value) || 0;
            var costPrice = item.product.price || 0;
            
            if (costPrice > 0) {
                var newSellingPrice = costPrice * (1 + profitPercentage / 100);
                item.sellingPrice = newSellingPrice;
                updateSelectedProductsDisplay();
            }
        }

        function setAutoProfitPercentage(index, percentage) {
            updateProfitPercentage(index, percentage);
        }

        function removeSelectedProduct(index) {
            if (index >= 0 && index < selectedProducts.length) {
                selectedProducts.splice(index, 1);
                updateSelectedProductsDisplay();
            }
        }

        function filterProducts() {
            displayProductsInModal();
        }

        function updateTotalAmount() {
            var totalAmount = 0;
            var totalProfit = 0;
            
            selectedProducts.forEach(function(item) {
                var sellingPrice = item.sellingPrice || item.product.price;
                var costPrice = item.product.price || 0;
                var itemTotal = sellingPrice * item.quantity;
                var itemProfit = (sellingPrice - costPrice) * item.quantity;
                
                totalAmount += itemTotal;
                totalProfit += itemProfit;
            });
            
            var totalElement = document.getElementById('totalAmount');
            var countElement = document.getElementById('itemCount');
            var profitElement = document.getElementById('totalProfit');
            
            if (totalElement) totalElement.textContent = formatCurrency(totalAmount);
            if (countElement) countElement.textContent = selectedProducts.length.toString();
            if (profitElement) {
                profitElement.textContent = formatCurrency(totalProfit);
                profitElement.className = 'fw-bold ' + (totalProfit > 0 ? 'profit-positive' : 
                                                       (totalProfit < 0 ? 'profit-negative' : 'profit-zero'));
            }
        }

        function updateHiddenFields() {
            var hiddenDiv = document.getElementById('hiddenProductFields');
            if (!hiddenDiv) return;
            
            hiddenDiv.innerHTML = '';
            
            selectedProducts.forEach(function(item, index) {
                var productIdInput = document.createElement('input');
                productIdInput.type = 'hidden';
                productIdInput.name = 'productId_' + index;
                productIdInput.value = item.productId.toString();
                hiddenDiv.appendChild(productIdInput);
                
                var quantityInput = document.createElement('input');
                quantityInput.type = 'hidden';
                quantityInput.name = 'quantity_' + index;
                quantityInput.value = item.quantity.toString();
                hiddenDiv.appendChild(quantityInput);
                
                // Add selling price to hidden fields
                var sellingPriceInput = document.createElement('input');
                sellingPriceInput.type = 'hidden';
                sellingPriceInput.name = 'sellingPrice_' + index;
                sellingPriceInput.value = (item.sellingPrice || item.product.price).toString();
                hiddenDiv.appendChild(sellingPriceInput);
            });
            
            var countInput = document.createElement('input');
            countInput.type = 'hidden';
            countInput.name = 'productCount';
            countInput.value = selectedProducts.length.toString();
            hiddenDiv.appendChild(countInput);
        }

        // Utility functions
        function isProductSelected(productId) {
            return selectedProducts.some(function(item) {
                return item.productId === productId;
            });
        }

        function findProductById(productId) {
            return availableProducts.find(function(p) {
                return p && p.productId === productId;
            });
        }

        function formatCurrency(amount) {
            var num = parseFloat(amount) || 0;
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND',
                minimumFractionDigits: 0
            }).format(num);
        }

        function escapeHtml(text) {
            if (!text) return '';
            var div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        function validateForm(e) {
            console.log('Validating edit form, selected products:', selectedProducts.length);
            
            // Check if products are selected
            if (selectedProducts.length === 0) {
                e.preventDefault();
                alert('Please select products for this order. Click "Select Products" button to choose new products that will replace the current ones.');
                return false;
            }
            
            // Check customer
            var customerSelect = document.getElementById('customerId');
            if (!customerSelect || !customerSelect.value) {
                e.preventDefault();
                alert('Please select a customer.');
                if (customerSelect) customerSelect.focus();
                return false;
            }
            
            // Check warehouse
            var warehouseSelect = document.getElementById('warehouseId');
            if (!warehouseSelect || !warehouseSelect.value) {
                e.preventDefault();
                alert('Please select a warehouse.');
                if (warehouseSelect) warehouseSelect.focus();
                return false;
            }
            
            // Ensure hidden fields are updated
            updateHiddenFields();
            
            // Final check for hidden fields
            var hiddenDiv = document.getElementById('hiddenProductFields');
            if (!hiddenDiv || hiddenDiv.children.length === 0) {
                e.preventDefault();
                alert('Error: Product data not properly prepared. Please select products again.');
                return false;
            }
            
            // Show loading state on submit button
            var submitBtn = document.getElementById('submitBtn');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Updating Order...';
                
                setTimeout(function() {
                    if (submitBtn) {
                        submitBtn.disabled = false;
                        submitBtn.innerHTML = '<i class="fas fa-save me-1"></i>Update Sales Order';
                    }
                }, 10000);
            }
            
            return true;
        }

        function autoHideAlerts() {
            setTimeout(function() {
                var alerts = document.querySelectorAll('.alert');
                alerts.forEach(function(alert) {
                    if (alert && typeof bootstrap !== 'undefined') {
                        try {
                            var bsAlert = new bootstrap.Alert(alert);
                            bsAlert.close();
                        } catch (e) {
                            console.log('Could not auto-hide alert:', e);
                        }
                    }
                });
            }, 5000);
        }
    </script>
</body>
</html>