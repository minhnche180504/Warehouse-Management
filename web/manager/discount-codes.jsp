<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Discount Codes | Warehouse System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
    <style>
        .status-badge {
            padding: 0.375rem 0.75rem;
            border-radius: 6px;
            font-weight: 500;
            font-size: 0.875rem;
        }
        .status-active { background-color: #d4edda; color: #155724; }
        .status-inactive { background-color: #f8d7da; color: #721c24; }
        .status-expired { background-color: #e2e3e5; color: #383d41; }
        
        .card-header { background: linear-gradient(135deg, #007bff 0%, #0056b3 100%); color: white; }
        .table thead th { background-color: #f8f9fa; color: #495057; font-weight: 600; }
        .table tbody tr:hover { background-color: #f8f9fa; }
        
        .btn-create {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            color: white;
            padding: 10px 20px;
            border-radius: 6px;
            font-weight: 500;
        }
        .btn-create:hover { color: white; transform: translateY(-1px); }
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
                            <h1 class="h2 fw-bold text-primary">Discount Codes Management</h1>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="manager-dashboard">Dashboard</a></li>
                                    <li class="breadcrumb-item active">Discount Codes</li>
                                </ol>
                            </nav>
                        </div>
                        <div>
                            <a href="create-discount-code" class="btn btn-create">
                                <i class="fas fa-plus me-1"></i>Create New Code
                            </a>
                        </div>
                    </div>

                    <!-- Messages -->
                    <c:if test="${not empty param.success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <strong>Success!</strong> ${param.success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty param.error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <strong>Error!</strong> ${param.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Discount Codes Table -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-tags me-2"></i>Discount Codes
                                <span class="badge bg-light text-dark ms-2">${discountCodes.size()} codes</span>
                            </h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty discountCodes}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-tags fa-3x text-muted mb-3"></i>
                                        <h5>No Discount Codes Found</h5>
                                        <p class="text-muted mb-4">Start by creating your first discount code to boost sales.</p>
                                        <a href="create-discount-code" class="btn btn-create">
                                            <i class="fas fa-plus me-1"></i>Create First Code
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Code</th>
                                                    <th>Name</th>
                                                    <th>Type</th>
                                                    <th>Value</th>
                                                    <th>Min Order</th>
                                                    <th>Usage</th>
                                                    <th>Valid Until</th>
                                                    <th>Status</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="code" items="${discountCodes}">
                                                    <tr>
                                                        <td>
                                                            <span class="fw-bold text-primary">${code.code}</span>
                                                        </td>
                                                        <td>
                                                            <div>
                                                                <div class="fw-medium">${code.name}</div>
                                                                <c:if test="${not empty code.description}">
                                                                    <small class="text-muted">${code.description}</small>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${code.discountType == 'PERCENTAGE'}">
                                                                    <span class="badge bg-info">Percentage</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-warning">Fixed Amount</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${code.discountType == 'PERCENTAGE'}">
                                                                    <span class="fw-bold text-success">${code.discountValue}%</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="fw-bold text-success">
                                                                        <fmt:formatNumber value="${code.discountValue}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${code.minOrderAmount > 0}">
                                                                    <fmt:formatNumber value="${code.minOrderAmount}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">No minimum</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div>
                                                                <span class="fw-medium">${code.usedCount}</span>
                                                                <c:choose>
                                                                    <c:when test="${code.usageLimit != null}">
                                                                        / ${code.usageLimit}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        / ∞
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                            <c:if test="${code.usageLimit != null && code.usedCount >= code.usageLimit}">
                                                                <small class="text-danger">Limit reached</small>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <fmt:formatDate value="${code.endDate}" pattern="dd/MM/yyyy"/>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${code.active and code.valid}">
                                                                    <span class="status-badge status-active">Active</span>
                                                                </c:when>
                                                                <c:when test="${code.active and not code.valid}">
                                                                    <span class="status-badge status-expired">Expired</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="status-badge status-inactive">Inactive</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="btn-group" role="group">
                                                                <a href="edit-discount-code?id=${code.discountId}" 
                                                                   class="btn btn-outline-primary btn-sm" title="Edit">
                                                                    <i class="fas fa-edit"></i>
                                                                </a>
                                                                <c:if test="${code.active}">
                                                                    <button type="button" class="btn btn-outline-danger btn-sm" 
                                                                            onclick="confirmDeactivate(${code.discountId}, '${code.code}')" title="Deactivate">
                                                                        <i class="fas fa-ban"></i>
                                                                    </button>
                                                                </c:if>
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
            </main>
            <jsp:include page="/manager/footer.jsp" />
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/feather-icons"></script>
    <script src="js/app.js"></script>
    
    <script>
        function confirmDeactivate(discountId, discountCode) {
            if (confirm('Are you sure you want to deactivate discount code "' + discountCode + '"?')) {
                // Create form and submit
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = 'delete-discount-code';
                
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'id';
                input.value = discountId;
                
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        // Auto-hide alerts
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(function() {
                var alerts = document.querySelectorAll('.alert');
                alerts.forEach(function(alert) {
                    if (alert && typeof bootstrap !== 'undefined') {
                        try {
                            var bsAlert = new bootstrap.Alert(alert);
                            bsAlert.close();
                        } catch (e) {
                            console.log('Could not auto-hide alert:', e);
                        }
                    }
                });
            }, 5000);
        });
    </script>
</body>
</html>