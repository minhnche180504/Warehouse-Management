<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List,model.TransferOrder,model.WarehouseDisplay" %>
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
        <link rel="shortcut icon" href="<c:url value='/staff/img/icons/icon-48x48.png'/>" />
        <link rel="canonical" href="forms-layouts.html" />
        <title>Transfer Orders | Warehouse System</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="<c:url value='/staff/css/light.css'/>" rel="stylesheet">
        <script src="<c:url value='/staff/js/settings.js'/>"></script>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <jsp:include page="/staff/WsSidebar.jsp" />
            <div class="main">
                <jsp:include page="/staff/navbar.jsp" />               
                <main class="content">                    
                    <div class="container-fluid p-0">
                        <h1 class="h3 mb-3">Transfer Orders</h1>
                        <div class="row">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-header">
                                        <div class="row">                                            <div class="col-md-6">
                                                <h5 class="card-title">Transfer Order Management</h5>
                                            </div>
                                            <div class="col-md-6 text-end">
                                                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#transferTypeModal">
                                                    <i data-feather="plus"></i> New Transfer Order
                                                </button>
                                            </div>
                                        </div>
                                    </div>                                    <div class="card-body">
                                        <!-- Success and Error Messages -->
                                        <c:if test="${not empty successMessage}">
                                            <div class="alert alert-success alert-dismissible" role="alert">
                                                <div class="alert-message">
                                                    ${successMessage}
                                                </div>
                                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            </div>
                                            <c:remove var="successMessage" scope="session" />
                                        </c:if>
                                        
                                        <c:if test="${not empty errorMessage}">
                                            <div class="alert alert-danger alert-dismissible" role="alert">
                                                <div class="alert-message">
                                                    ${errorMessage}
                                                </div>
                                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            </div>
                                            <c:remove var="errorMessage" scope="session" />
                                        </c:if>
                                        
                                        <!-- Filter Form -->
                                        <form method="get" action="list-transfer-order" class="row mb-4">
                                            <div class="col-md-4">
                                                <label for="type" class="form-label">Transfer Type</label>
                                                <select name="type" id="type" class="form-select">
                                                    <option value="">All Types</option>
                                                    <option value="import" ${selectedType == 'import' ? 'selected' : ''}>Import</option>
                                                    <option value="export" ${selectedType == 'export' ? 'selected' : ''}>Export</option>
                                                    <option value="transfer" ${selectedType == 'transfer' ? 'selected' : ''}>Warehouse Transfer</option>
                                                </select>
                                            </div>
                                            <div class="col-md-4">
                                                <label for="status" class="form-label">Status</label>
                                                <select name="status" id="status" class="form-select">
                                                    <option value="">All Statuses</option>
                                                    <option value="draft" ${selectedStatus == 'draft' ? 'selected' : ''}>Draft</option>
                                                    <option value="processing" ${selectedStatus == 'processing' ? 'selected' : ''}>Processing</option>
                                                    <option value="complete" ${selectedStatus == 'complete' ? 'selected' : ''}>Completed</option>
                                                </select>
                                            </div>
                                            <div class="col-md-4 d-flex align-items-end">
                                                <button type="submit" class="btn btn-primary">Filter</button>
                                                <a href="list-transfer-order" class="btn btn-secondary ms-2">Reset</a>
                                            </div>
                                        </form>

                                        <!-- Transfer Orders Table -->
                                        <div class="table-responsive">
                                            <table class="table table-striped table-hover">
                                                <thead>
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>Type</th>
                                                        <th>Source Warehouse</th>
                                                        <th>Destination</th>
                                                        <th>Created Date</th>
                                                        <th>Status</th>
                                                        <th>Created By</th>
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${transferOrders}" var="order">
                                                        <tr>
                                                            <td>${order.transferId}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${order.transferType == 'import'}">
                                                                        <span class="badge bg-success">Import</span>
                                                                    </c:when>
                                                                    <c:when test="${order.transferType == 'export'}">
                                                                        <span class="badge bg-warning">Export</span>
                                                                    </c:when>
                                                                    <c:when test="${order.transferType == 'transfer'}">
                                                                        <span class="badge bg-info">Transfer</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-secondary">${order.transferType}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>${order.sourceWarehouseName}</td>
                                                            <td>${order.destinationWarehouseName != null ? order.destinationWarehouseName : '-'}</td>
                                                            <td>${order.createdDate}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${order.status == 'draft'}">
                                                                        <span class="badge bg-secondary">Draft</span>
                                                                    </c:when>
                                                                    <c:when test="${order.status == 'processing'}">
                                                                        <span class="badge bg-info">Processing</span>
                                                                    </c:when>
                                                                    <c:when test="${order.status == 'completed'}">
                                                                        <span class="badge bg-success">Completed</span>
                                                                    </c:when>
                                                                    <c:when test="${order.status == 'Complete'}">
                                                                        <span class="badge bg-success">Completed</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge bg-secondary">${order.status}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>${order.creatorName}</td>
                                                            <td class="text-center">
                                                                <a href="view-transfer-order?id=${order.transferId}" class="btn btn-sm btn-info">
                                                                    <i data-feather="eye"></i>
                                                                </a>
                                                                <c:if test="${order.status == 'draft'}">
                                                                    <a href="edit-transfer-order?id=${order.transferId}" class="btn btn-sm btn-primary">
                                                                        <i data-feather="edit"></i>
                                                                    </a>
                                                                    <button class="btn btn-sm btn-success" onclick="confirmComplete(${order.transferId})">
                                                                        <i data-feather="check"></i>
                                                                    </button>
                                                                    <button class="btn btn-sm btn-danger" onclick="confirmDelete(${order.transferId})">
                                                                        <i data-feather="trash"></i>
                                                                    </button>
                                                                </c:if>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                        
                                        <!-- No Records Found Message -->
                                        <c:if test="${empty transferOrders}">
                                            <div class="text-center py-4">
                                                <p>No transfer orders found.</p>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                
                <footer class="footer">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-12">
                                <p class="mb-0">© 2023 Warehouse Management System</p>
                            </div>
                        </div>
                    </div>
                </footer>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteConfirmModalLabel">Confirm Delete</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to delete this transfer order? This action cannot be undone.
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Delete</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Complete Confirmation Modal -->
        <div class="modal fade" id="completeConfirmModal" tabindex="-1" aria-labelledby="completeConfirmModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="completeConfirmModalLabel">Confirm Completion</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to mark this transfer order as completed? This will update the inventory levels.
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <a href="#" id="confirmCompleteBtn" class="btn btn-success">Complete</a>
                    </div>
                </div>
            </div>
        </div>

        <script src="<c:url value='/staff/js/app.js'/>"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                // Initialize feather icons
                feather.replace();
                
                // Apply datatable if needed
                if (document.querySelector(".table")) {
                    $(".table").DataTable({
                        responsive: true
                    });
                }
            });
            
            function confirmDelete(transferId) {
                // Set the delete link
                document.getElementById('confirmDeleteBtn').href = 'delete-transfer-order?id=' + transferId;
                
                // Show the modal
                var deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
                deleteModal.show();
                
                return false;
            }
            
            function confirmComplete(transferId) {
                // Set the complete link
                document.getElementById('confirmCompleteBtn').href = 'complete-transfer-order?id=' + transferId;
                
                // Show the modal
                var completeModal = new bootstrap.Modal(document.getElementById('completeConfirmModal'));
                completeModal.show();
                
                return false;            }
        </script>
        
        <!-- Transfer Order Type Selection Modal -->
        <div class="modal fade" id="transferTypeModal" tabindex="-1" aria-labelledby="transferTypeModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="transferTypeModalLabel">Select Transfer Order Type</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="card h-100 cursor-pointer" onclick="window.location.href='create-transfer-order?type=import'">
                                    <div class="card-body text-center">
                                        <div class="mb-3">
                                            <i data-feather="download" class="feather-xl text-primary"></i>
                                        </div>
                                        <h5>Import Order</h5>
                                        <p class="card-text">Create an order to bring items into inventory</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="card h-100 cursor-pointer" onclick="window.location.href='create-transfer-order?type=export'">
                                    <div class="card-body text-center">
                                        <div class="mb-3">
                                            <i data-feather="upload" class="feather-xl text-warning"></i>
                                        </div>
                                        <h5>Export Order</h5>
                                        <p class="card-text">Create an order to send items out from inventory</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <style>
            .cursor-pointer {
                cursor: pointer;
            }
            
            .cursor-pointer:hover {
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
                transform: translateY(-2px);
                transition: all 0.3s ease;
            }
            
            .feather-xl {
                width: 48px;
                height: 48px;
            }
        </style>
    </body>
</html>
