<%-- 
    Document   : sales-report
    Created on : Jun 24, 2025, 8:58:21 PM
    Author     : nguyen
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Sales Report Dashboard">
        <meta name="author" content="AdminKit">
        <meta name="keywords" content="sales, report, dashboard, analytics">
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link rel="shortcut icon" href="img/icons/icon-48x48.png" />
        <title>Sales Report Dashboard</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
        <script src="js/settings.js"></script>
        <style>
            body {
                opacity: 0;
            }
            .stats-card {
                transition: transform 0.2s;
            }
            .stats-card:hover {
                transform: translateY(-2px);
            }
            .chart-container {
                position: relative;
                height: 300px;
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
                            <h1 class="h3 fw-bold">
                                <i class="align-middle me-2" data-feather="bar-chart-2"></i>
                                Sales Report Dashboard
                            </h1>
                        </div>

                        <!-- Filter Form -->
                        <div class="card shadow-sm mb-4">
                            <div class="card-header">
                                <h5 class="card-title mb-0">
                                    <i class="align-middle me-2" data-feather="filter"></i>
                                    Report Filters
                                </h5>
                            </div>
                            <div class="card-body">
                                <form method="get" action="${pageContext.request.contextPath}/sale/sales-report" class="row g-3">
                                    <div class="col-md-3">
                                        <label class="form-label">Report Type</label>
                                        <select name="type" class="form-select">
                                            <option value="date" ${type == 'date' ? 'selected' : ''}>By Date</option>
                                            <option value="month" ${type == 'month' ? 'selected' : ''}>By Month</option>
                                            <option value="product" ${type == 'product' ? 'selected' : ''}>By Product</option>
                                            <option value="customer" ${type == 'customer' ? 'selected' : ''}>By Customer</option>
                                            <option value="supplier" ${type == 'supplier' ? 'selected' : ''}>By Supplier</option>
                                            <option value="topproduct" ${type == 'topproduct' ? 'selected' : ''}>Top Products</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">From Date</label>
                                        <input type="date" name="fromDate" class="form-control" value="${param.fromDate}" required>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">To Date</label>
                                        <input type="date" name="toDate" class="form-control" value="${param.toDate}" required>
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label">&nbsp;</label>
                                        <button type="submit" class="btn btn-primary w-100">
                                            <i class="align-middle me-1" data-feather="search"></i>
                                            Generate Report
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Error Messages -->
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

                        <!-- Summary Statistics -->
                        <c:if test="${not empty summaryNumbers}">
                            <div class="row mb-4">
                                <div class="col-sm-6 col-xl-3">
                                    <div class="card stats-card">
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col mt-0">
                                                    <h5 class="card-title">Total Revenue</h5>
                                                </div>
                                                <div class="col-auto">
                                                    <div class="stat text-primary">
                                                        <i data-feather="dollar-sign"></i>
                                                    </div>
                                                </div>
                                            </div>
                                            <h1 class="mt-1 mb-3">
                                                <fmt:formatNumber value="${summaryNumbers.totalRevenue}" type="currency" currencySymbol="₫"/>
                                            </h1>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-sm-6 col-xl-3">
                                    <div class="card stats-card">
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col mt-0">
                                                    <h5 class="card-title">Total Orders</h5>
                                                </div>
                                                <div class="col-auto">
                                                    <div class="stat text-primary">
                                                        <i data-feather="shopping-cart"></i>
                                                    </div>
                                                </div>
                                            </div>
                                            <h1 class="mt-1 mb-3">${summaryNumbers.totalOrders}</h1>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-sm-6 col-xl-3">
                                    <div class="card stats-card">
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col mt-0">
                                                    <h5 class="card-title">Customers</h5>
                                                </div>
                                                <div class="col-auto">
                                                    <div class="stat text-primary">
                                                        <i data-feather="users"></i>
                                                    </div>
                                                </div>
                                            </div>
                                            <h1 class="mt-1 mb-3">${summaryNumbers.groupByValue}</h1>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-sm-6 col-xl-3">
                                    <div class="card stats-card">
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col mt-0">
                                                    <h5 class="card-title">Avg. Order Value</h5>
                                                </div>
                                                <div class="col-auto">
                                                    <div class="stat text-primary">
                                                        <i data-feather="bar-chart"></i>
                                                    </div>
                                                </div>
                                            </div>
                                            <h1 class="mt-1 mb-3">
                                                <c:if test="${summaryNumbers.totalOrders > 0}">
                                                    <fmt:formatNumber value="${summaryNumbers.totalRevenue / summaryNumbers.totalOrders}" type="currency" currencySymbol="₫"/>
                                                </c:if>
                                            </h1>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <!-- Main Report Table -->
                        <c:if test="${not empty reports}">
                            <div class="row">
                                <div class="col-12">
                                    <div class="card shadow-sm">
                                        <div class="card-header">
                                            <h5 class="card-title mb-0">
                                                <i class="align-middle me-2" data-feather="table"></i>
                                                Report Results
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="table-responsive">
                                                <table id="datatables-sales-report" class="table table-striped table-hover" style="width:100%">
                                                    <thead>
                                                        <tr>
                                                            <th>
                                                                <c:choose>
                                                                    <c:when test="${type == 'date'}">Date</c:when>
                                                                    <c:when test="${type == 'month'}">Month</c:when>
                                                                    <c:when test="${type == 'product'}">Product</c:when>
                                                                    <c:when test="${type == 'customer'}">Customer</c:when>
                                                                    <c:when test="${type == 'supplier'}">Supplier</c:when>
                                                                    <c:when test="${type == 'topproduct'}">Product</c:when>
                                                                    <c:otherwise>Group</c:otherwise>
                                                                </c:choose>
                                                            </th>
                                                            <th>Orders</th>
                                                            <th>Revenue</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="r" items="${reports}">
                                                            <tr>
                                                                <td><strong>${r.groupByValue}</strong></td>
                                                                <td>${r.totalOrders}</td>
                                                                <td>
                                                                    <strong class="text-success">
                                                                        <fmt:formatNumber value="${r.totalRevenue}" type="currency" currencySymbol="₫"/>
                                                                    </strong>
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
                        </c:if>

                        <!-- Top Products and Customers -->
                        <div class="row mt-4">
                            <!-- Top Products -->
                            <div class="col-md-6">
                                <c:if test="${not empty topProducts}">
                                    <div class="card shadow-sm">
                                        <div class="card-header">
                                            <h5 class="card-title mb-0">
                                                <i class="align-middle me-2" data-feather="star"></i>
                                                Top Selling Products
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="table-responsive">
                                                <table class="table table-sm">
                                                    <thead>
                                                        <tr>
                                                            <th>Rank</th>
                                                            <th>Product</th>
                                                            <th>Quantity</th>
                                                            <th>Revenue</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="product" items="${topProducts}" varStatus="status">
                                                            <tr>
                                                                <td>${status.index + 1}</td>
                                                                <td><strong>${product.groupByValue}</strong></td>
                                                                <td>${product.totalOrders}</td>
                                                                <td>
                                                                    <fmt:formatNumber value="${product.totalRevenue}" type="currency" currencySymbol="₫"/>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>

                            <!-- Top Customers -->
                            <div class="col-md-6">
                                <c:if test="${not empty topCustomers}">
                                    <div class="card shadow-sm">
                                        <div class="card-header">
                                            <h5 class="card-title mb-0">
                                                <i class="align-middle me-2" data-feather="award"></i>
                                                Top Customers
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="table-responsive">
                                                <table class="table table-sm">
                                                    <thead>
                                                        <tr>
                                                            <th>Rank</th>
                                                            <th>Customer</th>
                                                            <th>Orders</th>
                                                            <th>Revenue</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="customer" items="${topCustomers}" varStatus="status">
                                                            <tr>
                                                                <td>${status.index + 1}</td>
                                                                <td><strong>${customer.groupByValue}</strong></td>
                                                                <td>${customer.totalOrders}</td>
                                                                <td>
                                                                    <fmt:formatNumber value="${customer.totalRevenue}" type="currency" currencySymbol="₫"/>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Charts Section -->
                        <c:if test="${not empty reports}">
                            <div class="row mt-4">
                                <div class="col-12 col-lg-8">
                                    <div class="card shadow-sm">
                                        <div class="card-header">
                                            <h5 class="card-title mb-0">
                                                <i class="align-middle me-2" data-feather="bar-chart"></i>
                                                Revenue Chart
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="chart-container">
                                                <canvas id="revenueChart"></canvas>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12 col-lg-4">
                                    <div class="card shadow-sm">
                                        <div class="card-header">
                                            <h5 class="card-title mb-0">
                                                <i class="align-middle me-2" data-feather="pie-chart"></i>
                                                Revenue Distribution
                                            </h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="chart-container">
                                                <canvas id="pieChart"></canvas>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${empty reports}">
                            <div class="alert alert-info alert-dismissible fade show" role="alert">
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                <div class="alert-icon">
                                    <i data-feather="info"></i>
                                </div>
                                <div class="alert-message">
                                    <strong>No Data Available!</strong> Please try with a different date range or report type.
                                </div>
                            </div>
                        </c:if>
                    </div>
                </main>
                <footer class="footer">
                    <div class="container-fluid">
                        <div class="row text-muted">
                            <div class="col-6 text-start">
                                <p class="mb-0">
                                    <a class="text-muted" href="#" target="_blank"><strong>Warehouse Management System</strong></a> &copy;
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
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Initialize DataTable
                if (document.getElementById('datatables-sales-report')) {
                    $("#datatables-sales-report").DataTable({
                        responsive: true,
                        "order": [[2, "desc"]], // Sort by revenue descending
                        searching: false // Ẩn ô search box
                    });
                }
                
                // Initialize Feather icons
                if (typeof feather !== 'undefined') {
                    feather.replace();
                }
            });
        </script>
        
        <c:if test="${not empty reports}">
            <script>
                // Revenue Chart
                const revenueCtx = document.getElementById('revenueChart').getContext('2d');
                const revenueChart = new Chart(revenueCtx, {
                    type: 'bar',
                    data: {
                        labels: [
                            <c:forEach var="r" items="${reports}">
                                '${r.groupByValue}',
                            </c:forEach>
                        ],
                        datasets: [{
                            label: 'Revenue (VNĐ)',
                            data: [
                                <c:forEach var="r" items="${reports}">
                                    ${r.totalRevenue},
                                </c:forEach>
                            ],
                            backgroundColor: 'rgba(54, 162, 235, 0.2)',
                            borderColor: 'rgba(54, 162, 235, 1)',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    callback: function(value) {
                                        return new Intl.NumberFormat('vi-VN', {
                                            style: 'currency',
                                            currency: 'VND'
                                        }).format(value);
                                    }
                                }
                            }
                        }
                    }
                });

                // Pie Chart
                const pieCtx = document.getElementById('pieChart').getContext('2d');
                const pieChart = new Chart(pieCtx, {
                    type: 'pie',
                    data: {
                        labels: [
                            <c:forEach var="r" items="${reports}">
                                '${r.groupByValue}',
                            </c:forEach>
                        ],
                        datasets: [{
                            data: [
                                <c:forEach var="r" items="${reports}">
                                    ${r.totalRevenue},
                                </c:forEach>
                            ],
                            backgroundColor: [
                                '#FF6384',
                                '#36A2EB',
                                '#FFCE56',
                                '#4BC0C0',
                                '#9966FF',
                                '#FF9F40',
                                '#FF6384',
                                '#C9CBCF'
                            ]
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'bottom'
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        const label = context.label || '';
                                        const value = context.parsed;
                                        const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                        const percentage = ((value / total) * 100).toFixed(1);
                                        return label + ': ' + new Intl.NumberFormat('vi-VN', {
                                            style: 'currency',
                                            currency: 'VND'
                                        }).format(value) + ' (' + percentage + '%)';
                                    }
                                }
                            }
                        }
                    }
                });
            </script>
        </c:if>
    </body>
</html>
