<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/admin/img/icons/icon-48x48.png" />
        <title>Add New User</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
        
        <!-- Bootstrap CSS (nếu chưa có trong light.css) -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        
        <!-- SimplBar CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/simplebar@latest/dist/simplebar.css">
        
        <!-- Font Awesome CSS -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        
        <link href="${pageContext.request.contextPath}/admin/css/light.css" rel="stylesheet">
        
        <style>
            body {
                opacity: 1 !important;
            }
            
            /* Đảm bảo sidebar có thể click được */
            .sidebar {
                pointer-events: auto !important;
                z-index: 1000;
            }
            
            .sidebar-link {
                pointer-events: auto !important;
                cursor: pointer !important;
            }
            
            /* Đảm bảo dropdown hoạt động */
            .sidebar-dropdown {
                pointer-events: auto !important;
            }
            
            /* Header styling */
            .breadcrumb {
                margin-bottom: 0;
                background: transparent;
                padding: 0;
                font-size: 0.875rem;
            }
            
            .breadcrumb-item a {
                color: #6c757d;
                text-decoration: none;
            }
            
            .breadcrumb-item a:hover {
                color: #007bff;
                text-decoration: underline;
            }
            
            .breadcrumb-item.active {
                color: #6c757d;
            }
            
            /* Fix cho mobile */
            @media (max-width: 768px) {
                .sidebar {
                    z-index: 1050;
                }
                
                .header-buttons {
                    flex-direction: column;
                    gap: 0.5rem;
                    width: 100%;
                }

                .header-buttons .btn {
                    width: 100%;
                }
                
                .d-flex.justify-content-between {
                    flex-direction: column;
                    gap: 1rem;
                }
            }
        </style>
    </head>
    <body>
        <div class="wrapper">
            <jsp:include page="/admin/AdminSidebar.jsp" />
            <div class="main">
                <jsp:include page="/admin/navbar.jsp" />
                <main class="content">
                    <div class="container-fluid p-0">
                        <!-- Beautiful Header Section -->
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <div>
                                <h1 class="h2 fw-bold text-primary">Create New User</h1>
                                <nav aria-label="breadcrumb">
                                    <ol class="breadcrumb">
                                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/users">Users</a></li>
                                        <li class="breadcrumb-item active">Create New</li>
                                    </ol>
                                </nav>
                            </div>
                            <div class="d-flex gap-2 header-buttons">
                                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">
                                    <i class="fas fa-arrow-left me-1"></i>Back to List
                                </a>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">User Information</h5>
                                    </div>
                                    <div class="card-body">
                                        <c:if test="${not empty error}">
                                            <div class="alert alert-danger" role="alert">
                                                ${error}
                                            </div>
                                        </c:if>
                                       <form action="${pageContext.request.contextPath}/admin/add" method="post" enctype="multipart/form-data" id="userForm">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Username <span class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" name="username" id="username" value="${user.username}" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Password <span class="text-danger">*</span></label>
                                                        <input type="password" class="form-control" name="password" id="password" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">First Name <span class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" name="firstName" id="firstName" value="${user.firstName}" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Last Name <span class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" name="lastName" id="lastName" value="${user.lastName}" required>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label class="form-label">Email</label>
                                                        <input type="email" class="form-control" name="email" id="email" value="${user.email}">
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Role <span class="text-danger">*</span></label>
                                                        <select class="form-select" name="roleId" id="roleId" required>
                                                            <option value="">Select a role</option>
                                                            <c:forEach var="role" items="${roles}">
                                                                <option value="${role.roleId}" ${user.roleId == role.roleId ? 'selected' : ''}>${role.roleName}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Gender</label>
                                                        <select class="form-select" name="gender" id="gender">
                                                            <option value="">Select gender</option>
                                                            <option value="Male" ${user.gender == 'Male' ? 'selected' : ''}>Male</option>
                                                            <option value="Female" ${user.gender == 'Female' ? 'selected' : ''}>Female</option>
                                                            <option value="Other" ${user.gender == 'Other' ? 'selected' : ''}>Other</option>
                                                        </select>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">Date of Birth</label>
                                                        <input type="date" class="form-control" name="dateOfBirth" id="dateOfBirth" value="${user.dateOfBirth}">
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- FIXED: Warehouse dropdown with proper handling -->
                                            <div class="mb-3">
                                                <label class="form-label">Warehouse</label>
                                                <select class="form-select" name="warehouseId" id="warehouseId">
                                                    <option value="">None</option>
                                                    <c:forEach var="warehouse" items="${warehouses}">
                                                        <option value="${warehouse.warehouseId}" 
                                                                ${user.warehouseId != null && user.warehouseId == warehouse.warehouseId ? 'selected' : ''}
                                                                >${warehouse.warehouseName}</option>
                                                    </c:forEach>
                                                </select>
                                                <div class="form-text text-muted">
                                                    <small>Select a warehouse to assign this user to a specific location. Leave as "None" if user doesn't need warehouse assignment.</small>
                                                </div>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Address</label>
                                                <textarea class="form-control" name="address" id="address" rows="3">${user.address}</textarea>
                                            </div>
                                            <div class="mb-3">
                                                <label class="form-label">Profile Picture</label>
                                                <input type="file" class="form-control" name="profilePic" id="profilePic" accept="image/*">
                                            </div>
                                            
                                            <!-- Buttons moved to right -->
                                            <div class="d-flex justify-content-end gap-2">
                                                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">Cancel</a>
                                                <button type="submit" class="btn btn-primary">Save User</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                <jsp:include page="/admin/footer.jsp" />
            </div>
        </div>

        <!-- CREATE USER CONFIRMATION MODAL -->
        <div id="createModal" class="create-modal">
            <div class="create-modal-content">
                <div class="create-modal-header">
                    <div class="create-icon">
                        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <line x1="19" y1="8" x2="19" y2="14"></line>
                        <line x1="22" y1="11" x2="16" y2="11"></line>
                        </svg>
                    </div>
                    <h3>Confirm Create User</h3>
                    <p>Please review the user information before creating the account.</p>
                </div>

                <div class="create-modal-body">
                    <div class="user-preview">
                        <div class="user-preview-avatar">
                            <img id="previewAvatar" src="${pageContext.request.contextPath}/img/avatars/avatar.jpg" alt="User Avatar">
                        </div>
                        <div class="user-preview-details">
                            <h4 id="previewName">User Name</h4>
                            <p class="preview-username" id="previewUsername">@username</p>
                            <div class="preview-info">
                                <div class="info-item">
                                    <span class="info-label">Role:</span>
                                    <span class="info-value" id="previewRole">Role</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Email:</span>
                                    <span class="info-value" id="previewEmail">email@example.com</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Gender:</span>
                                    <span class="info-value" id="previewGender">Not specified</span>
                                </div>
                                <div class="info-item">
                                    <span class="info-label">Date of Birth:</span>
                                    <span class="info-value" id="previewDob">Not specified</span>
                                </div>
                                <!-- NEW: Add warehouse preview -->
                                <div class="info-item">
                                    <span class="info-label">Warehouse:</span>
                                    <span class="info-value" id="previewWarehouse">Not assigned</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="create-modal-footer">
                    <button type="button" class="btn-cancel" onclick="closeCreateModal()">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M18 6L6 18M6 6l12 12"></path>
                        </svg>
                        Cancel
                    </button>
                    <button type="button" class="btn-create" onclick="confirmCreateUser()">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <line x1="19" y1="8" x2="19" y2="14"></line>
                        <line x1="22" y1="11" x2="16" y2="11"></line>
                        </svg>
                        Create User
                    </button>
                </div>
            </div>
        </div>

        <!-- LOAD JAVASCRIPT IN CORRECT ORDER -->
        
        <!-- 1. Bootstrap JS (required for sidebar dropdown) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- 2. SimplBar JS (required for js-simplebar class) -->
        <script src="https://cdn.jsdelivr.net/npm/simplebar@latest/dist/simplebar.min.js"></script>
        
        <!-- 3. App JS (must load after dependencies) -->
        <script src="${pageContext.request.contextPath}/js/app.js"></script>
        
        <!-- 4. Feather Icons (for sidebar icons) -->
        <script src="https://cdn.jsdelivr.net/npm/feather-icons@4.29.0/dist/feather.min.js"></script>

        <!-- CREATE USER MODAL STYLES -->
        <style>
            /* Create User Modal Styles */
            .create-modal {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.6);
                backdrop-filter: blur(4px);
                z-index: 10050; /* Changed from 10000 to avoid sidebar conflict */
                animation: fadeIn 0.2s ease-out;
            }

            .create-modal.show {
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .create-modal-content {
                background: #ffffff;
                border-radius: 16px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
                max-width: 500px;
                width: 90%;
                max-height: 90vh;
                overflow: hidden;
                transform: scale(0.9);
                animation: slideIn 0.3s ease-out forwards;
            }

            .create-modal-header {
                padding: 32px 24px 20px;
                text-align: center;
                border-bottom: 1px solid #f1f5f9;
                background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
            }

            .create-icon {
                width: 64px;
                height: 64px;
                margin: 0 auto 16px;
                background: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                box-shadow: 0 4px 12px rgba(14, 165, 233, 0.3);
            }

            .create-modal-header h3 {
                margin: 0 0 8px;
                font-size: 22px;
                font-weight: 600;
                color: #1f2937;
            }

            .create-modal-header p {
                margin: 0;
                color: #6b7280;
                font-size: 14px;
                line-height: 1.5;
            }

            .create-modal-body {
                padding: 24px;
            }

            .user-preview {
                display: flex;
                align-items: flex-start;
                gap: 20px;
                padding: 20px;
                background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
                border-radius: 12px;
                border-left: 4px solid #0ea5e9;
            }

            .user-preview-avatar {
                width: 64px;
                height: 64px;
                border-radius: 50%;
                overflow: hidden;
                background: #e5e7eb;
                flex-shrink: 0;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            .user-preview-avatar img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .user-preview-details {
                flex: 1;
                min-width: 0;
            }

            .user-preview-details h4 {
                margin: 0 0 4px;
                font-size: 18px;
                font-weight: 600;
                color: #1f2937;
            }

            .preview-username {
                margin: 0 0 16px;
                font-size: 14px;
                color: #0ea5e9;
                font-weight: 500;
            }

            .preview-info {
                display: grid;
                gap: 8px;
            }

            .info-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 4px 0;
            }

            .info-label {
                font-size: 13px;
                color: #6b7280;
                font-weight: 500;
                min-width: 80px;
            }

            .info-value {
                font-size: 13px;
                color: #1f2937;
                font-weight: 500;
                text-align: right;
                word-break: break-word;
            }

            .create-modal-footer {
                padding: 16px 24px 24px;
                display: flex;
                gap: 12px;
                justify-content: flex-end;
                background: #f8fafc;
            }

            .btn-cancel, .btn-create {
                padding: 12px 24px;
                border: none;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 8px;
                transition: all 0.2s ease;
                text-decoration: none;
            }

            .btn-cancel {
                background: #f1f5f9;
                color: #475569;
                border: 1px solid #e2e8f0;
            }

            .btn-cancel:hover {
                background: #e2e8f0;
                transform: translateY(-1px);
            }

            .btn-create {
                background: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%);
                color: white;
                box-shadow: 0 2px 4px rgba(14, 165, 233, 0.2);
            }

            .btn-create:hover {
                background: linear-gradient(135deg, #0284c7 0%, #0369a1 100%);
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(14, 165, 233, 0.3);
            }

            .btn-create:active {
                transform: translateY(0);
            }

            /* Animations */
            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            @keyframes slideIn {
                from {
                    transform: scale(0.9) translateY(-20px);
                    opacity: 0;
                }
                to {
                    transform: scale(1) translateY(0);
                    opacity: 1;
                }
            }

            /* Mobile responsive */
            @media (max-width: 480px) {
                .create-modal-content {
                    margin: 20px;
                    width: calc(100% - 40px);
                }

                .create-modal-header {
                    padding: 24px 20px 16px;
                }

                .create-modal-body {
                    padding: 16px 20px;
                }

                .user-preview {
                    flex-direction: column;
                    text-align: center;
                    gap: 16px;
                }

                .user-preview-avatar {
                    margin: 0 auto;
                }

                .info-item {
                    flex-direction: column;
                    text-align: center;
                    gap: 4px;
                }

                .info-value {
                    text-align: center;
                }

                .create-modal-footer {
                    padding: 12px 20px 20px;
                    flex-direction: column;
                }

                .btn-cancel, .btn-create {
                    width: 100%;
                    justify-content: center;
                }
            }
            
            /* Additional fixes for sidebar interaction */
            .is-invalid {
                border-color: #dc3545 !important;
                box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25) !important;
            }
            
            /* Loading spinner animation */
            @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }
            
            .spinner {
                animation: spin 1s linear infinite;
            }
        </style>

        <!-- CREATE USER MODAL JAVASCRIPT -->
        <script>
            // Wait for DOM and all dependencies to load
            document.addEventListener('DOMContentLoaded', function() {
                
                // Initialize Feather icons if available
                if (typeof feather !== 'undefined') {
                    feather.replace();
                }
                
                // Ensure sidebar functionality
                initializeSidebar();
                
                // Initialize form functionality
                initializeForm();
            });
            
            // Sidebar initialization function
            function initializeSidebar() {
                // Ensure all sidebar links are clickable
                const sidebarLinks = document.querySelectorAll('.sidebar-link');
                sidebarLinks.forEach(link => {
                    link.style.pointerEvents = 'auto';
                    link.style.cursor = 'pointer';
                });
                
                // Initialize dropdown functionality manually if Bootstrap doesn't work
                const dropdownToggles = document.querySelectorAll('[data-bs-toggle="collapse"]');
                dropdownToggles.forEach(toggle => {
                    toggle.addEventListener('click', function(e) {
                        e.preventDefault();
                        const targetId = this.getAttribute('data-bs-target');
                        const target = document.querySelector(targetId);
                        
                        if (target) {
                            if (target.classList.contains('show')) {
                                target.classList.remove('show');
                                this.classList.add('collapsed');
                            } else {
                                target.classList.add('show');
                                this.classList.remove('collapsed');
                            }
                        }
                    });
                });
            }
            
            // Form initialization function
            function initializeForm() {
                // CREATE USER CONFIRMATION SYSTEM
                let isSubmitting = false;

                function openCreateModal() {
                    // Get form data
                    const firstName = document.getElementById('firstName').value.trim();
                    const lastName = document.getElementById('lastName').value.trim();
                    const username = document.getElementById('username').value.trim();
                    const email = document.getElementById('email').value.trim();
                    const roleSelect = document.getElementById('roleId');
                    const roleName = roleSelect.options[roleSelect.selectedIndex]?.text || 'Not selected';
                    const gender = document.getElementById('gender').value || 'Not specified';
                    const dateOfBirth = document.getElementById('dateOfBirth').value || 'Not specified';
                    const profilePic = document.getElementById('profilePic').files[0];
                    
                    // Get warehouse information
                    const warehouseSelect = document.getElementById('warehouseId');
                    const warehouseName = warehouseSelect.options[warehouseSelect.selectedIndex]?.text || 'Not assigned';

                    // Format full name
                    const fullName = (firstName + ' ' + lastName).trim() || 'No name provided';

                    // Update modal content
                    document.getElementById('previewName').textContent = fullName;
                    document.getElementById('previewUsername').textContent = '@' + (username || 'username');
                    document.getElementById('previewRole').textContent = roleName;
                    document.getElementById('previewEmail').textContent = email || 'No email provided';
                    document.getElementById('previewGender').textContent = gender;
                    document.getElementById('previewWarehouse').textContent = warehouseName;

                    // Format date of birth
                    if (dateOfBirth !== 'Not specified') {
                        const date = new Date(dateOfBirth);
                        const formattedDate = date.toLocaleDateString('en-US', {
                            year: 'numeric',
                            month: 'long',
                            day: 'numeric'
                        });
                        document.getElementById('previewDob').textContent = formattedDate;
                    } else {
                        document.getElementById('previewDob').textContent = 'Not specified';
                    }

                    // Handle profile picture preview
                    const avatarImg = document.getElementById('previewAvatar');
                    if (profilePic) {
                        const reader = new FileReader();
                        reader.onload = function (e) {
                            avatarImg.src = e.target.result;
                        };
                        reader.readAsDataURL(profilePic);
                    } else {
                        avatarImg.src = '${pageContext.request.contextPath}/img/avatars/avatar.jpg';
                    }

                    // Show modal
                    document.getElementById('createModal').classList.add('show');
                    document.body.style.overflow = 'hidden';
                }

                function closeCreateModal() {
                    document.getElementById('createModal').classList.remove('show');
                    document.body.style.overflow = 'auto';
                    isSubmitting = false;
                }

                function confirmCreateUser() {
                    if (!isSubmitting) {
                        isSubmitting = true;

                        // Add visual feedback
                        const createBtn = document.querySelector('.btn-create');
                        const originalText = createBtn.innerHTML;
                        createBtn.innerHTML = '<svg width="16" height="16" fill="currentColor" class="spinner" viewBox="0 0 16 16"><path d="M11.534 7h3.932a.25.25 0 0 1 .192.41l-1.966 2.36a.25.25 0 0 1-.384 0l-1.966-2.36a.25.25 0 0 1 .192-.41zm-11 2h3.932a.25.25 0 0 0 .192-.41L2.692 6.23a.25.25 0 0 0-.384 0L.342 8.59A.25.25 0 0 0 .534 9z"/><path fill-rule="evenodd" d="M8 3c-1.552 0-2.94.707-3.857 1.818a.5.5 0 1 1-.771-.636A6.002 6.002 0 0 1 13.917 7H12.9A5.002 5.002 0 0 0 8 3zM3.1 9a5.002 5.002 0 0 0 8.757 2.182.5.5 0 1 1 .771.636A6.002 6.002 0 0 1 2.083 9H3.1z"/></svg> Creating...';
                        createBtn.disabled = true;

                        // Submit the form after short delay for better UX
                        setTimeout(() => {
                            document.getElementById('userForm').submit();
                        }, 500);
                    }
                }
                
                // Make functions global so they can be called from onclick handlers
                window.openCreateModal = openCreateModal;
                window.closeCreateModal = closeCreateModal;
                window.confirmCreateUser = confirmCreateUser;

                // Form validation and modal integration
                const form = document.getElementById('userForm');

                form.addEventListener('submit', function (e) {
                    if (!isSubmitting) {
                        e.preventDefault();

                        // Basic validation
                        const requiredFields = ['username', 'password', 'firstName', 'lastName', 'roleId'];
                        let isValid = true;
                        let firstInvalidField = null;

                        requiredFields.forEach(fieldId => {
                            const field = document.getElementById(fieldId);
                            if (!field.value.trim()) {
                                isValid = false;
                                field.classList.add('is-invalid');
                                if (!firstInvalidField) {
                                    firstInvalidField = field;
                                }
                            } else {
                                field.classList.remove('is-invalid');
                            }
                        });

                        if (!isValid) {
                            if (firstInvalidField) {
                                firstInvalidField.focus();
                                firstInvalidField.scrollIntoView({behavior: 'smooth', block: 'center'});
                            }

                            // Show error message
                            const existingAlert = document.querySelector('.validation-alert');
                            if (existingAlert) {
                                existingAlert.remove();
                            }

                            const alert = document.createElement('div');
                            alert.className = 'alert alert-danger validation-alert';
                            alert.innerHTML = '<strong>Error:</strong> Please fill in all required fields marked with <span class="text-danger">*</span>';

                            const cardBody = document.querySelector('.card-body');
                            cardBody.insertBefore(alert, cardBody.firstChild);

                            // Auto-hide error after 5 seconds
                            setTimeout(() => {
                                if (alert && alert.parentNode) {
                                    alert.remove();
                                }
                            }, 5000);

                            return;
                        }

                        // Remove validation alert if exists
                        const existingAlert = document.querySelector('.validation-alert');
                        if (existingAlert) {
                            existingAlert.remove();
                        }

                        // Show confirmation modal
                        openCreateModal();
                    }
                });

                // Remove invalid class on input
                const inputs = document.querySelectorAll('input, select');
                inputs.forEach(input => {
                    input.addEventListener('input', function () {
                        this.classList.remove('is-invalid');
                    });
                });

                // Close modal on outside click
                document.getElementById('createModal').addEventListener('click', function (e) {
                    if (e.target === this) {
                        closeCreateModal();
                    }
                });

                // Close modal on ESC key
                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape' && document.getElementById('createModal').classList.contains('show')) {
                        closeCreateModal();
                    }
                });
            }
        </script>
    </body>
</html>