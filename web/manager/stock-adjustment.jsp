<%-- 
    Document   : importRequest-list
    Created on : Jun 12, 2025, 11:19:03 AM
    Author     : nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.List, model.ImportRequest" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Responsive Admin &amp; Dashboard Template based on Bootstrap 5">
        <meta name="author" content="AdminKit">
        <meta name="keywords" content="adminkit, bootstrap, bootstrap 5, admin, dashboard, template, responsive, css, sass, html, theme, front-end, ui kit, web">
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link rel="shortcut icon" href="img/icons/icon-48x48.png" />
        <link rel="canonical" href="stock-request" />
        <title>Import Request Management</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
        <script src="js/settings.js"></script>
        <style>
            body {
                opacity: 0;
            }
            div.dataTables_filter {
                display: none !important;
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
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h1 class="h3 fw-bold">Approve Stock Adjustment</h1>
                        </div>

                        <!-- Search Form -->
                        <div class="row mb-3">
                            <div class="col-md-12">
                                <form action="stock-request" method="GET" class="row g-3">
                                    <div class="col-md-4">
                                        <input type="text" class="form-control" name="productName" 
                                               placeholder="Search by product name..." 
                                               value="${param.productName}">
                                    </div>
                                    <div class="col-md-4">
                                        <input type="date" class="form-control" name="requestDate" 
                                               value="${param.requestDate}">
                                    </div>
                                    <div class="col-md-4">
                                        <button class="btn btn-primary" type="submit">
                                            <i data-feather="search"></i> Search
                                        </button>
                                        <a href="stock-request" class="btn btn-secondary">
                                            <i data-feather="x"></i> Clear
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                <div class="alert-icon">
                                    <i data-feather="alert-triangle"></i>
                                </div>
                                <div class="alert-message">
                                    <strong>Error!</strong> ${error}
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                <div class="alert-icon">
                                    <i data-feather="check-circle"></i>
                                </div>
                                <div class="alert-message">
                                    <strong>Success!</strong> ${success}
                                </div>
                            </div>
                        </c:if>                  
                        <div class="row">
                            <div class="col-12">
                                <div class="card shadow-sm">
                                    <div class="card-body">
                                        <table id="datatables-import-requests" class="table table-striped table-hover" style="width:100%">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Date</th>
                                                    <th>Created By</th>
                                                    <th>Status</th>
                                                    <th>Type</th>
                                                    <th>Rejection Reason</th> <!-- thêm cột -->
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${importRequests}" var="ir">
                                                    <tr>
                                                        <td>${ir.requestId}</td>
                                                        <td><fmt:formatDate value="${ir.requestDate}" pattern="yyyy-MM-dd"/></td>
                                                        <td>${ir.createdByName}</td>
                                                        <td>
                                                            <span class="badge bg-${ir.status == 'Pending' ? 'warning' : 
                                                                                    ir.status == 'Approved' ? 'success' : 
                                                                                    ir.status == 'Rejected' ? 'danger' : 'info'}">
                                                                      ${ir.status}
                                                                  </span>
                                                            </td>
                                                            <td>
                                                                ${ir.type}
                                                            </td>
                                                            <td>
                                                                <c:if test="${ir.status == 'Rejected'}">
                                                                    <span class="text-danger">${ir.rejectionReason}</span>
                                                                </c:if>
                                                            </td>
                                                            <td class="action-btns">
                                                                <a href="stock-adjustment-detail?requestId=${ir.requestId}" class="btn btn-sm btn-info me-1" title="View Details">
                                                                    <i data-feather="eye"></i>
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
                        <div class="container-fluid">
                            <div class="row text-muted">
                                <div class="col-6 text-start">
                                    <p class="mb-0">
                                        <a class="text-muted" href="#" target="_blank"><strong>AdminKit</strong></a> &copy;
                                    </p>
                                </div>
                                <div class="col-6 text-end">
                                    <ul class="list-inline">
                                        <li class="list-inline-item">
                                            <a class="text-muted" href="#">Support</a>
                                        </li>
                                        <li class="list-inline-item">
                                            <a class="text-muted" href="#">Help Center</a>
                                        </li>
                                        <li class="list-inline-item">
                                            <a class="text-muted" href="#">Privacy</a>
                                        </li>
                                        <li class="list-inline-item">
                                            <a class="text-muted" href="#">Terms</a>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </footer>
                </div>
            </div>
            <script src="js/app.js"></script>
            <script src="js/datatables.js"></script>
            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    $("#datatables-import-requests").DataTable({
                        responsive: true,
                        "order": [[0, "asc"]],
                        "columnDefs": [
                            {"orderable": true, "targets": [0, 1, 2, 3, 4]},
                            {"orderable": false, "targets": [5]}
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
                    if (typeof feather !== 'undefined') {
                        feather.replace();
                    }
                });
            </script>
        </body>
    </html>
