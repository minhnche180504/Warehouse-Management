<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Supplier Ratings - ${supplier.name}</title>
    <meta name="description" content="Supplier Ratings">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="img/icons/icon-48x48.png">
    
    <!-- CSS here -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
    <style>
        .star-display {
            color: #ffcc02;
            font-size: 18px;
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
                    <div class="row mb-2 mb-xl-3">
                        <div class="col-auto d-none d-sm-block">
                            <h3><strong>Ratings for</strong> ${supplier.name}</h3>
                        </div>
                        <div class="col-auto ms-auto text-end mt-n1">
                            <a href="<c:url value='/purchase/supplier-rating?action=add&supplierId=${supplier.supplierId}'/>" class="btn btn-primary">Add Rating</a>
                            <a href="<c:url value='/purchase/supplier-rating?action=list'/>" class="btn btn-secondary">Back to List</a>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <!-- Supplier Summary -->
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">Supplier Information</h5>
                                </div>
                                <div class="card-body">
                                    <p><strong>Name:</strong> ${supplier.name}</p>
                                    <p><strong>Email:</strong> ${supplier.email}</p>
                                    <p><strong>Phone:</strong> ${supplier.phone}</p>
                                    <p><strong>Contact:</strong> ${supplier.contactPerson}</p>
                                    <hr>
                                    <div class="text-center">
                                        <h4>Overall Rating</h4>
                                        <div class="mb-2">
                                            <c:choose>
                                                <c:when test="${averageRating > 0}">
                                                    <span class="star-display">
                                                        <c:forEach begin="1" end="5" var="i">
                                                            <c:choose>
                                                                <c:when test="${i <= averageRating}">★</c:when>
                                                                <c:otherwise><span class="star-empty">★</span></c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </span>
                                                </div>
                                                <h3><fmt:formatNumber value="${averageRating}" maxFractionDigits="1" minFractionDigits="1"/>/5</h3>
                                                <p class="text-muted">Based on ${fn:length(ratings)} rating(s)</p>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="text-muted">No ratings yet</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-8">
                            <!-- Ratings List -->
                            <div class="card">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="card-title mb-0">Customer Reviews</h5>
                                    <span class="badge bg-primary">${fn:length(ratings)} reviews</span>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${not empty ratings}">
                                            <c:forEach var="rating" items="${ratings}">
                                                <div class="border-bottom pb-3 mb-3">
                                                    <div class="row">
                                                        <div class="col-md-8">
                                                            <div class="d-flex align-items-center mb-2">
                                                                <strong class="me-3">Anonymous User</strong>
                                                                <small class="text-muted">
                                                                    <fmt:formatDate value="${rating.ratingDate}" pattern="dd/MM/yyyy" />
                                                                </small>
                                                            </div>
                                                            
                                                            <div class="row mb-2">
                                                                <div class="col-6">
                                                                    <small><strong>Delivery:</strong> 
                                                                        <span class="star-display">
                                                                            <c:forEach begin="1" end="5" var="i">
                                                                                <c:choose>
                                                                                    <c:when test="${i <= rating.deliveryScore}">★</c:when>
                                                                                    <c:otherwise><span class="star-empty">★</span></c:otherwise>
                                                                                </c:choose>
                                                                            </c:forEach>
                                                                        </span>
                                                                        (${rating.deliveryScore}/5)
                                                                    </small>
                                                                </div>
                                                                <div class="col-6">
                                                                    <small><strong>Quality:</strong> 
                                                                        <span class="star-display">
                                                                            <c:forEach begin="1" end="5" var="i">
                                                                                <c:choose>
                                                                                    <c:when test="${i <= rating.qualityScore}">★</c:when>
                                                                                    <c:otherwise><span class="star-empty">★</span></c:otherwise>
                                                                                </c:choose>
                                                                            </c:forEach>
                                                                        </span>
                                                                        (${rating.qualityScore}/5)
                                                                    </small>
                                                                </div>
                                                            </div>
                                                            
                                                            <div class="row mb-2">
                                                                <div class="col-6">
                                                                    <small><strong>Service:</strong> 
                                                                        <span class="star-display">
                                                                            <c:forEach begin="1" end="5" var="i">
                                                                                <c:choose>
                                                                                    <c:when test="${i <= rating.serviceScore}">★</c:when>
                                                                                    <c:otherwise><span class="star-empty">★</span></c:otherwise>
                                                                                </c:choose>
                                                                            </c:forEach>
                                                                        </span>
                                                                        (${rating.serviceScore}/5)
                                                                    </small>
                                                                </div>
                                                                <div class="col-6">
                                                                    <small><strong>Price:</strong> 
                                                                        <span class="star-display">
                                                                            <c:forEach begin="1" end="5" var="i">
                                                                                <c:choose>
                                                                                    <c:when test="${i <= rating.priceScore}">★</c:when>
                                                                                    <c:otherwise><span class="star-empty">★</span></c:otherwise>
                                                                                </c:choose>
                                                                            </c:forEach>
                                                                        </span>
                                                                        (${rating.priceScore}/5)
                                                                    </small>
                                                                </div>
                                                            </div>
                                                            
                                                            <c:if test="${not empty rating.comment}">
                                                                <div class="mt-2">
                                                                    <p class="mb-0">"${rating.comment}"</p>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                        
                                                        <div class="col-md-4 text-end">
                                                            <c:set var="avgScore" value="${(rating.deliveryScore + rating.qualityScore + rating.serviceScore + rating.priceScore) / 4}" />
                                                            <h5 class="mb-1">
                                                                <fmt:formatNumber value="${avgScore}" maxFractionDigits="1" minFractionDigits="1"/>/5
                                                            </h5>
                                                            <div class="star-display">
                                                                <c:forEach begin="1" end="5" var="i">
                                                                    <c:choose>
                                                                        <c:when test="${i <= avgScore}">★</c:when>
                                                                        <c:otherwise><span class="star-empty">★</span></c:otherwise>
                                                                    </c:choose>
                                                                </c:forEach>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center py-5">
                                                <i class="align-middle" data-feather="star" style="font-size: 48px; color: #ddd;"></i>
                                                <h5 class="mt-3">No ratings yet</h5>
                                                <p class="text-muted">Be the first to rate this supplier!</p>
                                                <a href="<c:url value='/purchase/supplier-rating?action=add&supplierId=${supplier.supplierId}'/>" class="btn btn-primary">
                                                    Add Rating
                                                </a>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
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