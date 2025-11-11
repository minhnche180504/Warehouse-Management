<%-- 
    Document   : customerQuote-viewDetail
    Created on : Jul 1, 2025, 10:24:34 PM
    Author     : nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <title>Quotation Details | Warehouse System</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
        <script src="js/settings.js"></script>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <jsp:include page="/sale/SalesSidebar.jsp" />
            <div class="main">
                <jsp:include page="/sale/navbar.jsp" />
                <main class="content">
                    <div class="container-fluid p-0">
                        <!-- Header -->
                        <div class="row mb-3">
                            <div class="col-6">
                                <h1 class="h3 fw-bold">Quotation Details</h1>
                            </div>
                            <div class="col-6 text-end">
                                <a href="listCustomerQuote" class="btn btn-secondary">
                                    <i class="align-middle" data-feather="arrow-left"></i> Back to List
                                </a>
                                <a href="#" class="btn btn-primary" onclick="scrollAndPrint(); return false;">
                                    <i class="align-middle" data-feather="printer"></i> In báo giá
                                </a>
                            </div>
                        </div>
                        <!-- Error Message -->
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                <div class="alert-icon">
                                    <i data-feather="alert-triangle"></i>
                                </div>
                                <div class="alert-message">
                                    <strong>Error!</strong> ${errorMessage}
                                </div>
                            </div>
                        </c:if>
                        <!-- Detail Card -->
                        <div id="print-area">
                        <div class="row">
                            <div class="col-12">
                                <div class="card shadow-sm">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">Quotation Information</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <!-- Basic Information -->
                                            <div class="col-md-6">
                                                <h6 class="fw-bold mb-3">Basic Information</h6>
                                                <table class="table table-borderless">
                                                    <tr>
                                                        <th style="width: 40%">Quotation ID:</th>
                                                        <td>Q-<fmt:formatNumber value="${quote.quotationId}" pattern="000"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Created At:</th>
                                                        <td><fmt:formatDate value="${quote.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Valid Until:</th>
                                                        <td><fmt:formatDate value="${quote.validUntil}" pattern="yyyy-MM-dd"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Total Amount:</th>
                                                        <td><fmt:formatNumber value="${quote.totalAmount}" type="currency" currencySymbol="₫"/></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Notes:</th>
                                                        <td>${quote.notes}</td>
                                                    </tr>
                                                </table>
                                            </div>
                                            
                                            <!-- Customer Information -->
                                            <div class="col-md-6">
                                                <h6 class="fw-bold mb-3">Customer Information</h6>
                                                <table class="table table-borderless">
                                                    <tr>
                                                        <th style="width: 40%">Customer Name:</th>
                                                        <td>${customer.customerName}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>Address:</th>
                                                        <td>${customer.address}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>Phone:</th>
                                                        <td>${customer.phone}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>Email:</th>
                                                        <td>${customer.email}</td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                        
                                        <!-- Creator Information -->
                                        <div class="row mt-3">
                                            <div class="col-12">
                                                <h6 class="fw-bold mb-3">Creator Information</h6>
                                                <table class="table table-borderless">
                                                    <tr>
                                                        <th style="width: 15%">Created by:</th>
                                                        <td>${creator.fullName}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>Email:</th>
                                                        <td>${creator.email}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>Address:</th>
                                                        <td>${creator.address}</td>
                                                    </tr>
                                                    <tr>
                                                        <th>Role:</th>
                                                        <td>${creator.role.roleName}</td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </div>
                                        
                                        <!-- Product Items Table -->
                                        <div class="row mt-4">
                                            <div class="col-12">
                                                <h6 class="fw-bold mb-3">Quotation Items</h6>
                                                <div class="table-responsive">
                                                    <table class="table table-bordered">
                                                        <thead>
                                                            <tr>
                                                                <th>Product Name</th>
                                                                <th>Unit</th>
                                                                <th>Quantity</th>
                                                                <th>Unit Price</th>
                                                                <th>Tax (10%)</th>
                                                                <th>Total</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach items="${items}" var="item">
                                                                <tr>
                                                                    <td>${item.productName}</td>
                                                                    <td>${item.unitName}</td>
                                                                    <td>${item.quantity}</td>
                                                                    <td><fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₫"/></td>
                                                                    <td><fmt:formatNumber value="${item.unitPrice * item.quantity * 0.1}" type="currency" currencySymbol="₫"/></td>
                                                                    <td><fmt:formatNumber value="${item.totalPrice}" type="currency" currencySymbol="₫"/></td>
                                                                </tr>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                        
                                                                                <!-- Signature Section -->
                                        <div class="row mt-4">
                                            <div class="col-12">
                                                <div class="row signature-section">
                                                    <div class="col-md-6">
                                                        <div class="signature-box text-center">
                                                            <div class="mb-3">
                                                                <strong>Khách hàng</strong>
                                                            </div>
                                                            <div class="mb-2">
                                                                <strong>${customer.customerName}</strong>
                                                            </div>
                                                            <div class="text-muted small">
                                                                ${customer.address}
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="signature-box text-center">
                                                            <div class="mb-3">
                                                                <strong>Người lập báo giá</strong>
                                                            </div>
                                                            <div class="mb-2">
                                                                <strong>${creator.fullName}</strong>
                                                            </div>
                                                            <div class="text-muted small">
                                                                ${creator.role.roleName}
                                                            </div>
                                                            
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
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
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                if (typeof feather !== 'undefined') {
                    feather.replace();
                }
            });
            function scrollAndPrint() {
                var printArea = document.getElementById('print-area');
                if (printArea) {
                    printArea.scrollIntoView({behavior: "smooth", block: "start"});
                    setTimeout(function() {
                        window.print();
                    }, 500);
                } else {
                    window.print();
                }
            }
        </script>
        <style>
        @media print {
            body * {
                visibility: hidden;
            }
            #print-area, #print-area * {
                visibility: visible;
            }
            #print-area {
                position: absolute;
                left: 0; top: 0; width: 100%;
            }
            .btn, .navbar, .sidebar, .footer, .alert, .row.mb-3, .text-end {
                display: none !important;
            }
            .text-center {
                text-align: center !important;
            }
            .text-muted {
                color: #666 !important;
            }
            .small {
                font-size: 12px !important;
            }
            .signature-section {
                display: flex !important;
                justify-content: space-between !important;
                margin-top: 30px !important;
            }
            .signature-section .col-md-6 {
                flex: 1 !important;
                margin: 0 20px !important;
            }
            .signature-box {
                min-height: 120px !important;
                padding: 15px !important;
            }
            .signature-line {
                border-top: 1px solid #333 !important;
                padding-top: 10px !important;
                margin-top: 20px !important;
            }
        }
        
        /* CSS cho màn hình */
        .signature-box {
            min-height: 120px;
            padding: 15px;
        }
        .signature-line {
            border-top: 1px solid #ddd;
            padding-top: 10px;
            margin-top: 20px;
        }
        </style>
    </body>
</html>

