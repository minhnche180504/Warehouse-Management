<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Rating Details - Admin Dashboard</title>
    <meta name="description" content="Rating Details">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="img/icons/icon-48x48.png">
    
    <!-- CSS here -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
    <style>
        .star-display {
            color: #ffcc02;
            font-size: 20px;
        }
        .star-empty {
            color: #ddd;
        }
        .rating-score {
            font-size: 24px;
            font-weight: bold;
            color: #333;
        }
    </style>
</head>

<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
    <div class="wrapper">
        <!-- Sidebar -->
        <jsp:include page="/purchase/PurchaseSidebar.jsp"/>
            <div class="main">
            <jsp:include page="/purchase/navbar.jsp" />

            <main class="content">
                <div class="container-fluid p-0">
                    <div class="row mb-2 mb-xl-3">
                        <div class="col-auto d-none d-sm-block">
                            <h3><strong>Rating</strong> Details</h3>
                        </div>
                        <div class="col-auto ms-auto text-end mt-n1">
                            <a href="<c:url value='/purchase/supplier-rating?action=supplier-ratings&supplierId=${supplier.supplierId}'/>" class="btn btn-info">
                                <i class="align-middle" data-feather="eye"></i> View All Ratings
                            </a>
                            <a href="<c:url value='/purchase/supplier-rating?action=list'/>" class="btn btn-secondary">
                                <i class="align-middle" data-feather="arrow-left"></i> Back to List
                            </a>
                        </div>
                    </div>

                    <div class="row">
                        <!-- Supplier Information -->
                        <div class="col-md-6">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">Supplier Information</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <p><strong>Name:</strong> ${supplier.name}</p>
                                            <p><strong>Email:</strong> ${supplier.email}</p>
                                        </div>
                                        <div class="col-md-6">
                                            <p><strong>Phone:</strong> ${supplier.phone}</p>
                                            <p><strong>Contact:</strong> ${supplier.contactPerson}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Rating Overview -->
                        <div class="col-md-6">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">Rating Overview</h5>
                                </div>
                                <div class="card-body text-center">
                                    <c:set var="averageScore" value="${(rating.deliveryScore + rating.qualityScore + rating.serviceScore + rating.priceScore) / 4}" />
                                    <div class="rating-score mb-2">
                                        <fmt:formatNumber value="${averageScore}" maxFractionDigits="1" minFractionDigits="1"/>/5
                                    </div>
                                    <div class="star-display mb-2">
                                        <c:forEach begin="1" end="5" var="i">
                                            <c:choose>
                                                <c:when test="${i <= averageScore}">★</c:when>
                                                <c:otherwise><span class="star-empty">★</span></c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </div>
                                    <small class="text-muted">
                                        Rated on <fmt:formatDate value="${rating.ratingDate}" pattern="dd/MM/yyyy HH:mm" />
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Detailed Ratings -->
                    <div class="row">
                        <div class="col-12">
                            <div class="card mb-4">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">Detailed Ratings</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-6 mb-4">
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <strong>Delivery Performance</strong>
                                                <span class="badge bg-primary">${rating.deliveryScore}/5</span>
                                            </div>
                                            <div class="star-display">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <c:choose>
                                                        <c:when test="${i <= rating.deliveryScore}">★</c:when>
                                                        <c:otherwise><span class="star-empty">★</span></c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </div>
                                        </div>

                                        <div class="col-md-6 mb-4">
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <strong>Product Quality</strong>
                                                <span class="badge bg-success">${rating.qualityScore}/5</span>
                                            </div>
                                            <div class="star-display">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <c:choose>
                                                        <c:when test="${i <= rating.qualityScore}">★</c:when>
                                                        <c:otherwise><span class="star-empty">★</span></c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </div>
                                        </div>

                                        <div class="col-md-6 mb-4">
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <strong>Customer Service</strong>
                                                <span class="badge bg-info">${rating.serviceScore}/5</span>
                                            </div>
                                            <div class="star-display">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <c:choose>
                                                        <c:when test="${i <= rating.serviceScore}">★</c:when>
                                                        <c:otherwise><span class="star-empty">★</span></c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </div>
                                        </div>

                                        <div class="col-md-6 mb-4">
                                            <div class="d-flex justify-content-between align-items-center mb-2">
                                                <strong>Price Competitiveness</strong>
                                                <span class="badge bg-warning">${rating.priceScore}/5</span>
                                            </div>
                                            <div class="star-display">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <c:choose>
                                                        <c:when test="${i <= rating.priceScore}">★</c:when>
                                                        <c:otherwise><span class="star-empty">★</span></c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Comment Section -->
                    <c:if test="${not empty rating.comment}">
                        <div class="row">
                            <div class="col-12">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">Customer Comment</h5>
                                    </div>
                                    <div class="card-body">
                                        <blockquote class="blockquote">
                                            <p class="mb-0">"${rating.comment}"</p>
                                            <footer class="blockquote-footer mt-2">
                                                Anonymous User
                                            </footer>
                                        </blockquote>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <!-- Rating Information -->
                    <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">Rating Information</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <p><strong>Rating ID:</strong> #${rating.ratingId}</p>
                                        </div>
                                        <div class="col-md-4">
                                            <p><strong>Submitted by:</strong> Anonymous User</p>
                                        </div>
                                        <div class="col-md-4">
                                            <p><strong>Date:</strong> <fmt:formatDate value="${rating.ratingDate}" pattern="dd/MM/yyyy HH:mm" /></p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </main>

            <footer class="footer">
                <div class="container-fluid">
                </div>
            </footer>
        </div>
    </div>

    <script src="js/app.js"></script>

    <script>
        // Toast message display
        var toastMessage = "${sessionScope.toastMessage}";
        var toastType = "${sessionScope.toastType}";
        if (toastMessage && window.notyf) {
            window.notyf.open({
                type: toastType === 'success' ? 'success' : 'error',
                message: toastMessage,
                duration: 5000
            });
            
            // Remove toast attributes from session
            fetch('${pageContext.request.contextPath}/remove-toast', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                }
            }).catch(function(error) {
                console.error('Error:', error);
            });
        }
    </script>
</body>
</html> 