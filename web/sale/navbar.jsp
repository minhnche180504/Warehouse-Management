<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- COMPLETELY ISOLATED NAVBAR -->
<div id="isolated-navbar" style="
    position: relative;
    z-index: 9999;
    background: white;
    border-bottom: 1px solid #e5e7eb;
    padding: 0.5rem 1rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
    min-height: 60px;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
">
    <!-- Left Side -->
    <div style="display: flex; align-items: center;">
        <button id="sidebar-toggle" style="
            background: none;
            border: none;
            color: #6b7280;
            font-size: 1.25rem;
            padding: 0.5rem;
            cursor: pointer;
            border-radius: 0.375rem;
            margin-right: 1rem;
        " onclick="toggleSidebar()">
            <i class="fas fa-bars"></i>
        </button>
    </div>

    <!-- Right Side -->
    <div style="display: flex; align-items: center; gap: 0.5rem;">
        
        <!-- Notifications -->
        <div style="position: relative; display: inline-block;">
            <button id="notifications-btn" style="
                background: none;
                border: none;
                color: #6b7280;
                padding: 0.5rem;
                cursor: pointer;
                border-radius: 0.375rem;
                position: relative;
                font-size: 1rem;
            ">
                <i class="fas fa-bell"></i>
                <span style="
                    position: absolute;
                    top: 2px;
                    right: 2px;
                    background: #ef4444;
                    color: white;
                    border-radius: 50%;
                    width: 14px;
                    height: 14px;
                    font-size: 9px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-weight: 600;
                ">4</span>
            </button>
            
            <!-- Notifications Dropdown -->
            <div id="notifications-dropdown" style="
                position: absolute;
                top: 100%;
                right: 0;
                background: white;
                border: 1px solid #e5e7eb;
                border-radius: 0.5rem;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
                width: 350px;
                z-index: 10000;
                display: none;
                margin-top: 0.5rem;
            ">
                <div style="
                    padding: 1rem;
                    border-bottom: 1px solid #e5e7eb;
                    font-weight: 600;
                    color: #374151;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                ">
                    <span>Notifications</span>
                    <small style="color: #6b7280;">4 new</small>
                </div>
                
                <div style="max-height: 300px; overflow-y: auto;">
                    <a href="<c:url value='/sale/inventory-alerts'/>" style="
                        display: block;
                        padding: 1rem;
                        border-bottom: 1px solid #f3f4f6;
                        text-decoration: none;
                        color: inherit;
                    " class="notification-item">
                        <div style="display: flex; align-items: start; gap: 0.75rem;">
                            <i class="fas fa-exclamation-triangle" style="color: #f59e0b; margin-top: 0.25rem;"></i>
                            <div>
                                <div style="font-weight: 600; color: #111827;">Low Stock Alert</div>
                                <div style="color: #6b7280; font-size: 0.875rem; margin-top: 0.25rem;">Laptop Acer Nitro 5 - Only 5 left</div>
                                <div style="color: #9ca3af; font-size: 0.75rem; margin-top: 0.25rem;">5 minutes ago</div>
                            </div>
                        </div>
                    </a>
                    
                    <a href="<c:url value='/sale/view-sales-order-list'/>" style="
                        display: block;
                        padding: 1rem;
                        border-bottom: 1px solid #f3f4f6;
                        text-decoration: none;
                        color: inherit;
                    " class="notification-item">
                        <div style="display: flex; align-items: start; gap: 0.75rem;">
                            <i class="fas fa-shopping-cart" style="color: #10b981; margin-top: 0.25rem;"></i>
                            <div>
                                <div style="font-weight: 600; color: #111827;">New Sales Order</div>
                                <div style="color: #6b7280; font-size: 0.875rem; margin-top: 0.25rem;">Order #SO-2023006 from ABC Company</div>
                                <div style="color: #9ca3af; font-size: 0.75rem; margin-top: 0.25rem;">10 minutes ago</div>
                            </div>
                        </div>
                    </a>
                </div>
                
                <div style="padding: 0.75rem;">
                    <a href="<c:url value='/sale/notifications'/>" style="
                        display: block;
                        text-align: center;
                        padding: 0.5rem;
                        background: #f9fafb;
                        color: #374151;
                        text-decoration: none;
                        border-radius: 0.375rem;
                        font-size: 0.875rem;
                    ">View All Notifications</a>
                </div>
            </div>
        </div>

        <!-- Messages -->
        <div style="position: relative; display: inline-block;">
            <button id="messages-btn" style="
                background: none;
                border: none;
                color: #6b7280;
                padding: 0.5rem;
                cursor: pointer;
                border-radius: 0.375rem;
                font-size: 1rem;
            ">
                <i class="fas fa-envelope"></i>
            </button>
            
            <!-- Messages Dropdown -->
            <div id="messages-dropdown" style="
                position: absolute;
                top: 100%;
                right: 0;
                background: white;
                border: 1px solid #e5e7eb;
                border-radius: 0.5rem;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
                width: 320px;
                z-index: 10000;
                display: none;
                margin-top: 0.5rem;
            ">
                <div style="
                    padding: 1rem;
                    border-bottom: 1px solid #e5e7eb;
                    font-weight: 600;
                    color: #374151;
                ">Messages</div>
                
                <div style="padding: 2rem; text-align: center; color: #6b7280;">
                    <i class="fas fa-envelope" style="font-size: 2rem; margin-bottom: 0.5rem; opacity: 0.5;"></i>
                    <div>No new messages</div>
                </div>
            </div>
        </div>

        <!-- User Profile Menu (Text Only) -->
        <div style="position: relative; display: inline-block;">
            <button id="profile-btn" style="
                background: none;
                border: none;
                padding: 0.5rem 0.75rem;
                cursor: pointer;
                border-radius: 0.375rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
                color: #374151;
                font-weight: 500;
            ">
                <img src="<c:url value='/sale/img/avatars/avatar.jpg'/>" style="
                    width: 32px;
                    height: 32px;
                    border-radius: 50%;
                    object-fit: cover;
                    border: 2px solid #e5e7eb;
                " alt="User Avatar" />
                <div style="display: flex; flex-direction: column; align-items: flex-start; line-height: 1.2;">
                    <span style="font-size: 0.875rem; font-weight: 500;">
                        <c:choose>
                            <c:when test="${sessionScope.user != null}">
                                ${sessionScope.user.firstName} ${sessionScope.user.lastName}
                            </c:when>
                            <c:otherwise>
                                Sales Staff
                            </c:otherwise>
                        </c:choose>
                    </span>
                    <span style="font-size: 0.75rem; color: #6b7280; font-weight: 400;">Sale Staff</span>
                </div>
                <i class="fas fa-chevron-down" style="color: #6b7280; font-size: 0.75rem;"></i>
            </button>
            
            <!-- Profile Dropdown -->
            <div id="profile-dropdown" style="
                position: absolute;
                top: 100%;
                right: 0;
                background: white;
                border: 1px solid #e5e7eb;
                border-radius: 0.5rem;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
                width: 200px;
                z-index: 10000;
                display: none;
                margin-top: 0.5rem;
            ">
                <div style="
                    padding: 1rem;
                    border-bottom: 1px solid #e5e7eb;
                    text-align: center;
                ">
                    <img src="<c:url value='/sale/img/avatars/avatar.jpg'/>" style="
                        width: 48px;
                        height: 48px;
                        border-radius: 50%;
                        object-fit: cover;
                        border: 2px solid #e5e7eb;
                        margin-bottom: 0.5rem;
                    " alt="User Avatar" />
                    <div style="font-weight: 600; color: #111827;">
                        <c:choose>
                            <c:when test="${sessionScope.user != null}">
                                ${sessionScope.user.firstName} ${sessionScope.user.lastName}
                            </c:when>
                            <c:otherwise>
                                Sales Staff
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div style="font-size: 0.875rem; color: #6b7280;">Sale Staff</div>
                </div>
                
                <div style="padding: 0.5rem;">
                    <a href="<c:url value='/sale/UserProfile'/>" style="
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                        padding: 0.5rem;
                        color: #374151;
                        text-decoration: none;
                        border-radius: 0.375rem;
                        font-size: 0.875rem;
                    " class="dropdown-link">
                        <i class="fas fa-user" style="width: 16px;"></i>
                        Profile
                    </a>
                    
                    <a href="<c:url value='/sale/changePassword.jsp'/>" style="
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                        padding: 0.5rem;
                        color: #374151;
                        text-decoration: none;
                        border-radius: 0.375rem;
                        font-size: 0.875rem;
                    " class="dropdown-link">
                        <i class="fas fa-lock" style="width: 16px;"></i>
                        Change Password
                    </a>
                    
                    <hr style="margin: 0.5rem 0; border: none; border-top: 1px solid #e5e7eb;">
                    
                    <a href="<c:url value='/logout'/>" style="
                        display: flex;
                        align-items: center;
                        gap: 0.5rem;
                        padding: 0.5rem;
                        color: #ef4444;
                        text-decoration: none;
                        border-radius: 0.375rem;
                        font-size: 0.875rem;
                    " class="dropdown-link">
                        <i class="fas fa-sign-out-alt" style="width: 16px;"></i>
                        Log out
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ISOLATED CSS AND JAVASCRIPT -->
<style>
/* Hover effects for navbar */
#isolated-navbar button:hover {
    background-color: #f3f4f6 !important;
}

#isolated-navbar .notification-item:hover,
#isolated-navbar .dropdown-link:hover {
    background-color: #f3f4f6 !important;
}

/* Responsive */
@media (min-width: 1024px) {
    #isolated-navbar .user-info-desktop {
        display: block !important;
    }
}

/* Sidebar toggle hover */
#sidebar-toggle:hover {
    background-color: #f3f4f6 !important;
}
</style>

<script>
(function() {
    // Completely isolated navbar JavaScript
    document.addEventListener('DOMContentLoaded', function() {
        console.log('Isolated navbar initializing...');
        
        // Get elements
        const notificationsBtn = document.getElementById('notifications-btn');
        const notificationsDropdown = document.getElementById('notifications-dropdown');
        const messagesBtn = document.getElementById('messages-btn');
        const messagesDropdown = document.getElementById('messages-dropdown');
        const profileBtn = document.getElementById('profile-btn');
        const profileDropdown = document.getElementById('profile-dropdown');
        
        // Notifications dropdown
        if (notificationsBtn && notificationsDropdown) {
            notificationsBtn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                console.log('Notifications clicked');
                
                // Close other dropdowns
                if (messagesDropdown) messagesDropdown.style.display = 'none';
                if (profileDropdown) profileDropdown.style.display = 'none';
                
                // Toggle notifications
                if (notificationsDropdown.style.display === 'none' || !notificationsDropdown.style.display) {
                    notificationsDropdown.style.display = 'block';
                } else {
                    notificationsDropdown.style.display = 'none';
                }
            });
        }
        
        // Messages dropdown
        if (messagesBtn && messagesDropdown) {
            messagesBtn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                console.log('Messages clicked');
                
                // Close other dropdowns
                if (notificationsDropdown) notificationsDropdown.style.display = 'none';
                if (profileDropdown) profileDropdown.style.display = 'none';
                
                // Toggle messages
                if (messagesDropdown.style.display === 'none' || !messagesDropdown.style.display) {
                    messagesDropdown.style.display = 'block';
                } else {
                    messagesDropdown.style.display = 'none';
                }
            });
        }
        
        // Profile dropdown
        if (profileBtn && profileDropdown) {
            profileBtn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                console.log('Profile clicked');
                
                // Close other dropdowns
                if (notificationsDropdown) notificationsDropdown.style.display = 'none';
                if (messagesDropdown) messagesDropdown.style.display = 'none';
                
                // Toggle profile
                if (profileDropdown.style.display === 'none' || !profileDropdown.style.display) {
                    profileDropdown.style.display = 'block';
                } else {
                    profileDropdown.style.display = 'none';
                }
            });
        }
        
        // Close dropdowns when clicking outside
        document.addEventListener('click', function(e) {
            const navbar = document.getElementById('isolated-navbar');
            if (navbar && !navbar.contains(e.target)) {
                if (notificationsDropdown) notificationsDropdown.style.display = 'none';
                if (messagesDropdown) messagesDropdown.style.display = 'none';
                if (profileDropdown) profileDropdown.style.display = 'none';
            }
        });
        
        console.log('Isolated navbar initialized successfully');
    });
    
    // Global sidebar toggle function
    window.toggleSidebar = function() {
        console.log('Toggle sidebar called');
        const sidebar = document.getElementById('sidebar');
        if (sidebar) {
            sidebar.classList.toggle('sidebar-mobile-show');
        }
    };
})();
</script>