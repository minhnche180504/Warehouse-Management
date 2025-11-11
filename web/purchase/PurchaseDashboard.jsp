<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="Purchase Staff Dashboard">
    <meta name="author" content="AdminKit">
    <meta name="keywords" content="purchase, dashboard, bootstrap, responsive, css, sass, html, theme, front-end, ui kit, web">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link rel="shortcut icon" href="img/icons/icon-48x48.png" />

    <link rel="canonical" href="https://demo-basic.adminkit.io/" />

    <title>Purchase Dashboard | ISP392</title>

    <link href="css/light.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
</head>

<body>
    <div class="wrapper">
        <!-- Include Purchase Sidebar -->
        <jsp:include page="/purchase/PurchaseSidebar.jsp" />

        <div class="main">
            <!-- Include Navbar -->
            <jsp:include page="/purchase/navbar.jsp" />

            <main class="content">
                <div class="container-fluid p-0">

                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Purchase Dashboard</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <div class="btn-group me-2">
                                <button type="button" class="btn btn-sm btn-outline-secondary">Share</button>
                                <button type="button" class="btn btn-sm btn-outline-secondary">Export</button>
                            </div>
                        </div>
                    </div>

                    <!-- Dashboard Stats -->
                    <div class="row">
                        <div class="col-xl-3 col-xxl-3 d-flex">
                            <div class="card illustration flex-fill">
                                <div class="card-body p-0 d-flex flex-fill">
                                    <div class="row g-0 w-100">
                                        <div class="col-6">
                                            <div class="p-3 m-1">
                                                <h4>Welcome back, ${sessionScope.user.firstName}!</h4>
                                                <p class="mb-0">Purchase Staff Dashboard</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-xxl-3 d-flex">
                            <div class="card flex-fill">
                                <div class="card-body py-4">
                                    <div class="d-flex align-items-start">
                                        <div class="flex-grow-1">
                                            <h3 class="mb-2">${totalProductsBoughtLastWeek}</h3>
                                            <p class="mb-2">Total Products Bought<br><small>(since last week)</small></p>
                                        </div>
                                        <div class="d-inline-block ms-3">
                                            <div class="stat">
                                                <i class="align-middle text-success" data-feather="package"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-xxl-3 d-flex">
                            <div class="card flex-fill">
                                <div class="card-body py-4">
                                    <div class="d-flex align-items-start">
                                        <div class="flex-grow-1">
                                            <h3 class="mb-2">${activeSuppliersLastMonth}</h3>
                                            <p class="mb-2">Active Suppliers<br><small>(since last month)</small></p>
                                        </div>
                                        <div class="d-inline-block ms-3">
                                            <div class="stat">
                                                <i class="align-middle text-primary" data-feather="truck"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-xl-3 col-xxl-3 d-flex">
                            <div class="card flex-fill">
                                <div class="card-body py-4">
                                    <div class="d-flex align-items-start">
                                        <div class="flex-grow-1">
                                            <h3 class="mb-2">${pendingPurchaseOrders}</h3>
                                            <p class="mb-2">Pending Purchase Orders</p>
                                        </div>
                                        <div class="d-inline-block ms-3">
                                            <div class="stat">
                                                <i class="align-middle text-warning" data-feather="shopping-cart"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Activities -->
                    <div class="row">
                        <div class="col-12 col-lg-8 col-xxl-9 d-flex">
                            <div class="card flex-fill">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">Recent Purchase Orders</h5>
                                </div>
                                <table class="table table-hover my-0">
                                    <thead>
                                        <tr>
                                            <th>PO ID</th>
                                            <th class="d-none d-xl-table-cell">Supplier</th>
                                            <th class="d-none d-xl-table-cell">Date</th>
                                            <th>Status</th>
                                            <th class="d-none d-md-table-cell">Warehouse</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty recentOrders}">
                                                <tr>
                                                    <td colspan="5" class="text-center text-muted">No recent purchase orders</td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="order" items="${recentOrders}">
                                                    <tr>
                                                        <td>PO-${order.poId}</td>
                                                        <td class="d-none d-xl-table-cell">${order.supplierName}</td>
                                                        <td class="d-none d-xl-table-cell">
                                                            <fmt:formatDate value="${order.date}" pattern="dd/MM/yyyy"/>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${order.status == 'Pending'}">
                                                                    <span class="badge bg-warning">Pending</span>
                                                                </c:when>
                                                                <c:when test="${order.status == 'Approved'}">
                                                                    <span class="badge bg-info">Approved</span>
                                                                </c:when>
                                                                <c:when test="${order.status == 'Completed'}">
                                                                    <span class="badge bg-success">Completed</span>
                                                                </c:when>
                                                                <c:when test="${order.status == 'Cancelled'}">
                                                                    <span class="badge bg-danger">Cancelled</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-secondary">${order.status}</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="d-none d-md-table-cell">${order.warehouseName}</td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="col-12 col-lg-4 col-xxl-3 d-flex">
                            <div class="card flex-fill w-100">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">Quick Actions</h5>
                                </div>
                                <div class="card-body d-flex">
                                    <div class="align-self-center w-100">
                                        <div class="py-3">
                                            <div class="d-grid gap-2">
                                                <a href="<c:url value='/purchase/purchase-order?action=create'/>" class="btn btn-primary">
                                                    <i data-feather="plus"></i> Create Purchase Order
                                                </a>
                                                <a href="<c:url value='/purchase/rfq?action=create'/>" class="btn btn-outline-primary">
                                                    <i data-feather="file-text"></i> Create RFQ
                                                </a>
                                                <a href="<c:url value='/purchase/manage-supplier?action=add'/>" class="btn btn-outline-secondary">
                                                    <i data-feather="truck"></i> Add Supplier
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </main>

            <!-- Include Footer -->
            <jsp:include page="/purchase/footer.jsp" />
        </div>
    </div>

    <script src="js/app.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // Initialize Feather icons
            feather.replace();
        });
    </script>

</body>

</html>
