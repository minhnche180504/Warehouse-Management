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
    <title>User Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    
    <!-- Font Awesome CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <link href="${pageContext.request.contextPath}/admin/css/light.css" rel="stylesheet">
    <style>
        body { opacity: 1 !important; }
        
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
        
        .header-buttons .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
        }
        
        /* Role Badge Colors - Clean & Consistent */
        .badge {
            font-size: 11px;
            font-weight: 500;
            padding: 6px 10px;
            border-radius: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border: 1px solid transparent;
            min-width: 90px;
            text-align: center;
            display: inline-block;
        }
        
        .role-admin {
            background: #fef2f2;
            color: #991b1b;
            border-color: #fecaca;
        }
        
        .role-warehouse-manager {
            background: #eff6ff;
            color: #1e40af;
            border-color: #bfdbfe;
        }
        
        .role-sales-staff {
            background: #f0fdf4;
            color: #166534;
            border-color: #bbf7d0;
        }
        
        .role-warehouse-staff {
            background: #fffbeb;
            color: #b45309;
            border-color: #fed7aa;
        }
        
        /* Status Badge Styles */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-active {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #bbf7d0;
        }
        
        .status-inactive {
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #e2e8f0;
        }
        
        .status-indicator {
            width: 6px;
            height: 6px;
            border-radius: 50%;
        }
        
        .status-active .status-indicator {
            background: #22c55e;
        }
        
        .status-inactive .status-indicator {
            background: #94a3b8;
        }
        
        /* Action Button Styles */
        .btn-activate {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 500;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        
        .btn-activate:hover {
            background: linear-gradient(135deg, #059669 0%, #047857 100%);
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(16, 185, 129, 0.3);
            color: white;
        }
        
        .btn-deactivate {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 500;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        
        .btn-deactivate:hover {
            background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(245, 158, 11, 0.3);
            color: white;
        }
        
        .btn-view {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 500;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            margin-right: 4px;
        }
        
        .btn-view:hover {
            background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(59, 130, 246, 0.3);
            color: white;
        }
        
        /* Inactive User Row Styling */
        .user-row.inactive {
            background-color: #f8fafc;
            opacity: 0.75;
        }
        
        .user-row.inactive td {
            color: #64748b;
        }
        
        /* Filter Enhancement for Status */
        .status-filter-section {
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
            border-radius: 8px;
            padding: 12px 16px;
            margin-top: 8px;
            border-left: 4px solid #0ea5e9;
        }
        
        .status-summary {
            display: flex;
            gap: 20px;
            align-items: center;
            font-size: 13px;
            color: #475569;
        }
        
        .summary-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-weight: 500;
        }
        
        .summary-count {
            background: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-weight: 600;
            color: #1e293b;
            border: 1px solid #e2e8f0;
        }
        
        /* Enhanced Filter & Search Section */
        .filter-search-section {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            margin-bottom: 24px;
            padding: 20px;
            border: 1px solid #e2e8f0;
        }
        
        .filter-search-header {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 16px;
            color: #475569;
            font-weight: 600;
            font-size: 14px;
        }
        
        .filter-search-controls {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr auto;
            gap: 16px;
            align-items: end;
        }
        
        .search-group, .filter-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        
        .search-group label, .filter-group label {
            font-size: 13px;
            font-weight: 500;
            color: #64748b;
            margin-bottom: 0;
        }
        
        .search-input {
            position: relative;
        }
        
        .search-input input {
            padding: 10px 40px 10px 16px;
            border: 1.5px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.2s ease;
            background: #ffffff;
        }
        
        .search-input input:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
        .search-input .search-icon {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            pointer-events: none;
        }
        
        .filter-select {
            padding: 10px 16px;
            border: 1.5px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            background: #ffffff;
            transition: all 0.2s ease;
            cursor: pointer;
        }
        
        .filter-select:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
        .clear-filters-btn {
            padding: 10px 16px;
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
        }
        
        .clear-filters-btn:hover {
            background: #e2e8f0;
            color: #334155;
            transform: translateY(-1px);
        }
        
        /* Enhanced Table Styles */
        .enhanced-table-container {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            border: 1px solid #e2e8f0;
        }
        
        .table-header {
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            border-bottom: 1px solid #e2e8f0;
            padding: 16px 20px;
        }
        
        .table-title {
            font-size: 16px;
            font-weight: 600;
            color: #1e293b;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .results-info {
            font-size: 13px;
            color: #64748b;
            margin-top: 4px;
        }
        
        .table-responsive {
            margin: 0;
        }
        
        .sortable-header {
            cursor: pointer;
            position: relative;
            transition: all 0.2s ease;
            user-select: none;
            padding: 12px 8px !important;
        }
        
        .sortable-header:hover {
            background-color: #f1f5f9;
            color: #3b82f6;
        }
        
        .sort-indicator {
            position: absolute;
            right: 8px;
            top: 50%;
            transform: translateY(-50%);
            opacity: 0.3;
            transition: all 0.2s ease;
        }
        
        .sortable-header:hover .sort-indicator {
            opacity: 0.6;
        }
        
        .sortable-header.sort-asc .sort-indicator {
            opacity: 1;
            color: #3b82f6;
            transform: translateY(-50%) rotate(180deg);
        }
        
        .sortable-header.sort-desc .sort-indicator {
            opacity: 1;
            color: #3b82f6;
            transform: translateY(-50%) rotate(0deg);
        }
        
        .user-row {
            transition: all 0.2s ease;
        }
        
        .user-row:hover {
            background-color: #f8fafc;
        }
        
        .no-results {
            text-align: center;
            padding: 60px 20px;
            color: #64748b;
        }
        
        .no-results-icon {
            width: 64px;
            height: 64px;
            margin: 0 auto 16px;
            color: #cbd5e1;
        }
        
        .no-results h4 {
            margin: 0 0 8px;
            font-size: 18px;
            color: #475569;
        }
        
        .no-results p {
            margin: 0;
            font-size: 14px;
        }

        /* ============ COMPACT PAGINATION STYLES ============ */
        .pagination-wrapper {
            background: #f8fafc;
            border-radius: 0 0 12px 12px;
            padding: 12px 20px;
        }
        
        .pagination-top-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
            flex-wrap: wrap;
            gap: 8px;
        }
        
        .page-size-control {
            display: flex;
            align-items: center;
            white-space: nowrap;
            font-size: 13px;
            color: #6c757d;
            gap: 8px;
        }
        
        .page-size-control .form-select {
            min-width: 65px;
            width: auto;
            padding: 0.25rem 1.5rem 0.25rem 0.5rem;
            font-size: 13px;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            background-color: #fff;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3e%3cpath fill='none' stroke='%23343a40' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m1 6 7 7 7-7'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 0.5rem center;
            background-size: 16px 12px;
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
        }
        
        .page-size-control .form-select:focus {
            border-color: #86b7fe;
            outline: 0;
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }
        
        .page-info-display {
            color: #6c757d;
            font-size: 13px;
        }
        
        .pagination-nav-row {
            display: flex;
            justify-content: center;
        }

        .pagination .page-link {
            border: 1px solid #dee2e6;
            color: #495057;
            padding: 0.2rem 0.4rem;
            font-size: 13px;
            min-width: 28px;
            text-align: center;
        }

        .pagination .page-link:hover {
            background-color: #e9ecef;
            border-color: #dee2e6;
            color: #495057;
        }

        .pagination .page-item.active .page-link {
            background-color: #007bff;
            border-color: #007bff;
            color: white;
        }

        .pagination .page-item.disabled .page-link {
            color: #6c757d;
            background-color: #fff;
            border-color: #dee2e6;
        }

        .pagination-sm .page-link {
            padding: 0.2rem 0.4rem;
            font-size: 0.8rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .filter-search-controls {
                grid-template-columns: 1fr;
                gap: 12px;
            }
            
            .clear-filters-btn {
                justify-self: start;
                width: fit-content;
            }
            
            .status-summary {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
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
            
            /* Mobile pagination improvements */
            .pagination-top-row {
                flex-direction: column;
                align-items: stretch;
                text-align: center;
                gap: 6px;
                margin-bottom: 6px;
            }
            
            .page-size-control {
                justify-content: center;
                font-size: 12px;
                gap: 6px;
            }
            
            .page-size-control .form-select {
                min-width: 60px;
                padding: 0.2rem 1.2rem 0.2rem 0.4rem;
                font-size: 12px;
            }
            
            .page-info-display {
                text-align: center;
                font-size: 12px;
            }
            
            .pagination-wrapper {
                padding: 8px 12px;
            }
            
            .pagination-nav-row .pagination {
                flex-wrap: wrap;
                justify-content: center;
            }
        }

        /* Extra small screens */
        @media (max-width: 576px) {
            .pagination .page-link {
                padding: 0.15rem 0.3rem;
                font-size: 0.75rem;
                min-width: 24px;
            }
            
            .page-size-control {
                flex-direction: column;
                gap: 4px;
                font-size: 11px;
            }
            
            .page-size-control .form-select {
                min-width: 55px;
                padding: 0.15rem 1rem 0.15rem 0.3rem;
                font-size: 11px;
            }
            
            .pagination-wrapper {
                padding: 6px 8px;
            }
            
            .page-info-display {
                font-size: 11px;
            }
        }

        /* Include all notification styles from original file */
        .notification-container {
            max-width: 400px;
            min-width: 300px;
        }
        
        .notification-alert {
            border: none;
            border-radius: 16px;
            margin-bottom: 15px;
            overflow: hidden;
            position: relative;
            backdrop-filter: blur(10px);
            animation: slideInRight 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            transition: all 0.3s ease;
        }
        
        .notification-alert:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15) !important;
        }
        
        .notification-content {
            display: flex;
            align-items: flex-start;
            padding: 16px 20px;
            gap: 12px;
        }
        
        .notification-icon {
            flex-shrink: 0;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: 2px;
        }
        
        .notification-text {
            flex: 1;
            min-width: 0;
        }
        
        .notification-title {
            font-weight: 600;
            font-size: 16px;
            margin-bottom: 4px;
            line-height: 1.2;
        }
        
        .notification-message {
            font-size: 14px;
            line-height: 1.4;
            opacity: 0.9;
            word-wrap: break-word;
        }
        
        .notification-close {
            background: none;
            border: none;
            padding: 8px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
            opacity: 0.6;
            margin-top: -4px;
            margin-right: -8px;
        }
        
        .notification-close:hover {
            opacity: 1;
            background: rgba(255, 255, 255, 0.2);
            transform: scale(1.1);
        }
        
        .notification-progress {
            position: absolute;
            bottom: 0;
            left: 0;
            height: 4px;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 0 0 16px 16px;
        }
        
        /* Success Notification */
        .alert-success.notification-alert {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            box-shadow: 0 4px 20px rgba(16, 185, 129, 0.3);
        }
        
        .alert-success .notification-icon {
            background: rgba(255, 255, 255, 0.2);
        }
        
        .alert-success .notification-progress {
            background: rgba(255, 255, 255, 0.3);
            animation: progressCountdown 6s linear forwards;
        }
        
        /* Error Notification */
        .alert-danger.notification-alert {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            color: white;
            box-shadow: 0 4px 20px rgba(239, 68, 68, 0.3);
        }
        
        .alert-danger .notification-icon {
            background: rgba(255, 255, 255, 0.2);
        }
        
        .alert-danger .notification-progress {
            background: rgba(255, 255, 255, 0.3);
            animation: progressCountdown 8s linear forwards;
        }
        
        /* Info Notification */
        .alert-info.notification-alert {
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            color: white;
            box-shadow: 0 4px 20px rgba(59, 130, 246, 0.3);
        }
        
        .alert-info .notification-icon {
            background: rgba(255, 255, 255, 0.2);
        }
        
        .alert-info .notification-progress {
            background: rgba(255, 255, 255, 0.3);
            animation: progressCountdown 7s linear forwards;
        }
        
        /* Animations */
        @keyframes slideInRight {
            from {
                transform: translateX(100%) translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateX(0) translateY(0);
                opacity: 1;
            }
        }
        
        @keyframes slideOutRight {
            from {
                transform: translateX(0) translateY(0);
                opacity: 1;
            }
            to {
                transform: translateX(100%) translateY(-10px);
                opacity: 0;
            }
        }
        
        @keyframes progressCountdown {
            from { transform: scaleX(1); }
            to { transform: scaleX(0); }
        }
        
        .notification-alert.slide-out {
            animation: slideOutRight 0.4s ease-in forwards;
        }
        
        /* Mobile Responsive */
        @media (max-width: 768px) {
            .notification-container {
                left: 10px !important;
                right: 10px !important;
                top: 10px !important;
                max-width: none;
                min-width: none;
            }
            
            .notification-content {
                padding: 14px 16px;
            }
            
            .notification-title {
                font-size: 15px;
            }
            
            .notification-message {
                font-size: 13px;
            }
        }
    </style>
</head>
<body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
    <div class="wrapper">
        <jsp:include page="/admin/AdminSidebar.jsp" />
        <div class="main">
            <jsp:include page="/admin/navbar.jsp" />
            <main class="content">
                <div class="container-fluid p-0">
                    <!-- SUCCESS/ERROR NOTIFICATIONS -->
                    <c:if test="${param.success != null}">
                        <div class="notification-container position-fixed" style="top: 20px; right: 20px; z-index: 9999;">
                            <div class="alert alert-success notification-alert shadow-lg" role="alert" id="successAlert">
                                <div class="notification-content">
                                    <div class="notification-icon">
                                        <svg width="24" height="24" fill="currentColor" viewBox="0 0 16 16">
                                            <path d="M2.5 8a5.5 5.5 0 0 1 8.25-4.764.5.5 0 0 0 .5-.866A6.5 6.5 0 1 0 14.5 8a.5.5 0 0 0-1 0 5.5 5.5 0 1 1-11 0z"/>
                                            <path d="M15.354 3.354a.5.5 0 0 0-.708-.708L8 9.293 5.354 6.646a.5.5 0 1 0-.708.708l3 3a.5.5 0 0 0 .708 0l7-7z"/>
                                        </svg>
                                    </div>
                                    <div class="notification-text">
                                        <div class="notification-title">Success!</div>
                                        <div class="notification-message">${param.success}</div>
                                    </div>
                                    <button type="button" class="notification-close" onclick="closeNotification('successAlert')">
                                        <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
                                            <path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8 2.146 2.854Z"/>
                                        </svg>
                                    </button>
                                </div>
                                <div class="notification-progress" id="successProgress"></div>
                            </div>
                        </div>
                    </c:if>
                    
                    <c:if test="${param.error != null}">
                        <div class="notification-container position-fixed" style="top: 20px; right: 20px; z-index: 9999;">
                            <div class="alert alert-danger notification-alert shadow-lg" role="alert" id="errorAlert">
                                <div class="notification-content">
                                    <div class="notification-icon">
                                        <svg width="24" height="24" fill="currentColor" viewBox="0 0 16 16">
                                            <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
                                        </svg>
                                    </div>
                                    <div class="notification-text">
                                        <div class="notification-title">Error!</div>
                                        <div class="notification-message">${param.error}</div>
                                    </div>
                                    <button type="button" class="notification-close" onclick="closeNotification('errorAlert')">
                                        <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
                                            <path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8 2.146 2.854Z"/>
                                        </svg>
                                    </button>
                                </div>
                                <div class="notification-progress" id="errorProgress"></div>
                            </div>
                        </div>
                    </c:if>
                    
                    <c:if test="${param.info != null}">
                        <div class="notification-container position-fixed" style="top: 20px; right: 20px; z-index: 9999;">
                            <div class="alert alert-info notification-alert shadow-lg" role="alert" id="infoAlert">
                                <div class="notification-content">
                                    <div class="notification-icon">
                                        <svg width="24" height="24" fill="currentColor" viewBox="0 0 16 16">
                                            <path d="m8.93 6.588-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533L8.93 6.588zM9 4.5a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"/>
                                        </svg>
                                    </div>
                                    <div class="notification-text">
                                        <div class="notification-title">Information</div>
                                        <div class="notification-message">${param.info}</div>
                                    </div>
                                    <button type="button" class="notification-close" onclick="closeNotification('infoAlert')">
                                        <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
                                            <path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8 2.146 2.854Z"/>
                                        </svg>
                                    </button>
                                </div>
                                <div class="notification-progress" id="infoProgress"></div>
                            </div>
                        </div>
                    </c:if>
                    
                    <!-- BEAUTIFUL HEADER SECTION -->
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div>
                            <h1 class="h2 fw-bold text-primary">User Management</h1>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/admindashboard">Dashboard</a></li>
                                    <li class="breadcrumb-item active">Users</li>
                                </ol>
                            </nav>
                        </div>
                        <div class="d-flex gap-2 header-buttons">
                            <c:if test="${currentUser.role.roleName == 'Admin' || currentUser.role.roleName == 'Warehouse Manager'}">
                                <a href="<c:url value='/admin/add'/>" class="btn btn-primary">
                                    <i class="fas fa-user-plus me-1"></i>Add New User
                                </a>
                            </c:if>
                        </div>
                    </div>
                    
                    <!-- FILTER & SEARCH SECTION -->
                    <div class="filter-search-section">
                        <div class="filter-search-header">
                            <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                                <path d="M6 10.5a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 0 1h-3a.5.5 0 0 1-.5-.5zm-2-3a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5zm-2-3a.5.5 0 0 1 .5-.5h11a.5.5 0 0 1 0 1h-11a.5.5 0 0 1-.5-.5z"/>
                            </svg>
                            Filter & Search Options
                        </div>
                        <div class="filter-search-controls">
                            <div class="search-group">
                                <label for="searchUsers">Search Users</label>
                                <div class="search-input">
                                    <input type="text" id="searchUsers" class="form-control" placeholder="Search by name, username, or email..." onkeyup="filterAndSearchUsers()">
                                    <svg class="search-icon" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                                        <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
                                    </svg>
                                </div>
                            </div>
                            <div class="filter-group">
                                <label for="roleFilter">Filter by Role</label>
                                <select id="roleFilter" class="filter-select" onchange="filterAndSearchUsers()">
                                    <option value="">All Roles</option>
                                    <option value="Admin">Admin</option>
                                    <option value="Warehouse Manager">Warehouse Manager</option>
                                    <option value="Sales Staff">Sales Staff</option>
                                    <option value="Warehouse Staff">Warehouse Staff</option>
                                </select>
                            </div>
                            <div class="filter-group">
                                <label for="statusFilter">Filter by Status</label>
                                <select id="statusFilter" class="filter-select" onchange="filterAndSearchUsers()">
                                    <option value="">All Status</option>
                                    <option value="active">Active Only</option>
                                    <option value="inactive">Inactive Only</option>
                                </select>
                            </div>
                            <div class="clear-group">
                                <button type="button" class="clear-filters-btn" onclick="clearFilters()">
                                    <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16">
                                        <path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8 2.146 2.854Z"/>
                                    </svg>
                                    Clear
                                </button>
                            </div>
                        </div>
                        
                        <!-- STATUS SUMMARY -->
                        <div class="status-filter-section">
                            <div class="status-summary">
                                <div class="summary-item">
                                    <span class="status-indicator" style="background: #22c55e;"></span>
                                    <span>Active Users:</span>
                                    <span class="summary-count" id="activeCount">0</span>
                                </div>
                                <div class="summary-item">
                                    <span class="status-indicator" style="background: #94a3b8;"></span>
                                    <span>Inactive Users:</span>
                                    <span class="summary-count" id="inactiveCount">0</span>
                                </div>
                                <div class="summary-item">
                                    <span>Total Users:</span>
                                    <span class="summary-count" id="totalCount">0</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- USERS TABLE -->
                    <div class="row">
                        <div class="col-12">
                            <div class="enhanced-table-container">
                                <div class="table-header">
                                    <h5 class="table-title">
                                        <svg width="18" height="18" fill="currentColor" viewBox="0 0 16 16">
                                            <path d="M7 14s-1 0-1-1 1-4 5-4 5 3 5 4-1 1-1 1H7Zm4-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6Zm-5.784 6A2.238 2.238 0 0 1 5 13c0-1.355.68-2.75 1.936-3.72A6.325 6.325 0 0 0 5 9c-4 0-5 3-5 4s1 1 1 1h4.216ZM4.5 8a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5Z"/>
                                        </svg>
                                        All Users
                                        <span class="badge bg-primary ms-2" id="userCount">
                                            <c:choose>
                                                <c:when test="${not empty users}">
                                                    ${users.size()} users
                                                </c:when>
                                                <c:otherwise>
                                                    0 users
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </h5>
                                    <div class="results-info" id="resultsInfo">
                                        <span id="visibleCount">${users.size()}</span> users displayed
                                    </div>
                                </div>
                                <div class="table-responsive">
                                    <table class="table table-hover my-0" id="usersTable">
                                        <thead>
                                            <tr>
                                                <th class="sortable-header" onclick="sortTable(0)">
                                                    Name
                                                    <svg class="sort-indicator" width="12" height="12" fill="currentColor" viewBox="0 0 16 16">
                                                        <path d="m7.247 4.86-4.796 5.481c-.566.647-.106 1.659.753 1.659h9.592a1 1 0 0 0 .753-1.659l-4.796-5.48a1 1 0 0 0-1.506 0z"/>
                                                    </svg>
                                                </th>
                                                <th class="d-none d-xl-table-cell sortable-header" onclick="sortTable(1)">
                                                    Username
                                                    <svg class="sort-indicator" width="12" height="12" fill="currentColor" viewBox="0 0 16 16">
                                                        <path d="m7.247 4.86-4.796 5.481c-.566.647-.106 1.659.753 1.659h9.592a1 1 0 0 0 .753-1.659l-4.796-5.48a1 1 0 0 0-1.506 0z"/>
                                                    </svg>
                                                </th>
                                                <th class="d-none d-xl-table-cell sortable-header" onclick="sortTable(2)">
                                                    Email
                                                    <svg class="sort-indicator" width="12" height="12" fill="currentColor" viewBox="0 0 16 16">
                                                        <path d="m7.247 4.86-4.796 5.481c-.566.647-.106 1.659.753 1.659h9.592a1 1 0 0 0 .753-1.659l-4.796-5.48a1 1 0 0 0-1.506 0z"/>
                                                    </svg>
                                                </th>
                                                <th class="sortable-header" onclick="sortTable(3)">
                                                    Role
                                                    <svg class="sort-indicator" width="12" height="12" fill="currentColor" viewBox="0 0 16 16">
                                                        <path d="m7.247 4.86-4.796 5.481c-.566.647-.106 1.659.753 1.659h9.592a1 1 0 0 0 .753-1.659l-4.796-5.48a1 1 0 0 0-1.506 0z"/>
                                                    </svg>
                                                </th>
                                                <th class="sortable-header" onclick="sortTable(4)">
                                                    Warehouse
                                                    <svg class="sort-indicator" width="12" height="12" fill="currentColor" viewBox="0 0 16 16">
                                                        <path d="m7.247 4.86-4.796 5.481c-.566.647-.106 1.659.753 1.659h9.592a1 1 0 0 0 .753-1.659l-4.796-5.48a1 1 0 0 0-1.506 0z"/>
                                                    </svg>
                                                </th>
                                                <th class="sortable-header" onclick="sortTable(5)">
                                                    Status
                                                    <svg class="sort-indicator" width="12" height="12" fill="currentColor" viewBox="0 0 16 16">
                                                        <path d="m7.247 4.86-4.796 5.481c-.566.647-.106 1.659.753 1.659h9.592a1 1 0 0 0 .753-1.659l-4.796-5.48a1 1 0 0 0-1.506 0z"/>
                                                    </svg>
                                                </th>
                                                <th class="d-none d-md-table-cell">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody id="usersTableBody">
                                            <c:forEach var="user" items="${users}">
                                                <tr class="user-row ${user.active ? '' : 'inactive'}" 
                                                    data-name="${user.fullName}" 
                                                    data-username="${user.username}" 
                                                    data-email="${user.email}" 
                                                    data-role="${user.role.roleName}"
                                                    data-status="${user.active ? 'active' : 'inactive'}">
                                                    <td>${user.fullName}</td>
                                                    <td class="d-none d-xl-table-cell">${user.username}</td>
                                                    <td class="d-none d-xl-table-cell">${user.email}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${user.role.roleName == 'Admin'}">
                                                                <span class="badge role-admin">${user.role.roleName}</span>
                                                            </c:when>
                                                            <c:when test="${user.role.roleName == 'Warehouse Manager'}">
                                                                <span class="badge role-warehouse-manager">${user.role.roleName}</span>
                                                            </c:when>
                                                            <c:when test="${user.role.roleName == 'Sales Staff'}">
                                                                <span class="badge role-sales-staff">${user.role.roleName}</span>
                                                            </c:when>
                                                            <c:when test="${user.role.roleName == 'Warehouse Staff'}">
                                                                <span class="badge role-warehouse-staff">${user.role.roleName}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary">${user.role.roleName}</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${user.warehouseName != null ? user.warehouseName :'None'}</td>
                                                    <td>
                                                        <span class="status-badge ${user.active ? 'status-active' : 'status-inactive'}">
                                                            <span class="status-indicator"></span>
                                                            ${user.statusText}
                                                        </span>
                                                    </td>
                                                    <td class="d-none d-md-table-cell">
                                                        <!-- View Profile Button (for Admin) -->
                                                        <c:if test="${currentUser.role.roleName == 'Admin'}">
                                                          <a href="${pageContext.request.contextPath}/admin/UserProfile?id=${user.userId}" 
                                                               class="btn-view">
                                                                <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16">
                                                                    <path d="M8 4.754a3.246 3.246 0 1 0 0 6.492 3.246 3.246 0 0 0 0-6.492zM5.754 8a2.246 2.246 0 1 1 4.492 0 2.246 2.246 0 0 1-4.492 0z"/>
                                                                    <path d="M9.796 1.343c-.527-1.79-3.065-1.79-3.592 0l-.094.319a.873.873 0 0 1-1.255.52l-.292-.16c-1.64-.892-3.433.902-2.54 2.541l.159.292a.873.873 0 0 1-.52 1.255l-.319.094c-1.79.527-1.79 3.065 0 3.592l.319.094a.873.873 0 0 1 .52 1.255l-.16.292c-.892 1.64.901 3.434 2.541 2.54l.292-.159a.873.873 0 0 1 1.255.52l.094.319c.527 1.79 3.065 1.79 3.592 0l.094-.319a.873.873 0 0 1 1.255-.52l.292.16c1.64.893 3.434-.902 2.54-2.541l-.159-.292a.873.873 0 0 1 .52-1.255l.319-.094c1.79-.527 1.79-3.065 0-3.592l-.319-.094a.873.873 0 0 1-.52-1.255l.16-.292c.893-1.64-.902-3.433-2.541-2.54l-.292.159a.873.873 0 0 1-1.255-.52l-.094-.319zm-2.633.283c.246-.835 1.428-.835 1.674 0l.094.319a1.873 1.873 0 0 0 2.693 1.115l.291-.16c.764-.415 1.6.42 1.184 1.185l-.159.292a1.873 1.873 0 0 0 1.116 2.692l.318.094c.835.246.835 1.428 0 1.674l-.319.094a1.873 1.873 0 0 0-1.115 2.693l.16.291c.415.764-.42 1.6-1.185 1.184l-.291-.159a1.873 1.873 0 0 0-2.693 1.116l-.094.318c-.246.835-1.428.835-1.674 0l-.094-.319a1.873 1.873 0 0 0-2.692-1.115l-.292.16c-.764.415-1.6-.42-1.184-1.185l.159-.291A1.873 1.873 0 0 0 1.945 8.93l-.319-.094c-.835-.246-.835-1.428 0-1.674l.319-.094A1.873 1.873 0 0 0 3.06 4.377l-.16-.292c-.415-.764.42-1.6 1.185-1.184l.292.159a1.873 1.873 0 0 0 2.692-1.115l.094-.319z"/>
                                                                </svg>
                                                                View
                                                            </a>
                                                        </c:if>
                                                        
                                                        <!-- Status Management Buttons -->
                                                        <c:choose>
                                                            <c:when test="${currentUser.role.roleName == 'Admin'}">
                                                                <c:if test="${user.userId != currentUser.userId}">
                                                                    <c:choose>
                                                                        <c:when test="${user.active}">
                                                                            <a href="${pageContext.request.contextPath}/admin/user-deactivate?id=${user.userId}" 
                                                                               class="btn-deactivate"
                                                                               onclick="return confirm('Are you sure you want to deactivate user: ${user.fullName}?')">
                                                                                <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16">
                                                                                    <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/>
                                                                                    <path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>
                                                                                </svg>
                                                                                Deactivate
                                                                            </a>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <a href="${pageContext.request.contextPath}/admin/user-activate?id=${user.userId}" 
                                                                               class="btn-activate"
                                                                               onclick="return confirm('Are you sure you want to activate user: ${user.fullName}?')">
                                                                                <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16">
                                                                                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                                                                                    <path d="M10.97 4.97a.235.235 0 0 0-.02.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.061L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05z"/>
                                                                                </svg>
                                                                                Activate
                                                                            </a>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:if>
                                                            </c:when>
                                                            <c:when test="${currentUser.role.roleName == 'Warehouse Manager' && user.role.roleName != 'Admin'}">
                                                                <c:if test="${user.userId != currentUser.userId}">
                                                                    <c:choose>
                                                                        <c:when test="${user.active}">
                                                                            <a href="${pageContext.request.contextPath}/user-deactivate?id=${user.userId}" 
                                                                               class="btn-deactivate"
                                                                               onclick="return confirm('Are you sure you want to deactivate user: ${user.fullName}?')">
                                                                                <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16">
                                                                                    <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/>
                                                                                    <path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>
                                                                                </svg>
                                                                                Deactivate
                                                                            </a>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <a href="${pageContext.request.contextPath}/user-activate?id=${user.userId}" 
                                                                               class="btn-activate"
                                                                               onclick="return confirm('Are you sure you want to activate user: ${user.fullName}?')">
                                                                                <svg width="12" height="12" fill="currentColor" viewBox="0 0 16 16">
                                                                                    <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
                                                                                    <path d="M10.97 4.97a.235.235 0 0 0-.02.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.061L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-1.071-1.05z"/>
                                                                                </svg>
                                                                                Activate
                                                                            </a>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:if>
                                                            </c:when>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                    <!-- NO RESULTS MESSAGE -->
                                    <div id="noResults" class="no-results" style="display: none;">
                                        <svg class="no-results-icon" fill="currentColor" viewBox="0 0 16 16">
                                            <path d="M7 14s-1 0-1-1 1-4 5-4 5 3 5 4-1 1-1 1H7Zm4-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6Zm-5.784 6A2.238 2.238 0 0 1 5 13c0-1.355.68-2.75 1.936-3.72A6.325 6.325 0 0 0 5 9c-4 0-5 3-5 4s1 1 1 1h4.216ZM4.5 8a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5Z"/>
                                        </svg>
                                        <h4>No users found</h4>
                                        <p>Try adjusting your search criteria or clearing the filters</p>
                                    </div>
                                </div>
                                
                                <!-- ============ COMPACT PAGINATION LAYOUT ============ -->
                                <div class="pagination-wrapper mt-2 pt-2 border-top">
                                    <div class="pagination-top-row">
                                        <div class="page-size-control">
                                            <span>Show:</span>
                                            <select class="form-select" id="pageSize">
                                                <option value="10">10</option>
                                                <option value="20">20</option>
                                                <option value="50">50</option>
                                                <option value="100">100</option>
                                            </select>
                                            <span>users per page</span>
                                        </div>
                                        <div class="page-info-display">
                                            <span id="pageInfo"></span>
                                        </div>
                                    </div>
                                    <div class="pagination-nav-row">
                                        <nav aria-label="User pagination">
                                            <ul class="pagination pagination-sm mb-0" id="pagination">
                                                <!-- Pagination buttons will be generated by JavaScript -->
                                            </ul>
                                        </nav>
                                    </div>
                                </div>
                                <!-- ============ END PAGINATION ============ -->
                            </div>
                        </div>
                    </div>
                </div>
            </main>
           <jsp:include page="/admin/footer.jsp" />
        </div>
    </div>

    <!-- SCRIPTS -->
    <script src="${pageContext.request.contextPath}/admin/js/app.js"></script>
    
    <script>
    // ============ PAGINATION VARIABLES EXACTLY LIKE SALE-ORDER-LIST ============
    let currentPage = 1;
    let pageSize = 10;
    let allRows = [];
    let filteredRows = [];

    // ENHANCED NOTIFICATION SYSTEM
    function closeNotification(alertId) {
        const alert = document.getElementById(alertId);
        if (alert) {
            alert.classList.add('slide-out');
            setTimeout(() => {
                const container = alert.closest('.notification-container');
                if (container && container.parentNode) {
                    container.parentNode.removeChild(container);
                }
            }, 400);
        }
    }
    
    function autoHideNotification(alertId, duration = 6000) {
        setTimeout(() => {
            closeNotification(alertId);
        }, duration);
    }
    
    // Auto-hide notifications when page loads
    document.addEventListener('DOMContentLoaded', function() {
        // Handle success notifications (6 seconds)
        const successAlert = document.getElementById('successAlert');
        if (successAlert) {
            autoHideNotification('successAlert', 6000);
        }
        
        // Handle error notifications (8 seconds)
        const errorAlert = document.getElementById('errorAlert');
        if (errorAlert) {
            autoHideNotification('errorAlert', 8000);
        }
        
        // Handle info notifications (7 seconds)
        const infoAlert = document.getElementById('infoAlert');
        if (infoAlert) {
            autoHideNotification('infoAlert', 7000);
        }
        
        // Add hover pause functionality
        document.querySelectorAll('.notification-alert').forEach(alert => {
            const progressBar = alert.querySelector('.notification-progress');
            
            alert.addEventListener('mouseenter', () => {
                if (progressBar) {
                    progressBar.style.animationPlayState = 'paused';
                }
            });
            
            alert.addEventListener('mouseleave', () => {
                if (progressBar) {
                    progressBar.style.animationPlayState = 'running';
                }
            });
        });
        
        // Initialize pagination and status counts
        initializePagination();
        updateStatusCounts();
    });

    // ============ PAGINATION FUNCTIONS EXACTLY LIKE SALE-ORDER-LIST ============
    function initializePagination() {
        setTimeout(function() {
            const tableBody = document.querySelector('#usersTable tbody');
            if (tableBody) {
                allRows = Array.from(tableBody.querySelectorAll('tr'));
                filteredRows = [...allRows];
                
                const pageSizeSelect = document.getElementById('pageSize');
                if (pageSizeSelect) {
                    pageSizeSelect.addEventListener('change', function() {
                        pageSize = parseInt(this.value);
                        currentPage = 1;
                        updatePagination();
                    });
                }
                
                updatePagination();
            } else {
                setTimeout(initializePagination, 100);
            }
        }, 100);
    }

    function updatePagination() {
        const totalItems = filteredRows.length;
        const totalPages = Math.ceil(totalItems / pageSize);
        const startIndex = (currentPage - 1) * pageSize;
        const endIndex = startIndex + pageSize;
        
        allRows.forEach(row => {
            row.style.display = 'none';
        });
        
        const currentPageRows = filteredRows.slice(startIndex, endIndex);
        currentPageRows.forEach(row => {
            row.style.display = '';
        });
        
        const userCountEl = document.getElementById('userCount');
        if (userCountEl) {
            userCountEl.textContent = totalItems + ' users';
        }
        
        const pageInfoElement = document.getElementById('pageInfo');
        if (pageInfoElement) {
            if (totalItems === 0) {
                pageInfoElement.textContent = 'No users found';
            } else {
                const displayStart = startIndex + 1;
                const displayEnd = Math.min(endIndex, totalItems);
                pageInfoElement.textContent = `Showing ${displayStart}–${displayEnd} of ${totalItems} users`;
            }
        }
        
        generatePaginationButtons(totalPages);
        updateStatusCounts();
    }

    function generatePaginationButtons(totalPages) {
        const paginationElement = document.getElementById('pagination');
        if (!paginationElement) return;
        
        paginationElement.innerHTML = '';
        
        if (totalPages <= 1) {
            return;
        }
        
        const prevLi = document.createElement('li');
        prevLi.className = currentPage === 1 ? 'page-item disabled' : 'page-item';
        const prevA = document.createElement('a');
        prevA.className = 'page-link';
        prevA.href = '#';
        prevA.innerHTML = '&laquo;';
        if (currentPage > 1) {
            prevA.onclick = function(e) {
                e.preventDefault();
                currentPage--;
                updatePagination();
            };
        }
        prevLi.appendChild(prevA);
        paginationElement.appendChild(prevLi);
        
        const maxPages = Math.min(totalPages, 10);
        for (let i = 1; i <= maxPages; i++) {
            const pageLi = document.createElement('li');
            pageLi.className = i === currentPage ? 'page-item active' : 'page-item';
            
            const pageA = document.createElement('a');
            pageA.className = 'page-link';
            pageA.href = '#';
            pageA.textContent = i;
            pageA.onclick = function(e) {
                e.preventDefault();
                currentPage = i;
                updatePagination();
            };
            
            pageLi.appendChild(pageA);
            paginationElement.appendChild(pageLi);
        }
        
        if (totalPages > 10) {
            const ellipsisLi = document.createElement('li');
            ellipsisLi.className = 'page-item disabled';
            const ellipsisSpan = document.createElement('span');
            ellipsisSpan.className = 'page-link';
            ellipsisSpan.textContent = '...';
            ellipsisLi.appendChild(ellipsisSpan);
            paginationElement.appendChild(ellipsisLi);
        }
        
        const nextLi = document.createElement('li');
        nextLi.className = currentPage === totalPages ? 'page-item disabled' : 'page-item';
        const nextA = document.createElement('a');
        nextA.className = 'page-link';
        nextA.href = '#';
        nextA.innerHTML = '&raquo;';
        if (currentPage < totalPages) {
            nextA.onclick = function(e) {
                e.preventDefault();
                currentPage++;
                updatePagination();
            };
        }
        nextLi.appendChild(nextA);
        paginationElement.appendChild(nextLi);
    }

    // ============ FILTER, SEARCH AND SORT FUNCTIONALITY - UPDATED FOR PAGINATION ============
    let sortDirection = 'asc';
    let currentSortColumn = -1;

    // Update status counts in summary
    function updateStatusCounts() {
        let activeCount = 0;
        let inactiveCount = 0;
        
        filteredRows.forEach(row => {
            const status = row.getAttribute('data-status');
            if (status === 'active') {
                activeCount++;
            } else if (status === 'inactive') {
                inactiveCount++;
            }
        });
        
        document.getElementById('activeCount').textContent = activeCount;
        document.getElementById('inactiveCount').textContent = inactiveCount;
        document.getElementById('totalCount').textContent = allRows.length;
        
        // Update visible count in header
        document.getElementById('visibleCount').textContent = filteredRows.length;
    }

    // Enhanced Filter and Search Users - Updated for pagination
    function filterAndSearchUsers() {
        const searchTerm = document.getElementById('searchUsers').value.toLowerCase();
        const roleFilter = document.getElementById('roleFilter').value;
        const statusFilter = document.getElementById('statusFilter').value;

        // Filter users
        filteredRows = allRows.filter(row => {
            const name = row.getAttribute('data-name').toLowerCase();
            const username = row.getAttribute('data-username').toLowerCase();
            const email = row.getAttribute('data-email').toLowerCase();
            const role = row.getAttribute('data-role');
            const status = row.getAttribute('data-status');

            // Check search criteria
            const matchesSearch = name.includes(searchTerm) || 
                                username.includes(searchTerm) || 
                                email.includes(searchTerm);

            // Check role filter
            const matchesRole = roleFilter === '' || role === roleFilter;
            
            // Check status filter
            const matchesStatus = statusFilter === '' || status === statusFilter;

            return matchesSearch && matchesRole && matchesStatus;
        });

        // Reset pagination after filter
        currentPage = 1;
        updatePagination();
        
        // Show/hide no results message
        const noResults = document.getElementById('noResults');
        const table = document.getElementById('usersTable');
        
        if (filteredRows.length === 0) {
            if (table) table.style.display = 'none';
            if (noResults) noResults.style.display = 'block';
        } else {
            if (table) table.style.display = 'table';
            if (noResults) noResults.style.display = 'none';
        }
    }

    // Clear all filters - Updated for pagination
    function clearFilters() {
        document.getElementById('searchUsers').value = '';
        document.getElementById('roleFilter').value = '';
        document.getElementById('statusFilter').value = '';
        
        // Reset filtered users to all users
        filteredRows = [...allRows];
        currentPage = 1;
        updatePagination();
        
        // Show table and hide no results
        const noResults = document.getElementById('noResults');
        const table = document.getElementById('usersTable');
        if (table) table.style.display = 'table';
        if (noResults) noResults.style.display = 'none';
    }

    // Sort table by column - Updated for pagination
    function sortTable(columnIndex) {
        // Clear previous sort indicators
        document.querySelectorAll('.sortable-header').forEach(header => {
            header.classList.remove('sort-asc', 'sort-desc');
        });

        // Determine sort direction
        if (currentSortColumn === columnIndex) {
            sortDirection = sortDirection === 'asc' ? 'desc' : 'asc';
        } else {
            sortDirection = 'asc';
            currentSortColumn = columnIndex;
        }

        // Add sort indicator to current column
        const currentHeader = document.querySelectorAll('.sortable-header')[columnIndex];
        currentHeader.classList.add(sortDirection === 'asc' ? 'sort-asc' : 'sort-desc');

        // Sort filtered users
        filteredRows.sort((a, b) => {
            let aValue, bValue;

            switch(columnIndex) {
                case 0: // Name
                    aValue = a.getAttribute('data-name').toLowerCase();
                    bValue = b.getAttribute('data-name').toLowerCase();
                    break;
                case 1: // Username
                    aValue = a.getAttribute('data-username').toLowerCase();
                    bValue = b.getAttribute('data-username').toLowerCase();
                    break;
                case 2: // Email
                    aValue = a.getAttribute('data-email').toLowerCase();
                    bValue = b.getAttribute('data-email').toLowerCase();
                    break;
                case 3: // Role
                    aValue = a.getAttribute('data-role').toLowerCase();
                    bValue = b.getAttribute('data-role').toLowerCase();
                    break;
                case 4: // Warehouse
                    aValue = a.cells[4].textContent.toLowerCase();
                    bValue = b.cells[4].textContent.toLowerCase();
                    break;
                case 5: // Status
                    aValue = a.getAttribute('data-status').toLowerCase();
                    bValue = b.getAttribute('data-status').toLowerCase();
                    break;
            }

            if (aValue < bValue) return sortDirection === 'asc' ? -1 : 1;
            if (aValue > bValue) return sortDirection === 'asc' ? 1 : -1;
            return 0;
        });

        // Reset to first page after sort and refresh display
        currentPage = 1;
        updatePagination();
    }

    // Initialize on page load
    document.addEventListener('DOMContentLoaded', function() {
        // Setup search input event listener
        document.getElementById('searchUsers').addEventListener('input', filterAndSearchUsers);
        
        // Setup filter event listeners
        document.getElementById('roleFilter').addEventListener('change', filterAndSearchUsers);
        document.getElementById('statusFilter').addEventListener('change', filterAndSearchUsers);
    });
    </script>
</body>
</html>