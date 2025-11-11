<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Create Stock Check Report</title>
    <link class="js-stylesheet" href="${pageContext.request.contextPath}/manager/css/light.css" rel="stylesheet">
    <style>
        .table-items th, .table-items td { vertical-align: middle; }
        .table-items .form-control-sm { padding: 0.25rem 0.5rem; font-size: 0.875rem; }
        .btn-remove-item { color: #dc3545; }
        .btn-remove-item:hover { color: #a71d2a; }
    </style>
</head>
<body>
<div class="wrapper">
    <jsp:include page="/manager/ManagerSidebar.jsp"/>
    <div class="main">
        <jsp:include page="/manager/navbar.jsp" />
        <main class="content">
            <div class="container-fluid p-0">
                <div class="mb-3">
                    <h1 class="h3 d-inline align-middle">Create New Stock Check Report</h1>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible" role="alert">
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        <div class="alert-message">
                            <strong>Error:</strong> ${errorMessage}
                        </div>
                    </div>
                </c:if>
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible" role="alert">
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        <div class="alert-message">
                            ${successMessage}
                        </div>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/manager/create-stock-check-report" method="POST" id="stockCheckForm">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">General Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label for="reportCode" class="form-label">Report Code <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="reportCode" name="reportCode" value="${reportCode}" readonly>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Warehouse <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" value="${warehouse.warehouseName}" readonly>
                                    <input type="hidden" name="warehouseId" value="${warehouse.warehouseId}">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="reportDate" class="form-label">Report Date <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="reportDate" name="reportDate" value="${reportDate}" readonly>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="notes" class="form-label">Notes</label>
                                <textarea class="form-control" id="notes" name="notes" rows="3" placeholder="Add any relevant notes here...">${submittedNotes}</textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Created By:</label>
                                <input type="text" class="form-control" value="${currentUser.firstName} ${currentUser.lastName}" readonly>
                                <input type="hidden" name="createdById" value="${currentUser.userId}" />
                            </div>
                        </div>
                    </div>

                    <!-- Product Items Section -->
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="card-title mb-0">Product Details</h5>
                            <button type="button" class="btn btn-sm btn-primary" id="addRowBtn">
                                <i class="align-middle" data-feather="plus"></i> Add Row
                            </button>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover table-items" id="stockItemsTable">
                                    <thead>
                                    <tr>
                                        <th style="width: 35%;">Product <span class="text-danger">*</span></th>
                                        <th style="width: 15%;">System Quantity <span class="text-danger">*</span></th>
                                        <th style="width: 15%;">Counted Quantity <span class="text-danger">*</span></th>
                                        <th style="width: 10%;">Discrepancy</th>
                                        <th style="width: 20%;">Reason</th>
                                        <th style="width: 5%;"></th>
                                    </tr>
                                    </thead>
                                    <tbody id="stockItemsBody">
                                    <tr class="item-row">
                                        <td>
                                            <select class="form-select form-control-sm product-select" name="productId" required>
                                                <option value="">Select Product...</option>
                                                <c:forEach var="item" items="${products}">
                                                    <option value="${item.productId}" data-qty="${item.quantity}">
                                                        ${item.productName} (${item.productCode})
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td>
                                            <input type="number" class="form-control form-control-sm system-quantity" name="systemQuantity" value="0" readonly>
                                        </td>
                                        <td>
                                            <input type="number" class="form-control form-control-sm counted-quantity" name="countedQuantity" min="0" required>
                                        </td>
                                        <td>
                                            <input type="text" class="form-control form-control-sm discrepancy" readonly value="0">
                                        </td>
                                        <td>
                                            <input type="text" class="form-control form-control-sm" name="reason">
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-sm btn-link btn-remove-item" title="Remove item">
                                                <i data-feather="trash-2"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Submit Buttons -->
                    <div class="text-center mt-3">
                        <button type="submit" name="action" value="saveReport" class="btn btn-primary btn-lg">Save Report</button>
                        <button type="submit" name="action" value="saveDraft" class="btn btn-secondary btn-lg">Save Draft</button>
                        <a href="${pageContext.request.contextPath}/manager/list-stock-check-reports" class="btn btn-secondary btn-lg">Cancel</a>
                    </div>
                </form>
            </div>
        </main>
        <jsp:include page="/manager/footer.jsp" />
    </div>
</div>

<script src="${pageContext.request.contextPath}/manager/js/app.js"></script>
<script>
document.addEventListener("DOMContentLoaded", function () {
    const stockItemsBody = document.getElementById('stockItemsBody');
    const addRowBtn = document.getElementById('addRowBtn');

    function updateSystemQty(row) {
        const select = row.querySelector('.product-select');
        const sysQtyInput = row.querySelector('.system-quantity');
        const selected = select.options[select.selectedIndex];
        sysQtyInput.value = selected ? (selected.getAttribute('data-qty') || 0) : 0;
        updateDiscrepancy(row);
    }

    function updateDiscrepancy(row) {
        const sysQty = parseInt(row.querySelector('.system-quantity').value) || 0;
        const countedQty = parseInt(row.querySelector('.counted-quantity').value) || 0;
        row.querySelector('.discrepancy').value = countedQty - sysQty;
    }

    function addRowListeners(row) {
        row.querySelector('.product-select').addEventListener('change', function () {
            updateSystemQty(row);
        });
        row.querySelector('.counted-quantity').addEventListener('input', function () {
            updateDiscrepancy(row);
        });
        row.querySelector('.btn-remove-item').addEventListener('click', function () {
            if (stockItemsBody.querySelectorAll('.item-row').length > 1) {
                row.remove();
            }
        });
        feather.replace();
    }

    addRowBtn.addEventListener('click', function () {
        const firstRow = stockItemsBody.querySelector('.item-row');
        const newRow = firstRow.cloneNode(true);
        // Reset values
        newRow.querySelector('.product-select').selectedIndex = 0;
        newRow.querySelector('.system-quantity').value = 0;
        newRow.querySelector('.counted-quantity').value = '';
        newRow.querySelector('.discrepancy').value = 0;
        newRow.querySelector('input[name="reason"]').value = '';
        stockItemsBody.appendChild(newRow);
        addRowListeners(newRow);
    });

    stockItemsBody.querySelectorAll('.item-row').forEach(addRowListeners);
});
</script>
</body>
</html>