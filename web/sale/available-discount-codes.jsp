<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Available Discount Codes | Warehouse System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Inter', sans-serif;
        }

        .page-title {
            color: #4a90e2;
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 0.25rem;
        }

        .breadcrumb {
            background: none;
            padding: 0;
            margin-bottom: 1.5rem;
            font-size: 0.875rem;
        }

        .breadcrumb-item a {
            color: #6c757d;
            text-decoration: none;
        }

        .breadcrumb-item.active {
            color: #495057;
        }

        /* Filter Section */
        .filter-section {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .filter-row {
            display: flex;
            align-items: end;
            gap: 2rem;
            flex-wrap: wrap;
        }

        .filter-group {
            flex: 1;
            min-width: 200px;
        }

        .filter-group label {
            display: block;
            font-size: 0.875rem;
            font-weight: 500;
            color: #495057;
            margin-bottom: 0.5rem;
        }

        .amount-input-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .amount-input {
            flex: 1;
            padding: 0.5rem 0.75rem;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 0.875rem;
        }

        .amount-input:focus {
            outline: none;
            border-color: #4a90e2;
            box-shadow: 0 0 0 2px rgba(74, 144, 226, 0.2);
        }

        .currency-label {
            font-size: 0.875rem;
            color: #6c757d;
            font-weight: 500;
        }

        .filter-btn {
            background: #4a90e2;
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            font-size: 0.875rem;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .filter-btn:hover {
            background: #357abd;
        }

        .filter-chips-group label {
            margin-bottom: 0.5rem;
        }

        .filter-chips {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .filter-chip {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            color: #495057;
            padding: 0.375rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            cursor: pointer;
            transition: all 0.2s;
            user-select: none;
        }

        .filter-chip:hover,
        .filter-chip.active {
            background: #4a90e2;
            color: white;
            border-color: #4a90e2;
        }

        .filter-help-text {
            font-size: 0.75rem;
            color: #6c757d;
            margin-top: 0.25rem;
        }

        /* Discount Cards */
        .discount-cards-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .discount-card {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            overflow: hidden;
            transition: box-shadow 0.2s;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .discount-card:hover {
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .discount-header {
            background: #4a90e2;
            color: white;
            padding: 1rem;
            position: relative;
        }

        .discount-code {
            font-family: 'Courier New', monospace;
            font-weight: bold;
            font-size: 1.1rem;
            letter-spacing: 1px;
            margin-bottom: 0.25rem;
        }

        .discount-name {
            font-size: 0.875rem;
            opacity: 0.9;
        }

        .copy-btn {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: rgba(255,255,255,0.2);
            border: 1px solid rgba(255,255,255,0.3);
            color: white;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.75rem;
            cursor: pointer;
        }

        .copy-btn:hover {
            background: rgba(255,255,255,0.3);
        }

        .discount-body {
            padding: 1rem;
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .discount-content {
            flex: 1;
        }

        .discount-value-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .discount-value {
            font-size: 1.5rem;
            font-weight: bold;
            color: #28a745;
        }

        .discount-type {
            background: #e3f2fd;
            color: #1976d2;
            padding: 0.25rem 0.5rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .discount-type.fixed {
            background: #fff3e0;
            color: #f57c00;
        }

        .discount-description {
            font-size: 0.8rem;
            color: #6c757d;
            margin-bottom: 1rem;
            font-style: italic;
        }

        .conditions-section {
            background: #f8f9fa;
            border-radius: 4px;
            padding: 0.75rem;
            margin-bottom: 1rem;
            min-height: 120px;
            display: flex;
            flex-direction: column;
        }

        .conditions-title {
            font-size: 0.75rem;
            font-weight: 600;
            color: #495057;
            text-transform: uppercase;
            margin-bottom: 0.5rem;
            flex-shrink: 0;
        }

        .conditions-list {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
        }

        .condition-item {
            font-size: 0.8rem;
            color: #495057;
            margin-bottom: 0.25rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .condition-item:last-child {
            margin-bottom: 0;
        }

        .condition-icon {
            width: 12px;
            color: #28a745;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            padding: 0.25rem 0.5rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 500;
            margin-bottom: 0.75rem;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
        }

        .status-limited {
            background: #fff3cd;
            color: #856404;
        }

        .status-expired {
            background: #f8d7da;
            color: #721c24;
        }

        .use-code-btn {
            width: 100%;
            background: #28a745;
            color: white;
            border: none;
            padding: 0.75rem 1rem;
            border-radius: 4px;
            font-size: 0.875rem;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            margin-top: auto;
            min-height: 44px;
        }

        .use-code-btn:hover:not(:disabled) {
            background: #218838;
        }

        .use-code-btn:disabled {
            background: #6c757d;
            cursor: not-allowed;
        }

        /* No codes state */
        .no-codes-state {
            text-align: center;
            padding: 3rem 1rem;
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 8px;
        }

        .no-codes-icon {
            font-size: 3rem;
            color: #dee2e6;
            margin-bottom: 1rem;
        }

        .no-codes-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
        }

        .no-codes-text {
            color: #6c757d;
            margin-bottom: 1.5rem;
        }

        /* Action buttons */
        .action-buttons {
            text-align: center;
            padding: 1.5rem 0;
        }

        .action-buttons .btn {
            margin: 0 0.5rem;
        }

        .btn-warning {
            background: #ffc107;
            border-color: #ffc107;
            color: #000;
        }

        .btn-warning:hover {
            background: #e0a800;
            border-color: #d39e00;
        }

        .btn-primary {
            background: #4a90e2;
            border-color: #4a90e2;
        }

        .btn-primary:hover {
            background: #357abd;
            border-color: #357abd;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .filter-row {
                flex-direction: column;
                gap: 1rem;
            }

            .filter-group {
                min-width: 100%;
            }

            .discount-cards-container {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .action-buttons .btn {
                display: block;
                width: 100%;
                margin: 0.5rem 0;
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
                    <!-- Page Header -->
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h1 class="page-title">Available Discount Codes</h1>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="dashboard">Dashboard</a></li>
                                    <li class="breadcrumb-item active">Discount Codes</li>
                                </ol>
                            </nav>
                        </div>
                        <div>
                            <a href="create-sales-order" class="btn btn-primary">
                                <i class="fas fa-plus me-1"></i>Create Order
                            </a>
                        </div>
                    </div>

                    <!-- Filter Section -->
                    <div class="filter-section">
                        <div class="filter-row">
                            <div class="filter-group">
                                <label>
                                    <i class="fas fa-calculator me-1"></i>Order Amount (to filter applicable codes)
                                </label>
                                <div class="amount-input-group">
                                    <input type="number" class="amount-input" id="orderAmountFilter" 
                                           value="${orderAmount}" min="0" step="1000" 
                                           placeholder="0.0">
                                    <span class="currency-label">₫</span>
                                    <button type="button" class="filter-btn" onclick="filterByAmount()">
                                        <i class="fas fa-filter"></i>Filter
                                    </button>
                                </div>
                                <div class="filter-help-text">Enter your order amount to see which codes you can use</div>
                            </div>
                            
                            <div class="filter-chips-group">
                                <label>Quick Filters</label>
                                <div class="filter-chips">
                                    <div class="filter-chip active" onclick="showAll()">All Codes</div>
                                    <div class="filter-chip" onclick="showPercentage()">Percentage</div>
                                    <div class="filter-chip" onclick="showFixed()">Fixed Amount</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Discount Codes -->
                    <c:choose>
                        <c:when test="${empty discountCodes}">
                            <div class="no-codes-state">
                                <i class="fas fa-tags no-codes-icon"></i>
                                <h5 class="no-codes-title">No Discount Codes Available</h5>
                                <p class="no-codes-text">
                                    <c:choose>
                                        <c:when test="${orderAmount > 0}">
                                            No discount codes are available for orders of <strong><fmt:formatNumber value="${orderAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/></strong> or above.
                                        </c:when>
                                        <c:otherwise>
                                            There are currently no active discount codes available.
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                                <a href="request-special-discount" class="btn btn-warning">
                                    <i class="fas fa-star me-1"></i>Request Special Discount
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="discount-cards-container">
                                <c:forEach var="code" items="${discountCodes}">
                                    <div class="discount-card" data-type="${code.discountType}" data-min-amount="${code.minOrderAmount}">
                                        <div class="discount-header">
                                            <div class="discount-code">${code.code}</div>
                                            <div class="discount-name">${code.name}</div>
                                            <button type="button" class="copy-btn" onclick="copyCode('${code.code}')" title="Copy code">
                                                <i class="fas fa-copy"></i>
                                            </button>
                                        </div>
                                        
                                        <div class="discount-body">
                                            <div class="discount-content">
                                                <div class="discount-value-row">
                                                    <div class="discount-value">
                                                        <c:choose>
                                                            <c:when test="${code.discountType == 'PERCENTAGE'}">
                                                                ${code.discountValue}% OFF
                                                            </c:when>
                                                            <c:otherwise>
                                                                <fmt:formatNumber value="${code.discountValue}" type="currency" currencySymbol="₫" groupingUsed="true"/> OFF
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <c:choose>
                                                        <c:when test="${code.discountType == 'PERCENTAGE'}">
                                                            <span class="discount-type">Percentage</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="discount-type fixed">Fixed Amount</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <c:if test="${not empty code.description}">
                                                    <div class="discount-description">${code.description}</div>
                                                </c:if>

                                                <!-- Conditions -->
                                                <div class="conditions-section">
                                                    <div class="conditions-title">Conditions:</div>
                                                    <div class="conditions-list">
                                                        <c:if test="${code.minOrderAmount > 0}">
                                                            <div class="condition-item">
                                                                <i class="fas fa-check condition-icon"></i>
                                                                <span>Min order: <strong><fmt:formatNumber value="${code.minOrderAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/></strong></span>
                                                            </div>
                                                        </c:if>
                                                        <c:if test="${code.maxDiscountAmount != null}">
                                                            <div class="condition-item">
                                                                <i class="fas fa-check condition-icon"></i>
                                                                <span>Max discount: <strong><fmt:formatNumber value="${code.maxDiscountAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/></strong></span>
                                                            </div>
                                                        </c:if>
                                                        <c:if test="${code.usageLimit != null}">
                                                            <div class="condition-item">
                                                                <i class="fas fa-check condition-icon"></i>
                                                                <span>Usage limit: <strong>${code.usedCount}/${code.usageLimit}</strong></span>
                                                            </div>
                                                        </c:if>
                                                        <div class="condition-item">
                                                            <i class="fas fa-calendar condition-icon"></i>
                                                            <span>Valid until: <strong><fmt:formatDate value="${code.endDate}" pattern="dd/MM/yyyy"/></strong></span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Status -->
                                                <div>
                                                    <c:choose>
                                                        <c:when test="${code.usageLimit != null && code.usedCount >= code.usageLimit}">
                                                            <span class="status-badge status-limited">
                                                                <i class="fas fa-exclamation-triangle"></i>Usage Limit Reached
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${code.valid}">
                                                            <span class="status-badge status-active">
                                                                <i class="fas fa-check-circle"></i>Active & Valid
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-expired">
                                                                <i class="fas fa-clock"></i>Expired
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>

                                            <!-- Action Button -->
                                            <c:choose>
                                                <c:when test="${orderAmount > 0 && code.minOrderAmount > orderAmount}">
                                                    <button type="button" class="use-code-btn" disabled>
                                                        <i class="fas fa-times"></i>
                                                        Not Applicable (Min: <fmt:formatNumber value="${code.minOrderAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/>)
                                                    </button>
                                                </c:when>
                                                <c:when test="${!code.valid || (code.usageLimit != null && code.usedCount >= code.usageLimit)}">
                                                    <button type="button" class="use-code-btn" disabled>
                                                        <i class="fas fa-ban"></i>Not Available
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" class="use-code-btn" onclick="useCode('${code.code}')">
                                                        <i class="fas fa-shopping-cart"></i>Use This Code
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <a href="request-special-discount" class="btn btn-warning">
                            <i class="fas fa-star me-1"></i>Request Special Discount
                        </a>
                        <a href="create-sales-order" class="btn btn-primary">
                            <i class="fas fa-plus me-1"></i>Create New Order
                        </a>
                    </div>
                </div>
            </main>
            <jsp:include page="/sale/footer.jsp" />
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/feather-icons"></script>
    <script src="js/app.js"></script>
    
    <script>
        function filterByAmount() {
            var amount = document.getElementById('orderAmountFilter').value;
            if (amount && amount > 0) {
                window.location.href = 'available-discount-codes?orderAmount=' + encodeURIComponent(amount);
            } else {
                window.location.href = 'available-discount-codes';
            }
        }

        function showAll() {
            var cards = document.querySelectorAll('.discount-card');
            cards.forEach(function(card) {
                card.style.display = 'block';
            });
            updateActiveChip(0);
        }

        function showPercentage() {
            var cards = document.querySelectorAll('.discount-card');
            cards.forEach(function(card) {
                if (card.getAttribute('data-type') === 'PERCENTAGE') {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
            updateActiveChip(1);
        }

        function showFixed() {
            var cards = document.querySelectorAll('.discount-card');
            cards.forEach(function(card) {
                if (card.getAttribute('data-type') === 'FIXED_AMOUNT') {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
            updateActiveChip(2);
        }

        function updateActiveChip(activeIndex) {
            var chips = document.querySelectorAll('.filter-chip');
            chips.forEach(function(chip, index) {
                if (index === activeIndex) {
                    chip.classList.add('active');
                } else {
                    chip.classList.remove('active');
                }
            });
        }

        function copyCode(code) {
            var tempInput = document.createElement('input');
            tempInput.value = code;
            document.body.appendChild(tempInput);
            
            tempInput.select();
            tempInput.setSelectionRange(0, 99999);
            document.execCommand('copy');
            
            document.body.removeChild(tempInput);
            
            var btn = event.target.closest('.copy-btn');
            var originalHtml = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-check"></i>';
            
            setTimeout(function() {
                btn.innerHTML = originalHtml;
            }, 2000);
            
            showToast('Discount code copied: ' + code);
        }

        function useCode(code) {
            var createOrderUrl = 'create-sales-order';
            
            try {
                sessionStorage.setItem('selectedDiscountCode', code);
            } catch (e) {
                console.log('SessionStorage not available');
            }
            
            window.location.href = createOrderUrl;
        }

        function showToast(message) {
            var toast = document.createElement('div');
            toast.className = 'position-fixed top-0 end-0 p-3';
            toast.style.zIndex = '9999';
            toast.innerHTML = 
                '<div class="toast show" role="alert">' +
                '<div class="toast-header">' +
                '<strong class="me-auto">Success</strong>' +
                '<button type="button" class="btn-close" data-bs-dismiss="toast"></button>' +
                '</div>' +
                '<div class="toast-body">' + message + '</div>' +
                '</div>';
            
            document.body.appendChild(toast);
            
            setTimeout(function() {
                if (toast && toast.parentNode) {
                    toast.parentNode.removeChild(toast);
                }
            }, 3000);
        }

        document.getElementById('orderAmountFilter').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                filterByAmount();
            }
        });

        document.addEventListener('DOMContentLoaded', function() {
            var orderAmount = ${orderAmount != null ? orderAmount : 0};
            if (orderAmount === 0) {
                document.getElementById('orderAmountFilter').focus();
            }
        });
    </script>
</body>
</html>