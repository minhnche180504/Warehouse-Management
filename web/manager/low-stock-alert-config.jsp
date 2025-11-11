<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Stock Alert Configuration - ISP392">
    <meta name="author" content="ISP392 Team">
    <meta name="keywords" content="warehouse, inventory, alerts, stock management">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/manager/img/icons/icon-48x48.png" />
    <link rel="canonical" href="https://demo-basic.adminkit.io/" />

    <title>Stock Alert Configuration - ISP392</title>

    <link href="${pageContext.request.contextPath}/manager/css/light.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        body {
            background: #f6f7fa;
        }
        .alert-config-form {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
        }
        .current-alerts-table {
            margin-top: 30px;
        }
        .expired-alert {
            opacity: 0.6;
            background-color: #fff3cd !important;
        }
        .alert-status-badge {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
        }
        .form-section {
            margin-bottom: 25px;
        }
        .form-section h5 {
            color: #495057;
            margin-bottom: 15px;
            font-weight: 600;
        }
        .threshold-input {
            max-width: 150px;
        }
        .duration-input {
            max-width: 100px;
        }
    </style>
</head>

<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
    <div class="wrapper">
        <jsp:include page="/manager/ManagerSidebar.jsp"/>
            <div class="main">
                <jsp:include page="/manager/navbar.jsp" />

            <main class="content">
                <div class="container-fluid p-0">
                    <div class="row">
                        <div class="col-12">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <div>
                                    <h1 class="h3 mb-1">Stock Alert Configuration</h1>
                                    <p class="text-muted">Set alert thresholds for products in the warehouse</p>
                                </div>
                                <div>
                                    <a href="${pageContext.request.contextPath}/manager/low-stock-alerts" 
                                       class="btn btn-outline-primary">
                                        <i class="fas fa-list"></i> Alert List
                                    </a>
                                    <a href="${pageContext.request.contextPath}/manager/alert-history" 
                                       class="btn btn-outline-secondary">
                                        <i class="fas fa-history"></i> History
                                    </a>
                                </div>
                            </div>

                            <!-- Alert Messages -->
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-triangle"></i>
                                    <strong>Error!</strong> ${error}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>

                            <c:if test="${not empty success}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <i class="fas fa-check-circle"></i>
                                    <strong>Success!</strong> ${success}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>

                            <!-- Configuration Form -->
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-plus-circle"></i> Create New Alert
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <form action="${pageContext.request.contextPath}/manager/alert/create" 
                                          method="post" onsubmit="return validateForm()">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="form-section">
                                                    <h5>Product Information</h5>
                                                    <div class="mb-3">
                                                        <label for="productId" class="form-label">Product <span class="text-danger">*</span></label>
                                                        <select class="form-select" id="productId" name="productId" required>
                                                            <option value="">-- Select product --</option>
                                                            <c:forEach var="product" items="${products}">
                                                                <option value="${product.productId}">
                                                                    ${product.code} - ${product.name}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label for="warehouseId" class="form-label">Warehouse <span class="text-danger">*</span></label>
                                                        <select class="form-select" id="warehouseId" name="warehouseId" required>
                                                            <option value="">-- Select warehouse --</option>
                                                            <c:forEach var="warehouse" items="${warehouses}">
                                                                <option value="${warehouse.warehouseId}" 
                                                                        <c:if test="${warehouse.warehouseId == userWarehouseId}">selected</c:if>>
                                                                    ${warehouse.warehouseName}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="col-md-6">
                                                <div class="form-section">
                                                    <h5>Alert Thresholds</h5>
                                                    <div class="mb-3">
                                                        <label for="warningThreshold" class="form-label">
                                                            Warning Threshold <span class="text-danger">*</span>
                                                        </label>
                                                        <input type="number" class="form-control threshold-input" 
                                                               id="warningThreshold" name="warningThreshold" 
                                                               min="1" required>
                                                        <div class="form-text">Stock quantity to trigger warning</div>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label for="criticalThreshold" class="form-label">
                                                            Critical Threshold <span class="text-danger">*</span>
                                                        </label>
                                                        <input type="number" class="form-control threshold-input" 
                                                               id="criticalThreshold" name="criticalThreshold" 
                                                               min="0" required>
                                                        <div class="form-text">Stock quantity to trigger critical alert</div>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label for="durationDays" class="form-label">
                                                            Duration (days) <span class="text-danger">*</span>
                                                        </label>
                                                        <input type="number" class="form-control duration-input" 
                                                               id="durationDays" name="durationDays" 
                                                               value="30" min="1" max="365" required>
                                                        <div class="form-text">Number of days alert is valid</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="d-flex justify-content-end">
                                            <button type="reset" class="btn btn-secondary me-2">
                                                <i class="fas fa-undo"></i> Reset
                                            </button>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-save"></i> Create Alert
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <!-- Current Alerts -->
                            <div class="card current-alerts-table">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="card-title mb-0">
                                        <i class="fas fa-bell"></i> Current Alerts
                                    </h5>
                                    <a href="${pageContext.request.contextPath}/manager/alert/cleanup-expired" 
                                       class="btn btn-outline-warning btn-sm"
                                       onclick="return confirm('Are you sure you want to clean up expired alerts?')">
                                        <i class="fas fa-broom"></i> Clean up expired
                                    </a>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${empty currentAlerts}">
                                            <div class="text-center py-5">
                                                <i class="fas fa-bell-slash text-muted fa-3x mb-3"></i>
                                                <h5 class="text-muted">No alerts have been configured</h5>
                                                <p class="text-muted">Use the form above to create a new alert</p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="table-responsive">
                                                <table class="table table-hover">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>Product Code</th>
                                                            <th>Product Name</th>
                                                            <th>Warehouse</th>
                                                            <th>Warning Threshold</th>
                                                            <th>Critical Threshold</th>
                                                            <th>Expiry Date</th>
                                                            <th>Status</th>
                                                            <th>Action</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="alert" items="${currentAlerts}">
                                                            <tr class="${alert.expired ? 'expired-alert' : ''}">
                                                                <td>
                                                                    <strong>${alert.productCode}</strong>
                                                                </td>
                                                                <td>${alert.productName}</td>
                                                                <td>${alert.warehouseName}</td>
                                                                <td>
                                                                    <span class="badge bg-warning">${alert.warningThreshold}</span>
                                                                </td>
                                                                <td>
                                                                    <span class="badge bg-danger">${alert.criticalThreshold}</span>
                                                                </td>
                                                                <td>
                                                                    <c:if test="${not empty alert.alertExpiryDate}">
                                                                        <fmt:formatDate value="${alert.alertExpiryDate}" 
                                                                                      pattern="dd/MM/yyyy"/>
                                                                    </c:if>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${alert.expired}">
                                                                            <span class="badge bg-secondary alert-status-badge">
                                                                                <i class="fas fa-clock"></i> Expired
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${alert.alertLevel == 'OUT_OF_STOCK'}">
                                                                            <span class="badge bg-dark alert-status-badge">
                                                                                <i class="fas fa-times-circle"></i> Out of stock
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${alert.alertLevel == 'CRITICAL'}">
                                                                            <span class="badge bg-danger alert-status-badge">
                                                                                <i class="fas fa-exclamation-triangle"></i> Critical
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${alert.alertLevel == 'WARNING'}">
                                                                            <span class="badge bg-warning alert-status-badge">
                                                                                <i class="fas fa-exclamation-circle"></i> Warning
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge bg-success alert-status-badge">
                                                                                <i class="fas fa-check-circle"></i> Stable
                                                                            </span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <div class="btn-group btn-group-sm">
                                                                        <button type="button" class="btn btn-outline-primary" 
                                                                                onclick="editAlert(${alert.alertId}, ${alert.warningThreshold}, ${alert.criticalThreshold}, ${alert.alertDurationDays})"
                                                                                title="Edit">
                                                                            <i class="fas fa-edit"></i>
                                                                        </button>
                                                                        <form method="post" style="display: inline;"
                                                                              action="${pageContext.request.contextPath}/manager/alert/deactivate"
                                                                              onsubmit="return confirm('Are you sure you want to deactivate this alert?')">
                                                                            <input type="hidden" name="alertId" value="${alert.alertId}">
                                                                            <button type="submit" class="btn btn-outline-warning" 
                                                                                    title="Deactivate">
                                                                                <i class="fas fa-ban"></i>
                                                                            </button>
                                                                        </form>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>

            <jsp:include page="/manager/footer.jsp"/>
        </div>
    </div>

    <!-- Edit Alert Modal -->
    <div class="modal fade" id="editAlertModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Edit Alert</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/manager/alert/update" method="post">
                    <div class="modal-body">
                        <input type="hidden" id="editAlertId" name="alertId">
                        
                        <div class="mb-3">
                            <label for="editWarningThreshold" class="form-label">Warning Threshold</label>
                            <input type="number" class="form-control" id="editWarningThreshold" 
                                   name="warningThreshold" min="1" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editCriticalThreshold" class="form-label">Critical Threshold</label>
                            <input type="number" class="form-control" id="editCriticalThreshold" 
                                   name="criticalThreshold" min="0" required>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editDurationDays" class="form-label">Duration (days)</label>
                            <input type="number" class="form-control" id="editDurationDays" 
                                   name="durationDays" min="1" max="365" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/manager/js/app.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Form validation
        function validateForm() {
            const warningThreshold = parseInt(document.getElementById('warningThreshold').value);
            const criticalThreshold = parseInt(document.getElementById('criticalThreshold').value);
            
            if (criticalThreshold >= warningThreshold) {
                alert('Critical threshold must be less than warning threshold!');
                return false;
            }
            
            return true;
        }

        // Edit alert function
        function editAlert(alertId, warningThreshold, criticalThreshold, durationDays) {
            document.getElementById('editAlertId').value = alertId;
            document.getElementById('editWarningThreshold').value = warningThreshold;
            document.getElementById('editCriticalThreshold').value = criticalThreshold;
            document.getElementById('editDurationDays').value = durationDays;
            
            const modal = new bootstrap.Modal(document.getElementById('editAlertModal'));
            modal.show();
        }

        // Highlight expired alerts
        document.addEventListener('DOMContentLoaded', function() {
            const expiredRows = document.querySelectorAll('.expired-alert');
            expiredRows.forEach(row => {
                row.style.opacity = '0.6';
            });
        });

        // Auto dismiss alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>