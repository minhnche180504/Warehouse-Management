<%-- 
    Document   : listCustomer
    Created on : Jun 10, 2025, 10:39:42 AM
    Author     : nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
        <link rel="canonical" href="createCustomer" />
        <title>Customer Management</title>
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
            <jsp:include page="/sale/SalesSidebar.jsp" />
            <div class="main">
                <jsp:include page="/sale/navbar.jsp" />
                <main class="content">
                    <div class="container-fluid p-0">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h1 class="h3 fw-bold">Customer List</h1>
                            <a href="createCustomer" class="btn btn-primary">
                                <i class="align-middle" data-feather="plus-circle"></i> Add New Customer
                            </a>
                        </div>
                        
                        <!-- Search Form -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <form action="/sale/listCustomer" method="GET">
                                    <div class="input-group">
                                        <input type="text" class="form-control" name="search" 
                                               placeholder="Search by name, email or phone..." 
                                               value="${searchTerm}">
                                        <button class="btn btn-primary" type="submit">
                                            <i data-feather="search"></i> Search
                                        </button>
                                        <c:if test="${not empty searchTerm}">
                                            <a href="listCustomer" class="btn btn-secondary">
                                                <i data-feather="x"></i> Clear
                                            </a>
                                        </c:if>
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
                        
                        <c:if test="${not empty message}">
                            <div class="alert alert-${messageType} alert-dismissible fade show" role="alert">
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                <div class="alert-icon">
                                    <i data-feather="${messageIcon}"></i>
                                </div>
                                <div class="alert-message">
                                    <strong>${messageTitle}</strong> ${message}
                                </div>
                            </div>
                        </c:if>
                        
                        <div class="row">
                            <div class="col-12">
                                <div class="card shadow-sm">
                                    <div class="card-body">
                                        <table id="datatables-customers" class="table table-striped table-hover" style="width:100%">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Name</th>
                                                    <th>Email</th>
                                                    <th>Phone</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="customer" items="${customers}">
                                                    <tr>
                                                        <td>${customer.customerId}</td>
                                                        <td>${customer.customerName}</td>
                                                        <td>${customer.email != null ? customer.email : 'N/A'}</td>
                                                        <td>${customer.phone != null ? customer.phone : 'N/A'}</td>
                                                        <td class="action-btns">
                                                            <a href="customerDetail?id=${customer.customerId}" class="btn btn-sm btn-info" title="View Details">
                                                                <i data-feather="eye"></i>
                                                            </a>
                                                            <a href="updateCustomer?id=${customer.customerId}" class="btn btn-sm btn-warning" title="Edit">
                                                                <i data-feather="edit-2"></i>
                                                            </a>
                                                            <button type="button" class="btn btn-sm btn-danger delete-customer-btn"
                                                                    data-bs-toggle="modal" data-bs-target="#deleteCustomerModal"
                                                                    data-id="${customer.customerId}"
                                                                    data-name="${customer.customerName}"
                                                                    title="Delete">
                                                                <i data-feather="trash-2"></i>
                                                            </button>
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
                <!-- Delete Customer Modal -->
                <div class="modal fade" id="deleteCustomerModal" tabindex="-1" aria-labelledby="deleteCustomerModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="deleteCustomerModalLabel">Confirm Deletion</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                Are you sure you want to delete customer: <strong id="deleteCustomerName"></strong>?
                                This action cannot be undone.
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <form id="deleteCustomerForm" action="deleteCustomer" method="POST" style="display: inline;">
                                    <input type="hidden" id="deleteCustomerIdInput" name="id">
                                    <button type="submit" class="btn btn-danger">Delete</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
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
                $("#datatables-customers").DataTable({
                    responsive: true,
                    "order": [[0, "asc"]],
                    "columnDefs": [
                        { "orderable": false, "targets": [2, 3, 4] }
                    ]
                });
                if (typeof feather !== 'undefined') {
                    feather.replace();
                }
                // Handle Delete Customer Modal
                const deleteCustomerModal = document.getElementById('deleteCustomerModal');
                if (deleteCustomerModal) {
                    deleteCustomerModal.addEventListener('show.bs.modal', function (event) {
                        const button = event.relatedTarget; // Button that triggered the modal
                        const customerId = button.getAttribute('data-id');
                        const customerName = button.getAttribute('data-name');
                        const modalCustomerName = deleteCustomerModal.querySelector('#deleteCustomerName');
                        const deleteIdInput = deleteCustomerModal.querySelector('#deleteCustomerIdInput');
                        modalCustomerName.textContent = customerName;
                        deleteIdInput.value = customerId;
                    });
                }
            });
        </script>
    </body>
</html>
