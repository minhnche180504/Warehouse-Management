<%-- /web/view/stockcheck/list-stock-check-reports.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>
<%@ page import="dao.AuthorizationUtil" %>

<%
    User currentUser = (User) session.getAttribute("user");
    // This page should be protected by the AuthenticationFilter and possibly a RoleFilter
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    pageContext.setAttribute("currentUser", currentUser); // Make currentUser available for JSTL
    pageContext.setAttribute("isAdmin", AuthorizationUtil.isAdmin(currentUser));
    pageContext.setAttribute("isWarehouseManager", AuthorizationUtil.isWarehouseManager(currentUser));
    pageContext.setAttribute("isWarehouseStaff", AuthorizationUtil.isWarehouseStaff(currentUser));
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Stock Check Reports</title>
    <link href="${pageContext.request.contextPath}/manager/css/light.css" rel="stylesheet">
    <%-- Add other necessary CSS/JS --%>
    <style>
        .status-draft { background-color: #6c757d; color: #fff; }
        .status-pending { background-color: #ffc107; color: #000; }
        .status-approved { background-color: #28a745; color: #fff; }
        .status-rejected { background-color: #dc3545; color: #fff; }
        .status-completed { background-color: #007bff; color: #fff; }
    </style>
</head>
<body>
    <div class="wrapper">
        <jsp:include page="/manager/ManagerSidebar.jsp"/>
        <div class="main">
            <jsp:include page="/manager/navbar.jsp" />

            <main class="content">
                <div class="container-fluid p-0">
                    <div class="row mb-2 mb-xl-3">
                        <div class="col-auto d-none d-sm-block">
                            <h3><strong>Stock Check</strong> Reports</h3>
                        </div>
                        <div class="col-auto ms-auto text-end mt-n1">
                            <c:if test="${isWarehouseStaff || isWarehouseManager || isAdmin}">
                                <a href="${pageContext.request.contextPath}/manager/create-stock-check-report" class="btn btn-primary">Create New Report</a>
                            </c:if>
                        </div>
                    </div>

                    <%-- Success/Error Messages --%>
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            ${successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <%-- Filter Form --%>
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title">Filter Reports</h5>
                        </div>
                        <div class="card-body">
                            <form method="GET" action="${pageContext.request.contextPath}/manager/list-stock-check-reports">
                                <div class="row">
                                    <div class="col-md-3 mb-3">
                                        <label for="reportCode" class="form-label">Report Code</label>
                                        <input type="text" class="form-control" id="reportCode" name="reportCode" value="${searchedReportCode}">
                                    </div>
                                    <c:if test="${not empty warehouses}">
                                        <div class="col-md-2 mb-3">
                                            <label for="warehouseId" class="form-label">Warehouse</label>
                                            <select class="form-select" id="warehouseId" name="warehouseId">
                                                <option value="">All</option>
                                                <c:forEach var="wh" items="${warehouses}">
                                                    <option value="${wh.warehouseId}" ${wh.warehouseId == selectedWarehouseId ? 'selected' : ''}>${wh.warehouseName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </c:if>
                                    <div class="col-md-2 mb-3">
                                        <label for="status" class="form-label">Status</label>
                                        <select class="form-select" id="status" name="status">
                                            <option value="">All</option>
                                            <option value="Draft" ${"Draft" == selectedStatus ? 'selected' : ''}>Draft</option>
                                            <option value="Pending" ${"Pending" == selectedStatus ? 'selected' : ''}>Pending</option>
                                            <option value="Approved" ${"Approved" == selectedStatus ? 'selected' : ''}>Approved</option>
                                            <option value="Rejected" ${"Rejected" == selectedStatus ? 'selected' : ''}>Rejected</option>
                                            <option value="Completed" ${"Completed" == selectedStatus ? 'selected' : ''}>Completed</option>
                                        </select>
                                    </div>
                                    <div class="col-md-2 mb-3">
                                        <label for="fromDate" class="form-label">From Date</label>
                                        <input type="date" class="form-control" id="fromDate" name="fromDate" value="${selectedFromDate}">
                                    </div>
                                    <div class="col-md-2 mb-3">
                                        <label for="toDate" class="form-label">To Date</label>
                                        <input type="date" class="form-control" id="toDate" name="toDate" value="${selectedToDate}">
                                    </div>
                                    <div class="col-md-1 align-self-end mb-3">
                                        <button type="submit" class="btn btn-primary">Filter</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title">Report List</h5>
                        </div>
                        <div class="card-body">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Report Code</th>
                                        <th>Warehouse</th>
                                        <th>Report Date</th>
                                        <th>Created By</th>
                                        <th>Status</th>
                                        <th>Approved By</th>
                                        <th>Approved At</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty reports}">
                                            <c:forEach var="report" items="${reports}">
                                                <tr>
                                                    <td>${report.reportCode}</td>
                                                    <td>${report.warehouseName}</td>
                                                    <td><fmt:formatDate value="${report.reportDate}" pattern="dd/MM/yyyy"/></td>
                                                    <td>${report.createdByName}</td>
                                                    <td>
                                                        <span class="badge ${report.status == 'Draft' ? 'status-draft' : report.status == 'Pending' ? 'status-pending' : report.status == 'Approved' ? 'status-approved' : report.status == 'Rejected' ? 'status-rejected' : report.status == 'Completed' ? 'status-completed' : 'bg-secondary'}">
                                                            ${report.status}
                                                        </span>
                                                    </td>
                                                    <td>${not empty report.approvedByName ? report.approvedByName : '-'}</td>
                                                    <td>
                                                        <c:if test="${not empty report.approvedAt}">
                                                            <fmt:formatDate value="${report.approvedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </c:if>
                                                        <c:if test="${empty report.approvedAt}">-</c:if>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/manager/manage-stock-check-report?action=view&reportId=${report.reportId}" class="btn btn-sm btn-info" title="View">
                                                            <i data-feather="eye"></i>
                                                        </a>
                                                        
                                                        <%-- Show Edit/Delete only if status is Draft and user is creator --%>
                                                        <c:if test="${isWarehouseManager && report.status == 'Draft' && currentUser.userId == report.createdBy}">
                                                            <a href="${pageContext.request.contextPath}/manager/manage-stock-check-report?action=edit&reportId=${report.reportId}" class="btn btn-sm btn-warning" title="Edit">
                                                                <i data-feather="edit-2"></i>
                                                            </a>
                                                            <button type="button" class="btn btn-sm btn-danger delete-btn" title="Delete" data-bs-toggle="modal" data-bs-target="#deleteModal" data-report-id="${report.reportId}" data-report-code="${report.reportCode}">
                                                                <i data-feather="trash-2"></i>
                                                            </button>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="8" class="text-center">No reports found.</td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>

            <jsp:include page="/manager/footer.jsp" />
        </div>
    </div>

    <%-- Modals for Approve/Reject/Complete/Delete --%>
    <%-- Approve Modal --%>
    <div class="modal fade" id="approveModal" tabindex="-1" aria-labelledby="approveModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/manager/manage-stock-check-report" method="post">
                    <input type="hidden" name="formAction" value="approve">
                    <input type="hidden" name="reportId" id="approveReportId">
                    <div class="modal-header">
                        <h5 class="modal-title" id="approveModalLabel">Approve Stock Check Report</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to approve this stock check report?</p>
                        <div class="mb-3">
                            <label for="managerNotes_approve" class="form-label">Manager Notes (Optional):</label>
                            <textarea class="form-control" id="managerNotes_approve" name="managerNotes_approve" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success">Approve</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%-- Reject Modal --%>
    <div class="modal fade" id="rejectModal" tabindex="-1" aria-labelledby="rejectModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/manager/manage-stock-check-report" method="post">
                    <input type="hidden" name="formAction" value="reject">
                    <input type="hidden" name="reportId" id="rejectReportId">
                    <div class="modal-header">
                        <h5 class="modal-title" id="rejectModalLabel">Reject Stock Check Report</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to reject this stock check report?</p>
                        <div class="mb-3">
                            <label for="managerNotes_reject" class="form-label">Reason for Rejection <span class="text-danger">*</span>:</label>
                            <textarea class="form-control" id="managerNotes_reject" name="managerNotes_reject" rows="3" required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">Reject</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%-- Complete Modal --%>
    <div class="modal fade" id="completeModal" tabindex="-1" aria-labelledby="completeModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/manager/manage-stock-check-report" method="post">
                    <input type="hidden" name="formAction" value="complete">
                    <input type="hidden" name="reportId" id="completeReportId">
                    <div class="modal-header">
                        <h5 class="modal-title" id="completeModalLabel">Complete Stock Check Report</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to complete this stock check report?</p>
                        <p class="text-danger">This action will adjust inventory based on counted quantities.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Complete</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%-- Delete Modal --%>
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="${pageContext.request.contextPath}/manager/manage-stock-check-report" method="post">
                    <input type="hidden" name="formAction" value="delete">
                    <input type="hidden" name="reportId" id="deleteReportId">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteModalLabel">Delete Stock Check Report</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>Are you sure you want to delete report <strong id="deleteReportCode"></strong>? This action cannot be undone.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/manager/js/app.js"></script>
    <script src="https://unpkg.com/feather-icons"></script>
    <script>
        feather.replace();
         // Auto-dismiss alerts after 5 seconds
        const successAlert = document.querySelector('.alert-success');
        if(successAlert) {
            setTimeout(() => {
                new bootstrap.Alert(successAlert).close();
            }, 5000);
        }
        const errorAlert = document.querySelector('.alert-danger');
        if(errorAlert) {
            setTimeout(() => {
                new bootstrap.Alert(errorAlert).close();
            }, 7000);
        }

        // Handle data-report-id for modals
        $(document).ready(function() {
            $('.approve-btn').on('click', function() {
                var reportId = $(this).data('report-id');
                $('#approveReportId').val(reportId);
            });
            $('.reject-btn').on('click', function() {
                var reportId = $(this).data('report-id');
                $('#rejectReportId').val(reportId);
            });
            $('.complete-btn').on('click', function() {
                var reportId = $(this).data('report-id');
                $('#completeReportId').val(reportId);
            });
            $('.delete-btn').on('click', function() {
                var reportId = $(this).data('report-id');
                var reportCode = $(this).data('report-code');
                $('#deleteReportId').val(reportId);
                $('#deleteReportCode').text(reportCode);
            });
        });
    </script>
</body>
</html>
