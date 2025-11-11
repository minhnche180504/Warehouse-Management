<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.InventoryTransfer,model.InventoryTransferItem" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        <link rel="canonical" href="forms-layouts.html" />
        <title>Create Inventory Transfer | Warehouse System</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <link href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css" rel="stylesheet" />
        <style>
            .select2-container--bootstrap-5 .select2-selection {
                border: 1px solid #ced4da;
                padding: 0.375rem 0.75rem;
                font-size: 1rem;
                border-radius: 0.25rem;
            }
            .select2-container--bootstrap-5 .select2-search--dropdown .select2-search__field {
                padding: 8px;
                border-radius: 4px;
                border: 1px solid #ced4da;
            }
            .select2-container--bootstrap-5 .select2-selection--single .select2-selection__rendered {
                padding-left: 0;
            }
            .select2-container--bootstrap-5 .select2-dropdown {
                border-color: #ced4da;
                box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            }
            .select2-container--bootstrap-5 .select2-results__option--highlighted[aria-selected] {
                background-color: #007bff;
            }
        </style>
        <script src="js/settings.js"></script>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <jsp:include page="/manager/ManagerSidebar.jsp" />
            <div class="main">
                <jsp:include page="/manager/navbar.jsp" />
                <main class="content">
                    <div class="container-fluid p-0">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h1 class="h3 mb-0">Inventory Transfer Details</h1>
                            <a href="list-inventory-transfer" class="btn btn-secondary">
                                <i data-feather="arrow-left"></i> Back to List
                            </a>
                        </div>

                        <div class="row">
                            <div class="col-12">
                                <!-- Success and Error Messages -->
                                <c:if test="${not empty successMessage}">
                                    <div class="alert alert-success alert-dismissible" role="alert">
                                        <div class="alert-message">
                                            ${successMessage}
                                        </div>
                                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                    </div>
                                </c:if>

                                <c:if test="${not empty errorMessage}">
                                    <div class="alert alert-danger alert-dismissible" role="alert">
                                        <div class="alert-message">
                                            ${errorMessage}
                                        </div>
                                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                    </div>
                                </c:if>

                                <!-- Transfer Information Card -->
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <h5 class="card-title mb-0">Transfer Information</h5>
                                            <div>
                                                <c:choose>
                                                    <c:when test="${transfer.status == 'draft'}">
                                                        <span class="badge bg-secondary fs-6">Draft</span>
                                                    </c:when>
                                                    <c:when test="${transfer.status == 'pending'}">
                                                        <span class="badge bg-warning fs-6">Pending</span>
                                                    </c:when>
                                                    <c:when test="${transfer.status == 'processing'}">
                                                        <span class="badge bg-success fs-6">Processing</span>
                                                    </c:when>
                                                    <c:when test="${transfer.status == 'rejected'}">
                                                        <span class="badge bg-danger fs-6">Rejected</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-info fs-6">${transfer.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <table class="table table-borderless">
                                                    <tr>
                                                        <td><strong>Transfer ID:</strong></td>
                                                        <td>IT-${String.format("%03d", transfer.transferId)}</td>
                                                    </tr>
                                                    <tr>
                                                        <td><strong>Source Warehouse:</strong></td>
                                                        <td>${transfer.sourceWarehouseName}</td>
                                                    </tr>
                                                    <tr>
                                                        <td><strong>Destination Warehouse:</strong></td>
                                                        <td>${transfer.destinationWarehouseName}</td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <div class="col-md-6">
                                                <table class="table table-borderless">
                                                    <tr>
                                                        <td><strong>Created Date:</strong></td>
                                                        <td>${transfer.date.toLocalDate()} ${transfer.date.toLocalTime().toString().substring(0,5)}</td>
                                                    </tr>
                                                    <tr>
                                                        <td><strong>Created By:</strong></td>
                                                        <td>${transfer.creatorName}</td>
                                                    </tr>
                                                    <tr>
                                                        <td><strong>Status:</strong></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${transfer.status == 'draft'}">
                                                                    <span class="badge bg-secondary">Draft</span>
                                                                </c:when>
                                                                <c:when test="${transfer.status == 'pending'}">
                                                                    <span class="badge bg-warning">Pending</span>
                                                                </c:when>
                                                                <c:when test="${transfer.status == 'processing'}">
                                                                    <span class="badge bg-success">Processing</span>
                                                                </c:when>
                                                                <c:when test="${transfer.status == 'rejected'}">
                                                                    <span class="badge bg-danger">Rejected</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-info">${transfer.status}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                        
                                        <c:if test="${not empty transfer.description}">
                                            <div class="row">
                                                <div class="col-12">
                                                    <hr>
                                                    <h6>Description:</h6>
                                                    <p class="text-muted">${transfer.description}</p>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>

                                <!-- Transfer Items Card -->
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h5 class="card-title">Transfer Items</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>Product Code</th>
                                                        <th>Product Name</th>
                                                        <th>Quantity</th>
                                                        <th>Unit</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:choose>
                                                        <c:when test="${empty transfer.items}">
                                                            <tr>
                                                                <td colspan="4" class="text-center text-muted">
                                                                    <i data-feather="inbox"></i>
                                                                    <p class="mt-2">No items found for this transfer.</p>
                                                                </td>
                                                            </tr>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:forEach var="item" items="${transfer.items}">
                                                                <tr>
                                                                    <td>${item.productCode}</td>
                                                                    <td>${item.productName}</td>
                                                                    <td>${item.quantity}</td>
                                                                    <td>${item.unit.unitName}</td>
                                                                </tr>
                                                            </c:forEach>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>

                                <!-- Action Buttons -->
                                <div class="card">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-end gap-2">
                                            <c:choose>
                                                <c:when test="${transfer.status == 'draft'}">
                                                    <button type="button" class="btn btn-danger" onclick="deleteTransfer()">
                                                        <i data-feather="trash-2"></i> Delete
                                                    </button>
                                                    <button type="button" class="btn btn-primary" onclick="submitTransfer()">
                                                        <i data-feather="send"></i> Submit
                                                    </button>
                                                </c:when>
                                                <c:when test="${transfer.status == 'pending'}">
                                                    <!-- Only show approve/reject buttons if current user's warehouse matches source warehouse -->
                                                    <c:if test="${currentUser.warehouseId == transfer.sourceWarehouseId}">
                                                        <button type="button" class="btn btn-danger" onclick="rejectTransfer()">
                                                            <i data-feather="x-circle"></i> Reject
                                                        </button>
                                                        <button type="button" class="btn btn-success" onclick="approveTransfer()">
                                                            <i data-feather="check-circle"></i> Approve
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${currentUser.warehouseId != transfer.sourceWarehouseId}">
                                                        <span class="text-muted">Only source warehouse manager can approve/reject this transfer.</span>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">No actions available for this status.</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                <jsp:include page="/manager/footer.jsp" />
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to delete this inventory transfer? This action cannot be undone.
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <form method="post" action="view-inventory-transfer" style="display: inline;">
                            <input type="hidden" name="transferId" value="${transfer.transferId}">
                            <input type="hidden" name="action" value="delete">
                            <button type="submit" class="btn btn-danger">Delete</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Submit Confirmation Modal -->
        <div class="modal fade" id="submitModal" tabindex="-1" aria-labelledby="submitModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="submitModalLabel">Confirm Submit</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to submit this inventory transfer for approval?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <form method="post" action="view-inventory-transfer" style="display: inline;">
                            <input type="hidden" name="transferId" value="${transfer.transferId}">
                            <input type="hidden" name="action" value="submit">
                            <button type="submit" class="btn btn-primary">Submit</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Approve Confirmation Modal -->
        <div class="modal fade" id="approveModal" tabindex="-1" aria-labelledby="approveModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="approveModalLabel">Confirm Approval</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to approve this inventory transfer? This will move items between warehouses.
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <form method="post" action="view-inventory-transfer" style="display: inline;">
                            <input type="hidden" name="transferId" value="${transfer.transferId}">
                            <input type="hidden" name="action" value="approve">
                            <button type="submit" class="btn btn-success">Approve</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Reject Confirmation Modal -->
        <div class="modal fade" id="rejectModal" tabindex="-1" aria-labelledby="rejectModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="rejectModalLabel">Confirm Rejection</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to reject this inventory transfer?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <form method="post" action="view-inventory-transfer" style="display: inline;">
                            <input type="hidden" name="transferId" value="${transfer.transferId}">
                            <input type="hidden" name="action" value="reject">
                            <button type="submit" class="btn btn-danger">Reject</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="js/app.js"></script>
        <!-- Bootstrap Bundle JS (includes Popper) -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        
        <script>
            function deleteTransfer() {
                const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
                deleteModal.show();
            }

            function submitTransfer() {
                const submitModal = new bootstrap.Modal(document.getElementById('submitModal'));
                submitModal.show();
            }

            function approveTransfer() {
                const approveModal = new bootstrap.Modal(document.getElementById('approveModal'));
                approveModal.show();
            }

            function rejectTransfer() {
                const rejectModal = new bootstrap.Modal(document.getElementById('rejectModal'));
                rejectModal.show();
            }
        </script>
    </body>
</html>
