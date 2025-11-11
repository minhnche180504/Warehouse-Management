<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav id="sidebar" class="sidebar js-sidebar">
    <div class="sidebar-content js-simplebar">
        <a class="sidebar-brand" href="<c:url value='/sale/sales-dashboard'/>">
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
                    <img src="<c:url value='/sale/img/avatars/avatar.jpg'/>" class="avatar img-fluid rounded me-1" alt="User" />
                </div>
                <div class="flex-grow-1 ps-2">
                    <div class="sidebar-user-title">
                        <c:choose>
                            <c:when test="${sessionScope.user != null}">
                                ${sessionScope.user.firstName} ${sessionScope.user.lastName}
                            </c:when>
                            <c:otherwise>
                                Sales Staff 
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="sidebar-user-subtitle">Sales Staff</div>
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
                <a class="sidebar-link" href="<c:url value='/sale/sales-dashboard'/>">
                    <i class="align-middle" data-feather="home"></i> <span class="align-middle">Dashboard</span>
                </a>
            </li>

            <!-- DIVIDER -->
            <li class="sidebar-header">Master Data</li>

            <li class="sidebar-item">
                <a data-bs-target="#customer-management" data-bs-toggle="collapse" class="sidebar-link collapsed" href="#">
                    <i class="align-middle" data-feather="users"></i> <span class="align-middle">Customers</span>
                </a>
                <ul id="customer-management" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/sale/createCustomer'/>">Create Customer</a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/sale/listCustomer'/>">List Customers</a>
                    </li>
                </ul>
            </li>

            <li class="sidebar-item">
                <a data-bs-target="#quotation-management" data-bs-toggle="collapse" class="sidebar-link collapsed" href="#">
                    <i class="align-middle" data-feather="file-text"></i> <span class="align-middle">Quotations</span>
                </a>
                <ul id="quotation-management" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/sale/createCustomerQuote'/>">Create Quotation</a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/sale/listCustomerQuote'/>">List Quotations</a>
                    </li>
                </ul>
            </li>

            <!-- DIVIDER -->
            <li class="sidebar-header">Operations</li>

            <li class="sidebar-item">
                <a data-bs-target="#order-management" data-bs-toggle="collapse" class="sidebar-link collapsed" href="#">
                    <i class="align-middle" data-feather="shopping-cart"></i> <span class="align-middle">Sales Orders</span>
                </a>
                <ul id="order-management" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/sale/create-sales-order'/>">Create Sales Order</a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/sale/view-sales-order-list'/>">View Sales Order List</a>
                    </li>
                </ul>
            </li>

            <!-- NEW: Discount Management Section -->
            <li class="sidebar-item">
                <a data-bs-target="#discount-management" data-bs-toggle="collapse" class="sidebar-link collapsed" href="#">
                    <i class="align-middle" data-feather="percent"></i> <span class="align-middle">Discounts</span>
                    <span class="sidebar-badge badge bg-success">New</span>
                </a>
                <ul id="discount-management" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/sale/available-discount-codes'/>">
                            <i class="align-middle" data-feather="tag"></i>
                            Available Codes
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/sale/request-special-discount'/>">
                            <i class="align-middle" data-feather="star"></i>
                            Request Special Discount
                        </a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/sale/my-special-requests'/>">
                            <i class="align-middle" data-feather="clock"></i>
                            My Special Requests
                        </a>
                    </li>
                </ul>
            </li>

            <li class="sidebar-item">
                <a data-bs-target="#import-request-management" data-bs-toggle="collapse" class="sidebar-link collapsed" href="#">
                    <i class="align-middle" data-feather="file-plus"></i> <span class="align-middle">Import Requests</span>
                </a>
                <ul id="import-request-management" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/sale/requestImport'/>">Create Import Request</a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/sale/importRequestList'/>">Import Request List</a>
                    </li>
                </ul>
            </li>

            <li class="sidebar-item">
                <a class="sidebar-link" href="<c:url value='/sale/sales-report'/>">
                    <i class="align-middle" data-feather="clipboard"></i> <span class="align-middle">Sales Report</span>
                </a>
            </li>

            <!-- Account -->
            <li class="sidebar-header">Account</li>

            <li class="sidebar-item">
                <a class="sidebar-link" href="<c:url value='/sale/UserProfile'/>">
                    <i class="align-middle" data-feather="user"></i>
                    <span class="align-middle">Profile</span>
                </a>
            </li>

            <li class="sidebar-item">
                <a class="sidebar-link" href="<c:url value='/sale/changePassword'/>">
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