<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Purchase Order Details - PO-${purchaseOrder.poId}</title>
    
    <!-- CSS -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css" rel="stylesheet">
    <style>
        .invoice-header { border-bottom: 3px solid #007bff; margin-bottom: 30px; padding-bottom: 20px; }
        .invoice-details { background: #f8f9fa; border-radius: 10px; padding: 20px; margin-bottom: 30px; }
        .invoice-table { border: 1px solid #dee2e6; }
        .invoice-table th { background-color: #343a40; color: white; font-weight: 600; }
        .status-badge { font-size: 0.9rem; padding: 8px 16px; }
        .total-section { background: #e9ecef; border-radius: 8px; padding: 20px; }
        @media print { .no-print { display: none !important; } .card { border: none !important; box-shadow: none !important; } body { font-size: 12px; } }
    </style>
</head>

<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
    <div class="wrapper">
        <!-- Sidebar -->
        <jsp:include page="/purchase/PurchaseSidebar.jsp"/>
        
        <div class="main">
            <!-- Navbar -->
            <jsp:include page="/purchase/navbar.jsp" />

            <main class="content">
                <div class="container-fluid p-0">
                    <div class="row mb-2 mb-xl-3">
                        <div class="col-auto d-none d-sm-block">
                            <h3><strong>Purchase Order</strong> Details</h3>
                        </div>
                    </div>

                    <div class="container mt-4">
                        <div class="card shadow">
                            <div class="card-body">
                                <!-- Header -->
                                <div class="invoice-header">
                                    <div class="row align-items-center">
                                        <div class="col-md-12 text-center">
                                            <h2 class="mb-0"><i class="fas fa-receipt me-2 text-primary"></i>WAREHOUSE RECEIPT</h2>
                                            <h4 class="text-muted">Receipt No: <strong>PO-${purchaseOrder.poId}</strong></h4>
                                        </div>
                                        <div class="col-md-12 text-center mt-3">
                                            <div class="no-print">
                                                <div class="btn-group" role="group">
                                                    <a href="${pageContext.request.contextPath}/purchase/purchase-order?action=list" class="btn btn-outline-secondary">
                                                        <i class="fas fa-arrow-left me-1"></i>Back to List
                                                    </a>
                                                    <button type="button" class="btn btn-outline-primary" onclick="window.print()">
                                                        <i class="fas fa-print me-1"></i>Print Receipt
                                                    </button>
                                                    <button type="button" class="btn btn-outline-success" onclick="exportToExcel()">
                                                        <i class="fas fa-file-excel me-1"></i>Export Excel
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="mt-3">
                                                <c:choose>
                                                    <c:when test="${purchaseOrder.status == 'Pending'}">
                                                        <span class="badge bg-warning status-badge">Pending</span>
                                                    </c:when>
                                                    <c:when test="${purchaseOrder.status == 'Approved'}">
                                                        <span class="badge bg-info status-badge">Approved</span>
                                                    </c:when>
                                                    <c:when test="${purchaseOrder.status == 'Completed'}">
                                                        <span class="badge bg-success status-badge">Completed</span>
                                                    </c:when>
                                                    <c:when test="${purchaseOrder.status == 'Cancelled'}">
                                                        <span class="badge bg-danger status-badge">Cancelled</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary status-badge">${purchaseOrder.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Purchase Order Details -->
                                <div class="invoice-details">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h5 class="mb-3"><i class="fas fa-building me-2"></i>Supplier Information</h5>
                                            <div class="mb-2">
                                                <strong>Supplier Name:</strong>
                                                <span class="text-primary">${purchaseOrder.supplierName}</span>
                                            </div>
                                            <div class="mb-2">
                                                <strong>Supplier Code:</strong>
                                                <code class="bg-light px-2 py-1 rounded">SUP-${purchaseOrder.supplierId}</code>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <h5 class="mb-3"><i class="fas fa-info-circle me-2"></i>Order Information</h5>
                                            <div class="mb-2">
                                                <strong>Created Date:</strong>
                                                <fmt:formatDate value="${purchaseOrder.date}" pattern="dd/MM/yyyy HH:mm:ss" />
                                            </div>
                                            <div class="mb-2">
                                                <strong>Created By:</strong>
                                                <span class="text-success">${purchaseOrder.userName}</span>
                                            </div>
                                            <div class="mb-2">
                                                <strong>Status:</strong>
                                                ${purchaseOrder.status}
                                            </div>
                                            <div class="mb-2">
                                                <strong>Expected Delivery Date:</strong>
                                                <c:choose>
                                                    <c:when test="${purchaseOrder.expectedDeliveryDate != null}">
                                                        <span class="text-info">
                                                            <fmt:formatDate value="${purchaseOrder.expectedDeliveryDate}" pattern="dd/MM/yyyy" />
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Not specified</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="mb-2">
                                                <strong>Delivery Warehouse:</strong>
                                                <c:choose>
                                                    <c:when test="${purchaseOrder.warehouseName != null}">
                                                        <span class="text-success">
                                                            <i class="fas fa-warehouse me-1"></i>${purchaseOrder.warehouseName}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">Not specified</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Items Table -->
                                <div class="table-responsive">
                                    <table class="table invoice-table" id="itemsTable">
                                        <thead>
                                            <tr>
                                                <th style="width: 5%">No.</th>
                                                <th style="width: 15%">Product Code</th>
                                                <th style="width: 35%">Product Name</th>
                                                <th style="width: 10%">Unit</th>
                                                <th style="width: 10%">Quantity</th>
                                                <th style="width: 15%">Unit Price</th>
                                                <th style="width: 15%">Total</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${empty purchaseOrderItems}">
                                                    <tr>
                                                        <td colspan="7" class="text-center py-4">
                                                            <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                                                            <p class="text-muted">No products in this order</p>
                                                        </td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="grandTotal" value="0" />
                                                    <c:set var="totalQuantity" value="0" />
                                                    <c:forEach var="item" items="${purchaseOrderItems}" varStatus="status">
                                                        <c:set var="itemTotal" value="${item.quantity * item.unitPrice}" />
                                                        <c:set var="grandTotal" value="${grandTotal + itemTotal}" />
                                                        <c:set var="totalQuantity" value="${totalQuantity + item.quantity}" />
                                                        <tr>
                                                            <td class="text-center">${status.index + 1}</td>
                                                            <td>
                                                                <code class="bg-light px-2 py-1 rounded">${item.productCode}</code>
                                                            </td>
                                                            <td>
                                                                <div class="fw-medium">${item.productName}</div>
                                                                <small class="text-muted">Code: ${item.productCode}</small>
                                                            </td>
                                                            <td class="text-center">Pcs</td>
                                                            <td class="text-center">
                                                                <span class="fw-bold text-primary">${item.quantity}</span>
                                                            </td>
                                                            <td class="text-end">
                                                                <fmt:formatNumber value="${item.unitPrice}" pattern="#,###" /> VND
                                                            </td>
                                                            <td class="text-end">
                                                                <fmt:formatNumber value="${itemTotal}" pattern="#,###" /> VND
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Summary Section -->
                                <c:if test="${not empty purchaseOrderItems}">
                                    <div class="row mt-4">
                                        <div class="col-md-6">
                                            <!-- Statistics -->
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="card border-primary">
                                                        <div class="card-body text-center">
                                                            <i class="fas fa-boxes fa-2x text-primary mb-2"></i>
                                                            <h5 class="text-primary mb-0">${purchaseOrderItems.size()}</h5>
                                                            <small class="text-muted">Product Types</small>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="card border-success">
                                                        <div class="card-body text-center">
                                                            <i class="fas fa-calculator fa-2x text-success mb-2"></i>
                                                            <h5 class="text-success mb-0">${totalQuantity}</h5>
                                                            <small class="text-muted">Total Quantity</small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <!-- Total Section -->
                                            <div class="total-section">
                                                <div class="row mb-2">
                                                    <div class="col-8">
                                                        <strong>Total Quantity:</strong>
                                                    </div>
                                                    <div class="col-4 text-end">
                                                        <strong>${totalQuantity} items</strong>
                                                    </div>
                                                </div>
                                                <div class="row mb-2">
                                                    <div class="col-8">
                                                        <strong>Total Types:</strong>
                                                    </div>
                                                    <div class="col-4 text-end">
                                                        <strong>${purchaseOrderItems.size()} types</strong>
                                                    </div>
                                                </div>
                                                <hr>
                                                <div class="row">
                                                    <div class="col-8">
                                                        <h5 class="mb-0">TOTAL AMOUNT:</h5>
                                                    </div>
                                                    <div class="col-4 text-end">
                                                        <h5 class="mb-0 text-danger">
                                                            <fmt:formatNumber value="${grandTotal}" pattern="#,###" /> VND
                                                        </h5>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>

                                <!-- Signature Section -->
                                <div class="row mt-5 pt-4" style="border-top: 1px solid #dee2e6;">
                                    <div class="col-md-3 text-center">
                                        <div class="mb-3">
                                            <strong>Prepared By</strong>
                                        </div>
                                        <div style="height: 80px; border-bottom: 1px solid #000; margin-bottom: 10px;"></div>
                                        <small>(Signature, Full Name)</small>
                                        <div class="mt-2">
                                            <small class="text-muted">${purchaseOrder.userName}</small>
                                        </div>
                                    </div>
                                    <div class="col-md-3 text-center">
                                        <div class="mb-3">
                                            <strong>Delivered By</strong>
                                        </div>
                                        <div style="height: 80px; border-bottom: 1px solid #000; margin-bottom: 10px;"></div>
                                        <small>(Signature, Full Name)</small>
                                    </div>
                                    <div class="col-md-3 text-center">
                                        <div class="mb-3">
                                            <strong>Warehouse Keeper</strong>
                                        </div>
                                        <div style="height: 80px; border-bottom: 1px solid #000; margin-bottom: 10px;"></div>
                                        <small>(Signature, Full Name)</small>
                                    </div>
                                    <div class="col-md-3 text-center">
                                        <div class="mb-3">
                                            <strong>Chief Accountant</strong>
                                        </div>
                                        <div style="height: 80px; border-bottom: 1px solid #000; margin-bottom: 10px;"></div>
                                        <small>(Signature, Full Name)</small>
                                    </div>
                                </div>

                                <!-- Footer -->
                                <div class="row mt-4 no-print">
                                    <div class="col-12 text-center">
                                        <p class="text-muted mb-0">
                                            <small>
                                                This receipt was automatically generated by the warehouse management system at 
                                                <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm:ss" />
                                            </small>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
    <script>
        function exportToExcel() {
            const table = document.getElementById('itemsTable');
            const html = table.outerHTML;
            
            const link = document.createElement('a');
            link.download = 'warehouse-receipt-PO-${purchaseOrder.poId}.xls';
            link.href = 'data:application/vnd.ms-excel,' + encodeURIComponent(html);
            
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            
            iziToast.success({
                title: 'Success',
                message: 'Warehouse receipt exported to Excel successfully!',
                position: 'topRight'
            });
        }

        // Toast message display
        var toastMessage = '${sessionScope.toastMessage}';
        var toastType = '${sessionScope.toastType}';
        if (toastMessage) {
            iziToast.show({
                title: toastType === 'success' ? 'Success' : 'Error',
                message: toastMessage,
                position: 'topRight',
                color: toastType === 'success' ? 'green' : 'red',
                timeout: 1500
            });
        }
    </script>
</body>
</html>