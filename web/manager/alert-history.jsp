<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Alert History Details - ISP392</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/manager/css/light.css" rel="stylesheet">
    <style>
        .action-badge {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
        }
        .timeline-item {
            border-left: 3px solid #dee2e6;
            padding-left: 1rem;
            margin-bottom: 1rem;
            position: relative;
        }
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -6px;
            top: 0.5rem;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background-color: #6c757d;
        }
        .timeline-item.created::before { background-color: #198754; }
        .timeline-item.updated::before { background-color: #0d6efd; }
        .timeline-item.resolved_by_purchase::before { background-color: #20c997; }
        .timeline-item.expired::before { background-color: #ffc107; }
        .timeline-item.deactivated::before { background-color: #dc3545; }
        
        .stats-card {
            transition: transform 0.2s;
        }
        .stats-card:hover {
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <!-- Sidebar -->
        <jsp:include page="/manager/ManagerSidebar.jsp"/>
        
        <div class="main">
            <!-- Navbar -->
            <jsp:include page="/manager/navbar.jsp"/>
            
            <main class="content">
                <div class="container-fluid p-0">
                    <!-- Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h1 class="h3 mb-0">Alert History Details</h1>
                            <p class="text-muted">Track all changes and activities of inventory alerts</p>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/manager/low-stock-alerts" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Back to List
                            </a>
                        </div>
                    </div>
                    
                    <!-- Alert Messages -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <!-- Statistics Cards -->
                    <c:if test="${not empty historyStats}">
                        <div class="row mb-4">
                            <div class="col-md-2">
                                <div class="card stats-card border-primary">
                                    <div class="card-body text-center">
                                        <i class="fas fa-chart-line text-primary fa-2x mb-2"></i>
                                        <h6 class="card-title">Total Activities</h6>
                                        <h3 class="text-primary mb-0">${historyStats['total']}</h3>
                                        <small class="text-muted">Last 30 days</small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="card stats-card border-success">
                                    <div class="card-body text-center">
                                        <i class="fas fa-plus text-success fa-2x mb-2"></i>
                                        <h6 class="card-title">Created</h6>
                                        <h3 class="text-success mb-0">${historyStats['created']}</h3>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="card stats-card border-info">
                                    <div class="card-body text-center">
                                        <i class="fas fa-edit text-info fa-2x mb-2"></i>
                                        <h6 class="card-title">Updated</h6>
                                        <h3 class="text-info mb-0">${historyStats['updated']}</h3>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="card stats-card border-success">
                                    <div class="card-body text-center">
                                        <i class="fas fa-check text-success fa-2x mb-2"></i>
                                        <h6 class="card-title">Resolved</h6>
                                        <h3 class="text-success mb-0">${historyStats['resolved']}</h3>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="card stats-card border-warning">
                                    <div class="card-body text-center">
                                        <i class="fas fa-clock text-warning fa-2x mb-2"></i>
                                        <h6 class="card-title">Expired</h6>
                                        <h3 class="text-warning mb-0">${historyStats['expired']}</h3>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="card stats-card border-danger">
                                    <div class="card-body text-center">
                                        <i class="fas fa-times text-danger fa-2x mb-2"></i>
                                        <h6 class="card-title">Deactivated</h6>
                                        <h3 class="text-danger mb-0">${historyStats['deactivated']}</h3>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    
                    <!-- Filter Options -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="form-label">Filter by Action:</label>
                                    <select class="form-select" id="actionFilter" onchange="filterHistory()">
                                        <option value="">All</option>
                                        <option value="CREATED">Created</option>
                                        <option value="UPDATED">Updated</option>
                                        <option value="RESOLVED_BY_PURCHASE">Resolved</option>
                                        <option value="EXPIRED">Expired</option>
                                        <option value="DEACTIVATED">Deactivated</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Filter by Level:</label>
                                    <select class="form-select" id="levelFilter" onchange="filterHistory()">
                                        <option value="">All</option>
                                        <option value="OUT_OF_STOCK">Out of Stock</option>
                                        <option value="CRITICAL">Critical</option>
                                        <option value="WARNING">Warning</option>
                                        <option value="STABLE">Stable</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Display:</label>
                                    <select class="form-select" id="viewMode" onchange="toggleViewMode()">
                                        <option value="table">Table View</option>
                                        <option value="timeline">Timeline View</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Search Product:</label>
                                    <input type="text" class="form-control" id="productSearch" placeholder="Product code or name" onkeyup="filterHistory()">
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Alert History Table View -->
                    <div class="card" id="tableView">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Alert History (Latest 100)</h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty alertHistory}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-history text-muted fa-3x mb-3"></i>
                                        <h5>No Alert History</h5>
                                        <p class="text-muted">Alert history will be displayed when there are activities</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover" id="historyTable">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>Time</th>
                                                    <th>Action</th>
                                                    <th>Product</th>
                                                    <th>Warehouse</th>
                                                    <th>Level</th>
                                                    <th>Stock</th>
                                                    <th>Threshold</th>
                                                    <th>Changes</th>
                                                    <th>Performed By</th>
                                                    <th>Notes</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="history" items="${alertHistory}">
                                                    <tr class="history-row" 
                                                        data-action="${history.actionType}" 
                                                        data-level="${history.alertLevel}"
                                                        data-product="${history.productCode} ${history.productName}">
                                                        <td>
                                                            <fmt:formatDate value="${history.actionDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                            <c:if test="${history.systemGenerated}">
                                                                <br><small class="text-muted"><i class="fas fa-robot"></i> Auto</small>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${history.actionType == 'CREATED'}">
                                                                    <span class="badge bg-success action-badge">
                                                                        <i class="fas fa-plus"></i> Created
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${history.actionType == 'UPDATED'}">
                                                                    <span class="badge bg-primary action-badge">
                                                                        <i class="fas fa-edit"></i> Updated
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${history.actionType == 'RESOLVED_BY_PURCHASE'}">
                                                                    <span class="badge bg-info action-badge">
                                                                        <i class="fas fa-shopping-cart"></i> Resolved
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${history.actionType == 'EXPIRED'}">
                                                                    <span class="badge bg-warning action-badge">
                                                                        <i class="fas fa-clock"></i> Expired
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${history.actionType == 'DEACTIVATED'}">
                                                                    <span class="badge bg-danger action-badge">
                                                                        <i class="fas fa-times"></i> Deactivated
                                                                    </span>
                                                                </c:when>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <strong>${history.productCode}</strong><br>
                                                            <small class="text-muted">${history.productName}</small>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-secondary">${history.warehouseName}</span>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${history.alertLevel == 'OUT_OF_STOCK'}">
                                                                    <span class="badge bg-danger">Out of Stock</span>
                                                                </c:when>
                                                                <c:when test="${history.alertLevel == 'CRITICAL'}">
                                                                    <span class="badge bg-danger">Critical</span>
                                                                </c:when>
                                                                <c:when test="${history.alertLevel == 'WARNING'}">
                                                                    <span class="badge bg-warning">Warning</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-success">Stable</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <span class="fw-bold">${history.stockQuantity}</span>
                                                        </td>
                                                        <td>
                                                            <small>
                                                                Warning: <span class="badge bg-warning">${history.warningThreshold}</span><br>
                                                                Critical: <span class="badge bg-danger">${history.criticalThreshold}</span>
                                                            </small>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${history.actionType == 'UPDATED'}">
                                                                    <small>
                                                                        <c:if test="${history.oldWarningThreshold != null}">
                                                                            Warning: ${history.oldWarningThreshold} → ${history.warningThreshold}<br>
                                                                        </c:if>
                                                                        <c:if test="${history.oldCriticalThreshold != null}">
                                                                            Critical: ${history.oldCriticalThreshold} → ${history.criticalThreshold}<br>
                                                                        </c:if>
                                                                        <c:if test="${history.oldExpiryDate != null && history.newExpiryDate != null}">
                                                                            Expiry: <fmt:formatDate value="${history.oldExpiryDate}" pattern="dd/MM"/> → <fmt:formatDate value="${history.newExpiryDate}" pattern="dd/MM"/>
                                                                        </c:if>
                                                                    </small>
                                                                </c:when>
                                                                <c:when test="${history.actionType == 'RESOLVED_BY_PURCHASE'}">
                                                                    <small class="text-success">
                                                                        <i class="fas fa-check"></i> PR #${history.resolvedByPurchaseRequestId}<br>
                                                                        <strong>Resolved by:</strong> ${history.resolvedByName}
                                                                    </small>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">-</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <small>${history.performedByName}</small>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty history.notes}">
                                                                <small class="text-muted">${history.notes}</small>
                                                            </c:if>
                                                            <c:if test="${not empty history.purchaseRequestReason}">
                                                                <br><small class="text-info"><strong>Reason:</strong> ${history.purchaseRequestReason}</small>
                                                            </c:if>
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
                    
                    <!-- Alert History Timeline View -->
                    <div class="card" id="timelineView" style="display: none;">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Alert History Timeline</h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty alertHistory}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-history text-muted fa-3x mb-3"></i>
                                        <h5>No Alert History</h5>
                                        <p class="text-muted">Timeline will be displayed when there are activities</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                   <div id="timelineContainer">
                                        <c:forEach var="history" items="${alertHistory}">
                                            <div class="timeline-item ${history.actionType.toLowerCase().replace('_', '')} history-timeline" 
                                                 data-action="${history.actionType}" 
                                                 data-level="${history.alertLevel}"
                                                 data-product="${history.productCode} ${history.productName}">
                                                <div class="d-flex justify-content-between align-items-start">
                                                    <div class="flex-grow-1">
                                                        <div class="d-flex align-items-center mb-2">
                                                            <c:choose>
                                                                <c:when test="${history.actionType == 'CREATED'}">
                                                                    <span class="badge bg-success me-2">
                                                                        <i class="fas fa-plus"></i> Created
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${history.actionType == 'UPDATED'}">
                                                                    <span class="badge bg-primary me-2">
                                                                        <i class="fas fa-edit"></i> Updated
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${history.actionType == 'RESOLVED_BY_PURCHASE'}">
                                                                    <span class="badge bg-info me-2">
                                                                        <i class="fas fa-shopping-cart"></i> Resolved
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${history.actionType == 'EXPIRED'}">
                                                                    <span class="badge bg-warning me-2">
                                                                        <i class="fas fa-clock"></i> Expired
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${history.actionType == 'DEACTIVATED'}">
                                                                    <span class="badge bg-danger me-2">
                                                                        <i class="fas fa-times"></i> Deactivated
                                                                    </span>
                                                                </c:when>
                                                            </c:choose>
                                                            <strong>${history.productCode} - ${history.productName}</strong>
                                                            <span class="badge bg-secondary ms-2">${history.warehouseName}</span>
                                                            <c:if test="${history.systemGenerated}">
                                                                <span class="badge bg-secondary ms-2">
                                                                    <i class="fas fa-robot"></i> Auto
                                                                </span>
                                                            </c:if>
                                                        </div>
                                                        
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <small class="text-muted">
                                                                    <strong>Level:</strong> 
                                                                    <c:choose>
                                                                        <c:when test="${history.alertLevel == 'OUT_OF_STOCK'}">
                                                                            <span class="badge bg-danger">Out of Stock</span>
                                                                        </c:when>
                                                                        <c:when test="${history.alertLevel == 'CRITICAL'}">
                                                                            <span class="badge bg-danger">Critical</span>
                                                                        </c:when>
                                                                        <c:when test="${history.alertLevel == 'WARNING'}">
                                                                            <span class="badge bg-warning">Warning</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge bg-success">Stable</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                    <br>
                                                                    <strong>Stock:</strong> ${history.stockQuantity}<br>
                                                                    <strong>Threshold:</strong> Warning ${history.warningThreshold} / Critical ${history.criticalThreshold}
                                                                </small>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <c:if test="${history.actionType == 'UPDATED'}">
                                                                    <small class="text-primary">
                                                                        <strong>Changes:</strong><br>
                                                                        <c:if test="${history.oldWarningThreshold != null}">
                                                                            Warning: ${history.oldWarningThreshold} → ${history.warningThreshold}<br>
                                                                        </c:if>
                                                                        <c:if test="${history.oldCriticalThreshold != null}">
                                                                            Critical: ${history.oldCriticalThreshold} → ${history.criticalThreshold}<br>
                                                                        </c:if>
                                                                    </small>
                                                                </c:if>
                                                                <c:if test="${history.actionType == 'RESOLVED_BY_PURCHASE'}">
                                                                    <small class="text-success">
                                                                        <strong>Resolved:</strong><br>
                                                                        Purchase Request #${history.resolvedByPurchaseRequestId}<br>
                                                                        Resolved by: ${history.resolvedByName}
                                                                    </small>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                        
                                                        <c:if test="${not empty history.notes}">
                                                            <div class="mt-2">
                                                                <small class="text-muted">
                                                                    <strong>Notes:</strong> ${history.notes}
                                                                </small>
                                                            </div>
                                                        </c:if>
                                                        
                                                        <c:if test="${not empty history.purchaseRequestReason}">
                                                            <div class="mt-1">
                                                                <small class="text-info">
                                                                    <strong>Request Reason:</strong> ${history.purchaseRequestReason}
                                                                </small>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                    <div class="text-end">
                                                        <small class="text-muted">
                                                            <fmt:formatDate value="${history.actionDate}" pattern="dd/MM/yyyy HH:mm"/><br>
                                                            ${history.performedByName}
                                                        </small>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </main>
            
            <!-- Footer -->
            <jsp:include page="/manager/footer.jsp"/>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/manager/js/app.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function filterHistory() {
            const actionFilter = document.getElementById('actionFilter').value;
            const levelFilter = document.getElementById('levelFilter').value;
            const productSearch = document.getElementById('productSearch').value.toLowerCase();
            
            // Filter table rows
            const tableRows = document.querySelectorAll('.history-row');
            tableRows.forEach(row => {
                const action = row.getAttribute('data-action');
                const level = row.getAttribute('data-level');
                const product = row.getAttribute('data-product').toLowerCase();
                
                let show = true;
                
                if (actionFilter && action !== actionFilter) show = false;
                if (levelFilter && level !== levelFilter) show = false;
                if (productSearch && !product.includes(productSearch)) show = false;
                
                row.style.display = show ? '' : 'none';
            });
            
            // Filter timeline items
            const timelineItems = document.querySelectorAll('.history-timeline');
            timelineItems.forEach(item => {
                const action = item.getAttribute('data-action');
                const level = item.getAttribute('data-level');
                const product = item.getAttribute('data-product').toLowerCase();
                
                let show = true;
                
                if (actionFilter && action !== actionFilter) show = false;
                if (levelFilter && level !== levelFilter) show = false;
                if (productSearch && !product.includes(productSearch)) show = false;
                
                item.style.display = show ? '' : 'none';
            });
        }
        
        function toggleViewMode() {
            const viewMode = document.getElementById('viewMode').value;
            const tableView = document.getElementById('tableView');
            const timelineView = document.getElementById('timelineView');
            
            if (viewMode === 'timeline') {
                tableView.style.display = 'none';
                timelineView.style.display = 'block';
            } else {
                tableView.style.display = 'block';
                timelineView.style.display = 'none';
            }
        }
        
        // Auto refresh every 10 minutes
        setTimeout(function() {
            location.reload();
        }, 600000);
    </script>
</body>
</html>
