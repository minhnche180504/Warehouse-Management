<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>My Special Requests | Warehouse System</title>
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
        
        .request-card {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            margin-bottom: 1rem;
            transition: box-shadow 0.2s;
        }
        .request-card:hover {
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .request-card.approved {
            border-left: 4px solid #28a745;
        }
        .request-card.rejected {
            border-left: 4px solid #dc3545;
        }
        .request-card.pending {
            border-left: 4px solid #ffc107;
        }
        
        .discount-code {
            background: #28a745;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            font-family: 'Courier New', monospace;
            font-weight: bold;
            display: inline-block;
            cursor: pointer;
        }
        
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
        <jsp:include page="/sale/SalesSidebar.jsp" />
        <div class="main">
            <jsp:include page="/sale/navbar.jsp" />
            <main class="content">
                <div class="container-fluid p-0">
                    <!-- Page Header -->
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h1 class="h2 fw-bold text-primary">My Special Discount Requests</h1>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="dashboard">Dashboard</a></li>
                                    <li class="breadcrumb-item active">My Special Requests</li>
                                </ol>
                            </nav>
                        </div>
                        <div>
                            <a href="request-special-discount" class="btn btn-create">
                                <i class="fas fa-plus me-1"></i>New Request
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

                    <!-- Requests List -->
                    <c:choose>
                        <c:when test="${empty requests}">
                            <div class="card">
                                <div class="card-body text-center py-5">
                                    <i class="fas fa-star fa-3x text-muted mb-3"></i>
                                    <h5>No Special Discount Requests</h5>
                                    <p class="text-muted mb-4">You haven't submitted any special discount requests yet.</p>
                                    <a href="request-special-discount" class="btn btn-create">
                                        <i class="fas fa-plus me-1"></i>Submit First Request
                                    </a>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="row">
                                <c:forEach var="request" items="${requests}">
                                    <div class="col-12">
                                        <div class="request-card ${request.status.toLowerCase()}">
                                            <div class="card-header">
                                                <div class="row align-items-center">
                                                    <div class="col-md-6">
                                                        <h6 class="mb-0">
                                                            <i class="fas fa-star me-2"></i>
                                                            Request #${request.requestId}
                                                        </h6>
                                                        <small class="text-muted">
                                                            <fmt:formatDate value="${request.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </small>
                                                    </div>
                                                    <div class="col-md-6 text-end">
                                                        <span class="status-badge status-${request.status.toLowerCase()}">
                                                            ${request.status}
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="card-body">
                                                <div class="row">
                                                    <div class="col-md-8">
                                                        <div class="row mb-3">
                                                            <div class="col-sm-6">
                                                                <strong>Customer:</strong><br>
                                                                <span class="text-primary">${request.customerName}</span>
                                                            </div>
                                                            <div class="col-sm-6">
                                                                <strong>Discount:</strong><br>
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
                                                            </div>
                                                        </div>
                                                        
                                                        <c:if test="${request.estimatedOrderValue != null}">
                                                            <div class="mb-3">
                                                                <strong>Estimated Order Value:</strong><br>
                                                                <fmt:formatNumber value="${request.estimatedOrderValue}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                                            </div>
                                                        </c:if>
                                                        
                                                        <div class="mb-3">
                                                            <strong>Reason:</strong><br>
                                                            <div class="text-muted">${request.reason}</div>
                                                        </div>
                                                    </div>
                                                    
                                                    <div class="col-md-4">
                                                        <c:choose>
                                                            <c:when test="${request.status == 'Approved'}">
                                                                <div class="text-center">
                                                                    <div class="mb-2">
                                                                        <strong class="text-success">
                                                                            <i class="fas fa-check-circle me-1"></i>Approved!
                                                                        </strong>
                                                                    </div>
                                                                    <c:if test="${not empty request.generatedCode}">
                                                                        <div class="mb-2">
                                                                            <div class="small text-muted mb-1">Your Discount Code:</div>
                                                                            <div class="discount-code" onclick="copyToClipboard('${request.generatedCode}')" 
                                                                                 title="Click to copy">
                                                                                ${request.generatedCode}
                                                                            </div>
                                                                        </div>
                                                                        <c:if test="${request.expiryDate != null}">
                                                                            <div class="small text-warning">
                                                                                <i class="fas fa-clock me-1"></i>
                                                                                Expires: <fmt:formatDate value="${request.expiryDate}" pattern="dd/MM/yyyy"/>
                                                                            </div>
                                                                        </c:if>
                                                                    </c:if>
                                                                    <c:if test="${request.approvedByName != null}">
                                                                        <div class="small text-muted mt-2">
                                                                            Approved by: ${request.approvedByName}<br>
                                                                            <fmt:formatDate value="${request.approvedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                                        </div>
                                                                    </c:if>
                                                                </div>
                                                            </c:when>
                                                            
                                                            <c:when test="${request.status == 'Rejected'}">
                                                                <div class="text-center">
                                                                    <div class="mb-2">
                                                                        <strong class="text-danger">
                                                                            <i class="fas fa-times-circle me-1"></i>Rejected
                                                                        </strong>
                                                                    </div>
                                                                    <c:if test="${not empty request.rejectionReason}">
                                                                        <div class="alert alert-danger small mb-2">
                                                                            <strong>Reason:</strong><br>
                                                                            ${request.rejectionReason}
                                                                        </div>
                                                                    </c:if>
                                                                    <c:if test="${request.approvedByName != null}">
                                                                        <div class="small text-muted">
                                                                            Rejected by: ${request.approvedByName}<br>
                                                                            <fmt:formatDate value="${request.approvedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                                        </div>
                                                                    </c:if>
                                                                </div>
                                                            </c:when>
                                                            
                                                            <c:otherwise>
                                                                <div class="text-center">
                                                                    <div class="mb-2">
                                                                        <strong class="text-warning">
                                                                            <i class="fas fa-clock me-1"></i>Pending Review
                                                                        </strong>
                                                                    </div>
                                                                    <div class="small text-muted">
                                                                        Your request is being reviewed by the manager. 
                                                                        You will receive a notification once it's processed.
                                                                    </div>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>
            <jsp:include page="/sale/footer.jsp" />
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://unpkg.com/feather-icons"></script>
    <script src="js/app.js"></script>
    
    <script>
        function copyToClipboard(text) {
            // Create a temporary input element
            var tempInput = document.createElement('input');
            tempInput.value = text;
            document.body.appendChild(tempInput);
            
            // Select and copy the text
            tempInput.select();
            tempInput.setSelectionRange(0, 99999); // For mobile devices
            document.execCommand('copy');
            
            // Remove the temporary input
            document.body.removeChild(tempInput);
            
            // Show feedback
            var originalText = event.target.textContent;
            event.target.textContent = 'Copied!';
            event.target.style.background = '#17a2b8';
            
            setTimeout(function() {
                event.target.textContent = originalText;
                event.target.style.background = '#28a745';
            }, 2000);
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