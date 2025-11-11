<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Warehouse Pro | Dashboard</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Feather Icons -->
    <script src="https://unpkg.com/feather-icons"></script>
    
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/admin/css/light.css" rel="stylesheet">
</head>

<body>
    <div class="wrapper">
        <!-- Sidebar -->
        <jsp:include page="/admin/AdminSidebar.jsp" />
        <div class="main">
        <jsp:include page="/admin/navbar.jsp" />

            <!-- Page Content -->
            <main class="content">
                <div class="container-fluid p-0">
                    <!-- Page Header -->
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3">
                        <h1 class="h2 fw-bold">Warehouse Management Admin Dashboard</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                          
                        </div>
                    </div>

                    <!-- Stats Cards -->
                    <div class="row">
                        <!-- Tổng số sản phẩm -->
                        <div class="col-sm-6 col-xl-4">
                            <div class="card border-0 shadow-sm">
                                <div class="card-body d-flex align-items-center">
                                    <div class="flex-shrink-0 me-3">
                                        <span class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center" style="width:48px; height:48px;">
                                            <i data-feather="package"></i>
                                        </span>
                                    </div>
                                    <div>
                                        <h6 class="mb-1 text-muted">Total Products</h6>
                                        <h2 class="mb-0 fw-bold">${totalProducts}</h2>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Tổng số kho -->
                        <div class="col-sm-6 col-xl-4">
                            <div class="card border-0 shadow-sm">
                                <div class="card-body d-flex align-items-center">
                                    <div class="flex-shrink-0 me-3">
                                        <span class="bg-success text-white rounded-circle d-flex align-items-center justify-content-center" style="width:48px; height:48px;">
                                            <i data-feather="home"></i>
                                        </span>
                                    </div>
                                    <div>
                                        <h6 class="mb-1 text-muted">Total Warehouses</h6>
                                        <h2 class="mb-0 fw-bold">${totalWarehouses}</h2>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Tổng số người dùng -->
                        <div class="col-sm-6 col-xl-4">
                            <div class="card border-0 shadow-sm">
                                <div class="card-body d-flex align-items-center">
                                    <div class="flex-shrink-0 me-3">
                                        <span class="bg-warning text-white rounded-circle d-flex align-items-center justify-content-center" style="width:48px; height:48px;">
                                            <i data-feather="users"></i>
                                        </span>
                                    </div>
                                    <div>
                                        <h6 class="mb-1 text-muted">Total Users</h6>
                                        <h2 class="mb-0 fw-bold">${totalUsers}</h2>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Quick Action Section -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="card border-0 shadow-sm">
                                <div class="card-body">
                                    <h5 class="mb-4 fw-bold d-flex align-items-center">
                                        <i data-feather="zap" class="me-2 text-primary"></i> Quick Actions
                                    </h5>
                                    <div class="d-flex flex-column gap-3">
                                        <!-- Create Product (highlighted) -->
                                        <a href="${pageContext.request.contextPath}/admin/create-product"
                                           class="border border-primary rounded p-3 d-flex align-items-start text-decoration-none mb-1"
                                           style="background: #f8faff;">
                                            <div class="me-3 mt-1">
                                                <i data-feather="plus-circle" class="text-primary"></i>
                                            </div>
                                            <div>
                                                <div class="fw-bold text-primary">Create Product</div>
                                                <div class="text-muted small">Add a new product to the system</div>
                                            </div>
                                        </a>
                                        <!-- Create Unit -->
                                        <a href="${pageContext.request.contextPath}/admin/create-unit"
                                           class="bg-light rounded p-3 d-flex align-items-start text-decoration-none mb-1">
                                            <div class="me-3 mt-1">
                                                <i data-feather="plus-square"></i>
                                            </div>
                                            <div>
                                                <div class="fw-bold text-dark">Create Unit</div>
                                                <div class="text-muted small">Define a new unit of measurement</div>
                                            </div>
                                        </a>
                                        <!-- Add User -->
                                        <a href="${pageContext.request.contextPath}/admin/add"
                                           class="bg-light rounded p-3 d-flex align-items-start text-decoration-none mb-1">
                                            <div class="me-3 mt-1">
                                                <i data-feather="user-plus"></i>
                                            </div>
                                            <div>
                                                <div class="fw-bold text-dark">Add User</div>
                                                <div class="text-muted small">Register a new user account</div>
                                            </div>
                                        </a>
                                        <!-- Create Warehouse -->
                                        <a href="${pageContext.request.contextPath}/admin/addWarehouse"
                                           class="bg-light rounded p-3 d-flex align-items-start text-decoration-none">
                                            <div class="me-3 mt-1">
                                                <i data-feather="home"></i>
                                            </div>
                                            <div>
                                                <div class="fw-bold text-dark">Create Warehouse</div>
                                                <div class="text-muted small">Add a new warehouse location</div>
                                            </div>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
   
            <!-- Footer -->
            <footer class="footer">
                <div class="container-fluid">
                    <div class="row text-muted">
                        <div class="col-6 text-start">
                            <p class="mb-0">
                                <a href="#" class="text-muted"><strong>Warehouse Management System</strong></a> &copy;
                            </p>
                        </div>
                        <div class="col-6 text-end">
                            <ul class="list-inline">
                                <li class="list-inline-item">
                                    <a class="text-muted" href="#">Support</a>
                                </li>
                                <li class="list-inline-item">
                                    <a class="text-muted" href="#">Help Center</a>
                                </li>
                                <li class="list-inline-item">
                                    <a class="text-muted" href="#">Privacy</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </footer>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize Feather icons
            feather.replace();
            
            // Sidebar dropdown toggle
            document.querySelectorAll('[data-bs-toggle="collapse"]').forEach(function(element) {
                element.addEventListener('click', function(e) {
                    e.preventDefault();
                    
                    const target = document.querySelector(this.getAttribute('data-bs-target'));
                    const arrow = this.querySelector('.sidebar-arrow');
                    
                    if (target) {
                        // Toggle collapse
                        if (target.classList.contains('show')) {
                            target.classList.remove('show');
                            arrow.style.transform = 'rotate(0deg)';
                        } else {
                            // Close other dropdowns
                            document.querySelectorAll('.sidebar-dropdown.show').forEach(function(dropdown) {
                                if (dropdown !== target) {
                                    dropdown.classList.remove('show');
                                    const otherArrow = document.querySelector(`[data-bs-target="#${dropdown.id}"] .sidebar-arrow`);
                                    if (otherArrow) {
                                        otherArrow.style.transform = 'rotate(0deg)';
                                    }
                                }
                            });
                            
                            target.classList.add('show');
                            arrow.style.transform = 'rotate(90deg)';
                        }
                    }
                });
            });
            
            // Mobile sidebar toggle
            window.toggleSidebar = function() {
                document.getElementById('sidebar').classList.toggle('sidebar-mobile-show');
            };
            
            // Close sidebar when clicking outside on mobile
            document.addEventListener('click', function(event) {
                const sidebar = document.getElementById('sidebar');
                const toggle = document.querySelector('.sidebar-toggle');
                
                if (window.innerWidth < 992 && 
                    !sidebar.contains(event.target) && 
                    !toggle.contains(event.target) &&
                    sidebar.classList.contains('sidebar-mobile-show')) {
                    sidebar.classList.remove('sidebar-mobile-show');
                }
            });
        });
    </script>
</body>
</html>