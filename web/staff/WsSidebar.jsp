<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav id="sidebar" class="sidebar js-sidebar">
    <div class="sidebar-content js-simplebar">
        <!-- Logo -->
        <a class="sidebar-brand" href="<c:url value='/staff/warehouse-staff-dashboard'/>">
            <span class="sidebar-brand-text align-middle">
                Warehouse
                <sup><small class="badge bg-primary text-uppercase">System</small></sup>
            </span>
            <svg class="sidebar-brand-icon align-middle" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#FFFFFF" stroke-width="1.5"
                 stroke-linecap="square" stroke-linejoin="miter" color="#FFFFFF" style="margin-left: -3px">
            <path d="M12 4L20 8L12 12L4 8L12 4Z"></path>
            <path d="M20 12L12 16L4 12"></path>
            <path d="M20 16L12 20L4 16"></path>
            </svg>
        </a>

        <!-- User Info -->
        <div class="sidebar-user">
            <div class="d-flex justify-content-center">
                <div class="flex-shrink-0">
                    <img src="<c:url value='/staff/img/avatars/avatar.jpg'/>" class="avatar img-fluid rounded me-1" alt="User" />
                </div>
                <div class="flex-grow-1 ps-2">
                    <div class="sidebar-user-title">
                        <c:choose>
                            <c:when test="${sessionScope.user != null}">
                                ${sessionScope.user.firstName} ${sessionScope.user.lastName}
                            </c:when>
                            <c:otherwise>
                                Inventory Staff
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="sidebar-user-subtitle">Warehouse Staff</div>
                    <c:if test="${not empty sessionScope.user.warehouseName}">
                        <div class="sidebar-user-title">
                            ${sessionScope.user.warehouseName}
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <ul class="sidebar-nav">
            <!-- Main -->
            <li class="sidebar-header">Main Navigation</li>

            <li class="sidebar-item">
<a class="sidebar-link" href="<c:url value='/staff/warehouse-staff-dashboard'/>">
                    <i class="align-middle" data-feather="home"></i>
                    <span class="align-middle">Dashboard</span>
                </a>
            </li>

            <!-- Inventory -->
            <li class="sidebar-header">Inventory Management</li>

            <li class="sidebar-item <c:if test="${pageContext.request.servletPath == '/ws-warehouse-inventory'}">active</c:if>">
                <a class="sidebar-link" href="${pageContext.request.contextPath}/ws-warehouse-inventory">
                    <i class="align-middle" data-feather="box"></i>
                    <span class="align-middle">My Warehouse Stock</span>
                </a>
            </li>

            <li class="sidebar-item">
                <a data-bs-target="#transfer-management" data-bs-toggle="collapse" class="sidebar-link collapsed" href="#">
                    <i class="align-middle" data-feather="repeat"></i> <span class="align-middle">Transfer Orders</span>
                </a>
                <ul id="transfer-management" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/staff/list-transfer-order'/>">Manage Transfer Orders</a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/staff/create-transfer-order?type=import'/>">Create Import Note</a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/staff/create-transfer-order?type=export'/>">Create Export Note</a>
                    </li>
                </ul>
            </li>
            <!-- Stock Check -->
            <li class="sidebar-header">Stock Check</li>

            <li class="sidebar-item">
                <a data-bs-toggle="collapse" href="#stockCheckReport" class="sidebar-link collapsed">
                    <i class="align-middle" data-feather="clipboard"></i>
                    <span class="align-middle">Stock Check Reports</span>
                </a>
                <ul id="stockCheckReport" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                    <li class="sidebar-item"><a class="sidebar-link" href="${pageContext.request.contextPath}/staff/create-stock-check-report">Create Report</a></li>
                    <li class="sidebar-item"><a class="sidebar-link" href="${pageContext.request.contextPath}/staff/list-stock-check-reports">View Reports</a></li>
                </ul>
            </li>

            <!-- Account -->
            <li class="sidebar-header">Account</li>

            <li class="sidebar-item">
                <a class="sidebar-link" href="<c:url value='/staff/UserProfile'/>">
                    <i class="align-middle" data-feather="user"></i>
                    <span class="align-middle">Profile</span>
                </a>
            </li>

            <li class="sidebar-item">
                <a class="sidebar-link" href="<c:url value='/staff/changePassword'/>">
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