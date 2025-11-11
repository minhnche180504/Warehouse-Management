<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Top Navigation -->
<nav class="navbar navbar-expand navbar-light navbar-bg compact-navbar">
    <button class="sidebar-toggle d-lg-none" onclick="toggleSidebar()">
        <i data-feather="menu"></i>
    </button>

    <!-- Left side spacer -->
    <div class="me-auto"></div>

    <!-- Right Side Actions -->
    <div class="navbar-nav align-items-center">
        <!-- Current Warehouse Indicator -->
        <div class="nav-item me-3 d-none d-lg-flex align-items-center">
            <div class="warehouse-indicator">
                
              
            </div>
        </div>

        

        <!-- Enhanced Notifications -->
        <div class="nav-item dropdown me-2">
            <a class="nav-icon-compact dropdown-toggle position-relative" href="#" data-bs-toggle="dropdown">
                <i data-feather="bell" class="icon-sm"></i>
                <span class="indicator-sm">4</span>
            </a>
            <div class="dropdown-menu dropdown-menu-lg dropdown-menu-end py-0" style="width: 350px;">
                <div class="dropdown-menu-header d-flex justify-content-between align-items-center">
                    <span>Notifications</span>
                    <small class="text-muted">4 new</small>
                </div>
                <div class="list-group list-group-flush">
                    <!-- Low Stock Alert -->
                    <a href="<c:url value='/inventory-alerts'/>" class="list-group-item list-group-item-action">
                        <div class="row g-0 align-items-center">
                            <div class="col-2">
                                <i data-feather="alert-triangle" class="text-warning"></i>
                            </div>
                            <div class="col-10">
                                <div class="text-dark fw-medium">Low Stock Alert</div>
                                <div class="text-muted small mt-1">Laptop Acer Nitro 5 - Only 5 left in Hanoi warehouse</div>
                                <div class="text-muted small mt-1">5 minutes ago</div>
                            </div>
                        </div>
                    </a>
                    
                    <!-- New Order -->
                    <a href="<c:url value='/view-sales-order-list'/>" class="list-group-item list-group-item-action">
                        <div class="row g-0 align-items-center">
                            <div class="col-2">
                                <i data-feather="shopping-cart" class="text-success"></i>
                            </div>
                            <div class="col-10">
                                <div class="text-dark fw-medium">New Sales Order</div>
                                <div class="text-muted small mt-1">Order #SO-2023006 from ABC Company</div>
                                <div class="text-muted small mt-1">10 minutes ago</div>
                            </div>
                        </div>
                    </a>

                    <!-- Import Request -->
                    <a href="<c:url value='/importRequestList'/>" class="list-group-item list-group-item-action">
                        <div class="row g-0 align-items-center">
                            <div class="col-2">
                                <i data-feather="file-plus" class="text-info"></i>
                            </div>
                            <div class="col-10">
                                <div class="text-dark fw-medium">Import Request Approved</div>
                                <div class="text-muted small mt-1">Request for Laptop Dell XPS 13 approved</div>
                                <div class="text-muted small mt-1">30 minutes ago</div>
                            </div>
                        </div>
                    </a>

                    <!-- Transfer Complete -->
                    <a href="<c:url value='/list-transfer-order'/>" class="list-group-item list-group-item-action">
                        <div class="row g-0 align-items-center">
                            <div class="col-2">
                                <i data-feather="check-circle" class="text-success"></i>
                            </div>
                            <div class="col-10">
                                <div class="text-dark fw-medium">Transfer Completed</div>
                                <div class="text-muted small mt-1">Transfer from Hanoi to Da Nang completed</div>
                                <div class="text-muted small mt-1">1 hour ago</div>
                            </div>
                        </div>
                    </a>
                </div>
                <div class="dropdown-menu-footer">
                    <a href="<c:url value='/notifications'/>" class="btn btn-outline-primary btn-sm w-100">
                        View All Notifications
                    </a>
                </div>
            </div>
        </div>

        <!-- Enhanced Messages -->
        <div class="nav-item dropdown me-2">
            <a class="nav-icon-compact dropdown-toggle" href="#" data-bs-toggle="dropdown">
                <i data-feather="message-square" class="icon-sm"></i>
            </a>
            <div class="dropdown-menu dropdown-menu-lg dropdown-menu-end py-0" style="width: 320px;">
                <div class="dropdown-menu-header">
                    <span>Messages</span>
                </div>
                <div class="list-group list-group-flush">
                    <div class="list-group-item text-center py-4">
                        <i data-feather="message-square" class="text-muted mb-2" style="width: 48px; height: 48px;"></i>
                        <div class="text-muted">No new messages</div>
                    </div>
                </div>
                <div class="dropdown-menu-footer">
                    <a href="<c:url value='/messages'/>" class="btn btn-outline-primary btn-sm w-100">
                        View All Messages
                    </a>
                </div>
            </div>
        </div>

        <!-- System Status Indicator -->
        <div class="nav-item me-3 d-none d-xl-flex align-items-center">
            <div class="status-compact">
<!--                <div class="status-indicator bg-success me-1"></div>
                <small class="text-muted">Online</small>-->
            </div>
        </div>

        <!-- Enhanced User Profile -->
        <div class="nav-item dropdown">
            <a class="user-profile-compact dropdown-toggle" href="#" data-bs-toggle="dropdown">
                <img src="<c:url value='/manager/img/avatars/avatar.jpg'/>" 
                     class="avatar-sm rounded-circle me-2" alt="Admin User">
                <span class="d-none d-lg-inline-block user-info">
                    <div class="user-name">Admin User</div>
                    <small class="user-role">Administrator</small>
                </span>
            </a>
            <ul class="dropdown-menu dropdown-menu-end">
                <li class="dropdown-header">
                    <strong>Admin User</strong><br>
                    <small class="text-muted">admin@example.com</small>
                </li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="<c:url value='/manager/UserProfile'/>">
                    <i data-feather="user" class="align-middle me-2"></i> Profile
                </a></li>
                <li><a class="dropdown-item" href="<c:url value='/manager/changePassword'/>">
                    <i data-feather="lock" class="align-middle me-2"></i> Change Password
                </a></li>
                <li><a class="dropdown-item text-danger" href="<c:url value='/logout'/>">
                    <i data-feather="log-out" class="align-middle me-2"></i> Log out
                </a></li>
            </ul>
        </div>
    </div>
</nav>

<!-- CSS Enhancements -->
<style>
/* Compact Navbar Styling */
.compact-navbar {
    padding: 0.25rem 1rem;
    min-height: 60px;
}

.navbar-nav {
    height: 100%;
}

/* Icon Sizes */
.icon-xs {
    width: 14px;
    height: 14px;
}

.icon-sm {
    width: 16px;
    height: 16px;
}

/* Compact Button */
.compact-btn {
    padding: 0.375rem 0.75rem;
    font-size: 0.875rem;
    line-height: 1.2;
}

/* Warehouse Indicator */
.warehouse-indicator {
    color: #6c757d;
    font-size: 0.875rem;
    display: flex;
    align-items: center;
}

/* Compact Navigation Icons */
.nav-icon-compact {
    padding: 0.5rem;
    color: #6c757d;
    text-decoration: none;
    border-radius: 0.375rem;
    transition: all 0.15s ease-in-out;
}

.nav-icon-compact:hover {
    color: #495057;
    background-color: #f8f9fa;
}

/* Compact Indicators */
.indicator-sm {
    position: absolute;
    top: 2px;
    right: 2px;
    background: #dc3545;
    color: white;
    border-radius: 50%;
    width: 14px;
    height: 14px;
    font-size: 9px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
    border: 1px solid white;
}

.status-indicator {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    display: inline-block;
}

.status-compact {
    display: flex;
    align-items: center;
    font-size: 0.8rem;
}

/* Compact User Profile */
.user-profile-compact {
    display: flex;
    align-items: center;
    padding: 0.25rem 0.5rem;
    color: #495057;
    text-decoration: none;
    border-radius: 0.5rem;
    transition: background-color 0.15s ease-in-out;
}

.user-profile-compact:hover {
    background-color: #f8f9fa;
    color: #495057;
}

.avatar-sm {
    width: 28px;
    height: 28px;
    object-fit: cover;
}

.user-info {
    text-align: left;
    line-height: 1.2;
}

.user-name {
    font-size: 0.875rem;
    font-weight: 500;
    color: #212529;
    margin: 0;
}

.user-role {
    font-size: 0.75rem;
    color: #6c757d;
    margin: 0;
}

/* Dropdown Menu Improvements */
.dropdown-menu-header {
    padding: 0.5rem 1rem;
    margin-bottom: 0;
    font-weight: 600;
    color: #495057;
    background-color: #f8f9fa;
    border-bottom: 1px solid #dee2e6;
    font-size: 0.875rem;
}

.dropdown-menu-footer {
    padding: 0.5rem;
    background-color: #f8f9fa;
    border-top: 1px solid #dee2e6;
}

.dropdown-item {
    display: flex;
    align-items: center;
    padding: 0.5rem 1rem;
    font-size: 0.875rem;
}

.dropdown-item i {
    width: 16px;
    height: 16px;
    margin-right: 0.5rem;
}

/* List Group Compact */
.list-group-item-action {
    padding: 0.75rem 1rem;
}

.list-group-item-action:hover {
    background-color: #f8f9fa;
}

/* Navbar Background */
.navbar-bg {
    background-color: #fff;
    border-bottom: 1px solid #e9ecef;
    box-shadow: 0 1px 2px rgba(0,0,0,0.05);
}

/* Responsive Adjustments */
@media (max-width: 991.98px) {
    .compact-navbar {
        padding: 0.25rem 0.75rem;
    }
    
    .user-info {
        display: none;
    }
    
    .avatar-sm {
        width: 24px;
        height: 24px;
    }
}

@media (max-width: 767.98px) {
    .warehouse-indicator {
        display: none;
    }
    
    .status-compact {
        display: none;
    }
}
</style>