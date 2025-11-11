<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/img/icons/icon-48x48.png" />
    <title>Dashboard - AdminKit</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/light.css" rel="stylesheet">
    <link rel="stylesheet" href="css/styles.css">
    <style>
        body { opacity: 1 !important; }
        /* CSS cho dashboard */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr); /* 2 cột */
            grid-auto-rows: 200px; /* Chiều cao cố định */
            grid-gap: 20px;
            padding: 20px;
        }
        .dashboard-tile {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            overflow: hidden;
        }
        .quick-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }
        .quick-actions .btn {
            flex: 1 1 100%;
            max-width: 100%;
            padding: 10px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="wrapper">
        <jsp:include page="../components/sidebar_loader.jsp"/>
        <div class="main">
            <jsp:include page="components/navbar.jsp" />
            <main class="content">
                <div class="container-fluid p-0">
                    <div class="row mb-2 mb-xl-3">
                        <div class="col-auto d-none d-sm-block">
                            <h3><strong>Analytics</strong> Dashboard</h3>
                        </div>
                        <div class="col-auto ms-auto text-end mt-n1">
                           
                            <c:if test="${sessionScope.user.role.roleName == 'Admin' || sessionScope.user.role.roleName == 'Warehouse Manager'}">
                                <a href="${pageContext.request.contextPath}/user/add" class="btn btn-primary">New User</a>
                            </c:if>
                        </div>
                    </div>
                    <div class="dashboard-grid">
                        <div class="dashboard-tile">
                            <div class="card">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col mt-0">
                                            <h5 class="card-title">Total Users</h5>
                                        </div>
                                        <div class="col-auto">
                                            <div class="stat text-primary">
                                                <i class="align-middle" data-feather="users"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <h1 class="mt-1 mb-3">${userCount}</h1>
                                    <div class="mb-0">
                                        <span class="badge badge-success-light">
                                            <i class="mdi mdi-arrow-bottom-right"></i> Active
                                        </span>
                                        <span class="text-muted">System users</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="dashboard-tile">
                            <div class="card">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col mt-0">
                                            <h5 class="card-title">Your Role</h5>
                                        </div>
                                        <div class="col-auto">
                                            <div class="stat text-primary">
                                                <i class="align-middle" data-feather="user"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <h1 class="mt-1 mb-3">${sessionScope.user.role.roleName}</h1>
                                    <div class="mb-0">
                                        <span class="badge badge-primary-light">
                                            <i class="mdi mdi-arrow-bottom-right"></i> Access Level
                                        </span>
                                        <span class="text-muted">Current permissions</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="dashboard-tile">
                            <div class="card">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col mt-0">
                                            <h5 class="card-title">Welcome</h5>
                                        </div>
                                        <div class="col-auto">
                                            <div class="stat text-primary">
                                                <i class="align-middle" data-feather="user-check"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <h1 class="mt-1 mb-3">${sessionScope.user.firstName}</h1>
                                    <div class="mb-0">
                                        <span class="badge badge-success-light">
                                            <i class="mdi mdi-arrow-bottom-right"></i> Logged In
                                        </span>
                                        <span class="text-muted">Welcome back</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="dashboard-tile">
                            <div class="card">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col mt-0">
                                            <h5 class="card-title">Status</h5>
                                        </div>
                                        <div class="col-auto">
                                            <div class="stat text-primary">
                                                <i class="align-middle" data-feather="activity"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <h1 class="mt-1 mb-3">Online</h1>
                                    <div class="mb-0">
                                        <span class="badge badge-success-light">
                                            <i class="mdi mdi-arrow-bottom-right"></i> Active
                                        </span>
                                        <span class="text-muted">System operational</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="dashboard-tile quick-actions">
                            <div class="card flex-fill w-100">
                                <div class="card-header">
                                    <h5 class="card-title mb-0">Quick Actions</h5>
                                </div>
                                <div class="card-body pt-2 pb-3">
                                    <div class="row">
                                        <div class="col-12 mb-3">
                                            <a href="${pageContext.request.contextPath}/users" class="btn btn-primary btn-lg w-100">
                                                <i data-feather="users" class="me-2"></i> Manage Users
                                            </a>
                                        </div>
                                        <c:if test="${sessionScope.user.role.roleName == 'Admin' || sessionScope.user.role.roleName == 'Warehouse Manager'}">
                                            <div class="col-12 mb-3">
                                                <a href="${pageContext.request.contextPath}/user/add" class="btn btn-success btn-lg w-100">
                                                    <i data-feather="user-plus" class="me-2"></i> Add New User
                                                </a>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="components/footer.jsp" />
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
</body>
</html>