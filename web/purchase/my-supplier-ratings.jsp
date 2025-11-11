<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Ratings - Warehouse Management</title>
    
    <!-- CSS -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css" rel="stylesheet">
    <style>
        .star-display {
            color: #ffcc02;
            font-size: 16px;
        }
        .star-empty {
            color: #ddd;
        }
    </style>
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
                            <h3><strong>My</strong> Supplier Ratings</h3>
                        </div>
                        <div class="col-auto ms-auto text-end mt-n1">
                            <a href="<c:url value='/purchase/supplier-rating?action=list'/>" class="btn btn-secondary">
                                <i class="fas fa-list me-1"></i>All Ratings
                            </a>
                        </div>
                    </div>

                    <!-- My Ratings -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">My Reviews</h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${not empty ratings}">
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Supplier</th>
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
                                                        <td>
                                                            <c:forEach var="supplier" items="${suppliers}">
                                                                <c:if test="${supplier.supplierId eq rating.supplierId}">
                                                                    <strong>${supplier.name}</strong>
                                                                </c:if>
                                                            </c:forEach>
                                                        </td>
                                                        <td>
                                                            <span class="star-display">
                                                                <c:forEach begin="1" end="5" var="i">
                                                                    <c:choose>
                                                                        <c:when test="${i <= rating.deliveryScore}">★</c:when>
                                                                        <c:otherwise><span class="star-empty">★</span></c:otherwise>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </span>
                                                            <small>(${rating.deliveryScore}/5)</small>
                                                        </td>
                                                        <td>
                                                            <span class="star-display">
                                                                <c:forEach begin="1" end="5" var="i">
                                                                    <c:choose>
                                                                        <c:when test="${i <= rating.qualityScore}">★</c:when>
                                                                        <c:otherwise><span class="star-empty">★</span></c:otherwise>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </span>
                                                            <small>(${rating.qualityScore}/5)</small>
                                                        </td>
                                                        <td>
                                                            <span class="star-display">
                                                                <c:forEach begin="1" end="5" var="i">
                                                                    <c:choose>
                                                                        <c:when test="${i <= rating.serviceScore}">★</c:when>
                                                                        <c:otherwise><span class="star-empty">★</span></c:otherwise>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </span>
                                                            <small>(${rating.serviceScore}/5)</small>
                                                        </td>
                                                        <td>
                                                            <span class="star-display">
                                                                <c:forEach begin="1" end="5" var="i">
                                                                    <c:choose>
                                                                        <c:when test="${i <= rating.priceScore}">★</c:when>
                                                                        <c:otherwise><span class="star-empty">★</span></c:otherwise>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </span>
                                                            <small>(${rating.priceScore}/5)</small>
                                                        </td>
                                                        <td>
                                                            <strong>
                                                                <fmt:formatNumber value="${avgScore}" maxFractionDigits="1" minFractionDigits="1"/>/5
                                                            </strong>
                                                        </td>
                                                        <td>
                                                            <fmt:formatDate value="${rating.ratingDate}" pattern="dd/MM/yyyy" />
                                                        </td>
                                                                                                <td>
                                            <div class="btn-group btn-group-sm">
                                                <a href="<c:url value='/purchase/supplier-rating?action=edit&id=${rating.ratingId}'/>" 
                                                   class="btn btn-outline-primary" title="Edit">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <button onclick="confirmDelete(${rating.ratingId})" 
                                                        class="btn btn-outline-danger" title="Delete">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                        </td>
                                                    </tr>
                                                    <c:if test="${not empty rating.comment}">
                                                        <tr>
                                                            <td colspan="8" class="border-top-0 pt-0">
                                                                <small class="text-muted">
                                                                    <strong>Comment:</strong> "${rating.comment}"
                                                                </small>
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-5">
                                        <i class="fas fa-star fa-3x mb-3" style="color: #ddd;"></i>
                                        <h5 class="mt-3">No ratings yet</h5>
                                        <p class="text-muted">You haven't rated any suppliers yet.</p>
                                        <a href="<c:url value='/purchase/supplier-rating?action=list'/>" class="btn btn-primary">
                                            <i class="fas fa-search me-1"></i>Browse Suppliers
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
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
        function confirmDelete(ratingId) {
            iziToast.question({
                timeout: 20000,
                close: false,
                overlay: true,
                displayMode: 'once',
                id: 'question',
                zindex: 999,
                title: 'Confirm',
                message: 'Are you sure you want to delete this rating?',
                position: 'center',
                buttons: [
                    ['<button><b>YES</b></button>', function (instance, toast) {
                        instance.hide({ transitionOut: 'fadeOut' }, toast, 'button');
                        window.location.href = '${pageContext.request.contextPath}/purchase/supplier-rating?action=delete&id=' + ratingId;
                    }, true],
                    ['<button>NO</button>', function (instance, toast) {
                        instance.hide({ transitionOut: 'fadeOut' }, toast, 'button');
                    }],
                ]
            });
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