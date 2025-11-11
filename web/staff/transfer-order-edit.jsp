<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List,model.Product,model.WarehouseDisplay,model.TransferOrder,model.TransferOrderItem" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <link rel="shortcut icon" href="<c:url value='/staff/img/icons/icon-48x48.png'/>" />
        <link rel="canonical" href="forms-layouts.html" />
        <title>${pageTitle} | Warehouse System</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="<c:url value='/staff/css/light.css'/>" rel="stylesheet">
        <!-- Select2 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet" />
        <!-- Custom Select2 Styles -->
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
        <script src="<c:url value='/staff/js/settings.js'/>"></script>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <jsp:include page="/staff/WsSidebar.jsp" />
            <div class="main">
                <jsp:include page="/staff/navbar.jsp" />
                <main class="content">
                    <div class="container-fluid p-0">
                        <%
                            // Get any error messages
                            String errorMessage = (String) request.getAttribute("errorMessage");
                            if (errorMessage != null && !errorMessage.isEmpty()) {
                        %>
                        <div class="alert alert-danger alert-dismissible" role="alert">
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            <div class="alert-message">
                                <%= errorMessage %>
                            </div>
                        </div>
                        <%
                            }
                            
                            // Get page title and description
                            String pageTitle = (String) request.getAttribute("pageTitle");
                            String pageDescription = (String) request.getAttribute("pageDescription");
                            if (pageTitle == null) pageTitle = "Edit Transfer Order";
                            if (pageDescription == null) pageDescription = "Update transfer order details";
                            
                            // Get transfer order from request
                            TransferOrder transferOrder = (TransferOrder) request.getAttribute("transferOrder");
                            if (transferOrder == null) {
                                response.sendRedirect("list-transfer-order");
                                return;
                            }
                            
                            String selectedType = transferOrder.getTransferType();
                            if (selectedType == null) selectedType = "transfer";
                        %>
                        
                        <div class="row mb-3">
                            <div class="col-6">
                                <h1 class="h2 mb-3 fw-bold text-primary"><%= pageTitle %></h1>
                                <p class="text-muted"><%= pageDescription %></p>
                            </div>
                            <div class="col-6 text-end">
                                <a href="list-transfer-order" class="btn btn-secondary me-2">
                                    <i class="align-middle" data-feather="arrow-left"></i> Back to List
                                </a>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-12">
                                <div class="card shadow-sm">
                                    <div class="card-header pb-0 border-bottom-0">
                                        <h5 class="card-title mb-0 fw-semibold">Transfer Order Details</h5>
                                        <hr class="mt-2 mb-0">
                                    </div>
                                    <div class="card-body pt-3">
                                        <form action="edit-transfer-order" method="post" id="transferOrderForm">
                                            <input type="hidden" name="transferOrderId" value="<%= transferOrder.getTransferId() %>">
                                            
                                            <!-- Basic Order Information -->
                                            <div class="row mb-3">
                                                <div class="col-md-4">
                                                    <label class="form-label fw-medium">Order Number</label>
                                                    <input type="text" class="form-control form-control-lg" value="<%= transferOrder.getTransferId() %>" readonly>
                                                </div>
                                                <div class="col-md-4">
                                                    <label class="form-label fw-medium">Status</label>
                                                    <input type="text" class="form-control form-control-lg" value="<%= transferOrder.getStatus() %>" readonly>
                                                </div>
                                                <div class="col-md-4">
                                                    <label class="form-label fw-medium">Created Date</label>
                                                    <input type="text" class="form-control form-control-lg" value="<%= transferOrder.getCreatedDate() %>" readonly>
                                                </div>
                                            </div>
                                              <!-- Transfer Type Selection -->
                                            <div class="row mb-4">
                                                <div class="col-12">
                                                    <div class="d-flex align-items-center mb-2">
                                                        <label class="form-label fw-medium mb-0 me-2">Transfer Type:</label>
                                                        <% if ("import".equals(selectedType)) { %>
                                                            <span class="badge bg-success p-2">Import Order</span>
                                                        <% } else if ("export".equals(selectedType)) { %>
                                                            <span class="badge bg-warning p-2">Export Order</span>
                                                        <% } else if ("transfer".equals(selectedType)) { %>
                                                            <span class="badge bg-info p-2">Warehouse Transfer</span>
                                                        <% } %>
                                                        <!-- Hidden input to store the transfer type value -->
                                                        <input type="hidden" name="transferType" value="<%= selectedType %>">
                                                    </div>
                                                    <small class="text-muted">
                                                        Transfer type is set during creation and cannot be changed.
                                                    </small>
                                                </div>
                                            </div>
                                            
                                            <!-- Warehouse Selection -->
                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <label for="sourceWarehouseId" class="form-label fw-medium">Source Warehouse *</label>
                                                    <select class="form-select form-select-lg" id="sourceWarehouseId" name="sourceWarehouseId" required>
                                                        <option value="">-- Select Source Warehouse --</option>
                                                        <% 
                                                            List<WarehouseDisplay> warehouses = (List<WarehouseDisplay>)request.getAttribute("warehouses");
                                                            if (warehouses != null) {
                                                                for (WarehouseDisplay warehouse : warehouses) {
                                                        %>
                                                        <option value="<%= warehouse.getWarehouseId() %>" <%= (transferOrder.getSourceWarehouseId() == warehouse.getWarehouseId()) ? "selected" : "" %>>
                                                            <%= warehouse.getWarehouseName() %>
                                                        </option>
                                                        <% 
                                                                }
                                                            }
                                                        %>
                                                    </select>
                                                </div>
                                                <div class="col-md-6" id="destinationWarehouseContainer">
                                                    <label for="destinationWarehouseId" class="form-label fw-medium">Destination Warehouse *</label>
                                                    <select class="form-select form-select-lg" id="destinationWarehouseId" name="destinationWarehouseId">
                                                        <option value="">-- Select Destination Warehouse --</option>
                                                        <% 
                                                            if (warehouses != null) {
                                                                for (WarehouseDisplay warehouse : warehouses) {
                                                        %>
                                                        <option value="<%= warehouse.getWarehouseId() %>" <%= (transferOrder.getDestinationWarehouseId() != null && transferOrder.getDestinationWarehouseId() == warehouse.getWarehouseId()) ? "selected" : "" %>>
                                                            <%= warehouse.getWarehouseName() %>
                                                        </option>
                                                        <% 
                                                                }
                                                            }
                                                        %>
                                                    </select>
                                                </div>
                                            </div>
                                            
                                            <!-- Document Reference and Description -->
                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <label for="documentRefId" class="form-label fw-medium">Reference Document ID *</label>
                                                    <% 
                                                        String displayValue = "";
                                                        if (transferOrder.getDocumentRefId() != null) {
                                                            if (transferOrder.getDocumentRefType() != null) {
                                                                displayValue = transferOrder.getDocumentRefType() + "-" + transferOrder.getDocumentRefId();
                                                            } else {
                                                                displayValue = String.valueOf(transferOrder.getDocumentRefId());
                                                            }
                                                        }
                                                    %>
                                                    <input type="text" class="form-control form-control-lg" id="documentRefId" name="documentRefId" 
                                                           value="<%= displayValue %>" 
                                                           placeholder="e.g., SO-123, PO-456, IT-789" required>
                                                    <% if (transferOrder.getDocumentRefType() != null) { %>
                                                        <small class="text-muted">Current type: <%= transferOrder.getDocumentRefType() %> (type will be preserved)</small>
                                                    <% } %>
                                                </div>
                                                <div class="col-md-6">
                                                    <label for="description" class="form-label fw-medium">Description</label>
                                                    <textarea class="form-control" id="description" name="description" rows="2" 
                                                              placeholder="Transfer order description"><%= transferOrder.getDescription() != null ? transferOrder.getDescription() : "" %></textarea>
                                                </div>
                                            </div>
                                            
                                            <!-- Product Items Section -->
                                            <div class="card mt-4 mb-3">
                                                <div class="card-header d-flex justify-content-between align-items-center">
                                                    <h5 class="mb-0">Products</h5>
                                                    <button type="button" class="btn btn-primary btn-sm" id="addProductBtn">
                                                        <i data-feather="plus"></i> Add Product
                                                    </button>
                                                </div>
                                                <div class="card-body">
                                                    <div class="table-responsive">
                                                        <table class="table table-bordered" id="productItemsTable">
                                                            <thead>
                                                                <tr>
                                                                    <th style="width: 40%">Product</th>
                                                                    <th>Quantity</th>
                                                                    <th>Unit Price</th>
                                                                    <th>Total</th>
                                                                    <th style="width: 80px">Actions</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody id="productItemsBody">
                                                                <%
                                                                    List<TransferOrderItem> items = transferOrder.getItems();
                                                                    List<Product> products = (List<Product>)request.getAttribute("products");
                                                                    
                                                                    if (items != null && !items.isEmpty()) {
                                                                        for (TransferOrderItem item : items) {
                                                                %>
                                                                <tr class="product-row">
                                                                    <td>
                                                                        <select class="form-select product-select" name="productId" required>
                                                                            <option value="">-- Select Product --</option>
                                                                            <% 
                                                                                if (products != null) {
                                                                                    for (Product product : products) {
                                                                                        String priceValue = product.getPrice() != null ? product.getPrice().toString() : "0";
                                                                                        boolean isSelected = product.getProductId() == item.getProductId();
                                                                            %>
                                                                            <option value="<%= product.getProductId() %>" data-price="<%= priceValue %>" <%= isSelected ? "selected" : "" %>>
                                                                                <%= product.getName() %> (<%= product.getCode() %>)
                                                                            </option>
                                                                            <% 
                                                                                    }
                                                                                }
                                                                            %>
                                                                        </select>
                                                                    </td>
                                                                    <td>
                                                                        <input type="number" class="form-control quantity-input" name="quantity" min="1" value="<%= item.getQuantity() %>" required>
                                                                    </td>
                                                                    <td>
                                                                        <input type="text" class="form-control unit-price" readonly>
                                                                        <input type="hidden" name="unitPrice">
                                                                    </td>
                                                                    <td>
                                                                        <input type="text" class="form-control row-total" readonly>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <button type="button" class="btn btn-sm btn-outline-danger remove-product">
                                                                            <i data-feather="trash-2"></i>
                                                                        </button>
                                                                    </td>
                                                                </tr>
                                                                <% 
                                                                        }
                                                                    } else {
                                                                %>
                                                                <tr class="product-row">
                                                                    <td>
                                                                        <select class="form-select product-select" name="productId" required>
                                                                            <option value="">-- Select Product --</option>
                                                                            <% 
                                                                                if (products != null) {
                                                                                    for (Product product : products) {
                                                                                        String priceValue = product.getPrice() != null ? product.getPrice().toString() : "0";
                                                                            %>
                                                                            <option value="<%= product.getProductId() %>" data-price="<%= priceValue %>">
                                                                                <%= product.getName() %> (<%= product.getCode() %>)
                                                                            </option>
                                                                            <% 
                                                                                    }
                                                                                }
                                                                            %>
                                                                        </select>
                                                                    </td>
                                                                    <td>
                                                                        <input type="number" class="form-control quantity-input" name="quantity" min="1" value="1" required>
                                                                    </td>
                                                                    <td>
                                                                        <input type="text" class="form-control unit-price" readonly>
                                                                        <input type="hidden" name="unitPrice">
                                                                    </td>
                                                                    <td>
                                                                        <input type="text" class="form-control row-total" readonly>
                                                                    </td>
                                                                    <td class="text-center">
                                                                        <button type="button" class="btn btn-sm btn-outline-danger remove-product">
                                                                            <i data-feather="trash-2"></i>
                                                                        </button>
                                                                    </td>
                                                                </tr>
                                                                <% } %>
                                                            </tbody>
                                                            <tfoot>
                                                                <tr class="table-active">
                                                                    <th colspan="3" class="text-end">Total:</th>
                                                                    <th id="orderTotal" class="text-end">0.00</th>
                                                                    <th></th>
                                                                </tr>
                                                            </tfoot>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Submit Buttons -->
                                            <div class="row mt-4">
                                                <div class="col-12 text-end">
                                                    <button type="button" class="btn btn-danger btn-lg me-2" 
                                                            onclick="if(confirm('Are you sure you want to delete this transfer order?')) { window.location.href='delete-transfer-order?id=<%= transferOrder.getTransferId() %>'; }">
                                                        <i class="align-middle me-1" data-feather="trash-2"></i> Delete Order
                                                    </button>
                                                    <button type="button" class="btn btn-secondary btn-lg me-2" onclick="window.location.href='list-transfer-order'">
                                                        Cancel
                                                    </button>
                                                    <button type="submit" class="btn btn-lg btn-primary">
                                                        <i class="align-middle me-1" data-feather="save"></i> Update Transfer Order
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
                <jsp:include page="/staff/footer.jsp" />
            </div>
        </div>

        <script src="<c:url value='/staff/js/app.js'/>"></script>
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- Select2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                // Initialize feather icons
                feather.replace();
                  // Initialize Select2 for product dropdowns
                $('.product-select').each(function() {
                    initializeSelect2($(this));
                });
                
                // Function to initialize Select2 on an element
                function initializeSelect2(element) {
                    // Destroy existing instance if it exists
                    if (element.data('select2')) {
                        element.select2('destroy');
                    }
                    
                    // Initialize fresh instance
                    element.select2({
                        theme: 'bootstrap-5',
                        width: '100%',
                        placeholder: "Search for a product...",
                        allowClear: true,
                        dropdownParent: element.parent()
                    });
                }
                
                // Format currency function
                function formatCurrency(amount) {
                    return new Intl.NumberFormat('vi-VN', { 
                        style: 'currency', 
                        currency: 'VND',
                        minimumFractionDigits: 0,
                        maximumFractionDigits: 0
                    }).format(amount);
                }
                
                // Calculate row total
                function calculateRowTotal(row) {
                    const quantityInput = row.querySelector('.quantity-input');
                    const unitPriceInput = row.querySelector('.unit-price');
                    const rowTotalInput = row.querySelector('.row-total');
                    const hiddenUnitPrice = row.querySelector('input[name="unitPrice"]');
                    
                    const quantity = parseInt(quantityInput.value) || 0;
                    const unitPrice = parseFloat(hiddenUnitPrice.value) || 0;
                    const total = quantity * unitPrice;
                    
                    rowTotalInput.value = formatCurrency(total);
                    
                    return total;
                }
                
                // Calculate order total
                function calculateOrderTotal() {
                    let orderTotal = 0;
                    document.querySelectorAll('.product-row').forEach(row => {
                        orderTotal += calculateRowTotal(row);
                    });
                    
                    document.getElementById('orderTotal').textContent = formatCurrency(orderTotal);
                    return orderTotal;
                }
                  // Initialize product select change handler
                function initProductSelectHandler(select) {
                    // Use jQuery on to handle both native and Select2 change events
                    $(select).on('change', function() {
                        const row = this.closest('.product-row');
                        const selectedOption = this.options[this.selectedIndex];
                        const price = selectedOption ? (selectedOption.dataset.price || 0) : 0;
                        
                        const unitPriceInput = row.querySelector('.unit-price');
                        const hiddenUnitPrice = row.querySelector('input[name="unitPrice"]');
                        
                        hiddenUnitPrice.value = price;
                        unitPriceInput.value = formatCurrency(price);
                        
                        calculateRowTotal(row);
                        calculateOrderTotal();
                    });
                    
                    // Initialize the price values for pre-selected products
                    if (select.selectedIndex > 0) {
                        const row = select.closest('.product-row');
                        const selectedOption = select.options[select.selectedIndex];
                        const price = selectedOption.dataset.price || 0;
                        
                        const unitPriceInput = row.querySelector('.unit-price');
                        const hiddenUnitPrice = row.querySelector('input[name="unitPrice"]');
                        
                        hiddenUnitPrice.value = price;
                        unitPriceInput.value = formatCurrency(price);
                    }
                }
                
                // Initialize quantity input change handler
                function initQuantityInputHandler(input) {
                    input.addEventListener('change', function() {
                        const row = this.closest('.product-row');
                        calculateRowTotal(row);
                        calculateOrderTotal();
                    });
                    
                    input.addEventListener('keyup', function() {
                        const row = this.closest('.product-row');
                        calculateRowTotal(row);
                        calculateOrderTotal();
                    });
                }
                  // Transfer type is fixed and can't be changed
                const destinationWarehouseContainer = document.getElementById('destinationWarehouseContainer');
                const destinationWarehouseSelect = document.getElementById('destinationWarehouseId');
                
                function handleTransferTypeDisplay() {
                    const transferTypeInput = document.querySelector('input[name="transferType"]');
                    const selectedType = transferTypeInput.value;
                    
                    if (selectedType === 'transfer') {
                        destinationWarehouseContainer.style.display = 'block';
                        destinationWarehouseSelect.required = true;
                    } else if (selectedType === 'import') {
                        destinationWarehouseContainer.style.display = 'none';
                        destinationWarehouseSelect.required = false;
                    } else if (selectedType === 'export') {
                        destinationWarehouseContainer.style.display = 'none';
                        destinationWarehouseSelect.required = false;
                    }
                }
                
                // Initialize based on the transfer type
                handleTransferTypeDisplay();
                  // Add Product button functionality
                const addProductBtn = document.getElementById('addProductBtn');                
                const productItemsBody = document.getElementById('productItemsBody');                
                addProductBtn.addEventListener('click', function() {
                    // Create a fresh row
                    const templateRow = document.createElement('tr');
                    templateRow.className = 'product-row';
                    
                    // Build the product options HTML
                    let optionsHTML = '<option value="">-- Select Product --</option>';
                    const productSelect = document.querySelector('.product-select');
                    
                    if (productSelect) {
                        Array.from(productSelect.options).forEach(function(option) {
                            if (option.value) {
                                optionsHTML += '<option value="' + option.value + '" data-price="' + 
                                    (option.dataset.price || '0') + '">' + 
                                    option.textContent + '</option>';
                            }
                        });
                    }
                    
                    // Create the row HTML
                    const rowHTML = '<td>' +
                        '<select class="form-select product-select" name="productId" required>' +
                        optionsHTML +
                        '</select>' +
                        '</td>' +
                        '<td>' +
                        '<input type="number" class="form-control quantity-input" name="quantity" min="1" value="1" required>' +
                        '</td>' +
                        '<td>' +
                        '<input type="text" class="form-control unit-price" readonly>' +
                        '<input type="hidden" name="unitPrice" value="0">' +
                        '</td>' +
                        '<td>' +
                        '<input type="text" class="form-control row-total" readonly>' +
                        '</td>' +
                        '<td class="text-center">' +
                        '<button type="button" class="btn btn-sm btn-outline-danger remove-product">' +
                        '<i data-feather="trash-2"></i>' +
                        '</button>' +
                        '</td>';
                    
                    templateRow.innerHTML = rowHTML;
                    
                    // Get elements
                    const selectElement = templateRow.querySelector('.product-select');
                    const quantityInput = templateRow.querySelector('.quantity-input');
                    const removeBtn = templateRow.querySelector('.remove-product');
                    
                    // Add event listeners
                    initProductSelectHandler(selectElement);
                    initQuantityInputHandler(quantityInput);
                    
                    // Add remove button functionality
                    removeBtn.addEventListener('click', function() {
                        if (document.querySelectorAll('.product-row').length > 1) {
                            $(templateRow).find('.product-select').select2('destroy');
                            templateRow.remove();
                            calculateOrderTotal();
                        }
                    });
                    
                    // Add the new row to the table
                    productItemsBody.appendChild(templateRow);
                    
                    // Initialize Select2 on the new product select
                    initializeSelect2($(selectElement));
                    
                    // Reinitialize feather icons
                    feather.replace();
                });                // Set up initial row functionality
                document.querySelectorAll('.product-row').forEach(row => {
                    const selectElement = row.querySelector('.product-select');
                    const quantityInput = row.querySelector('.quantity-input');
                    const removeBtn = row.querySelector('.remove-product');
                    
                    initProductSelectHandler(selectElement);
                    initQuantityInputHandler(quantityInput);
                    
                    removeBtn.addEventListener('click', function() {
                        if (document.querySelectorAll('.product-row').length > 1) {
                            // Make sure to properly destroy the select2 instance
                            $(row).find('.product-select').select2('destroy');
                            row.remove();
                            calculateOrderTotal();
                        }
                    });
                });
                
                // Initialize calculations
                calculateOrderTotal();
                
                // Form validation before submit
                const transferOrderForm = document.getElementById('transferOrderForm');
                  transferOrderForm.addEventListener('submit', function(event) {
                    const selectedType = document.querySelector('input[name="transferType"]').value;
                    const sourceWarehouse = document.getElementById('sourceWarehouseId').value;
                    const destinationWarehouse = document.getElementById('destinationWarehouseId').value;
                    
                    // Check that source and destination warehouses are different for transfers
                    if (selectedType === 'transfer' && sourceWarehouse === destinationWarehouse && sourceWarehouse !== '') {
                        event.preventDefault();
                        alert('Source and destination warehouses must be different for transfers');
                        return false;
                    }
                    
                    // Ensure at least one product is selected
                    const productSelects = document.querySelectorAll('select[name="productId"]');
                    let validProducts = false;
                    
                    productSelects.forEach(select => {
                        if (select.value !== '') {
                            validProducts = true;
                        }
                    });
                    
                    if (!validProducts) {
                        event.preventDefault();
                        alert('Please select at least one product');
                        return false;
                    }
                });
            });
        </script>
    </body>
</html>
