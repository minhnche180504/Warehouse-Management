<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List,model.TransferOrder,model.TransferOrderItem" %>
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
        <link rel="shortcut icon" href="<c:url value='/staff/img/icons/icon-48x48.png'/>" />
        <link rel="canonical" href="forms-layouts.html" />
        <title>${pageTitle} | Warehouse System</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="<c:url value='/staff/css/light.css'/>" rel="stylesheet">
        <script src="<c:url value='/staff/js/settings.js'/>"></script>
        <style>
            .badge-large {
                font-size: 0.9rem;
                padding: 0.5rem 0.75rem;
            }
            
            .border-top-dashed {
                border-top: 1px dashed #dee2e6 !important;
            }
            
            .bg-light-subtle {
                background-color: rgba(0,0,0,.02);
            }
            
            @media print {
                .no-print {
                    display: none !important;
                }
                
                .card {
                    border: none !important;
                    box-shadow: none !important;
                }
                
                body {
                    background-color: white;
                }
            }
        </style>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <jsp:include page="/staff/WsSidebar.jsp" />
            <div class="main">
                <jsp:include page="/staff/navbar.jsp" />               
                <main class="content">                    
                    <div class="container-fluid p-0">
                        <div class="row mb-3">
                            <div class="col-auto">
                                <h1 class="h3">
                                    <c:choose>
                                        <c:when test="${transferOrder.transferType == 'import'}">
                                            <i data-feather="download" class="me-2"></i> Import Order
                                        </c:when>
                                        <c:when test="${transferOrder.transferType == 'export'}">
                                            <i data-feather="upload" class="me-2"></i> Export Order
                                        </c:when>
                                        <c:when test="${transferOrder.transferType == 'transfer'}">
                                            <i data-feather="refresh-cw" class="me-2"></i> Transfer Order
                                        </c:when>
                                    </c:choose>
                                    #${transferOrder.transferId}
                                </h1>
                            </div>
                            <div class="col text-end">
                                <c:choose>
                                    <c:when test="${transferOrder.status == 'draft'}">
                                        <span class="badge bg-secondary badge-large">Draft</span>
                                    </c:when>
                                    <c:when test="${transferOrder.status == 'processing'}">
                                        <span class="badge bg-info badge-large">Processing</span>
                                    </c:when>
                                    <c:when test="${transferOrder.status == 'completed'}">
                                        <span class="badge bg-success badge-large">Completed</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary badge-large">${transferOrder.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
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
                        
                        <!-- Action Buttons -->
                        <div class="row mb-4">
                            <div class="col-12 text-end">
                                <div class="btn-group no-print">
                                    <button class="btn btn-secondary" onclick="window.print()">
                                        <i data-feather="printer"></i> Print
                                    </button>
                                    <a href="list-transfer-order" class="btn btn-primary">
                                        <i data-feather="list"></i> Back to List
                                    </a>
                                    <c:if test="${transferOrder.status == 'draft'}">
                                        <a href="edit-transfer-order?id=${transferOrder.transferId}" class="btn btn-warning">
                                            <i data-feather="edit"></i> Edit
                                        </a>
                                        <button class="btn btn-success" onclick="confirmCompletion(${transferOrder.transferId})">
                                            <i data-feather="check-circle"></i> Mark as Completed
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-12">
                                
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">Transfer Order Information</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-6">
                                                <table class="table table-sm table-borderless">
                                                    <tr>
                                                        <th style="width: 30%">Transfer ID:</th>
                                                        <td>#${transferOrder.transferId}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>Type:</th>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${transferOrder.transferType == 'import'}">
                                                                    <span class="badge bg-success">Import</span>
                                                                </c:when>
                                                                <c:when test="${transferOrder.transferType == 'export'}">
                                                                    <span class="badge bg-warning">Export</span>
                                                                </c:when>
                                                                <c:when test="${transferOrder.transferType == 'transfer'}">
                                                                    <span class="badge bg-info">Transfer</span>
                                                                </c:when>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Supplier:</th>
                                                        <td>${transferOrder.sourceWarehouseName}</td>
                                                    </tr>
                                                    <c:if test="${transferOrder.destinationWarehouseId != null}">
                                                        <tr>
                                                            <th>Destination Warehouse:</th>
                                                            <td>${transferOrder.destinationWarehouseName}</td>
                                                        </tr>
                                                    </c:if>
                                                    <c:if test="${transferOrder.documentRefId != null}">
                                                        <tr>
                                                            <th>Reference Document:</th>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${transferOrder.documentRefType == 'PO'}">
                                                                        PO-${transferOrder.documentRefId}
                                                                    </c:when>
                                                                    <c:when test="${transferOrder.documentRefType == 'SO'}">
                                                                        SO-${transferOrder.documentRefId}
                                                                    </c:when>
                                                                    <c:when test="${transferOrder.documentRefType == 'IT'}">
                                                                        IT-${transferOrder.documentRefId}
                                                                    </c:when>
                                                                    <c:when test="${transferOrder.documentRefType == 'IR'}">
                                                                        IR-${transferOrder.documentRefId}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        ${transferOrder.documentRefId}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                    </c:if>
                                                </table>
                                            </div>
                                            <div class="col-md-6">
                                                <table class="table table-sm table-borderless">
                                                    <tr>
                                                        <th style="width: 30%">Created Date:</th>
                                                        <td>${transferOrder.createdDate}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>Created By:</th>
                                                        <td>${transferOrder.creatorName}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>Transfer Date:</th>
                                                        <td>${transferOrder.transferDate}</td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                        
                                        <c:if test="${not empty transferOrder.description}">
                                            <div class="row mt-3">
                                                <div class="col-12">
                                                    <div class="card bg-light-subtle">
                                                        <div class="card-header py-2 bg-light">
                                                            <h6 class="card-title mb-0">Description</h6>
                                                        </div>
                                                        <div class="card-body py-2">
                                                            <p class="card-text">${transferOrder.description}</p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                                
                                <!-- Items Table -->
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">Items</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="table-responsive">
                                            <table class="table table-bordered table-striped">
                                                <thead>
                                                    <tr>
                                                        <th>#</th>
                                                        <th>Product Code</th>
                                                        <th>Product Name</th>
                                                        <th>Quantity</th>
                                                        <th>Unit</th>
                                                        <th class="text-end">Unit Price</th>
                                                        <th class="text-end">Total</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:set var="total" value="0" />
                                                    <c:forEach items="${transferOrder.items}" var="item" varStatus="loop">
                                                        <tr>
                                                            <td>${loop.index + 1}</td>
                                                            <td>${item.productCode}</td>
                                                            <td>${item.productName}</td>
                                                            <td>${item.quantity}</td>
                                                            <td>${item.unit.unitName}</td>
                                                            <td class="text-end">
                                                                <c:choose>
                                                                    <c:when test="${item.unitPrice != null}">
                                                                        <fmt:formatNumber value="${item.unitPrice}" type="number" pattern="#,##0" /> đ
                                                                    </c:when>
                                                                    <c:otherwise>0 đ</c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="text-end">
                                                                <c:choose>
                                                                    <c:when test="${item.totalPrice != null}">
                                                                        <fmt:formatNumber value="${item.totalPrice}" type="number" pattern="#,##0" /> đ
                                                                    </c:when>
                                                                    <c:otherwise>0 đ</c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                        </tr>
                                                        <c:set var="total" value="${total + (item.totalPrice != null ? item.totalPrice : 0)}" />
                                                    </c:forEach>
                                                </tbody>
                                                <tfoot>
                                                    <tr class="table-active">
                                                        <th colspan="6" class="text-end">Total:</th>
                                                        <th class="text-end"><fmt:formatNumber value="${total}" type="number" pattern="#,##0" /> đ</th>
                                                    </tr>
                                                </tfoot>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Status History -->
                                <%-- <div class="card no-print">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">Status History</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="timeline">
                                            <!-- This would be populated from a real status history table -->
                                            <div class="timeline-item">
                                                <div class="timeline-marker bg-success"></div>
                                                <div class="timeline-content">
                                                    <div class="timeline-heading">
                                                        <h6 class="mb-0">Order Created</h6>
                                                        <small class="text-muted">${transferOrder.createdDate}</small>
                                                    </div>
                                                    <div class="timeline-body">
                                                        <p>Transfer order created by ${transferOrder.creatorName}</p>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <c:if test="${transferOrder.status != 'draft'}">
                                                <div class="timeline-item">
                                                    <div class="timeline-marker bg-primary"></div>
                                                    <div class="timeline-content">
                                                        <div class="timeline-heading">
                                                            <h6 class="mb-0">Order Approved</h6>
                                                            <small class="text-muted">2023-07-16 10:30:00</small>
                                                        </div>
                                                        <div class="timeline-body">
                                                            <p>Transfer order approved by ${transferOrder.approverName}</p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                            
                                            <c:if test="${transferOrder.status == 'completed'}">
                                                <div class="timeline-item">
                                                    <div class="timeline-marker bg-success"></div>
                                                    <div class="timeline-content">
                                                        <div class="timeline-heading">
                                                            <h6 class="mb-0">Order Completed</h6>
                                                            <small class="text-muted">2023-07-18 14:45:00</small>
                                                        </div>
                                                        <div class="timeline-body">
                                                            <p>Transfer order marked as completed</p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                            
                                            <c:if test="${transferOrder.status == 'cancelled'}">
                                                <div class="timeline-item">
                                                    <div class="timeline-marker bg-danger"></div>
                                                    <div class="timeline-content">
                                                        <div class="timeline-heading">
                                                            <h6 class="mb-0">Order Cancelled</h6>
                                                            <small class="text-muted">2023-07-16 11:15:00</small>
                                                        </div>
                                                        <div class="timeline-body">
                                                            <p>Transfer order cancelled</p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div> --%>
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
        
        <!-- Completion Confirmation Modal -->
        <div class="modal fade" id="completeModal" tabindex="-1" aria-labelledby="completeModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="completeModalLabel">Confirm Completion</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to mark this transfer order as completed? This will update the inventory levels accordingly.
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <a href="#" id="confirmCompleteBtn" class="btn btn-success">Complete Order</a>
                    </div>
                </div>
            </div>
        </div>

        <script src="<c:url value='/staff/js/app.js'/>"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                // Initialize feather icons
                feather.replace();
            });
            
            function confirmCompletion(orderId) {
                document.getElementById('confirmCompleteBtn').href = 'complete-transfer-order?id=' + orderId;
                var modal = new bootstrap.Modal(document.getElementById('completeModal'));
                modal.show();
            }
        </script>
        
        <style>
            /* Timeline styles */
            .timeline {
                position: relative;
                padding-left: 30px;
            }
            
            .timeline:before {
                content: '';
                position: absolute;
                top: 0;
                left: 9px;
                height: 100%;
                width: 2px;
                background-color: #e5e7eb;
            }
            
            .timeline-item {
                position: relative;
                margin-bottom: 20px;
            }
            
            .timeline-marker {
                position: absolute;
                top: 5px;
                left: -30px;
                width: 20px;
                height: 20px;
                border-radius: 50%;
            }
            
            .timeline-content {
                padding-bottom: 10px;
            }
        </style>
    </body>
</html>