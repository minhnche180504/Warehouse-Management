<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>
<%@ page import="dao.AuthorizationUtil" %>

<%-- Retrieve variables from request scope passed by Servlet --%>
<jsp:useBean id="report" scope="request" type="model.StockCheckReport"/>
<jsp:useBean id="warehouses" scope="request" type="java.util.List<model.WarehouseDisplay>"/>
<jsp:useBean id="products" scope="request" type="java.util.List<model.Product>"/>
<jsp:useBean id="currentUser" scope="request" type="model.User"/>
<c:set var="viewAction" value="${requestScope.viewAction}" />
<c:set var="isWarehouseManager" value="${requestScope.isWarehouseManager}" />
<c:set var="isWarehouseStaff" value="${requestScope.isWarehouseStaff}" />
<c:set var="canEditReport" value="${requestScope.canEditReport}" />
<c:set var="isEditMode" value="${canEditReport}" />

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>
            <c:choose>
                <c:when test="${isEditMode}">Edit Stock Check Report</c:when>
                <c:otherwise>Stock Check Report Details</c:otherwise>
            </c:choose>
            : ${report.reportCode}
        </title>
        <link href="${pageContext.request.contextPath}/manager/css/light.css" rel="stylesheet">
        <style>
            .table-items th, .table-items td {
                vertical-align: middle;
            }
            .table-items .form-control-sm {
                padding: 0.25rem 0.5rem;
                font-size: 0.875rem;
            }
            .table-items .form-control-sm[readonly],
            .table-items .form-select.form-control-sm[disabled] {
                background-color: #e9ecef;
                opacity: 1;
            }
            .btn-remove-item {
                color: #dc3545;
            }
            .btn-remove-item:hover {
                color: #a71d2a;
            }
            .status-badge {
                padding: 0.35em 0.65em;
                font-size: .75em;
                font-weight: 700;
                line-height: 1;
                color: #fff;
                text-align: center;
                white-space: nowrap;
                vertical-align: baseline;
                border-radius: .25rem;
            }
            .status-pending {
                background-color: #ffc107 !important;
                color: #000 !important;
            }
            .status-approved {
                background-color: #28a745 !important;
            }
            .status-rejected {
                background-color: #dc3545 !important;
            }
            .status-completed {
                background-color: #17a2b8 !important;
            }
            .form-control[readonly] {
                background-color: #e9ecef;
                opacity: 1;
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
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h1 class="h3">
                                <c:choose>
                                    <c:when test="${isEditMode}">Edit Stock Check Report</c:when>
                                    <c:otherwise>Stock Check Report Details</c:otherwise>
                                </c:choose>
                                : ${report.reportCode}
                            </h1>
                            <div>
                                <a href="${pageContext.request.contextPath}/manager/list-stock-check-reports" class="btn btn-secondary">
                                    <i data-feather="arrow-left" class="align-middle"></i> Back to List
                                </a>
                            </div>
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

                        <form action="${pageContext.request.contextPath}/manager/manage-stock-check-report" method="POST" id="manageStockCheckForm">
                            <input type="hidden" name="reportId" value="${report.reportId}">
                            <input type="hidden" name="formAction" id="formActionInput" value="${isEditMode ? 'update' : ''}">

                            <div class="card">
                                <div class="card-header">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <h5 class="card-title mb-0">General Information</h5>
                                        <div>
                                            Status: 
                                            <span class="status-badge
                                                  <c:choose>
                                                      <c:when test='${report.status == "Pending"}'>status-pending</c:when>
                                                      <c:when test='${report.status == "Approved"}'>status-approved</c:when>
                                                      <c:when test='${report.status == "Rejected"}'>status-rejected</c:when>
                                                      <c:when test='${report.status == "Completed"}'>status-completed</c:when>
                                                      <c:otherwise>bg-secondary</c:otherwise>
                                                  </c:choose>
                                                  ">${report.status}</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-3 mb-3">
                                            <label for="reportCodeDisplay" class="form-label">Report Code</label>
                                            <input type="text" class="form-control" id="reportCodeDisplay" value="${report.reportCode}" readonly>
                                            <input type="hidden" name="reportCode" value="${report.reportCode}"> <%-- Send reportCode when updating --%>
                                        </div>
                                        <div class="col-md-3 mb-3">
                                            <label for="warehouseId" class="form-label">Warehouse</label>
                                            <select class="form-select" id="warehouseId" name="warehouseId" disabled required>
                                                <c:forEach var="warehouse" items="${warehouses}">
                                                    <option value="${warehouse.warehouseId}" ${warehouse.warehouseId == report.warehouseId ? 'selected' : ''}>
                                                        ${warehouse.warehouseName}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <input type="hidden" name="warehouseId" value="${report.warehouseId}">
                                        </div>
                                        <div class="col-md-3 mb-3">
                                            <label for="reportDate" class="form-label">Check Date</label>
                                            <input type="date" class="form-control" id="reportDate" name="reportDate" 
                                                   value="<fmt:formatDate value='${report.reportDate}' pattern='yyyy-MM-dd'/>" 
                                                   readonly required>
                                            <input type="hidden" name="reportDate" value="<fmt:formatDate value='${report.reportDate}' pattern='yyyy-MM-dd'/>">
                                        </div>
                                        <div class="col-md-3 mb-3">
                                            <label class="form-label">Created By</label>
                                            <input type="text" class="form-control" value="${report.createdByName}" readonly>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="notes" class="form-label">Staff Notes</label>
                                            <textarea class="form-control" id="notes" name="notes" rows="3"
                                                ${isEditMode && isWarehouseStaff ? "" : "readonly"}>${report.notes}</textarea>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="managerNotesDisplay" class="form-label">Manager Notes</label>
                                            <textarea class="form-control" id="managerNotesDisplay" name="managerNotes" rows="3"
                                                ${isEditMode && isWarehouseManager ? "" : "readonly"}>${report.managerNotes}</textarea>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-4 mb-3">
                                            <label class="form-label">Report Creation Date</label>
                                            <input type="text" class="form-control" value="<fmt:formatDate value='${report.createdAt}' pattern='dd/MM/yyyy HH:mm:ss'/>" readonly>
                                        </div>
                                        <c:if test="${not empty report.approvedBy}">
                                            <div class="col-md-4 mb-3">
                                                <label class="form-label">Approved/Rejected By</label>
                                                <input type="text" class="form-control" value="${report.approvedByName}" readonly>
                                            </div>
                                            <div class="col-md-4 mb-3">
                                                <label class="form-label">Approval/Rejection Date</label>
                                                <input type="text" class="form-control" value="<fmt:formatDate value='${report.approvedAt}' pattern='dd/MM/yyyy HH:mm:ss'/>" readonly>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>

                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title">Product Details</h5>
                                </div>
                                <div class="card-body">
                                    <table class="table table-bordered table-hover table-items" id="itemsTable">
                                        <thead>
                                            <tr>
                                                <th style="width: 30%;">Product</th>
                                                <th style="width: 15%;">System Quantity</th>
                                                <th style="width: 15%;">Actual Quantity</th>
                                                <th style="width: 10%;">Discrepancy</th>
                                                <th style="width: 25%;">Reason</th>
                                                    <c:if test="${isEditMode}">
                                                    <th style="width: 5%;"></th>
                                                    </c:if>
                                            </tr>
                                        </thead>
                                        <tbody id="itemsTableBody">
                                            <c:forEach var="item" items="${report.items}" varStatus="loop">
                                                <tr class="item-row">
                                                    <td>
                                                        <select class="form-select form-control-sm product-select" name="productId" ${isEditMode ? '' : 'disabled'} required>
                                                            <option value="">Select product...</option>
                                                            <c:forEach var="product" items="${products}">
                                                                <option value="${product.productId}" data-qty="${product.quantity}" ${product.productId == item.productId ? 'selected' : ''}>
                                                                    ${product.productName} (${product.productCode})
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </td>
                                                    <td><input type="number" class="form-control form-control-sm system-quantity" name="systemQuantity" value="${item.systemQuantity}" min="0" required readonly></td>
                                                    <td><input type="number" class="form-control form-control-sm counted-quantity" name="countedQuantity" value="${item.countedQuantity}" min="0" ${isEditMode ? '' : 'readonly'} required></td>
                                                    <td><input type="text" class="form-control form-control-sm discrepancy" value="${item.discrepancy}" readonly></td>
                                                    <td><input type="text" class="form-control form-control-sm" name="reason" value="${item.reason}" ${isEditMode ? '' : 'readonly'}></td>
                                                        <c:if test="${isEditMode}">
                                                        <td><button type="button" class="btn btn-sm btn-link btn-remove-item"><i data-feather="trash-2"></i></button></td>
                                                            </c:if>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                    <c:if test="${isEditMode}">
                                        <button type="button" class="btn btn-outline-primary mt-2" id="addItemBtn">
                                            <i data-feather="plus" class="align-middle"></i> Add Product
                                        </button>
                                    </c:if>
                                </div>
                            </div>

                            <div class="mt-3 mb-3 text-center">
                                <c:if test="${isEditMode}">
                                    <button type="submit" class="btn btn-primary btn-lg" onclick="setFormAction('update')">Update Report</button>
                                </c:if>

                                <div class="mt-4">
                                    <h4>Actions</h4>

                                    <%-- Warehouse Manager or Admin Actions --%>
                                    <c:if test="${(isWarehouseManager || isAdmin) && viewAction == 'view'}">
                                        <c:if test="${report.status == 'Pending'}">
                                            <button type="button" class="btn btn-success me-2" data-bs-toggle="modal" data-bs-target="#approveModal">
                                                Approve Report
                                            </button>
                                            <button type="button" class="btn btn-danger me-2" data-bs-toggle="modal" data-bs-target="#rejectModal">
                                                Reject Report
                                            </button>
                                        </c:if>
                                        <c:if test="${report.status == 'Approved'}">
                                            <button type="button" class="btn btn-primary" onclick="submitCompleteForm()">Complete (Adjust Inventory)</button>
                                        </c:if>
                                    </c:if>

                                    <%-- Warehouse Staff Actions --%>
                                    <c:if test="${(isWarehouseStaff || isWarehouseManager) && viewAction == 'view'}">
                                        <c:if test="${report.status == 'Draft' && currentUser.userId == report.createdBy}">
                                            <a href="${pageContext.request.contextPath}/staff/manage-stock-check-report?action=edit&reportId=${report.reportId}" class="btn btn-warning me-2">
                                                Edit
                                            </a>
                                            <button type="button" class="btn btn-danger" onclick="submitDeleteForm()">Delete Report</button>
                                        </c:if>
                                    </c:if>
                                </div>
                            </div>
                        </form> <%-- End of main form --%>

                        <%-- Separate forms for actions that are not part of the main update form --%>
                        <c:if test="${(isWarehouseManager || isAdmin) && report.status == 'Approved' && viewAction == 'view'}">
                            <form id="completeForm" action="${pageContext.request.contextPath}/manager/manage-stock-check-report" method="POST" style="display:none;">
                                <input type="hidden" name="reportId" value="${report.reportId}">
                                <input type="hidden" name="formAction" value="complete">
                            </form>
                        </c:if>
                        <c:if test="${isWarehouseStaff && report.status == 'Draft' && viewAction == 'view'}">
                            <form id="deleteForm" action="${pageContext.request.contextPath}/manager/manage-stock-check-report" method="POST" style="display:none;">
                                <input type="hidden" name="reportId" value="${report.reportId}">
                                <input type="hidden" name="formAction" value="delete">
                            </form>
                        </c:if>


                        <%-- Modals for Approve/Reject (Defined ONCE) --%>
                        <c:if test="${(isWarehouseManager || isAdmin) && report.status == 'Pending' && viewAction == 'view'}">
                            <!-- Approve Modal -->
                            <div class="modal fade" id="approveModal" tabindex="-1" aria-labelledby="approveModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <form action="${pageContext.request.contextPath}/manager/manage-stock-check-report" method="POST">
                                            <input type="hidden" name="reportId" value="${report.reportId}">
                                            <input type="hidden" name="formAction" value="approve">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="approveModalLabel">Approve Stock Check Report: ${report.reportCode}</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <div class="mb-3">
                                                    <label for="managerNotes_approve" class="form-label">Manager Notes (Optional)</label>
                                                    <textarea class="form-control" id="managerNotes_approve" name="managerNotes_approve" rows="3"></textarea>
                                                </div>
                                                <p>Are you sure you want to approve this stock check report?</p>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                <button type="submit" class="btn btn-success">Approve</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <!-- Reject Modal -->
                            <div class="modal fade" id="rejectModal" tabindex="-1" aria-labelledby="rejectModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <form action="${pageContext.request.contextPath}/manager/manage-stock-check-report" method="POST">
                                            <input type="hidden" name="reportId" value="${report.reportId}">
                                            <input type="hidden" name="formAction" value="reject">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="rejectModalLabel">Reject Stock Check Report: ${report.reportCode}</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <div class="mb-3">
                                                    <label for="managerNotes_reject" class="form-label">Reason for Rejection <span class="text-danger">*</span></label>
                                                    <textarea class="form-control" id="managerNotes_reject" name="managerNotes_reject" rows="3" required></textarea>
                                                </div>
                                                <p>Are you sure you want to reject this stock check report?</p>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                <button type="submit" class="btn btn-danger">Reject</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </main>
                <jsp:include page="/manager/footer.jsp" />
            </div>
        </div>
        <script src="${pageContext.request.contextPath}/manager/js/app.js"></script>
        <script>
            // Đưa giá trị JSTL sang JS đúng cách, đảm bảo là true/false hợp lệ
            let isEditMode = ${isEditMode ? 'true' : 'false'};
                                                function setFormAction(action) {
                                                    document.getElementById('formActionInput').value = action;
                                                }

                                                function submitCompleteForm() {
                                                    if (confirm('Are you sure you want to complete this report? This action will adjust inventory.')) {
                                                        document.getElementById('completeForm').submit();
                                                    }
                                                }
                                                function submitDeleteForm() {
                                                    if (confirm('Are you sure you want to delete this stock check report? This action cannot be undone.')) {
                                                        document.getElementById('deleteForm').submit();
                                                    }
                                                }

                                                document.addEventListener('DOMContentLoaded', function () {
                                                    feather.replace();

                                                    const tableBody = document.getElementById('itemsTableBody');
                                                    const addItemBtn = document.getElementById('addItemBtn');
                                                    const productOptionsHtml = generateProductOptions();

                                                    function generateProductOptions() {
                                                        let options = '<option value="">Select product...</option>';
            <c:forEach var="product" items="${products}">
                                                        options += `<option value="${product.productId}" data-qty="${product.quantity}">${product.productName} (${product.productCode})</option>`;
            </c:forEach>
                                                        return options;
                                                    }

                                                    function updateSystemQty(row) {
                                                        const select = row.querySelector('.product-select');
                                                        const sysQtyInput = row.querySelector('.system-quantity');
                                                        const selected = select.options[select.selectedIndex];
                                                        sysQtyInput.value = selected ? (selected.getAttribute('data-qty') || 0) : 0;
                                                        calculateDiscrepancy(row);
                                                    }

                                                    function calculateDiscrepancy(row) {
                                                        const sysQty = parseInt(row.querySelector('.system-quantity').value) || 0;
                                                        const countedQty = parseInt(row.querySelector('.counted-quantity').value) || 0;
                                                        row.querySelector('.discrepancy').value = countedQty - sysQty;
                                                    }

                                                    function addRowListeners(row) {
                                                        row.querySelector('.product-select').addEventListener('change', function () {
                                                            updateSystemQty(row);
                                                        });
                                                        row.querySelector('.counted-quantity').addEventListener('input', function () {
                                                            calculateDiscrepancy(row);
                                                        });
                                                        row.querySelector('.btn-remove-item').addEventListener('click', function () {
                                                            if (tableBody.querySelectorAll('.item-row').length > 1) {
                                                                row.remove();
                                                            }
                                                        });
                                                        feather.replace();
                                                    }

                                                    if (addItemBtn) {
                                                        addItemBtn.addEventListener('click', function () {
                                                            const firstRow = tableBody.querySelector('.item-row');
                                                            const newRow = firstRow.cloneNode(true);
                                                            newRow.querySelector('.product-select').selectedIndex = 0;
                                                            newRow.querySelector('.system-quantity').value = 0;
                                                            newRow.querySelector('.counted-quantity').value = '';
                                                            newRow.querySelector('.discrepancy').value = 0;
                                                            newRow.querySelector('input[name="reason"]').value = '';
                                                            tableBody.appendChild(newRow);
                                                            addRowListeners(newRow);
                                                        });
                                                    }
                                                    tableBody.querySelectorAll('.item-row').forEach(addRowListeners);

                                                    // Form validation for update
                                                    const form = document.getElementById('manageStockCheckForm');
                                                    form.addEventListener('submit', function (event) {
                                                        const currentAction = document.getElementById('formActionInput').value;
                                                        if (currentAction === 'update') {
                                                            let isValid = true;
                                                            if (tableBody.rows.length === 0) {
                                                                alert("Please add at least one product to the stock check report.");
                                                                isValid = false;
                                                            }
                                                            Array.from(tableBody.rows).forEach(row => {
                                                                const productSelect = row.querySelector('select[name="productId"]');
                                                                const systemQtyInput = row.querySelector('input[name="systemQuantity"]');
                                                                const countedQtyInput = row.querySelector('input[name="countedQuantity"]');

                                                                if (!productSelect.value) {
                                                                    alert("Please select a product for all rows.");
                                                                    productSelect.focus();
                                                                    isValid = false;
                                                                    return;
                                                                }
                                                                if (systemQtyInput.value === "" || parseInt(systemQtyInput.value) < 0) {
                                                                    alert("Invalid system quantity.");
                                                                    systemQtyInput.focus();
                                                                    isValid = false;
                                                                    return;
                                                                }
                                                                if (countedQtyInput.value === "" || parseInt(countedQtyInput.value) < 0) {
                                                                    alert("Invalid actual quantity.");
                                                                    countedQtyInput.focus();
                                                                    isValid = false;
                                                                    return;
                                                                }
                                                            });
                                                            if (!isValid) {
                                                                event.preventDefault();
                                                            }
                                                        }
                                                    });

                                                    // Auto-dismiss alerts
                                                    const successAlert = document.querySelector('.alert-success');
                                                    if (successAlert) {
                                                        setTimeout(() => {
                                                            new bootstrap.Alert(successAlert).close();
                                                        }, 5000);
                                                    }
                                                    const errorAlert = document.querySelector('.alert-danger');
                                                    if (errorAlert) {
                                                        setTimeout(() => {
                                                            new bootstrap.Alert(errorAlert).close();
                                                        }, 7000);
                                                    }

                                                    // Show reject modal if parameter is present (e.g., after server-side validation fail for reject notes)
                                                    const urlParams = new URLSearchParams(window.location.search);
                                                    if (urlParams.get('showRejectModal') === 'true') {
                                                        var rejectModalElement = document.getElementById('rejectModal');
                                                        if (rejectModalElement) {
                                                            var rejectModal = new bootstrap.Modal(rejectModalElement);
                                                            rejectModal.show();
                                                        }
                                                    }
                                                });
        </script>
    </body>
</html>