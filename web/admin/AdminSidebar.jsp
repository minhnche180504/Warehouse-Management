<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav id="sidebar" class="sidebar js-sidebar">
    <div class="sidebar-content js-simplebar">
        <a class="sidebar-brand" href="<c:url value='/admin/admindashboard'/>">
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
                    <img src="<c:url value='/admin/img/avatars/avatar.jpg'/>" class="avatar img-fluid rounded me-1" alt="User" />
                </div>
                <div class="flex-grow-1 ps-2">
                    <div class="sidebar-user-title">
                        <c:choose>
                            <c:when test="${sessionScope.user != null}">
                                ${sessionScope.user.firstName} ${sessionScope.user.lastName}
                            </c:when>
                            <c:otherwise>
                                Admin 
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="sidebar-user-subtitle">Admin</div>
                </div>
            </div>
        </div>
        <ul class="sidebar-nav">

            <!-- 1. DASHBOARD -->
            <li class="sidebar-item">
                <a class="sidebar-link" href="<c:url value='/admin/admindashboard'/>">
                    <i class="align-middle" data-feather="home"></i> <span class="align-middle">Dashboard</span>
                </a>
            </li>

            <!-- DIVIDER -->
            <li class="sidebar-header">Master Data</li>

           


            <li class="sidebar-item">
                <a data-bs-target="#unit-management" data-bs-toggle="collapse" class="sidebar-link collapsed" href="#">
                    <i class="align-middle" data-feather="hash"></i> <span class="align-middle">Units</span>
                </a>
                <ul id="unit-management" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/admin/create-unit'/>">Add Unit</a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/admin/list-unit'/>">Manage Units</a>
                    </li>
                </ul>
            </li>
            <li class="sidebar-item">
                <a data-bs-target="#product-management" data-bs-toggle="collapse" class="sidebar-link collapsed" href="#">
                    <i class="align-middle" data-feather="box"></i> <span class="align-middle">Products</span>
                </a>
                <ul id="product-management" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/admin/create-product'/>">Add Product</a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/admin/list-product'/>">Manage Products</a>
                    </li>
                </ul>
            </li>
            <!-- 4. WAREHOUSE -->
            <li class="sidebar-item">
                <a data-bs-target="#warehouse-management" data-bs-toggle="collapse" class="sidebar-link collapsed" href="#">
                    <i class="align-middle" data-feather="database"></i> <span class="align-middle">Warehouses</span>
                </a>
                <ul id="warehouse-management" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/admin/addWarehouse'/>">Add Warehouse</a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/admin/viewWarehouses'/>">View Warehouses</a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/admin/UpdateWarehouseServlet'/>">Update Warehouse</a>
                    </li>

                </ul>
            </li>

            <!-- DIVIDER -->
            <li class="sidebar-header">Administration</li>

            <!-- 8. USER MANAGEMENT -->
            <li class="sidebar-item">
                <a data-bs-target="#user-management" data-bs-toggle="collapse" class="sidebar-link collapsed" href="#">
                    <i class="align-middle" data-feather="users"></i> <span class="align-middle">Users</span>
                </a>
                <ul id="user-management" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/admin/add'/>">Add User</a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/admin/users'/>">Manage Users</a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/admin/UserProfile'/>">User Profile</a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/admin/changePassword'/>">Change Password</a>
                    </li>
                </ul>
            
            <li class="sidebar-item">
                <a class="sidebar-link" href="<c:url value='/logout'/>">
                    <i class="align-middle" data-feather="log-out"></i> <span class="align-middle me-2">Log Out</span>
                </a>
            </li>
            
        </ul>
    </div>

</nav>

<!-- Add CSS for sidebar headers -->
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
</style>