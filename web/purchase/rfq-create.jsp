<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Request for Quotation - RFQ</title>
    

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .rfq-form {
            background: white;
            max-width: 100%;
            margin: 20px auto;
            padding: 30px;
        }
        .rfq-header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #000;
            padding-bottom: 20px;
        }
        .form-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .form-table th, .form-table td {
            border: 1px solid #dee2e6;
            padding: 8px;
            text-align: center;
        }
        .form-table th {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        .supplier-info {
            margin: 20px 0;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 5px;
        }
        .btn-add-row {
            margin: 10px 0;
        }
        .signature-section {
            margin-top: 40px;
            display: flex;
            justify-content: space-between;
        }
        .supplier-contact {
            margin-top: 10px;
            color: #6c757d;
        }
    </style>
</head>

<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
    <div class="wrapper">
        <!-- Sidebar -->
        <jsp:include page="/purchase/PurchaseSidebar.jsp"/>
        
        <div class="main">
            <!-- Navbar -->
            <jsp:include page="/purchase/navbar.jsp" />

            <main class="content">
                <div class="container-fluid p-0">
                    <div class="row mb-2 mb-xl-3">
                        <div class="col-auto d-none d-sm-block">
                            <h3><strong>Create</strong> Request for Quotation</h3>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-body">
                            <!-- RFQ Form -->
                            <form action="${pageContext.request.contextPath}/purchase/rfq" method="POST" id="rfqForm">
                                <input type="hidden" name="action" value="save">
                                
                                <!-- Header -->
                                <div class="rfq-header">
                                    <h3>REQUEST FOR QUOTATION</h3>
                                    <p class="mb-1">Date: <span id="currentDate"></span></p>
                                    <p class="mb-0">No: <strong>RFQ-<span id="rfqNumber"></span></strong></p>
                                </div>

                                <!-- Supplier Information -->
                                <div class="supplier-info">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <label for="supplierId" class="form-label"><strong>Supplier:</strong></label>
                                            <select class="form-select" id="supplierId" name="supplierId" required>
                                                <option value="">-- Select Supplier --</option>
                                                <c:forEach var="supplier" items="${suppliers}">
                                                    <option value="${supplier.supplierId}">${supplier.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <div id="supplierContact" class="supplier-contact" style="display: none;">
                                                <strong>Contact Information:</strong>
                                                <div id="supplierEmail"></div>
                                                <div id="supplierPhone"></div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Additional Information -->
                                    <div class="row mt-3">
                                        <div class="col-md-6">
                                            <label for="warehouseId" class="form-label"><strong>Delivery Warehouse:</strong></label>
                                            <c:choose>
                                                <c:when test="${isWarehouseLocked}">
                                                    <select class="form-select" id="warehouseId" name="warehouseId" disabled required>
                                                        <c:forEach var="warehouse" items="${warehouses}">
                                                            <c:if test="${warehouse.warehouseId == defaultWarehouseId}">
                                                                <option value="${warehouse.warehouseId}" selected>${warehouse.warehouseName} - ${warehouse.address}</option>
                                                            </c:if>
                                                        </c:forEach>
                                                    </select>
                                                    <input type="hidden" name="warehouseId" value="${defaultWarehouseId}">
                                                    <div class="form-text text-muted">
                                                        <small><i class="fas fa-lock"></i> Warehouse is automatically assigned based on your account.</small>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <select class="form-select" id="warehouseId" name="warehouseId" required>
                                                        <option value="">-- Select Delivery Warehouse --</option>
                                                        <c:forEach var="warehouse" items="${warehouses}">
                                                            <c:choose>
                                                                <c:when test="${warehouse.warehouseId == defaultWarehouseId}">
                                                                    <option value="${warehouse.warehouseId}" selected>${warehouse.warehouseName} - ${warehouse.address}</option>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <option value="${warehouse.warehouseId}">${warehouse.warehouseName} - ${warehouse.address}</option>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </select>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="expectedDeliveryDate" class="form-label"><strong>Expected Delivery Date:</strong></label>
                                            <input type="date" class="form-control" id="expectedDeliveryDate" name="expectedDeliveryDate" required>
                                        </div>
                                    </div>
                                </div>

                                <!-- Reference Document Section -->
                                <div class="row mt-4">
                                    <div class="col-md-12">
                                        <div class="card">
                                            <div class="card-header">
                                                <h6 class="mb-0"><i class="fas fa-file-import"></i> Reference Document (Optional)</h6>
                                            </div>
                                            <div class="card-body">
                                                <div class="row">
                                                    <div class="col-md-8">
                                                <label for="importRequestId" class="form-label"><strong>Select Import Request:</strong></label>
                                                <select class="form-select" id="importRequestId" name="importRequestId">
                                                    <option value="">-- Select Import Request (Optional) --</option>
                                                    <c:forEach var="importRequest" items="${importRequests}">
                                                        <option value="${importRequest.requestId}">
                                                            IR-${importRequest.requestId} - ${importRequest.reason} (${importRequest.status})
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                                <div class="form-text text-muted">
                                                    <small><i class="fas fa-info-circle"></i> Select an import request to automatically populate products and quantities, or leave blank to enter manually.</small>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <label class="form-label">&nbsp;</label>
                                                <div>
                                                    <button type="button" class="btn btn-primary" id="loadImportRequestBtn" onclick="loadImportRequestItems()" disabled>
                                                        <i class="fas fa-download"></i> Load Items
                                                    </button>
                                                    <button type="button" class="btn btn-warning" id="clearImportRequestBtn" onclick="clearImportRequestItems()" disabled>
                                                        <i class="fas fa-times"></i> Clear
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- Purchase Request Section -->
                                <div class="row mt-4">
                                    <div class="col-md-12">
                                        <div class="card">
                                            <div class="card-header">
                                                <h6 class="mb-0"><i class="fas fa-file-import"></i> Reference Purchase Request (Optional)</h6>
                                            </div>
                                            <div class="card-body">
                                                <div class="row">
                                                    <div class="col-md-8">
                                                        <label for="purchaseRequestId" class="form-label"><strong>Select Purchase Request:</strong></label>
                                                        <select class="form-select" id="purchaseRequestId" name="purchaseRequestId">
                                                            <option value="">-- Select Purchase Request (Optional) --</option>
                                                            <c:forEach var="purchaseRequest" items="${purchaseRequests}">
                                                            <option value="${purchaseRequest.prId}">
                                                            ${purchaseRequest.reason}
                                                            </option>
                                                            </c:forEach>
                                                        </select>
                                                        <div class="form-text text-muted">
                                                            <small><i class="fas fa-info-circle"></i> Select a purchase request to automatically populate products and quantities, or leave blank to enter manually.</small>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-4">
                                                        <label class="form-label">&nbsp;</label>
                                                        <div>
                                                            <button type="button" class="btn btn-primary" id="loadPurchaseRequestBtn" onclick="loadPurchaseRequestItems()" disabled>
                                                                <i class="fas fa-download"></i> Load Items
                                                            </button>
                                                            <button type="button" class="btn btn-warning" id="clearPurchaseRequestBtn" onclick="clearPurchaseRequestItems()" disabled>
                                                                <i class="fas fa-times"></i> Clear
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Products Table -->
                                <table class="form-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 5%">No.</th>
                                            <th style="width: 35%">Product</th>
                                            <th style="width: 20%">Product Code</th>
                                            <th style="width: 15%">Unit</th>
                                            <th style="width: 15%">Quantity</th>
                                            <th style="width: 10%">Delete</th>
                                        </tr>
                                    </thead>
                                    <tbody id="productTableBody">
                                        <tr class="product-row">
                                            <td>1</td>
                                            <td>
                                                <select class="form-select product-select" name="productId" required>
                                                    <option value="">-- Select Product --</option>
                                                </select>
                                            </td>
                                            <td class="product-code">-</td>
                                            <td class="product-unit">-</td>
                                            <td>
                                                <input type="number" class="form-control quantity-input" name="quantity" min="1" value="1" required>
                                            </td>
                                            <td>
                                                <button type="button" class="btn btn-sm btn-danger remove-row" onclick="removeRow(this)" disabled>
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>

                                <!-- Add Row Button -->
                                <div class="btn-add-row">
                                    <button type="button" class="btn btn-success" onclick="addProductRow()" id="addRowBtn" disabled>
                                        <i class="fas fa-plus"></i> Add Product
                                    </button>
                                </div>

                                <!-- Notes Section -->
                                <div class="row mt-3">
                                    <div class="col-md-12">
                                        <label for="notes" class="form-label"><strong>General Notes:</strong></label>
                                        <textarea class="form-control" id="notes" name="notes" rows="4" 
                                                  placeholder="Enter notes, special requirements or delivery conditions..."></textarea>
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <div class="text-center mt-4">
                                    <button type="submit" class="btn btn-primary btn-lg me-2">
                                        <i class="fas fa-save"></i> Save Request for Quotation
                                    </button>
                                    <a href="${pageContext.request.contextPath}/purchase/rfq?action=list" class="btn btn-secondary btn-lg">
                                        <i class="fas fa-arrow-left"></i> Back
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </main>

            <!-- Footer -->
            <jsp:include page="/purchase/footer.jsp" />
        </div>
    </div>

    <!-- JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app.js"></script>

    <script>
        let rowCounter = 1;
        let availableProducts = [];

        // Set current date
        document.getElementById('currentDate').textContent = new Date().toLocaleDateString('vi-VN');
        document.getElementById('rfqNumber').textContent = Date.now().toString().slice(-6);

        // Supplier selection handler
        document.getElementById('supplierId').addEventListener('change', function() {
            const supplierId = this.value;
            
            if (supplierId) {
                // Get supplier info
                fetch('${pageContext.request.contextPath}/purchase/rfq?action=get-supplier-info&supplierId=' + supplierId)
                    .then(response => response.json())
                    .then(data => {
                        document.getElementById('supplierEmail').innerHTML = '<i class="fas fa-envelope"></i> ' + (data.email || 'No email');
                        document.getElementById('supplierPhone').innerHTML = '<i class="fas fa-phone"></i> ' + (data.phone || 'No phone number');
                        document.getElementById('supplierContact').style.display = 'block';
                    });

                // Get products by supplier
                fetch('${pageContext.request.contextPath}/purchase/rfq?action=get-products&supplierId=' + supplierId)
                    .then(response => response.json())
                    .then(data => {
                        availableProducts = data;
                        updateAllProductSelects();
                        document.getElementById('addRowBtn').disabled = false;
                    });
            } else {
                document.getElementById('supplierContact').style.display = 'none';
                availableProducts = [];
                updateAllProductSelects();
                document.getElementById('addRowBtn').disabled = true;
            }
        });

        // Import Request selection handler
        document.getElementById('importRequestId').addEventListener('change', function() {
            const importRequestId = this.value;
            const loadBtn = document.getElementById('loadImportRequestBtn');
            const clearBtn = document.getElementById('clearImportRequestBtn');
            
            if (importRequestId) {
                loadBtn.disabled = false;
                clearBtn.disabled = false;
            } else {
                loadBtn.disabled = true;
                clearBtn.disabled = true;
            }
        });

        // Purchase Request selection handler
        document.getElementById('purchaseRequestId').addEventListener('change', function() {
            const purchaseRequestId = this.value;
            const loadBtn = document.getElementById('loadPurchaseRequestBtn');
            const clearBtn = document.getElementById('clearPurchaseRequestBtn');
            
            if (purchaseRequestId) {
                loadBtn.disabled = false;
                clearBtn.disabled = false;
            } else {
                loadBtn.disabled = true;
                clearBtn.disabled = true;
            }
        });

        function loadPurchaseRequestItems() {
            const purchaseRequestId = document.getElementById('purchaseRequestId').value;
            
            if (!purchaseRequestId) {
                alert('Please select a purchase request first!');
                return;
            }

            // Show loading state
            const loadBtn = document.getElementById('loadPurchaseRequestBtn');
            const originalText = loadBtn.innerHTML;
            loadBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Loading...';
            loadBtn.disabled = true;

            // Make AJAX call to get purchase request details
            fetch('${pageContext.request.contextPath}/purchase/rfq?action=get-purchase-request-details&purchaseRequestId=' + purchaseRequestId)
                .then(response => response.json())
                .then(data => {
                    console.log('Purchase request response:', data); // Debug logging
                    if (data.success && data.details) {
                        console.log('Details:', data.details); // Debug logging
                        // Clear existing product rows
                        const tableBody = document.getElementById('productTableBody');
                        tableBody.innerHTML = '';
                        rowCounter = 0;
                        
                        // Add items from purchase request
                        data.details.forEach(function(detail, index) {
                            console.log('Processing detail:', detail); // Debug logging
                            addProductRowFromPurchaseRequest(detail, index === 0);
                        });
                        
                        // If no items were added, add at least one empty row
                        if (data.details.length === 0) {
                            addEmptyProductRow();
                        }
                        
                        updateRowNumbers();
                        alert('Purchase request items loaded successfully!');
                    } else {
                        console.error('API Error:', data); // Debug logging
                        alert('Error loading purchase request details: ' + (data.message || 'Unknown error'));
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error loading purchase request details. Please try again.');
                })
                .finally(() => {
                    // Restore button state
                    loadBtn.innerHTML = originalText;
                    loadBtn.disabled = false;
                });
        }

        function clearPurchaseRequestItems() {
            if (confirm('Are you sure you want to clear all imported items and start fresh?')) {
                // Reset purchase request dropdown
                document.getElementById('purchaseRequestId').value = '';
                document.getElementById('loadPurchaseRequestBtn').disabled = true;
                document.getElementById('clearPurchaseRequestBtn').disabled = true;
                
                // Clear existing product rows and add one empty row
                const tableBody = document.getElementById('productTableBody');
                tableBody.innerHTML = '';
                rowCounter = 0;
                addEmptyProductRow();
            }
        }

        function addProductRowFromPurchaseRequest(detail, isFirst = false) {
            rowCounter++;
            const tableBody = document.getElementById('productTableBody');
            const newRow = document.createElement('tr');
            newRow.className = 'product-row';
            
            let html = '';
            html += '<td>' + rowCounter + '</td>';
            html += '<td>';
            html += '<select class="form-select product-select" name="productId" required onchange="updateProductInfo(this)">';
            html += '<option value="">-- Select Product --</option>';
            html += '<option value="' + (detail.productId || '') + '" selected data-code="' + (detail.productCode || '') + '" data-unit="' + (detail.unitName || '') + '">';
            html += (detail.productName || 'Unknown Product') + ' (' + (detail.productCode || 'No Code') + ')';
            html += '</option>';
            html += '</select>';
            html += '</td>';
            html += '<td class="product-code">' + (detail.productCode || '-') + '</td>';
            html += '<td class="product-unit">' + (detail.unitName || '-') + '</td>';
            html += '<td><input type="number" class="form-control quantity-input" name="quantity" min="1" value="' + (detail.quantity || 1) + '" required></td>';
            html += '<td><button type="button" class="btn btn-sm btn-danger remove-row" onclick="removeRow(this)" ' + (isFirst ? 'disabled' : '') + '><i class="fas fa-trash"></i></button></td>';
            
            newRow.innerHTML = html;
            tableBody.appendChild(newRow);
        }

        function loadImportRequestItems() {
            const importRequestId = document.getElementById('importRequestId').value;
            
            if (!importRequestId) {
                alert('Please select an import request first!');
                return;
            }

            // Show loading state
            const loadBtn = document.getElementById('loadImportRequestBtn');
            const originalText = loadBtn.innerHTML;
            loadBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Loading...';
            loadBtn.disabled = true;

            // Make AJAX call to get import request details
            fetch('${pageContext.request.contextPath}/purchase/rfq?action=get-import-request-details&requestId=' + importRequestId)
                .then(response => response.json())
                .then(data => {
                    console.log('Import request response:', data); // Debug logging
                    if (data.success && data.details) {
                        console.log('Details:', data.details); // Debug logging
                        // Clear existing product rows
                        const tableBody = document.getElementById('productTableBody');
                        tableBody.innerHTML = '';
                        rowCounter = 0;
                        
                        // Add items from import request
                        data.details.forEach(function(detail, index) {
                            console.log('Processing detail:', detail); // Debug logging
                            addProductRowFromImportRequest(detail, index === 0);
                        });
                        
                        // If no items were added, add at least one empty row
                        if (data.details.length === 0) {
                            addEmptyProductRow();
                        }
                        
                        updateRowNumbers();
                        alert('Import request items loaded successfully!');
                    } else {
                        console.error('API Error:', data); // Debug logging
                        alert('Error loading import request details: ' + (data.message || 'Unknown error'));
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error loading import request details. Please try again.');
                })
                .finally(() => {
                    // Restore button state
                    loadBtn.innerHTML = originalText;
                    loadBtn.disabled = false;
                });
        }

        function clearImportRequestItems() {
            if (confirm('Are you sure you want to clear all imported items and start fresh?')) {
                // Reset import request dropdown
                document.getElementById('importRequestId').value = '';
                document.getElementById('loadImportRequestBtn').disabled = true;
                document.getElementById('clearImportRequestBtn').disabled = true;
                
                // Clear existing product rows and add one empty row
                const tableBody = document.getElementById('productTableBody');
                tableBody.innerHTML = '';
                rowCounter = 0;
                addEmptyProductRow();
            }
        }

        function addProductRowFromImportRequest(detail, isFirst = false) {
            rowCounter++;
            const tableBody = document.getElementById('productTableBody');
            const newRow = document.createElement('tr');
            newRow.className = 'product-row';
            
            let html = '';
            html += '<td>' + rowCounter + '</td>';
            html += '<td>';
            html += '<select class="form-select product-select" name="productId" required onchange="updateProductInfo(this)">';
            html += '<option value="">-- Select Product --</option>';
            html += '<option value="' + (detail.productId || '') + '" selected data-code="' + (detail.productCode || '') + '" data-unit="' + (detail.unitName || '') + '">';
            html += (detail.productName || 'Unknown Product') + ' (' + (detail.productCode || 'No Code') + ')';
            html += '</option>';
            html += '</select>';
            html += '</td>';
            html += '<td class="product-code">' + (detail.productCode || '-') + '</td>';
            html += '<td class="product-unit">' + (detail.unitName || '-') + '</td>';
            html += '<td><input type="number" class="form-control quantity-input" name="quantity" min="1" value="' + (detail.quantity || 1) + '" required></td>';
            html += '<td><button type="button" class="btn btn-sm btn-danger remove-row" onclick="removeRow(this)" ' + (isFirst ? 'disabled' : '') + '><i class="fas fa-trash"></i></button></td>';
            
            newRow.innerHTML = html;
            tableBody.appendChild(newRow);
        }

        function updateAllProductSelects() {
            const productSelects = document.querySelectorAll('.product-select');
            productSelects.forEach(select => {
                updateProductSelectOptions(select);
            });
        }

        function addProductRow() {
            if (availableProducts.length === 0) {
                alert('Please select a supplier first!');
                return;
            }

            addEmptyProductRow();
            
            // Update product select for new row
            const newSelect = document.querySelector('#productTableBody tr:last-child .product-select');
            updateProductSelectOptions(newSelect);
        }

        function addEmptyProductRow() {
            rowCounter++;
            const tableBody = document.getElementById('productTableBody');
            const newRow = document.createElement('tr');
            newRow.className = 'product-row';
            
            let html = '';
            html += '<td>' + rowCounter + '</td>';
            html += '<td>';
            html += '<select class="form-select product-select" name="productId" required onchange="updateProductInfo(this)">';
            html += '<option value="">-- Select Product --</option>';
            html += '</select>';
            html += '</td>';
            html += '<td class="product-code">-</td>';
            html += '<td class="product-unit">-</td>';
            html += '<td><input type="number" class="form-control quantity-input" name="quantity" min="1" value="1" required></td>';
            html += '<td><button type="button" class="btn btn-sm btn-danger remove-row" onclick="removeRow(this)"><i class="fas fa-trash"></i></button></td>';
            
            newRow.innerHTML = html;
            tableBody.appendChild(newRow);
            updateRowNumbers();
        }

        function removeRow(button) {
            const row = button.closest('tr');
            const tableBody = document.getElementById('productTableBody');
            
            if (tableBody.children.length > 1) {
                row.remove();
                updateRowNumbers();
            } else {
                alert('Must have at least one product!');
            }
        }

        function updateRowNumbers() {
            const rows = document.querySelectorAll('#productTableBody tr');
            rows.forEach((row, index) => {
                row.querySelector('td:first-child').textContent = index + 1;
                
                // Enable/disable remove button
                const removeBtn = row.querySelector('.remove-row');
                removeBtn.disabled = rows.length === 1;
            });
        }

        function updateProductInfo(select) {
            const row = select.closest('tr');
            const selectedOption = select.options[select.selectedIndex];
            
            if (selectedOption && selectedOption.value) {
                row.querySelector('.product-code').textContent = selectedOption.getAttribute('data-code') || '-';
                row.querySelector('.product-unit').textContent = selectedOption.getAttribute('data-unit') || '-';
                
                // Update all product selects to prevent duplicates only if we have available products
                if (availableProducts && availableProducts.length > 0) {
                    updateAllProductSelects();
                }
            } else {
                row.querySelector('.product-code').textContent = '-';
                row.querySelector('.product-unit').textContent = '-';
            }
        }
        
        function updateProductSelectOptions(selectElement) {
            if (!selectElement) return;
            
            const selectedProducts = getSelectedProducts();
            const currentValue = selectElement.value;
            
            selectElement.innerHTML = '<option value="">-- Select Product --</option>';
            
            // Only update if we have available products
            if (availableProducts && availableProducts.length > 0) {
                availableProducts.forEach(product => {
                    // Only add option if product is not already selected in other rows
                    if (!selectedProducts.includes(product.productId.toString()) || product.productId.toString() === currentValue) {
                        const option = document.createElement('option');
                        option.value = product.productId;
                        option.textContent = product.name;
                        option.setAttribute('data-code', product.code);
                        option.setAttribute('data-unit', product.unitName || '');
                        selectElement.appendChild(option);
                    }
                });
                
                selectElement.value = currentValue;
            }
        }
        
        function getSelectedProducts() {
            const selectedProducts = [];
            const productSelects = document.querySelectorAll('.product-select');
            productSelects.forEach(select => {
                if (select.value) {
                    selectedProducts.push(select.value);
                }
            });
            return selectedProducts;
        }

        // Add event listeners to existing product selects
        document.addEventListener('change', function(e) {
            if (e.target.classList.contains('product-select')) {
                updateProductInfo(e.target);
            }
        });

        // Set minimum date to today
        document.getElementById('expectedDeliveryDate').min = new Date().toISOString().split('T')[0];
        
        // Form validation
        document.getElementById('rfqForm').addEventListener('submit', function(e) {
            const supplierId = document.getElementById('supplierId').value;
            const warehouseId = document.getElementById('warehouseId').value;
            const expectedDeliveryDate = document.getElementById('expectedDeliveryDate').value;
            const productSelects = document.querySelectorAll('.product-select');
            
            if (!supplierId) {
                e.preventDefault();
                alert('Please select a supplier!');
                return;
            }
            
            if (!warehouseId) {
                e.preventDefault();
                alert('Please select a delivery warehouse!');
                return;
            }
            
            if (!expectedDeliveryDate) {
                e.preventDefault();
                alert('Please select expected delivery date!');
                return;
            }

            let hasValidProduct = false;
            productSelects.forEach(select => {
                if (select.value) {
                    hasValidProduct = true;
                }
            });

            if (!hasValidProduct) {
                e.preventDefault();
                alert('Please select at least one product!');
                return;
            }
            
            // Check for duplicate products
            const selectedProducts = getSelectedProducts();
            const uniqueProducts = [...new Set(selectedProducts)];
            if (selectedProducts.length !== uniqueProducts.length) {
                e.preventDefault();
                alert('Cannot select duplicate products!');
                return;
            }
        });

        // Initialize
        updateRowNumbers();
    </script>
</body>
</html>