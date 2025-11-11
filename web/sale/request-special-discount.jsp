<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Request Special Discount | Warehouse System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
    <style>
        .info-card {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
            border: 2px solid #ffc107;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .form-control:focus, .form-select:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }
        .required { color: #dc3545; }
    </style>
</head>
<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
    <div class="wrapper">
        <jsp:include page="/sale/SalesSidebar.jsp" />
        <div class="main">
            <jsp:include page="/sale/navbar.jsp" />
            <main class="content">
                <div class="container-fluid p-0">
                    <!-- Page Header -->
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h1 class="h2 fw-bold text-primary">Request Special Discount</h1>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="dashboard">Dashboard</a></li>
                                    <li class="breadcrumb-item active">Special Discount Request</li>
                                </ol>
                            </nav>
                        </div>
                        <div>
                            <a href="my-special-requests" class="btn btn-outline-info">
                                <i class="fas fa-list me-1"></i>My Requests
                            </a>
                        </div>
                    </div>

                    <!-- Info Card -->
                    <div class="info-card">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-info-circle fa-2x text-warning me-3"></i>
                            <div>
                                <h6 class="mb-1">Special Discount Request</h6>
                                <p class="mb-0">
                                    Use this form to request special discounts for VIP customers or exceptional cases. 
                                    All requests require manager approval and will be reviewed within 24 hours.
                                </p>
                            </div>
                        </div>
                    </div>

                    <!-- Messages -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong>Error!</strong> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Request Form -->
                    <div class="row">
                        <div class="col-lg-8 mx-auto">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-percentage me-2"></i>Special Discount Request Form
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <form method="post" action="request-special-discount" id="requestForm">
                                        <div class="mb-3">
                                            <label for="customerId" class="form-label">Customer <span class="required">*</span></label>
                                            <select class="form-select" id="customerId" name="customerId" required>
                                                <option value="">-- Select Customer --</option>
                                                <c:forEach var="customer" items="${customers}">
                                                    <option value="${customer.customerId}">
                                                        ${customer.customerName}
                                                        <c:if test="${not empty customer.email}"> - ${customer.email}</c:if>
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <div class="form-text">Select the customer for this special discount</div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label for="discountType" class="form-label">Discount Type <span class="required">*</span></label>
                                                <select class="form-select" id="discountType" name="discountType" required onchange="updateDiscountType()">
                                                    <option value="">Select Type</option>
                                                    <option value="PERCENTAGE">Percentage (%)</option>
                                                    <option value="FIXED_AMOUNT">Fixed Amount (₫)</option>
                                                </select>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="discountValue" class="form-label">Discount Value <span class="required">*</span></label>
                                                <div class="input-group">
                                                    <input type="number" class="form-control" id="discountValue" name="discountValue" 
                                                           min="0" step="0.01" required>
                                                    <span class="input-group-text" id="valueUnit">₫</span>
                                                </div>
                                                <div class="form-text" id="valueHelp">Enter the discount amount</div>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label for="estimatedOrderValue" class="form-label">Estimated Order Value</label>
                                            <div class="input-group">
                                                <input type="number" class="form-control" id="estimatedOrderValue" name="estimatedOrderValue" 
                                                       min="0" step="1000" placeholder="Optional">
                                                <span class="input-group-text">₫</span>
                                            </div>
                                            <div class="form-text">Estimated value of the order this discount will be applied to</div>
                                        </div>

                                        <div class="mb-3">
                                            <label for="reason" class="form-label">Reason for Special Discount <span class="required">*</span></label>
                                            <textarea class="form-control" id="reason" name="reason" rows="4" 
                                                      maxlength="500" required placeholder="Please provide a detailed reason for this special discount request..."></textarea>
                                            <div class="form-text">
                                                <span id="reasonCount">0</span>/500 characters. 
                                                Please provide a clear justification for the manager's review.
                                            </div>
                                        </div>

                                        <!-- Preview Section -->
                                        <div class="alert alert-info" id="previewSection" style="display: none;">
                                            <h6 class="mb-2">
                                                <i class="fas fa-eye me-1"></i>Request Preview
                                            </h6>
                                            <div id="previewContent"></div>
                                        </div>

                                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                            <a href="dashboard" class="btn btn-outline-secondary me-md-2">Cancel</a>
                                            <button type="submit" class="btn btn-warning">
                                                <i class="fas fa-paper-plane me-1"></i>Submit Request
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="/sale/footer.jsp" />
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/feather-icons"></script>
    <script src="js/app.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            updateDiscountType();
            setupFormValidation();
        });

        function updateDiscountType() {
            const discountType = document.getElementById('discountType').value;
            const valueUnit = document.getElementById('valueUnit');
            const valueHelp = document.getElementById('valueHelp');
            const discountValueInput = document.getElementById('discountValue');
            
            if (discountType === 'PERCENTAGE') {
                valueUnit.textContent = '%';
                valueHelp.textContent = 'Enter percentage (0-100)';
                discountValueInput.max = '100';
                discountValueInput.placeholder = 'e.g., 15';
            } else if (discountType === 'FIXED_AMOUNT') {
                valueUnit.textContent = '₫';
                valueHelp.textContent = 'Enter fixed amount in VND';
                discountValueInput.max = '';
                discountValueInput.placeholder = 'e.g., 50000';
            } else {
                valueUnit.textContent = '₫';
                valueHelp.textContent = 'Enter the discount amount';
                discountValueInput.max = '';
                discountValueInput.placeholder = '';
            }
            
            updatePreview();
        }

        function setupFormValidation() {
            const reasonTextarea = document.getElementById('reason');
            const reasonCount = document.getElementById('reasonCount');
            
            // Character counter
            reasonTextarea.addEventListener('input', function() {
                const length = this.value.length;
                reasonCount.textContent = length;
                
                if (length > 450) {
                    reasonCount.style.color = '#dc3545';
                } else if (length > 350) {
                    reasonCount.style.color = '#ffc107';
                } else {
                    reasonCount.style.color = '#28a745';
                }
                
                updatePreview();
            });
            
            // Form inputs change event
            document.querySelectorAll('#requestForm input, #requestForm select, #requestForm textarea').forEach(function(element) {
                element.addEventListener('change', updatePreview);
                element.addEventListener('input', updatePreview);
            });
        }

        function updatePreview() {
            const customerId = document.getElementById('customerId').value;
            const customerName = customerId ? document.getElementById('customerId').selectedOptions[0].text : '';
            const discountType = document.getElementById('discountType').value;
            const discountValue = document.getElementById('discountValue').value;
            const estimatedOrderValue = document.getElementById('estimatedOrderValue').value;
            const reason = document.getElementById('reason').value;
            
            const previewSection = document.getElementById('previewSection');
            const previewContent = document.getElementById('previewContent');
            
            if (customerId && discountType && discountValue && reason) {
                let preview = '<div class="row">';
                preview += '<div class="col-md-6">';
                preview += '<strong>Customer:</strong> ' + customerName + '<br>';
                preview += '<strong>Discount Type:</strong> ' + (discountType === 'PERCENTAGE' ? 'Percentage' : 'Fixed Amount') + '<br>';
                preview += '<strong>Discount Value:</strong> ';
                
                if (discountType === 'PERCENTAGE') {
                    preview += discountValue + '%';
                } else {
                    preview += new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(discountValue);
                }
                
                preview += '</div>';
                preview += '<div class="col-md-6">';
                
                if (estimatedOrderValue) {
                    preview += '<strong>Est. Order Value:</strong> ' + 
                              new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(estimatedOrderValue) + '<br>';
                    
                    // Calculate estimated discount
                    let estimatedDiscount = 0;
                    if (discountType === 'PERCENTAGE') {
                        estimatedDiscount = estimatedOrderValue * discountValue / 100;
                    } else {
                        estimatedDiscount = Math.min(discountValue, estimatedOrderValue);
                    }
                    preview += '<strong>Est. Discount:</strong> ' + 
                              new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(estimatedDiscount) + '<br>';
                    preview += '<strong>Est. Final Amount:</strong> ' + 
                              new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(estimatedOrderValue - estimatedDiscount);
                }
                
                preview += '</div>';
                preview += '</div>';
                preview += '<div class="mt-2"><strong>Reason:</strong> ' + reason.substring(0, 100) + (reason.length > 100 ? '...' : '') + '</div>';
                
                previewContent.innerHTML = preview;
                previewSection.style.display = 'block';
            } else {
                previewSection.style.display = 'none';
            }
        }

        // Form submission validation
        document.getElementById('requestForm').addEventListener('submit', function(e) {
            const discountType = document.getElementById('discountType').value;
            const discountValue = parseFloat(document.getElementById('discountValue').value);
            
            if (discountType === 'PERCENTAGE' && discountValue > 100) {
                e.preventDefault();
                alert('Percentage discount cannot be more than 100%');
                return false;
            }
            
            if (discountValue <= 0) {
                e.preventDefault();
                alert('Discount value must be greater than 0');
                return false;
            }
        });
    </script>
</body>
</html>