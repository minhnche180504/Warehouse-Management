<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Sales Orders | Warehouse System</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
    
    <style>
        /* Clean status badges - updated statuses */
        .status-order { 
            background-color: #fff3cd;
            color: #856404; 
            border: 1px solid #ffeaa7;
        }
        
        .status-delivery { 
            background-color: #d1ecf1;
            color: #0c5460; 
            border: 1px solid #bee5eb;
        }
        
        .status-completed { 
            background-color: #d4edda;
            color: #155724; 
            border: 1px solid #c3e6cb;
        }
        
        .status-cancelled { 
            background-color: #f8d7da;
            color: #721c24; 
            border: 1px solid #f5c6cb;
        }

        .status-returning { 
            background-color: #fff3cd;
            color: #856404; 
            border: 1px solid #ffeaa7;
        }

        .status-returned { 
            background-color: #e2e3e5;
            color: #383d41; 
            border: 1px solid #d6d8db;
        }

        .badge-status {
            padding: 0.375rem 0.75rem;
            border-radius: 6px;
            font-weight: 500;
            font-size: 0.875rem;
            display: inline-block;
        }

        /* Rest of CSS remains the same */
        .search-filters {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            border: 1px solid #dee2e6;
        }

        .table {
            margin-bottom: 0;
        }

        .table thead th {
            border-bottom: 2px solid #dee2e6;
            font-weight: 600;
            color: #495057;
            padding: 1rem 0.75rem;
            background-color: #f8f9fa;
        }

        .table tbody td {
            padding: 1rem 0.75rem;
            vertical-align: middle;
            border-bottom: 1px solid #f1f3f4;
        }

        .table tbody tr:hover {
            background-color: #f8f9fa;
        }

        /* Clean action buttons */
        .btn-view {
            background-color: #007bff;
            border-color: #007bff;
            color: white;
            padding: 0.375rem 0.75rem;
            font-size: 0.875rem;
            border-radius: 4px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
        }

        .btn-view:hover {
            background-color: #0056b3;
            border-color: #0056b3;
            color: white;
        }

        .btn-edit {
            background-color: #fd7e14;
            border-color: #fd7e14;
            color: white;
            padding: 0.375rem 0.75rem;
            font-size: 0.875rem;
            border-radius: 4px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
        }

        .btn-edit:hover {
            background-color: #e66500;
            border-color: #e66500;
            color: white;
        }

        /* Rest of CSS styles remain the same... */
        .order-number {
            font-family: 'Courier New', monospace;
            font-weight: 600;
            color: #495057;
        }

        .currency {
            font-weight: 600;
            color: #28a745;
        }

        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .form-control, .form-select {
            border: 1px solid #dee2e6;
            border-radius: 4px;
            padding: 0.375rem 0.75rem;
        }

        .form-control:focus, .form-select:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }

        .stats-card {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 1.5rem;
            text-align: center;
        }

        .stats-number {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: #495057;
        }

        .stats-label {
            color: #6c757d;
            font-size: 0.875rem;
        }

        .pagination .page-link {
            border: 1px solid #dee2e6;
            color: #495057;
            padding: 0.375rem 0.75rem;
        }

        .pagination .page-link:hover {
            background-color: #e9ecef;
            border-color: #dee2e6;
            color: #495057;
        }

        .pagination .page-item.active .page-link {
            background-color: #007bff;
            border-color: #007bff;
            color: white;
        }

        .pagination .page-item.disabled .page-link {
            color: #6c757d;
            background-color: #fff;
            border-color: #dee2e6;
        }

        .form-select-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }

        @media (max-width: 768px) {
            .table-responsive {
                font-size: 0.875rem;
            }

            .btn-view, .btn-edit {
                padding: 0.25rem 0.5rem;
                font-size: 0.75rem;
            }

            .stats-card {
                margin-bottom: 1rem;
            }

            .header-buttons {
                flex-direction: column;
                gap: 0.5rem;
            }

            .header-buttons .btn {
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
                    <!-- Page Header -->
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h1 class="h2 fw-bold text-primary">Sales Orders</h1>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="dashboard">Dashboard</a></li>
                                    <li class="breadcrumb-item active">Sales Orders</li>
                                </ol>
                            </nav>
                        </div>
                        <div class="d-flex gap-2 header-buttons">
                            <a href="create-sales-order" class="btn btn-primary">
                                <i class="fas fa-plus me-1"></i>Create New Order
                            </a>
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

                    <!-- Search and Filter Section -->
                    <div class="search-filters">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Search Orders</label>
                                <input type="text" class="form-control" placeholder="Order number, customer name..." id="searchInput">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Status</label>
                                <select class="form-select" id="statusFilter">
                                    <option value="">All Status</option>
                                    <option value="Order">Order</option>
                                    <option value="Delivery">Delivery</option>
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
                                    <button type="button" class="btn btn-outline-secondary" onclick="clearFilters()">
                                        <i class="fas fa-times me-1"></i>Clear
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Orders Table -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">
                                Sales Orders List
                                <span class="badge bg-primary ms-2" id="orderCount">
                                    <c:choose>
                                        <c:when test="${not empty orders}">
                                            ${orders.size()} orders
                                        </c:when>
                                        <c:otherwise>
                                            0 orders
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty orders}">
                                    <div class="empty-state">
                                        <i class="fas fa-shopping-cart"></i>
                                        <h5>No Sales Orders Found</h5>
                                        <p class="text-muted mb-4">Start by creating your first sales order to track customer purchases.</p>
                                        <a href="create-sales-order" class="btn btn-primary">
                                            <i class="fas fa-plus me-1"></i>Create First Order
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover" id="ordersTable">
                                            <thead>
                                                <tr>
                                                    <th>Order #</th>
                                                    <th>Customer</th>
                                                    <th>Warehouse</th>
                                                    <th>Date</th>
                                                    <th>Status</th>
                                                    <th>Total</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="order" items="${orders}">
                                                    <tr>
                                                        <td>
                                                            <span class="order-number">${order.orderNumber}</span>
                                                        </td>
                                                        <td>
                                                            <div>
                                                                <div class="fw-medium">${order.customerName}</div>
                                                                <c:if test="${not empty order.customerEmail}">
                                                                    <small class="text-muted">${order.customerEmail}</small>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty order.warehouseName}">
                                                                    <div>
                                                                        <div class="fw-medium">${order.warehouseName}</div>
                                                                        <c:if test="${not empty order.warehouseAddress}">
                                                                            <small class="text-muted">${order.warehouseAddress}</small>
                                                                        </c:if>
                                                                    </div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">N/A</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div>
                                                                <div class="fw-medium">
                                                                    <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/>
                                                                </div>
                                                                <small class="text-muted">
                                                                    <fmt:formatDate value="${order.orderDate}" pattern="HH:mm"/>
                                                                </small>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${order.status == 'Order'}">
                                                                    <span class="badge-status status-order">Order</span>
                                                                </c:when>
                                                                <c:when test="${order.status == 'Delivery'}">
                                                                    <span class="badge-status status-delivery">Delivery</span>
                                                                </c:when>
                                                                <c:when test="${order.status == 'Completed'}">
                                                                    <span class="badge-status status-completed">Completed</span>
                                                                </c:when>
                                                                <c:when test="${order.status == 'Cancelled'}">
                                                                    <span class="badge-status status-cancelled">Cancelled</span>
                                                                </c:when>
                                                                <c:when test="${order.status == 'returning'}">
                                                                    <span class="badge-status status-returning">Returning</span>
                                                                </c:when>
                                                                <c:when test="${order.status == 'returned'}">
                                                                    <span class="badge-status status-returned">Returned</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">${order.status}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <span class="currency">
                                                                <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <div class="d-flex gap-1">
                                                                <a href="view-sales-order-detail?id=${order.soId}" 
                                                                   class="btn-view" 
                                                                   title="View Details">
                                                                    <i class="fas fa-eye"></i>
                                                                    <span class="d-none d-md-inline">View</span>
                                                                </a>
                                                                
                                                                <c:if test="${order.status == 'Order'}">
                                                                    <a href="edit-sales-order?id=${order.soId}" 
                                                                       class="btn-edit" 
                                                                       title="Edit Order">
                                                                        <i class="fas fa-edit"></i>
                                                                        <span class="d-none d-lg-inline">Edit</span>
                                                                    </a>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Order Statistics -->
                                    <div class="row mt-4 pt-4 border-top">
                                        <div class="col-md-4">
                                            <div class="stats-card">
                                                <div class="stats-number text-warning" id="orderStatusCount">0</div>
                                                <div class="stats-label">Order Status</div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="stats-card">
                                                <div class="stats-number text-info" id="deliveryCount">0</div>
                                                <div class="stats-label">In Delivery</div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="stats-card">
                                                <div class="stats-number text-success" id="completedCount">0</div>
                                                <div class="stats-label">Completed</div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Pagination -->
                                    <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="text-muted">Show:</span>
                                            <select class="form-select form-select-sm" id="pageSize" style="width: auto;">
                                                <option value="10">10</option>
                                                <option value="20">20</option>
                                                <option value="50">50</option>
                                                <option value="100">100</option>
                                            </select>
                                            <span class="text-muted">orders per page</span>
                                        </div>
                                        <nav aria-label="Order pagination">
                                            <ul class="pagination pagination-sm mb-0" id="pagination">
                                                <!-- Pagination buttons will be generated by JavaScript -->
                                            </ul>
                                        </nav>
                                        <div class="text-muted" id="pageInfo">
                                            <!-- Page info will be updated by JavaScript -->
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
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

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/feather-icons"></script>
    <script src="js/app.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            if (typeof feather !== 'undefined') {
                feather.replace();
            }
            
            initializeSidebar();
            initializePagination();
            calculateOrderStatistics();
            autoHideAlerts();
        });

        let currentPage = 1;
        let pageSize = 10;
        let allRows = [];
        let filteredRows = [];

        function initializePagination() {
            setTimeout(function() {
                const tableBody = document.querySelector('#ordersTable tbody');
                if (tableBody) {
                    allRows = Array.from(tableBody.querySelectorAll('tr'));
                    filteredRows = [...allRows];
                    
                    const pageSizeSelect = document.getElementById('pageSize');
                    if (pageSizeSelect) {
                        pageSizeSelect.addEventListener('change', function() {
                            pageSize = parseInt(this.value);
                            currentPage = 1;
                            updatePagination();
                        });
                    }
                    
                    updatePagination();
                } else {
                    setTimeout(initializePagination, 100);
                }
            }, 100);
        }

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

        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function() {
            filterTable();
        });

        document.getElementById('statusFilter').addEventListener('change', function() {
            filterTable();
        });

        document.getElementById('fromDate').addEventListener('change', function() {
            filterTable();
        });

        function filterTable() {
            const searchValue = document.getElementById('searchInput').value.toLowerCase();
            const statusValue = document.getElementById('statusFilter').value; // ★ FIX: Bỏ toLowerCase()
            const fromDateValue = document.getElementById('fromDate').value;
            
            filteredRows = allRows.filter(row => {
                const cells = row.cells;
                if (cells.length === 0) return false;
                
                const orderNumber = cells[0].textContent.toLowerCase();
                const customer = cells[1].textContent.toLowerCase();
                const warehouse = cells[2].textContent.toLowerCase();
                const date = cells[3].textContent;
                const status = cells[4].textContent.trim(); // ★ FIX: Bỏ toLowerCase()
                
                let show = true;
                
                if (searchValue && !orderNumber.includes(searchValue) && 
                    !customer.includes(searchValue) && !warehouse.includes(searchValue)) {
                    show = false;
                }
                
                // ★ FIX: Case-sensitive comparison
                if (statusValue && !status.includes(statusValue)) {
                    show = false;
                }
                
                if (fromDateValue && date) {
                    const rowDate = new Date(date.split('/').reverse().join('-'));
                    const filterDate = new Date(fromDateValue);
                    if (rowDate < filterDate) {
                        show = false;
                    }
                }
                
                return show;
            });

            currentPage = 1;
            updatePagination();
        }

        function updatePagination() {
            const totalItems = filteredRows.length;
            const totalPages = Math.ceil(totalItems / pageSize);
            const startIndex = (currentPage - 1) * pageSize;
            const endIndex = startIndex + pageSize;
            
            allRows.forEach(row => {
                row.style.display = 'none';
            });
            
            const currentPageRows = filteredRows.slice(startIndex, endIndex);
            currentPageRows.forEach(row => {
                row.style.display = '';
            });
            
            const orderCountEl = document.getElementById('orderCount');
            if (orderCountEl) {
                orderCountEl.textContent = totalItems + ' orders';
            }
            
            const pageInfoElement = document.getElementById('pageInfo');
            if (pageInfoElement) {
                if (totalItems === 0) {
                    pageInfoElement.textContent = 'No orders found';
                } else {
                    const displayStart = startIndex + 1;
                    const displayEnd = Math.min(endIndex, totalItems);
                    pageInfoElement.textContent = `Showing ${displayStart}-${displayEnd} of ${totalItems}`;
                }
            }
            
            generatePaginationButtons(totalPages);
            calculateOrderStatistics();
        }

        function generatePaginationButtons(totalPages) {
            const paginationElement = document.getElementById('pagination');
            if (!paginationElement) return;
            
            paginationElement.innerHTML = '';
            
            if (totalPages <= 1) {
                return;
            }
            
            const prevLi = document.createElement('li');
            prevLi.className = currentPage === 1 ? 'page-item disabled' : 'page-item';
            const prevA = document.createElement('a');
            prevA.className = 'page-link';
            prevA.href = '#';
            prevA.innerHTML = '&laquo;';
            if (currentPage > 1) {
                prevA.onclick = function(e) {
                    e.preventDefault();
                    currentPage--;
                    updatePagination();
                };
            }
            prevLi.appendChild(prevA);
            paginationElement.appendChild(prevLi);
            
            const maxPages = Math.min(totalPages, 10);
            for (let i = 1; i <= maxPages; i++) {
                const pageLi = document.createElement('li');
                pageLi.className = i === currentPage ? 'page-item active' : 'page-item';
                
                const pageA = document.createElement('a');
                pageA.className = 'page-link';
                pageA.href = '#';
                pageA.textContent = i;
                pageA.onclick = function(e) {
                    e.preventDefault();
                    currentPage = i;
                    updatePagination();
                };
                
                pageLi.appendChild(pageA);
                paginationElement.appendChild(pageLi);
            }
            
            if (totalPages > 10) {
                const ellipsisLi = document.createElement('li');
                ellipsisLi.className = 'page-item disabled';
                const ellipsisSpan = document.createElement('span');
                ellipsisSpan.className = 'page-link';
                ellipsisSpan.textContent = '...';
                ellipsisLi.appendChild(ellipsisSpan);
                paginationElement.appendChild(ellipsisLi);
            }
            
            const nextLi = document.createElement('li');
            nextLi.className = currentPage === totalPages ? 'page-item disabled' : 'page-item';
            const nextA = document.createElement('a');
            nextA.className = 'page-link';
            nextA.href = '#';
            nextA.innerHTML = '&raquo;';
            if (currentPage < totalPages) {
                nextA.onclick = function(e) {
                    e.preventDefault();
                    currentPage++;
                    updatePagination();
                };
            }
            nextLi.appendChild(nextA);
            paginationElement.appendChild(nextLi);
        }

        function clearFilters() {
            document.getElementById('searchInput').value = '';
            document.getElementById('statusFilter').value = '';
            document.getElementById('fromDate').value = '';
            
            filteredRows = [...allRows];
            currentPage = 1;
            updatePagination();
        }

        // ★ FIXED: Calculate order statistics with proper case sensitivity
        function calculateOrderStatistics() {
            let orderCount = 0;
            let deliveryCount = 0;
            let completedCount = 0;

            filteredRows.forEach(row => {
                const statusCell = row.cells[4];
                
                if (statusCell) {
                    const status = statusCell.textContent.trim(); // ★ FIX: Không lowercase nữa
                    
                    console.log('DEBUG: Status found:', status); // Debug log

                    // ★ FIX: So sánh exact match với proper case
                    if (status === 'Order') {
                        orderCount++;
                    } else if (status === 'Delivery') {
                        deliveryCount++;
                    } else if (status === 'Completed') {
                        completedCount++;
                    }
                }
            });

            console.log('DEBUG: Counts - Order:', orderCount, 'Delivery:', deliveryCount, 'Completed:', completedCount);

            // ★ FIX: Update correct element IDs
            const orderElement = document.getElementById('orderStatusCount');
            const deliveryElement = document.getElementById('deliveryCount');
            const completedElement = document.getElementById('completedCount');

            if (orderElement) orderElement.textContent = orderCount;
            if (deliveryElement) deliveryElement.textContent = deliveryCount;
            if (completedElement) completedElement.textContent = completedCount;
        }

        document.addEventListener('keydown', function(e) {
            if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
                e.preventDefault();
                document.getElementById('searchInput').focus();
            }
            
            if ((e.ctrlKey || e.metaKey) && e.key === 'n') {
                e.preventDefault();
                window.location.href = 'create-sales-order';
            }
        });
    </script>
</body>
</html>