<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.User" %>
<%@ page import="dao.AuthorizationUtil" %>

<%
    User currentUser = (User) session.getAttribute("user");
    
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Inventory Staff Dashboard">
        <meta name="author" content="Warehouse Management System">
        <title>Inventory Manager Dashboard</title>

        <link href="${pageContext.request.contextPath}/manager/css/light.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">

        <style>
            .stats-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border-radius: 15px;
                padding: 1.5rem;
                margin-bottom: 1rem;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            }

            .stats-card.warning {
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            }

            .stats-card.success {
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            }

            .stats-card.info {
                background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            }

            .stats-number {
                font-size: 2.5rem;
                font-weight: 700;
                margin-bottom: 0.5rem;
            }

            .stats-label {
                font-size: 0.9rem;
                opacity: 0.9;
            }

            .alert-item {
                border-left: 4px solid #dc3545;
                background: #fff5f5;
                padding: 1rem;
                margin-bottom: 0.5rem;
                border-radius: 0 8px 8px 0;
            }

            .alert-item.warning {
                border-left-color: #ffc107;
                background: #fffbf0;
            }

            .alert-item.info {
                border-left-color: #17a2b8;
                background: #f0f9ff;
            }

            .inventory-item {
                padding: 1rem;
                border-bottom: 1px solid #eee;
                transition: background-color 0.2s;
            }

            .inventory-item:hover {
                background-color: #f8f9fa;
            }

            .welcome-banner {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 2rem;
                border-radius: 15px;
                margin-bottom: 2rem;
            }
        </style>
    </head>

    <body>
        <div class="wrapper">
            <!-- Include Sidebar -->
            <jsp:include page="/manager/ManagerSidebar.jsp" />

            <div class="main">
                <!-- Include Navbar -->
                <jsp:include page="/manager/navbar.jsp" />

                <main class="content">
                    <div class="container-fluid p-0">

                        <!-- Welcome Banner -->
                        <div class="welcome-banner">
                            <h1 class="h3 mb-2">Welcome back, ${currentUser.firstName} ${currentUser.lastName}!</h1>
                            <p class="mb-0">Inventory Staff Dashboard - Manage your warehouse operations efficiently</p>
                        </div>

                        <!-- Error Display -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i data-feather="alert-circle" class="align-middle me-2"></i>
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Main Content Row -->
                        <div class="row">
                            <!-- Recent Low Stock Alerts -->
                            <div class="col-12 col-lg-6">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">
                                            <i data-feather="alert-triangle" class="align-middle me-2"></i>
                                            Recent Low Stock Alerts
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <c:choose>
                                            <c:when test="${not empty recentAlerts}">
                                                <c:forEach var="alert" items="${recentAlerts}">
                                                    <div class="alert-item ${alert.getAlertLevel().toLowerCase()}">
                                                        <div class="d-flex justify-content-between align-items-start">
                                                            <div>
                                                                <h6 class="mb-1">${alert.productName}</h6>
                                                                <p class="mb-1 text-muted small">
                                                                    Code: ${alert.productCode} | Warehouse: ${alert.warehouseName}
                                                                </p>
                                                                <p class="mb-0 small">
                                                                    <strong>Current Stock: ${alert.currentStock}</strong> 
                                                                    (Warning Threshold: ${alert.warningThreshold} | Critical Threshold: ${alert.criticalThreshold})
                                                                </p>
                                                            </div>
                                                            <span class="badge ${alert.alertLevelClass}">${alert.getAlertLevel()}</span>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                                <div class="text-center mt-3">
                                                    <a href="${pageContext.request.contextPath}/manager/low-stock-alerts" 
                                                       class="btn btn-outline-primary btn-sm">
                                                        View All Alerts
                                                    </a>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="text-center py-4">
                                                    <i data-feather="check-circle" class="align-middle me-2 text-success" style="width: 48px; height: 48px;"></i>
                                                    <p class="text-muted mb-0">No low stock alerts at the moment!</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <!-- Recent Inventory Updates -->
                            <div class="col-12 col-lg-6">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">
                                            <i data-feather="package" class="align-middle me-2"></i>
                                            Current Inventory Overview
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <c:choose>
                                            <c:when test="${not empty recentInventory}">
                                                <c:forEach var="inventory" items="${recentInventory}">
                                                    <div class="inventory-item">
                                                        <div class="d-flex justify-content-between align-items-center">
                                                            <div>
                                                                <h6 class="mb-1">${inventory.productName}</h6>
                                                                <p class="mb-0 text-muted small">
                                                                    ${inventory.productCode} | ${inventory.warehouseName}
                                                                </p>
                                                            </div>
                                                            <div class="text-end">
                                                                <!-- Kiểm tra số lượng tồn kho (onHand) -->
                                                                <span class="badge bg-primary">${inventory.onHand != null ? inventory.onHand : 0} units</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="text-center py-4">
                                                    <i data-feather="inbox" class="align-middle me-2 text-muted" style="width: 48px; height: 48px;"></i>
                                                    <p class="text-muted mb-0">No inventory data available</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Actions -->
                        <div class="row mt-4">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">
                                            <i data-feather="zap" class="align-middle me-2"></i>
                                            Quick Actions
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row justify-content-center">
                                            <div class="col-md-2 col-sm-4 col-6 mb-3 d-flex justify-content-center">
                                                <a href="${pageContext.request.contextPath}/manager/list-inventory-transfer" 
                                                   class="btn btn-outline-info w-100 h-100 d-flex flex-column justify-content-center align-items-center py-3">
                                                    <i data-feather="refresh-cw" class="mb-2" style="width: 24px; height: 24px;"></i>
                                                    <span class="small">Điều chuyển</span>
                                                </a>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-6 mb-3 d-flex justify-content-center">
                                                <a href="${pageContext.request.contextPath}/manager/list-stock-check-reports" 
                                                   class="btn btn-outline-warning w-100 h-100 d-flex flex-column justify-content-center align-items-center py-3">
                                                    <i data-feather="clipboard" class="mb-2" style="width: 24px; height: 24px;"></i>
                                                    <span class="small">Kiểm kê</span>
                                                </a>
                                            </div>
                                            <div class="col-md-2 col-sm-4 col-6 mb-3 d-flex justify-content-center">
                                                <a href="${pageContext.request.contextPath}/manager/inventory-report?action=list" 
                                                   class="btn btn-outline-secondary w-100 h-100 d-flex flex-column justify-content-center align-items-center py-3">
                                                    <i data-feather="bar-chart-2" class="mb-2" style="width: 24px; height: 24px;"></i>
                                                    <span class="small">Báo cáo</span>
                                                </a>
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

    <!-- Include Footer -->
</div>
</div>

<script src="${pageContext.request.contextPath}/manager/js/app.js"></script>
<script>
    // Initialize Feather icons
    feather.replace();

    // Auto-dismiss alerts after 5 seconds
    setTimeout(function () {
        $('.alert').alert('close');
    }, 5000);
</script>
</body>
</html>
