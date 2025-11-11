<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Purchase Order List</title>
    
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
        <jsp:include page="/purchase/PurchaseSidebar.jsp"/>
        
        <div class="main">
            <!-- Navbar -->
            <jsp:include page="/purchase/navbar.jsp"/>

            <main class="content">
                <div class="container-fluid p-0">
                    <!-- Header Section -->
                    <div class="row mb-2 mb-xl-3">
                        <div class="col-auto d-none d-sm-block">
                            <h3><strong>Purchase Order</strong> List</h3>
                        </div>
                        <div class="col-auto ms-auto text-end mt-n1">
                            <a href="${pageContext.request.contextPath}/purchase/purchase-order?action=create" class="btn btn-primary">
                                <i class="fas fa-plus me-1"></i>Create New Order
                            </a>
                        </div>
                    </div>

                    <!-- Main Card -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Search Filters</h5>
                        </div>
                        <div class="card-body">
                            <!-- Filter Form -->
                            <form action="${pageContext.request.contextPath}/purchase/purchase-order" method="GET" class="mb-4">
                                <input type="hidden" name="action" value="list">
                                <div class="row g-3">
                                    <div class="col-md-3">
                                        <label for="supplier" class="form-label">Supplier</label>
                                        <select class="form-select" id="supplier" name="supplier">
                                            <option value="">-- All Suppliers --</option>
                                            <c:forEach var="supplier" items="${suppliers}">
                                                <option value="${supplier.supplierId}" 
                                                    ${param.supplier == supplier.supplierId ? 'selected' : ''}>
                                                    ${supplier.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <label for="status" class="form-label">Status</label>
                                        <select class="form-select" id="status" name="status">
                                            <option value="">-- All Status --</option>
                                            <option value="Pending" ${param.status == 'Pending' ? 'selected' : ''}>Pending</option>
                                            <option value="Approved" ${param.status == 'Approved' ? 'selected' : ''}>Approved</option>
                                            <option value="Completed" ${param.status == 'Completed' ? 'selected' : ''}>Completed</option>
                                            <option value="Cancelled" ${param.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <label for="startDate" class="form-label">From Date</label>
                                        <input type="date" class="form-control" id="startDate" name="startDate" value="${param.startDate}">
                                    </div>
                                    <div class="col-md-2">
                                        <label for="endDate" class="form-label">To Date</label>
                                        <input type="date" class="form-control" id="endDate" name="endDate" value="${param.endDate}">
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

                            <!-- Set filter values for maintaining state -->
                            <!-- Build filter URL for maintaining state -->
                            <c:set var="filterUrl" value="${pageContext.request.contextPath}/purchse/purchase-order?action=list" />
                            <c:if test="${not empty param.supplier}">
                                <c:set var="filterUrl" value="${filterUrl}&supplier=${param.supplier}" />
                            </c:if>
                            <c:if test="${not empty param.status}">
                                <c:set var="filterUrl" value="${filterUrl}&status=${param.status}" />
                            </c:if>
                            <c:if test="${not empty param.startDate}">
                                <c:set var="filterUrl" value="${filterUrl}&startDate=${param.startDate}" />
                            </c:if>
                            <c:if test="${not empty param.endDate}">
                                <c:set var="filterUrl" value="${filterUrl}&endDate=${param.endDate}" />
                            </c:if>
                            <c:if test="${not empty param.page}">
                                <c:set var="filterUrl" value="${filterUrl}&page=${param.page}" />
                            </c:if>

                            <!-- Results Info -->
                            <div class="row align-items-center mb-3">
                                <div class="col">
                                    <div class="text-muted">
                                        Showing ${(currentPage - 1) * 10 + 1} - ${currentPage * 10 > totalOrders ? totalOrders : currentPage * 10} 
                                        of ${totalOrders} purchase orders
                                    </div>
                                </div>
                                <div class="col-auto">
                                    <div class="btn-group" role="group">
                                        <a href="${pageContext.request.contextPath}/purchase/purchase-order?action=history" 
                                           class="btn btn-outline-primary btn-sm">
                                            <i class="fas fa-history me-1"></i>History
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <!-- Purchase Orders Table -->
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <th>Order Code</th>
                                            <th>Created Date</th>
                                            <th>Supplier</th>
                                            <th>Created By</th>
                                            <th>Expected Delivery Date</th>
                                            <th>Delivery Warehouse</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty purchaseOrders}">
                                                <tr>
                                                    <td colspan="8" class="text-center py-4">
                                                        <div class="text-muted">
                                                            <i class="fas fa-inbox fa-3x mb-3"></i>
                                                            <p>No purchase orders found</p>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="order" items="${purchaseOrders}">
                                                    <tr>
                                                        <td>
                                                            <strong>PO-${order.poId}</strong>
                                                        </td>
                                                        <td>
                                                            <fmt:formatDate value="${order.date}" pattern="dd/MM/yyyy HH:mm" />
                                                        </td>
                                                        <td>${order.supplierName}</td>
                                                        <td>${order.userName}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${order.expectedDeliveryDate != null}">
                                                                    <fmt:formatDate value="${order.expectedDeliveryDate}" pattern="dd/MM/yyyy" />
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">Not specified</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${order.warehouseName != null}">
                                                                    <span class="text-info">
                                                                        <i class="fas fa-warehouse me-1"></i>${order.warehouseName}
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">Not specified</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${order.status == 'Pending'}">
                                                                    <span class="badge bg-warning">Pending</span>
                                                                </c:when>
                                                                <c:when test="${order.status == 'Approved'}">
                                                                    <span class="badge bg-info">Approved</span>
                                                                </c:when>
                                                                <c:when test="${order.status == 'Completed'}">
                                                                    <span class="badge bg-success">Completed</span>
                                                                </c:when>
                                                                <c:when test="${order.status == 'Cancelled'}">
                                                                    <span class="badge bg-danger">Cancelled</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">${order.status}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="btn-group btn-group-sm">
                                                                <a href="${pageContext.request.contextPath}/purchase/purchase-order?action=view&id=${order.poId}" 
                                                                   class="btn btn-outline-primary" title="View Details">
                                                                    <i class="fas fa-eye"></i>
                                                                </a>
                                                                <c:if test="${order.status == 'Pending'}">
                                                                    <button type="button" class="btn btn-outline-success" 
                                                                            onclick="updateStatus('${order.poId}', 'Approved')" title="Approve Order">
                                                                        <i class="fas fa-check"></i>
                                                                    </button>
                                                                    <button type="button" class="btn btn-outline-danger" 
                                                                            onclick="updateStatus('${order.poId}', 'Cancelled')" title="Cancel Order">
                                                                        <i class="fas fa-times"></i>
                                                                    </button>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
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
            document.getElementById('supplier').value = '';
            document.getElementById('status').value = '';
            document.getElementById('startDate').value = '';
            document.getElementById('endDate').value = '';
            document.querySelector('form').submit();
        }

        function updateStatus(poId, newStatus) {
            const statusText = newStatus === 'Approved' ? 'approve' : 'cancel';
            if (confirm('Are you sure you want to ' + statusText + ' this purchase order?')) {
                // Build URL with current filter parameters
                let url = '${pageContext.request.contextPath}/purchase/purchase-order?action=update-status&id=' + poId + '&newStatus=' + newStatus;
                
                // Add current filter parameters to maintain state
                const supplier = '${param.supplier}';
                const status = '${param.status}';
                const startDate = '${param.startDate}';
                const endDate = '${param.endDate}';
                const page = '${param.page}';
                
                if (supplier) url += '&supplier=' + encodeURIComponent(supplier);
                if (status) url += '&status=' + encodeURIComponent(status);
                if (startDate) url += '&startDate=' + encodeURIComponent(startDate);
                if (endDate) url += '&endDate=' + encodeURIComponent(endDate);
                if (page) url += '&page=' + encodeURIComponent(page);
                
                window.location.href = url;
            }
        }

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