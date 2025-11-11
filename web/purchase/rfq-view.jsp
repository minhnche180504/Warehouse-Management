<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request for Quotation Details - RFQ-${rfq.rfqId}</title>
    
    <!-- CSS -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .rfq-detail {
            background: white;
            padding: 30px;
        }
        .rfq-header {
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #000;
            padding-bottom: 20px;
        }
        .info-section {
            margin: 20px 0;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 5px;
        }
        .products-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .products-table th, .products-table td {
            border: 1px solid #dee2e6;
            padding: 12px 8px;
            text-align: center;
        }
        .products-table th {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        .status-badge {
            font-size: 1.1em;
            padding: 8px 16px;
        }
        .print-section {
            margin-top: 40px;
        }
        @media print {
            .no-print {
                display: none !important;
            }
            .rfq-detail {
                box-shadow: none;
                border: none;
            }
        }
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
                    <div class="row mb-2 mb-xl-3 no-print">
                        <div class="col-auto d-none d-sm-block">
                            <h3><strong>Request for Quotation</strong> Details</h3>
                        </div>
                        <div class="col-auto ms-auto text-end mt-n1">
                            <a href="${pageContext.request.contextPath}/purchase/rfq?action=list" class="btn btn-secondary me-2">
                                <i class="fas fa-arrow-left"></i> Back
                            </a>
                            <button onclick="window.print()" class="btn btn-info">
                                <i class="fas fa-print"></i> Print
                            </button>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-body rfq-detail">
                            <!-- Header -->
                            <div class="rfq-header">
                                <h2>REQUEST FOR QUOTATION</h2>
                                <h4>Số: RFQ-${rfq.rfqId}</h4>
                                <p class="mb-1">Created Date: ${rfq.requestDate}</p>
                                <div class="mt-3">
                                    <c:choose>
                                        <c:when test="${rfq.status eq 'Pending'}">
                                            <span class="badge bg-warning status-badge">Pending</span>
                                        </c:when>
                                        <c:when test="${rfq.status eq 'Sent'}">
                                            <span class="badge bg-success status-badge">Sent</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary status-badge">${rfq.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- Information Section -->
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="info-section">
                                        <h5><strong>Supplier Information</strong></h5>
                                        <table class="table table-borderless mb-0">
                                            <tr>
                                                <td style="width: 30%;"><strong>Name:</strong></td>
                                                <td>${rfq.supplierName}</td>
                                            </tr>
                                            <c:if test="${not empty rfq.supplierEmail}">
                                                <tr>
                                                    <td><strong>Email:</strong></td>
                                                    <td>
                                                        <i class="fas fa-envelope"></i> ${rfq.supplierEmail}
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <c:if test="${not empty rfq.supplierPhone}">
                                                <tr>
                                                    <td><strong>Phone:</strong></td>
                                                    <td>
                                                        <i class="fas fa-phone"></i> ${rfq.supplierPhone}
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </table>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="info-section">
                                        <h5><strong>Request Information</strong></h5>
                                        <table class="table table-borderless mb-0">
                                            <tr>
                                                <td style="width: 30%;"><strong>Created By:</strong></td>
                                                <td>${rfq.createdByName}</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Created Date:</strong></td>
                                                <td>${rfq.requestDate}</td>
                                            </tr>
                                            <tr>
                                                <td><strong>Status:</strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${rfq.status eq 'Pending'}">
                                                            <span class="badge bg-warning">Pending</span>
                                                        </c:when>
                                                        <c:when test="${rfq.status eq 'Sent'}">
                                                            <span class="badge bg-success">Sent</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">${rfq.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <!-- Delivery Information Section -->
                            <div class="row mt-3">
                                <div class="col-md-6">
                                    <div class="info-section">
                                        <h5><strong>Delivery Information</strong></h5>
                                        <table class="table table-borderless mb-0">
                                            <tr>
                                                <td style="width: 30%;"><strong>Delivery Warehouse:</strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty rfq.warehouseName}">
                                                            <i class="fas fa-warehouse"></i> ${rfq.warehouseName}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">No warehouse selected</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><strong>Expected Date:</strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty rfq.expectedDeliveryDate}">
                                                            <i class="fas fa-calendar-alt"></i> ${rfq.expectedDeliveryDate}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Not determined</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                                <!-- <div class="col-md-6">
                                    <div class="info-section">
                                        <h5><strong>Request Description</strong></h5>
                                        <div class="p-2">
                                            <c:choose>
                                                <c:when test="${not empty rfq.description}">
                                                    <p class="mb-0">${rfq.description}</p>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="mb-0 text-muted">No description</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div> -->
                            </div>

                            <!-- Products Table -->
                            <div class="mt-4">
                                <h5><strong>Requested Products List for Quotation</strong></h5>
                                <table class="products-table">
                                    <thead>
                                        <tr>
                                            <th style="width: 5%">No.</th>
                                            <th style="width: 25%">Product Code</th>
                                            <th style="width: 45%">Product Name</th>
                                            <th style="width: 15%">Unit</th>
                                            <th style="width: 10%">Quantity</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty rfqItems}">
                                                <tr>
                                                    <td colspan="5" class="text-center text-muted">
                                                        No products available
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="item" items="${rfqItems}" varStatus="status">
                                                    <tr>
                                                        <td>${status.index + 1}</td>
                                                        <td><strong>${item.productCode}</strong></td>
                                                        <td style="text-align: left;">${item.productName}</td>
                                                        <td>${item.unitName}</td>
                                                        <td><strong>${item.quantity}</strong></td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Notes Section -->
                            <c:if test="${not empty rfq.notes}">
                                <div class="mt-4">
                                    <h5><strong>Notes</strong></h5>
                                    <div class="info-section">
                                        <p class="mb-0">${rfq.notes}</p>
                                    </div>
                                </div>
                            </c:if>



                            <!-- Action Buttons -->
                            <div class="text-center mt-4 no-print">
                                <c:if test="${rfq.status eq 'Pending'}">
                                    <button class="btn btn-success me-2" onclick="updateStatus('Sent')">
                                        <i class="fas fa-paper-plane"></i> Mark as Sent
                                    </button>
                                    <button class="btn btn-outline-danger" onclick="confirmDelete()">
                                        <i class="fas fa-trash"></i> Delete Request
                                    </button>
                                </c:if>
                                <c:if test="${rfq.status eq 'Sent'}">
                                    <div class="alert alert-info">
                                        <i class="fas fa-info-circle"></i> Request for quotation has been sent and cannot be deleted.
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </main>

            <!-- Footer -->
            <jsp:include page="/purchase/footer.jsp" />
        </div>
    </div>

    <!-- JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/app.js"></script>

    <script>
        function updateStatus(status) {
            const statusText = {
                'Sent': 'mark as sent'
            };
            
            if (confirm('Are you sure you want to ' + statusText[status] + ' this request for quotation?')) {
                window.location.href = '${pageContext.request.contextPath}/purchase/rfq?action=update-status&id=${rfq.rfqId}&status=' + status;
            }
        }

        function confirmDelete() {
            if (confirm('Are you sure you want to delete this request for quotation? This action cannot be undone.')) {
                window.location.href = '${pageContext.request.contextPath}/purchase/rfq?action=delete&id=${rfq.rfqId}';
            }
        }

        // Toast message display
        var toastMessage = "${sessionScope.toastMessage}";
        var toastType = "${sessionScope.toastType}";
        if (toastMessage) {
            if (toastType === 'success') {
                alert('Success: ' + toastMessage);
            } else {
                alert('Error: ' + toastMessage);
            }
            
            // Remove toast attributes from session
            fetch('${pageContext.request.contextPath}/remove-toast', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
            });
        }
    </script>
</body>
</html>