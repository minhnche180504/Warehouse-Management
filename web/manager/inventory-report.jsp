<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory Report - Warehouse Management System</title>
    
    <!-- CSS -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css" rel="stylesheet">
</head>

<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
    <div class="wrapper">
        <!-- Sidebar -->
        <jsp:include page="/manager/ManagerSidebar.jsp" />
        
        <div class="main">
            <!-- Navbar -->
            <jsp:include page="/manager/navbar.jsp" />

            <main class="content">
                <div class="container-fluid p-0">
                    <!-- Header Section -->
                    <div class="row mb-2 mb-xl-3">
                        <div class="col-auto d-none d-sm-block">
                            <h3><strong>Inventory</strong> Report</h3>
                        </div>
                        <div class="col-auto ms-auto text-end mt-n1">
                            <a href="${pageContext.request.contextPath}/manager/inventory-report?action=export&product=${param.product}&warehouse=${param.warehouse}&supplier=${param.supplier}&stockLevel=${param.stockLevel}" 
                               class="btn btn-success">
                                <i class="fas fa-download me-1"></i>Export CSV
                            </a>
                        </div>
                    </div>

                    <!-- Build filter URL for maintaining state -->
                    <c:set var="filterUrl" value="${pageContext.request.contextPath}/manager/inventory-report?action=list" />
                    <c:if test="${not empty param.product}">
                        <c:set var="filterUrl" value="${filterUrl}&product=${param.product}" />
                    </c:if>
                    <c:if test="${not empty param.warehouse}">
                        <c:set var="filterUrl" value="${filterUrl}&warehouse=${param.warehouse}" />
                    </c:if>
                    <c:if test="${not empty param.supplier}">
                        <c:set var="filterUrl" value="${filterUrl}&supplier=${param.supplier}" />
                    </c:if>
                    <c:if test="${not empty param.stockLevel}">
                        <c:set var="filterUrl" value="${filterUrl}&stockLevel=${param.stockLevel}" />
                    </c:if>

                    <!-- Main Card -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Filter & Search Options</h5>
                        </div>
                        <div class="card-body">
                            <!-- Filter Form -->
                            <form action="${pageContext.request.contextPath}/manager/inventory-report" method="GET" class="mb-4">
                                <input type="hidden" name="action" value="list">
                                <div class="row g-3">
                                    <div class="col-md-3">
                                        <label for="productFilter" class="form-label">Product</label>
                                        <input type="text" class="form-control" id="productFilter" name="product" 
                                               placeholder="Search by code or name..." value="${param.product}">
                                    </div>
                                    <div class="col-md-2">
                                        <label for="warehouseFilter" class="form-label">Warehouse</label>
                                        <select class="form-select" id="warehouseFilter" name="warehouse">
                                            <option value="">-- All Warehouses --</option>
                                            <c:forEach var="warehouse" items="${warehouses}">
                                                <option value="${warehouse.warehouseId}" 
                                                        ${param.warehouse == warehouse.warehouseId ? 'selected' : ''}>
                                                    ${warehouse.warehouseName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <label for="supplierFilter" class="form-label">Supplier</label>
                                        <input type="text" class="form-control" id="supplierFilter" name="supplier" 
                                               placeholder="Supplier name..." value="${param.supplier}">
                                    </div>
                                    <div class="col-md-2">
                                        <label for="stockLevelFilter" class="form-label">Stock Level</label>
                                        <select class="form-select" id="stockLevelFilter" name="stockLevel">
                                            <option value="">-- All Levels --</option>
                                            <option value="out" ${param.stockLevel == 'out' ? 'selected' : ''}>Out of Stock</option>
                                            <option value="low" ${param.stockLevel == 'low' ? 'selected' : ''}>Low Stock</option>
                                            <option value="normal" ${param.stockLevel == 'normal' ? 'selected' : ''}>Normal Stock</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">&nbsp;</label>
                                        <div class="d-flex gap-2">
                                            <button type="submit" class="btn btn-primary w-100">
                                                <i class="fas fa-search me-1"></i> Search
                                            </button>
                                            <button type="button" class="btn btn-secondary" onclick="clearFilters()">
                                                <i class="fas fa-redo me-1"></i> Reset
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </form>

                            <!-- Results Info -->
                            <div class="row align-items-center mb-3">
                                <div class="col">
                                    <div class="text-muted">
                                        Showing ${(currentPage - 1) * 10 + 1} - ${currentPage * 10 > totalReports ? totalReports : currentPage * 10} 
                                        of ${totalReports} inventory entries
                                    </div>
                                </div>
                            </div>

                                    <!-- Summary Cards -->
                                    <div class="row mb-4">
                                        <div class="col-md-3">
                                            <div class="card border-0 bg-primary text-white">
                                                <div class="card-body">
                                                    <div class="d-flex align-items-center">
                                                        <div class="flex-grow-1">
                                                            <h6 class="card-title mb-0">Total Products</h6>
                                                            <h3 class="mb-0">${totalReports}</h3>
                                                        </div>
                                                        <div class="flex-shrink-0">
                                                            <i class="fas fa-boxes fa-2x opacity-75"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="card border-0 bg-success text-white">
                                                <div class="card-body">
                                                    <div class="d-flex align-items-center">
                                                        <div class="flex-grow-1">
                                                            <h6 class="card-title mb-0">In Stock</h6>
                                                            <h3 class="mb-0">
                                                                <c:set var="inStockCount" value="0" />
                                                                <c:forEach var="report" items="${reports}">
                                                                    <c:if test="${report.onHand > 0}">
                                                                        <c:set var="inStockCount" value="${inStockCount + 1}" />
                                                                    </c:if>
                                                                </c:forEach>
                                                                ${inStockCount}
                                                            </h3>
                                                        </div>
                                                        <div class="flex-shrink-0">
                                                            <i class="fas fa-check-circle fa-2x opacity-75"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="card border-0 bg-warning text-white">
                                                <div class="card-body">
                                                    <div class="d-flex align-items-center">
                                                        <div class="flex-grow-1">
                                                            <h6 class="card-title mb-0">Low Stock</h6>
                                                            <h3 class="mb-0">
                                                                <c:set var="lowStockCount" value="0" />
                                                                <c:forEach var="report" items="${reports}">
                                                                    <c:if test="${report.needsRestock && report.onHand > 0}">
                                                                        <c:set var="lowStockCount" value="${lowStockCount + 1}" />
                                                                    </c:if>
                                                                </c:forEach>
                                                                ${lowStockCount}
                                                            </h3>
                                                        </div>
                                                        <div class="flex-shrink-0">
                                                            <i class="fas fa-exclamation-triangle fa-2x opacity-75"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <div class="card border-0 bg-danger text-white">
                                                <div class="card-body">
                                                    <div class="d-flex align-items-center">
                                                        <div class="flex-grow-1">
                                                            <h6 class="card-title mb-0">Out of Stock</h6>
                                                            <h3 class="mb-0">
                                                                <c:set var="outStockCount" value="0" />
                                                                <c:forEach var="report" items="${reports}">
                                                                    <c:if test="${report.onHand == 0}">
                                                                        <c:set var="outStockCount" value="${outStockCount + 1}" />
                                                                    </c:if>
                                                                </c:forEach>
                                                                ${outStockCount}
                                                            </h3>
                                                        </div>
                                                        <div class="flex-shrink-0">
                                                            <i class="fas fa-times-circle fa-2x opacity-75"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- New Warehouse Statistics Cards -->
                                    <div class="row mb-4">
                                        <div class="col-md-6">
                                            <div class="card border-0 bg-info text-white">
                                                <div class="card-body">
                                                    <div class="d-flex align-items-center">
                                                        <div class="flex-grow-1">
                                                            <h6 class="card-title mb-0">Total Products (All Warehouses)</h6>
                                                            <h3 class="mb-0">${totalProductsAllWarehouses}</h3>
                                                            <small class="opacity-75">Unique products across all warehouses</small>
                                                        </div>
                                                        <div class="flex-shrink-0">
                                                            <i class="fas fa-warehouse fa-2x opacity-75"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="card border-0 bg-secondary text-white">
                                                <div class="card-body">
                                                    <div class="d-flex align-items-center">
                                                        <div class="flex-grow-1">
                                                            <h6 class="card-title mb-0">Distribution by Warehouse</h6>
                                                            <div class="mt-2">
                                                                <c:forEach var="warehouse" items="${warehouses}">
                                                                    <c:if test="${warehouseProductSummary[warehouse.warehouseId] != null}">
                                                                        <div class="d-flex justify-content-between">
                                                                            <small>${warehouse.warehouseName}:</small>
                                                                            <small><strong>${warehouseProductSummary[warehouse.warehouseId]} products</strong></small>
                                                                        </div>
                                                                    </c:if>
                                                                </c:forEach>
                                                            </div>
                                                        </div>
                                                        <div class="flex-shrink-0">
                                                            <i class="fas fa-chart-pie fa-2x opacity-75"></i>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Inventory Table -->
                                    <div class="table-responsive">
                                        <table class="table table-striped table-hover">
                                            <thead class="table-dark">
                                                <tr>
                                                    <th scope="col">Product</th>
                                                    <th scope="col" class="text-end">Unit Cost</th>
                                                    <th scope="col" class="text-end">Total Value</th>
                                                    <th scope="col" class="text-center">On Hand</th>
                                                    <th scope="col" class="text-center">Free to Use</th>
                                                    <th scope="col" class="text-center">Incoming</th>
                                                    <th scope="col" class="text-center">Outgoing</th>
                                                    <th scope="col" class="text-center">Replenishment</th>
                                                    <th scope="col">Location</th>
                                                    <th scope="col" class="text-center">History</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${not empty reports}">
                                                        <c:forEach var="report" items="${reports}">
                                                            <tr>
                                                                <td>
                                                                    <div>
                                                                        <strong>${report.productCode}</strong>
                                                                        <br>
                                                                        <small class="text-muted">${report.productName}</small>
                                                                        <c:if test="${not empty report.supplierName}">
                                                                            <br>
                                                                            <small class="text-info">Supplier: ${report.supplierName}</small>
                                                                        </c:if>
                                                                    </div>
                                                                </td>
                                                                <td class="text-end">
                                                                    <c:choose>
                                                                        <c:when test="${report.unitCost != null}">
                                                                            $${report.unitCost}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">N/A</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="text-end">
                                                                    <strong>$${report.totalValue}</strong>
                                                                </td>
                                                                <td class="text-center">
                                                                    <span class="badge ${report.onHand == 0 ? 'bg-danger' : report.needsRestock ? 'bg-warning' : 'bg-success'}">
                                                                        ${report.onHand}
                                                                        <c:if test="${not empty report.unitCode}">
                                                                            ${report.unitCode}
                                                                        </c:if>
                                                                    </span>
                                                                </td>
                                                                <td class="text-center">
                                                                    <span class="badge ${report.freeToUse == 0 ? 'bg-danger' : report.freeToUse < report.reorderThreshold ? 'bg-warning' : 'bg-success'}" 
                                                                          data-bs-toggle="tooltip" 
                                                                          data-bs-placement="top" 
                                                                          title="Available quantity after subtracting outgoing orders (On Hand - Outgoing)">
                                                                        ${report.freeToUse}
                                                                        <c:if test="${not empty report.unitCode}">
                                                                            ${report.unitCode}
                                                                        </c:if>
                                                                    </span>
                                                                </td>
                                                                <td class="text-center">
                                                                    <c:choose>
                                                                        <c:when test="${report.incoming > 0}">
                                                                            <span class="badge bg-info">${report.incoming}</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            ${report.incoming}
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="text-center">
                                                                    <c:choose>
                                                                        <c:when test="${report.outgoing > 0}">
                                                                            <span class="badge bg-secondary">${report.outgoing}</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            ${report.outgoing}
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="text-center">
                                                                    <c:choose>
                                                                        <c:when test="${report.replenishment == 'Out of Stock'}">
                                                                            <span class="badge bg-danger">
                                                                                <i class="fas fa-exclamation-triangle me-1"></i>
                                                                                Out of Stock
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${report.replenishment == 'Restock'}">
                                                                            <span class="badge bg-warning">
                                                                                <i class="fas fa-exclamation-triangle me-1"></i>
                                                                                Restock
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge bg-success">
                                                                                <i class="fas fa-check me-1"></i>
                                                                                Normal
                                                                            </span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty report.location}">
                                                                            <i class="fas fa-warehouse me-1 text-muted"></i>
                                                                            ${report.location}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td class="text-center">
                                                                    <c:if test="${isUserWarehouse}">
                                                                        <a href="${pageContext.request.contextPath}/manager/inventory-report?action=history&productId=${report.productId}" 
                                                                           class="btn btn-sm btn-outline-primary" title="View History">
                                                                            <i class="fas fa-history"></i>
                                                                        </a>
                                                                    </c:if>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <tr>
                                                            <td colspan="10" class="text-center text-muted py-4">
                                                                <i class="fas fa-box-open fa-3x mb-3"></i>
                                                                <br>
                                                                No inventory data found with the current filters.
                                                            </td>
                                                        </tr>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>

                            <!-- Pagination -->
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="Page navigation" class="mt-4">
                                    <ul class="pagination justify-content-center">
                                        <c:if test="${currentPage > 1}">
                                            <li class="page-item">
                                                <a class="page-link" href="${filterUrl}&page=${currentPage - 1}">
                                                    <i class="fas fa-angle-left"></i>
                                                </a>
                                            </li>
                                        </c:if>

                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="${filterUrl}&page=${i}">${i}</a>
                                            </li>
                                        </c:forEach>

                                        <c:if test="${currentPage < totalPages}">
                                            <li class="page-item">
                                                <a class="page-link" href="${filterUrl}&page=${currentPage + 1}">
                                                    <i class="fas fa-angle-right"></i>
                                                </a>
                                            </li>
                                        </c:if>
                                    </ul>
                                </nav>
                            </c:if>
                        </div>
                    </div>
                </div>
            </main>

            <footer class="footer">
                <div class="container-fluid">
                    <div class="row text-muted">
                        <div class="col-6 text-start">
                            <p class="mb-0">
                                <strong>Warehouse Management System</strong> &copy;
                            </p>
                        </div>
                    </div>
                </div>
            </footer>
        </div>
    </div>

    <!-- Scripts -->
    <script src="js/app.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
    
    <script>
        function clearFilters() {
            document.getElementById('productFilter').value = '';
            document.getElementById('warehouseFilter').value = '';
            document.getElementById('supplierFilter').value = '';
            document.getElementById('stockLevelFilter').value = '';
            document.querySelector('form').submit();
        }

        // Initialize Bootstrap tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });

        // Toast message display
        var toastMessage = '${sessionScope.toastMessage}';
        var toastType = '${sessionScope.toastType}';
        if (toastMessage) {
            iziToast.show({
                title: toastType === 'success' ? 'Success' : 'Error',
                message: toastMessage,
                position: 'topRight',
                color: toastType === 'success' ? 'green' : 'red',
                timeout: 1500
            });
        }
    </script>
</body>
</html>