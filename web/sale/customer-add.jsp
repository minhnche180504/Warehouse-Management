<%-- 
    Document   : addCustomer
    Created on : Jun 9, 2025, 4:24:24 PM
    Author     : nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection,java.sql.PreparedStatement,java.sql.ResultSet" %>
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
        <link rel="shortcut icon" href="img/icons/icon-48x48.png" />
        <link rel="canonical" href="forms-layouts.html" />
        <title>Add New Customer | Warehouse System</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&amp;display=swap" rel="stylesheet">
        <link class="js-stylesheet" href="css/light.css" rel="stylesheet">
        <script src="js/settings.js"></script>
    </head>
    <body data-theme="default" data-layout="fluid" data-sidebar-position="left" data-sidebar-layout="default">
        <div class="wrapper">
            <jsp:include page="/sale/SalesSidebar.jsp" />
            <div class="main">
                <jsp:include page="/sale/navbar.jsp" />
                <main class="content">
                    <div class="container-fluid p-0">
                        <%
                            String errorMessage = (String) request.getAttribute("error");
                            String successMessage = (String) request.getAttribute("success");
                            
                            if (errorMessage != null && !errorMessage.isEmpty()) {
                        %>
                        <div class="alert alert-danger alert-dismissible" role="alert">
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            <div class="alert-message">
                                <%= errorMessage %>
                            </div>
                        </div>
                        <%
                            }
                            
                            if (successMessage != null && !successMessage.isEmpty()) {
                        %>
                        <div class="alert alert-success alert-dismissible" role="alert">
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            <div class="alert-message">
                                <i class="align-middle me-1" data-feather="check-circle"></i>
                                <%= successMessage %>
                            </div>
                        </div>
                        <%
                            }
                        %>

                        <div class="row mb-3">
                            <div class="col-6">
                                <h1 class="h2 mb-3 fw-bold text-primary">Add New Customer</h1>
                            </div>
                            <div class="col-6 text-end">
                                <a href="listCustomer" class="btn btn-secondary me-2">
                                    <i class="align-middle" data-feather="arrow-left"></i> Back to List
                                </a>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-12">
                                <div class="card shadow-sm">
                                    <div class="card-header pb-0 border-bottom-0">
                                        <h5 class="card-title mb-0 fw-semibold">Customer Information</h5>
                                        <hr class="mt-2 mb-0">
                                    </div>
                                    <div class="card-body pt-3">
                                        <form action="${pageContext.request.contextPath}/sale/createCustomer" method="POST">

                                            <!-- First Row of Inputs -->
                                            <div class="row mb-3 align-items-center">
                                                <div class="col-md-6 mb-3 mb-md-0">
                                                    <label for="customerName" class="form-label fw-medium">Customer Name *</label>
                                                    <input type="text" class="form-control form-control-lg" id="customerName" name="customerName" 
                                                           value="${customerName}" required maxlength="100">
                                                </div>
                                            </div>
                                            <div class="row mb-3 align-items-center">
                                                <div class="col-md-6 mb-3 mb-md-0">
                                                    <label for="phone" class="form-label fw-medium">Phone Number *</label>
                                                    <input type="tel" class="form-control form-control-lg" id="phone" name="phone" 
                                                           value="${phone}" required pattern="[0-9]{10}">
                                                    <small class="text-muted">Phone number must start with 0 and have exactly 10 digits</small>
                                                </div>
                                            </div>

                                            <!-- Second Row of Inputs -->
                                            <div class="row mb-3 align-items-center">
                                                <div class="col-md-6 mb-3 mb-md-0">
                                                    <label for="email" class="form-label fw-medium">Email *</label>
                                                    <input type="email" class="form-control form-control-lg" id="email" name="email" 
                                                           value="${email}" required>
                                                </div>
                                            </div>

                                            <!-- Third Row of Inputs -->
                                            <div class="row mb-4">
                                                <div class="col-md-12">
                                                    <label for="address" class="form-label fw-medium">Address *</label>
                                                    <textarea class="form-control" id="address" name="address" rows="4" 
                                                              required maxlength="255">${address}</textarea>
                                                </div>
                                            </div>

                                            <!-- Submit Buttons -->
                                            <div class="row mt-4">
                                                <div class="col-12 text-end">
                                                    <button type="button" class="btn btn-secondary btn-lg me-2" onclick="window.location.href = 'listCustomer'">
                                                        Cancel
                                                    </button>
                                                    <button type="submit" class="btn btn-success btn-lg px-4">
                                                        <i class="align-middle me-1" data-feather="plus-circle"></i> Create Customer
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                <footer class="footer">
                    <div class="container-fluid">
                        <div class="row text-muted">
                            <div class="col-6 text-start">
                                <p class="mb-0">
                                    <a class="text-muted" href="#" target="_blank"><strong>Warehouse Management System</strong></a> &copy;
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
                                </ul>
                            </div>
                        </div>
                    </div>
                </footer>
            </div>
        </div>

        <script src="js/app.js"></script>
        <script>
                                                        document.addEventListener("DOMContentLoaded", function () {
                                                            // Initialize feather icons
                                                            feather.replace();

                                                            // Client-side validation
                                                            document.querySelector('form').addEventListener('submit', function (e) {
                                                                const phone = document.getElementById('phone').value;
                                                                const email = document.getElementById('email').value;
                                                                const customerName = document.getElementById('customerName').value;
                                                                const address = document.getElementById('address').value;

                                                                // Validate phone number
                                                                if (!phone.match(/^0\d{9}$/)) {
                                                                    e.preventDefault();
                                                                    alert('Phone number must start with 0 and have exactly 10 digits');
                                                                    return;
                                                                }

                                                                // Validate email
                                                                if (!email.match(/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)) {
                                                                    e.preventDefault();
                                                                    alert('Please enter a valid email address');
                                                                    return;
                                                                }

                                                                // Validate customer name
                                                                if (customerName.trim().length === 0) {
                                                                    e.preventDefault();
                                                                    alert('Customer name is required');
                                                                    return;
                                                                }

                                                                // Validate address
                                                                if (address.trim().length === 0) {
                                                                    e.preventDefault();
                                                                    alert('Address is required');
                                                                    return;
                                                                }
                                                            });
                                                        });
        </script>
    </body>
</html> 