<%-- 
    Document   : importRequest-edit
    Created on : Jun 12, 2025, 1:49:19 PM
    Author     : nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <title>Edit Import Request</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
        <script src="js/settings.js"></script>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <jsp:include page="/sale/SalesSidebar.jsp" />
            <div class="main">
                <jsp:include page="/sale/navbar.jsp" />
                <main class="content">
                    <div class="container-fluid p-0">
                        <div class="row mb-3">
                            <div class="col-6">
                                <h1 class="h2 mb-3 fw-bold text-primary">Edit Import Request</h1>
                            </div>
                            <div class="col-6 text-end">
                                <a href="importRequestList" class="btn btn-secondary me-2">
                                    <i class="align-middle" data-feather="arrow-left"></i> Back to List
                                </a>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-12">
                                <div class="card shadow-sm">
                                    <div class="card-header pb-0 border-bottom-0">
                                        <h5 class="card-title mb-0 fw-semibold">Import Request Information</h5>
                                        <hr class="mt-2 mb-0">
                                    </div>
                                    <div class="card-body pt-3">
                                        <form action="${pageContext.request.contextPath}/sale/importRequestEdit" method="POST" id="editForm">
                                            <input type="hidden" name="requestId" value="${importRequest.requestId}">
                                            
                                            <!-- Request Date and Creator Information -->
                                            <div class="row mb-3 align-items-center">
                                                <div class="col-md-6">
                                                    <label class="form-label fw-medium">Request Date</label>
                                                    <input type="text" class="form-control form-control-lg" 
                                                           value="<fmt:formatDate value='${importRequest.requestDate}' pattern='yyyy-MM-dd'/>" readonly>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label fw-medium">Created By</label>
                                                    <input type="text" class="form-control form-control-lg" 
                                                           value="${importRequest.createdByName}" readonly>
                                                </div>
                                                <div class="col-md-6 mt-3">
                                                    <label class="form-label fw-medium">Warehouse</label>
                                                    <input type="text" class="form-control form-control-lg" value="${warehouseName}" readonly>
                                                </div>
                                            </div>

                                            <!-- Product Items Table -->
                                            <div class="card mt-4 mb-3">
                                                <div class="card-header">
                                                    <h5 class="mb-0">Items</h5>
                                                </div>
                                                <div class="card-body">
                                                    <div class="table-responsive">
                                                        <table class="table table-bordered" id="productItemsTable">
                                                            <thead>
                                                                <tr>
                                                                    <th style="width: 40%">Product</th>
                                                                    <th>Quantity</th>
                                                                    <th style="width: 80px">Actions</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody id="productItemsBody">
                                                                <c:forEach items="${importRequest.details}" var="detail" varStatus="status">
                                                                    <tr class="product-row">
                                                                        <td>
                                                                            <select class="form-select product-select" name="productIds[]" required>
                                                                                <option value="">-- Select Product --</option>
                                                                                <c:forEach items="${products}" var="product">
                                                                                    <option value="${product.productId}" 
                                                                                            ${product.productId == detail.productId ? 'selected' : ''}>
                                                                                        ${product.name} (${product.code})
                                                                                    </option>
                                                                                </c:forEach>
                                                                            </select>
                                                                        </td>
                                                                        <td>
                                                                            <input type="number" class="form-control quantity-input" 
                                                                                   name="quantities[]" min="1" value="${detail.quantity}" required>
                                                                        </td>
                                                                        <td class="text-center">
                                                                            <button type="button" class="btn btn-sm btn-outline-danger remove-product" 
                                                                                    ${status.first ? 'style=display:none' : ''}>
                                                                                <i data-feather="trash-2"></i>
                                                                            </button>
                                                                        </td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                        <div class="mt-3">
                                                            <button type="button" class="btn btn-primary" id="addProductBtn">
                                                                <i data-feather="plus"></i> Add Product
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Reason Section -->
                                            <div class="card mt-4 mb-3">
                                                <div class="card-header">
                                                    <h5 class="mb-0">Reason</h5>
                                                </div>
                                                <div class="card-body">
                                                    <div class="table-responsive">
                                                        <table class="table table-bordered">
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <textarea class="form-control" id="reason" name="reason" rows="4" 
                                                                                  required>${importRequest.reason}</textarea>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Form Actions -->
                                            <div class="row mt-4">
                                                <div class="col-12 text-end">
                                                    <button type="button" class="btn btn-secondary btn-lg me-2" onclick="window.location.href='importRequestList'">
                                                        Cancel
                                                    </button>
                                                    <button type="submit" class="btn btn-primary btn-lg px-4">
                                                        <i class="align-middle me-1" data-feather="save"></i> Save Changes
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                
                <footer class="footer">
                    <div class="container-fluid">
                        <div class="row text-muted">
                            <div class="col-6 text-start">
                                <p class="mb-0">
                                    <a class="text-muted" href="#" target="_blank"><strong>Warehouse Management System</strong></a> &copy;
                                </p>
                            </div>
                            <div class="col-6 text-end">
                                <ul class="list-inline">
                                    <li class="list-inline-item">
                                        <a class="text-muted" href="#">Support</a>
                                    </li>
                                    <li class="list-inline-item">
                                        <a class="text-muted" href="#">Help Center</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </footer>
            </div>
        </div>

        <script src="js/app.js"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                // Initialize feather icons
                feather.replace();
                
                // Create new product row
                function createProductRow() {
                    const template = document.querySelector('.product-row').cloneNode(true);
                    template.querySelector('.remove-product').style.display = 'block';
                    template.querySelector('.product-select').value = '';
                    template.querySelector('.quantity-input').value = '1';
                    return template;
                }

                // Add new product button click handler
                document.getElementById('addProductBtn').addEventListener('click', function() {
                    const tbody = document.getElementById('productItemsBody');
                    const newRow = createProductRow();
                    tbody.appendChild(newRow);
                    feather.replace();
                });

                // Remove product button click handler
                document.addEventListener('click', function(e) {
                    if (e.target.closest('.remove-product')) {
                        const row = e.target.closest('.product-row');
                        if (document.querySelectorAll('.product-row').length > 1) {
                            row.remove();
                        }
                    }
                });

                // Form validation
                document.getElementById('editForm').addEventListener('submit', function(e) {
                    const rows = document.querySelectorAll('.product-row');
                    let isValid = true;

                    rows.forEach(row => {
                        const productSelect = row.querySelector('.product-select');
                        const quantity = row.querySelector('.quantity-input');

                        if (!productSelect.value) {
                            e.preventDefault();
                            alert('Please select a product for all items');
                            isValid = false;
                            return;
                        }

                        if (!quantity.value || parseInt(quantity.value) <= 0) {
                            e.preventDefault();
                            alert('Quantity must be greater than 0 for all items');
                            isValid = false;
                            return;
                        }
                    });

                    if (!isValid) {
                        e.preventDefault();
                    }
                });
            });
        </script>
    </body>
</html>
