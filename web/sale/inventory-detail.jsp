<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>
<%@ page import="dao.AuthorizationUtil" %>

<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    // Add role-based access control if needed, e.g., only Admin or Warehouse Manager/Staff
    // if (!AuthorizationUtil.canViewInventory(currentUser)) {
    //    request.setAttribute("errorMessage", "You do not have permission to view inventory details.");
    //    request.getRequestDispatcher("/view/error.jsp").forward(request, response);
    //    return;
    // }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Inventory Detail - ${inventoryDetail.productName}</title>
    <link href="${pageContext.request.contextPath}/css/light.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        .detail-label { font-weight: 600; color: #555; }
        .detail-value { color: #333; }
        .card-subtitle { font-size: 0.9rem; color: #6c757d; }
        .attributes-list li { padding: 0.25rem 0; }
    </style>
</head>
<body>
    <div class="wrapper">
        <jsp:include page="../components/sidebar_loader.jsp"/>
        <div class="main">
            <jsp:include page="/view/components/navbar.jsp" />

            <main class="content">
                <div class="container-fluid p-0">

                    <div class="mb-3">
                        <h1 class="h3 d-inline align-middle">Inventory Detail: ${inventoryDetail.productName}</h1>
                        <a href="${pageContext.request.contextPath}/users" class="btn btn-secondary float-end">Back to List</a>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <c:if test="${inventoryDetail != null}">
                        <div class="row">
                            <div class="col-md-8">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">Product Information</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row mb-2">
                                            <div class="col-sm-4 detail-label">Product Code:</div>
                                            <div class="col-sm-8 detail-value">${inventoryDetail.productCode}</div>
                                        </div>
                                        <div class="row mb-2">
                                            <div class="col-sm-4 detail-label">Product Name:</div>
                                            <div class="col-sm-8 detail-value">${inventoryDetail.productName}</div>
                                        </div>
                                        <div class="row mb-2">
                                            <div class="col-sm-4 detail-label">Description:</div>
                                            <div class="col-sm-8 detail-value">${inventoryDetail.productDescription}</div>
                                        </div>
                                        <div class="row mb-2">
                                            <div class="col-sm-4 detail-label">Unit:</div>
                                            <div class="col-sm-8 detail-value">${inventoryDetail.unit}</div>
                                        </div>
                                        <div class="row mb-2">
                                            <div class="col-sm-4 detail-label">Price:</div>
                                            <div class="col-sm-8 detail-value">
                                                <fmt:formatNumber value="${inventoryDetail.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                            </div>
                                        </div>
                                        <div class="row mb-2">
                                            <div class="col-sm-4 detail-label">Supplier:</div>
                                            <div class="col-sm-8 detail-value">${inventoryDetail.supplierName}</div>
                                        </div>
                                        <c:if test="${not empty inventoryDetail.productAttributes}">
                                            <hr>
                                            <h6 class="card-subtitle mb-2 text-muted">Attributes</h6>
                                            <ul class="list-unstyled attributes-list">
                                                <c:forEach var="attr" items="${inventoryDetail.productAttributes}">
                                                    <li><span class="detail-label">${attr.attributeName}:</span> ${attr.attributeValue}</li>
                                                </c:forEach>
                                            </ul>
                                        </c:if>
                                         <div class="row mb-2">
                                            <div class="col-sm-4 detail-label">Product Added:</div>
                                            <div class="col-sm-8 detail-value">
                                                <fmt:formatDate value="${inventoryDetail.productCreatedAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">Stock Information</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row mb-2">
                                            <div class="col-sm-6 detail-label">Warehouse:</div>
                                            <div class="col-sm-6 detail-value">${inventoryDetail.warehouseName}</div>
                                        </div>
                                        <div class="row mb-2">
                                            <div class="col-sm-6 detail-label">Region:</div>
                                            <div class="col-sm-6 detail-value">${inventoryDetail.region}</div>
                                        </div>
                                        <div class="row mb-2">
                                            <div class="col-sm-6 detail-label">Quantity On Hand:</div>
                                            <div class="col-sm-6 detail-value">
                                                <span class="badge ${inventoryDetail.belowThreshold ? 'bg-danger' : 'bg-success'}">
                                                    ${inventoryDetail.quantityOnHand}
                                                </span>
                                            </div>
                                        </div>
                                        <c:if test="${inventoryDetail.minThreshold != null}">
                                        <div class="row mb-2">
                                            <div class="col-sm-6 detail-label">Min Threshold:</div>
                                            <div class="col-sm-6 detail-value">${inventoryDetail.minThreshold}</div>
                                        </div>
                                        </c:if>
                                        <div class="row mb-2">
                                            <div class="col-sm-6 detail-label">Last Import:</div>
                                            <div class="col-sm-6 detail-value">
                                                <fmt:formatDate value="${inventoryDetail.lastImportDate}" pattern="dd/MM/yyyy" />
                                            </div>
                                        </div>
                                        <div class="row mb-2">
                                            <div class="col-sm-6 detail-label">Last Export:</div>
                                            <div class="col-sm-6 detail-value">
                                                <fmt:formatDate value="${inventoryDetail.lastExportDate}" pattern="dd/MM/yyyy" />
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">Last Stock Check</h5>
                                    </div>
                                    <div class="card-body">
                                        <c:choose>
                                            <c:when test="${inventoryDetail.lastCheckDate != null}">
                                                <div class="row mb-2">
                                                    <div class="col-sm-6 detail-label">Check Date:</div>
                                                    <div class="col-sm-6 detail-value">
                                                        <fmt:formatDate value="${inventoryDetail.lastCheckDate}" pattern="dd/MM/yyyy" />
                                                    </div>
                                                </div>
                                                <div class="row mb-2">
                                                    <div class="col-sm-6 detail-label">Actual Quantity:</div>
                                                    <div class="col-sm-6 detail-value">${inventoryDetail.lastActualQuantity}</div>
                                                </div>
                                                <div class="row mb-2">
                                                    <div class="col-sm-6 detail-label">Discrepancy:</div>
                                                    <div class="col-sm-6 detail-value">${inventoryDetail.lastAdjustmentQty}</div>
                                                </div>
                                                <div class="row mb-2">
                                                    <div class="col-sm-6 detail-label">Reason:</div>
                                                    <div class="col-sm-6 detail-value">${inventoryDetail.adjustmentReason}</div>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <p class="text-muted">No stock check information available.</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>

                </div>
            </main>

            <jsp:include page="/view/components/footer.jsp" />
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>
