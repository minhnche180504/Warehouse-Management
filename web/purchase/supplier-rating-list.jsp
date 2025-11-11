<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Supplier Ratings - Warehouse Management</title>

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
            <jsp:include page="/purchase/PurchaseSidebar.jsp" />
            <div class="main">
                <jsp:include page="/purchase/navbar.jsp" />

                <main class="content">
                    <div class="container-fluid p-0">
                        <!-- Header Section -->
                        <div class="row mb-2 mb-xl-3">
                            <div class="col-auto d-none d-sm-block">
                                <h3><strong>Supplier</strong> Ratings</h3>
                            </div>
                            <div class="col-auto ms-auto text-end mt-n1">
                                <a href="<c:url value='/purchase/supplier-rating?action=my-ratings'/>" class="btn btn-outline-primary">
                                    <i class="fas fa-star me-1"></i>My Ratings
                                </a>
                            </div>
                        </div>

                        <!-- Pagination URL with filters -->
                        <c:url value="/purchase/supplier-rating" var="paginationUrl">
                            <c:param name="action" value="list" />
                            <c:if test="${not empty param.supplierId}">
                                <c:param name="supplierId" value="${param.supplierId}" />
                            </c:if>
                            <c:if test="${not empty param.userId}">
                                <c:param name="userId" value="${param.userId}" />
                            </c:if>
                            <c:if test="${not empty param.minScore}">
                                <c:param name="minScore" value="${param.minScore}" />
                            </c:if>
                            <c:if test="${not empty param.maxScore}">
                                <c:param name="maxScore" value="${param.maxScore}" />
                            </c:if>
                        </c:url>

                        <!-- Main Card -->
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Search Filters</h5>
                            </div>
                            <div class="card-body">
                                <!-- Filter Form -->
                                <form action="<c:url value='/purchase/supplier-rating'/>" method="GET" class="mb-4">
                                    <input type="hidden" name="action" value="list">
                                    <div class="row g-3">
                                        <div class="col-md-3">
                                            <label for="supplierId" class="form-label">Supplier</label>
                                            <select class="form-select" id="supplierId" name="supplierId">
                                                <option value="">-- All Suppliers --</option>
                                                <c:forEach var="supplier" items="${suppliers}">
                                                    <option value="${supplier.supplierId}" 
                                                            ${param.supplierId == supplier.supplierId ? 'selected' : ''}>
                                                        ${supplier.name}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label for="userId" class="form-label">User</label>
                                            <select class="form-select" id="userId" name="userId">
                                                <option value="">-- All Users --</option>
                                                <c:forEach var="user" items="${users}">
                                                    <option value="${user.userId}" 
                                                            ${param.userId == user.userId ? 'selected' : ''}>
                                                        ${user.fullName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label for="minScore" class="form-label">Min Score</label>
                                            <select class="form-select" id="minScore" name="minScore">
                                                <option value="">-- Min --</option>
                                                <option value="1" ${param.minScore == '1' ? 'selected' : ''}>1 Star</option>
                                                <option value="2" ${param.minScore == '2' ? 'selected' : ''}>2 Stars</option>
                                                <option value="3" ${param.minScore == '3' ? 'selected' : ''}>3 Stars</option>
                                                <option value="4" ${param.minScore == '4' ? 'selected' : ''}>4 Stars</option>
                                                <option value="5" ${param.minScore == '5' ? 'selected' : ''}>5 Stars</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <label for="maxScore" class="form-label">Max Score</label>
                                            <select class="form-select" id="maxScore" name="maxScore">
                                                <option value="">-- Max --</option>
                                                <option value="1" ${param.maxScore == '1' ? 'selected' : ''}>1 Star</option>
                                                <option value="2" ${param.maxScore == '2' ? 'selected' : ''}>2 Stars</option>
                                                <option value="3" ${param.maxScore == '3' ? 'selected' : ''}>3 Stars</option>
                                                <option value="4" ${param.maxScore == '4' ? 'selected' : ''}>4 Stars</option>
                                                <option value="5" ${param.maxScore == '5' ? 'selected' : ''}>5 Stars</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
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

                                <!-- Build filter URL for maintaining state -->
                                <c:set var="filterUrl" value="${pageContext.request.contextPath}/purchase/supplier-rating?action=list" />
                                <c:if test="${not empty param.supplierId}">
                                    <c:set var="filterUrl" value="${filterUrl}&supplierId=${param.supplierId}" />
                                </c:if>
                                <c:if test="${not empty param.userId}">
                                    <c:set var="filterUrl" value="${filterUrl}&userId=${param.userId}" />
                                </c:if>
                                <c:if test="${not empty param.minScore}">
                                    <c:set var="filterUrl" value="${filterUrl}&minScore=${param.minScore}" />
                                </c:if>
                                <c:if test="${not empty param.maxScore}">
                                    <c:set var="filterUrl" value="${filterUrl}&maxScore=${param.maxScore}" />
                                </c:if>

                                <!-- Results Info -->
                                <div class="row align-items-center mb-3">
                                    <div class="col">
                                        <div class="text-muted">
                                            Showing ${(currentPage - 1) * 10 + 1} - ${currentPage * 10 > totalRatings ? totalRatings : currentPage * 10} 
                                            of ${totalRatings} ratings
                                        </div>
                                    </div>
                                </div>

                                <!-- Ratings Table -->
                                <div class="table-responsive">
                                    <table class="table table-striped table-hover">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Supplier</th>
                                                <th>User</th>
                                                <th>Delivery</th>
                                                <th>Quality</th>
                                                <th>Service</th>
                                                <th>Price</th>
                                                <th>Average</th>
                                                <th>Date</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="rating" items="${ratings}">
                                                <c:set var="avgScore" value="${(rating.deliveryScore + rating.qualityScore + rating.serviceScore + rating.priceScore) / 4}" />
                                                <tr>
                                                    <td>${rating.ratingId}</td>
                                                    <td>
                                                        <c:forEach var="supplier" items="${suppliers}">
                                                            <c:if test="${supplier.supplierId eq rating.supplierId}">
                                                                <strong>${supplier.name}</strong>
                                                            </c:if>
                                                        </c:forEach>
                                                    </td>
                                                    <td>
                                                        <c:forEach var="user" items="${users}">
                                                            <c:if test="${user.userId eq rating.userId}">
                                                                ${user.fullName}
                                                            </c:if>
                                                        </c:forEach>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-primary">${rating.deliveryScore}/5</span>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-success">${rating.qualityScore}/5</span>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-info">${rating.serviceScore}/5</span>
                                                    </td>
                                                    <td>
                                                        <span class="badge bg-warning">${rating.priceScore}/5</span>
                                                    </td>
                                                    <td>
                                                        <strong><fmt:formatNumber value="${avgScore}" maxFractionDigits="1" minFractionDigits="1"/>/5</strong>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${rating.ratingDate}" pattern="dd/MM/yyyy" />
                                                    </td>
                                                    <td>
                                                        <div class="btn-group btn-group-sm">
                                                            <a href="<c:url value='/purchase/supplier-rating?action=view&id=${rating.ratingId}'/>" 
                                                               class="btn btn-outline-primary" title="View Details">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty ratings}">
                                                <tr>
                                                    <td colspan="10" class="text-center py-4">
                                                        <div class="text-muted">
                                                            <i class="fas fa-star fa-3x mb-3"></i>
                                                            <p>No ratings found</p>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:if>
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
                                                        document.getElementById('supplierId').value = '';
                                                        document.getElementById('userId').value = '';
                                                        document.getElementById('minScore').value = '';
                                                        document.getElementById('maxScore').value = '';
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