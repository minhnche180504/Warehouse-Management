<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Rate Supplier - Admin Dashboard</title>
    <meta name="description" content="Rate Supplier">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="img/icons/icon-48x48.png">
    
    <!-- CSS here -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
    <style>
        .star-rating {
            display: inline-flex;
            flex-direction: row-reverse;
            font-size: 24px;
            padding: 0;
            margin: 0;
        }
        
        .star-rating input {
            display: none;
        }
        
        .star-rating label {
            color: #ddd;
            cursor: pointer;
            padding: 0 5px;
            transition: color 0.2s;
        }
        
        .star-rating input:checked ~ label,
        .star-rating label:hover,
        .star-rating label:hover ~ label {
            color: #ffcc02;
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
                            <h3><strong>Rate</strong> Supplier</h3>
                        </div>
                        <div class="col-auto ms-auto text-end mt-n1">
                            <a href="<c:url value='/purchase/supplier-rating?action=list'/>" class="btn btn-secondary">Back to List</a>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-8">
                            <!-- Supplier Info -->
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
                                            <p><strong>Contact Person:</strong> ${supplier.contactPerson}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Rating Form -->
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">Rate This Supplier</h5>
                                </div>
                                <div class="card-body">
                                    <c:if test="${not empty errorMessage}">
                                        <div class="alert alert-danger" role="alert">
                                            ${errorMessage}
                                        </div>
                                    </c:if>

                                    <form action="<c:url value='${pageContext.request.contextPath}/purchase/supplier-rating'/>" method="POST">
                                        <input type="hidden" name="action" value="create">
                                        <input type="hidden" name="supplierId" value="${supplier.supplierId}">

                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Delivery Score <span class="text-danger">*</span></label>
                                                <div class="star-rating">
                                                    <input type="radio" name="deliveryScore" value="5" id="delivery5" 
                                                        <c:if test="${deliveryScore eq 5}">checked</c:if>>
                                                    <label for="delivery5">★</label>
                                                    <input type="radio" name="deliveryScore" value="4" id="delivery4" 
                                                        <c:if test="${deliveryScore eq 4}">checked</c:if>>
                                                    <label for="delivery4">★</label>
                                                    <input type="radio" name="deliveryScore" value="3" id="delivery3" 
                                                        <c:if test="${deliveryScore eq 3}">checked</c:if>>
                                                    <label for="delivery3">★</label>
                                                    <input type="radio" name="deliveryScore" value="2" id="delivery2" 
                                                        <c:if test="${deliveryScore eq 2}">checked</c:if>>
                                                    <label for="delivery2">★</label>
                                                    <input type="radio" name="deliveryScore" value="1" id="delivery1" 
                                                        <c:if test="${deliveryScore eq 1}">checked</c:if>>
                                                    <label for="delivery1">★</label>
                                                </div>
                                                <small class="form-text text-muted">Rate the delivery performance</small>
                                            </div>

                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Quality Score <span class="text-danger">*</span></label>
                                                <div class="star-rating">
                                                    <input type="radio" name="qualityScore" value="5" id="quality5" 
                                                        <c:if test="${qualityScore eq 5}">checked</c:if>>
                                                    <label for="quality5">★</label>
                                                    <input type="radio" name="qualityScore" value="4" id="quality4" 
                                                        <c:if test="${qualityScore eq 4}">checked</c:if>>
                                                    <label for="quality4">★</label>
                                                    <input type="radio" name="qualityScore" value="3" id="quality3" 
                                                        <c:if test="${qualityScore eq 3}">checked</c:if>>
                                                    <label for="quality3">★</label>
                                                    <input type="radio" name="qualityScore" value="2" id="quality2" 
                                                        <c:if test="${qualityScore eq 2}">checked</c:if>>
                                                    <label for="quality2">★</label>
                                                    <input type="radio" name="qualityScore" value="1" id="quality1" 
                                                        <c:if test="${qualityScore eq 1}">checked</c:if>>
                                                    <label for="quality1">★</label>
                                                </div>
                                                <small class="form-text text-muted">Rate the product quality</small>
                                            </div>

                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Service Score <span class="text-danger">*</span></label>
                                                <div class="star-rating">
                                                    <input type="radio" name="serviceScore" value="5" id="service5" 
                                                        <c:if test="${serviceScore eq 5}">checked</c:if>>
                                                    <label for="service5">★</label>
                                                    <input type="radio" name="serviceScore" value="4" id="service4" 
                                                        <c:if test="${serviceScore eq 4}">checked</c:if>>
                                                    <label for="service4">★</label>
                                                    <input type="radio" name="serviceScore" value="3" id="service3" 
                                                        <c:if test="${serviceScore eq 3}">checked</c:if>>
                                                    <label for="service3">★</label>
                                                    <input type="radio" name="serviceScore" value="2" id="service2" 
                                                        <c:if test="${serviceScore eq 2}">checked</c:if>>
                                                    <label for="service2">★</label>
                                                    <input type="radio" name="serviceScore" value="1" id="service1" 
                                                        <c:if test="${serviceScore eq 1}">checked</c:if>>
                                                    <label for="service1">★</label>
                                                </div>
                                                <small class="form-text text-muted">Rate the customer service</small>
                                            </div>

                                            <div class="col-md-6 mb-3">
                                                <label class="form-label">Price Score <span class="text-danger">*</span></label>
                                                <div class="star-rating">
                                                    <input type="radio" name="priceScore" value="5" id="price5" 
                                                        <c:if test="${priceScore eq 5}">checked</c:if>>
                                                    <label for="price5">★</label>
                                                    <input type="radio" name="priceScore" value="4" id="price4" 
                                                        <c:if test="${priceScore eq 4}">checked</c:if>>
                                                    <label for="price4">★</label>
                                                    <input type="radio" name="priceScore" value="3" id="price3" 
                                                        <c:if test="${priceScore eq 3}">checked</c:if>>
                                                    <label for="price3">★</label>
                                                    <input type="radio" name="priceScore" value="2" id="price2" 
                                                        <c:if test="${priceScore eq 2}">checked</c:if>>
                                                    <label for="price2">★</label>
                                                    <input type="radio" name="priceScore" value="1" id="price1" 
                                                        <c:if test="${priceScore eq 1}">checked</c:if>>
                                                    <label for="price1">★</label>
                                                </div>
                                                <small class="form-text text-muted">Rate the price competitiveness</small>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label for="comment" class="form-label">Comment</label>
                                            <textarea class="form-control" id="comment" name="comment" rows="4" 
                                                placeholder="Share your experience with this supplier...">${comment}</textarea>
                                            <small class="form-text text-muted">Optional feedback about this supplier</small>
                                        </div>

                                        <div class="d-flex justify-content-between">
                                            <a href="<c:url value='/purchase/supplier-rating?action=list'/>" class="btn btn-secondary">Cancel</a>
                                            <button type="submit" class="btn btn-primary">Submit Rating</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">Rating Guidelines</h5>
                                </div>
                                <div class="card-body">
                                    <p><strong>★★★★★ (5 stars)</strong> - Excellent</p>
                                    <p><strong>★★★★☆ (4 stars)</strong> - Very Good</p>
                                    <p><strong>★★★☆☆ (3 stars)</strong> - Good</p>
                                    <p><strong>★★☆☆☆ (2 stars)</strong> - Fair</p>
                                    <p><strong>★☆☆☆☆ (1 star)</strong> - Poor</p>
                                    
                                    <hr>
                                    
                                    <h6>Criteria:</h6>
                                    <ul class="list-unstyled">
                                        <li><strong>Delivery:</strong> Timeliness and condition</li>
                                        <li><strong>Quality:</strong> Product standards</li>
                                        <li><strong>Service:</strong> Customer support</li>
                                        <li><strong>Price:</strong> Value for money</li>
                                    </ul>
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
        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            var deliveryScore = document.querySelector('input[name="deliveryScore"]:checked');
            var qualityScore = document.querySelector('input[name="qualityScore"]:checked');
            var serviceScore = document.querySelector('input[name="serviceScore"]:checked');
            var priceScore = document.querySelector('input[name="priceScore"]:checked');
            
            if (!deliveryScore || !qualityScore || !serviceScore || !priceScore) {
                e.preventDefault();
                alert('Please rate all criteria before submitting!');
                return false;
            }
        });
    </script>
</body>
</html> 