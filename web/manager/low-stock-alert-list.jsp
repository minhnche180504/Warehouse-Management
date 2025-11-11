<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Stock Alert List - ISP392">
    <meta name="author" content="ISP392 Team">
    <meta name="keywords" content="warehouse, inventory, alerts, stock management">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/manager/img/icons/icon-48x48.png" />

    <title>Stock Alerts - ${userRole} - ISP392</title>

    <link href="${pageContext.request.contextPath}/manager/css/light.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        .alert-stats {
            margin-bottom: 30px;
        }
        .stat-card {
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            color: white;
            margin-bottom: 15px;
        }
        .stat-card.out-of-stock { background: linear-gradient(135deg, #6c757d, #495057); }
        .stat-card.critical { background: linear-gradient(135deg, #dc3545, #c82333); }
        .stat-card.warning { background: linear-gradient(135deg, #ffc107, #e0a800); }
        .stat-card.stable { background: linear-gradient(135deg, #28a745, #1e7e34); }
        .stat-card.expired { background: linear-gradient(135deg, #6f42c1, #5a32a3); }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .stat-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }
        
        .expired-alert {
            opacity: 0.6;
            background-color: #fff3cd !important;
        }
        
        .alert-level-badge {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
        }
        
        .days-remaining {
            font-size: 0.8rem;
        }
        
        .days-remaining.urgent {
            color: #dc3545;
            font-weight: bold;
        }
        
        .refresh-info {
            font-size: 0.8rem;
            color: #6c757d;
            margin-top: 10px;
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
                                    <h1 class="h3 mb-1">
                                        <i class="fas fa-bell"></i> 
                                        Stock Alerts
                                        <c:if test="${userRole == 'Warehouse Staff'}">
                                            - Warehouse Staff
                                        </c:if>
                                    </h1>
                                    <p class="text-muted">Monitor and manage stock alerts in the system</p>
                                </div>
                                <div>
                                    <c:if test="${canModify}">
                                        <a href="${pageContext.request.contextPath}/manager/low-stock-config" 
                                           class="btn btn-primary me-2">
                                            <i class="fas fa-cog"></i> Configuration
                                        </a>
                                        <a href="${pageContext.request.contextPath}/manager/alert/cleanup-expired" 
                                           class="btn btn-outline-warning me-2"
                                           onclick="return confirm('Are you sure you want to clean up expired alerts?')">
                                            <i class="fas fa-broom"></i> Clean up
                                        </a>
                                    </c:if>
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

                            <!-- Alert Statistics -->
                            <c:if test="${not empty alertCounts}">
                                <div class="alert-stats">
                                    <div class="row">
                                        <div class="col-md-2">
                                            <div class="stat-card out-of-stock">
                                                <div class="stat-number">${alertCounts.out_of_stock}</div>
                                                <div class="stat-label">Out of Stock</div>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="stat-card critical">
                                                <div class="stat-number">${alertCounts.critical}</div>
                                                <div class="stat-label">Critical</div>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="stat-card warning">
                                                <div class="stat-number">${alertCounts.warning}</div>
                                                <div class="stat-label">Warning</div>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="stat-card stable">
                                                <div class="stat-number">${alertCounts.stable}</div>
                                                <div class="stat-label">Stable</div>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="stat-card expired">
                                                <div class="stat-number">${alertCounts.expired}</div>
                                                <div class="stat-label">Expired</div>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="refresh-info text-center">
                                                <i class="fas fa-sync-alt"></i><br>
                                                Auto refresh<br>
                                                every 5 minutes
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Alerts Table -->
                            <div class="card">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">Alert List</h5>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${empty alerts}">
                                            <div class="text-center py-5">
                                                <i class="fas fa-check-circle text-success fa-3x mb-3"></i>
                                                <h5>No alerts</h5>
                                                <p class="text-muted">All products in the warehouse have stable stock levels</p>
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
                                                            <th>Current Stock</th>
                                                            <th>Warning Threshold</th>
                                                            <th>Critical Threshold</th>
                                                            <th>Status</th>
                                                            <th>Created Date</th>
                                                            <th>Expiry Date</th>
                                                            <th>Remaining</th>
                                                            <c:if test="${canModify}">
                                                                <th>Action</th>
                                                            </c:if>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="alert" items="${alerts}">
                                                            <tr class="${alert.expired ? 'expired-alert' : ''}">
                                                                <td>
                                                                    <strong>${alert.productCode}</strong>
                                                                </td>
                                                                <td>${alert.productName}</td>
                                                                <td>
                                                                    <small class="text-muted">${alert.warehouseName}</small>
                                                                </td>
                                                                <td>
                                                                    <span class="badge bg-info">${alert.currentStock}</span>
                                                                    <c:if test="${not empty alert.unitName}">
                                                                        <small class="text-muted">${alert.unitName}</small>
                                                                    </c:if>
                                                                </td>
                                                                <td>
                                                                    <span class="badge bg-warning">${alert.warningThreshold}</span>
                                                                </td>
                                                                <td>
                                                                    <span class="badge bg-danger">${alert.criticalThreshold}</span>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${alert.expired}">
                                                                            <span class="badge bg-secondary alert-level-badge">
                                                                                <i class="fas fa-clock"></i> Expired
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${alert.alertLevel == 'OUT_OF_STOCK'}">
                                                                            <span class="badge bg-dark alert-level-badge">
                                                                                <i class="fas fa-times-circle"></i> Out of Stock
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${alert.alertLevel == 'CRITICAL'}">
                                                                            <span class="badge bg-danger alert-level-badge">
                                                                                <i class="fas fa-exclamation-triangle"></i> Critical
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${alert.alertLevel == 'WARNING'}">
                                                                            <span class="badge bg-warning alert-level-badge">
                                                                                <i class="fas fa-exclamation-circle"></i> Warning
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge bg-success alert-level-badge">
                                                                                <i class="fas fa-check-circle"></i> Stable
                                                                            </span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <fmt:formatDate value="${alert.alertStartDate}" 
                                                                                  pattern="dd/MM/yyyy"/>
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
                                                                            <span class="days-remaining text-muted">
                                                                                <i class="fas fa-clock"></i> Expired
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${alert.daysUntilExpiry <= 7}">
                                                                            <span class="days-remaining urgent">
                                                                                <i class="fas fa-exclamation-triangle"></i> 
                                                                                ${alert.daysUntilExpiry} days
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="days-remaining">
                                                                                ${alert.daysUntilExpiry} days
                                                                            </span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <c:if test="${canModify}">
                                                                    <td>
                                                                        <div class="btn-group btn-group-sm">
                                                                            <a href="${pageContext.request.contextPath}/manager/purchase-request?action=create" 
                                                                               class="btn btn-outline-primary" 
                                                                               title="Create purchase request">
                                                                                <i class="fas fa-plus"></i>
                                                                            </a>
                                                                            <a href="${pageContext.request.contextPath}/manager/low-stock-config?edit=${alert.alertId}" 
                                                                               class="btn btn-outline-secondary" 
                                                                               title="Edit alert">
                                                                                <i class="fas fa-edit"></i>
                                                                            </a>
                                                                            <form method="post" style="display: inline;"
                                                                                  action="${pageContext.request.contextPath}/manager/alert/deactivate"
                                                                                  onsubmit="return confirm('Are you sure you want to deactivate this alert?')">
                                                                                <input type="hidden" name="alertId" value="${alert.alertId}">
                                                                                <button type="submit" class="btn btn-outline-warning" 
                                                                                        title="Deactivate alert">
                                                                                    <i class="fas fa-ban"></i>
                                                                                </button>
                                                                            </form>
                                                                        </div>
                                                                    </td>
                                                                </c:if>
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

    <script src="${pageContext.request.contextPath}/manager/js/app.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Auto refresh page every 5 minutes
        setTimeout(function() {
            window.location.reload();
        }, 300000);

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