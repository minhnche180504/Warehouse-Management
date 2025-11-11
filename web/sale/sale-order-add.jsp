<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Create Sales Order | Warehouse System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
    <style>
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
        
        .selected-products-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            overflow: hidden;
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
        
        .stock-badge {
            font-size: 0.85rem;
            padding: 4px 8px;
            border-radius: 12px;
        }
        
        .stock-high { background-color: #d4edda; color: #155724; }
        .stock-medium { background-color: #fff3cd; color: #856404; }
        .stock-low { background-color: #f8d7da; color: #721c24; }
        .stock-out { background-color: #f5c6cb; color: #721c24; }
        
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
            border-color: #adb5bd;
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
        
        .profit-buttons-container {
            display: flex;
            gap: 8px;
            align-items: center;
        }
        
        .btn-auto-profit:hover {
            background: #218838;
            color: white;
        }
        
        /* Request Import Button */
        .btn-import-request {
            background-color: #28a745;
            border-color: #28a745;
            color: white;
            padding: 0.375rem 0.75rem;
            font-size: 0.875rem;
            border-radius: 4px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            border: 1px solid transparent;
        }

        .btn-import-request:hover {
            background-color: #218838;
            border-color: #1e7e34;
            color: white;
        }
        
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
        
        .total-summary {
            background: linear-gradient(135deg, #e8f5e8 0%, #d4edda 100%);
            border-radius: 12px;
            padding: 20px;
            margin-top: 20px;
        }
        
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
        
        .selected-product-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 15px 20px;
            border-bottom: 2px solid #dee2e6;
            font-weight: 600;
            color: #495057;
        }
        
        .form-select {
            cursor: pointer;
            position: relative;
            z-index: 1;
        }
        
        .form-select:disabled {
            cursor: not-allowed;
            opacity: 0.5;
        }
        
        .modal {
            z-index: 1055;
        }
        
        .modal-backdrop {
            z-index: 1050;
        }
        
        .sidebar-toggle {
            z-index: 1040;
        }
        
        .form-control,
        .form-select,
        .btn {
            position: relative;
            z-index: 1;
        }

        /* Simple quotation styles */
        .quotation-info {
            background: #e3f2fd;
            border: 1px solid #2196f3;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
        }

        /* ============ DISCOUNT STYLES - THÊM VÀO CUỐI CSS ============ */
        .discount-card {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            border: 2px solid #ffc107;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .discount-result {
            margin-top: 15px;
        }

        .applied-discount {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            border-radius: 8px;
            padding: 15px;
        }
        
        @media (max-width: 768px) {
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
            
            .price-controls {
                padding: 10px;
            }
            
            .price-input {
                width: 100%;
                margin-bottom: 5px;
            }
            
            .header-buttons {
                flex-direction: column;
                gap: 0.5rem;
            }

            .header-buttons .btn,
            .header-buttons .btn-import-request {
                width: 100%;
            }
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
                            <h1 class="h2 fw-bold text-primary">Create New Sales Order</h1>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="view-sales-order-list">Sales Orders</a></li>
                                    <li class="breadcrumb-item active">Create New</li>
                                </ol>
                            </nav>
                        </div>
                        <div class="d-flex gap-2 header-buttons">
                            <a href="<c:url value='/sale/requestImport'/>" class="btn-import-request">
                                <i class="fas fa-download me-1"></i>Request Import
                            </a>
                            <a href="view-sales-order-list" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-1"></i>Back to List
                            </a>
                        </div>
                    </div>

                    <!-- SIMPLE QUOTATION INFO (if exists) -->
                    <c:if test="${not empty quotation}">
                    <div class="quotation-info">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-file-alt fa-2x text-primary me-3"></i>
                            <div>
                                <h5 class="mb-1">Creating Order from Quotation</h5>
                                <p class="mb-0">
                                    <strong>Customer:</strong> <c:out value="${quotation.customerName}"/> | 
                                    <strong>Total:</strong> <c:out value="${quotation.totalAmount}"/> ₫
                                </p>
                                <small class="text-muted">Products will be automatically selected when you choose a warehouse.</small>
                            </div>
                        </div>
                    </div>
                    </c:if>

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

                    <!-- Create Order Form -->
                    <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">Order Information</h5>
                                </div>
                                <div class="card-body">
                                    <form method="post" action="${pageContext.request.contextPath}/sale/create-sales-order" accept-charset="UTF-8" id="orderForm">
                                        <!-- Basic Order Info -->
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label for="customerId" class="form-label">Customer <span class="text-danger">*</span></label>
                                                <select class="form-select" id="customerId" name="customerId" required>
                                                    <option value="">-- Select Customer --</option>
                                                    <c:forEach var="customer" items="${customers}">
                                                        <option value="${customer.customerId}" 
                                                                data-address="${customer.address}"
                                                                <c:if test="${not empty quotation && quotation.customerId == customer.customerId}">selected</c:if>>
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
                                                        <option value="${warehouse.warehouseId}">
                                                            <c:out value="${warehouse.warehouseName}" />
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label for="orderDate" class="form-label">Order Date</label>
                                                <input type="date" class="form-control" id="orderDate" name="orderDate" max="9999-12-31">
                                                <small class="form-text text-muted">Leave empty to use current date</small>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="deliveryDate" class="form-label">Expected Delivery Date</label>
                                                <input type="date" class="form-control" id="deliveryDate" name="deliveryDate" max="9999-12-31">
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label for="deliveryAddress" class="form-label">Delivery Address</label>
                                            <textarea class="form-control" id="deliveryAddress" name="deliveryAddress" 
                                                      rows="3" placeholder="Will be filled with customer address..."></textarea>
                                            <small class="form-text text-muted">Default: Customer address (editable)</small>
                                        </div>

                                        <!-- Product Selection Section -->
                                        <div id="productSection" style="display: none;">
                                            <h6 class="mb-3"><i class="fas fa-box me-2"></i>Select Products</h6>
                                            
                                            <!-- Add Product Button -->
                                            <div class="product-selection-area" id="addProductArea">
                                                <i class="fas fa-plus-circle mb-3" style="font-size: 3rem; color: #007bff; opacity: 0.7;"></i>
                                                <h5 class="mb-3">Add Products to Order</h5>
                                                <p class="text-muted mb-4">Click the button below to search and select products from your warehouse</p>
                                                <button type="button" class="btn add-product-btn" onclick="openProductModal()">
                                                    <i class="fas fa-plus me-2"></i>Add Product
                                                </button>
                                            </div>
                                            
                                            <!-- Selected Products -->
                                            <div id="selectedProductsContainer" style="display: none;">
                                                <div class="selected-products-container">
                                                    <div class="selected-product-header">
                                                        <i class="fas fa-shopping-cart me-2"></i>Selected Products
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
                                                                    Total Amount: <span id="totalAmount">0 ₫</span>
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

                                        <!-- ============ DISCOUNT SECTION ============ -->
                                        <div id="discountSection" style="display: none;">
                                            <h6 class="mb-3"><i class="fas fa-percentage me-2"></i>Apply Discount</h6>
                                            
                                            <div class="discount-card">
                                                <div class="row">
                                                    <div class="col-md-8 mb-3">
                                                        <label for="discountCode" class="form-label">Enter Discount Code</label>
                                                        <div class="input-group">
                                                            <input type="text" class="form-control" id="discountCode" 
                                                                   placeholder="Enter discount code (e.g., SUMMER2025)" maxlength="20">
                                                            <button type="button" class="btn btn-outline-primary" 
                                                                    onclick="validateDiscountCode()" id="validateBtn">
                                                                <i class="fas fa-check me-1"></i>Apply
                                                            </button>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4 mb-3">
                                                        <label class="form-label">Quick Actions</label>
                                                        <div class="d-grid gap-2">
                                                            <a href="${pageContext.request.contextPath}/sale/request-special-discount" 
                                                               class="btn btn-outline-warning btn-sm">
                                                                <i class="fas fa-star me-1"></i>Request Special
                                                            </a>
                                                        </div>
                                                    </div>
                                                </div>
                                                
                                                <!-- Discount Result -->
                                                <div id="discountResult" class="discount-result" style="display: none;"></div>
                                                
                                                <!-- Applied Discount Display -->
                                                <div id="appliedDiscount" class="applied-discount" style="display: none;">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <div>
                                                            <strong><i class="fas fa-check-circle me-1"></i>Discount Applied</strong>
                                                            <div id="discountDetails"></div>
                                                        </div>
                                                        <button type="button" class="btn btn-outline-danger btn-sm" onclick="removeDiscount()">
                                                            <i class="fas fa-times"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label for="notes" class="form-label">Notes</label>
                                            <textarea class="form-control" id="notes" name="notes" 
                                                      rows="3" placeholder="Enter any additional notes..."></textarea>
                                        </div>

                                        <!-- Hidden fields for selected products -->
                                        <div id="hiddenProductFields"></div>

                                        <!-- ============ HIDDEN DISCOUNT FIELDS ============ -->
                                        <input type="hidden" id="appliedDiscountCode" name="appliedDiscountCode">
                                        <input type="hidden" id="discountType" name="discountType">
                                        <input type="hidden" id="discountId" name="discountId">
                                        <input type="hidden" id="specialRequestId" name="specialRequestId">
                                        <input type="hidden" id="discountAmount" name="discountAmount" value="0">
                                        <input type="hidden" id="totalBeforeDiscount" name="totalBeforeDiscount" value="0">

                                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                            <a href="view-sales-order-list" class="btn btn-outline-secondary me-md-2">Cancel</a>
                                            <button type="submit" class="btn btn-primary" id="submitBtn">
                                                <i class="fas fa-save me-1"></i>Create Sales Order
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
        // ============ ORIGINAL CODE - COMPLETELY UNCHANGED ============
        // Global variables
        var availableProducts = [];
        var selectedProducts = [];
        var currentWarehouseId = null;

        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM loaded, initializing...');
            
            if (typeof feather !== 'undefined') {
                feather.replace();
            }
            
            initializeSidebar();
            setTodayDate();
            setupEventListeners();
            autoHideAlerts();

            // ============ SIMPLE QUOTATION INTEGRATION ============
            // Only load quotation data if it exists
            var hasQuotation = ${not empty quotation};
            if (hasQuotation) {
                console.log('Quotation detected, will auto-load data when warehouse is selected');
                loadQuotationNotesOnly();
            }
        });

        // ============ ORIGINAL FUNCTIONS - UNCHANGED ============
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

        function setTodayDate() {
            var orderDateInput = document.getElementById('orderDate');
            if (orderDateInput && !orderDateInput.value) {
                var today = new Date();
                var formattedDate = today.toISOString().split('T')[0];
                orderDateInput.value = formattedDate;
            }
        }

        function setupEventListeners() {
            var warehouseSelect = document.getElementById('warehouseId');
            var customerSelect = document.getElementById('customerId');
            var orderForm = document.getElementById('orderForm');
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
                deliveryAddressField.value = customerAddress;
                deliveryAddressField.placeholder = 'Customer address: ' + (customerAddress || 'No address on file');
            } else if (deliveryAddressField) {
                deliveryAddressField.value = '';
                deliveryAddressField.placeholder = 'Will be filled with customer address...';
            }
        }

        function onWarehouseChange() {
            var warehouseId = this.value;
            var productSection = document.getElementById('productSection');
            var discountSection = document.getElementById('discountSection');
            
            if (warehouseId && warehouseId !== '') {
                currentWarehouseId = warehouseId;
                if (productSection) {
                    productSection.style.display = 'block';
                }
                if (discountSection) {
                    discountSection.style.display = 'block';
                }
                selectedProducts = [];
                updateSelectedProductsDisplay();

                // ============ SIMPLE QUOTATION AUTO-SELECT ============
                var hasQuotation = ${not empty quotation};
                if (hasQuotation) {
                    console.log('Auto-selecting products from quotation...');
                    autoSelectQuotationProductsSimple();
                }
            } else {
                if (productSection) {
                    productSection.style.display = 'none';
                }
                if (discountSection) {
                    discountSection.style.display = 'none';
                }
                currentWarehouseId = null;
                availableProducts = [];
                selectedProducts = [];
            }
        }

        // ============ SIMPLE QUOTATION FUNCTIONS ============
        function loadQuotationNotesOnly() {
            var notesField = document.getElementById('notes');
            if (notesField) {
                <c:if test="${not empty quotation}">
                var quotationRef = 'Created from Quotation ID: ${quotation.quotationId}';
                <c:if test="${not empty quotation.notes}">
                quotationRef += ' | Original notes: ${quotation.notes}';
                </c:if>
                notesField.value = quotationRef;
                </c:if>
            }

            // Trigger customer change to load address
            var customerSelect = document.getElementById('customerId');
            if (customerSelect && customerSelect.value) {
                customerSelect.dispatchEvent(new Event('change'));
            }
        }

        function autoSelectQuotationProductsSimple() {
            <c:if test="${not empty quotationItems}">
            console.log('Loading quotation items...');
            
            // Clear existing selections
            selectedProducts = [];
            
            // Add each quotation item
            <c:forEach var="item" items="${quotationItems}">
            var quotationProduct = {
                productId: ${item.productId},
                productName: '${item.productName}',
                productCode: 'Q-${quotation.quotationId}-${item.productId}',
                price: ${item.unitPrice},
                availableQuantity: 999,
                unit: '${item.unitName}' || 'pcs'
            };
            
            selectedProducts.push({
                productId: ${item.productId},
                quantity: ${item.quantity},
                sellingPrice: ${item.unitPrice},
                product: quotationProduct
            });
            </c:forEach>
            
            updateSelectedProductsDisplay();
            showQuotationLoadedMessage();
            </c:if>
        }

        function showQuotationLoadedMessage() {
            var successDiv = document.createElement('div');
            successDiv.className = 'alert alert-success alert-dismissible fade show';
            successDiv.innerHTML = 
                '<strong>Products Auto-Selected!</strong> ' +
                'Products from the quotation have been automatically added to your order. ' +
                '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
            
            var productSection = document.getElementById('productSection');
            if (productSection) {
                productSection.insertBefore(successDiv, productSection.firstChild);
            }
            
            setTimeout(function() {
                if (successDiv && successDiv.parentNode) {
                    successDiv.remove();
                }
            }, 5000);
        }

        // ============ ALL REMAINING FUNCTIONS - ORIGINAL CODE ============
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
                    console.log('Products loaded:', data);
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
            
            // Store total before discount
            document.getElementById('totalBeforeDiscount').value = totalAmount;
            
            // Apply discount if any
            var discountAmount = parseFloat(document.getElementById('discountAmount').value) || 0;
            var finalAmount = Math.max(0, totalAmount - discountAmount);
            
            var totalElement = document.getElementById('totalAmount');
            var countElement = document.getElementById('itemCount');
            var profitElement = document.getElementById('totalProfit');
            
            if (totalElement) totalElement.textContent = formatCurrency(finalAmount);
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
            console.log('Validating form, selected products:', selectedProducts.length);
            
            if (selectedProducts.length === 0) {
                e.preventDefault();
                alert('Please select at least one product for this order.');
                return false;
            }
            
            var customerSelect = document.getElementById('customerId');
            if (!customerSelect || !customerSelect.value) {
                e.preventDefault();
                alert('Please select a customer.');
                if (customerSelect) customerSelect.focus();
                return false;
            }
            
            var warehouseSelect = document.getElementById('warehouseId');
            if (!warehouseSelect || !warehouseSelect.value) {
                e.preventDefault();
                alert('Please select a warehouse.');
                if (warehouseSelect) warehouseSelect.focus();
                return false;
            }
            
            updateHiddenFields();
            
            var hiddenDiv = document.getElementById('hiddenProductFields');
            if (!hiddenDiv || hiddenDiv.children.length === 0) {
                e.preventDefault();
                alert('Error: Product data not properly prepared. Please try again.');
                return false;
            }
            
            var submitBtn = document.getElementById('submitBtn');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Creating Order...';
                
                setTimeout(function() {
                    if (submitBtn) {
                        submitBtn.disabled = false;
                        submitBtn.innerHTML = '<i class="fas fa-save me-1"></i>Create Sales Order';
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

        // ============ DISCOUNT FUNCTIONS ============
        function validateDiscountCode() {
            var code = document.getElementById('discountCode').value.trim();
            if (!code) {
                alert('Please enter a discount code');
                return;
            }
            
            var totalBeforeDiscount = parseFloat(document.getElementById('totalBeforeDiscount').value) || 0;
            if (totalBeforeDiscount <= 0) {
                alert('Please add products to the order first');
                return;
            }
            
            var validateBtn = document.getElementById('validateBtn');
            validateBtn.disabled = true;
            validateBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Validating...';
            
            var url = '${pageContext.request.contextPath}/sale/validate-discount-code';
            var params = 'code=' + encodeURIComponent(code) + '&orderAmount=' + totalBeforeDiscount;
            
            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params
            })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                handleDiscountValidationResult(data);
            })
            .catch(function(error) {
                console.error('Error:', error);
                showDiscountError('Error validating discount code. Please try again.');
            })
            .finally(function() {
                validateBtn.disabled = false;
                validateBtn.innerHTML = '<i class="fas fa-check me-1"></i>Apply';
            });
        }

        function handleDiscountValidationResult(data) {
            if (data.success && data.valid) {
                applyDiscount(data.discountInfo);
            } else {
                showDiscountError(data.message || 'Invalid discount code');
            }
        }

        function applyDiscount(discountInfo) {
            document.getElementById('appliedDiscountCode').value = document.getElementById('discountCode').value;
            document.getElementById('discountAmount').value = discountInfo.calculatedDiscount;
            
            if (discountInfo.type === 'regular') {
                document.getElementById('discountId').value = discountInfo.discountId;
                document.getElementById('discountType').value = 'regular';
                document.getElementById('specialRequestId').value = '';
            } else {
                document.getElementById('specialRequestId').value = discountInfo.requestId;
                document.getElementById('discountType').value = 'special';
                document.getElementById('discountId').value = '';
            }
            
            updateTotalAmount();
            showAppliedDiscount(discountInfo);
            
            document.getElementById('discountResult').style.display = 'none';
            document.getElementById('discountCode').value = '';
        }

        function showAppliedDiscount(discountInfo) {
            var appliedDiv = document.getElementById('appliedDiscount');
            var detailsDiv = document.getElementById('discountDetails');
            
            var discountText = discountInfo.discountType === 'PERCENTAGE' ? 
                discountInfo.discountValue + '%' : 
                formatCurrency(discountInfo.discountValue);
            
            var typeText = discountInfo.type === 'special' ? 'Special Discount' : 'Regular Discount';
            
            detailsDiv.innerHTML = 
                '<div><strong>Code:</strong> ' + document.getElementById('appliedDiscountCode').value + ' (' + typeText + ')</div>' +
                '<div><strong>Discount:</strong> ' + discountText + ' = ' + formatCurrency(discountInfo.calculatedDiscount) + '</div>' +
                '<div><strong>Final Amount:</strong> ' + formatCurrency(discountInfo.finalAmount) + '</div>';
            
            appliedDiv.style.display = 'block';
        }

        function showDiscountError(message) {
            var resultDiv = document.getElementById('discountResult');
            resultDiv.innerHTML = 
                '<div class="alert alert-danger">' +
                '<i class="fas fa-exclamation-triangle me-1"></i>' + message +
                '</div>';
            resultDiv.style.display = 'block';
            
            setTimeout(function() {
                resultDiv.style.display = 'none';
            }, 5000);
        }

        function removeDiscount() {
            document.getElementById('appliedDiscountCode').value = '';
            document.getElementById('discountAmount').value = '0';
            document.getElementById('discountId').value = '';
            document.getElementById('specialRequestId').value = '';
            document.getElementById('discountType').value = '';
            
            document.getElementById('appliedDiscount').style.display = 'none';
            updateTotalAmount();
        }
    </script>
</body>
</html>