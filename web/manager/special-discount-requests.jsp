<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Special Discount Requests | Warehouse System</title>
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
        .status-pending { background-color: #fff3cd; color: #856404; }
        .status-approved { background-color: #d4edda; color: #155724; }
        .status-rejected { background-color: #f8d7da; color: #721c24; }
        
        .card-header { background: linear-gradient(135deg, #007bff 0%, #0056b3 100%); color: white; }
        .table thead th { background-color: #f8f9fa; color: #495057; font-weight: 600; }
        .table tbody tr:hover { background-color: #f8f9fa; }
        
        .filter-tabs .nav-link {
            border: 1px solid #dee2e6;
            color: #495057;
            margin-right: 0.25rem;
        }
        .filter-tabs .nav-link.active {
            background-color: #007bff;
            border-color: #007bff;
            color: white;
        }
        
        .reason-text {
            max-width: 200px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
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
                            <h1 class="h2 fw-bold text-primary">Special Discount Requests</h1>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="manager-dashboard">Dashboard</a></li>
                                    <li class="breadcrumb-item active">Special Requests</li>
                                </ol>
                            </nav>
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

                    <!-- Filter Tabs -->
                    <ul class="nav nav-tabs filter-tabs mb-3">
                        <li class="nav-item">
                            <a class="nav-link ${empty filter or filter eq 'all' ? 'active' : ''}" 
                               href="special-discount-requests">
                                <i class="fas fa-list me-1"></i>All Requests
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${filter eq 'pending' ? 'active' : ''}" 
                               href="special-discount-requests?filter=pending">
                                <i class="fas fa-clock me-1"></i>Pending
                            </a>
                        </li>
                    </ul>

                    <!-- Requests Table -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">
                                <i class="fas fa-star me-2"></i>Special Discount Requests
                                <span class="badge bg-light text-dark ms-2">${requests.size()} requests</span>
                            </h5>
                        </div>
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty requests}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-star fa-3x text-muted mb-3"></i>
                                        <h5>No Special Discount Requests Found</h5>
                                        <p class="text-muted">
                                            <c:choose>
                                                <c:when test="${filter eq 'pending'}">
                                                    There are no pending special discount requests at this time.
                                                </c:when>
                                                <c:otherwise>
                                                    No special discount requests have been submitted yet.
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Request ID</th>
                                                    <th>Customer</th>
                                                    <th>Requested By</th>
                                                    <th>Discount</th>
                                                    <th>Reason</th>
                                                    <th>Est. Order Value</th>
                                                    <th>Status</th>
                                                    <th>Created</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="request" items="${requests}">
                                                    <tr>
                                                        <td>
                                                            <span class="fw-bold text-primary">#${request.requestId}</span>
                                                        </td>
                                                        <td>
                                                            <div class="fw-medium">${request.customerName}</div>
                                                        </td>
                                                        <td>
                                                            <div class="fw-medium">${request.requestedByName}</div>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${request.discountType == 'PERCENTAGE'}">
                                                                    <span class="fw-bold text-info">${request.discountValue}%</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="fw-bold text-info">
                                                                        <fmt:formatNumber value="${request.discountValue}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="reason-text" title="${request.reason}">
                                                                ${request.reason}
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${request.estimatedOrderValue != null}">
                                                                    <fmt:formatNumber value="${request.estimatedOrderValue}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">Not specified</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <span class="status-badge status-${request.status.toLowerCase()}">
                                                                ${request.status}
                                                            </span>
                                                            <c:if test="${request.status == 'Approved' and not empty request.generatedCode}">
                                                                <div class="small text-success mt-1">
                                                                    Code: <strong>${request.generatedCode}</strong>
                                                                </div>
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <fmt:formatDate value="${request.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${request.status == 'Pending'}">
                                                                    <div class="btn-group" role="group">
                                                                        <button type="button" class="btn btn-success btn-sm" 
                                                                                onclick="approveRequest(${request.requestId})" title="Approve">
                                                                            <i class="fas fa-check"></i>
                                                                        </button>
                                                                        <button type="button" class="btn btn-danger btn-sm" 
                                                                                onclick="rejectRequest(${request.requestId})" title="Reject">
                                                                            <i class="fas fa-times"></i>
                                                                        </button>
                                                                    </div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="text-muted small">
                                                                        <c:if test="${not empty request.approvedByName}">
                                                                            By: ${request.approvedByName}
                                                                        </c:if>
                                                                        <c:if test="${request.approvedAt != null}">
                                                                            <br><fmt:formatDate value="${request.approvedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                                        </c:if>
                                                                        <c:if test="${not empty request.rejectionReason}">
                                                                            <br><strong>Reason:</strong> ${request.rejectionReason}
                                                                        </c:if>
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
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

    <!-- Reject Modal -->
    <div class="modal fade" id="rejectModal" tabindex="-1" aria-labelledby="rejectModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="rejectModalLabel">Reject Special Discount Request</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="rejectForm" method="post" action="reject-special-discount">
                    <div class="modal-body">
                        <input type="hidden" id="rejectRequestId" name="requestId">
                        <div class="mb-3">
                            <label for="rejectionReason" class="form-label">Rejection Reason <span class="text-danger">*</span></label>
                            <textarea class="form-control" id="rejectionReason" name="rejectionReason" 
                                      rows="3" required placeholder="Please provide a reason for rejecting this request..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-times me-1"></i>Reject Request
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/feather-icons"></script>
    <script src="js/app.js"></script>
    
    <script>
        function approveRequest(requestId) {
            if (confirm('Are you sure you want to approve this special discount request?')) {
                // Create form and submit
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = 'approve-special-discount';
                
                var input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'requestId';
                input.value = requestId;
                
                form.appendChild(input);
                document.body.appendChild(form);
                form.submit();
            }
        }
        
        function rejectRequest(requestId) {
            document.getElementById('rejectRequestId').value = requestId;
            document.getElementById('rejectionReason').value = '';
            
            var modal = new bootstrap.Modal(document.getElementById('rejectModal'));
            modal.show();
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