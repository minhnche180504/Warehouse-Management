<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!doctype html>
<html class="no-js" lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>Manage Suppliers - Manager Dashboard</title>
    <meta name="description" content="Manage Suppliers">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="shortcut icon" type="image/x-icon" href="img/icons/icon-48x48.png">
    
    <!-- CSS here -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
</head>

<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
    <div class="wrapper">
        <!-- Sidebar -->
        <jsp:include page="/purchase/PurchaseSidebar.jsp" />
            <div class="main">
            <jsp:include page="/purchase/navbar.jsp" />

            <main class="content">
                <div class="container-fluid p-0">
                    <div class="row mb-2 mb-xl-3">
                        <div class="col-auto d-none d-sm-block">
                            <h3><strong>Manage</strong> Suppliers</h3>
                        </div>
                        <div class="col-auto ms-auto text-end mt-n1">
                            <a href="<c:url value='/purchase/manage-supplier?action=add'/>" class="btn btn-primary">Add New Supplier</a>
                        </div>
                    </div>

                    <!-- Pagination URL with filters -->
                    <c:url value="/purchase/manage-supplier" var="paginationUrl">
                        <c:param name="action" value="list" />
                        <c:if test="${not empty param.name}">
                            <c:param name="name" value="${param.name}" />
                        </c:if>
                        <c:if test="${not empty param.email}">
                            <c:param name="email" value="${param.email}" />
                        </c:if>
                        <c:if test="${not empty param.phone}">
                            <c:param name="phone" value="${param.phone}" />
                        </c:if>
                        <c:if test="${not empty param.contactPerson}">
                            <c:param name="contactPerson" value="${param.contactPerson}" />
                        </c:if>
                        <c:if test="${not empty param.status}">
                            <c:param name="status" value="${param.status}" />
                        </c:if>
                    </c:url>

                    <!-- Filter Form -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Search Filters</h5>
                        </div>
                        <div class="card-body">
                            <form action="<c:url value='/purchase/manage-supplier'/>" method="GET" class="mb-4">
                                <input type="hidden" name="action" value="list">
                                <div class="row mb-3">
                                    <div class="col-md-2">
                                        <input type="text" class="form-control" name="name" 
                                               placeholder="Search by name..." value="${param.name}">
                                    </div>
                                    <div class="col-md-2">
                                        <input type="text" class="form-control" name="email" 
                                               placeholder="Search by email..." value="${param.email}">
                                    </div>
                                    <div class="col-md-2">
                                        <input type="text" class="form-control" name="phone" 
                                               placeholder="Search by phone..." value="${param.phone}">
                                    </div>
                                    <div class="col-md-2">
                                        <input type="text" class="form-control" name="contactPerson" 
                                               placeholder="Search by contact..." value="${param.contactPerson}">
                                    </div>
                                    <div class="col-md-2">
                                        <select class="form-control" name="status">
                                            <option value="">All Status</option>
                                            <option value="active" <c:if test="${param.status eq 'active'}">selected</c:if>>Active</option>
                                            <option value="deleted" <c:if test="${param.status eq 'deleted'}">selected</c:if>>Deleted</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2">
                                        <button type="submit" class="btn btn-primary w-100">
                                            <i class="align-middle" data-feather="search"></i> Search
                                        </button>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12">
                                        <a href="<c:url value='/purchase/manage-supplier?action=list'/>" class="btn btn-secondary">
                                            <i class="align-middle" data-feather="refresh-cw"></i> Clear Filters
                                        </a>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Suppliers Table -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Suppliers List</h5>
                            <div class="text-muted">Total: ${totalSuppliers} suppliers</div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Name</th>
                                            <th>Address</th>
                                            <th>Phone</th>
                                            <th>Email</th>
                                            <th>Contact Person</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="supplier" items="${suppliers}">
                                            <tr>
                                                <td>${supplier.supplierId}</td>
                                                <td><strong>${supplier.name}</strong></td>
                                                <td>${supplier.address != null ? supplier.address : '-'}</td>
                                                <td>${supplier.phone != null ? supplier.phone : '-'}</td>
                                                <td>${supplier.email != null ? supplier.email : '-'}</td>
                                                <td>${supplier.contactPerson != null ? supplier.contactPerson : '-'}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${supplier.isDeleted}">
                                                            <span class="badge bg-danger">Deleted</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-success">Active</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${!supplier.isDeleted}">
                                                        <a href="<c:url value='/purchase/manage-supplier?action=edit&id=${supplier.supplierId}'/>" 
                                                           class="btn btn-sm btn-outline-primary" title="Edit">
                                                            <i class="align-middle" data-feather="edit"></i>
                                                        </a>
                                                        <a href="<c:url value='/purchase/supplier-rating?action=add&supplierId=${supplier.supplierId}'/>" 
                                                           class="btn btn-sm btn-outline-warning" title="Rate Supplier">
                                                            <i class="align-middle" data-feather="star"></i>
                                                        </a>
                                                        <a href="<c:url value='/purchase/supplier-rating?action=supplier-ratings&supplierId=${supplier.supplierId}'/>" 
                                                           class="btn btn-sm btn-outline-info" title="View Ratings">
                                                            <i class="align-middle" data-feather="eye"></i>
                                                        </a>
                                                        <button onclick="confirmDelete(${supplier.supplierId})" 
                                                                class="btn btn-sm btn-outline-danger" title="Delete">
                                                            <i class="align-middle" data-feather="trash-2"></i>
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${supplier.isDeleted}">
                                                        <button onclick="confirmRestore(${supplier.supplierId})" 
                                                                class="btn btn-sm btn-outline-success" title="Restore">
                                                            <i class="align-middle" data-feather="refresh-cw"></i> Restore
                                                        </button>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty suppliers}">
                                            <tr>
                                                <td colspan="8" class="text-center text-muted">No suppliers found</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Pagination -->
                            <c:if test="${totalPages > 1}">
                                <nav aria-label="Page navigation" style="margin-top: 30px">
                                    <ul class="pagination justify-content-center">
                                        <c:if test="${currentPage > 1}">
                                            <li class="page-item">
                                                <a class="page-link" href="${paginationUrl}&page=${currentPage - 1}" aria-label="Previous">
                                                    <span aria-hidden="true">&laquo;</span>
                                                </a>
                                            </li>
                                        </c:if>

                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="${paginationUrl}&page=${i}">${i}</a>
                                            </li>
                                        </c:forEach>

                                        <c:if test="${currentPage < totalPages}">
                                            <li class="page-item">
                                                <a class="page-link" href="${paginationUrl}&page=${currentPage + 1}" aria-label="Next">
                                                    <span aria-hidden="true">&raquo;</span>
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

            <footer class="footer">
                <div class="container-fluid">
                </div>
            </footer>
        </div>
    </div>

    <script src="js/app.js"></script>

    <script>
        function confirmDelete(supplierId) {
            if (confirm('Are you sure you want to delete this supplier?')) {
                window.location.href = '${pageContext.request.contextPath}/purchase/manage-supplier?action=delete&id=' + supplierId;
            }
        }

        function confirmRestore(supplierId) {
            if (confirm('Are you sure you want to restore this supplier?')) {
                window.location.href = '${pageContext.request.contextPath}/purchase/manage-supplier?action=restore&id=' + supplierId;
            }
        }

        // Toast message display
        var toastMessage = "${sessionScope.toastMessage}";
        var toastType = "${sessionScope.toastType}";
        if (toastMessage && window.notyf) {
            window.notyf.open({
                type: toastType === 'success' ? 'success' : 'error',
                message: toastMessage,
                duration: 5000
            });
            
            // Remove toast attributes from session
            fetch('${pageContext.request.contextPath}/remove-toast', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                }
            }).catch(function(error) {
                console.error('Error:', error);
            });
        }
    </script>
</body>

</html>