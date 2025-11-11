<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Supplier Ratings - Admin Dashboard</title>
    <meta name="description" content="Supplier Ratings">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="img/icons/icon-48x48.png">
    
    <!-- CSS here -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
</head>

<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
    <div class="wrapper">
        <!-- Sidebar -->
        <jsp:include page="/purchase/PurchaseSidebar.jsp" />
            <div class="main">
            <jsp:include page="/purchase/navbar.jsp" />

            <main class="content">
                <div class="container-fluid p-0">
                    <div class="row mb-2 mb-xl-3">
                        <div class="col-auto d-none d-sm-block">
                            <h3><strong>Supplier</strong> Ratings</h3>
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

                    <!-- Filter Form -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Search Filters</h5>
                        </div>
                        <div class="card-body">
                            <form action="<c:url value='/purchase/supplier-rating'/>" method="GET" class="mb-4">
                                <input type="hidden" name="action" value="list">
                                <div class="row mb-3">
                                    <div class="col-md-3">
                                        <select class="form-control" name="supplierId">
                                            <option value="">All Suppliers</option>
                                            <c:forEach var="supplier" items="${suppliers}">
                                                <option value="${supplier.supplierId}" 
                                                    <c:if test="${param.supplierId eq supplier.supplierId}">selected</c:if>>
                                                    ${supplier.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <select class="form-control" name="userId">
                                            <option value="">All Users</option>
                                            <c:forEach var="user" items="${users}">
                                                <option value="${user.userId}" 
                                                    <c:if test="${param.userId eq user.userId}">selected</c:if>>
                                                    ${user.fullName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <select class="form-control" name="minScore">
                                            <option value="">Min Score</option>
                                            <option value="1" <c:if test="${param.minScore eq '1'}">selected</c:if>>1 Star</option>
                                            <option value="2" <c:if test="${param.minScore eq '2'}">selected</c:if>>2 Stars</option>
                                            <option value="3" <c:if test="${param.minScore eq '3'}">selected</c:if>>3 Stars</option>
                                            <option value="4" <c:if test="${param.minScore eq '4'}">selected</c:if>>4 Stars</option>
                                            <option value="5" <c:if test="${param.minScore eq '5'}">selected</c:if>>5 Stars</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <select class="form-control" name="maxScore">
                                            <option value="">Max Score</option>
                                            <option value="1" <c:if test="${param.maxScore eq '1'}">selected</c:if>>1 Star</option>
                                            <option value="2" <c:if test="${param.maxScore eq '2'}">selected</c:if>>2 Stars</option>
                                            <option value="3" <c:if test="${param.maxScore eq '3'}">selected</c:if>>3 Stars</option>
                                            <option value="4" <c:if test="${param.maxScore eq '4'}">selected</c:if>>4 Stars</option>
                                            <option value="5" <c:if test="${param.maxScore eq '5'}">selected</c:if>>5 Stars</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <button type="submit" class="btn btn-primary w-100">
                                            <i class="align-middle" data-feather="search"></i> Search
                                        </button>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12">
                                        <a href="<c:url value='/purchase/supplier-rating?action=list'/>" class="btn btn-secondary">
                                            <i class="align-middle" data-feather="refresh-cw"></i> Clear Filters
                                        </a>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Ratings Table -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Ratings List</h5>
                            <div class="text-muted">Total: ${totalRatings} ratings</div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
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
                                                    <a href="<c:url value='/purchase/supplier-rating?action=view&id=${rating.ratingId}'/>" 
                                                       class="btn btn-sm btn-outline-primary" title="View">
                                                        <i class="align-middle" data-feather="eye"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty ratings}">
                                            <tr>
                                                <td colspan="10" class="text-center text-muted">No ratings found</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Pagination -->
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="Page navigation" style="margin-top: 30px">
                                    <ul class="pagination justify-content-center">
                                        <c:if test="${currentPage > 1}">
                                            <li class="page-item">
                                                <a class="page-link" href="${paginationUrl}&page=${currentPage - 1}" aria-label="Previous">
                                                    <span aria-hidden="true">&laquo;</span>
                                                </a>
                                            </li>
                                        </c:if>

                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="${paginationUrl}&page=${i}">${i}</a>
                                            </li>
                                        </c:forEach>

                                        <c:if test="${currentPage < totalPages}">
                                            <li class="page-item">
                                                <a class="page-link" href="${paginationUrl}&page=${currentPage + 1}" aria-label="Next">
                                                    <span aria-hidden="true">&raquo;</span>
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

            <jsp:include page="/purchase/footer.jsp" />
        </div>
    </div>

    <script src="js/app.js"></script>

    <script>
        // Toast message display
        var toastMessage = "${sessionScope.toastMessage}";
        var toastType = "${sessionScope.toastType}";
        if (toastMessage) {
            // Simple alert for now - can be enhanced with proper toast notifications
            alert(toastMessage);
            
            // Remove toast attributes from the session
            fetch('${pageContext.request.contextPath}/remove-toast', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
            }).catch(function(error) {
                console.error('Error:', error);
            });
        }
    </script>
</body>
</html> 