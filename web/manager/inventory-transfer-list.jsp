<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List,model.InventoryTransfer" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="description" content="Responsive Admin &amp; Dashboard Template based on Bootstrap 5">
        <meta name="author" content="AdminKit">
        <meta name="keywords" content="adminkit, bootstrap, bootstrap 5, admin, dashboard, template, responsive, css, sass, html, theme, front-end, ui kit, web">
        <link rel="preconnect" href="https://fonts.gstatic.com">
        <link rel="shortcut icon" href="<c:url value='/manager/img/icons/icon-48x48.png'/>" />
        <link rel="canonical" href="forms-layouts.html" />
        <title>Inventory Transfers | Warehouse System</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link class="js-stylesheet" href="<c:url value='/manager/css/light.css'/>" rel="stylesheet">
        <script src="<c:url value='/manager/js/settings.js'/>"></script>
        <style>
            /* Modern Premium Design */
            * {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            }
            
            .content {
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                min-height: 100vh;
                position: relative;
            }
            
            .content::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: 
                    radial-gradient(circle at 20% 20%, rgba(102, 126, 234, 0.1) 0%, transparent 50%),
                    radial-gradient(circle at 80% 80%, rgba(118, 75, 162, 0.1) 0%, transparent 50%);
                pointer-events: none;
            }
            
            .container-fluid {
                position: relative;
                z-index: 1;
            }
            
            .page-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2.5rem;
                padding: 2rem;
                background: white;
                border-radius: 20px;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
                border: 1px solid rgba(255, 255, 255, 0.8);
            }
            
            .page-header h1 {
                font-size: 2.25rem;
                font-weight: 800;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                margin: 0;
                display: flex;
                align-items: center;
                gap: 1rem;
                letter-spacing: -0.5px;
            }
            
            .page-header h1 i {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                font-size: 2rem;
            }
            
            .page-header .btn-primary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border: none;
                padding: 0.75rem 1.5rem;
                border-radius: 12px;
                font-weight: 600;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
                transition: all 0.3s ease;
            }
            
            .page-header .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.5);
            }
            
            .stats-cards {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                gap: 1.5rem;
                margin-bottom: 2.5rem;
            }
            
            .stat-card {
                background: white;
                border-radius: 20px;
                padding: 2rem;
                box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
                border: none;
                transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                position: relative;
                overflow: hidden;
            }
            
            .stat-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
                transform: scaleX(0);
                transition: transform 0.3s ease;
            }
            
            .stat-card:hover {
                transform: translateY(-8px) scale(1.02);
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
            }
            
            .stat-card:hover::before {
                transform: scaleX(1);
            }
            
            .stat-card-icon {
                width: 64px;
                height: 64px;
                border-radius: 16px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.75rem;
                margin-bottom: 1.25rem;
                position: relative;
                transition: all 0.3s ease;
            }
            
            .stat-card:hover .stat-card-icon {
                transform: scale(1.1) rotate(5deg);
            }
            
            .stat-card-icon.primary { 
                background: linear-gradient(135deg, #eef2ff 0%, #ddd6fe 100%);
                color: #667eea;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            }
            .stat-card-icon.success { 
                background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
                color: #10b981;
                box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
            }
            .stat-card-icon.warning { 
                background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
                color: #f59e0b;
                box-shadow: 0 4px 15px rgba(245, 158, 11, 0.3);
            }
            .stat-card-icon.info { 
                background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
                color: #3b82f6;
                box-shadow: 0 4px 15px rgba(59, 130, 246, 0.3);
            }
            
            .stat-card-value {
                font-size: 2.5rem;
                font-weight: 800;
                background: linear-gradient(135deg, #1f2937 0%, #4b5563 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                margin: 0.75rem 0;
                line-height: 1;
            }
            
            .stat-card-label {
                font-size: 0.9rem;
                color: #6b7280;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            
            .card {
                border: none;
                border-radius: 24px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                background: white;
                backdrop-filter: blur(10px);
            }
            
            .card-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                padding: 2rem;
                position: relative;
                overflow: hidden;
            }
            
            .card-header::before {
                content: '';
                position: absolute;
                top: -50%;
                right: -50%;
                width: 200%;
                height: 200%;
                background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
                animation: rotate 20s linear infinite;
            }
            
            @keyframes rotate {
                from { transform: rotate(0deg); }
                to { transform: rotate(360deg); }
            }
            
            .card-header h5 {
                color: white;
                font-weight: 700;
                margin: 0;
                font-size: 1.5rem;
                position: relative;
                z-index: 1;
            }
            
            .card-header .btn-primary {
                background: rgba(255, 255, 255, 0.25);
                backdrop-filter: blur(10px);
                border: 2px solid rgba(255, 255, 255, 0.3);
                color: white;
                padding: 0.625rem 1.5rem;
                border-radius: 12px;
                font-weight: 600;
                transition: all 0.3s ease;
                position: relative;
                z-index: 1;
            }
            
            .card-header .btn-primary:hover {
                background: white;
                color: #667eea;
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
            }
            
            .filter-section {
                background: white;
                padding: 2rem;
                border-radius: 20px;
                margin-bottom: 2rem;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                border: 1px solid rgba(255, 255, 255, 0.8);
            }
            
            .filter-section label {
                font-weight: 700;
                color: #1f2937;
                font-size: 1rem;
                margin-bottom: 1rem;
                display: block;
            }
            
            .form-select {
                border-radius: 12px;
                border: 2px solid #e5e7eb;
                padding: 0.75rem 1.25rem;
                font-size: 0.95rem;
                font-weight: 500;
                transition: all 0.3s ease;
                background: #f9fafb;
            }
            
            .form-select:focus {
                border-color: #667eea;
                background: white;
                box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.15);
                outline: none;
            }
            
            .btn-outline-secondary {
                border-radius: 12px;
                border: 2px solid #e5e7eb;
                padding: 0.75rem 1.25rem;
                transition: all 0.3s ease;
                font-weight: 600;
                background: white;
            }
            
            .btn-outline-secondary:hover {
                background: #f3f4f6;
                border-color: #667eea;
                color: #667eea;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            }
            
            .table-responsive {
                border-radius: 20px;
                overflow: hidden;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            }
            
            .table {
                margin: 0;
                background: white;
            }
            
            .table thead {
                background: linear-gradient(135deg, #f9fafb 0%, #f3f4f6 100%);
            }
            
            .table thead th {
                font-weight: 700;
                font-size: 0.8rem;
                text-transform: uppercase;
                letter-spacing: 1px;
                color: #374151;
                padding: 1.25rem 1rem;
                border-bottom: 3px solid #e5e7eb;
                position: relative;
            }
            
            .table thead th::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 0;
                right: 0;
                height: 3px;
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
                transform: scaleX(0);
                transition: transform 0.3s ease;
            }
            
            .table thead:hover th::after {
                transform: scaleX(1);
            }
            
            .table tbody tr {
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                border-bottom: 1px solid #f3f4f6;
                position: relative;
            }
            
            .table tbody tr::before {
                content: '';
                position: absolute;
                left: 0;
                top: 0;
                bottom: 0;
                width: 4px;
                background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
                transform: scaleY(0);
                transition: transform 0.3s ease;
            }
            
            .table tbody tr:hover {
                background: linear-gradient(90deg, #f9fafb 0%, #ffffff 100%);
                transform: translateX(4px);
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            }
            
            .table tbody tr:hover::before {
                transform: scaleY(1);
            }
            
            .table tbody td {
                padding: 1.25rem 1rem;
                vertical-align: middle;
                color: #4b5563;
                font-size: 0.95rem;
                font-weight: 500;
            }
            
            .badge {
                padding: 0.625rem 1rem;
                border-radius: 10px;
                font-weight: 700;
                font-size: 0.75rem;
                text-transform: uppercase;
                letter-spacing: 0.8px;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
            }
            
            .badge:hover {
                transform: scale(1.05);
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            }
            
            .badge.bg-secondary { 
                background: linear-gradient(135deg, #e5e7eb 0%, #d1d5db 100%) !important; 
                color: #374151 !important; 
            }
            .badge.bg-warning { 
                background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%) !important; 
                color: #92400e !important; 
            }
            .badge.bg-info { 
                background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%) !important; 
                color: #1e40af !important; 
            }
            .badge.bg-success { 
                background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%) !important; 
                color: #065f46 !important; 
            }
            .badge.bg-danger { 
                background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%) !important; 
                color: #991b1b !important; 
            }
            .badge.bg-primary { 
                background: linear-gradient(135deg, #eef2ff 0%, #ddd6fe 100%) !important; 
                color: #3730a3 !important; 
            }
            
            .btn-group .btn {
                border-radius: 8px;
                padding: 0.5rem 0.75rem;
                margin: 0 0.25rem;
                transition: all 0.3s;
            }
            
            .btn-outline-primary {
                border: 2px solid #667eea;
                color: #667eea;
            }
            
            .btn-outline-primary:hover {
                background: #667eea;
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
            }
            
            .btn-outline-danger {
                border: 2px solid #ef4444;
                color: #ef4444;
            }
            
            .btn-outline-danger:hover {
                background: #ef4444;
                color: white;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
            }
            
            .empty-state {
                text-align: center;
                padding: 5rem 2rem;
                color: #9ca3af;
                background: linear-gradient(135deg, #f9fafb 0%, #f3f4f6 100%);
                border-radius: 20px;
            }
            
            .empty-state i {
                font-size: 5rem;
                margin-bottom: 1.5rem;
                background: linear-gradient(135deg, #d1d5db 0%, #9ca3af 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                display: block;
            }
            
            .empty-state p {
                font-size: 1.25rem;
                margin: 0 0 1.5rem 0;
                font-weight: 600;
                color: #6b7280;
            }
            
            .empty-state .btn-primary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border: none;
                padding: 0.75rem 2rem;
                border-radius: 12px;
                font-weight: 600;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            }
            
            .alert {
                border-radius: 16px;
                border: none;
                padding: 1.25rem 1.75rem;
                margin-bottom: 2rem;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 0.75rem;
            }
            
            .alert-success {
                background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
                color: #065f46;
                border-left: 4px solid #10b981;
            }
            
            .alert-danger {
                background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
                color: #991b1b;
                border-left: 4px solid #ef4444;
            }
            
            @media (max-width: 768px) {
                .stats-cards {
                    grid-template-columns: 1fr;
                }
                
                .page-header {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 1rem;
                }
            }
        </style>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <jsp:include page="/manager/ManagerSidebar.jsp" />
            <div class="main">
                <jsp:include page="/manager/navbar.jsp" />               
                <main class="content">                    
                    <div class="container-fluid p-0">
                        <div class="page-header">
                            <h1>
                                <i class="fas fa-exchange-alt"></i>
                                Inventory Transfers
                            </h1>
                            <a href="create-inventory-transfer" class="btn btn-primary">
                                <i class="fas fa-plus"></i> New Transfer
                            </a>
                        </div>
                        
                        <!-- Statistics Cards -->
                        <div class="stats-cards">
                            <div class="stat-card">
                                <div class="stat-card-icon primary">
                                    <i class="fas fa-list"></i>
                                </div>
                                <div class="stat-card-value">${not empty transfers ? transfers.size() : 0}</div>
                                <div class="stat-card-label">Total Transfers</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-card-icon success">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="stat-card-value">
                                    <c:set var="completedCount" value="0" />
                                    <c:forEach var="t" items="${transfers}">
                                        <c:if test="${t.status == 'completed' || t.status == 'complete'}">
                                            <c:set var="completedCount" value="${completedCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${completedCount}
                                </div>
                                <div class="stat-card-label">Completed</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-card-icon warning">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <div class="stat-card-value">
                                    <c:set var="pendingCount" value="0" />
                                    <c:forEach var="t" items="${transfers}">
                                        <c:if test="${t.status == 'pending' || t.status == 'processing'}">
                                            <c:set var="pendingCount" value="${pendingCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${pendingCount}
                                </div>
                                <div class="stat-card-label">In Progress</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-card-icon info">
                                    <i class="fas fa-file-alt"></i>
                                </div>
                                <div class="stat-card-value">
                                    <c:set var="draftCount" value="0" />
                                    <c:forEach var="t" items="${transfers}">
                                        <c:if test="${t.status == 'draft'}">
                                            <c:set var="draftCount" value="${draftCount + 1}" />
                                        </c:if>
                                    </c:forEach>
                                    ${draftCount}
                                </div>
                                <div class="stat-card-label">Draft</div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-header">
                                        <div class="row align-items-center">
                                            <div class="col-md-6">
                                                <h5 class="card-title mb-0">
                                                    <i class="fas fa-tasks"></i> Transfer Management
                                                </h5>
                                            </div>
                                            <div class="col-md-6 text-end">
                                                <a href="create-inventory-transfer" class="btn btn-primary">
                                                    <i class="fas fa-plus"></i> New Transfer
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <!-- Success and Error Messages -->
                                        <c:if test="${not empty successMessage}">
                                            <div class="alert alert-success alert-dismissible" role="alert">
                                                <div class="alert-message">
                                                    ${successMessage}
                                                </div>
                                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            </div>
                                        </c:if>

                                        <c:if test="${not empty errorMessage}">
                                            <div class="alert alert-danger alert-dismissible" role="alert">
                                                <div class="alert-message">
                                                    ${errorMessage}
                                                </div>
                                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                            </div>
                                        </c:if>

                                        <!-- Filter Section -->
                                        <div class="filter-section">
                                            <div class="row align-items-center">
                                                <div class="col-md-6">
                                                    <label class="form-label fw-bold mb-2">
                                                        <i class="fas fa-filter"></i> Filter by Status
                                                    </label>
                                                    <form method="get" action="list-inventory-transfer" class="d-flex gap-2">
                                                        <select class="form-select flex-grow-1" name="status" onchange="this.form.submit()">
                                                            <option value="all" ${statusFilter == 'all' || empty statusFilter ? 'selected' : ''}>
                                                                <i class="fas fa-list"></i> All Status
                                                            </option>
                                                            <option value="draft" ${statusFilter == 'draft' ? 'selected' : ''}>📝 Draft</option>
                                                            <option value="pending" ${statusFilter == 'pending' ? 'selected' : ''}>⏳ Pending</option>
                                                            <option value="processing" ${statusFilter == 'processing' ? 'selected' : ''}>⚙️ Processing</option>
                                                            <option value="completed" ${statusFilter == 'completed' ? 'selected' : ''}>✅ Completed</option>
                                                            <option value="rejected" ${statusFilter == 'rejected' ? 'selected' : ''}>❌ Rejected</option>
                                                        </select>
                                                        <button class="btn btn-outline-secondary" type="button" onclick="resetFilter()">
                                                            <i class="fas fa-redo"></i> Reset
                                                        </button>
                                                    </form>
                                                </div>
                                                <div class="col-md-6 text-end">
                                                    <span class="text-muted">
                                                        <i class="fas fa-info-circle"></i> Showing ${not empty transfers ? transfers.size() : 0} transfer(s)
                                                    </span>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Transfer Orders Table -->
                                        <div class="table-responsive">
                                            <table class="table table-striped table-hover">
                                                <thead>
                                                    <tr>
                                                        <th>ID</th>
                                                        <th>Source Warehouse</th>
                                                        <th>Destination Warehouse</th>
                                                        <th>Date</th>
                                                        <th>Status</th>
                                                        <th>Created By</th>
                                                        <th>Actions</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:choose>
                                                        <c:when test="${empty transfers}">
                                                            <tr>
                                                                <td colspan="7" class="empty-state">
                                                                    <i class="fas fa-inbox"></i>
                                                                    <p class="mt-3">No inventory transfers found.</p>
                                                                    <a href="create-inventory-transfer" class="btn btn-primary mt-3">
                                                                        <i class="fas fa-plus"></i> Create First Transfer
                                                                    </a>
                                                                </td>
                                                            </tr>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:forEach var="transfer" items="${transfers}">
                                                                <tr>
                                                                    <td>IT-${String.format("%03d", transfer.transferId)}</td>
                                                                    <td>${transfer.sourceWarehouseName}</td>
                                                                    <td>${transfer.destinationWarehouseName}</td>
                                                                    <td>${transfer.date.toLocalDate()}</td>
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when test="${transfer.status == 'draft'}">
                                                                                <span class="badge bg-secondary">
                                                                                    <i class="fas fa-file-alt"></i> Draft
                                                                                </span>
                                                                            </c:when>
                                                                            <c:when test="${transfer.status == 'pending'}">
                                                                                <span class="badge bg-warning">
                                                                                    <i class="fas fa-clock"></i> Pending
                                                                                </span>
                                                                            </c:when>
                                                                            <c:when test="${transfer.status == 'processing'}">
                                                                                <span class="badge bg-info">
                                                                                    <i class="fas fa-cog fa-spin"></i> Processing
                                                                                </span>
                                                                            </c:when>
                                                                            <c:when test="${transfer.status == 'complete' || transfer.status == 'completed'}">
                                                                                <span class="badge bg-success">
                                                                                    <i class="fas fa-check-circle"></i> Completed
                                                                                </span>
                                                                            </c:when>
                                                                            <c:when test="${transfer.status == 'rejected'}">
                                                                                <span class="badge bg-danger">
                                                                                    <i class="fas fa-times-circle"></i> Rejected
                                                                                </span>
                                                                            </c:when>
                                                                            <c:when test="${transfer.status == 'delivery'}">
                                                                                <span class="badge bg-primary">
                                                                                    <i class="fas fa-truck"></i> Delivery
                                                                                </span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <span class="badge bg-light text-dark">
                                                                                    <i class="fas fa-circle"></i> ${transfer.status}
                                                                                </span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                    <td>${transfer.creatorName}</td>
                                                                    <td>
                                                                        <div class="btn-group" role="group">
                                                                            <a href="view-inventory-transfer?id=${transfer.transferId}" 
                                                                               class="btn btn-sm btn-outline-primary" 
                                                                               title="View Details">
                                                                                <i class="fas fa-eye"></i> View
                                                                            </a>
                                                                            <c:if test="${transfer.status == 'draft'}">
                                                                                <button type="button" 
                                                                                        class="btn btn-sm btn-outline-danger" 
                                                                                        title="Delete" 
                                                                                        onclick="deleteTransfer(${transfer.transferId})">
                                                                                    <i class="fas fa-trash-alt"></i>
                                                                                </button>
                                                                            </c:if>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                <jsp:include page="/manager/footer.jsp" />
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteModalLabel">Confirm Delete</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to delete this inventory transfer? This action cannot be undone.
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <form id="deleteForm" method="post" action="view-inventory-transfer" style="display: inline;">
                            <input type="hidden" name="transferId" id="deleteTransferId">
                            <input type="hidden" name="action" value="delete">
                            <button type="submit" class="btn btn-danger">Delete</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="<c:url value='/manager/js/app.js'/>"></script>
        <script>
            function resetFilter() {
                window.location.href = 'list-inventory-transfer';
            }

            function deleteTransfer(transferId) {
                document.getElementById('deleteTransferId').value = transferId;
                const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
                deleteModal.show();
            }
            
            // Initialize tooltips if using Bootstrap 5
            document.addEventListener('DOMContentLoaded', function() {
                // Add any additional initialization here
                console.log('Inventory Transfer List page loaded');
            });
        </script>
    </body>
</html>
