<%-- 
    Document   : customer-Quote
    Created on : Jul 1, 2025, 8:42:40 PM
    Author     : nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Product, model.Customer, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Create Quotation | Warehouse System</title>
    <link href="css/light.css" rel="stylesheet">
    <script src="js/settings.js"></script>
    <!-- Select2 CSS for searchable select -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
</head>
<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
    <div class="wrapper">
        <jsp:include page="/sale/SalesSidebar.jsp" />
        <div class="main">
            <jsp:include page="/sale/navbar.jsp" />
            <main class="content">
                <div class="container-fluid p-0">
                    <%-- Hiển thị thông báo lỗi nếu có --%>
                    <%
                        String error = (String) request.getAttribute("error");
                        if (error != null && !error.isEmpty()) {
                    %>
                    <div class="alert alert-danger alert-dismissible" role="alert">
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        <div class="alert-message"><%= error %></div>
                    </div>
                    <% } %>
                    <div class="row mb-3">
                        <div class="col-6">
                            <h1 class="h2 mb-3 fw-bold text-primary">Create Quotation</h1>
                        </div>
                        <div class="col-6 text-end">
                            <a href="listCustomerQuote" class="btn btn-secondary me-2">
                                <i class="align-middle" data-feather="arrow-left"></i> Back to List
                            </a>
                        </div>
                    </div>
                    <!-- FORM TẠO BÁO GIÁ -->
                    <div class="row">
                        <div class="col-12">
                            <div class="card shadow-sm">
                                <div class="card-header pb-0 border-bottom-0">
                                    <h5 class="card-title mb-0 fw-semibold">Quotation Information</h5>
                                    <hr class="mt-2 mb-0">
                                </div>
                                <div class="card-body pt-3">
                                    <form action="createCustomerQuote" method="post" id="quotationForm">
                                        <div class="row mb-3 align-items-center">
                                            <!-- Chọn khách hàng với tìm kiếm -->
                                            <div class="col-md-4">
                                                <label class="form-label fw-medium">Customer *</label>
                                                <select class="form-select" name="customerId" id="customerSelect" required>
                                                    <option value="">-- Select Customer --</option>
                                                    <%
                                                        List<Customer> customers = (List<Customer>)request.getAttribute("customers");
                                                        if (customers != null) {
                                                            for (Customer c : customers) {
                                                    %>
                                                    <option value="<%=c.getCustomerId()%>"><%=c.getCustomerName()%></option>
                                                    <% }} %>
                                                </select>
                                            </div>
                                            <!-- Ngày hết hạn báo giá -->
                                            <div class="col-md-4">
                                                <label class="form-label fw-medium">Quotation Expiration Date*</label>
                                                <input type="date" class="form-control" name="validUntil" id="validUntil" required>
                                            </div>
                                            <!-- Ghi chú -->
                                            <div class="col-md-4">
                                                <label class="form-label fw-medium">Notes</label>
                                                <input type="text" class="form-control" name="notes" maxlength="255" required>
                                            </div>
                                        </div>
                                        <!-- BẢNG SẢN PHẨM TRONG BÁO GIÁ -->
                                        <div class="card mt-4 mb-3">
                                            <div class="card-header">
                                                <h5 class="mb-0">Quotation Items</h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="table-responsive">
                                                    <table class="table table-bordered" id="quoteItemsTable">
                                                        <thead>
                                                            <tr>
                                                                <th style="width: 30%">Product</th>
                                                                <th>Quantity</th>
                                                                <th>Unit Price</th>
                                                                <th>Tax (10%)</th>
                                                                <th>Total</th>
                                                                <th style="width: 80px">Actions</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody id="quoteItemsBody">
                                                            <tr class="quote-row">
                                                                <td>
                                                                    <select class="form-select product-select" name="productId" required>
                                                                        <option value="">-- Select Product --</option>
                                                                        <%
                                                                            List<Product> products = (List<Product>)request.getAttribute("products");
                                                                            if (products != null) {
                                                                                for (Product p : products) {
                                                                        %>
                                                                        <option value="<%=p.getProductId()%>" data-price="<%=p.getPrice()%>"><%=p.getName()%></option>
                                                                        <% }} %>
                                                                    </select>
                                                                </td>
                                                                <td>
                                                                    <input type="number" class="form-control quantity-input" name="quantity" min="1" value="1" required>
                                                                </td>
                                                                <td>
                                                                    <input type="text" class="form-control unitprice-input" name="unitPrice" min="0" step="1000" value="0" required>
                                                                </td>
                                                                <td>
                                                                    <input type="text" class="form-control tax-input" name="tax" value="0" readonly>
                                                                </td>
                                                                <td>
                                                                    <input type="text" class="form-control totalprice-input" name="totalPrice" value="0" readonly>
                                                                </td>
                                                                <td class="text-center">
                                                                    <button type="button" class="btn btn-sm btn-outline-danger remove-quote" style="display: none;">
                                                                        <i data-feather="trash-2"></i>
                                                                    </button>
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                    <div class="mt-3">
                                                        <button type="button" class="btn btn-primary" id="addQuoteItemBtn">
                                                            <i data-feather="plus"></i> Add Product
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- TỔNG TIỀN -->
                                        <div class="row mb-3">
                                            <div class="col-md-4 offset-md-8 text-end">
                                                <label class="fw-bold">Total Amount: </label>
                                                <input type="text" class="form-control d-inline-block w-auto" id="grandTotal" name="totalAmount" value="0" readonly>
                                            </div>
                                        </div>
                                        <!-- NÚT LƯU/BỎ QUA -->
                                        <div class="row mt-4">
                                            <div class="col-12 text-end">
                                                <button type="button" class="btn btn-secondary btn-lg me-2" onclick="window.location.href='listCustomerQuote'">
                                                    Cancel
                                                </button>
                                                <button type="submit" class="btn btn-success btn-lg px-4">
                                                    <i class="align-middle me-1" data-feather="plus-circle"></i> Save Quotation
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
                <jsp:include page="/sale/footer.jsp" />
            </footer>
        </div>
    </div>
    <!-- JS & Thư viện hỗ trợ -->
    <script src="js/app.js"></script>
    <!-- jQuery và Select2 cho ô tìm kiếm khách hàng -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script>
        // Khởi tạo Select2 cho ô chọn khách hàng
        $(document).ready(function() {
            $('#customerSelect').select2({
                width: '100%',
                placeholder: '-- Select Customer --',
                allowClear: true
            });
        });

        document.addEventListener("DOMContentLoaded", function() {
            feather.replace();
            // ====== HÀM HỖ TRỢ ĐỊNH DẠNG SỐ ======
            function formatNumber(num) {
                return num.toLocaleString('vi-VN');
            }

            // ====== ĐẶT NGÀY HẾT HẠN MẶC ĐỊNH ======
            function setDefaultExpirationDate() {
                const today = new Date();
                if (isNaN(today.getTime())) return;
                const expirationDate = new Date(today);
                expirationDate.setDate(today.getDate() + 15);
                if (isNaN(expirationDate.getTime())) return;
                const year = expirationDate.getFullYear();
                const month = String(expirationDate.getMonth() + 1).padStart(2, '0');
                const day = String(expirationDate.getDate()).padStart(2, '0');
                const formattedDate = year + '-' + month + '-' + day;
                document.getElementById('validUntil').value = formattedDate;
            }
            setDefaultExpirationDate();

            // ====== QUẢN LÝ DÒNG SẢN PHẨM ======
            function createQuoteRow() {
                const template = document.querySelector('.quote-row').cloneNode(true);
                template.querySelector('.remove-quote').style.display = 'block';
                template.querySelector('.product-select').value = '';
                template.querySelector('.quantity-input').value = '1';
                template.querySelector('.unitprice-input').value = '0';
                template.querySelector('.tax-input').value = '0';
                template.querySelector('.totalprice-input').value = '0';
                return template;
            }
            document.getElementById('addQuoteItemBtn').addEventListener('click', function() {
                const tbody = document.getElementById('quoteItemsBody');
                const newRow = createQuoteRow();
                tbody.appendChild(newRow);
                feather.replace();
            });
            document.addEventListener('click', function(e) {
                if (e.target.closest('.remove-quote')) {
                    const row = e.target.closest('.quote-row');
                    if (document.querySelectorAll('.quote-row').length > 1) {
                        row.remove();
                        updateGrandTotal();
                    }
                }
            });

            // ====== TÍNH TOÁN TAX VÀ TOTAL KHI NHẬP GIÁ HOẶC SỐ LƯỢNG ======
            document.addEventListener('input', function(e) {
                if (e.target.classList.contains('quantity-input') || e.target.classList.contains('unitprice-input')) {
                    const row = e.target.closest('.quote-row');
                    const qty = parseInt(row.querySelector('.quantity-input').value) || 0;
                    const price = parseFloat((row.querySelector('.unitprice-input').value + '').replace(/\./g, '')) || 0;
                    const tax = qty * price * 0.1;
                    const total = qty * price * 1.1;
                    row.querySelector('.tax-input').value = formatNumber(tax);
                    row.querySelector('.totalprice-input').value = formatNumber(total);
                    updateGrandTotal();
                }
            });
            // ====== CẬP NHẬT GRAND TOTAL ======
            function updateGrandTotal() {
                let total = 0;
                document.querySelectorAll('.totalprice-input').forEach(function(el) {
                    total += parseFloat((el.value + '').replace(/\./g, '')) || 0;
                });
                document.getElementById('grandTotal').value = formatNumber(total);
            }

            // ====== VALIDATE FORM KHI SUBMIT ======
            document.getElementById('quotationForm').addEventListener('submit', function(e) {
                const rows = document.querySelectorAll('.quote-row');
                let isValid = true;
                rows.forEach(row => {
                    const productSelect = row.querySelector('.product-select');
                    const quantity = row.querySelector('.quantity-input');
                    const unitPrice = row.querySelector('.unitprice-input');
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
                    if (!unitPrice.value || parseFloat(unitPrice.value) <= 0) {
                        e.preventDefault();
                        alert('Unit price must be greater than 0 for all items');
                        isValid = false;
                        return;
                    }
                });
                if (!isValid) e.preventDefault();
                // Kiểm tra giá ngoài khoảng cho Unit Price
                let validPrice = true;
                document.querySelectorAll('.quote-row').forEach(function(row) {
                    const unitPriceInput = row.querySelector('.unitprice-input');
                    const min = parseFloat(unitPriceInput.min) || 0;
                    const max = parseFloat(unitPriceInput.max) || 0;
                    let value = parseFloat((unitPriceInput.value + '').replace(/\./g, ''));
                    if (isNaN(value) || min === 0) return;
                    if ((min && value < min) || (max && value > max)) {
                        alert('Unit price must be between base price and base price x 1.3 for all items!');
                        unitPriceInput.value = unitPriceInput.getAttribute('data-original-price');
                        validPrice = false;
                    }
                });
                if (!validPrice) {
                    e.preventDefault();
                    return false;
                }
                // Định dạng lại số trước khi submit
                document.querySelectorAll('.unitprice-input').forEach(function(input) {
                    input.value = (input.value + '').replace(/\./g, '');
                });
                document.querySelectorAll('.totalprice-input').forEach(function(input) {
                    input.value = (input.value + '').replace(/\./g, '');
                });
                document.getElementById('grandTotal').value = (document.getElementById('grandTotal').value + '').replace(/\./g, '');
            });

            // ====== KHI CHỌN SẢN PHẨM, SET GIÁ, TAX, TOTAL ======
            document.addEventListener('change', function(e) {
                if (e.target.classList.contains('product-select')) {
                    const row = e.target.closest('.quote-row');
                    const selectedOption = e.target.selectedOptions[0];
                    const basePrice = parseFloat(selectedOption.getAttribute('data-price')) || 0;
                    const unitPriceInput = row.querySelector('.unitprice-input');
                    if (basePrice > 0) {
                        const maxPrice = Math.round(basePrice * 1.3);
                        unitPriceInput.value = formatNumber(maxPrice);
                        unitPriceInput.min = basePrice;
                        unitPriceInput.max = maxPrice;
                        unitPriceInput.setAttribute('data-original-price', formatNumber(maxPrice));
                    } else {
                        unitPriceInput.value = 0;
                        unitPriceInput.min = 0;
                        unitPriceInput.max = '';
                        unitPriceInput.setAttribute('data-original-price', 0);
                    }
                    // Cập nhật lại tổng tiền dòng và thuế
                    const qty = parseInt(row.querySelector('.quantity-input').value) || 0;
                    const price = parseFloat((unitPriceInput.value + '').replace(/\./g, '')) || 0;
                    const tax = qty * price * 0.1;
                    const total = qty * price * 1.1;
                    row.querySelector('.tax-input').value = formatNumber(tax);
                    row.querySelector('.totalprice-input').value = formatNumber(total);
                    updateGrandTotal();
                }
            });

            // ====== KIỂM TRA GIÁ HỢP LỆ KHI BLUR HOẶC ENTER ======
            document.addEventListener('blur', function(e) {
                if (e.target.classList.contains('unitprice-input')) {
                    const input = e.target;
                    const min = parseFloat(input.min) || 0;
                    const max = parseFloat(input.max) || 0;
                    let value = parseFloat((input.value + '').replace(/\./g, ''));
                    const original = input.getAttribute('data-original-price');
                    if (isNaN(value) || min === 0) return;
                    if ((min && value < min) || (max && value > max)) {
                        alert('Unit price must be between base price and base price x 1.3!');
                        input.value = original;
                        setTimeout(() => input.focus(), 0);
                    }
                }
            }, true);
            document.addEventListener('keydown', function(e) {
                if (
                    e.target.classList.contains('unitprice-input') &&
                    (e.key === 'Enter' || e.keyCode === 13)
                ) {
                    const input = e.target;
                    const min = parseFloat(input.min) || 0;
                    const max = parseFloat(input.max) || 0;
                    let value = parseFloat((input.value + '').replace(/\./g, ''));
                    const original = input.getAttribute('data-original-price');
                    if (isNaN(value) || min === 0) return;
                    if ((min && value < min) || (max && value > max)) {
                        alert('Unit price must be between base price and base price x 1.3!');
                        input.value = original;
                        e.preventDefault();
                        setTimeout(() => input.focus(), 0);
                    }
                }
            });
        });
    </script>
</body>
</html>
