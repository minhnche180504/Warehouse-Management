<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    pageContext.setAttribute("currentUser", currentUser);
    pageContext.setAttribute("isAdmin", AuthorizationUtil.isAdmin(currentUser));
    pageContext.setAttribute("isWarehouseManager", AuthorizationUtil.isWarehouseManager(currentUser));
    pageContext.setAttribute("isWarehouseStaff", AuthorizationUtil.isWarehouseStaff(currentUser));
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Purchase Request Detail</title>
    <link href="${pageContext.request.contextPath}/manager/css/light.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', 'Roboto', Arial, sans-serif;
            background: #f6f8fa;
        }
        .detail-label {
            font-weight: 600;
            color: #1976d2;
        }
        .detail-value {
            color: #212529;
        }
        .card-header h4 {
            font-weight: 700;
            font-size: 1.25rem;
            margin-bottom: 1rem;
        }
        .btn-group {
            margin-top: 1rem;
        }
        .card {
            border-radius: 14px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            border: none;
        }
        .btn {
            border-radius: 8px;
            font-weight: 500;
        }
        .table-bordered {
            border-radius: 10px;
            overflow: hidden;
            background: #fff;
        }
        .table-bordered tbody tr:nth-child(odd) {
            background-color: #f9fbfd;
        }
        .table-bordered tbody tr:nth-child(even) {
            background-color: #eef2f7;
        }
        .table-bordered tbody tr:hover {
            background: #e3f2fd;
            transition: background 0.2s;
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <jsp:include page="/manager/ManagerSidebar.jsp"/>
        <div class="main">
            <jsp:include page="/manager/navbar.jsp" />

            <main class="content">
                <div class="container-fluid p-0">
                    <h1 class="h3 mb-3">Purchase Request Detail</h1>

                    <div class="card">
                        <div class="card-header">
                            <h4>Request Information</h4>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-3 detail-label">PR Number:</div>
                                <div class="col-md-9 detail-value"><c:out value="${purchaseRequest.prNumber}" /></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3 detail-label">Requester:</div>
                                <div class="col-md-9 detail-value"><c:out value="${purchaseRequest.requestedByName}" /></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3 detail-label">Warehouse:</div>
                                <div class="col-md-9 detail-value">
                                    <c:choose>
                                        <c:when test="${not empty purchaseRequest.warehouseName}">
                                            <c:out value="${purchaseRequest.warehouseName}" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Chưa có thông tin kho</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3 detail-label">Request Date:</div>
                                <div class="col-md-9 detail-value"><fmt:formatDate value="${purchaseRequest.requestDate}" pattern="yyyy-MM-dd HH:mm:ss" /></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3 detail-label">Preferred Delivery Date:</div>
                                <div class="col-md-9 detail-value"><fmt:formatDate value="${purchaseRequest.preferredDeliveryDate}" pattern="yyyy-MM-dd" /></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3 detail-label">Reason:</div>
                                <div class="col-md-9 detail-value"><c:out value="${purchaseRequest.reason}" /></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3 detail-label">Status:</div>
                                <div class="col-md-9 detail-value">
                                    <c:choose>
                                        <c:when test="${purchaseRequest.status == 'Purchasing'}">
                                            <span style="color: green; font-weight: bold;"><c:out value="${purchaseRequest.status}" /></span>
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="${purchaseRequest.status}" />
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3 detail-label">Confirmed By:</div>
                                <div class="col-md-9 detail-value"><c:out value="${purchaseRequest.confirmByName}" /></div>
                            </div>
                        </div>
                    </div>

                    <div class="card mt-4">
                        <div class="card-header">
                            <h4>Items</h4>
                        </div>
                        <div class="card-body">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>Product</th>
                                        <th>Quantity</th>
                                        <th>Note</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${purchaseRequest.items}">
                                        <tr>
                                            <td><c:out value="${item.productName}" /></td>
                                            <td><c:out value="${item.quantity}" /></td>
                                            <td><c:out value="${item.note}" /></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="btn-group">
                        <a href="${pageContext.request.contextPath}/manager/purchase-request?action=list" class="btn btn-secondary">Back to List</a>
                        <c:if test="${purchaseRequest.status == 'Save Draft'}">
                            <a href="${pageContext.request.contextPath}/manager/purchase-request?action=edit&id=${purchaseRequest.prId}" class="btn btn-warning">Edit</a>
                            <a href="${pageContext.request.contextPath}/manager/purchase-request?action=delete&id=${purchaseRequest.prId}" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this purchase request?');">Delete</a>
                        </c:if>
                    </div>
                </div>
            </main>

            <jsp:include page="/manager/footer.jsp" />
            <script src="${pageContext.request.contextPath}/manager/js/app.js"></script>
        </div>
    </div>
</body>
</html>
