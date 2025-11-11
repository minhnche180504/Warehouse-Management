<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request for Quotation List</title>
    
    <!-- CSS -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>

<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
    <div class="wrapper">
        <!-- Sidebar -->
        <jsp:include page="/purchase/PurchaseSidebar.jsp" />
        
        <div class="main">
            <!-- Navbar -->
            <jsp:include page="/purchase/navbar.jsp" />

            <main class="content">
                <div class="container-fluid p-0">
                    <div class="row mb-2 mb-xl-3">
                        <div class="col-auto d-none d-sm-block">
                            <h3><strong>Request for</strong> Quotation</h3>
                        </div>
                        <div class="col-auto ms-auto text-end mt-n1">
                            <a href="rfq?action=create" class="btn btn-primary">
                                <i class="fas fa-plus"></i> Create RFQ
                            </a>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Request for Quotation List</h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>RFQ Code</th>
                                            <th>Supplier</th>
                                            <th>Created By</th>
                                            <th>Created Date</th>
                                            <th>Status</th>
                                            <th>Notes</th>
                                            <th class="text-center">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty rfqList}">
                                                <tr>
                                                    <td colspan="7" class="text-center text-muted">
                                                        <i class="fas fa-inbox fa-2x mb-2"></i>
                                                        <p>No RFQ found</p>
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="rfq" items="${rfqList}">
                                                    <tr>
                                                        <td>
                                                            <strong>RFQ-${rfq.rfqId}</strong>
                                                        </td>
                                                        <td>
                                                            <div>
                                                                <strong>${rfq.supplierName}</strong>
                                                                <c:if test="${not empty rfq.supplierEmail}">
                                                                    <br><small class="text-muted">
                                                                        <i class="fas fa-envelope"></i> ${rfq.supplierEmail}
                                                                    </small>
                                                                </c:if>
                                                                <c:if test="${not empty rfq.supplierPhone}">
                                                                    <br><small class="text-muted">
                                                                        <i class="fas fa-phone"></i> ${rfq.supplierPhone}
                                                                    </small>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                        <td>${rfq.createdByName}</td>
                                                        <td>${rfq.requestDate}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${rfq.status eq 'Pending'}">
                                                                    <span class="badge bg-warning">Pending</span>
                                                                </c:when>
                                                                <c:when test="${rfq.status eq 'Sent'}">
                                                                    <span class="badge bg-success">Sent</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">${rfq.status}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty rfq.notes and fn:length(rfq.notes) > 50}">
                                                                    ${fn:substring(rfq.notes, 0, 50)}...
                                                                </c:when>
                                                                <c:otherwise>
                                                                    ${rfq.notes}
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-center">
                                                            <div class="btn-group" role="group">
                                                                <a href="${pageContext.request.contextPath}/purchase/rfq?action=view&id=${rfq.rfqId}" 
                                                                   class="btn btn-sm btn-outline-info" title="View details">
                                                                    <i class="fas fa-eye"></i>
                                                                </a>
                                                                <c:if test="${rfq.status eq 'Pending'}">
                                                                    <button type="button" class="btn btn-sm btn-outline-success" 
                                                                            onclick="updateStatus(${rfq.rfqId}, 'Sent')" title="Mark as Sent">
                                                                        <i class="fas fa-paper-plane"></i>
                                                                    </button>
                                                                    <button type="button" class="btn btn-sm btn-outline-danger" 
                                                                            onclick="confirmDelete(${rfq.rfqId})" title="Delete">
                                                                        <i class="fas fa-trash"></i>
                                                                    </button>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Pagination -->
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="Page navigation" style="margin-top: 30px">
                                    <ul class="pagination justify-content-center">
                                        <c:if test="${currentPage > 1}">
                                            <li class="page-item">
                                                <a class="page-link" href="${pageContext.request.contextPath}/purchase/rfq?action=list&page=${currentPage - 1}">
                                                    <span>&laquo;</span>
                                                </a>
                                            </li>
                                        </c:if>

                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="${pageContext.request.contextPath}/purchase/rfq?action=list&page=${i}">${i}</a>
                                            </li>
                                        </c:forEach>

                                        <c:if test="${currentPage < totalPages}">
                                            <li class="page-item">
                                                <a class="page-link" href="${pageContext.request.contextPath}/purchase/rfq?action=list&page=${currentPage + 1}">
                                                    <span>&raquo;</span>
                                                </a>
                                            </li>
                                        </c:if>
                                    </ul>
                                </nav>
                            </c:if>
                        </div>
                    </div>
                </div>
            </main>

            <!-- Footer -->
            <jsp:include page="/purchase/footer.jsp" />
        </div>
    </div>

    <!-- JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app.js"></script>

    <script>
        function updateStatus(rfqId, status) {
            if (confirm('Are you sure you want to update the status?')) {
                window.location.href = '${pageContext.request.contextPath}' + '/purchase/rfq?action=update-status&id=' + rfqId + '&status=' + status;
            }
        }

        function confirmDelete(rfqId) {
            if (confirm('Are you sure you want to delete this RFQ?')) {
                window.location.href = '${pageContext.request.contextPath}' + '/purchase/rfq?action=delete&id=' + rfqId;
            }
        }

        // Toast message display
        var toastMessage = "${sessionScope.toastMessage}";
        var toastType = "${sessionScope.toastType}";
        if (toastMessage) {
            // Simple alert for now - can be replaced with better toast library
            if (toastType === 'success') {
                alert('Success: ' + toastMessage);
            } else {
                alert('Error: ' + toastMessage);
            }
            
            // Remove toast attributes from session
            fetch('${pageContext.request.contextPath}/remove-toast', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
            });
        }
    </script>
</body>
</html> 