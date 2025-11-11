<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Create Purchase Order</title>

        <!-- CSS -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .invoice-form {
                background: white;
                max-width: 100%;
                margin: 20px auto;
                padding: 30px;
            }
            .invoice-header {
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
            }
            .total-section {
                margin-top: 20px;
                text-align: right;
            }
            .btn-add-row {
                margin: 10px 0;
            }
            .signature-section {
                margin-top: 40px;
                display: flex;
                justify-content: space-between;
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
                                <h3><strong>Create</strong> Purchase Order</h3>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-body">
                                <!-- Purchase Order Form -->
                                <form action="${pageContext.request.contextPath}/purchase/purchase-order" method="POST" id="purchaseOrderForm">
                                    <input type="hidden" name="action" value="save">

                                    <!-- Header -->
                                    <div class="invoice-header">
                                        <h3>PURCHASE ORDER</h3>
                                        <p class="mb-1">Date: <span id="currentDate"></span></p>
                                        <p class="mb-0">Number: <strong>PO-<span id="poNumber"></span></strong></p>
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
                                            <div class="col-md-6" style="display: none;">
                                                <label for="status" class="form-label"><strong>Status:</strong></label>
                                                <select class="form-select" id="status" name="status">
                                                    <option value="Pending" selected>Pending</option>
                                                    <option value="Approved">Approved</option>
                                                    <option value="Completed">Completed</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="row mt-3">
                                            <div class="col-md-6">
                                                <label for="expectedDeliveryDate" class="form-label"><strong>Expected Delivery Date:</strong></label>
                                                <input type="date" class="form-control" id="expectedDeliveryDate" name="expectedDeliveryDate" min="" required>
                                                <div class="invalid-feedback" id="dateError"></div>
                                            </div>
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
                                                            <option value="">-- Select Warehouse --</option>
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
                                        </div>
                                    </div>

                                    <!-- Reference RFQ (Optional) -->
                                    <div class="card mt-4">
                                        <div class="card-header bg-light">
                                            <h5 class="card-title mb-0">
                                                <i class="fas fa-link text-primary"></i> Reference RFQ (Optional)
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <p class="text-muted small mb-3">
                                                <i class="fas fa-info-circle"></i> You can optionally select an existing RFQ to automatically populate products and supplier information. 
                                                If no RFQ is selected, you can manually enter the product details.
                                            </p>

                                            <div class="row">
                                                <div class="col-md-8">
                                                    <label for="rfqSelect" class="form-label">Select RFQ:</label>
                                                    <select class="form-select" id="rfqSelect">
                                                        <option value="">-- Select an RFQ (Optional) --</option>
                                                        <c:forEach var="rfq" items="${rfqs}">
                                                            <option value="${rfq.rfqId}">
                                                                RFQ-${rfq.rfqId} - ${rfq.description} - ${rfq.supplierName} (${rfq.status})
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="col-md-4">
                                                    <label class="form-label">&nbsp;</label>
                                                    <div class="btn-group d-block">
                                                        <button type="button" class="btn btn-outline-primary" id="loadRfqItemsBtn" disabled>
                                                            <i class="fas fa-download"></i> Load Items
                                                        </button>
                                                        <button type="button" class="btn btn-outline-secondary" id="clearRfqItemsBtn" disabled>
                                                            <i class="fas fa-times"></i> Clear
                                                        </button>
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
                                                <th style="width: 30%">Product Name</th>
                                                <th style="width: 15%">Product Code</th>
                                                <th style="width: 10%">Unit</th>
                                                <th style="width: 10%">Quantity</th>
                                                <th style="width: 15%">Unit Price</th>
                                                <th style="width: 15%">Total</th>
                                                <th style="width: 5%">Delete</th>
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
                                                    <input type="number" class="form-control price-input" name="unitPrice" min="0" step="0.01" placeholder="Enter unit price" required>
                                                </td>
                                                <td class="total-price">0</td>
                                                <td>
                                                    <button type="button" class="btn btn-sm btn-danger remove-row" onclick="removeRow(this)">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <!-- Add Row Button -->
                                    <div class="btn-add-row">
                                        <button type="button" class="btn btn-success" onclick="addProductRow()">
                                            <i class="fas fa-plus"></i> Add Product
                                        </button>
                                    </div>

                                    <!-- Total Section -->
                                    <div class="total-section">
                                        <div class="row">
                                            <div class="col-md-8"></div>
                                            <div class="col-md-4">
                                                <table class="table table-bordered">
                                                    <tr>
                                                        <td><strong>Total Amount:</strong></td>
                                                        <td><strong><span id="grandTotal">0</span> VND</strong></td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Signature Section -->
                                    <div class="signature-section">
                                        <div class="text-center">
                                            <p><strong>Created By</strong></p>
                                            <br><br>
                                            <p>(Signature, Full Name)</p>
                                        </div>
                                        <div class="text-center">
                                            <p><strong>Delivery Person</strong></p>
                                            <br><br>
                                            <p>(Signature, Full Name)</p>
                                        </div>
                                        <div class="text-center">
                                            <p><strong>Warehouse Keeper</strong></p>
                                            <br><br>
                                            <p>(Signature, Full Name)</p>
                                        </div>
                                        <div class="text-center">
                                            <p><strong>Chief Accountant</strong></p>
                                            <br><br>
                                            <p>(Signature, Full Name)</p>
                                        </div>
                                    </div>

                                    <!-- Action Buttons -->
                                    <div class="text-center mt-4">
                                        <button type="submit" class="btn btn-primary btn-lg me-3">
                                            <i class="fas fa-save"></i> Save Purchase Order
                                        </button>
                                        <a href="${pageContext.request.contextPath}/purchase-order?action=list" class="btn btn-secondary btn-lg">
                                            <i class="fas fa-arrow-left"></i> Back
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </main>

                <footer class="footer">
                    <div class="container-fluid">
                        <div class="row text-muted">
                            <div class="col-6 text-start">
                                <p class="mb-0">
                                    <strong>Warehouse Management System</strong> &copy;
                                </p>
                            </div>
                        </div>
                    </div>
                </footer>
            </div>
        </div>

        <!-- Scripts -->
        <script src="js/app.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                            let rowCounter = 1;
                                            let allProducts = [
            <c:forEach var="product" items="${products}" varStatus="status">
                                            {
                                            "productId": ${product.productId},
                                                    "name": "<c:out value='${product.name}' escapeXml='true'/>",
                                                    "code": "<c:out value='${product.code}' escapeXml='true'/>",
                                                    "unitName": "<c:out value='${product.unitName != null ? product.unitName : "N/A"}' escapeXml='true'/>",
                                                    "price": ${product.price != null ? product.price : 0},
                                                    "supplierId": ${product.supplierId != null ? product.supplierId : 0}
                                            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
                                            ];

                                            // Set current date
                                            document.getElementById('currentDate').textContent = new Date().toLocaleDateString('vi-VN');

                                            // Generate PO number
                                            document.getElementById('poNumber').textContent = new Date().getTime().toString().slice(-6);

                                            // Set minimum date for expected delivery date (today)
                                            const today = new Date().toISOString().split('T')[0];
                                            document.getElementById('expectedDeliveryDate').setAttribute('min', today);

                                            // Handle supplier change
                                            document.getElementById('supplierId').addEventListener('change', function () {
                                                updateProductDropdowns();
                                            });

                                            function updateProductDropdowns() {
                                                const productSelects = document.querySelectorAll('.product-select');
                                                productSelects.forEach(function (select) {
                                                    // Store current selection
                                                    const currentValue = select.value;
                                                    // Clear current options except first
                                                    select.innerHTML = '<option value="">-- Pick product --</option>';
                                                    allProducts.forEach(function (product) {
                                                        const option = document.createElement('option');
                                                        option.value = product.productId;
                                                        option.textContent = product.name;
                                                        option.setAttribute('data-code', product.code);
                                                        option.setAttribute('data-unit', product.unitName);
                                                        option.setAttribute('data-price', product.price);
                                                        select.appendChild(option);
                                                    });
                                                    // Try to restore previous selection if it exists in new options
                                                    if (currentValue) {
                                                        const option = select.querySelector(`option[value="${currentValue}"]`);
                                                        if (option) {
                                                            select.value = currentValue;
                                                            // Don't clear the fields if we restored the selection
                                                            return;
                                                        }
                                                    }
                                                    // Only clear related fields if we couldn't restore the selection
                                                    if (!currentValue || !select.value) {
                                                        const row = select.closest('.product-row');
                                                        row.querySelector('.product-code').textContent = '-';
                                                        row.querySelector('.product-unit').textContent = '-';
                                                        row.querySelector('.price-input').value = '';
                                                        row.querySelector('.quantity-input').value = '';
                                                        row.querySelector('.total-price').textContent = '0';
                                                    }
                                                });
                                                calculateGrandTotal();
                                            }

                                            function populateProductDropdown(select) {
                                                // Clear current options except first
                                                select.innerHTML = '<option value="">-- Select Product --</option>';
                                                allProducts.forEach(function (product) {
                                                    const option = document.createElement('option');
                                                    option.value = product.productId;
                                                    option.textContent = product.name;
                                                    option.setAttribute('data-code', product.code);
                                                    option.setAttribute('data-unit', product.unitName);
                                                    option.setAttribute('data-price', product.price);
                                                    select.appendChild(option);
                                                });
                                            }

                                            function addProductRow() {
                                                rowCounter++;
                                                const tbody = document.getElementById('productTableBody');
                                                const newRow = document.createElement('tr');
                                                newRow.className = 'product-row';
                                                newRow.innerHTML = '<td>' + rowCounter + '</td>' +
                                                        '<td><select class="form-select product-select" name="productId" required>' +
                                                        '<option value="">-- Select Product --</option></select></td>' +
                                                        '<td class="product-code">-</td>' +
                                                        '<td class="product-unit">-</td>' +
                                                        '<td><input type="number" class="form-control quantity-input" name="quantity" min="1" value="1" required></td>' +
                                                        '<td><input type="number" class="form-control price-input" name="unitPrice" min="0" step="0.01" placeholder="Enter unit price" required></td>' +
                                                        '<td class="total-price">0</td>' +
                                                        '<td><button type="button" class="btn btn-sm btn-danger remove-row" onclick="removeRow(this)">' +
                                                        '<i class="fas fa-trash"></i></button></td>';
                                                tbody.appendChild(newRow);
                                                // Populate dropdown for new row only
                                                const newRowSelect = newRow.querySelector('.product-select');
                                                populateProductDropdown(newRowSelect);
                                                // Add event listeners for new row
                                                addRowEventListeners(newRow);
                                            }

                                            function removeRow(button) {
                                                const row = button.closest('tr');
                                                if (document.querySelectorAll('.product-row').length > 1) {
                                                    row.remove();
                                                    updateRowNumbers();
                                                    calculateGrandTotal();
                                                } else {
                                                    alert('Must have at least one product!');
                                                }
                                            }

                                            function updateRowNumbers() {
                                                const rows = document.querySelectorAll('.product-row');
                                                rows.forEach(function (row, index) {
                                                    row.querySelector('td:first-child').textContent = index + 1;
                                                });
                                            }

                                            function addRowEventListeners(row) {
                                                const productSelect = row.querySelector('.product-select');
                                                const quantityInput = row.querySelector('.quantity-input');
                                                const priceInput = row.querySelector('.price-input');

                                                productSelect.addEventListener('change', function () {
                                                    const selectedOption = this.options[this.selectedIndex];
                                                    if (selectedOption.value) {
                                                        // Check if this product already exists in another row
                                                        const existingRow = findExistingProductRow(selectedOption.value, row);

                                                        if (existingRow) {
                                                            // Product already exists, merge quantities
                                                            mergeProductRows(existingRow, row);
                                                            return;
                                                        }

                                                        // Product doesn't exist, populate normally
                                                        row.querySelector('.product-code').textContent = selectedOption.getAttribute('data-code');
                                                        row.querySelector('.product-unit').textContent = selectedOption.getAttribute('data-unit');
                                                        // Set suggested price as placeholder but allow manual input
                                                        if (!priceInput.value) {
                                                            priceInput.placeholder = 'Suggested: ' + selectedOption.getAttribute('data-price') + ' VND';
                                                        }

                                                        // Set default quantity to 1 if empty
                                                        if (!quantityInput.value) {
                                                            quantityInput.value = 1;
                                                        }

                                                        calculateRowTotal(row);
                                                    } else {
                                                        row.querySelector('.product-code').textContent = '-';
                                                        row.querySelector('.product-unit').textContent = '-';
                                                        priceInput.value = '';
                                                        calculateRowTotal(row);
                                                    }
                                                });

                                                quantityInput.addEventListener('input', function () {
                                                    calculateRowTotal(row);
                                                });

                                                priceInput.addEventListener('input', function () {
                                                    calculateRowTotal(row);
                                                });
                                            }

                                            function findExistingProductRow(productId, currentRow) {
                                                const allRows = document.querySelectorAll('.product-row');
                                                for (let row of allRows) {
                                                    if (row !== currentRow) {
                                                        const selectElement = row.querySelector('.product-select');
                                                        if (selectElement && selectElement.value === productId) {
                                                            return row;
                                                        }
                                                    }
                                                }
                                                return null;
                                            }

                                            function mergeProductRows(existingRow, newRow) {
                                                // Get current quantities
                                                const existingQuantity = parseInt(existingRow.querySelector('.quantity-input').value) || 0;
                                                const newQuantity = parseInt(newRow.querySelector('.quantity-input').value) || 1;

                                                // Add quantities together
                                                const totalQuantity = existingQuantity + newQuantity;
                                                existingRow.querySelector('.quantity-input').value = totalQuantity;

                                                // Recalculate total for existing row
                                                calculateRowTotal(existingRow);

                                                // Reset the new row
                                                resetProductRow(newRow);

                                                // Show notification
                                                showMergeNotification(existingRow, totalQuantity);

                                                // Focus on the existing row
                                                existingRow.scrollIntoView({behavior: 'smooth', block: 'center'});
                                                existingRow.style.backgroundColor = '#fff3cd';
                                                setTimeout(() => {
                                                    existingRow.style.backgroundColor = '';
                                                }, 2000);
                                            }

                                            function resetProductRow(row) {
                                                const productSelect = row.querySelector('.product-select');
                                                const quantityInput = row.querySelector('.quantity-input');
                                                const priceInput = row.querySelector('.price-input');

                                                productSelect.value = '';
                                                quantityInput.value = '';
                                                priceInput.value = '';
                                                row.querySelector('.product-code').textContent = '-';
                                                row.querySelector('.product-unit').textContent = '-';
                                                row.querySelector('.total-price').textContent = '0';
                                            }

                                            function showMergeNotification(row, totalQuantity) {
                                                // Create a temporary notification
                                                const notification = document.createElement('div');
                                                notification.className = 'alert alert-info alert-dismissible fade show position-fixed';
                                                notification.style.cssText = 'top: 20px; right: 20px; z-index: 9999; max-width: 400px;';
                                                notification.innerHTML = `
                    <i class="fas fa-info-circle"></i>
                    <strong>Product merged!</strong> New quantity: ${totalQuantity}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                `;

                                                document.body.appendChild(notification);

                                                // Auto remove after 3 seconds
                                                setTimeout(() => {
                                                    if (notification.parentNode) {
                                                        notification.remove();
                                                    }
                                                }, 1500);
                                            }

                                            function calculateRowTotal(row) {
                                                const quantity = parseFloat(row.querySelector('.quantity-input').value) || 0;
                                                const price = parseFloat(row.querySelector('.price-input').value) || 0;
                                                const total = quantity * price;

                                                row.querySelector('.total-price').textContent = total.toLocaleString('vi-VN');
                                                calculateGrandTotal();
                                            }

                                            function calculateGrandTotal() {
                                                let grandTotal = 0;
                                                document.querySelectorAll('.product-row').forEach(function (row) {
                                                    const quantity = parseFloat(row.querySelector('.quantity-input').value) || 0;
                                                    const price = parseFloat(row.querySelector('.price-input').value) || 0;
                                                    grandTotal += quantity * price;
                                                });

                                                document.getElementById('grandTotal').textContent = grandTotal.toLocaleString('vi-VN');
                                            }

                                            // Initialize event listeners for first row
                                            document.addEventListener('DOMContentLoaded', function () {
                                                addRowEventListeners(document.querySelector('.product-row'));
                                            });

                                            // Expected delivery date validation
                                            document.getElementById('expectedDeliveryDate').addEventListener('change', function () {
                                                validateExpectedDeliveryDate();
                                            });

                                            function validateExpectedDeliveryDate() {
                                                const expectedDateInput = document.getElementById('expectedDeliveryDate');
                                                const dateError = document.getElementById('dateError');
                                                const selectedDate = new Date(expectedDateInput.value);
                                                const today = new Date();
                                                today.setHours(0, 0, 0, 0);

                                                if (expectedDateInput.value && selectedDate < today) {
                                                    expectedDateInput.classList.add('is-invalid');
                                                    dateError.textContent = 'Expected delivery date cannot be in the past!';
                                                    return false;
                                                } else {
                                                    expectedDateInput.classList.remove('is-invalid');
                                                    dateError.textContent = '';
                                                    return true;
                                                }
                                            }

                                            // Form validation
                                            document.getElementById('purchaseOrderForm').addEventListener('submit', function (e) {
                                                const rows = document.querySelectorAll('.product-row');
                                                let hasValidProduct = false;

                                                rows.forEach(function (row) {
                                                    const productSelect = row.querySelector('.product-select');
                                                    const quantity = row.querySelector('.quantity-input').value;
                                                    const price = row.querySelector('.price-input').value;

                                                    if (productSelect.value && quantity && price) {
                                                        hasValidProduct = true;
                                                    }
                                                });

                                                if (!hasValidProduct) {
                                                    e.preventDefault();
                                                    alert('Please add at least one valid product!');
                                                    return;
                                                }

                                                // Validate expected delivery date
                                                if (!validateExpectedDeliveryDate()) {
                                                    e.preventDefault();
                                                    alert('Please select a valid expected delivery date!');
                                                    return;
                                                }
                                            });

                                            // RFQ handling functionality
                                            document.addEventListener('DOMContentLoaded', function () {
                                                const rfqSelect = document.getElementById('rfqSelect');
                                                const loadRfqItemsBtn = document.getElementById('loadRfqItemsBtn');
                                                const clearRfqItemsBtn = document.getElementById('clearRfqItemsBtn');

                                                // Handle RFQ dropdown change
                                                rfqSelect.addEventListener('change', function () {
                                                    const isSelected = this.value !== '';
                                                    loadRfqItemsBtn.disabled = !isSelected;
                                                    clearRfqItemsBtn.disabled = !isSelected;
                                                });

                                                // Handle Load Items button
                                                loadRfqItemsBtn.addEventListener('click', function () {
                                                    const rfqId = rfqSelect.value;
                                                    if (rfqId) {
                                                        loadRfqItems(rfqId);
                                                    }
                                                });

                                                // Handle Clear button
                                                clearRfqItemsBtn.addEventListener('click', function () {
                                                    clearRfqItems();
                                                    rfqSelect.value = '';
                                                    loadRfqItemsBtn.disabled = true;
                                                    clearRfqItemsBtn.disabled = true;
                                                });
                                            });

                                            function loadRfqItems(rfqId) {
                                                // Show loading state
                                                const loadBtn = document.getElementById('loadRfqItemsBtn');
                                                const originalText = loadBtn.innerHTML;
                                                loadBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Loading...';
                                                loadBtn.disabled = true;

                                                // Make AJAX request
                                                fetch('${pageContext.request.contextPath}/purchase/purchase-order?action=get-rfq-details&rfqId=' + rfqId, {
                                                    method: 'GET',
                                                    headers: {
                                                        'Content-Type': 'application/json',
                                                    }
                                                })
                                                        .then(response => response.json())
                                                        .then(data => {
                                                            if (data.success) {
                                                                // Set supplier
                                                                const supplierSelect = document.getElementById('supplierId');
                                                                supplierSelect.value = data.rfq.supplierId;

                                                                // Update product dropdowns with new supplier
                                                                updateProductDropdowns();

                                                                // Set expected delivery date if available
                                                                if (data.rfq.expectedDeliveryDate) {
                                                                    document.getElementById('expectedDeliveryDate').value = data.rfq.expectedDeliveryDate;
                                                                }

                                                                // Clear existing product rows
                                                                clearProductTable();

                                                                // Add products from RFQ
                                                                data.items.forEach((item, index) => {
                                                                    if (index === 0) {
                                                                        // Use first row
                                                                        addProductRowFromRfq(item, document.querySelector('.product-row'));
                                                                    } else {
                                                                        // Add new row
                                                                        addProductRow();
                                                                        const newRow = document.querySelector('.product-row:last-child');
                                                                        addProductRowFromRfq(item, newRow);
                                                                    }
                                                                });

                                                                showSuccessMessage('RFQ items loaded successfully!');
                                                            } else {
                                                                showErrorMessage('Error loading RFQ: ' + data.message);
                                                            }
                                                        })
                                                        .catch(error => {
                                                            console.error('Error:', error);
                                                            showErrorMessage('An error occurred while loading RFQ items');
                                                        })
                                                        .finally(() => {
                                                            // Restore button state
                                                            loadBtn.innerHTML = originalText;
                                                            loadBtn.disabled = false;
                                                        });
                                            }

                                            function clearRfqItems() {
                                                // Clear supplier selection
                                                document.getElementById('supplierId').value = '';

                                                // Update product dropdowns (clear them)
                                                updateProductDropdowns();

                                                // Clear expected delivery date
                                                document.getElementById('expectedDeliveryDate').value = '';

                                                // Clear product table
                                                clearProductTable();

                                                showSuccessMessage('RFQ reference cleared. You can now enter products manually.');
                                            }

                                            function clearProductTable() {
                                                const tbody = document.getElementById('productTableBody');
                                                // Remove all rows except the first one
                                                const rows = tbody.querySelectorAll('.product-row');
                                                for (let i = rows.length - 1; i > 0; i--) {
                                                    rows[i].remove();
                                                }

                                                // Reset the first row
                                                const firstRow = tbody.querySelector('.product-row');
                                                resetProductRow(firstRow);

                                                // Reset row counter
                                                rowCounter = 1;
                                                firstRow.querySelector('td:first-child').textContent = '1';

                                                calculateGrandTotal();
                                            }

                                            function addProductRowFromRfq(item, row) {
                                                // Set product selection
                                                const productSelect = row.querySelector('.product-select');
                                                productSelect.value = item.productId;

                                                // Trigger change event to populate other fields
                                                const changeEvent = new Event('change');
                                                productSelect.dispatchEvent(changeEvent);

                                                // Set quantity
                                                row.querySelector('.quantity-input').value = item.quantity;

                                                // Calculate total
                                                calculateRowTotal(row);
                                            }

                                            function showSuccessMessage(message) {
                                                showNotification(message, 'success');
                                            }

                                            function showErrorMessage(message) {
                                                showNotification(message, 'error');
                                            }

                                            function showNotification(message, type) {
                                                const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
                                                const iconClass = type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle';

                                                const notification = document.createElement('div');
                                                notification.className = 'alert ' + alertClass + ' alert-dismissible fade show position-fixed';
                                                notification.style.cssText = 'top: 20px; right: 20px; z-index: 9999; max-width: 400px;';
                                                notification.innerHTML =
                                                        '<i class="fas ' + iconClass + '"></i> ' +
                                                        '<strong>' + message + '</strong>' +
                                                        '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';

                                                document.body.appendChild(notification);

                                                // Auto remove after 4 seconds
                                                setTimeout(() => {
                                                    if (notification.parentNode) {
                                                        notification.remove();
                                                    }
                                                }, 4000);
                                            }
        </script>
    </body>
</html>