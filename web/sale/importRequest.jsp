<%-- 
    Document   : importRequest
    Created on : Jun 12, 2025, 12:27:53 AM
    Author     : nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Product, dao.ProductDAO, java.util.List, java.text.SimpleDateFormat, java.util.Date" %>
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
        <title>Create Import Request | Warehouse System</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
        <script src="js/settings.js"></script>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <jsp:include page="/sale/SalesSidebar.jsp"/>
            <div class="main">
                <jsp:include page="/sale/navbar.jsp"/>
                <main class="content">
                    <div class="container-fluid p-0">
                        <%-- Success message --%>
                        <%
                            String successMessage = (String) request.getAttribute("successMessage");
                            if (successMessage != null && !successMessage.isEmpty()) {
                        %>
                        <div class="alert alert-success alert-dismissible" role="alert">
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            <div class="alert-message">
                                <%= successMessage %>
                            </div>
                        </div>
                        <% } %>

                        <%-- Error message --%>
                        <%
                            String errorMessage = (String) request.getAttribute("errorMessage");
                            if (errorMessage != null && !errorMessage.isEmpty()) {
                        %>
                        <div class="alert alert-danger alert-dismissible" role="alert">
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            <div class="alert-message">
                                <%= errorMessage %>
                            </div>
                        </div>
                        <% } %>
                        
                        <div class="row mb-3">
                            <div class="col-6">
                                <h1 class="h2 mb-3 fw-bold text-primary">Create Import Request</h1>
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
                                        <!-- Main Form -->
                                        <form action="requestImport" method="post" id="importRequestForm">
                                            <!-- ===== REQUEST INFORMATION ===== -->
                                            <!-- Request Date and Creator Information -->
                                            <div class="row mb-3 align-items-center">
                                                <!-- Request Date Field -->
                                                <div class="col-md-6">
                                                    <label for="requestDate" class="form-label fw-medium">Request Date *</label>
                                                    <input type="date" class="form-control form-control-lg" id="requestDate" name="requestDate"
                                                           value="<%= request.getAttribute("requestDate") != null ? request.getAttribute("requestDate") : "" %>" disabled>
                                                    <input type="hidden" name="requestDate" value="<%= request.getAttribute("requestDate") != null ? request.getAttribute("requestDate") : "" %>">
                                                </div>
                                                <!-- Creator Name Field -->
                                                <div class="col-md-6">
                                                    <label for="creatorName" class="form-label fw-medium">Created By</label>
                                                    <input type="text" class="form-control form-control-lg" id="creatorName" name="creatorName"
                                                           value="<%= request.getAttribute("creatorName") != null ? request.getAttribute("creatorName") : "" %>" readonly>
                                                </div>
                                                <!-- Warehouse Name Field -->
                                                <div class="col-md-6 mt-3">
                                                    <label for="warehouseName" class="form-label fw-medium">Warehouse</label>
                                                    <input type="text" class="form-control form-control-lg" id="warehouseName" name="warehouseName"
                                                           value="<%= request.getAttribute("warehouseName") != null ? request.getAttribute("warehouseName") : "" %>" readonly>
                                                </div>
                                            </div>

                                            <!-- ===== PRODUCT ITEMS ===== -->
                                            <!-- Product Items Table Card -->
                                            <div class="card mt-4 mb-3">
                                                <!-- Card Header with Title -->
                                                <div class="card-header">
                                                    <h5 class="mb-0">Items</h5>
                                                </div>
                                                <!-- Card Body with Table -->
                                                <div class="card-body">
                                                    <div class="table-responsive">
                                                        <!-- Product Items Table -->
                                                        <table class="table table-bordered" id="productItemsTable">
                                                            <!-- Table Header -->
                                                            <thead>
                                                                <tr>
                                                                    <th style="width: 40%">Product</th>
                                                                    <th>Quantity</th>
                                                                    <th style="width: 80px">Actions</th>
                                                                </tr>
                                                            </thead>
                                                            <!-- Table Body -->
                                                            <tbody id="productItemsBody">
                                                                <!-- Default Product Row -->
                                                                <tr class="product-row">
                                                                    <!-- Product Selection Column -->
                                                                    <td>
                                                                        <select class="form-select product-select" name="productIds[]" required>
                                                                            <option value="">-- Select Product --</option>
                                                                            <% 
                                                                                // Get product list from request attribute
                                                                                List<Product> products = (List<Product>)request.getAttribute("products");
                                                                                if (products != null) {
                                                                                    for (Product product : products) {
                                                                            %>
                                                                            <option value="<%= product.getProductId() %>">
                                                                                <%= product.getName()%> (<%= product.getCode()%>)
                                                                            </option>
                                                                            <% 
                                                                                    }
                                                                                }
                                                                            %>
                                                                        </select>
                                                                    </td>
                                                                    <!-- Quantity Input Column -->
                                                                    <td>
                                                                        <input type="number" class="form-control quantity-input" name="quantities[]" min="1" value="1" required>
                                                                    </td>
                                                                    <!-- Action Buttons Column -->
                                                                    <td class="text-center">
                                                                        <button type="button" class="btn btn-sm btn-outline-danger remove-product" style="display: none;">
                                                                            <i data-feather="trash-2"></i>
                                                                        </button>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                        <!-- Add Product Button -->
                                                        <div class="mt-3">
                                                            <button type="button" class="btn btn-primary" id="addProductBtn">
                                                                <i data-feather="plus"></i> Add Product
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- ===== REASON SECTION ===== -->
                                            <!-- Reason Card -->
                                            <div class="card mt-4 mb-3">
                                                <!-- Card Header with Title -->
                                                <div class="card-header">
                                                    <h5 class="mb-0">Reason</h5>
                                                </div>
                                                <!-- Card Body with Textarea -->
                                                <div class="card-body">
                                                    <div class="table-responsive">
                                                        <table class="table table-bordered">
                                                            <tbody>
                                                                <tr>
                                                                    <td>
                                                                        <textarea class="form-control" id="reason" name="reason" rows="4" 
                                                                                  placeholder="Enter reason for import request" required></textarea>
                                                                    </td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- ===== FORM ACTIONS ===== -->
                                            <!-- Submit and Cancel Buttons -->
                                            <div class="row mt-4">
                                                <div class="col-12 text-end">
                                                    <button type="button" class="btn btn-secondary btn-lg me-2" onclick="window.location.href='importRequestList'">
                                                        Cancel
                                                    </button>
                                                    <button type="submit" class="btn btn-success btn-lg px-4">
                                                        <i class="align-middle me-1" data-feather="plus-circle"></i> Submit Request
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
                
                // ===== PRODUCT ROW MANAGEMENT =====
                /**
                 * Creates a new product row by cloning the template
                 * @returns {HTMLElement} The cloned product row
                 */
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

                // ===== FORM VALIDATION =====
                /**
                 * Validates the form before submission
                 * Checks if all products are selected and quantities are valid
                 */
                document.getElementById('importRequestForm').addEventListener('submit', function(e) {
                    const rows = document.querySelectorAll('.product-row');
                    let isValid = true;

                    rows.forEach(row => {
                        const productSelect = row.querySelector('.product-select');
                        const quantity = row.querySelector('.quantity-input');

                        // Validate product selection
                        if (!productSelect.value) {
                            e.preventDefault();
                            alert('Please select a product for all items');
                            isValid = false;
                            return;
                        }

                        // Validate quantity
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
