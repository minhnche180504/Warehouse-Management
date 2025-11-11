<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav id="sidebar" class="sidebar js-sidebar">
    <div class="sidebar-content js-simplebar">
        <a class="sidebar-brand" href="<c:url value='/manager/manager-dashboard'/>">
            <span class="sidebar-brand-text align-middle">
                Warehouse
                <sup><small class="badge bg-primary text-uppercase">System</small></sup>
            </span>
            <svg class="sidebar-brand-icon align-middle" width="32px" height="32px" viewBox="0 0 24 24" fill="none" stroke="#FFFFFF" stroke-width="1.5"
                 stroke-linecap="square" stroke-linejoin="miter" color="#FFFFFF" style="margin-left: -3px">
            <path d="M12 4L20 8.00004L12 12L4 8.00004L12 4Z"></path>
            <path d="M20 12L12 16L4 12"></path>
            <path d="M20 16L12 20L4 16"></path>
            </svg>
        </a>
        <div class="sidebar-user">
            <div class="d-flex justify-content-center">
                <div class="flex-shrink-0">
                    <img src="<c:url value='/manager/img/avatars/avatar.jpg'/>" class="avatar img-fluid rounded me-1" alt="User" />
                </div>
                <div class="flex-grow-1 ps-2">
                    <div class="sidebar-user-title">
                        <c:choose>
                            <c:when test="${sessionScope.user != null}">
                                ${sessionScope.user.firstName} ${sessionScope.user.lastName}
                            </c:when>
                            <c:otherwise>
                                Manager 
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="sidebar-user-subtitle">Manager</div>
                    <c:if test="${not empty sessionScope.user.warehouseName}">
                        <div class="sidebar-user-title">
                            ${sessionScope.user.warehouseName}
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
        <ul class="sidebar-nav">

            <!-- 1. DASHBOARD -->
            <li class="sidebar-item">
                <a class="sidebar-link" href="<c:url value='/manager/manager-dashboard'/>">
                    <i class="align-middle" data-feather="home"></i> <span class="align-middle">Dashboard</span>
                </a>
            </li>

            <!-- DIVIDER -->
            <li class="sidebar-header">Master Data</li>

            <li class="sidebar-item">
                <a class="sidebar-link" href="<c:url value='/manager/list-inventory-transfer'/>">
                    <i class="align-middle" data-feather="layers"></i> <span class="align-middle">Inventory Transfer</span>
                </a>
            </li>

            <li class="sidebar-item">
                <a class="sidebar-link" href="${pageContext.request.contextPath}/manager/low-stock-alerts">
                    <i class="align-middle" data-feather="alert-triangle"></i> 
                    <span class="align-middle">Low Stock Alerts</span>
                    <span class="sidebar-badge badge bg-warning">!</span>
                </a>
            </li>

            <!-- NEW: Discount Management Section -->
            <li class="sidebar-item">
                <a data-bs-target="#discount-management" data-bs-toggle="collapse" class="sidebar-link collapsed" href="#">
                    <i class="align-middle" data-feather="percent"></i> <span class="align-middle">Discount Management</span>
                    <span class="sidebar-badge badge bg-success">New</span>
                </a>
                <ul id="discount-management" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/manager/discount-codes'/>">
                            <i class="align-middle" data-feather="tag"></i>
                            Discount Codes
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/manager/create-discount-code'/>">
                            <i class="align-middle" data-feather="plus-circle"></i>
                            Create Discount Code
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/manager/special-discount-requests'/>">
                            <i class="align-middle" data-feather="star"></i>
                            Special Requests
                            <span class="sidebar-badge badge bg-warning">!</span>
                        </a>
                    </li>
                </ul>
            </li>

            <!-- DIVIDER -->
            <li class="sidebar-header">Operations</li>
            <li class="sidebar-item">
                <a data-bs-target="#product-managementcdmm" data-bs-toggle="collapse" class="sidebar-link collapsed" href="#">
                    <i class="align-middle" data-feather="box"></i> <span class="align-middle">Manage Stock Orders</span>
                </a>
                <ul id="product-managementcdmm" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/manager/stock-request'/>">Stock Order List</a>
                    </li>                    

                </ul>
            </li>

            <li class="sidebar-item">
                <a data-bs-target="#purchase-request-management" data-bs-toggle="collapse" class="sidebar-link collapsed" href="#">
                    <i class="align-middle" data-feather="file-plus"></i> <span class="align-middle">Purchase Requests</span>
                </a>
                <ul id="purchase-request-management" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/manager/purchase-request?action=create'/>">Create Purchase Request</a>
                    </li> 
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/manager/purchase-request?action=list'/>">List Purchase Requests</a>
                    </li>
                </ul>
            </li>

            <li class="sidebar-item">
                <a data-bs-toggle="collapse" href="#stockCheckReport" class="sidebar-link collapsed">
                    <i class="align-middle" data-feather="clipboard"></i>
                    <span class="align-middle">Stock Check Reports</span>
                </a>
                <ul id="stockCheckReport" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                    <li class="sidebar-item"><a class="sidebar-link" href="${pageContext.request.contextPath}/manager/create-stock-check-report">Create Report</a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="${pageContext.request.contextPath}/manager/list-stock-check-reports">View Reports</a></li>
                </ul>
            </li>

            <li class="sidebar-item">
                <a data-bs-target="#inventory-management" data-bs-toggle="collapse" class="sidebar-link collapsed" href="#">
                    <i class="align-middle" data-feather="bar-chart-2"></i> <span class="align-middle">Inventory</span>
                </a>
                <ul id="inventory-management" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/manager/inventory-report?action=list'/>">Inventory Report</a>
                    </li>
                </ul>
            </li>
            <!-- Account -->
            <li class="sidebar-header">Account</li>

                <li class="sidebar-item">
                    <a class="sidebar-link" href="<c:url value='/manager/UserProfile'/>">
                        <i class="align-middle" data-feather="user"></i>
                        <span class="align-middle">Profile</span>
                    </a>
                </li>

                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/manager/changePassword'/>">
                            <i class="align-middle" data-feather="lock"></i>
                            <span class="align-middle">Change Password</span>
                        </a>
                    </li>

                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/logout'/>">
                            <i class="align-middle" data-feather="log-out"></i>
                            <span class="align-middle">Logout</span>
                        </a>
                    </li>
                </ul>
                </div>
                </nav>

                <!-- Add CSS for sidebar headers and badges -->
                <style>
                    .sidebar-header {
                        padding: 1rem 1.5rem 0.5rem;
                        font-size: 0.75rem;
                        font-weight: 600;
                        text-transform: uppercase;
                        letter-spacing: 0.05em;
                        color: #6c757d;
                        border-top: 1px solid rgba(255,255,255,0.1);
                        margin-top: 1rem;
                    }

                    .sidebar-header:first-of-type {
                        border-top: none;
                        margin-top: 0;
                    }

                    .sidebar-badge {
                        margin-left: auto;
                        font-size: 0.6rem;
                        padding: 0.2em 0.4em;
                    }

                    .sidebar-link {
                        position: relative;
                    }

                    .sidebar-dropdown .sidebar-link {
                        padding-left: 3rem;
                        font-size: 0.875rem;
                    }

                    .sidebar-dropdown .sidebar-link i {
                        font-size: 0.75rem;
                        margin-right: 0.5rem;
                    }
                </style>