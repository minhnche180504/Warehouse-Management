<%-- 
    Document   : customerQuote-list
    Created on : Jul 1, 2025, 9:35:07 PM
    Author     : nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.List, model.CustomerQuote" %>
<%
    String success = request.getParameter("success");
    if (success != null) {
        request.setAttribute("success", success);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Quotation List | Warehouse System</title>
    <link href="css/light.css" rel="stylesheet">
    <script src="js/settings.js"></script>
    <style>
        body { opacity: 0; }
        div.dataTables_filter { display: none !important; }
        .btn-create-order {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            color: white;
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
            transition: all 0.2s ease;
        }
        .btn-create-order:hover {
            background: linear-gradient(135deg, #218838 0%, #1e7e34 100%);
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
        }
        .btn-create-order:disabled {
            background: #6c757d;
            opacity: 0.6;
            cursor: not-allowed;
        }
        .action-btns .btn {
            margin-right: 0.25rem;
            margin-bottom: 0.25rem;
        }
    </style>
</head>
<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
    <div class="wrapper">
        <jsp:include page="/sale/SalesSidebar.jsp" />
        <div class="main">
            <jsp:include page="/sale/navbar.jsp" />
            <main class="content">
                <div class="container-fluid p-0">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h1 class="h3 fw-bold">Quotation List</h1>
                        <a href="createCustomerQuote" class="btn btn-primary">
                            <i class="align-middle" data-feather="plus-circle"></i> Create Quotation
                        </a>
                    </div>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            <div class="alert-icon"><i data-feather="alert-triangle"></i></div>
                            <div class="alert-message"><strong>Error!</strong> ${error}</div>
                        </div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            <div class="alert-icon"><i data-feather="check-circle"></i></div>
                            <div class="alert-message"><strong>Success!</strong> ${success}</div>
                        </div>
                    </c:if>
                    <div class="row mb-3">
                        <div class="col-md-12">
                            <form action="/sale/listCustomerQuote" method="GET" class="row g-3">
                                <div class="col-md-4">
                                    <input type="text" class="form-control" name="customerName" 
                                           placeholder="Search by customer name..." 
                                           value="${param.customerName}">
                                </div>
                                <div class="col-md-4">
                                    <input type="date" class="form-control" name="createdAt" 
                                           value="${param.createdAt}">
                                </div>
                                <div class="col-md-4">
                                    <button class="btn btn-primary" type="submit">
                                        <i data-feather="search"></i> Search
                                    </button>
                                    <a href="listCustomerQuote" class="btn btn-secondary">
                                        <i data-feather="x"></i> Clear
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="card shadow-sm">
                                <div class="card-body">
                                    <table id="datatables-quotes" class="table table-striped table-hover" style="width:100%">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Created At</th>
                                                <th>Customer ID</th>
                                                <th>Valid Until</th>
                                                <th>Total Amount</th>
                                                <th>Notes</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${quotes}" var="q">
                                                <tr>
                                                    <td>Q-<fmt:formatNumber value="${q.quotationId}" pattern="000"/></td>
                                                    <td><fmt:formatDate value="${q.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                                                    <td>${q.customerName}</td>
                                                    <td><fmt:formatDate value="${q.validUntil}" pattern="yyyy-MM-dd"/></td>
                                                    <td><fmt:formatNumber value="${q.totalAmount}" type="currency" currencySymbol="₫"/></td>
                                                    <td>${q.notes}</td>
                                                    <td class="action-btns">
                                                        <a href="customerQuoteDetail?id=${q.quotationId}" class="btn btn-sm btn-info me-1" title="View Details">
                                                            <i data-feather="eye"></i>
                                                        </a>
                                                        <a href="quotation-to-sales-order?quotationId=${q.quotationId}" 
                                                           class="btn btn-sm btn-create-order me-1" 
                                                           title="Create Sales Order">
                                                            <i data-feather="shopping-cart"></i>
                                                        </a>          
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <footer class="footer">
                <jsp:include page="/sale/footer.jsp" />
            </footer>
        </div>
    </div>
    <script src="js/app.js"></script>
    <script src="js/datatables.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            $("#datatables-quotes").DataTable({
                responsive: true,
                "order": [[0, "desc"]],
                "columnDefs": [
                    {"orderable": true, "targets": [0, 1, 2, 3, 4]},
                    {"orderable": false, "targets": [5, 6]}
                ],
                "language": {
                    "search": "Search:",
                    "lengthMenu": "Show _MENU_ entries per page",
                    "info": "Showing _START_ to _END_ of _TOTAL_ entries",
                    "infoEmpty": "Showing 0 to 0 of 0 entries",
                    "infoFiltered": "(filtered from _MAX_ total entries)",
                    "zeroRecords": "No matching records found",
                    "paginate": {
                        "first": "First",
                        "last": "Last",
                        "next": "Next",
                        "previous": "Previous"
                    }
                }
            });
            
            // Add loading state to Create Order buttons
            document.querySelectorAll('.btn-create-order:not([disabled])').forEach(function(btn) {
                btn.addEventListener('click', function(e) {
                    // Add loading state
                    this.disabled = true;
                    this.innerHTML = '<span class="spinner-border spinner-border-sm"></span>';
                    
                    // Re-enable after 10 seconds as fallback
                    setTimeout(() => {
                        this.disabled = false;
                        this.innerHTML = '<i data-feather="shopping-cart"></i>';
                        if (typeof feather !== 'undefined') {
                            feather.replace();
                        }
                    }, 10000);
                });
            });
            
            if (typeof feather !== 'undefined') {
                feather.replace();
            }
        });
    </script>
</body>
</html>