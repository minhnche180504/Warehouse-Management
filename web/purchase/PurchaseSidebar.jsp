<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav id="sidebar" class="sidebar js-sidebar">
    <div class="sidebar-content js-simplebar">
        <a class="sidebar-brand" href="<c:url value='/purchase/purchase-dashboard'/>">
            <span class="align-middle">Purchase Management</span>
        </a>

        <!-- User Profile Section (copied and adapted from SalesSidebar.jsp) -->
        <div class="sidebar-user">
            <div class="d-flex justify-content-center">
                <div class="flex-shrink-0">
                    <img src="<c:url value='/purchase/img/avatars/avatar.jpg'/>" class="avatar img-fluid rounded me-1" alt="User" />
                </div>
                <div class="flex-grow-1 ps-2">
                    <div class="sidebar-user-title">
                        <c:choose>
                            <c:when test="${sessionScope.user != null}">
                                ${sessionScope.user.firstName} ${sessionScope.user.lastName}
                            </c:when>
                            <c:otherwise>
                                Purchase Staff
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="sidebar-user-subtitle">Purchase Staff</div>
                    <c:if test="${not empty sessionScope.user.warehouseName}">
                        <div class="sidebar-user-title">
                            ${sessionScope.user.warehouseName}
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <ul class="sidebar-nav">
            <li class="sidebar-header">
                Main Navigation
            </li>

            <li class="sidebar-item">
                <a class="sidebar-link" href="<c:url value='/purchase/purchase-dashboard'/>">
                    <i class="align-middle" data-feather="sliders"></i> <span class="align-middle">Dashboard</span>
                </a>
            </li>

            <!-- Request for Quotation -->
            <li class="sidebar-item">
                <a data-bs-target="#rfq-management" data-bs-toggle="collapse" class="sidebar-link collapsed" href="#">
                    <i class="align-middle" data-feather="file-text"></i> <span class="align-middle">Request for Quotation</span>
                </a>
                <ul id="rfq-management" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/purchase/rfq?action=create'/>">Create RFQ</a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/purchase/rfq?action=list'/>">Manage RFQs</a>
                    </li>
                </ul>
            </li>

            <!-- Purchase Order -->
            <li class="sidebar-item">
                <a data-bs-target="#purchase-management" data-bs-toggle="collapse" class="sidebar-link collapsed" href="#">
                    <i class="align-middle" data-feather="shopping-bag"></i> <span class="align-middle">Purchase Orders</span>
                </a>
                <ul id="purchase-management" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/purchase/purchase-order?action=create'/>">Create Purchase Order</a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/purchase/purchase-order?action=list'/>">Manage Orders</a>
                    </li>
                </ul>
            </li>
            <li class="sidebar-item">
                <a data-bs-target="#supplier-management" data-bs-toggle="collapse" class="sidebar-link collapsed" href="#">
                    <i class="align-middle" data-feather="truck"></i> <span class="align-middle">Suppliers</span>
                </a>
                <ul id="supplier-management" class="sidebar-dropdown list-unstyled collapse" data-bs-parent="#sidebar">
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/purchase/manage-supplier?action=add'/>">Add Supplier</a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/purchase/manage-supplier?action=list'/>">Manage Suppliers</a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/purchase/supplier-rating?action=list'/>">Supplier Ratings</a>
                    </li>
                    <li class="sidebar-item">
                        <a class="sidebar-link" href="<c:url value='/purchase/supplier-rating?action=my-ratings'/>">My Ratings</a>
                    </li>
                </ul>
            </li>

            <!-- Account Management -->
            <li class="sidebar-item">
                <a class="sidebar-link collapsed" data-bs-toggle="collapse" data-bs-target="#accountMenu" aria-expanded="false">
                    <i class="align-middle" data-feather="user"></i> <span class="align-middle">Account</span>
                </a>
                <div class="collapse" id="accountMenu">
                    <ul class="sidebar-dropdown list-unstyled">
                        <li class="sidebar-item">
                            <a class="sidebar-link" href="UserProfile.jsp">My Profile</a>
                        </li>
                        <li class="sidebar-item">
                            <a class="sidebar-link" href="changePassword.jsp">Change Password</a>
                        </li>
                    </ul>
                </div>
            </li>
            <li class="sidebar-header">
            </li>
        </ul>
    </div>
</nav>

<!-- Add CSS for sidebar headers and user section -->
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
