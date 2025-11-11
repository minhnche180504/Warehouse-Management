<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>
<%@ page import="dao.AuthorizationUtil" %>

<%
    User currentUser = (User) session.getAttribute("user");
    // Warehouse Staff, Manager, or Admin can view this page.
    if (currentUser == null || !(AuthorizationUtil.isWarehouseStaff(currentUser) || AuthorizationUtil.isWarehouseManager(currentUser) || AuthorizationUtil.isAdmin(currentUser))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    // Đã set currentUser từ servlet, không cần set lại ở đây trừ khi servlet chưa làm
    // request.setAttribute("currentUser", currentUser); 
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Inventory Overview - ${inventoryDetail.productName}</title>

    <link href="${pageContext.request.contextPath}/staff/css/light.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        /* Added CSS styles for inventory overview and warehouse inventory pages */
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f0f4f8;
            color: #212529;
        }

        h1.h3 {
            font-weight: 700;
            margin-bottom: 1rem;
            color: #2c3e50;
            text-shadow: 0 1px 1px rgba(0,0,0,0.1);
        }

        .table.info-table {
            background-color: #ffffff;
            border: 1px solid #b0c4de;
            border-radius: 0.5rem;
            box-shadow: 0 2px 6px rgba(176,196,222,0.3);
        }

        .table.info-table td {
            padding: 0.75rem 1rem;
            vertical-align: middle;
            border-top: 1px solid #d6e0f0;
            color: #34495e;
        }

        .table.info-table tr:first-child td {
            border-top: none;
        }

        .detail-label {
            font-weight: 700;
            color: #1f3a93;
            min-width: 250px;
            padding-right: 15px;
        }

        .detail-value {
            color: #2c3e50;
        }

        .card {
            box-shadow: 0 0.25rem 0.5rem rgba(44, 62, 80, 0.1);
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
            background: linear-gradient(145deg, #e3f2fd, #bbdefb);
        }

        .card-header {
            background-color: #1f3a93;
            border-bottom: 1px solid #162d6b;
            padding: 0.75rem 1.25rem;
            border-top-left-radius: 0.5rem;
            border-top-right-radius: 0.5rem;
            color: #ecf0f1;
            text-shadow: 0 1px 2px rgba(0,0,0,0.3);
        }

        .card-title {
            font-weight: 700;
            font-size: 1.3rem;
            color: #ecf0f1;
        }

        .attribute-list li {
            padding: 0.3rem 0;
            font-size: 0.95rem;
            color: #34495e;
        }

        .table-striped > tbody > tr:nth-of-type(odd) {
            background-color: #dbe9fb;
        }

        .btn-outline-primary {
            color: #1f3a93;
            border-color: #1f3a93;
            font-weight: 600;
        }

        .btn-outline-primary:hover {
            color: #fff;
            background-color: #1f3a93;
            border-color: #162d6b;
        }

        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            border-radius: 0.3rem;
        }

        .text-center {
            text-align: center;
        }

        .alert {
            border-radius: 0.5rem;
            font-weight: 600;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #842029;
            border-color: #f5c2c7;
            box-shadow: 0 0 8px rgba(216, 72, 72, 0.5);
        }

        .alert-warning {
            background-color: #fff3cd;
            color: #664d03;
            border-color: #ffecb5;
            box-shadow: 0 0 8px rgba(255, 193, 7, 0.5);
        }

        .container-fluid {
            padding-left: 1.5rem;
            padding-right: 1.5rem;
        }

        .mb-3 {
            margin-bottom: 1rem !important;
        }

        .float-end {
            float: right !important;
        }
    </style>
</head>

<body>
    <div class="wrapper">
        <%-- Sidebar --%>
        <jsp:include page="/staff/WsSidebar.jsp"/>

        <div class="main">
            <%-- Navbar --%>
            <jsp:include page="/staff/navbar.jsp" />
        

            <main class="content">
                <div class="container-fluid p-0">

                    <div class="mb-3">
                        <h1 class="h3 d-inline align-middle">Inventory Overview: ${inventoryDetail.productName}</h1>
                        <a href="${pageContext.request.contextPath}/ws-warehouse-inventory" class="btn btn-secondary float-end">Back to Inventory List</a>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">${errorMessage}</div>
                    </c:if>

                    <c:if test="${inventoryDetail != null}">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Product Inventory Overview</h5>
                            </div>
                            <div class="card-body">
                                <table class="table info-table">
                                    <tbody>
                                        <tr><td class="detail-label">1. Product Code (Mã sản phẩm):</td><td class="detail-value">${inventoryDetail.productCode}</td></tr>
                                        <tr><td class="detail-label">2. Product Name (Tên sản phẩm):</td><td class="detail-value">${inventoryDetail.productName}</td></tr>
                                        <tr><td class="detail-label">3. Description (Mô tả):</td><td class="detail-value">${not empty inventoryDetail.productDescription ? inventoryDetail.productDescription : 'N/A'}</td></tr>
                                        <tr><td class="detail-label">4. Unit (Đơn vị tính):</td><td class="detail-value">${inventoryDetail.unit}</td></tr>
                                        <tr><td class="detail-label">5. Price (Giá):</td><td class="detail-value"><fmt:formatNumber value="${inventoryDetail.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td></tr>
                                        <tr><td class="detail-label">6. Supplier (Nhà cung cấp):</td><td class="detail-value">${not empty inventoryDetail.supplierName ? inventoryDetail.supplierName : 'N/A'}</td></tr>
                                        <tr><td class="detail-label">7. Warehouse (Kho chứa):</td><td class="detail-value">${inventoryDetail.warehouseName}</td></tr>
                                        <tr><td class="detail-label">8. Region (Miền/Khu vực kho):</td><td class="detail-value">${inventoryDetail.region}</td></tr>
                                        <tr><td class="detail-label">9. Quantity on Hand (Tồn thực tế):</td><td class="detail-value">${inventoryDetail.quantityOnHand} ${inventoryDetail.unit}</td></tr>
                                        <tr>
                                            <td class="detail-label">10. Last Import Date (Ngày nhập gần nhất):</td>
                                            <td class="detail-value">
                                                <fmt:formatDate value="${inventoryDetail.lastImportDate}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                                <c:if test="${empty inventoryDetail.lastImportDate}">N/A</c:if>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="detail-label">11. Last Export Date (Ngày xuất gần nhất):</td>
                                            <td class="detail-value">
                                                <fmt:formatDate value="${inventoryDetail.lastExportDate}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                                <c:if test="${empty inventoryDetail.lastExportDate}">N/A</c:if>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="detail-label">12. Last Stock Check Date (Ngày kiểm kê gần nhất):</td>
                                            <td class="detail-value">
                                                <fmt:formatDate value="${inventoryDetail.lastCheckDate}" pattern="dd/MM/yyyy"/>
                                                <c:if test="${empty inventoryDetail.lastCheckDate}">N/A</c:if>
                                            </td>
                                        </tr>
                                        <tr><td class="detail-label">13. Last Actual Quantity (SL thực tế kiểm kê gần nhất):</td><td class="detail-value">${inventoryDetail.lastActualQuantity != null ? inventoryDetail.lastActualQuantity : '0'} ${inventoryDetail.unit}</td></tr>
                                        
                                        <tr><td class="detail-label">Stock Check Discrepancy (Chênh lệch kiểm kê):</td><td class="detail-value">${inventoryDetail.lastAdjustmentQty != null ? inventoryDetail.lastAdjustmentQty : '0'} ${inventoryDetail.unit}</td></tr>
                                        <tr><td class="detail-label">Stock Check Reason (Lý do chênh lệch kiểm kê):</td><td class="detail-value">${not empty inventoryDetail.adjustmentReason ? inventoryDetail.adjustmentReason : '0'}</td></tr>
                                        
                                            <td class="detail-label">14. Product Attributes (Đặc điểm sản phẩm):</td>
                                            <td class="detail-value">
                                                <c:if test="${not empty inventoryDetail.productAttributes}">
                                                    <ul class="list-unstyled mb-0 attribute-list">
                                                        <c:forEach var="attr" items="${inventoryDetail.productAttributes}">
                                                            <li><strong>${attr.attributeName}:</strong> ${attr.attributeValue}</li>
                                                        </c:forEach>
                                                    </ul>
                                                </c:if>
                                                <c:if test="${empty inventoryDetail.productAttributes}">N/A</c:if>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${inventoryDetail == null && empty errorMessage}">
                         <div class="alert alert-warning">Inventory overview not found for the specified product and warehouse.</div>
                    </c:if>

                </div>
            </main>

            <%-- Footer --%>
            <jsp:include page="/staff/footer.jsp" />
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/staff/js/app.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // Initialize Feather icons
            if (typeof feather !== 'undefined') {
                 feather.replace();
            }
        });
    </script>
</body>
</html>

