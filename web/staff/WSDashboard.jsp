<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>Warehouse Dashboard</title>
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link rel="shortcut icon" href="<c:url value='/staff/img/icons/icon-48x48.png'/>" />
        <link rel="stylesheet" href="<c:url value='/staff/css/light.css'/>" class="js-stylesheet">
        <link href="<c:url value='/staff/css/light.css'/>" rel="stylesheet">
        <script src="<c:url value='/staff/js/settings.js'/>"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="<c:url value='/staff/js/app.js'/>"></script>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                feather.replace();
            });
        </script>
        <style>
            /* Custom styles for WSDashboard.jsp */
            .card-flex {
                display: flex;
                justify-content: space-between;
                align-items: center;
                gap: 1rem;
            }

            .card-flex {
                display: flex;
                justify-content: space-between;
                align-items: center;

                .stat-icon {
                    background-color: #3b7ddd;
                    border-radius: 50%;
                    color: white;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    height: 60px;
                    width: 60px;
                    font-size: 28px;
                    box-shadow: 0 4px 8px rgba(59, 125, 221, 0.4);
                    transition: background-color 0.3s ease;
                }
                .stat-icon:hover {
                    background-color: #2f64b1;
                    box-shadow: 0 6px 12px rgba(47, 100, 177, 0.6);
                }

                .quick-action-card {
                    padding: 0.75rem;
                    margin-bottom: 1.5rem;
                }

                /* Status badges with distinct colors */
                .badge-status {
                    font-weight: 600;
                    font-size: 0.85rem;
                    padding: 0.4em 0.75em;
                    border-radius: 0.5rem;
                    color: #fff;
                    display: inline-block;
                    min-width: 90px;
                    text-align: center;
                    box-shadow: 0 2px 6px rgba(0,0,0,0.15);
                    transition: background-color 0.3s ease;
                }
                .badge-status.sale-order {
                    background-color: #28a745; /* green */
                }
                .badge-status.purchase-order {
                    background-color: #ffc107; /* amber */
                    color: #212529;
                }
                .badge-status.pending {
                    background-color: #17a2b8; /* info blue */
                }
                .badge-status.approved {
                    background-color: #1cbb8c; /* success teal */
                }
                .badge-status.unapproved {
                    background-color: #dc3545; /* danger red */
                }
                .badge-status.completed {
                    background-color: #6c757d; /* secondary gray */
                }
            </style>
        </head>
        <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
            <div class="wrapper">
                <jsp:include page="WsSidebar.jsp" />
                <div class="main">
                    <jsp:include page="navbar.jsp" />

                    <main class="content">
                        <div class="container-fluid p-0">

                            <h1 class="h3 mb-3">Warehouse Dashboard</h1>

                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger" role="alert">
                                    ${errorMessage}
                                </div>
                            </c:if>

                            <div class="row">
                                <!-- Product Stats -->
                                <div class="col-sm-6 col-xl-6">
                                    <div class="card">
                                        <div class="card-body">
                                            <div class="card-flex">
                                                <div>
                                                    <h5 class="card-title mb-2">Total Products</h5>
                                                    <h1 class="display-5 mt-1 mb-3">${totalProducts}</h1>
                                                </div>
                                                <div class="stat-icon">
                                                    <i class="align-middle" data-feather="box"></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6 col-xl-6">
                                    <div class="card">
                                        <div class="card-body">
                                            <div class="card-flex">
                                                <div>
                                                    <h5 class="card-title mb-2">Total Stock Quantity</h5>
                                                    <h1 class="display-5 mt-1 mb-3"><fmt:formatNumber value="${totalQuantity}" type="number"/></h1>
                                                </div>
                                                <div class="stat-icon">
                                                    <i class="align-middle" data-feather="package"></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Quick Actions -->
                            <div class="row">
                                <div class="col-12">
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="card-title mb-0">Quick Actions</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-3 quick-action-card">
                                                    <a href="${pageContext.request.contextPath}/staff/create-transfer-order" class="btn btn-primary w-100">Create Transfer Order</a>
                                                </div>
                                                <div class="col-md-3 quick-action-card">
                                                    <a href="${pageContext.request.contextPath}/staff/create-stock-check-report" class="btn btn-primary w-100">Create Stock Check Report</a>
                                                </div>
                                                <div class="col-md-3 quick-action-card">
                                                    <a href="${pageContext.request.contextPath}/ws-warehouse-inventory" class="btn btn-info w-100">View Inventory</a>
                                                </div>
                                                <div class="col-md-3 quick-action-card">
                                                    <a href="${pageContext.request.contextPath}/staff/list-stock-check-reports" class="btn btn-info w-100">View Stock Check Reports</a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <!-- Product List -->
                                <div class="col-xl-5">
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="card-title mb-0">Recent Products in Stock</h5>
                                        </div>
                                        <div class="card-body table-responsive">
                                            <table class="table table-hover">
                                                <thead>
                                                    <tr>
                                                        <th>Product Name</th>
                                                        <th>Stock Quantity</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="product" items="${productList}">
                                                        <tr>
                                                            <td>${product.name}</td>
                                                            <td><fmt:formatNumber value="${product.stockQuantity}" type="number"/></td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>

                                <!-- Orders -->
                                <div class="col-xl-7">
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="card-title mb-0">Pending Orders (Sales & Purchase)</h5>
                                        </div>
                                        <div class="card-body table-responsive">
                                            <table class="table table-hover">
                                                <thead>
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>Type</th>
                                                        <th>Customer/Supplier</th>
                                                        <th>Date</th>
                                                        <th>Status</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="so" items="${salesOrders}">
                                                        <tr>
                                                            <td>SO-${so.soId}</td>
                                                            <td><span class="badge bg-success">Sale order</span></td>
                                                            <td>${so.customerName}</td>
                                                            <td><fmt:formatDate value="${so.orderDate}" pattern="dd-MM-yyyy"/></td>
                                                            <td><span class="badge bg-info">${so.status}</span></td>

                                                        </tr>
                                                    </c:forEach>
                                                    <c:forEach var="po" items="${purchaseOrders}">
                                                        <tr>
                                                            <td>PO-${po.poId}</td>
                                                            <td><span class="badge bg-warning text-dark">Purchase Order</span></td>
                                                            <td>${po.supplierName}</td>
                                                            <td><fmt:formatDate value="${po.date}" pattern="dd-MM-yyyy"/></td>
                                                            <td><span class="badge bg-secondary">${po.status}</span></td>

                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <!-- Inventory Transfers -->
                                <div class="col-md-6">
                                    <div class="card">
                                        <h5 class="card-title mb-0">Pending Inventory Transfers</h5>
                                        <div class="card-body table-responsive">
                                            <table class="table table-hover">
                                                <thead>
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>From Warehouse</th>
                                                        <th>To Warehouse</th>
                                                        <th>Date</th>
                                                        <th>Status</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="it" items="${inventoryTransfers}">
                                                        <tr>
                                                            <td>IT-${it.transferId}</td>
                                                            <td>${it.sourceWarehouseName}</td>
                                                            <td>${it.destinationWarehouseName}</td>
                                                            <td>${it.date != null ? it.date.toLocalDate() : ''}</td>
                                                            <td><span class="badge bg-primary">${it.status}</span></td>
                                                            <td></td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                <!-- Unapproved Stock Checks -->
                                <div class="col-md-6">
                                    <div class="card">
                                        <h5 class="card-title mb-0">Unapproved Stock Check Reports</h5>
                                        <div class="card-body table-responsive">
                                            <table class="table table-hover">
                                                <thead>
                                                    <tr>
                                                        <th>Report ID</th>
                                                        <th>Date</th>
                                                        <th>Status</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="sc" items="${stockChecks}">
                                                        <tr>
                                                            <td>SC-${sc.reportId}</td>
                                                            <td><fmt:formatDate value="${sc.reportDate}" pattern="dd-MM-yyyy"/></td>
                                                            <td><span class="badge bg-danger">${sc.status}</span></td>

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

                    <jsp:include page="footer.jsp" />
                </div>
            </div>

            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    feather.replace();
                });
            </script>
        </body>
    </html>
