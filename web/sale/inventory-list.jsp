<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>

<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Inventory Overview</title>
    <link href="${pageContext.request.contextPath}/css/light.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
</head>
<body>
    <div class="wrapper">
        <jsp:include page="../components/sidebar_loader.jsp"/>
        <div class="main">
            <jsp:include page="/view/components/navbar.jsp" />

            <main class="content">
                <div class="container-fluid p-0">

                    <div class="mb-3">
                        <h1 class="h3 d-inline align-middle">Inventory List</h1>
                        <%-- Optional: Add button to create new inventory item or other actions --%>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                     <c:if test="${not empty successMessage}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            ${successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title">All Inventory Items</h5>
                        </div>
                        <div class="card-body">
                            <table id="inventoryTable" class="table table-striped" style="width:100%">
                                <thead>
                                    <tr>
                                        <th>Product Code</th>
                                        <th>Product Name</th>
                                        <th>Warehouse</th>
                                        <th>Quantity</th>
                                        <th>Unit</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${inventoryItems}">
                                        <tr>
                                            <td>${item.productCode}</td>
                                            <td>${item.productName}</td>
                                            <td>${item.warehouseName}</td>
                                            <td>${item.quantity}</td>
                                            <td>${item.unit}</td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/inventory-detail?productId=${item.productId}&warehouseId=${item.warehouseId}" class="btn btn-sm btn-info">
                                                    <i data-feather="eye"></i> View Details
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="/view/components/footer.jsp" />
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
    <script>feather.replace()</script>
</body>
</html>
