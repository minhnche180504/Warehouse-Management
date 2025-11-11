<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory History - Warehouse Management System</title>
    
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
                            <h3><strong>Inventory History</strong> 
                                <c:if test="${not empty productCode}">
                                    - ${productCode}
                                </c:if>
                            </h3>
                            <c:if test="${not empty productName}">
                                <p class="text-muted mb-0">${productName}</p>
                            </c:if>
                        </div>
                        <div class="col-auto ms-auto text-end mt-n1">
                            <a href="${pageContext.request.contextPath}/manager/inventory-report?action=list" class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-1"></i>Back to Report
                            </a>
                        </div>
                    </div>

                    <!-- Build filter URL for maintaining state -->
                    <c:set var="filterUrl" value="${pageContext.request.contextPath}/manager/inventory-report?action=history&productId=${productId}" />
                    <c:if test="${not empty param.transactionType}">
                        <c:set var="filterUrl" value="${filterUrl}&transactionType=${param.transactionType}" />
                    </c:if>

                    <!-- Main Card -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Transaction Filters</h5>
                        </div>
                        <div class="card-body">
                            <!-- Filter Form -->
                            <form action="${pageContext.request.contextPath}/manager/inventory-report" method="GET" class="mb-4">
                                <input type="hidden" name="action" value="history">
                                <input type="hidden" name="productId" value="${productId}">
                                <div class="row g-3">
                                    <div class="col-md-3">
                                        <label for="transactionType" class="form-label">Transaction Type</label>
                                        <select class="form-select" id="transactionType" name="transactionType">
                                            <option value="">-- All Transactions --</option>
                                            <option value="IN" ${param.transactionType == 'IN' ? 'selected' : ''}>Stock In</option>
                                            <option value="OUT" ${param.transactionType == 'OUT' ? 'selected' : ''}>Stock Out</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">&nbsp;</label>
                                        <div class="d-flex gap-2">
                                            <button type="submit" class="btn btn-primary w-100">
                                                <i class="fas fa-filter me-1"></i> Filter
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
                                        Showing ${(currentPage - 1) * 15 + 1} - ${currentPage * 15 > totalHistory ? totalHistory : currentPage * 15} 
                                        of ${totalHistory} transactions
                                    </div>
                                </div>
                            </div>

                            <!-- History Table -->
                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead>
                                        <tr>
                                            <th>Date</th>
                                            <th>Type</th>
                                            <th>Quantity Change</th>
                                            <th>Reference</th>
                                            <th>Reason</th>
                                            <th>User</th>
                                            <th>Warehouse</th>
                                            <th>Unit Price</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty history}">
                                                <tr>
                                                    <td colspan="8" class="text-center py-4">
                                                        <div class="text-muted">
                                                            <i class="fas fa-history fa-3x mb-3"></i>
                                                            <p>No transaction history found for this product</p>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="record" items="${history}">
                                                    <tr>
                                                        <td>
                                                            <fmt:formatDate value="${record.transactionDate}" pattern="dd/MM/yyyy" />
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${record.transactionType == 'IN'}">
                                                                    <span class="badge bg-success">
                                                                        <i class="fas fa-arrow-up me-1"></i>Stock In
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${record.transactionType == 'OUT'}">
                                                                    <span class="badge bg-danger">
                                                                        <i class="fas fa-arrow-down me-1"></i>Stock Out
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-warning">
                                                                        <i class="fas fa-edit me-1"></i>Adjustment
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${record.transactionType == 'IN'}">
                                                                    <span class="text-success fw-bold">
                                                                        +${record.quantityChange}
                                                                        <c:if test="${not empty record.unitCode}">
                                                                            ${record.unitCode}
                                                                        </c:if>
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${record.transactionType == 'OUT'}">
                                                                    <span class="text-danger fw-bold">
                                                                        ${record.quantityChange}
                                                                        <c:if test="${not empty record.unitCode}">
                                                                            ${record.unitCode}
                                                                        </c:if>
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-warning fw-bold">
                                                                        ${record.quantityChangeDisplay}
                                                                        <c:if test="${not empty record.unitCode}">
                                                                            ${record.unitCode}
                                                                        </c:if>
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty record.referenceNumber}">
                                                                <span class="badge bg-secondary">${record.referenceNumber}</span>
                                                            </c:if>
                                                        </td>
                                                        <td>${record.reason}</td>
                                                        <td>
                                                            <c:if test="${not empty record.userName}">
                                                                <i class="fas fa-user me-1 text-muted"></i>
                                                                ${record.userName}
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty record.warehouseName}">
                                                                    <i class="fas fa-warehouse me-1 text-muted"></i>
                                                                    ${record.warehouseName}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">N/A</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${record.unitPrice != null && record.unitPrice > 0}">
                                                                    $${record.unitPrice}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">N/A</span>
                                                                </c:otherwise>
                                                            </c:choose>
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
            document.getElementById('transactionType').value = '';
            document.querySelector('form').submit();
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