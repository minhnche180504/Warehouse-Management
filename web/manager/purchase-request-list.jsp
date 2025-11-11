<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Purchase Requests</title>
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/manager/img/icons/icon-48x48.png" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet" />
        <link class="js-stylesheet" href="${pageContext.request.contextPath}/manager/css/light.css" rel="stylesheet" />
        <style>
            body {
                font-family: 'Inter', 'Roboto', Arial, sans-serif;
                background: #f6f8fa;
            }
            .table-custom {
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 4px 16px rgba(0,0,0,0.07);
                background: #fff;
            }
            .table-custom thead {
                background-color: #f1f3f6;
            }
            .table-custom tbody tr:nth-child(odd) {
                background-color: #f9fbfd;
            }
            .table-custom tbody tr:nth-child(even) {
                background-color: #eef2f7;
            }
            .table-custom tbody tr:hover {
                background: #e3f2fd;
                transition: background 0.2s;
            }
            .badge-status {
                font-size: 0.85em;
                padding: 0.4em 1em;
                border-radius: 1em;
                font-weight: 700;
                letter-spacing: 0.02em;
                text-transform: uppercase;
                box-shadow: 0 1px 4px rgba(0,0,0,0.04);
            }
            .badge-status-pending { background-color: #ff9800; color: #fff; }
            .badge-status-purchasing { background-color: #42a5f5; color: #fff; }
            .badge-status-savedraft { background-color: #757575; color: #fff; }
            .card, .card.shadow-sm {
                border-radius: 14px;
                box-shadow: 0 2px 12px rgba(0,0,0,0.06);
                border: none;
            }
            .btn {
                border-radius: 8px;
                font-weight: 500;
            }
            .form-control, .form-select {
                border-radius: 8px;
                border: 1px solid #e0e3e7;
                background: #f8fafc;
            }
            .form-control:focus, .form-select:focus {
                border-color: #1976d2;
                box-shadow: 0 0 0 2px #e3f2fd;
            }
            div.dataTables_wrapper div.dataTables_filter { display: none !important; }
        </style>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <jsp:include page="ManagerSidebar.jsp"></jsp:include>
            <div class="main">
                <jsp:include page="navbar.jsp"></jsp:include>
                <main class="content">
                    <div class="container-fluid p-0">
                        <c:if test="${not empty sessionScope.globalSuccess}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                ${sessionScope.globalSuccess}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="globalSuccess" scope="session" />
                        </c:if>
                        <c:if test="${not empty sessionScope.globalError}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${sessionScope.globalError}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="globalError" scope="session" />
                        </c:if>
                        
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h1 class="h3">Purchase Requests</h1>
                            <a href="${pageContext.request.contextPath}/manager/purchase-request?action=create" class="btn btn-primary">
                                <i class="align-middle" data-feather="plus"></i> Create New
                            </a>
                        </div>

                        <div class="card shadow-sm">
                            <div class="card-header">
                                <form action="${pageContext.request.contextPath}/manager/purchase-request" method="get" class="d-flex justify-content-end gap-2">
                                    <input type="hidden" name="action" value="list">
                                    <div class="flex-grow-1" style="max-width: 300px;">
                                        <input type="text" name="search" class="form-control" placeholder="Search by PR Code, Date..." value="${param.search}">
                                    </div>
                                    <div style="min-width: 180px;">
                                        <select name="status" class="form-select">
                                            <option value="">All Statuses</option>
                                            <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Pending</option>
                                            <option value="save draft" ${param.status == 'save draft' ? 'selected' : ''}>Save Draft</option>
                                            <option value="purchasing" ${param.status == 'Purchasing' ? 'selected' : ''}>Purchasing</option>
                                        </select>
                                    </div>
                                    <button type="submit" class="btn btn-secondary">Filter</button>
                                </form>
                            </div>
                            <div class="card-body">
                                <table id="datatables-purchase-requests" class="table table-hover table-custom w-100">
                                    <thead>
                                        <tr>
                                            <th>PR Number</th>
                                            <th>Request Date</th>
                                            <th>Requested By</th>
                                            <th>Status</th>
                                            <th class="text-center">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="pr" items="${purchaseRequests}">
                                            <tr>
                                                <td>${pr.prNumber}</td>
                                                <td><fmt:formatDate value="${pr.requestDate}" pattern="yyyy-MM-dd"/></td>
                                                <td>${pr.requestedByName}</td>
                                                <td>
                                                    <span class="badge-status badge-status-${fn:toLowerCase(fn:replace(pr.status, ' ', ''))}">
                                                        ${pr.status}
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                     <a href="${pageContext.request.contextPath}/manager/purchase-request?action=view&id=${pr.prId}" class="btn btn-sm btn-outline-info" data-bs-toggle="tooltip" title="View Details">
                                                        <i data-feather="eye"></i>
                                                    </a>
                                                    <c:if test="${fn:toLowerCase(pr.status) == 'save draft'}">
                                                        <a href="${pageContext.request.contextPath}/manager/purchase-request?action=edit&id=${pr.prId}" class="btn btn-sm btn-outline-warning" data-bs-toggle="tooltip" title="Edit">
                                                            <i data-feather="edit-2"></i>
                                                        </a>
                                                        <form method="post" action="${pageContext.request.contextPath}/manager/purchase-request" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this request?');">
                                                            <input type="hidden" name="action" value="delete" />
                                                            <input type="hidden" name="id" value="${pr.prId}" />
                                                            <button type="submit" class="btn btn-sm btn-outline-danger" data-bs-toggle="tooltip" title="Delete">
                                                                <i data-feather="trash-2"></i>
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </main>
                <jsp:include page="footer.jsp"></jsp:include>
            </div>
        </div>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/manager/js/app.js"></script>
        <script src="${pageContext.request.contextPath}/manager/js/datatables.js"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                var table = $("#datatables-purchase-requests").DataTable({
                    responsive: true,
                     ordering: false, // Disable ordering since we handle it server-side
                    "bFilter": true, // Enable client-side filter to work with our custom search box
                });
                // Link custom search box to DataTable's search functionality
                $('input[name="search"]').on('keyup', function(){
                    table.search($(this).val()).draw();
                });
            });
        </script>
    </body>
</html>
