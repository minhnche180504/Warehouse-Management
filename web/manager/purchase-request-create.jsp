<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>
<%@ page import="dao.AuthorizationUtil" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    pageContext.setAttribute("currentUser", currentUser);
    
    // Get current date for display
    String currentDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
    pageContext.setAttribute("currentDate", currentDate);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Purchase Request</title>
    <link href="${pageContext.request.contextPath}/manager/css/light.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', 'Roboto', Arial, sans-serif;
            background: #f6f8fa;
        }
        .card-header h5 {
            font-size: 1.1rem;
            font-weight: 600;
        }
        .form-control[readonly] {
            background-color: #e9ecef;
            opacity: 1;
        }
        .form-label .feather {
            width: 16px;
            height: 16px;
            margin-right: 8px;
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
        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #e0e3e7;
            background: #f8fafc;
        }
        .form-control:focus, .form-select:focus {
            border-color: #1976d2;
            box-shadow: 0 0 0 2px #e3f2fd;
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
                    <h1 class="h3 mb-3">Create Purchase Request</h1>

                    <form method="post" action="${pageContext.request.contextPath}/manager/purchase-request" onsubmit="return validateForm();">
                        <input type="hidden" name="action" value="save" />

                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Request Information</h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label d-flex align-items-center"><i class="align-middle" data-feather="hash"></i>PR Number</label>
                                        <input type="text" class="form-control" value="${nextPRNumber}" readonly>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label d-flex align-items-center"><i class="align-middle" data-feather="user"></i>Requester</label>
                                        <input type="text" class="form-control" value="<c:out value='${currentUser.fullName}'/>" readonly>
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label d-flex align-items-center"><i class="align-middle" data-feather="calendar"></i>Request Date</label>
                                        <input type="text" class="form-control" value="${currentDate}" readonly>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="warehouseId" class="form-label d-flex align-items-center"><i class="align-middle" data-feather="archive"></i>Warehouse</label>
                                        <select id="warehouseId" name="warehouseId" class="form-select" <c:if test="${isWarehouseLocked}">disabled</c:if>>
                                            <c:forEach var="warehouse" items="${warehouses}">
                                                <option value="${warehouse.warehouseId}" <c:if test="${warehouse.warehouseId == defaultWarehouseId}">selected</c:if>>
                                                    <c:out value="${warehouse.warehouseName}" />
                                                </option>
                                            </c:forEach>
                                        </select>
                                        <c:if test="${isWarehouseLocked}">
                                            <input type="hidden" name="warehouseId" value="${defaultWarehouseId}" />
                                        </c:if>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="preferredDeliveryDate" class="form-label d-flex align-items-center"><i class="align-middle" data-feather="calendar"></i>Preferred Delivery Date</label>
                                        <input type="date" id="preferredDeliveryDate" name="preferredDeliveryDate" class="form-control" required/>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="reason" class="form-label d-flex align-items-center"><i class="align-middle" data-feather="message-square"></i>Reason</label>
                                    <textarea id="reason" name="reason" class="form-control" rows="3" placeholder="Enter reason for this purchase request..."></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="card-title mb-0">Items to Request</h5>
                                <button type="button" class="btn btn-success d-flex align-items-center gap-2" onclick="addItemRow()"><i class="align-middle" data-feather="plus"></i>Add Item</button>
                            </div>
                            <div class="card-body">
                                <table class="table table-bordered" id="itemsTable">
                                    <thead>
                                        <tr>
                                            <th>Product</th>
                                            <th style="width: 15%;">Quantity</th>
                                            <th>Note</th>
                                            <th style="width: 10%; text-align: center;">Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>
                                                <select name="productId" class="form-select" required>
                                                    <option value="">Select a product</option>
                                                    <c:forEach var="product" items="${products}">
                                                        <option value="${product.productId}"><c:out value="${product.name}" /></option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td><input type="number" name="quantity" class="form-control" min="1" value="1" required /></td>
                                            <td><input type="text" name="note" class="form-control" placeholder="Optional note..."/></td>
                                            <td class="text-center"><button type="button" class="btn btn-danger btn-sm d-flex align-items-center justify-content-center w-100" onclick="removeItemRow(this)"><i class="align-middle" data-feather="trash-2"></i></button></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-end mt-3 gap-2">
                             <a href="${pageContext.request.contextPath}/manager/purchase-request?action=list" class="btn btn-light d-flex align-items-center gap-2"><i class="align-middle" data-feather="x-circle"></i>Cancel</a>
                             <button type="submit" name="submitAction" value="save_draft" class="btn btn-secondary d-flex align-items-center gap-2"><i class="align-middle" data-feather="save"></i>Save as Draft</button>
                             <button type="submit" name="submitAction" value="submit" class="btn btn-primary d-flex align-items-center gap-2"><i class="align-middle" data-feather="check-circle"></i>Submit Request</button>
                        </div>
                    </form>
                </div>
            </main>

            <jsp:include page="/manager/footer.jsp" />
        </div>
        <script src="${pageContext.request.contextPath}/manager/js/app.js"></script>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var today = new Date().toISOString().split('T')[0];
            document.getElementById('preferredDeliveryDate').setAttribute('min', today);
        });

        function addItemRow() {
            const table = document.getElementById('itemsTable').getElementsByTagName('tbody')[0];
            const newRow = table.rows[0].cloneNode(true);
            newRow.querySelector('select[name="productId"]').selectedIndex = 0;
            newRow.querySelector('input[name="quantity"]').value = '1';
            newRow.querySelector('input[name="note"]').value = '';
            table.appendChild(newRow);
            feather.replace(); // Re-initialize icons for the new row
        }

        function removeItemRow(button) {
            const row = button.closest('tr');
            const table = document.getElementById('itemsTable').getElementsByTagName('tbody')[0];
            if (table.rows.length > 1) {
                row.remove();
            } else {
                alert('At least one item is required in the purchase request.');
            }
        }

        function validateForm() {
            const preferredDate = document.getElementById('preferredDeliveryDate').value;
            if (!preferredDate) {
                alert('Please select a preferred delivery date.');
                return false;
            }

            const quantities = document.getElementsByName('quantity');
            for (let qty of quantities) {
                if (!qty.value || parseInt(qty.value, 10) <= 0) {
                    alert('Quantity for all items must be a positive number.');
                    return false;
                }
            }
            
            const products = document.getElementsByName('productId');
            const selectedProducts = new Set();
            for (let prod of products) {
                if (prod.value === "") {
                    alert('Please select a product for all items.');
                    return false;
                }
                if (selectedProducts.has(prod.value)) {
                    alert('Duplicate products found. Please combine quantities in a single line.');
                    return false;
                }
                selectedProducts.add(prod.value);
            }

            return true;
        }
    </script>
</body>
</html>

