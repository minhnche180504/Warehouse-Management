<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Create Discount Code | Warehouse System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
    <style>
        .preview-card {
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            border: 2px solid #2196f3;
            border-radius: 12px;
            padding: 20px;
            margin-top: 20px;
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
        <jsp:include page="/manager/ManagerSidebar.jsp" />
        <div class="main">
            <jsp:include page="/manager/navbar.jsp" />
            <main class="content">
                <div class="container-fluid p-0">
                    <!-- Page Header -->
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h1 class="h2 fw-bold text-primary">Create Discount Code</h1>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="manager-dashboard">Dashboard</a></li>
                                    <li class="breadcrumb-item"><a href="discount-codes">Discount Codes</a></li>
                                    <li class="breadcrumb-item active">Create New</li>
                                </ol>
                            </nav>
                        </div>
                        <div>
                            <a href="discount-codes" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-1"></i>Back to List
                            </a>
                        </div>
                    </div>

                    <!-- Messages -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong>Error!</strong> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Create Form -->
                    <div class="row">
                        <div class="col-lg-8">
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-plus-circle me-2"></i>New Discount Code
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <form method="post" action="create-discount-code" id="createForm">
                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label for="code" class="form-label">Discount Code <span class="required">*</span></label>
                                                <input type="text" class="form-control" id="code" name="code" 
                                                       value="${formData['code'][0]}" maxlength="20" required 
                                                       placeholder="e.g., SUMMER2025" onchange="updatePreview()">
                                                <div class="form-text">Unique code (max 20 characters)</div>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="name" class="form-label">Campaign Name <span class="required">*</span></label>
                                                <input type="text" class="form-control" id="name" name="name" 
                                                       value="${formData['name'][0]}" maxlength="100" required 
                                                       placeholder="e.g., Summer Sale 2025" onchange="updatePreview()">
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label for="description" class="form-label">Description</label>
                                            <textarea class="form-control" id="description" name="description" 
                                                      rows="3" maxlength="500" placeholder="Optional description for this discount...">${formData['description'][0]}</textarea>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label for="discountType" class="form-label">Discount Type <span class="required">*</span></label>
                                                <select class="form-select" id="discountType" name="discountType" required onchange="updateDiscountType()">
                                                    <option value="">Select Type</option>
                                                    <option value="PERCENTAGE" ${formData['discountType'][0] == 'PERCENTAGE' ? 'selected' : ''}>Percentage (%)</option>
                                                    <option value="FIXED_AMOUNT" ${formData['discountType'][0] == 'FIXED_AMOUNT' ? 'selected' : ''}>Fixed Amount (₫)</option>
                                                </select>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="discountValue" class="form-label">Discount Value <span class="required">*</span></label>
                                                <div class="input-group">
                                                    <input type="number" class="form-control" id="discountValue" name="discountValue" 
                                                           value="${formData['discountValue'][0]}" min="0" step="0.01" required onchange="updatePreview()">
                                                    <span class="input-group-text" id="valueUnit">₫</span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label for="minOrderAmount" class="form-label">Minimum Order Amount</label>
                                                <div class="input-group">
                                                    <input type="number" class="form-control" id="minOrderAmount" name="minOrderAmount" 
                                                           value="${formData['minOrderAmount'][0]}" min="0" step="1000" onchange="updatePreview()">
                                                    <span class="input-group-text">₫</span>
                                                </div>
                                                <div class="form-text">Leave empty for no minimum</div>
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="maxDiscountAmount" class="form-label">Maximum Discount Amount</label>
                                                <div class="input-group">
                                                    <input type="number" class="form-control" id="maxDiscountAmount" name="maxDiscountAmount" 
                                                           value="${formData['maxDiscountAmount'][0]}" min="0" step="1000" onchange="updatePreview()">
                                                    <span class="input-group-text">₫</span>
                                                </div>
                                                <div class="form-text">For percentage discounts only</div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 mb-3">
                                                <label for="startDate" class="form-label">Start Date <span class="required">*</span></label>
                                                <input type="date" class="form-control" id="startDate" name="startDate" 
                                                       value="${formData['startDate'][0]}" required onchange="updatePreview()">
                                            </div>
                                            <div class="col-md-6 mb-3">
                                                <label for="endDate" class="form-label">End Date <span class="required">*</span></label>
                                                <input type="date" class="form-control" id="endDate" name="endDate" 
                                                       value="${formData['endDate'][0]}" required onchange="updatePreview()">
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label for="usageLimit" class="form-label">Usage Limit</label>
                                            <input type="number" class="form-control" id="usageLimit" name="usageLimit" 
                                                   value="${formData['usageLimit'][0]}" min="1" onchange="updatePreview()">
                                            <div class="form-text">Leave empty for unlimited usage</div>
                                        </div>

                                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                            <a href="discount-codes" class="btn btn-outline-secondary me-md-2">Cancel</a>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save me-1"></i>Create Discount Code
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Preview Card -->
                        <div class="col-lg-4">
                            <div class="preview-card">
                                <h6 class="fw-bold mb-3">
                                    <i class="fas fa-eye me-2"></i>Preview
                                </h6>
                                <div id="previewContent">
                                    <div class="fw-bold text-primary mb-2" id="previewCode">-</div>
                                    <div class="fw-medium mb-2" id="previewName">-</div>
                                    <div class="mb-2">
                                        <span class="badge bg-info" id="previewType">-</span>
                                        <span class="ms-2 fw-bold text-success" id="previewValue">-</span>
                                    </div>
                                    <div class="small text-muted mb-2" id="previewConditions">-</div>
                                    <div class="small text-muted" id="previewDuration">-</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="/manager/footer.jsp" />
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/feather-icons"></script>
    <script src="js/app.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Set today as minimum start date
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('startDate').min = today;
            
            // Set start date to today if empty
            if (!document.getElementById('startDate').value) {
                document.getElementById('startDate').value = today;
            }
            
            updateDiscountType();
            updatePreview();
        });

        function updateDiscountType() {
            const discountType = document.getElementById('discountType').value;
            const valueUnit = document.getElementById('valueUnit');
            const maxDiscountField = document.getElementById('maxDiscountAmount').closest('.col-md-6');
            
            if (discountType === 'PERCENTAGE') {
                valueUnit.textContent = '%';
                maxDiscountField.style.display = 'block';
                document.getElementById('discountValue').max = '100';
            } else if (discountType === 'FIXED_AMOUNT') {
                valueUnit.textContent = '₫';
                maxDiscountField.style.display = 'none';
                document.getElementById('discountValue').max = '';
            } else {
                valueUnit.textContent = '₫';
                maxDiscountField.style.display = 'none';
            }
            
            updatePreview();
        }

        function updatePreview() {
            const code = document.getElementById('code').value || '-';
            const name = document.getElementById('name').value || '-';
            const discountType = document.getElementById('discountType').value;
            const discountValue = document.getElementById('discountValue').value;
            const minOrderAmount = document.getElementById('minOrderAmount').value;
            const maxDiscountAmount = document.getElementById('maxDiscountAmount').value;
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            const usageLimit = document.getElementById('usageLimit').value;
            
            // Update preview elements
            document.getElementById('previewCode').textContent = code;
            document.getElementById('previewName').textContent = name;
            
            // Type and value
            if (discountType && discountValue) {
                document.getElementById('previewType').textContent = 
                    discountType === 'PERCENTAGE' ? 'Percentage' : 'Fixed Amount';
                
                if (discountType === 'PERCENTAGE') {
                    document.getElementById('previewValue').textContent = discountValue + '%';
                } else {
                    document.getElementById('previewValue').textContent = 
                        new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(discountValue);
                }
            } else {
                document.getElementById('previewType').textContent = '-';
                document.getElementById('previewValue').textContent = '-';
            }
            
            // Conditions
            let conditions = [];
            if (minOrderAmount) {
                conditions.push('Min order: ' + new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(minOrderAmount));
            }
            if (maxDiscountAmount && discountType === 'PERCENTAGE') {
                conditions.push('Max discount: ' + new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(maxDiscountAmount));
            }
            if (usageLimit) {
                conditions.push('Usage limit: ' + usageLimit);
            }
            document.getElementById('previewConditions').textContent = conditions.length > 0 ? conditions.join(', ') : 'No conditions';
            
            // Duration
            if (startDate && endDate) {
                document.getElementById('previewDuration').textContent = 
                    'Valid from ' + formatDate(startDate) + ' to ' + formatDate(endDate);
            } else {
                document.getElementById('previewDuration').textContent = '-';
            }
        }

        function formatDate(dateString) {
            const date = new Date(dateString);
            return date.toLocaleDateString('vi-VN');
        }

        // Form validation
        document.getElementById('createForm').addEventListener('submit', function(e) {
            const startDate = new Date(document.getElementById('startDate').value);
            const endDate = new Date(document.getElementById('endDate').value);
            
            if (endDate <= startDate) {
                e.preventDefault();
                alert('End date must be after start date');
                return false;
            }
            
            const discountType = document.getElementById('discountType').value;
            const discountValue = parseFloat(document.getElementById('discountValue').value);
            
            if (discountType === 'PERCENTAGE' && discountValue > 100) {
                e.preventDefault();
                alert('Percentage discount cannot be more than 100%');
                return false;
            }
        });
    </script>
</body>
</html>