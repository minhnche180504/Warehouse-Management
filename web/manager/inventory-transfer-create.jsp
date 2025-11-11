<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List,model.Product,model.WarehouseDisplay,model.ImportRequest,model.ImportRequestDetail,java.text.SimpleDateFormat" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Responsive Admin &amp; Dashboard Template based on Bootstrap 5">
        <meta name="author" content="AdminKit">
        <meta name="keywords" content="adminkit, bootstrap, bootstrap 5, admin, dashboard, template, responsive, css, sass, html, theme, front-end, ui kit, web">
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link rel="shortcut icon" href="img/icons/icon-48x48.png" />
        <link rel="canonical" href="forms-layouts.html" />
        <title>Create Inventory Transfer | Warehouse System</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet" />
        <style>
            .select2-container--bootstrap-5 .select2-selection {
                border: 1px solid #ced4da;
                padding: 0.375rem 0.75rem;
                font-size: 1rem;
                border-radius: 0.25rem;
            }
            .select2-container--bootstrap-5 .select2-search--dropdown .select2-search__field {
                padding: 8px;
                border-radius: 4px;
                border: 1px solid #ced4da;
            }
            .select2-container--bootstrap-5 .select2-selection--single .select2-selection__rendered {
                padding-left: 0;
            }
            .select2-container--bootstrap-5 .select2-dropdown {
                border-color: #ced4da;
                box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            }
            .select2-container--bootstrap-5 .select2-results__option--highlighted[aria-selected] {
                background-color: #007bff;
            }
        </style>
        <script src="js/settings.js"></script>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <jsp:include page="/manager/ManagerSidebar.jsp" />
            <div class="main">
                <jsp:include page="/manager/navbar.jsp" />
                <main class="content">
                    <div class="container-fluid p-0">
                        <h1 class="h3 mb-3">Create Inventory Transfer</h1>
                        <div class="row">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title">Inventory Transfer Information</h5>
                                    </div>
                                    <div class="card-body">
                                        <c:if test="${not empty errorMessage}">
                                            <div class="alert alert-danger alert-dismissible" role="alert">
                                                <div class="alert-message">
                                                    ${errorMessage}
                                                </div>
                                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            </div>
                                        </c:if>

                                        <form method="post" action="create-inventory-transfer" id="transferForm">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label for="sourceWarehouseId" class="form-label">Source Warehouse *</label>
                                                        <select class="form-select" id="sourceWarehouseId" name="sourceWarehouseId" required>
                                                            <option value="">Select source warehouse</option>
                                                            <c:forEach var="warehouse" items="${warehouses}">
                                                                <option value="${warehouse.warehouseId}">${warehouse.warehouseName}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label for="destinationWarehouseId" class="form-label">Destination Warehouse *</label>
                                                        <!-- Destination is always current user's warehouse -->
                                                        <input type="text" class="form-control" 
                                                               value="${currentUserWarehouseName}" disabled readonly>
                                                        <input type="hidden" name="destinationWarehouseId" value="${currentUserWarehouseId}">
                                                        <small class="form-text text-muted">Items will be transferred to your warehouse</small>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="mb-3">
                                                <label for="description" class="form-label">Description</label>
                                                <textarea class="form-control" id="description" name="description" rows="3" placeholder="Enter transfer description..."></textarea>
                                            </div>

                                            <div class="mb-3">
                                                <label for="importRequestId" class="form-label">Reference Document ID</label>
                                                <select class="form-select" id="importRequestId" name="importRequestId" onchange="loadImportRequestItems(this.value)">
                                                    <option value="">-- Select Import Request --</option>
                                                    <c:forEach var="importRequest" items="${approvedImportRequests}">
                                                        <option value="${importRequest.requestId}">
                                                            IR-${importRequest.requestId} - ${importRequest.createdByName} 
                                                            (<fmt:formatDate value="${importRequest.requestDate}" pattern="dd/MM/yyyy" />)
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                                <small class="form-text text-muted">Select an import request to automatically populate items below</small>
                                            </div>

                                            <hr>

                                            <div class="d-flex justify-content-between align-items-center mb-3">
                                                <h5>Transfer Items</h5>
                                                <button type="button" class="btn btn-primary btn-sm" onclick="addItem()">
                                                    <i data-feather="plus"></i> Add Item
                                                </button>
                                            </div>

                                            <div class="table-responsive">
                                                <table class="table table-bordered" id="itemsTable" style="max-width: 2000px; margin: 0 auto;">
                                                    <thead>
                                                        <tr>
                                                            <th style="width: 50%">Product</th>
                                                            <th style="width: 30%">Quantity</th>
                                                            <th style="width: 60px">Action</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="itemsTableBody">
                                                        <!-- Items will be added dynamically -->
                                                    </tbody>
                                                </table>
                                            </div>

                                            <div class="row mt-4">
                                                <div class="col-12">
                                                    <div class="d-flex justify-content-between">
                                                        <a href="list-inventory-transfer" class="btn btn-secondary">
                                                            <i data-feather="arrow-left"></i> Back to List
                                                        </a>
                                                        <div>
                                                            <button type="submit" name="action" value="saveDraft" class="btn btn-warning me-2">
                                                                <i data-feather="save"></i> Save Draft
                                                            </button>
                                                            <button type="submit" name="action" value="create" class="btn btn-success">
                                                                <i data-feather="check"></i> Create Transfer
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                <jsp:include page="/manager/footer.jsp" />
            </div>
        </div>

        <script src="js/app.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

        <script>
            $(document).ready(function() {
                // Initialize Select2
                $('.form-select').select2({
                    theme: 'bootstrap-5'
                });

                // Add first item row on page load
                addItem();

                // Form validation
                $('#transferForm').on('submit', function(e) {
                    const items = $('#itemsTableBody tr');
                    if (items.length === 0) {
                        e.preventDefault();
                        alert('Please add at least one item to the transfer.');
                        return false;
                    }

                    // Check if source and destination are the same
                    const sourceId = $('#sourceWarehouseId').val();
                    const destId = $('input[name="destinationWarehouseId"]').val();
                    if (sourceId === destId && sourceId !== '') {
                        e.preventDefault();
                        alert('Source and destination warehouses cannot be the same.');
                        return false;
                    }

                    return true;
                });
            });

            let itemIndex = 0;

            function addItem() {
                const products = [
                    <c:forEach var="product" items="${products}" varStatus="status">
                        {id: '${product.productId}', name: '${product.name}', code: '${product.code}'}${!status.last ? ',' : ''}
                    </c:forEach>
                ];

                const row = `
                    <tr id="item-row-` + itemIndex + `">
                        <td>
                            <select class="form-select product-select" name="productId" required>
                                <option value="">Select product</option>
                                ` + products.map(p => `<option value="` + p.id + `">` + p.name + ` (` + p.code + `)</option>`).join('') + `
                            </select>
                        </td>
                        <td>
                            <input type="number" class="form-control" name="quantity" min="1" required>
                        </td>
                        <td>
                            <button type="button" class="btn btn-danger btn-sm" onclick="removeItem(` + itemIndex + `)">
                                <i data-feather="trash-2"></i>
                            </button>
                        </td>
                    </tr>
                `;

                $('#itemsTableBody').append(row);
                
                // Initialize Select2 for the new product select
                $(`#item-row-` + itemIndex + ` .product-select`).select2({
                    theme: 'bootstrap-5'
                });

                // Re-initialize feather icons
                feather.replace();

                itemIndex++;
            }

            function removeItem(index) {
                $('#item-row-' + index).remove();
            }

            function loadImportRequestItems(importRequestId) {
                if (!importRequestId) {
                    // Clear existing items when no import request is selected
                    $('#itemsTableBody').empty();
                    addItem();
                    return;
                }

                // Make AJAX call to get import request details
                $.ajax({
                    url: '<c:url value="/get-import-request-details"/>',
                    type: 'GET',
                    data: { requestId: importRequestId },
                    dataType: 'json',
                    success: function(response) {
                        if (response.success && response.details) {
                            // Clear existing items
                            $('#itemsTableBody').empty();
                            
                            // Add items from import request
                            response.details.forEach(function(detail) {
                                addItemFromImportRequest(detail);
                            });
                        } else {
                            alert('Error loading import request details: ' + (response.message || 'Unknown error'));
                        }
                    },
                    error: function() {
                        alert('Error loading import request details. Please try again.');
                    }
                });
            }

            function addItemFromImportRequest(detail) {
                const products = [
                    <c:forEach var="product" items="${products}" varStatus="status">
                        {id: '${product.productId}', name: '${product.name}', code: '${product.code}'}${!status.last ? ',' : ''}
                    </c:forEach>
                ];

                const row = `
                    <tr id="item-row-` + itemIndex + `">
                        <td>
                            <select class="form-select product-select" name="productId" required>
                                <option value="">Select product</option>
                                ` + products.map(p => `<option value="` + p.id + `" ` + (p.id == detail.productId ? 'selected' : '') + `>` + p.name + ` (` + p.code + `)</option>`).join('') + `
                            </select>
                        </td>
                        <td>
                            <input type="number" class="form-control" name="quantity" min="1" value="` + detail.quantity + `" required>
                        </td>
                        <td>
                            <button type="button" class="btn btn-danger btn-sm" onclick="removeItem(` + itemIndex + `)">
                                <i data-feather="trash-2"></i> Remove
                            </button>
                        </td>
                    </tr>
                `;

                $('#itemsTableBody').append(row);
                
                // Initialize Select2 for the new product select
                $(`#item-row-` + itemIndex + ` .product-select`).select2({
                    theme: 'bootstrap-5'
                });

                // Re-initialize feather icons
                feather.replace();

                itemIndex++;
            }
        </script>
    </body>
</html>
